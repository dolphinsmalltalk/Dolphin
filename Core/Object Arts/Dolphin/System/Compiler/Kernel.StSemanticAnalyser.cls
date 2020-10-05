"Filed out from Dolphin Smalltalk 7"!

Kernel.ParseNodeVisitor subclass: #'Kernel.StSemanticAnalyser'
	instanceVariableNames: 'methodNode methodClass evaluationContext currentScope scopes literals stringLiterals addToFrame tempDecls inStaticExpression evalScope annotations errorBlock'
	classVariableNames: 'OptimizedMessages RestrictedSelectors SpecialSelectors'
	imports: #(#{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StSemanticAnalyser guid: (Core.GUID fromString: '{3922cac3-8a81-45a8-adb3-2795a6e7bc2f}')!
Kernel.StSemanticAnalyser comment: 'StSemanticAnalyser is a <StParseNodeVisitor> that performs semantic analysis of an AST.'!
!Kernel.StSemanticAnalyser categoriesForClass!System-Compiler! !
!Kernel.StSemanticAnalyser methodsFor!

accessStaticVariable: aStVariableNode
	self addLiteral: aStVariableNode value: aStVariableNode variable binding!

addLiteral: aLiteralNode value: anObject
	(literals addNewElement: anObject) ifTrue: [self checkLiteralFrameSize: aLiteralNode]!

addMessageToFrame: aMessageNode
	| selector |
	selector := aMessageNode selector.
	"Special selectors such as #== are not added to the literal frame. These have special
	bytecodes which can be used to find senders."
	(SpecialSelectors identityIncludes: selector) ifTrue: [^self].
	self addLiteral: aMessageNode value: selector!

addToFrame: aLiteralNode
	| value |
	value := aLiteralNode value.
	(VMLibrary hasBytecodeRepresentation: value) ifTrue: [^self].
	value isString
		ifTrue: [(value isSymbol not and: [(stringLiterals addNewElement: value) not]) ifTrue: [^self]].
	self addLiteral: aLiteralNode value: value!

addToFrameStatic: aLiteralNode
	| value |
	value := aLiteralNode value.
	"When parsing static expressions we record all the symbols, literal arrays, and variables
	that are referenced in the static expression so that these can be searched on later."
	(value isSymbol or: [(value isKindOf: Array) or: [value isKindOf: VariableBinding]])
		ifTrue: [self addLiteral: aLiteralNode value: value]!

annotations
	^annotations ifNil: [annotations := OrderedCollection new]!

assignStaticVariable: anStVariableNode
	self accessStaticVariable: anStVariableNode!

assignVariable: anStVariableNode
	^(self bindVariable: anStVariableNode)
		ifNotNil: 
			[:var |
			var isConstant
				ifTrue: 
					[self errorAssignConstant: anStVariableNode.
					"If an argument, record the illegal assignment as a read to suppress unreferenced argument warning"
					var isArgument ifTrue: [var addRead: anStVariableNode fromScope: currentScope]]
				ifFalse: 
					[var addAssignment: anStVariableNode fromScope: currentScope.
					var isStaticVariable ifTrue: [self assignStaticVariable: anStVariableNode]].
			var]!

bindVariable: anStVariableNode
	"Private - Find the correct variable definition for the identifier of aVariableNode, and
	associate the StVariable describing that definition with the node."

	^(currentScope lookupVariable: anStVariableNode)
		ifNil: 
			[self signalError: CErrUndeclared forNode: anStVariableNode.
			nil]
		ifNotNil: 
			[:var |
			anStVariableNode variable: var.
			var]!

blockDepth
	| depth scope |
	depth := 0.
	scope := currentScope.
	[scope isNil] whileFalse: 
			[scope isInlined ifFalse: [depth := depth + 1].
			scope := scope outer].
	^depth!

checkAnnotations: aStMethodNode
	annotations ifNil: [^self].
	(annotations detect: [:each | each first == #mutable] ifNone: [])
		ifNotNil: 
			[(aStMethodNode argumentCount ~~ 1 or: 
					[| statements |
					statements := aStMethodNode body statements.
					statements size > 1 or: 
							[| statement |
							statement := statements first.
							statement isAssignment not or: 
									[| rhs |
									rhs := statement value.
									rhs isVariable not or: 
											[rhs name ~= aStMethodNode arguments first name or: 
													[| lhs |
													lhs := currentScope lookupVariable: statement variable.
													lhs isNil or: [lhs isInstanceVariable not]]]]]])
				ifTrue: [self signalError: CWarnMutableIgnored forNode: aStMethodNode]]!

checkIsLiteralBlockHandler: aStProgramNode forMessage: aStMessageNode 
	aStProgramNode isBlock 
		ifFalse: [aStProgramNode isLiteralNode ifFalse: [^self]]
		ifTrue: 
			[| argc |
			argc := aStProgramNode argumentCount.
			argc == 1 
				ifTrue: 
					["Correctly formed!!"
					^self].
			argc == 0 
				ifTrue: 
					["Deprecated form with niladic handler block: e.g. [...] on: Error do: [...]"
					self 
						signalError: CWarnExpectMonadicBlockArg
						forNode: aStProgramNode
						extra: aStMessageNode selector.
					^self]].
	"Invalid form with dyadic (or >) handler block: e.g. [...] on: Error do: [:a :b | ...]"
	"Or: Likely invalid form with non-block literal e.g. [...] on: Error do: 'blah'."
	self 
		signalError: CWarnExpectMonadicOrNiladicBlockArg
		forNode: aStProgramNode
		extra: aStMessageNode selector!

checkLiteralFrameSize: anStProgramNode
	literals size > VMConstants.MaxLiterals
		ifTrue: [self signalError: CErrTooManyLiterals forNode: anStProgramNode]!

checkMessage: aStMessageNode hasMonadicBlockArg: aStProgramNode 
	aStProgramNode isBlock 
		ifTrue: 
			[aStProgramNode argumentCount == 1 
				ifTrue: [^true]
				ifFalse: 
					[self 
						signalError: CErrIncorrectBlockArgCount
						forNode: aStProgramNode
						range: (aStProgramNode start to: aStProgramNode barOrStop)
						extras: #()]]
		ifFalse: 
			[self 
				signalError: CWarnExpectMonadicBlockArg
				forNode: aStProgramNode
				extra: aStMessageNode selector].
	^false!

checkMessage: aStMessageNode hasNiladicBlockArg: aStProgramNode code: anInteger
	aStProgramNode isBlock
		ifTrue: 
			[aStProgramNode argumentCount = 0
				ifTrue: [^true]
				ifFalse: 
					[self
						signalError: CErrIncorrectBlockArgCount
						forNode: aStProgramNode
						range: (aStProgramNode start to: aStProgramNode barOrStop)
						extras: {aStMessageNode selector}]]
		ifFalse: 
			[self
				signalError: anInteger
				forNode: aStProgramNode
				extra: aStMessageNode selector].
	^false!

checkMessage: aStMessageNode hasNiladicOrMonadicBlockArg: aStProgramNode code: anInteger
	aStProgramNode isBlock
		ifTrue: 
			[aStProgramNode argumentCount <= 1
				ifTrue: [^true]
				ifFalse: 
					[self
						signalError: CErrTooManyIfNotNilBlockArgs
						forNode: aStProgramNode
						range: (aStProgramNode start to: aStProgramNode barOrStop)
						extras: #()]]
		ifFalse: 
			[self
				signalError: anInteger
				forNode: aStProgramNode
				extra: aStMessageNode selector].
	^false!

checkMessage: aStMessageNode hasNonEmptyNiladicBlockArg: aStProgramNode code: anInteger
	^(self
		checkMessage: aStMessageNode
		hasNiladicBlockArg: aStProgramNode
		code: anInteger) and: 
				[aStProgramNode isEmptyBlock not or: 
						[self
							signalError: CErrEmptyConditionBlock
							forNode: aStMessageNode
							range: aStProgramNode sourceInterval
							extras: {aStMessageNode selector}.
						false]]!

checkMessageArgumentCount: aMessageNode 
	aMessageNode argumentCount > VMConstants.MaxMessageArgs 
		ifTrue: [self signalError: CErrTooManyArgs forNode: aMessageNode]!

checkMessageHasNiladicBlockReceiver: aMessageNode
	| receiver |
	receiver := aMessageNode receiver.
	(receiver isBlock and: [receiver argumentCount = 0]) ifTrue: [^true].
	self
		signalError: CWarnExpectNiladicBlockReceiver
		forNode: aMessageNode
		range: aMessageNode receiver sourceInterval
		extras: {aMessageNode selector}.
	^false!

checkMessageHasNonEmptyNiladicBlockReceiver: aMessageNode
	^(self checkMessageHasNiladicBlockReceiver: aMessageNode) and: 
			[| block |
			block := aMessageNode receiver.
			block isEmptyBlock not or: 
					[self
						signalError: CErrEmptyConditionBlock
						forNode: aMessageNode
						range: block sourceInterval
						extras: {aMessageNode selector}.
					false]]!

checkOptimizedKeywordMessages: aMessageNode
	| selector arguments argc |
	arguments := aMessageNode arguments.
	argc := arguments size.
	argc > 3 ifTrue: [^false].
	selector := aMessageNode selector.
	argc == 1
		ifTrue: 
			[(#(#ifTrue: #ifFalse: #ifNil: #timesRepeat:) identityIncludes: selector)
				ifTrue: 
					[^self
						checkMessage: aMessageNode
						hasNiladicBlockArg: arguments first
						code: CWarnExpectNiladicBlockArg].
			(selector == #and: or: [selector == #or:])
				ifTrue: 
					[^self
						checkMessage: aMessageNode
						hasNonEmptyNiladicBlockArg: arguments first
						code: CWarnExpectNiladicBlockArg].
			(selector == #whileTrue: or: [selector == #whileFalse:])
				ifTrue: 
					[^(self checkMessageHasNonEmptyNiladicBlockReceiver: aMessageNode) and: 
							[self
								checkMessage: aMessageNode
								hasNiladicBlockArg: arguments first
								code: CWarnExpectNiladicBlockArg]].
			selector == #ifNotNil:
				ifTrue: 
					[^self
						checkMessage: aMessageNode
						hasNiladicOrMonadicBlockArg: arguments first
						code: CWarnExpectMonadicOrNiladicBlockArg].
			^false].
	(#ifTrue:ifFalse: == selector or: [selector == #ifFalse:ifTrue:])
		ifTrue: 
			[^(self
				checkMessage: aMessageNode
				hasNiladicBlockArg: arguments first
				code: CWarnExpectNiladicBlockArg) and: 
						[self
							checkMessage: aMessageNode
							hasNiladicBlockArg: arguments second
							code: CWarnExpectNiladicBlockArg]].
	selector == #ifNil:ifNotNil:
		ifTrue: 
			[^(self
				checkMessage: aMessageNode
				hasNiladicBlockArg: arguments first
				code: CWarnExpectNiladicBlockArg) and: 
						[self
							checkMessage: aMessageNode
							hasNiladicOrMonadicBlockArg: arguments second
							code: CErrExpectLiteralBlock]].
	selector == #ifNotNil:ifNil:
		ifTrue: 
			[^(self
				checkMessage: aMessageNode
				hasNiladicOrMonadicBlockArg: arguments first
				code: CWarnExpectMonadicOrNiladicBlockArg) and: 
						[self
							checkMessage: aMessageNode
							hasNiladicBlockArg: arguments second
							code: CErrExpectLiteralBlock]].
	selector == #to:do: ifTrue: [^self checkMessage: aMessageNode hasMonadicBlockArg: arguments second].
	selector == #to:by:do:
		ifTrue: [^self checkMessage: aMessageNode hasMonadicBlockArg: arguments third].
	^false!

checkOptimizedMessages: aMessageNode 
	aMessageNode isUnary ifTrue: [^self checkOptimizedUnaryMessages: aMessageNode].
	aMessageNode isKeyword ifTrue: [^self checkOptimizedKeywordMessages: aMessageNode].
	"No optimised binary selectors are present."
	^false!

checkOptimizedUnaryMessages: aMessageNode
	| selector |
	selector := aMessageNode selector.
	^(selector == #whileTrue or: [selector == #whileFalse])
		ifTrue: [self checkMessageHasNonEmptyNiladicBlockReceiver: aMessageNode]
		ifFalse: [selector == #repeat and: [self checkMessageHasNiladicBlockReceiver: aMessageNode]]!

checkRedefines: anStVariableNode
	| var |
	var := currentScope lookupVariable: anStVariableNode.
	var isNil ifTrue: [^self].
	var isStaticVariable
		ifTrue: 
			[var scope == evalScope ifFalse: [self signalError: CWarnRedefiningStatic forNode: anStVariableNode].
			^self].
	var isInstanceVariable
		ifTrue: 
			[self signalError: CWarnRedefiningInstVar forNode: anStVariableNode.
			^self].
	"Note that we interpret the ANSI standard as stating that duplicate temporary/argument names
	at the same scope are not permitted (which is certainly true), but that duplicate names in
	nested scopes (i.e. temps/args that shadow outer temps) are permitted (which seems
	appropriate), but for which we issue a warning."
	var isArgument
		ifTrue: [self signalError: CWarnRedefiningArg forNode: anStVariableNode]
		ifFalse: [self signalError: CWarnRedefiningTemp forNode: anStVariableNode]!

checkRestrictedSelectors: aMethodNode
	| last first |
	(self restrictedSelectors identityIncludes: aMethodNode selector) ifFalse: [^self].
	(OptimizedMessages lookup: methodClass)
		ifNotNil: [:selectors | (selectors identityIncludes: aMethodNode selector) ifTrue: [^self]].
	first := aMethodNode selectorParts first sourceInterval.
	last := aMethodNode argumentCount > 0
				ifTrue: [aMethodNode arguments last sourceInterval]
				ifFalse: [first].
	self
		signalError: CWarnRestrictedSelector
		forNode: aMethodNode
		range: (first start to: last stop)
		extras: {aMethodNode selector}!

checkSupersend: aMessageNode
	methodClass superclass isNil
		ifTrue: [^self signalError: CErrUndeclared forNode: aMessageNode receiver]!

checkTryBlock: aMessageNode
	"Private - Warning if an exception guarded statement (i.e. a block sent #on:do:+) does not
	appear to be correctly formed, or is using the deprecated VSE form with a niladic handler
	block."

	| args |
	aMessageNode receiver isBlock
		ifFalse: 
			["If the receiver is not a block, we can't make any assumptions about how it might implement on:do:+"
			^self].
	"Some quick checks to eliminate non-on:do: messages"
	(aMessageNode isKeyword
		and: [aMessageNode selectorParts size even and: [aMessageNode selector beginsWith: #on:do:]])
			ifFalse: [^self].
	((#on:do: split: aMessageNode selector) anySatisfy: [:each | each notEmpty]) ifTrue: [^self].
	"Message is of the form on:do:+, so check receiver and handler args"
	self checkMessageHasNiladicBlockReceiver: aMessageNode.
	args := aMessageNode arguments.
	2 to: args size
		by: 2
		do: [:i | self checkIsLiteralBlockHandler: (args at: i) forMessage: aMessageNode]!

compilationErrorClass
	^Parser notificationClass!

countOuterTemps
	| scope count |
	scope := self currentScope.
	count := 0.
	[scope outer notNil and: [scope isInlined]] whileTrue: 
			[scope := scope outer.
			count := count + scope localCount].
	^count!

currentScope
	^currentScope!

errorAssignConstant: anStVariableNode
	anStVariableNode variable isArgument
		ifTrue: 
			[self
				signalError: CErrAssignmentToArgument
				forNode: anStVariableNode parent
				extra: anStVariableNode name]
		ifFalse: 
			[self
				signalError: CErrAssignConstant
				forNode: anStVariableNode parent
				extra: anStVariableNode name].
	^nil!

errorBlock: aMonadicValuable
	"Set the <monadicValuable> that is evaluated for any semantic errors (not warnings) detected while analysing the AST.
	The argument will be a CompilerErrorNotification. If the block returns, then the error will be signalled, but as these 
	are resumable the analysis can recover and continue in order to detect any further errors."

	errorBlock := aMonadicValuable!

initialize
	super initialize.
	scopes := OrderedCollection new.
	literals := IdentitySet new.
	stringLiterals := Set new.
	addToFrame := [:literal | self addToFrame: literal].
	inStaticExpression := false!

isReceiverOfNilTest: aVariableNode 
	| parentNode |
	parentNode := aVariableNode parent.
	^parentNode isMessage and: 
			[parentNode receiver == aVariableNode and: 
					[#(#notNil #isNil #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:) 
						identityIncludes: parentNode selector]]!

isTempVariable: anStVariableNode
	"Private - Answer whether the specified variable node represents one of the temporaries in
	the parse tree (note that parameters are included)."

	^self tempDecls includes: anStVariableNode!

lineOfSourcePosition: position 
	| line stream |
	stream := methodNode source readStream.
	line := 1.
	[stream atEnd not and: [stream position < position]] 
		whileTrue: [stream next == $\n ifTrue: [line := line + 1]].
	^line!

newLiteralsCollection
	^IdentityDictionary new!

pushActiveFrame
	!

pushImmediate: anInteger!

pushSelf
!

pushSuper
!

readStaticVariable: aStVariableNode
	self accessStaticVariable: aStVariableNode!

removeScope
	^currentScope := currentScope outer!

restrictedSelectors
	^RestrictedSelectors!

scopes
	^scopes!

setMethodNode: aStMethodNode methodClass: aClass context: anObject pools: anArray errorBlock: aMonadicValuable
	methodNode := aStMethodNode.
	methodClass := aClass.
	evaluationContext := anObject.
	currentScope := StClassScope methodClass: aClass.
	anArray isEmpty
		ifFalse: 
			[evalScope := (StEvalScope pools: anArray)
						outer: currentScope;
						yourself.
			currentScope := evalScope].
	errorBlock := aMonadicValuable!

signalError: anInteger forNode: aNode 
	^self 
		signalError: anInteger
		forNode: aNode
		extras: #()!

signalError: anInteger forNode: aNode extra: anObject
	^self
		signalError: anInteger
		forNode: aNode
		extras: {anObject}!

signalError: anInteger forNode: aNode extras: anArray 
	^self 
		signalError: anInteger
		forNode: aNode
		range: aNode sourceInterval
		extras: anArray!

signalError: codeInteger forNode: anStProgramNode range: anInterval extras: anArray
	| source position err |
	source := methodNode source.
	position := anStProgramNode startWithoutParentheses.
	err := self compilationErrorClass
				code: codeInteger
				in: source
				for: methodClass
				selector: methodNode selector
				position: position
				line: (self lineOfSourcePosition: position)
				range: anInterval
				extras: anArray.
	"Warnings are not passed to the error block"
	(err severityClass == Error and: [errorBlock notNil]) ifTrue: [errorBlock value: err].
	"If the error block returns, then the exception is signalled"
	^err signal!

tempDecls
	^tempDecls ifNil: [tempDecls := methodNode allDefinedVariableNodes]!

visitAnnotationNode: anStAnnotationNode
	self annotations add: {anStAnnotationNode selector. anStAnnotationNode arguments}!

visitArgumentNode: anStParameterNode
	self checkRedefines: anStParameterNode.
	self currentScope declareArgument: anStParameterNode!

visitArgumentNodes: aNodeCollection
	| count max |
	aNodeCollection isEmpty ifTrue: [^self].
	count := self countOuterTemps.
	max := VMConstants.MaxTemps.
	aNodeCollection do: 
			[:each |
			self visitArgumentNode: each.
			count := count + 1.
			count > max
				ifTrue: 
					[self
						signalError: CErrTooManyTemps
						forNode: each
						extra: each name]]!

visitAssignmentNode: anStAssignmentNode
	| variableNode |
	self visitNode: anStAssignmentNode value.
	variableNode := anStAssignmentNode variable.
	variableNode isConstantNode ifTrue: [^self].
	self assignVariable: variableNode!

visitBlockNode: aBlockNode
	currentScope := scopes addLast: (StBlockScope forScopeNode: aBlockNode outer: currentScope).
	self blockDepth > VMConstants.MaxBlockNesting
		ifTrue: [self signalError: CErrBlockNestingTooDeep forNode: aBlockNode].
	self processBlock: aBlockNode.
	self removeScope!

visitExternalArgTypeNode: anStExternalArgTypeNode
	anStExternalArgTypeNode structClass
		ifNotNil: 
			[:structVar |
			(self bindVariable: structVar)
				ifNotNil: 
					[:static |
					| structClass |
					structClass := static binding value.
					(structClass class isMeta and: [structClass isBytes or: [structClass instSize >= 1]])
						ifTrue: 
							[| indirections |
							indirections := anStExternalArgTypeNode indirections.
							indirections == 0
								ifTrue: 
									[structClass isNonInstantiable
										ifTrue: 
											[self
												signalError: CErrInvalidStructArg
												forNode: anStExternalArgTypeNode
												extra: structClass]]
								ifFalse: 
									[(structClass isIndirection and: [indirections > 1])
										ifTrue: 
											[self
												signalError: CErrNotIndirectable
												forNode: anStExternalArgTypeNode
												extra: structClass]]]
						ifFalse: 
							[self
								signalError: CErrInvalidStructArg
								forNode: anStExternalArgTypeNode
								extra: structClass]]].
	^super visitExternalArgTypeNode: anStExternalArgTypeNode!

visitExternalCallNode: anStExternalCallNode
	self currentScope
		declareLocalVariable: (StGeneratedTempVariable node: (StTempDeclNode named: '_failureCode')).
	super visitExternalCallNode: anStExternalCallNode!

visitLiteralArrayNode: aLiteralArrayNode
	"We don't want to visit the individual elements"

	!

visitLiteralNode: aLiteralNode
	addToFrame value: aLiteralNode!

visitMessageNode: aMessageNode
	"Process a message send (check for wrong argument types for optimized messages, etc)"

	| receiver |
	super visitMessageNode: aMessageNode.
	self addMessageToFrame: aMessageNode.
	self checkMessageArgumentCount: aMessageNode.
	self checkOptimizedMessages: aMessageNode.
	receiver := aMessageNode receiver.
	receiver isSuperVariable ifTrue: [self checkSupersend: aMessageNode].
	self checkTryBlock: aMessageNode!

visitMethodNode: aMethodNode
	self checkRestrictedSelectors: aMethodNode.
	currentScope := scopes addLast: (StMethodScope forScopeNode: aMethodNode outer: currentScope).
	super visitMethodNode: aMethodNode.
	self checkAnnotations: aMethodNode.
	self removeScope!

visitOptimizedNode: anOptimizedNode
	| wasInStaticExpression outerAddToFrame outerScopes outerCurrentScope |
	outerAddToFrame := addToFrame.
	outerCurrentScope := currentScope.
	outerScopes := scopes.
	(wasInStaticExpression := inStaticExpression)
		ifFalse: 
			["If entering a static expression the scope is different (static expressions
			 are compiled in the context of the class side), and only some literals are
			 retained in the frame."
			addToFrame := [:literal | self addToFrameStatic: literal].
			currentScope := StClassScope
						methodClass: (methodClass isMeta ifTrue: [methodClass] ifFalse: [methodClass class]).
			scopes := OrderedCollection new].
	currentScope := scopes addLast: (StMethodScope forScopeNode: anOptimizedNode outer: currentScope).
	inStaticExpression := true.
	[super visitOptimizedNode: anOptimizedNode] ensure: 
			[self removeScope.
			inStaticExpression := wasInStaticExpression.
			addToFrame := outerAddToFrame.
			currentScope := outerCurrentScope.
			scopes := outerScopes]!

visitPrimitiveNode: anStPrimitiveNode
	self currentScope declareLocalVariable: (StGeneratedTempVariable
				node: (anStPrimitiveNode errorTemp ifNil: [StTempDeclNode named: '_failureCode']))!

visitReturnNode: aReturnNode
	currentScope markFarReturn.
	^super visitReturnNode: aReturnNode!

visitSelfVariableNode: anStSelfVariableNode
	self visitVariableNode: anStSelfVariableNode.
	currentScope markNeedsSelf!

visitSequenceNode: aSequenceNode
	| answer scope |
	answer := super visitSequenceNode: aSequenceNode.
	scope := self currentScope.
	scope temporaries do: 
			[:each |
			| reads writes |
			reads := each reads.
			writes := each writes.
			writes isEmpty
				ifTrue: 
					["Not Written..."
					reads isEmpty
						ifTrue: [self signalError: CWarnUnreferencedTemp forNode: each node]
						ifFalse: [self signalError: CWarnReadNotWritten forNode: reads first]]
				ifFalse: 
					["Written..."
					reads isEmpty ifTrue: [self signalError: CWarnWrittenNotRead forNode: writes first]]].
	^answer!

visitSuperVariableNode: anStSuperVariableNode
	self visitVariableNode: anStSuperVariableNode.
	currentScope markNeedsSelf!

visitTempDeclNode: anStTempDeclNode
	self checkRedefines: anStTempDeclNode.
	self currentScope declareTemp: anStTempDeclNode!

visitTemporaryNodes: aNodeCollection
	| count |
	aNodeCollection isEmpty ifTrue: [^self].
	count := self countOuterTemps + self currentScope argumentCount.
	aNodeCollection do: 
			[:each |
			self visitNode: each.
			(count := count + 1) > VMConstants.MaxTemps
				ifTrue: 
					[self
						signalError: CErrTooManyTemps
						forNode: each
						extra: each name]]!

visitVariableNode: aStVariableNode
	(self bindVariable: aStVariableNode)
		ifNotNil: 
			[:var |
			var addRead: aStVariableNode fromScope: currentScope.
			var isTempVariable
				ifTrue: 
					[#todo.	"Report read-before-written after visiting entire AST and only if the temp is written somewhere, i.e. if read-not-written, should not get read-before-written warning."
					(var writes isEmpty and: [(self isReceiverOfNilTest: aStVariableNode) not])
						ifTrue: [self signalError: CWarnReadBeforeWritten forNode: aStVariableNode]]
				ifFalse: [var isStaticVariable ifTrue: [self readStaticVariable: aStVariableNode]]]! !
!Kernel.StSemanticAnalyser categoriesFor: #accessStaticVariable:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #addLiteral:value:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #addMessageToFrame:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #addToFrame:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #addToFrameStatic:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #annotations!accessing!private! !
!Kernel.StSemanticAnalyser categoriesFor: #assignStaticVariable:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #assignVariable:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #bindVariable:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #blockDepth!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkAnnotations:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkIsLiteralBlockHandler:forMessage:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkLiteralFrameSize:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkMessage:hasMonadicBlockArg:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkMessage:hasNiladicBlockArg:code:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkMessage:hasNiladicOrMonadicBlockArg:code:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkMessage:hasNonEmptyNiladicBlockArg:code:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkMessageArgumentCount:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkMessageHasNiladicBlockReceiver:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkMessageHasNonEmptyNiladicBlockReceiver:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkOptimizedKeywordMessages:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkOptimizedMessages:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkOptimizedUnaryMessages:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkRedefines:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkRestrictedSelectors:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkSupersend:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #checkTryBlock:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #compilationErrorClass!constants!private! !
!Kernel.StSemanticAnalyser categoriesFor: #countOuterTemps!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #currentScope!accessing!private! !
!Kernel.StSemanticAnalyser categoriesFor: #errorAssignConstant:!error handling!private! !
!Kernel.StSemanticAnalyser categoriesFor: #errorBlock:!accessing!private! !
!Kernel.StSemanticAnalyser categoriesFor: #initialize!initializing!public! !
!Kernel.StSemanticAnalyser categoriesFor: #isReceiverOfNilTest:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #isTempVariable:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #lineOfSourcePosition:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #newLiteralsCollection!helpers!initializing!private! !
!Kernel.StSemanticAnalyser categoriesFor: #pushActiveFrame!instructions-stack ops!private! !
!Kernel.StSemanticAnalyser categoriesFor: #pushImmediate:!instructions-stack ops!private! !
!Kernel.StSemanticAnalyser categoriesFor: #pushSelf!instructions-stack ops!private! !
!Kernel.StSemanticAnalyser categoriesFor: #pushSuper!instructions-stack ops!private! !
!Kernel.StSemanticAnalyser categoriesFor: #readStaticVariable:!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #removeScope!helpers!private! !
!Kernel.StSemanticAnalyser categoriesFor: #restrictedSelectors!constants!private! !
!Kernel.StSemanticAnalyser categoriesFor: #scopes!accessing!public! !
!Kernel.StSemanticAnalyser categoriesFor: #setMethodNode:methodClass:context:pools:errorBlock:!initializing!private! !
!Kernel.StSemanticAnalyser categoriesFor: #signalError:forNode:!error handling!private! !
!Kernel.StSemanticAnalyser categoriesFor: #signalError:forNode:extra:!error handling!private! !
!Kernel.StSemanticAnalyser categoriesFor: #signalError:forNode:extras:!error handling!private! !
!Kernel.StSemanticAnalyser categoriesFor: #signalError:forNode:range:extras:!error handling!private! !
!Kernel.StSemanticAnalyser categoriesFor: #tempDecls!accessing!private! !
!Kernel.StSemanticAnalyser categoriesFor: #visitAnnotationNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitArgumentNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitArgumentNodes:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitAssignmentNode:!public!visitor/double dispatching! !
!Kernel.StSemanticAnalyser categoriesFor: #visitBlockNode:!public!visitor/double dispatching! !
!Kernel.StSemanticAnalyser categoriesFor: #visitExternalArgTypeNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitExternalCallNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitLiteralArrayNode:!public!visitor/double dispatching! !
!Kernel.StSemanticAnalyser categoriesFor: #visitLiteralNode:!public!visitor/double dispatching! !
!Kernel.StSemanticAnalyser categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !
!Kernel.StSemanticAnalyser categoriesFor: #visitMethodNode:!public!visitor/double dispatching! !
!Kernel.StSemanticAnalyser categoriesFor: #visitOptimizedNode:!public!visitor/double dispatching! !
!Kernel.StSemanticAnalyser categoriesFor: #visitPrimitiveNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitReturnNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitSelfVariableNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitSequenceNode:!public!visitor/double dispatching! !
!Kernel.StSemanticAnalyser categoriesFor: #visitSuperVariableNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitTempDeclNode:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitTemporaryNodes:!public!visiting! !
!Kernel.StSemanticAnalyser categoriesFor: #visitVariableNode:!public!visitor/double dispatching! !

!Kernel.StSemanticAnalyser class methodsFor!

analyzeParseTree: aParseTree for: aClass context: anObject pools: anArray onError: aMonadicValuable
	| methodNode |
	methodNode := aParseTree isMethod ifTrue: [aParseTree] ifFalse: [aParseTree methodNode].
	^self new
		setMethodNode: methodNode
			methodClass: aClass
			context: anObject
			pools: anArray
			errorBlock: aMonadicValuable;
		visitNode: methodNode!

initialize
	" self initialize "

	| boolean optimizedMessages restrictedSelectors |
	optimizedMessages := IdentityDictionary new.
	boolean := #(#and: #or: #not #ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:).
	optimizedMessages
		at: Object
			put: #(#~~ #== #basicAt: #basicAt:put: #basicClass #basicSize #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil: #yourself);
		at: UndefinedObject put: #(#ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:);
		at: true class put: boolean;
		at: false class put: boolean;
		at: Boolean put: boolean;
		at: Number put: #(#to:do: #to:by:do:);
		at: Integer put: #(#timesRepeat:);
		at: SmallInteger put: #(#basicAt: #basicAt:put: #basicSize);
		at: Process put: #(#basicAt:put:);
		at: Behavior put: #(#basicNew:);
		at: ProtoObject put: #(#basicClass #basicSize #==);
		at: Character put: #(#basicSize);
		yourself.
	self addClassConstant: 'OptimizedMessages' value: optimizedMessages.
	restrictedSelectors := IdentitySet new.
	optimizedMessages do: [:each | restrictedSelectors addAll: each].
	self addClassConstant: 'RestrictedSelectors' value: restrictedSelectors.
	self addClassConstant: 'SpecialSelectors' value: VMLibrary default specialSelectors! !
!Kernel.StSemanticAnalyser class categoriesFor: #analyzeParseTree:for:context:pools:onError:!accessing!public! !
!Kernel.StSemanticAnalyser class categoriesFor: #initialize!development!initializing!public! !

