"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.Parser'
	instanceVariableNames: 'scanner currentToken nextToken errorBlock methodNode st80Syntax comments methodClass source environment'
	classVariableNames: 'AllowEmptyStatements'
	imports: #(#{External.ExtCallArgTypes} #{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Parser guid: (Core.GUID fromString: '{f15a9f2f-3a15-47cd-8ef9-0534b6f91c17}')!
Kernel.Parser comment: 'Instance Variables:
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
!Kernel.Parser categoriesForClass!System-Compiler! !
!Kernel.Parser methodsFor!

addCommentsTo: aNode 
	comments isNil ifTrue: [^self].
	aNode addComments: comments.
	comments := nil!

annotationNodeClass
	^StAnnotationNode!

assignmentNodeClass
	^StAssignmentNode!

atEnd
	^currentToken isEof!

blockNodeClass
	^StBlockNode!

braceArrayNodeClass
	^StBraceArrayNode!

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
	^(External.FunctionDescriptor referenceTypeFor: anInteger) ?? ExtCallArgLPPVOID!

initialize
	"If true then certain St80 syntax which is not valid ANSI are permitted, e.g. [:a ] is a valid block"
	st80Syntax := false!

initializeParserWith: aString
	source := aString.
	self scanner: (self scannerClass on: (ReadStream on: source) errorHandler: self)!

line
	"Anwswer one-based <integer> line number of the receiver's current position in the 
	source text."

	^scanner line!

messageNodeClass
	^StMessageNode!

methodClass: aClass environment: aNamespace
	methodClass := aClass.
	environment := aNamespace!

methodNodeClass
	^StMethodNode!

nextToken
	^nextToken ifNil: [nextToken := scanner next]!

optimizedNodeClass
	^StOptimizedNode!

parameterNodeClass
	^StParameterNode!

parseAnnotationArgument
	| token node |
	currentToken isIdentifier
		ifTrue: 
			[node := self variableNodeClass identifierToken: currentToken.
			self step.
			^node].
	(currentToken isLiteralToken and: [currentToken isMultiKeyword not])
		ifTrue: [^self parsePrimitiveLiteral].
	currentToken isLiteralArrayToken ifTrue: [^self parseLiteralArray].
	currentToken isLiteralByteArrayToken ifTrue: [^self parseLiteralByteArray].
	currentToken isOptimized ifTrue: [^self parseOptimizedExpression].
	currentToken isQualifiedReference ifTrue: [^self parseQualifiedReference].
	self parserError: CErrExpectAnnotationArg.
	"Attempt to recover by treating it as a literal value, the AST will be invalid of course"
	token := StLiteralToken
				start: currentToken start
				comments: nil
				value: (source copyFrom: currentToken start to: currentToken stop)
				stop: currentToken stop.
	self step.
	node := StLiteralValueNode new literalToken: token.
	self addCommentsTo: node.
	^node!

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
				selectorParts: {StIdentifierToken
							start: nil
							comments: nil
							value: 'doIt'}
				arguments: #().
	method
		source: aString;
		methodClass: methodClass environment: environment.
	body := self parseStatementsOf: method.
	method body: body.
	self atEnd
		ifFalse: [self parserError: CErrNonsenseAtExprEnd range: (self errorPosition to: source size)].
	^body!

parseExternalArgType
	| valueType indirections typeToken structClass stop start |
	start := currentToken sourceInterval start.
	currentToken isIdentifier
		ifFalse: 
			[self parserError: CErrExpectExtType range: currentToken sourceInterval.
			"Error ignored, attempt to recover by creating a dummy arg type node and
			stepping over the offending token..."
			self step.
			^StExternalArgTypeNode new
				start: currentToken start;
				stop: currentToken stop;
				typeOrdinal: ExtCallArgLPVOID;
				indirections: 0;
				yourself].
	structClass := nil.
	valueType := External.FunctionDescriptor typeFromName: currentToken value ifAbsent: ExtCallArgSTRUCT.
	"We can't look up the struct class until semantic analysis, so hold as a variable for later resolution"
	structClass := valueType == ExtCallArgSTRUCT ifTrue: [StVariableNode identifierToken: currentToken].
	typeToken := currentToken.
	self step.
	indirections := self parseExternalArgTypeQualifier.
	indirections > 0
		ifTrue: 
			[| refType |
			refType := valueType.
			indirections > 1
				ifTrue: [valueType == ExtCallArgSTRUCT ifFalse: [refType := self externalReferenceTypeFor: valueType]].
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
	^StExternalArgTypeNode new
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
	(qualifier == #*> or: [qualifier == #**>]) ifTrue: [qualifier := self patchFunctionDescriptorClose].
	qualifier == #* ifTrue: [^1].
	qualifier == #** ifTrue: [^2].
	self parserError: CErrBadExtTypeQualifier.
	"Error ignored, attempt to recover by stepping over the bad qualifier and defaulting to no indirection..."
	self step.
	^0!

parseExternalCall: callConvId startingAt: startInteger
	| node |
	node := StExternalCallNode new.
	node
		start: startInteger;
		callingConvention: callConvId;
		returnType: self parseExternalArgType.
	node nameOrOrdinal: self parseExternalCallName.
	self parseExternalCallArgs: node.
	^node!

parseExternalCallArgList
	| args |
	args := WriteStream on: (Array new: methodNode argumentCount).
	[self atEnd or: [currentToken isBinary: #>]] whileFalse: 
			[| arg |
			arg := self parseExternalArgType.
			(arg typeOrdinal == ExtCallArgVOID and: [arg indirections == 0])
				ifTrue: 
					[self parserError: CErrArgTypeCannotBeVoid range: arg sourceInterval
					"Error ignored, no recovery required since this is a semantic rather than syntax error"].
			args nextPut: arg].
	^args grabContents!

parseExternalCallArgs: aStExternalCallNode
	| types got expected start |
	start := currentToken start.
	types := self parseExternalCallArgList.
	aStExternalCallNode argumentTypes: types.
	got := types size.
	expected := methodNode argumentCount.
	got < expected
		ifTrue: 
			[self parserError: CErrInsufficientArgTypes range: (start to: self errorPosition - 1)
			"Error ignored, but no recovery needed as the decl is syntactically correct, it just defines too few types."].
	got > expected
		ifTrue: 
			[self parserError: CErrTooManyArgTypes range: (start to: types last sourceInterval stop)
			"Error ignored, but no recovery needed as the decl is syntactically correct, it just defines too many types."].
	^types!

parseExternalCallingConvention
	| callConvId |
	(currentToken isKeyword not
		or: [(callConvId := External.FunctionDescriptor conventionFromName: currentToken value) < 0])
			ifTrue: 
				[self parserError: CErrExpectCallConv.
				"Error ignored, attempt to recover by using a sensible default..."
				callConvId := 0]
			ifFalse: 
				[callConvId > 1
					ifTrue: 
						[self parserError: CErrUnsupportedCallConv.
						"Error ignored, attempt to recover by using a sensible default.."
						callConvId := 0].
				self step].
	^callConvId!

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

parseKeywordAnnotation: anInteger
	| selector args |
	selector := WriteStream on: (Utf8String new: 16).
	args := WriteStream on: (Array new: 1).
	
	[selector nextPutAll: currentToken value.
	self step.
	args nextPut: self parseAnnotationArgument.
	currentToken isKeyword]
			whileTrue.
	^(self annotationNodeClass selector: selector contents asSymbol arguments: args grabContents)
		start: anInteger;
		yourself!

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

parseKeywordTag: startInteger
	| keyword |
	keyword := currentToken value.
	^keyword = 'primitive:'
		ifTrue: [self parsePrimitive: startInteger]
		ifFalse: 
			[| callConvId |
			callConvId := External.FunctionDescriptor conventionFromName: keyword.
			callConvId >= 0
				ifTrue: 
					["An external call descriptor"
					callConvId > 1
						ifTrue: 
							[self parserError: CErrUnsupportedCallConv.
							"Error ignored, attempt to recover by using a sensible default.."
							callConvId := 0].
					self step.
					self parseExternalCall: callConvId startingAt: startInteger]
				ifFalse: 
					["A generic keyword annotation"
					self parseKeywordAnnotation: startInteger]]!

parseLiteralArray
	| stream start stop |
	start := currentToken start.
	stream := WriteStream on: (Array new: 30).
	self step.
	[currentToken isEof or: [currentToken isSpecial: $)]]
		whileFalse: [stream nextPut: self parseLiteralArrayObject].
	(currentToken isSpecial: $))
		ifFalse: 
			[self parserError: CErrArrayNotClosed range: (start to: self errorPosition - 1)
			"Error ignored, no recovery needed as at EOF"].
	stop := currentToken stop.
	self step.
	^StLiteralArrayNode new
		startPosition: start
		contents: stream contents
		stopPosition: stop!

parseLiteralArrayObject
	currentToken isSpecial
		ifTrue: 
			[currentToken value == $( ifTrue: [^self parseLiteralArray].
			currentToken value == $[ ifTrue: [^self parseLiteralByteArray]].
	currentToken isLiteralArrayToken ifTrue: [^self parseLiteralArray].
	currentToken isLiteralByteArrayToken ifTrue: [^self parseLiteralByteArray].
	currentToken isOptimized ifTrue: [^self parseOptimizedExpression].
	currentToken isQualifiedReference ifTrue: [^self parseQualifiedReference].
	currentToken isLiteralToken ifFalse: [self patchLiteralArrayToken].
	^self parsePrimitiveLiteral!

parseLiteralByteArray
	| stream start stop |
	start := currentToken start.
	stream := WriteStream on: (Array new: 30).
	self step.
	[currentToken isEof or: [currentToken isSpecial: $]]]
		whileFalse: [stream nextPut: self parseLiteralByteArrayObject].
	(currentToken isSpecial: $])
		ifTrue: [stop := currentToken stop]
		ifFalse: 
			[stop := stream isEmpty ifTrue: [start + 1] ifFalse: [stream contents last stop].
			self parserError: CErrByteArrayNotClosed range: (start to: stop)
			"Error ignored, but at EOF so no recovery needed..."].
	self step.
	^StLiteralByteArrayNode new
		startPosition: start
		contents: stream contents
		stopPosition: stop!

parseLiteralByteArrayObject
	| token |
	token := currentToken.
	(token isNumberLiteralToken and: 
			[| value |
			value := token value.
			value isInteger and: [value == (value bitAnd: 255)]])
		ifFalse: 
			[self parserError: CErrBadValueInByteArray.
			"Error ignored, attempt to recover"
			token := StNumberLiteralToken
						start: currentToken start
						comments: nil
						value: 0
						stop: currentToken stop].
	self step.
	^StLiteralValueNode new literalToken: token!

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
								selectorParts: {StIdentifierToken
											start: 1
											comments: nil
											value: ''}
								arguments: #()]]]!

parseMethod
	methodNode := self parseMessagePattern.
	self parseTags.
	self addCommentsTo: methodNode.
	methodNode body: (self parseStatementsOf: methodNode).
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
		methodClass: methodClass environment: environment;
		yourself!

parseMethod: aString in: aClass environment: aNamespace errorBlock: monadicBlock
	self errorBlock: monadicBlock.
	self methodClass: aClass environment: aNamespace.
	self initializeParserWith: aString.
	^self parseMethod: aString!

parseMethodParameter
	^self parseVariableNode: self parameterNodeClass!

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
	| callConvId |
	self step.
	callConvId := self parseExternalCallingConvention.
	^(self parseExternalCall: callConvId startingAt: startInteger)
		isOverlapped: true;
		yourself!

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

parsePrimitive: startInteger
	| primitiveNode primitiveIndex |
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
	^primitiveNode!

parsePrimitiveIdentifier: aStVariableNodeClass
	| token node |
	token := currentToken.
	self step.
	node := aStVariableNodeClass identifierToken: token.
	self addCommentsTo: node.
	^node!

parsePrimitiveLiteral
	| token |
	token := currentToken.
	self step.
	^StLiteralValueNode new literalToken: token!

parsePrimitiveObject
	| token node |
	currentToken isIdentifier ifTrue: [^self parsePrimitiveIdentifier: self variableNodeClass].
	(currentToken isLiteralToken and: [currentToken isMultiKeyword not])
		ifTrue: [^self parsePrimitiveLiteral].
	currentToken isLiteralArrayToken ifTrue: [^self parseLiteralArray].
	currentToken isLiteralByteArrayToken ifTrue: [^self parseLiteralByteArray].
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
	token := StLiteralToken
				start: currentToken start
				comments: nil
				value: (source copyFrom: currentToken start to: currentToken stop)
				stop: currentToken stop.
	self step.
	node := StLiteralValueNode new literalToken: token.
	self addCommentsTo: node.
	^node!

parseQualifiedReference
	| start stop node |
	start := currentToken start.
	stop := currentToken stop.
	self step.
	currentToken isIdentifier
		ifTrue: 
			[node := self qualifiedReferenceNodeClass pathString: currentToken value start: start flags: 0.
			stop := self parseQualifiedRefModifiers: node]
		ifFalse: 
			[node := self qualifiedReferenceNodeClass pathString: '' start: start flags: 0.
			self parserError: CErrExpectVariable].
	(currentToken isSpecial: $})
		ifTrue: 
			[stop := currentToken stop.
			self step]
		ifFalse: 
			["Attempt to recover - Skip over any invalid identifier/modifier if the next token is the closing brace"
			(self nextToken isSpecial: $})
				ifTrue: 
					[self parserError: CErrBadQualifiedRefModifier.
					self step.
					stop := currentToken stop.
					self step]
				ifFalse: 
					["If one token lookahead doesn't find the closing brace, assume the current token is part of a subsequent message and the close brace is missing"
					self parserError: CErrQualifiedRefNotClosed range: (start to: stop)]].
	node stop: stop.
	^node!

parseQualifiedRefModifiers: aStQualifiedReferenceNode
	| stop |
	stop := currentToken stop.
	self step.
	[currentToken isIdentifier] whileTrue: 
			[| qualifier |
			qualifier := currentToken value.
			qualifier = 'class'
				ifTrue: 
					[aStQualifiedReferenceNode isMeta: true.
					stop := currentToken stop.
					self step]
				ifFalse: 
					[qualifier = 'private'
						ifTrue: 
							[aStQualifiedReferenceNode isPrivate: true.
							stop := currentToken stop.
							self step]
						ifFalse: [^stop]]].
	^stop!

parserError: anInteger
	"Raise a <SmalltalkParseError> with the specified <integer> error code and associated arguments
	(which are used when formatting the error message)."

	self parserError: anInteger range: currentToken sourceInterval!

parserError: anInteger range: anInterval 
	"Private - Raise a <SmalltalkParseError> with the specified <integer> error code and associated arguments
	(which are used when formatting the error message)."

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
	statements := OrderedCollection new: 4.
	periods := OrderedCollection new: 4.
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
					end := false]
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
	statements isEmpty ifFalse: [self addCommentsTo: statements last].
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
	currentToken isKeyword ifTrue: [^self parseKeywordTag: startInteger].
	currentToken isIdentifier ifTrue: [^self parseUnaryTag: startInteger].
	"Tags must have a keyword or unary selector"
	self parserError: CErrBadSelector.
	"Attempt to recover..."
	self step.
	^(StAnnotationNode selector: #error arguments: #())
		start: startInteger;
		yourself!

parseTags
	| tags start |
	(currentToken isBinary: #<) ifFalse: [^self].
	tags := Array writeStream: 1.
	
	[| tag |
	start := currentToken start.
	self step.
	tag := self parseTag: start.
	tags nextPut: tag.
	(currentToken isBinary: #>)
		ifFalse: 
			[self parserError: CErrExpectCloseTag.
			"Error ignored, attempt to recover..."
			tag stop: currentToken start - 1.
			methodNode tags: tags grabContents.
			^self].
	tag stop: currentToken start.
	self step.
	currentToken isBinary: #<]
			whileTrue.
	methodNode tags: tags grabContents!

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

parseUnaryTag: startInteger
	| selector |
	selector := currentToken value.
	selector = 'virtual' ifTrue: [^self parseVirtualCall: startInteger].
	selector = 'overlap' ifTrue: [^self parseOverlappedCall: startInteger].
	self step.
	^(StAnnotationNode selector: selector arguments: #())
		start: startInteger;
		yourself!

parseVariableNode: aStVariableNodeClass
	| token node |
	currentToken isIdentifier ifTrue: [^self parsePrimitiveIdentifier: aStVariableNodeClass].
	self parserError: CErrExpectVariable.
	"Error ignored, attempt to recover..."
	token := StIdentifierToken
				start: currentToken start
				comments: nil
				value: (source copyFrom: currentToken start to: currentToken stop).
	self step.
	node := aStVariableNodeClass identifierToken: token.
	self addCommentsTo: node.
	^node!

parseVirtualCall: startInteger
	| vfnIndex node callConvId |
	self step.
	callConvId := self parseExternalCallingConvention.
	node := StExternalCallNode new.
	node
		start: startInteger;
		callingConvention: callConvId;
		returnType: self parseExternalArgType.
	node isVirtual: true.
	(currentToken isLiteralToken not or: [(vfnIndex := currentToken value) isInteger not])
		ifTrue: 
			[self parserError: CErrExpectVfn.	"Error ignored, attempt to recover."
			vfnIndex := 1].
	(vfnIndex between: 1 and: VMConstants.MaxVirtualFunction)
		ifFalse: [self parserError: CErrBadVfn	"Error ignored, continue"].
	node nameOrOrdinal: vfnIndex.
	self step.
	self parseExternalCallArgs: node.
	^node!

patchFunctionDescriptorClose
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
					source copyFrom: currentToken start to: currentToken stop].
	currentToken := StLiteralToken
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
	value isNil
		ifTrue: 
			[^currentToken := StIdentifierToken
						start: currentToken start
						comments: nil
						value: 'nil']!

patchNegativeLiteral
	"Private - Handle the special negative number case for binary message sends."

	| intValue |
	intValue := currentToken value.
	(intValue isKindOf: Number) ifFalse: [^self].
	intValue <= 0 ifFalse: [^self].
	intValue == 0
		ifTrue: 
			[(source notNil
				and: [source notEmpty and: [(source at: (currentToken start min: source size)) == $-]])
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
	^Scanner!

sequenceNodeClass
	^StSequenceNode!

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
!Kernel.Parser categoriesForMethods!
addCommentsTo:!helpers!private! !
annotationNodeClass!constants!private! !
assignmentNodeClass!constants!private! !
atEnd!public!testing! !
blockNodeClass!constants!private! !
braceArrayNodeClass!constants!private! !
cascadeNodeClass!constants!private! !
errorBlock:!accessing!public! !
errorPosition!error handling!public! !
externalReferenceTypeFor:!parsing!private! !
initialize!initializing!public! !
initializeParserWith:!initializing!private! !
line!accessing!public! !
messageNodeClass!constants!private! !
methodClass:environment:!initializing!private! !
methodNodeClass!constants!private! !
nextToken!helpers!private! !
optimizedNodeClass!constants!private! !
parameterNodeClass!parsing!private! !
parseAnnotationArgument!parsing!private! !
parseAssignment!parsing!private! !
parseBinaryMessage!parsing!private! !
parseBinaryMessageWith:!parsing!private! !
parseBinaryPattern!parsing!private! !
parseBlock!parsing!private! !
parseBlockArgsInto:!parsing!private! !
parseBlockParameter!parsing!private! !
parseBraceArray!parsing!private! !
parseCascadedMessageFor:!parsing!private! !
parseCascadeMessage!parsing!private! !
parseExpression:!parsing!public! !
parseExternalArgType!parsing!private! !
parseExternalArgTypeQualifier!parsing!private! !
parseExternalCall:startingAt:!parsing!private! !
parseExternalCallArgList!parsing!private! !
parseExternalCallArgs:!parsing!private! !
parseExternalCallingConvention!parsing!private! !
parseExternalCallName!parsing!private! !
parseKeywordAnnotation:!parsing!private! !
parseKeywordMessage!parsing!private! !
parseKeywordMessageWith:!parsing!private! !
parseKeywordPattern!parsing!private! !
parseKeywordTag:!parsing!private! !
parseLiteralArray!parsing!private! !
parseLiteralArrayObject!parsing!private! !
parseLiteralByteArray!parsing!private! !
parseLiteralByteArrayObject!parsing!private! !
parseMessagePattern!parsing!private! !
parseMethod!parsing!private! !
parseMethod:!accessing!private! !
parseMethod:in:environment:errorBlock:!parsing!private! !
parseMethodParameter!parsing!private! !
parseOptimizedExpression!parsing!private! !
parseOverlappedCall:!parsing!private! !
parseParenthesizedExpression!parsing!private! !
parsePrimitive:!parsing!private! !
parsePrimitiveIdentifier:!parsing!private! !
parsePrimitiveLiteral!parsing!private! !
parsePrimitiveObject!parsing!private! !
parseQualifiedReference!parsing!private! !
parseQualifiedRefModifiers:!parsing!private! !
parserError:!error handling!private! !
parserError:range:!error handling!private! !
parserError:range:extra:!error handling!private! !
parserError:range:extras:!error handling!private! !
parseStatementList:!parsing!private! !
parseStatementsOf:!parsing!private! !
parseTag:!parsing!private! !
parseTags!parsing!private! !
parseTempDecl!parsing!private! !
parseTempsOf:!parsing!private! !
parseUnaryMessage!parsing!private! !
parseUnaryMessageWith:!parsing!private! !
parseUnaryPattern!parsing!private! !
parseUnaryTag:!parsing!private! !
parseVariableNode:!parsing!private! !
parseVirtualCall:!parsing!private! !
patchFunctionDescriptorClose!parsing!private! !
patchLiteralArrayToken!parsing!private! !
patchLiteralMessage!helpers!private! !
patchNegativeLiteral!helpers!private! !
qualifiedReferenceNodeClass!constants!private! !
reportError:at:line:range:extras:!error handling!private! !
returnNodeClass!constants!private! !
scanner:!accessing!public! !
scannerClass!constants!private! !
sequenceNodeClass!constants!private! !
step!parsing!private! !
tempDeclClass!parsing!private! !
validateArg:args:!parsing!private! !
validateTemp:of:temps:!parsing!private! !
variableNodeClass!constants!private! !
!

Kernel.Parser methodProtocol: #parseErrorHandler attributes: #(#readOnly) selectors: #(#reportError:at:line:range:extras:)!

!Kernel.Parser class methodsFor!

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
		environment: aCompiledMethod customEnvironment
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
	^self parseExpression: aString in: aClass environment: aClass environment!

parseExpression: aString in: aClass environment: aNamespace
	^self
		parseExpression: aString
		in: aClass
		environment: aNamespace
		onError: nil!

parseExpression: aString in: aClass environment: aNamespace onError: aBlock
	| node parser |
	parser := self new
				errorBlock: aBlock;
				methodClass: aClass environment: aNamespace;
				initializeParserWith: aString;
				yourself.
	node := parser parseExpression: aString.
	^(node statements size == 1 and: [node temporaries isEmpty])
		ifTrue: [node statements first]
		ifFalse: [node]!

parseExpression: aString in: aClass onError: aBlock
	^self
		parseExpression: aString
		in: aClass
		environment: aClass environment
		onError: aBlock!

parseExpression: aString onError: aBlock
	^self
		parseExpression: aString
		in: Object
		onError: aBlock!

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
		environment: nil!

parseMethod: aString in: aClass environment: aNamespace
	^self
		parseMethod: aString
		in: aClass
		environment: aNamespace
		onError: nil!

parseMethod: aString in: aClass environment: aNamespace onError: aBlock
	^self new
		parseMethod: aString
		in: aClass
		environment: aNamespace
		errorBlock: aBlock!

parseMethod: aString in: aClass onError: aMonadicValuable
	^self
		parseMethod: aString
		in: aClass
		environment: nil
		onError: aMonadicValuable!

parseMethod: aString onError: aBlock
	^self
		parseMethod: aString
		in: UndefinedObject
		environment: Smalltalk
		onError: aBlock!

parseMethodNoError: aString
	^self parseMethodNoError: aString in: UndefinedObject!

parseMethodNoError: aString in: methodClass
	^self
		parseMethod: aString
		in: methodClass
		environment: nil
		onError: [:err | ^nil]!

parseMethodPattern: aString
	| parser |
	parser := self new.
	parser errorBlock: [:error | ^nil].
	parser initializeParserWith: aString.
	^parser parseMessagePattern selector!

warningClass
	^CompilerWarningNotification! !
!Kernel.Parser class categoriesForMethods!
allowEmptyStatements!accessing!public! !
allowEmptyStatements:!accessing!public! !
errorClass!constants!public! !
initialize!development!initializing!public! !
new!instance creation!public! !
notificationClass!constants!public! !
parseExistingMethodNoError:!commands!public! !
parseExpression:!parsing!public! !
parseExpression:in:!parsing!public! !
parseExpression:in:environment:!parsing!public! !
parseExpression:in:environment:onError:!parsing!public! !
parseExpression:in:onError:!parsing!public! !
parseExpression:onError:!parsing!public! !
parseExpressionNoError:in:!parsing!public! !
parseMethod:!parsing!public! !
parseMethod:in:!parsing!public! !
parseMethod:in:environment:!parsing!public! !
parseMethod:in:environment:onError:!parsing!public! !
parseMethod:in:onError:!parsing!public! !
parseMethod:onError:!parsing!public! !
parseMethodNoError:!parsing!public! !
parseMethodNoError:in:!parsing!public! !
parseMethodPattern:!parsing!public! !
warningClass!constants!public! !
!

