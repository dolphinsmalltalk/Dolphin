"Filed out from Dolphin Smalltalk"!

Kernel.AbstractSemanticAnalyser subclass: #'Kernel.StSemanticAnalyser'
	instanceVariableNames: 'literals stringLiterals tempDecls isMutator'
	classVariableNames: 'OptimizedMessages RestrictedSelectors SpecialSelectors'
	imports: #()
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

	^(anStVariableNode lookupInScope: currentScope)
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

checkMutatorMethod: aStMethodNode
	(aStMethodNode argumentCount ~~ 1 or: 
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
											lhs := statement variable lookupInScope: currentScope.
											lhs isNil or: [lhs isInstanceVariable not]]]]]])
		ifTrue: [self signalError: CWarnMutableIgnored forNode: aStMethodNode]!

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
	var := anStVariableNode lookupInScope: currentScope.
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
	(RestrictedSelectors identityIncludes: aMethodNode selector) ifFalse: [^self].
	(OptimizedMessages lookup: self methodClass)
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
	self methodClass superclass isNil
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
	scope := currentScope.
	count := 0.
	[scope outer notNil and: [scope isInlined]] whileTrue: 
			[scope := scope outer.
			count := count + scope localCount].
	^count!

enterMethodNode: aMethodNode
	self checkRestrictedSelectors: aMethodNode.
	super enterMethodNode: aMethodNode!

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

exitMethodNode: aMethodNode
	isMutator ifTrue: [self checkMutatorMethod: aMethodNode].
	super exitMethodNode: aMethodNode!

initialize
	super initialize.
	literals := IdentitySet new.
	stringLiterals := Set new.
	isMutator := false!

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

newLiteralsCollection
	^IdentityDictionary new!

processBlock: aBlockNode
	self blockDepth > VMConstants.MaxBlockNesting
		ifTrue: [self signalError: CErrBlockNestingTooDeep forNode: aBlockNode].
	super processBlock: aBlockNode!

readStaticVariable: aStVariableNode
	self accessStaticVariable: aStVariableNode!

tempDecls
	^tempDecls ifNil: [tempDecls := methodNode allDefinedVariableNodes]!

visitAnnotationNode: anStAnnotationNode
	super visitAnnotationNode: anStAnnotationNode.
	anStAnnotationNode selector == #mutable ifTrue: [isMutator := true]!

visitArgumentNodes: aNodeCollection
	aNodeCollection isEmpty ifTrue: [^self].
	aNodeCollection inject: self countOuterTemps
		into: 
			[:count :each |
			self visitNode: each.
			count >= VMConstants.MaxTemps
				ifTrue: 
					[self
						signalError: CErrTooManyTemps
						forNode: each
						extra: each name].
			count + 1]!

visitAssignmentNode: anStAssignmentNode
	| variableNode |
	self visitNode: anStAssignmentNode value.
	variableNode := anStAssignmentNode variable.
	variableNode scope: currentScope.
	variableNode isConstantNode ifTrue: [^self].
	self assignVariable: variableNode!

visitExternalArgTypeNode: anStExternalArgTypeNode
	anStExternalArgTypeNode structClass
		ifNotNil: 
			[:structVar |
			(self bindVariable: structVar)
				ifNotNil: 
					[:static |
					| structClass |
					(static isStaticVariable and: 
							[structClass := static binding value.
							structClass class isMeta and: [structClass isBytes or: [structClass instSize >= 1]]])
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
								extra: structVar]].
			self visitNode: structVar]!

visitLiteralArrayNode: aLiteralArrayNode
	"We don't want to visit the individual elements"

	!

visitLiteralNode: aLiteralNode
	| value |
	value := aLiteralNode value.
	inStaticExpression
		ifTrue: 
			["When parsing static expressions we record all the symbols, literal arrays, and variables that are referenced in the static expression so that these can be searched on later."
			(value isSymbol or: [(value isKindOf: Array) or: [value isKindOf: VariableBinding]])
				ifFalse: [^self]]
		ifFalse: 
			[(VMLibrary hasBytecodeRepresentation: value) ifTrue: [^self].
			value isString
				ifTrue: [(value isSymbol not and: [(stringLiterals addNewElement: value) not]) ifTrue: [^self]]].
	self addLiteral: aLiteralNode value: value!

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

visitParameterNode: anStParameterNode
	self checkRedefines: anStParameterNode.
	super visitParameterNode: anStParameterNode!

visitReturnNode: aReturnNode
	currentScope markFarReturn.
	^super visitReturnNode: aReturnNode!

visitSelfVariableNode: anStSelfVariableNode
	self visitVariableNode: anStSelfVariableNode.
	currentScope markNeedsSelf!

visitSequenceNode: aSequenceNode
	| answer |
	answer := super visitSequenceNode: aSequenceNode.
	currentScope temporaries do: 
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
	super visitTempDeclNode: anStTempDeclNode!

visitTemporaryNodes: aNodeCollection
	aNodeCollection isEmpty ifTrue: [^self].
	aNodeCollection inject: self countOuterTemps + currentScope argumentCount
		into: 
			[:count :each |
			self visitNode: each.
			count >= VMConstants.MaxTemps
				ifTrue: 
					[self
						signalError: CErrTooManyTemps
						forNode: each
						extra: each name].
			count + 1]!

visitVariableNode: aStVariableNode
	(self bindVariable: aStVariableNode)
		ifNotNil: 
			[:var |
			(inTag and: [var isStaticVariable not])
				ifTrue: [self signalError: CErrExpectAnnotationArg forNode: aStVariableNode].
			var addRead: aStVariableNode fromScope: currentScope.
			var isTempVariable
				ifTrue: 
					[#todo.	"Report read-before-written after visiting entire AST and only if the temp is written somewhere, i.e. if read-not-written, should not get read-before-written warning."
					(var writes isEmpty and: [(self isReceiverOfNilTest: aStVariableNode) not])
						ifTrue: [self signalError: CWarnReadBeforeWritten forNode: aStVariableNode]]
				ifFalse: [var isStaticVariable ifTrue: [self readStaticVariable: aStVariableNode]]]! !
!Kernel.StSemanticAnalyser categoriesForMethods!
accessStaticVariable:!helpers!private! !
addLiteral:value:!helpers!private! !
addMessageToFrame:!helpers!private! !
assignStaticVariable:!helpers!private! !
assignVariable:!helpers!private! !
bindVariable:!helpers!private! !
blockDepth!helpers!private! !
checkIsLiteralBlockHandler:forMessage:!helpers!private! !
checkLiteralFrameSize:!helpers!private! !
checkMessage:hasMonadicBlockArg:!helpers!private! !
checkMessage:hasNiladicBlockArg:code:!helpers!private! !
checkMessage:hasNiladicOrMonadicBlockArg:code:!helpers!private! !
checkMessage:hasNonEmptyNiladicBlockArg:code:!helpers!private! !
checkMessageArgumentCount:!helpers!private! !
checkMessageHasNiladicBlockReceiver:!helpers!private! !
checkMessageHasNonEmptyNiladicBlockReceiver:!helpers!private! !
checkMutatorMethod:!helpers!private! !
checkOptimizedKeywordMessages:!helpers!private! !
checkOptimizedMessages:!helpers!private! !
checkOptimizedUnaryMessages:!helpers!private! !
checkRedefines:!helpers!private! !
checkRestrictedSelectors:!helpers!private! !
checkSupersend:!helpers!private! !
checkTryBlock:!helpers!private! !
compilationErrorClass!constants!private! !
countOuterTemps!helpers!private! !
enterMethodNode:!helpers!private! !
errorAssignConstant:!error handling!private! !
exitMethodNode:!helpers!private! !
initialize!initializing!public! !
isReceiverOfNilTest:!helpers!private! !
isTempVariable:!helpers!private! !
newLiteralsCollection!helpers!initializing!private! !
processBlock:!helpers!private! !
readStaticVariable:!helpers!private! !
tempDecls!accessing!private! !
visitAnnotationNode:!public!visiting! !
visitArgumentNodes:!public!visiting! !
visitAssignmentNode:!public!visitor/double dispatching! !
visitExternalArgTypeNode:!public!visiting! !
visitLiteralArrayNode:!public!visitor/double dispatching! !
visitLiteralNode:!public!visitor/double dispatching! !
visitMessageNode:!public!visitor/double dispatching! !
visitParameterNode:!public!visiting! !
visitReturnNode:!public!visiting! !
visitSelfVariableNode:!public!visiting! !
visitSequenceNode:!public!visitor/double dispatching! !
visitSuperVariableNode:!public!visiting! !
visitTempDeclNode:!public!visiting! !
visitTemporaryNodes:!public!visiting! !
visitVariableNode:!public!visitor/double dispatching! !
!

!Kernel.StSemanticAnalyser class methodsFor!

initialize
	" self initialize "

	| boolean optimizedMessages restrictedSelectors |
	optimizedMessages := IdentityDictionary new.
	boolean := #(#and: #or: #not #ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:).
	optimizedMessages
		at: Object
			put: #(#?? #~~ #== #basicAt: #basicAt:put: #basicClass #basicSize #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil: #yourself);
		at: UndefinedObject put: #(#?? #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:);
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
	self addClassConstant: 'SpecialSelectors' value: VM specialSelectors! !
!Kernel.StSemanticAnalyser class categoriesForMethods!
initialize!development!initializing!public! !
!

