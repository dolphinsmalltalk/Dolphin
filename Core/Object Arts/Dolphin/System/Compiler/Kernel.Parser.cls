"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SmalltalkParser
	instanceVariableNames: 'scanner currentToken nextToken errorBlock methodNode st80Syntax comments methodClass source'
	classVariableNames: 'AllowEmptyStatements'
	imports: #(#{ExtCallArgTypes} #{SmalltalkParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
SmalltalkParser guid: (GUID fromString: '{f15a9f2f-3a15-47cd-8ef9-0534b6f91c17}')!
SmalltalkParser comment: 'Instance Variables:
	scanner		<SmalltalkScanner> performing lexical analysis over the source text
	currentToken	<StToken>
	nextToken	<StToken>
	emptyStatements	<boolean>
	errorBlock		<dyadicValuable> evaluated when a syntax error is detected.
	methodNode	<StMethodNode>
	st80Syntax	<boolean>. If true then certain St80 syntax which is not valid ANSI are permitted, e.g. [:a ] is a valid block.
	comments		nil | <OrderedCollection> of <Interval>. nil until a comment is encountered for the node being parsed, otherwise a sequence of text ranges of comments parsed so far for that node.
	methodClass	<Class>|<Metaclass>. The class for which the expression/method is being parsed.
	source		<readableString>. Source text of the expression/method.

Class Variables:
	MaxPrimIndex		<integer>. Maximum primitive number.
	MaxVfn			<integer>. Maximum virtual function number.

Pools:
	ExtCallArgTypes 		Maps standard external type names, as recognised by the old Dolphin Compiler to the parameter types to be used for passing by value and by reference.
	SmalltalkParseErrorCodes	Maps compiler error/warning names to their corresponding integer code'!
!SmalltalkParser categoriesForClass!System-Compiler! !
!SmalltalkParser methodsFor!

addCommentsTo: aNode 
	comments isNil ifTrue: [^self].
	aNode addComments: comments.
	comments := nil!

assignmentNodeClass
	^StAssignmentNode!

atEnd
	^currentToken isEof!

blockNodeClass
	^StBlockNode!

braceArrayNodeClass
	^StBraceArrayNode!

canHaveStatementsAfterReturn
	#rbFix. "Dolphin can have statements after the return"
	^true!

cascadeNodeClass
	^StCascadeNode!

errorBlock: aBlock
	"Set the errorBlock to be evaluated when a syntax error is detected in the input stream.
	Note difference from RBParser - the Dolphin parser prefers a monadic error block that it
	expects to pass an appropriately constructed exception containing all details of the error.
	If, however, a dyadic block is provided, this is wrapped with a monadic block which cracks
	open the exception for the value and position."

	errorBlock := aBlock
				ifNotNil: 
					[aBlock argumentCount == 2
						ifTrue: 
							[
							[:ex |
							aBlock value: ex description value: ex position.
							ex signal]]
						ifFalse: [aBlock]]!

errorPosition
	^currentToken start!

externalReferenceTypeFor: anInteger 
	^(ExternalDescriptor referenceTypeFor: anInteger) ?? ExtCallArgLPPVOID!

initialize
	"If true then certain St80 syntax which is not valid ANSI are permitted, e.g. [:a ] is a valid block"
	st80Syntax := false!

initializeParserWith: aString 
	source := aString.
	self scanner: (self scannerClass on: (ReadStream on: self source) errorHandler: self)!

line
	"Anwswer one-based <integer> line number of the receiver's current position in the 
	source text."

	^scanner line!

literalArrayNodeClass
	^StLiteralArrayNode!

literalValueNodeClass
	^StLiteralValueNode!

lookupExternalStructType: anStIdentifierToken
	| structClass |
	structClass := anStIdentifierToken value asQualifiedReference bindingOrNil
				ifNil: 
					[self parserError: CErrUndefinedClass range: anStIdentifierToken sourceInterval.
					"Error ignored, attempt to recover..."
					DWORD]
				ifNotNil: [:var | var value].
	((structClass isKindOf: Class) not or: [structClass isPointers and: [structClass instSize < 1]])
		ifTrue: 
			[self parserError: CErrInvalidStructArg range: anStIdentifierToken sourceInterval.
			"Error ignored, attempt to recover..."
			structClass := DWORD].
	^structClass!

messageNodeClass
	^StMessageNode!

methodClass: aClass 
	methodClass := aClass!

methodNodeClass
	^StMethodNode!

nextToken
	^nextToken ifNil: [nextToken := scanner next]!

optimizedNodeClass
	^StOptimizedNode!

parameterNodeClass
	^StParameterNode!

parseAssignment
	"Need one token lookahead to see if we have a ':='. This method could 
	make it possible to assign the literals true, false and nil."

	| node position assignment |
	(currentToken isIdentifier and: [self nextToken isAssignment]) ifFalse: [^self parseCascadeMessage].
	node := self parseVariableNode: self variableNodeClass.
	position := currentToken start.
	self step.
	assignment := self assignmentNodeClass
				variable: node
				value: self parseAssignment
				position: position.
	node isConstantNode
		ifTrue: 
			[self
				parserError: CErrAssignConstant
				range: assignment sourceInterval
				extra: node name].
	^assignment!

parseBinaryMessage
	| node |
	node := self parseUnaryMessage.
	
	[currentToken isLiteralToken ifTrue: [self patchNegativeLiteral].
	currentToken isBinary] 
			whileTrue: [node := self parseBinaryMessageWith: node].
	^node!

parseBinaryMessageWith: aNode
	| binaryToken |
	binaryToken := currentToken.
	self step.
	^self messageNodeClass
		receiver: aNode
		selectorParts: {binaryToken}
		arguments: {self parseUnaryMessage}!

parseBinaryPattern
	| binaryToken node arg |
	binaryToken := currentToken.
	self step.
	arg := self parseMethodParameter.
	node := self methodNodeClass selectorParts: {binaryToken} arguments: {arg}.
	node addComments: arg comments.
	arg comments: nil.
	^node!

parseBlock
	| position node |
	position := currentToken start.
	self step.
	node := self blockNodeClass new.
	"Set start position before attempting to parse the block args so can use for error reporting if necessary"
	node left: position.
	self parseBlockArgsInto: node.
	node body: (self parseStatementsOf: node).
	(currentToken isSpecial: $])
		ifFalse: 
			[| blockEnd |
			blockEnd := node body sourceInterval stop.
			blockEnd = 0 ifTrue: [blockEnd := node bar ?? position].
			self parserError: CErrBlockNotClosed range: (position to: blockEnd).
			"Error ignored, attempt to recover..."
			node right: blockEnd.
			^node].
	node right: currentToken start.
	self step.
	^node!

parseBlockArgsInto: node
	| args |
	(currentToken isSpecial: $:)
		ifFalse: 
			[node arguments: #().
			^node].
	args := OrderedCollection new: 2.
	
	[| arg |
	self step.	":"
	arg := self parseBlockParameter.
	self validateArg: arg args: args.
	args addLast: arg.
	currentToken isSpecial: $:]
			whileTrue.
	currentToken isBinary
		ifTrue: 
			[node bar: currentToken start.
			currentToken value == #|
				ifTrue: [self step]
				ifFalse: 
					[currentToken value == #'||'
						ifTrue: 
							["Hack the current token to be the start of temps bar"
							currentToken
								value: #|;
								start: currentToken start + 1]
						ifFalse: 
							[self parserError: CErrBlockArgListNotClosed range: (node start to: args last sourceInterval stop)]]]
		ifFalse: 
			["St-80 allows, for example, [:a] as a valid block, ANSI requires the arg list termination bar, i.e. [:a|]"
			(st80Syntax and: [currentToken isSpecial: $]])
				ifFalse: 
					["Error ignored, no recovery needed"
					self parserError: CErrBlockArgListNotClosed range: (node start to: args last sourceInterval stop)]].
	node arguments: args.
	^node!

parseBlockParameter
	^self parseVariableNode: self parameterNodeClass!

parseBraceArray
	| start node |
	start := currentToken start.
	self step.
	node := self braceArrayNodeClass new.
	node left: start.
	self parseStatementList: node.
	(currentToken isSpecial: $})
		ifFalse: 
			[self parserError: CErrBraceNotClosed range: (start to: self errorPosition - 1)
			"Error ignored, no recovery needed as reached EOF looking for a closing brace"].
	node right: currentToken stop.
	self step.
	^node!

parseCascadedMessageFor: aStVariableNode 
	currentToken isIdentifier ifTrue: [^self parseUnaryMessageWith: aStVariableNode].
	currentToken isKeyword ifTrue: [^self parseKeywordMessageWith: aStVariableNode].
	currentToken isLiteralToken ifTrue: [self patchNegativeLiteral].
	currentToken isBinary 
		ifFalse: 
			[self parserError: CErrExpectMessage
			"Error ignored, how should we recover?".
			^nil].
	^self parseBinaryMessageWith: aStVariableNode!

parseCascadeMessage
	| node |
	node := self parseKeywordMessage.
	#rbFix.	"Add outer loop to parse Dolphin's more flexible cascade syntax"
	
	[currentToken isKeyword ifTrue: [node := self parseKeywordMessageWith: node].
	currentToken isBinary ifTrue: [node := self parseBinaryMessageWith: node].
	currentToken isIdentifier ifTrue: [node := self parseUnaryMessageWith: node].
	(currentToken isSpecial: $;) and: [node isMessage]] 
			whileTrue: 
				[| receiver messages semicolons |
				receiver := node receiver.
				messages := OrderedCollection new: 3.
				messages addLast: node.
				semicolons := OrderedCollection new: 3.
				[currentToken isSpecial: $;] whileTrue: 
						[semicolons addLast: currentToken start.
						self step.
						(self parseCascadedMessageFor: receiver) ifNotNil: [:msg | messages addLast: msg]].
				node := self cascadeNodeClass messages: messages semicolons: semicolons].
	^node!

parseExpression: aString
	| body method |
	method := self methodNodeClass
				selectorParts: {scanner identifierTokenClass
							start: nil
							comments: nil
							value: 'doIt'}
				arguments: #().
	method source: aString.
	body := self parseStatementsOf: method.
	method body: body.
	self atEnd
		ifFalse: [self parserError: CErrNonsenseAtExprEnd range: (self errorPosition to: self source size)].
	^body!

parseExtendedTags: startInteger
	currentToken isIdentifier
		ifTrue: 
			[| selector |
			selector := currentToken value.
			selector = 'virtual'
				ifTrue: 
					[self step.
					^self parseExternalCall: startInteger isVirtual: true].
			selector = 'overlap'
				ifTrue: 
					[self step.
					^self parseOverlappedCall: startInteger].
			selector = 'mutable'
				ifTrue: 
					[self step.
					^(StAnnotationNode selector: selector)
						start: startInteger;
						yourself]].
	self parserError: CErrBadPrimCallType.
	"Attempt to recover..."
	self step.
	^self parseExternalCall: startInteger isVirtual: false!

parseExternalArgType
	| valueType indirections typeToken structClass stop start |
	start := currentToken sourceInterval start.
	currentToken isIdentifier 
		ifFalse: 
			[self parserError: CErrExpectExtType range: currentToken sourceInterval.
			"Error ignored, attempt to recover by creating a dummy arg type node and
			stepping over the offending token..."
			self step.
			^(StExternalArgTypeNode new)
				start: currentToken start;
				stop: currentToken stop;
				typeOrdinal: ExtCallArgLPVOID;
				indirections: 0;
				yourself].
	structClass := nil.
	valueType := ExternalDescriptor typeFromName: currentToken value ifAbsent: [ExtCallArgSTRUCT].
	structClass := valueType == ExtCallArgSTRUCT 
				ifTrue: [self lookupExternalStructType: currentToken]
				ifFalse: [nil].
	typeToken := currentToken.
	self step.
	indirections := self parseExternalArgTypeQualifier.
	indirections > 0 
		ifTrue: 
			[| refType |
			refType := valueType.
			indirections > 1 
				ifTrue: 
					[valueType == ExtCallArgSTRUCT 
						ifTrue: [structClass isIndirection ifTrue: [refType := ExtCallArgLPPVOID]]
						ifFalse: [refType := self externalReferenceTypeFor: valueType]].
			stop := currentToken stop.
			refType == ExtCallArgLPPVOID 
				ifTrue: 
					[self 
						parserError: CErrNotIndirectable
						range: (start to: stop)
						extra: typeToken value.
					"Error ignored, to recover just ignore the indirection..."
					indirections := 0].
			"Step over the qualifier now we know it is valid"
			self step]
		ifFalse: [stop := typeToken stop].
	^(StExternalArgTypeNode new)
		start: typeToken start;
		stop: stop;
		typeOrdinal: valueType;
		indirections: indirections;
		structClass: structClass;
		yourself!

parseExternalArgTypeQualifier
	| qualifier |
	currentToken isBinary ifFalse: [^0].
	qualifier := currentToken value.
	qualifier == #> ifTrue: [^0].
	(qualifier == #*> or: [qualifier == #**>]) ifTrue: [qualifier := self patchExternalDescriptorClose].
	qualifier == #* ifTrue: [^1].
	qualifier == #** ifTrue: [^2].
	self parserError: CErrBadExtTypeQualifier.
	"Error ignored, attempt to recover by stepping over the bad qualifier and defaulting to no indirection..."
	self step.
	^0!

parseExternalCall: startInteger isVirtual: aBoolean
	| vfnIndex node |
	node := StExternalCallNode new.
	node
		start: startInteger;
		callingConvention: self parseExternalCallingConvention;
		returnType: self parseExternalArgType.
	aBoolean
		ifTrue: 
			[node isVirtual: true.
			(currentToken isLiteralToken not or: [(vfnIndex := currentToken value) isInteger not])
				ifTrue: 
					[self parserError: CErrExpectVfn.
					"Error ignored, attempt to recover."
					vfnIndex := 1].
			(vfnIndex between: 1 and: VMConstants.MaxVirtualFunction)
				ifFalse: 
					[self parserError: CErrBadVfn
					"Error ignored, continue"].
			node nameOrOrdinal: vfnIndex.
			self step]
		ifFalse: [node nameOrOrdinal: self parseExternalCallName].
	self parseExternalCallArgs: node.
	^node!

parseExternalCallArgList
	| args |
	args := OrderedCollection new.
	[self atEnd or: [currentToken isBinary: #>]] whileFalse: 
			[| arg |
			arg := self parseExternalArgType.
			(arg typeOrdinal == ExtCallArgVOID and: [arg indirections == 0]) 
				ifTrue: 
					[self parserError: CErrArgTypeCannotBeVoid range: arg sourceInterval
					"Error ignored, no recovery required since this is a semantic rather than syntax error"].
			args addLast: arg].
	^args!

parseExternalCallArgs: anStExternalCallNode 
	| types got expected start |
	start := currentToken start.
	types := self parseExternalCallArgList.
	anStExternalCallNode argumentTypes: types.
	got := types size.
	expected := methodNode argumentCount.
	got < expected 
		ifTrue: 
			[self parserError: CErrInsufficientArgTypes range: (start to: self errorPosition - 1)
			"Error ignored, but no recovery needed as the decl is syntactically correct,it just defines too many types."].
	got > expected 
		ifTrue: 
			[self parserError: CErrTooManyArgTypes range: (start to: types last sourceInterval stop)
			"Error ignored, but no recovery needed as the decl is syntactically correct,it just defines too many types."].
	^types!

parseExternalCallingConvention
	currentToken isKeyword 
		ifTrue: 
			[| answer |
			answer := ExternalDescriptor conventionFromName: currentToken value.
			answer < 0 
				ifTrue: 
					[self parserError: CErrBadPrimCallType.
					"Error ignored, attempt to recover by using a sensible default..."
					1].
			answer > 1 
				ifTrue: 
					[self parserError: CErrUnsupportedCallConv.
					"Error ignored, attempt to recover by using a sensible default.."
					answer := 0].
			self step.
			^answer].
	self parserError: CErrBadPrimCallType!

parseExternalCallName
	| nameOrOrdinal |
	currentToken isLiteralToken 
		ifTrue: 
			[| token |
			token := currentToken value.
			(token isString or: [token isInteger and: [token >= 0]]) ifTrue: [nameOrOrdinal := token]]
		ifFalse: [currentToken isIdentifier ifTrue: [nameOrOrdinal := currentToken value]].
	nameOrOrdinal isNil 
		ifTrue: 
			[self parserError: CErrExpectFnName.
			"Error ignored, attempt to recover..."
			nameOrOrdinal := '']
		ifFalse: [self step].
	^nameOrOrdinal!

parseKeywordMessage
	^self parseKeywordMessageWith: self parseBinaryMessage!

parseKeywordMessageWith: node
	| args keywords |
	currentToken isKeyword
		ifFalse: 
			[node isSuperVariable ifTrue: [self parserError: CErrExpectMessage].
			^node].
	args := OrderedCollection new: 3.
	keywords := OrderedCollection new: 3.
	
	[keywords addLast: currentToken.
	self step.
	args addLast: self parseBinaryMessage.
	currentToken isKeyword]
			whileTrue.
	^self messageNodeClass
		receiver: node
		selectorParts: keywords
		arguments: args!

parseKeywordPattern
	"...It is erroneous if the same identifier is used for more than one <method argument> in an
	individual <method definition>. It is erroneous if any of the reserved identifiers ('nil',
	'true', 'false', 'self', and 'super') is used as a <method argument>. "

	| keywords args node |
	keywords := OrderedCollection new: 2.
	args := OrderedCollection new: 2.
	[currentToken isKeyword] whileTrue: 
			[| arg |
			keywords addLast: currentToken.
			self step.
			arg := self parseMethodParameter.
			(self validateArg: arg args: args) ifTrue: [args addLast: arg]].
	node := self methodNodeClass selectorParts: keywords arguments: args.
	"Be resilient to the absence of arguments"
	args isEmpty
		ifFalse: 
			[node addComments: args last comments.
			args last comments: nil].
	^node!

parseLiteralArray
	| stream start stop |
	start := currentToken start.
	stream := WriteStream on: (Array new: 30).
	self step.
	[self atEnd or: [currentToken isSpecial: $)]]
		whileFalse: [stream nextPut: self parseLiteralArrayObject].
	(currentToken isSpecial: $))
		ifFalse: 
			[self parserError: CErrArrayNotClosed range: (start to: self errorPosition - 1)
			"Error ignored, no recovery needed as at EOF"].
	stop := currentToken stop.
	self step.
	^self literalArrayNodeClass
		startPosition: start
		contents: stream contents
		stopPosition: stop
		isByteArray: false!

parseLiteralArrayObject
	currentToken isSpecial 
		ifTrue: 
			[currentToken value == $( ifTrue: [^self parseLiteralArray].
			currentToken value == $[ ifTrue: [^self parseLiteralByteArray]].
	currentToken isLiteralArrayToken 
		ifTrue: 
			[^currentToken isForByteArray 
				ifTrue: [self parseLiteralByteArray]
				ifFalse: [self parseLiteralArray]].
	currentToken isOptimized ifTrue: [^self parseOptimizedExpression].
	currentToken isQualifiedReference ifTrue: [^self parseQualifiedReference].
	currentToken isLiteralToken ifFalse: [self patchLiteralArrayToken].
	^self parsePrimitiveLiteral!

parseLiteralByteArray
	| stream start stop |
	start := currentToken start.
	stream := WriteStream on: (Array new: 30).
	self step.
	[self atEnd or: [currentToken isSpecial: $]]]
		whileFalse: [stream nextPut: self parseLiteralByteArrayObject].
	(currentToken isSpecial: $])
		ifTrue: [stop := currentToken stop]
		ifFalse: 
			[stop := stream isEmpty ifTrue: [start + 1] ifFalse: [stream contents last stop].
			self parserError: CErrByteArrayNotClosed range: (start to: stop)
			"Error ignored, but at EOF so no recovery needed..."].
	self step.
	^self literalArrayNodeClass
		startPosition: start
		contents: stream contents
		stopPosition: stop
		isByteArray: true!

parseLiteralByteArrayObject
	(currentToken isLiteralToken and: 
			[| value |
			value := currentToken value.
			value isInteger and: [value between: 0 and: 255]])
		ifFalse: 
			[| token |
			self parserError: CErrBadValueInByteArray.
			"Error ignored, attempt to recover"
			token := scanner numberTokenClass
						start: currentToken start
						comments: nil
						value: 0
						stop: currentToken stop.
			self step.
			^self literalValueNodeClass literalToken: token].
	^self parsePrimitiveLiteral!

parseMessagePattern
	currentToken isLiteralToken ifTrue: [self patchLiteralMessage].
	^currentToken isIdentifier
		ifTrue: [self parseUnaryPattern]
		ifFalse: 
			[currentToken isKeyword
				ifTrue: [self parseKeywordPattern]
				ifFalse: 
					[currentToken isBinary
						ifTrue: [self parseBinaryPattern]
						ifFalse: 
							[self parserError: CErrBadSelector.
							"Error ignored, attempt to recover by
							constructing a dummy pattern and method node..."
							self methodNodeClass
								selectorParts: {scanner identifierTokenClass
											start: 1
											comments: nil
											value: ''}
								arguments: #()]]]!

parseMethod
	methodNode := self parseMessagePattern.
	self parseTags.
	self addCommentsTo: methodNode.
	methodNode body: (self parseStatementsOf: methodNode).
	"	methodNode tags: tags."
	^methodNode!

parseMethod: aString
	| node |
	node := self parseMethod.
	self atEnd
		ifFalse: 
			[self parserError: CErrNonsenseAtMethodEnd range: (self errorPosition to: aString size)
			"Error ignored, but at EOF so no recovery needed."].
	^node
		source: aString;
		methodClass: methodClass;
		yourself!

parseMethod: aString in: aClass errorBlock: monadicBlock 
	self errorBlock: monadicBlock.
	methodClass := aClass.
	self initializeParserWith: aString.
	^self parseMethod: aString!

parseMethodParameter
	^self parseVariableNode: self parameterNodeClass!

parseNumberLiteral
	| token |
	token := currentToken.
	self step.
	^self literalValueNodeClass literalToken: token!

parseOptimizedExpression
	| position node body isClosed |
	position := currentToken start.
	self step.
	node := self optimizedNodeClass new.
	body := self parseStatementsOf: node.
	isClosed := currentToken isSpecial: $).
	node
		left: position
		body: body
		right: (isClosed ifTrue: [currentToken start] ifFalse: [scanner previousStepPosition]).
	isClosed ifFalse: [self parserError: CErrStaticExprNotClosed range: node sourceInterval].
	node source: source.
	self step.
	^node!

parseOverlappedCall: startInteger
	| node |
	node := self parseExternalCall: startInteger isVirtual: false.
	node isOverlapped: true.
	^node!

parseParenthesizedExpression
	| leftParen node rightParen |
	leftParen := currentToken start.
	self step.
	node := self parseAssignment.
	(currentToken isSpecial: $)) 
		ifTrue: 
			[rightParen := currentToken start.
			self step]
		ifFalse: 
			[rightParen := self errorPosition - 1.
			self parserError: CErrParenNotClosed range: (leftParen to: rightParen)
			"Error ignored, attempt to recover...."].
	node addParenthesis: (leftParen to: rightParen).
	^node!

parsePrimitiveIdentifier: anStVariableNodeClass
	| token node |
	token := currentToken.
	self step.
	node := anStVariableNodeClass identifierToken: token.
	self addCommentsTo: node.
	^node!

parsePrimitiveLiteral
	^currentToken isNumberLiteralToken
		ifTrue: [self parseNumberLiteral]
		ifFalse: [self parsePrimitiveValueLiteral]!

parsePrimitiveObject
	| token node |
	currentToken isIdentifier ifTrue: [^self parsePrimitiveIdentifier: self variableNodeClass].
	(currentToken isLiteralToken and: [currentToken isMultiKeyword not])
		ifTrue: [^self parsePrimitiveLiteral].
	currentToken isLiteralArrayToken
		ifTrue: 
			[^currentToken isForByteArray ifTrue: [self parseLiteralByteArray] ifFalse: [self parseLiteralArray]].
	currentToken isSpecial
		ifTrue: 
			[| char |
			char := currentToken value.
			char == $[ ifTrue: [^self parseBlock].
			char == $( ifTrue: [^self parseParenthesizedExpression].
			char == ${ ifTrue: [^self parseBraceArray]].
	currentToken isOptimized ifTrue: [^self parseOptimizedExpression].
	currentToken isQualifiedReference ifTrue: [^self parseQualifiedReference].
	self parserError: CErrInvalExprStart.
	"Attempt to recover by treating it as a literal value, the AST will be invalid of course"
	token := scanner literalTokenClass
				start: currentToken start
				comments: nil
				value: (self source copyFrom: currentToken start to: currentToken stop)
				stop: currentToken stop.
	self step.
	node := self literalValueNodeClass literalToken: token.
	self addCommentsTo: node.
	^node!

parsePrimitiveValueLiteral
	| token |
	token := currentToken.
	self step.
	^self literalValueNodeClass literalToken: token!

parseQualifiedReference
	| start identifier stop meta |
	start := currentToken start.
	self step.
	currentToken isIdentifier
		ifTrue: 
			[identifier := currentToken.
			self step]
		ifFalse: 
			[identifier := scanner identifierTokenClass
						start: start
						comments: nil
						value: ''.
			self parserError: CErrExpectVariable.
			"Attempt to recover - Skip over any invalid identifier if the next token is the closing brace"
			((currentToken isSpecial: $}) not and: [self nextToken isSpecial: $}]) ifTrue: [self step]].
	meta := currentToken isIdentifier
				and: [currentToken value = 'class' and: 
							[self step.
							true]].
	stop := currentToken stop.
	(currentToken isSpecial: $})
		ifTrue: [self step]
		ifFalse: [self parserError: CErrQualifiedRefNotClosed range: (start to: identifier stop)].
	^self qualifiedReferenceNodeClass
		pathString: identifier value
		meta: meta
		start: start
		stop: stop!

parserError: anInteger
	"Raise a <SmalltalkParseError> with the specified <integer> error code and associated arguments
	(which are used to when formatting the error message)."

	self parserError: anInteger range: currentToken sourceInterval!

parserError: anInteger range: anInterval 
	"Private - Raise a <SmalltalkParseError> with the specified <integer> error code and associated arguments
	(which are used to when formatting the error message)."

	^self 
		parserError: anInteger
		range: anInterval
		extras: #()!

parserError: anInteger range: anInterval extra: anObject
	^self
		parserError: anInteger
		range: anInterval
		extras: {anObject}!

parserError: anInteger range: anInterval extras: anArray 
	^self 
		reportError: anInteger
		at: self errorPosition
		line: self line
		range: anInterval
		extras: anArray!

parseStatementList: sequenceNode
	| statements end periods node firstReturn |
	end := false.
	statements := OrderedCollection new.
	periods := OrderedCollection new.
	self addCommentsTo: sequenceNode.
	AllowEmptyStatements
		ifTrue: 
			[[currentToken isSpecial: $.] whileTrue: 
					[periods addLast: currentToken start.
					self step]].
	[self atEnd or: [currentToken isSpecial and: ['])}' identityIncludes: currentToken value]]]
		whileFalse: 
			[end
				ifTrue: 
					[self parserError: CErrUnterminatedStatement range: node sourceInterval.
					"Attempt to recover..,"
					end := false].
			(currentToken isSpecial: $^)
				ifTrue: 
					[| returnPosition |
					returnPosition := currentToken start.
					self step.
					node := self returnNodeClass return: returnPosition value: self parseAssignment.
					statements addLast: node.
					firstReturn ifNil: [firstReturn := statements size].
					end := self canHaveStatementsAfterReturn not]
				ifFalse: 
					[node := self parseAssignment.
					statements addLast: node].
			(currentToken isSpecial: $.)
				ifTrue: 
					[periods addLast: currentToken start.
					self step.
					self addCommentsTo: node]
				ifFalse: 
					["An unterminated statement can only occur at the end of a statement list"
					end := true].
			AllowEmptyStatements
				ifTrue: 
					[[currentToken isSpecial: $.] whileTrue: 
							[periods addLast: currentToken start.
							self step]]].
	(firstReturn notNil and: [firstReturn < statements size])
		ifTrue: 
			[self parserError: CWarnUnreachable
				range: ((statements at: firstReturn + 1) start to: statements last stop)].
	statements notEmpty ifTrue: [self addCommentsTo: statements last].
	sequenceNode
		statements: statements;
		periods: periods.
	^sequenceNode!

parseStatementsOf: aNode
	| temps leftBar rightBar |
	temps := #().
	leftBar := rightBar := nil.
	currentToken isBinary
		ifTrue: 
			[currentToken value == #|
				ifTrue: 
					[leftBar := currentToken start.
					self step.
					temps := self parseTempsOf: aNode.
					(currentToken isBinary: #|)
						ifTrue: 
							[rightBar := currentToken start.
							self step]
						ifFalse: 
							[self parserError: CErrTempListNotClosed range: (leftBar to: self errorPosition - 1).
							"If this error is ignored, we can recover
							but it is possible that some of the first
							statement has been treated as temporary
							declarations..."
							rightBar := self errorPosition - 1]]
				ifFalse: 
					[currentToken value == #'||'
						ifTrue: 
							[rightBar := (leftBar := currentToken start) + 1.
							self step]]].
	^self parseStatementList: (self sequenceNodeClass
				leftBar: leftBar
				temporaries: temps
				rightBar: rightBar)!

parseTag: startInteger
	^currentToken isKeyword
		ifTrue: 
			[currentToken value = 'primitive:'
				ifTrue: 
					[| primitiveIndex primitiveNode |
					self step.
					(currentToken isLiteralToken not or: [currentToken value isInteger not])
						ifTrue: 
							[self parserError: CErrExpectPrimIdx.
							"Error ignored, attempt to recover, skip the offending token unless it is the close tag and return a dummy primitive node..."
							(currentToken isBinary: #>) ifFalse: [self step].
							^(StPrimitiveNode primitiveIndex: 0)
								start: startInteger;
								yourself].
					primitiveIndex := currentToken value.
					(primitiveIndex between: 1 and: VMConstants.MaxPrimitive)
						ifFalse: [self parserError: CErrBadPrimIdx].
					self step.
					primitiveNode := (StPrimitiveNode primitiveIndex: primitiveIndex)
								start: startInteger;
								yourself.
					(currentToken isKeyword and: [currentToken value = 'error:'])
						ifTrue: 
							[self step.
							primitiveNode errorTemp: self parseTempDecl].
					primitiveNode]
				ifFalse: [self parseExternalCall: startInteger isVirtual: false]]
		ifFalse: [self parseExtendedTags: startInteger]!

parseTags
	| tag start |
	(currentToken isBinary: #<) ifFalse: [^self].
	start := currentToken start.
	self step.
	tag := self parseTag: start.
	methodNode tag: tag.
	(currentToken isBinary: #>)
		ifFalse: 
			[self parserError: CErrExpectCloseTag.
			"Error ignored, attempt to recover..."
			tag stop: currentToken start - 1.
			^self].
	tag stop: currentToken start.
	self step!

parseTempDecl
	^self parseVariableNode: self tempDeclClass!

parseTempsOf: aNode
	| temps |
	currentToken isIdentifier ifFalse: [^#()].
	temps := OrderedCollection new: 2.
	
	[| temp |
	temp := self parseTempDecl.
	(self
		validateTemp: temp
		of: aNode
		temps: temps) ifTrue: [temps addLast: temp].
	currentToken isIdentifier]
			whileTrue.
	^temps!

parseUnaryMessage
	| node |
	node := self parsePrimitiveObject.
	self addCommentsTo: node.
	
	[currentToken isLiteralToken ifTrue: [self patchLiteralMessage].
	currentToken isIdentifier] 
			whileTrue: [node := self parseUnaryMessageWith: node].
	self addCommentsTo: node.
	^node!

parseUnaryMessageWith: aNode
	| selector |
	selector := currentToken.
	self step.
	^self messageNodeClass
		receiver: aNode
		selectorParts: {selector}
		arguments: #()!

parseUnaryPattern
	| selector |
	selector := currentToken.
	self step.
	^self methodNodeClass selectorParts: {selector} arguments: #()!

parseVariableNode: anStVariableNodeClass
	| token node |
	currentToken isIdentifier ifTrue: [^self parsePrimitiveIdentifier: anStVariableNodeClass].
	self parserError: CErrExpectVariable.
	"Error ignored, attempt to recover..."
	token := scanner identifierTokenClass
				start: currentToken start
				comments: nil
				value: (self source copyFrom: currentToken start to: currentToken stop).
	self step.
	node := anStVariableNodeClass identifierToken: token.
	self addCommentsTo: node.
	^node!

patchExternalDescriptorClose
	"Hack needed because scanner treats trailing *> and **> binary selectors rather than two tokens"

	| qualifier |
	self assert: [nextToken isNil].
	qualifier := currentToken value.
	qualifier := (qualifier copyFrom: 1 to: qualifier size - 1) asSymbol.
	nextToken := currentToken.
	currentToken := StBinarySelectorToken
				start: nextToken start
				comments: nil
				value: qualifier.
	nextToken value: #>.
	nextToken start: nextToken start + qualifier size.
	^qualifier!

patchLiteralArrayToken
	| value |
	value := (currentToken isIdentifier or: [currentToken isBinary or: [currentToken isKeyword]])
				ifTrue: [currentToken value]
				ifFalse: 
					[self parserError: CErrBadTokenInArray.
					"Error ignored, attempt to recover..."
					self source copyFrom: currentToken start to: currentToken stop].
	currentToken := scanner literalTokenClass
				start: currentToken start
				comments: nil
				value: value asSymbol
				stop: currentToken stop!

patchLiteralMessage
	| value |
	value := currentToken value.
	value == true
		ifTrue: 
			[^currentToken := StIdentifierToken
						start: currentToken start
						comments: nil
						value: 'true'].
	value == false
		ifTrue: 
			[^currentToken := StIdentifierToken
						start: currentToken start
						comments: nil
						value: 'false'].
	value == nil
		ifTrue: 
			[^currentToken := StIdentifierToken
						start: currentToken start
						comments: nil
						value: 'nil']!

patchNegativeLiteral
	"Private - Handle the special negative number case for binary message sends."

	| intValue |
	(currentToken value isKindOf: Number) ifFalse: [^self].
	intValue := currentToken value.
	intValue <= 0 ifFalse: [^self].
	intValue == 0
		ifTrue: 
			[(self source notNil
				and: [self source notEmpty and: [(self source at: (currentToken start min: self source size)) == $-]])
					ifFalse: [^self]].
	nextToken := currentToken.
	currentToken := StBinarySelectorToken
				start: nextToken start
				comments: nil
				value: #-.
	nextToken forgetNegative!

qualifiedReferenceNodeClass
	^StQualifiedReferenceNode!

reportError: anInteger at: posInteger line: lineInteger range: anInterval extras: anArray
	| err |
	err := self class notificationClass
				code: anInteger
				in: source
				for: methodClass
				selector: (methodNode ifNotNil: [:m | m selector])
				position: posInteger
				line: lineInteger
				range: anInterval
				extras: anArray.
	"Warnings are not passed to the error block"
	(err severityClass == Error and: [errorBlock notNil]) ifTrue: [errorBlock value: err].
	"If the error block returns, then the exception is signalled"
	^err signal!

returnNodeClass
	^StReturnNode!

scanner: aScanner
	scanner := aScanner.
	self step!

scannerClass
	^SmalltalkScanner!

sequenceNodeClass
	^StSequenceNode!

source
	^ source!

step
	(currentToken notNil and: [currentToken comments notNil]) 
		ifTrue: 
			[comments isNil 
				ifTrue: [comments := currentToken comments copy]
				ifFalse: [comments addAll: currentToken comments]].
	nextToken notNil 
		ifTrue: 
			[currentToken := nextToken.
			nextToken := nil]
		ifFalse: [currentToken := scanner next]!

tempDeclClass
	^StTempDeclNode!

validateArg: aVariableNode args: anOrderedCollection
	"...It is erroneous if the same identifier is used as a <method argument> of a <method
	definition> and also appears in the method's <temporary variable list>...It is erroneous if
	the same identifier appears more than once in a single method definition's <temporary
	variable list>. It is erroneous for any one of the reserved identifiers ('nil', 'true',
	'false', 'self' and 'super') to appear in a <temporary variable list>."

	(anOrderedCollection includes: aVariableNode)
		ifTrue: [self parserError: CErrDuplicateArgName range: aVariableNode sourceInterval]
		ifFalse: 
			[aVariableNode isSpecialVariable
				ifTrue: [self parserError: CErrRedefiningPseudoVar range: aVariableNode sourceInterval]
				ifFalse: [^true]].
	^false!

validateTemp: aVariableNode of: aNode temps: anOrderedCollection
	"...It is erroneous if the same identifier is used as a <method argument> of a <method
	definition> and also appears in the method's <temporary variable list>...It is erroneous if
	the same identifier appears more than once in a single method definition's <temporary
	variable list>. It is erroneous for any one of the reserved identifiers ('nil', 'true',
	'false', 'self' and 'super') to appear in a <temporary variable list>."

	(anOrderedCollection includes: aVariableNode)
		ifTrue: [self parserError: CErrDuplicateTempName range: aVariableNode sourceInterval]
		ifFalse: 
			[aVariableNode isSpecialVariable
				ifTrue: [self parserError: CErrRedefiningPseudoVar range: aVariableNode sourceInterval]
				ifFalse: 
					[(aNode arguments includes: aVariableNode)
						ifTrue: [self parserError: CErrRedefiningArg range: aVariableNode sourceInterval]
						ifFalse: [^true]]].
	^false!

variableNodeClass
	^StVariableNode! !
!SmalltalkParser categoriesFor: #addCommentsTo:!helpers!private! !
!SmalltalkParser categoriesFor: #assignmentNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #atEnd!public!testing! !
!SmalltalkParser categoriesFor: #blockNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #braceArrayNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #canHaveStatementsAfterReturn!public!testing! !
!SmalltalkParser categoriesFor: #cascadeNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #errorBlock:!accessing!public! !
!SmalltalkParser categoriesFor: #errorPosition!error handling!public! !
!SmalltalkParser categoriesFor: #externalReferenceTypeFor:!parsing!private! !
!SmalltalkParser categoriesFor: #initialize!initializing!public! !
!SmalltalkParser categoriesFor: #initializeParserWith:!initializing!private! !
!SmalltalkParser categoriesFor: #line!accessing!public! !
!SmalltalkParser categoriesFor: #literalArrayNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #literalValueNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #lookupExternalStructType:!parsing!private! !
!SmalltalkParser categoriesFor: #messageNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #methodClass:!accessing!public! !
!SmalltalkParser categoriesFor: #methodNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #nextToken!helpers!private! !
!SmalltalkParser categoriesFor: #optimizedNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #parameterNodeClass!parsing!private! !
!SmalltalkParser categoriesFor: #parseAssignment!parsing!private! !
!SmalltalkParser categoriesFor: #parseBinaryMessage!parsing!private! !
!SmalltalkParser categoriesFor: #parseBinaryMessageWith:!parsing!private! !
!SmalltalkParser categoriesFor: #parseBinaryPattern!parsing!private! !
!SmalltalkParser categoriesFor: #parseBlock!parsing!private! !
!SmalltalkParser categoriesFor: #parseBlockArgsInto:!parsing!private! !
!SmalltalkParser categoriesFor: #parseBlockParameter!parsing!private! !
!SmalltalkParser categoriesFor: #parseBraceArray!parsing!private! !
!SmalltalkParser categoriesFor: #parseCascadedMessageFor:!parsing!private! !
!SmalltalkParser categoriesFor: #parseCascadeMessage!parsing!private! !
!SmalltalkParser categoriesFor: #parseExpression:!parsing!public! !
!SmalltalkParser categoriesFor: #parseExtendedTags:!parsing!private! !
!SmalltalkParser categoriesFor: #parseExternalArgType!parsing!private! !
!SmalltalkParser categoriesFor: #parseExternalArgTypeQualifier!parsing!private! !
!SmalltalkParser categoriesFor: #parseExternalCall:isVirtual:!parsing!private! !
!SmalltalkParser categoriesFor: #parseExternalCallArgList!parsing!private! !
!SmalltalkParser categoriesFor: #parseExternalCallArgs:!parsing!private! !
!SmalltalkParser categoriesFor: #parseExternalCallingConvention!parsing!private! !
!SmalltalkParser categoriesFor: #parseExternalCallName!parsing!private! !
!SmalltalkParser categoriesFor: #parseKeywordMessage!parsing!private! !
!SmalltalkParser categoriesFor: #parseKeywordMessageWith:!parsing!private! !
!SmalltalkParser categoriesFor: #parseKeywordPattern!parsing!private! !
!SmalltalkParser categoriesFor: #parseLiteralArray!parsing!private! !
!SmalltalkParser categoriesFor: #parseLiteralArrayObject!parsing!private! !
!SmalltalkParser categoriesFor: #parseLiteralByteArray!parsing!private! !
!SmalltalkParser categoriesFor: #parseLiteralByteArrayObject!parsing!private! !
!SmalltalkParser categoriesFor: #parseMessagePattern!parsing!private! !
!SmalltalkParser categoriesFor: #parseMethod!parsing!private! !
!SmalltalkParser categoriesFor: #parseMethod:!accessing!private! !
!SmalltalkParser categoriesFor: #parseMethod:in:errorBlock:!parsing!public! !
!SmalltalkParser categoriesFor: #parseMethodParameter!parsing!private! !
!SmalltalkParser categoriesFor: #parseNumberLiteral!parsing!private! !
!SmalltalkParser categoriesFor: #parseOptimizedExpression!parsing!private! !
!SmalltalkParser categoriesFor: #parseOverlappedCall:!parsing!private! !
!SmalltalkParser categoriesFor: #parseParenthesizedExpression!parsing!private! !
!SmalltalkParser categoriesFor: #parsePrimitiveIdentifier:!parsing!private! !
!SmalltalkParser categoriesFor: #parsePrimitiveLiteral!parsing!private! !
!SmalltalkParser categoriesFor: #parsePrimitiveObject!parsing!private! !
!SmalltalkParser categoriesFor: #parsePrimitiveValueLiteral!parsing!private! !
!SmalltalkParser categoriesFor: #parseQualifiedReference!parsing!private! !
!SmalltalkParser categoriesFor: #parserError:!error handling!private! !
!SmalltalkParser categoriesFor: #parserError:range:!error handling!private! !
!SmalltalkParser categoriesFor: #parserError:range:extra:!error handling!private! !
!SmalltalkParser categoriesFor: #parserError:range:extras:!error handling!private! !
!SmalltalkParser categoriesFor: #parseStatementList:!parsing!private! !
!SmalltalkParser categoriesFor: #parseStatementsOf:!parsing!private! !
!SmalltalkParser categoriesFor: #parseTag:!parsing!private! !
!SmalltalkParser categoriesFor: #parseTags!parsing!private! !
!SmalltalkParser categoriesFor: #parseTempDecl!parsing!private! !
!SmalltalkParser categoriesFor: #parseTempsOf:!parsing!private! !
!SmalltalkParser categoriesFor: #parseUnaryMessage!parsing!private! !
!SmalltalkParser categoriesFor: #parseUnaryMessageWith:!parsing!private! !
!SmalltalkParser categoriesFor: #parseUnaryPattern!parsing!private! !
!SmalltalkParser categoriesFor: #parseVariableNode:!parsing!private! !
!SmalltalkParser categoriesFor: #patchExternalDescriptorClose!parsing!private! !
!SmalltalkParser categoriesFor: #patchLiteralArrayToken!parsing!private! !
!SmalltalkParser categoriesFor: #patchLiteralMessage!helpers!private! !
!SmalltalkParser categoriesFor: #patchNegativeLiteral!helpers!private! !
!SmalltalkParser categoriesFor: #qualifiedReferenceNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #reportError:at:line:range:extras:!error handling!private! !
!SmalltalkParser categoriesFor: #returnNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #scanner:!accessing!public! !
!SmalltalkParser categoriesFor: #scannerClass!constants!private! !
!SmalltalkParser categoriesFor: #sequenceNodeClass!constants!private! !
!SmalltalkParser categoriesFor: #source!accessing!private! !
!SmalltalkParser categoriesFor: #step!parsing!private! !
!SmalltalkParser categoriesFor: #tempDeclClass!parsing!private! !
!SmalltalkParser categoriesFor: #validateArg:args:!parsing!private! !
!SmalltalkParser categoriesFor: #validateTemp:of:temps:!parsing!private! !
!SmalltalkParser categoriesFor: #variableNodeClass!constants!private! !

SmalltalkParser methodProtocol: #parseErrorHandler attributes: #(#readOnly) selectors: #(#reportError:at:line:range:extras:)!

!SmalltalkParser class methodsFor!

allowEmptyStatements
	^AllowEmptyStatements!

allowEmptyStatements: aBoolean
	AllowEmptyStatements := aBoolean!

errorClass
	^CompilerErrorNotification!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	"By default Dolphin treats empty statements as a syntax error"

	AllowEmptyStatements := false!

new
	^super new initialize!

notificationClass
	^CompilerNotification!

parseExistingMethodNoError: aCompiledMethod
	^self
		parseMethod: aCompiledMethod getSource
		in: aCompiledMethod methodClass
		onError: 
			[:err |
			Notification signal: ('Error <1p> on line <2p> of <3p> -> <4s>'
						expandMacrosWith: err errorCode
						with: err line
						with: aCompiledMethod
						with: err errorMessage).
			^nil]!

parseExpression: aString 
	^self parseExpression: aString onError: nil!

parseExpression: aString in: aClass
	^self parseExpression: aString in: aClass onError: nil!

parseExpression: aString in: aClass onError: aBlock 
	| node parser |
	parser := self new.
	parser errorBlock: aBlock.
	parser methodClass: aClass.
	parser initializeParserWith: aString.
	node := parser parseExpression: aString.
	^(node statements size == 1 and: [node temporaries isEmpty]) 
		ifTrue: [node statements first]
		ifFalse: [node]!

parseExpression: aString onError: aBlock 
	^self parseExpression: aString in: Object onError: aBlock!

parseExpressionNoError: aString in: aClass 
	^self 
		parseExpression: aString
		in: aClass
		onError: [:ex | ^nil]!

parseMethod: aString 
	^self parseMethod: aString in: UndefinedObject!

parseMethod: aString in: aClass 
	^self 
		parseMethod: aString
		in: aClass
		onError: nil!

parseMethod: aString in: aClass onError: aBlock 
	^self new 
		parseMethod: aString
		in: aClass
		errorBlock: aBlock!

parseMethod: aString onError: aBlock 
	^self 
		parseMethod: aString
		in: UndefinedObject
		onError: aBlock!

parseMethodNoError: aString 
	^self parseMethodNoError: aString in: UndefinedObject!

parseMethodNoError: aString in: methodClass 
	^self 
		parseMethod: aString
		in: methodClass
		onError: [:err | ^nil]!

parseMethodPattern: aString
	| parser |
	parser := self new.
	parser errorBlock: [:error | ^nil].
	parser initializeParserWith: aString.
	^parser parseMessagePattern selector!

warningClass
	^CompilerWarningNotification! !
!SmalltalkParser class categoriesFor: #allowEmptyStatements!accessing!public! !
!SmalltalkParser class categoriesFor: #allowEmptyStatements:!accessing!public! !
!SmalltalkParser class categoriesFor: #errorClass!constants!public! !
!SmalltalkParser class categoriesFor: #initialize!development!initializing!public! !
!SmalltalkParser class categoriesFor: #new!instance creation!public! !
!SmalltalkParser class categoriesFor: #notificationClass!constants!public! !
!SmalltalkParser class categoriesFor: #parseExistingMethodNoError:!commands!public! !
!SmalltalkParser class categoriesFor: #parseExpression:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseExpression:in:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseExpression:in:onError:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseExpression:onError:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseExpressionNoError:in:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseMethod:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseMethod:in:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseMethod:in:onError:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseMethod:onError:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseMethodNoError:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseMethodNoError:in:!parsing!public! !
!SmalltalkParser class categoriesFor: #parseMethodPattern:!parsing!public! !
!SmalltalkParser class categoriesFor: #warningClass!constants!public! !

