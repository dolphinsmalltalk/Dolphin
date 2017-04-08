"Filed out from Dolphin Smalltalk 7"!

StParseNodeVisitor subclass: #StParseNodeAnalyzer
	instanceVariableNames: 'methodNode methodClass evaluationContext currentScope scopes literals stringLiterals addToFrame tempDecls inStaticExpression evalScope'
	classVariableNames: 'OptimizedMessages RestrictedSelectors SpecialSelectors'
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
StParseNodeAnalyzer guid: (GUID fromString: '{3922cac3-8a81-45a8-adb3-2795a6e7bc2f}')!
StParseNodeAnalyzer comment: ''!
!StParseNodeAnalyzer categoriesForClass!System-Compiler! !
!StParseNodeAnalyzer methodsFor!

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
	value isImmediate ifTrue: [^self].
	value isString
		ifTrue: [(value isSymbol not and: [(stringLiterals addNewElement: value) not]) ifTrue: [^self]]
		ifFalse: [(value == true or: [value == false or: [value isNil]]) ifTrue: [^self]].
	self addLiteral: aLiteralNode value: value!

addToFrameStatic: aLiteralNode
	| value |
	value := aLiteralNode value.
	"When parsing static expressions we record all the symbols, literal arrays, and variables
	that are referenced in the static expression so that these can be searched on later."
	(value isSymbol or: [(value isKindOf: Array) or: [value isKindOf: VariableBinding]])
		ifFalse: [^self].
	self addLiteral: aLiteralNode value: value!

assignStaticVariable: anStVariableNode
	self accessStaticVariable: anStVariableNode!

assignVariable: anStVariableNode
	^(self bindVariable: anStVariableNode)
		ifNotNil: 
			[:var |
			var isConstant
				ifTrue: [self errorAssignConstant: anStVariableNode]
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
						extras: (Array with: aStMessageNode selector)]]
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
		range: aMessageNode selectorParts first sourceInterval
		extras: (Array with: aMessageNode selector).
	^false!

checkOptimizedKeywordMessages: aMessageNode
	| selector arguments argc |
	arguments := aMessageNode arguments.
	argc := arguments size.
	argc > 3 ifTrue: [^false].
	selector := aMessageNode selector.
	argc == 1
		ifTrue: 
			[(#(#ifTrue: #ifFalse: #and: #or: #ifNil: #timesRepeat:) identityIncludes: selector)
				ifTrue: 
					[^self
						checkMessage: aMessageNode
						hasNiladicBlockArg: arguments first
						code: CWarnExpectNiladicBlockArg].
			(selector == #whileTrue: or: [selector == #whileFalse:])
				ifTrue: 
					[^(self checkMessageHasNiladicBlockReceiver: aMessageNode) and: 
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
	selector = #to:by:do:
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
	^(selector == #whileTrue or: [selector == #whileFalse or: [selector == #repeat]]) 
		and: [self checkMessageHasNiladicBlockReceiver: aMessageNode]!

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
		extras: (Array with: aMethodNode selector)!

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
	((aMessageNode selector subStrings: #on:do:) anySatisfy: [:each | each notEmpty]) ifTrue: [^self].
	"Message is of the form on:do:+, so check receiver and handler args"
	self checkMessageHasNiladicBlockReceiver: aMessageNode.
	args := aMessageNode arguments.
	2 to: args size
		by: 2
		do: [:i | self checkIsLiteralBlockHandler: (args at: i) forMessage: aMessageNode]!

compilationErrorClass
	^SmalltalkParser notificationClass!

countOuterTemps
	| scope count |
	scope := self currentScope.
	count := 0.
	[scope outer notNil and: [scope isInlined]] whileTrue: 
			[scope := scope outer.
			count := count + scope localCount].
	^count!

currentMethodClass
	^inStaticExpression 
		ifTrue: [methodClass isMeta ifTrue: [methodClass] ifFalse: [methodClass class]]
		ifFalse: [methodClass]!

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

initialize
	super initialize.
	scopes := OrderedCollection new.
	literals := IdentityDictionary new.
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

setMethodNode: aStMethodNode methodClass: aClass context: anObject pools: anArray
	methodNode := aStMethodNode.
	methodClass := aClass.
	evaluationContext := anObject.
	currentScope := StClassScope methodClass: aClass.
	anArray isEmpty
		ifFalse: 
			[evalScope := (StEvalScope pools: anArray)
						outer: currentScope;
						yourself.
			currentScope := evalScope]!

signalError: anInteger forNode: aNode 
	^self 
		signalError: anInteger
		forNode: aNode
		extras: #()!

signalError: anInteger forNode: aNode extra: anObject 
	^self 
		signalError: anInteger
		forNode: aNode
		extras: (Array with: anObject)!

signalError: anInteger forNode: aNode extras: anArray 
	^self 
		signalError: anInteger
		forNode: aNode
		range: aNode sourceInterval
		extras: anArray!

signalError: codeInteger forNode: anStProgramNode range: anInterval extras: anArray 
	| source position |
	source := methodNode source.
	position := anStProgramNode startWithoutParentheses.
	^(self compilationErrorClass 
		code: codeInteger
		in: source
		for: methodClass
		selector: methodNode selector
		position: position
		line: (self lineOfSourcePosition: position)
		range: anInterval
		extras: anArray) signal!

tempDecls
	tempDecls ifNil: [tempDecls := methodNode allDefinedVariableNodes].
	^tempDecls!

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
	self removeScope!

visitOptimizedNode: anOptimizedNode
	| wasInStaticExpression outerAddToFrame |
	outerAddToFrame := addToFrame.
	(wasInStaticExpression := inStaticExpression)
		ifFalse: [addToFrame := [:literal | self addToFrameStatic: literal]].
	inStaticExpression := true.
	[super visitOptimizedNode: anOptimizedNode] ensure: 
			[inStaticExpression := wasInStaticExpression.
			addToFrame := outerAddToFrame]!

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

visitTemporaryNode: anStTempDeclNode
	self checkRedefines: anStTempDeclNode.
	self currentScope declareTemp: anStTempDeclNode!

visitTemporaryNodes: aNodeCollection
	| count |
	aNodeCollection isEmpty ifTrue: [^self].
	count := self countOuterTemps + self currentScope argumentCount.
	aNodeCollection do: 
			[:each |
			self visitTemporaryNode: each.
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
					[(var writes isEmpty and: [(self isReceiverOfNilTest: aStVariableNode) not])
						ifTrue: [self signalError: CWarnReadBeforeWritten forNode: aStVariableNode]]
				ifFalse: [var isStaticVariable ifTrue: [self readStaticVariable: aStVariableNode]]]! !
!StParseNodeAnalyzer categoriesFor: #accessStaticVariable:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addLiteral:value:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addMessageToFrame:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addToFrame:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addToFrameStatic:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #assignStaticVariable:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #assignVariable:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #bindVariable:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #blockDepth!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkIsLiteralBlockHandler:forMessage:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkLiteralFrameSize:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessage:hasMonadicBlockArg:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessage:hasNiladicBlockArg:code:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessage:hasNiladicOrMonadicBlockArg:code:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessageArgumentCount:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessageHasNiladicBlockReceiver:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkOptimizedKeywordMessages:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkOptimizedMessages:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkOptimizedUnaryMessages:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkRedefines:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkRestrictedSelectors:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkSupersend:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkTryBlock:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #compilationErrorClass!constants!private! !
!StParseNodeAnalyzer categoriesFor: #countOuterTemps!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #currentMethodClass!accessing!private! !
!StParseNodeAnalyzer categoriesFor: #currentScope!accessing!private! !
!StParseNodeAnalyzer categoriesFor: #errorAssignConstant:!error handling!private! !
!StParseNodeAnalyzer categoriesFor: #initialize!initializing!public! !
!StParseNodeAnalyzer categoriesFor: #isReceiverOfNilTest:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #isTempVariable:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #lineOfSourcePosition:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #newLiteralsCollection!helpers!initializing!private! !
!StParseNodeAnalyzer categoriesFor: #pushActiveFrame!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushImmediate:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushSelf!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushSuper!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #readStaticVariable:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #removeScope!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #restrictedSelectors!constants!private! !
!StParseNodeAnalyzer categoriesFor: #scopes!accessing!public! !
!StParseNodeAnalyzer categoriesFor: #setMethodNode:methodClass:context:pools:!initializing!private! !
!StParseNodeAnalyzer categoriesFor: #signalError:forNode:!error handling!private! !
!StParseNodeAnalyzer categoriesFor: #signalError:forNode:extra:!error handling!private! !
!StParseNodeAnalyzer categoriesFor: #signalError:forNode:extras:!error handling!private! !
!StParseNodeAnalyzer categoriesFor: #signalError:forNode:range:extras:!error handling!private! !
!StParseNodeAnalyzer categoriesFor: #tempDecls!accessing!private! !
!StParseNodeAnalyzer categoriesFor: #visitArgumentNode:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitArgumentNodes:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitAssignmentNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitBlockNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitLiteralArrayNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitLiteralNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitMethodNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitOptimizedNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitReturnNode:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitSelfVariableNode:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitSequenceNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitSuperVariableNode:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitTemporaryNode:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitTemporaryNodes:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitVariableNode:!public!visitor/double dispatching! !

!StParseNodeAnalyzer class methodsFor!

analyzeParseTree: aParseTree for: aClass context: anObject pools: anArray
	| methodNode |
	methodNode := aParseTree isMethod ifTrue: [aParseTree] ifFalse: [aParseTree methodNode].
	^(self new)
		setMethodNode: methodNode
			methodClass: aClass
			context: anObject
			pools: anArray;
		visitNode: methodNode!

initialize
	" self initialize "

	| boolean |
	OptimizedMessages := IdentityDictionary new.
	boolean := #(#and: #or: #not #ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:).
	OptimizedMessages
		at: Object
			put: #(#~~ #== #basicAt: #basicAt:put: #basicClass #basicSize #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil: #yourself);
		at: UndefinedObject put: #(#ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:);
		at: True put: boolean;
		at: False put: boolean;
		at: Boolean put: boolean;
		at: Number put: #(#to:do: #to:by:do:);
		at: Integer put: #(#timesRepeat:);
		at: SmallInteger put: #(#basicAt: #basicAt:put: #basicSize);
		at: Process put: #(#basicAt:put:);
		at: Behavior put: #(#basicNew:);
		at: ProtoObject put: #(#basicClass #basicSize #==);
		at: Character put: #(#basicSize);
		yourself.
	OptimizedMessages isImmutable: true.
	RestrictedSelectors := IdentitySet new.
	OptimizedMessages do: [:each | RestrictedSelectors addAll: each].
	RestrictedSelectors isImmutable: true.
	self addClassConstant: 'SpecialSelectors' value: VMLibrary default specialSelectors! !
!StParseNodeAnalyzer class categoriesFor: #analyzeParseTree:for:context:pools:!accessing!public! !
!StParseNodeAnalyzer class categoriesFor: #initialize!public! !

