"Filed out from Dolphin Smalltalk 7"!

StParseNodeVisitor subclass: #StParseNodeAnalyzer
	instanceVariableNames: 'methodNode scopeStack methodClass scopeDepth evaluationContext evaluationPools literals literalCount stringLiterals addToFrame tempDecls isStub inStaticExpression'
	classVariableNames: 'OptimizedMessages RestrictedSelectors SpecialSelectors'
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
StParseNodeAnalyzer guid: (GUID fromString: '{3922CAC3-8A81-45A8-ADB3-2795A6E7BC2F}')!
StParseNodeAnalyzer comment: ''!
!StParseNodeAnalyzer categoriesForClass!System-Compiler! !
!StParseNodeAnalyzer methodsFor!

acceptAssignmentNode: anAssignmentNode 
	self visitNode: anAssignmentNode value.
	self varRef: anAssignmentNode variable isAssignment: true!

acceptBlockNode: aBlockNode
	| inlined |
	self createScope: aBlockNode.
	inlined := aBlockNode isInlined.
	inlined ifFalse: [scopeDepth := scopeDepth + 1].
	scopeDepth > VMConstants.MaxBlockNesting
		ifTrue: [self signalError: CErrBlockNestingTooDeep forNode: aBlockNode].
	self processBlock: aBlockNode.
	self removeScope.
	inlined ifFalse: [scopeDepth := scopeDepth - 1]!

acceptLiteralArrayNode: aLiteralArrayNode
	"We don't want to visit the individual elements"!

acceptLiteralNode: aLiteralNode 
	addToFrame value: aLiteralNode.!

acceptMessageNode: aMessageNode
	"Process a message send (check for wrong argument types for optimized messages, etc)"

	super acceptMessageNode: aMessageNode.
	self addMessageToFrame: aMessageNode.
	self checkIfStubMessage: aMessageNode.
	self checkOptimizedMessages: aMessageNode.
	self checkSupersend: aMessageNode.
	self checkMessageArgumentCount: aMessageNode.
	self checkTryBlock: aMessageNode!

acceptMethodNode: aMethodNode 
	self checkRestrictedSelectors: aMethodNode.
	self createScope: aMethodNode.
	super acceptMethodNode: aMethodNode.
	self removeScope!

acceptOptimizedNode: anOptimizedNode
	| wasInStaticExpression outerAddToFrame |
	outerAddToFrame := addToFrame.
	(wasInStaticExpression := inStaticExpression)
		ifFalse: [addToFrame := [:literal | self addToFrameStatic: literal]].
	inStaticExpression := true.
	[super acceptOptimizedNode: anOptimizedNode] ensure: 
			[inStaticExpression := wasInStaticExpression.
			addToFrame := outerAddToFrame]!

acceptSequenceNode: aSequenceNode 
	| answer scope nodes |
	answer := super acceptSequenceNode: aSequenceNode.
	scope := self currentScope.
	isStub 
		ifFalse: 
			[scope unreferencedArguments do: [:each | self signalError: CInfoUnreferencedArg forNode: each]].
	aSequenceNode temporaries do: 
			[:each | 
			| firstWritten firstRead |
			nodes := scope refsToTemp: each name.
			firstWritten := nodes first.
			firstRead := nodes second.
			firstWritten 
				ifNil: 
					["Not Written..."
					firstRead 
						ifNil: [self signalError: CWarnUnreferencedTemp forNode: each]
						ifNotNil: [self signalError: CWarnReadNotWritten forNode: firstRead]]
				ifNotNil: 
					["Written..."
					nodes second ifNil: [self signalError: CWarnWrittenNotRead forNode: firstWritten]]].
	^answer!

acceptVariableNode: aVariableNode 
	self varRef: aVariableNode isAssignment: false!

addLiteral: aLiteralNode
	(literals addNewElement: aLiteralNode value) ifTrue: [self checkLiteralFrameSize: aLiteralNode]!

addMessageToFrame: aMessageNode
	| selector |
	selector := aMessageNode selector.
	"Special selectors such as #== are not added to the literal frame. These have special
	bytecodes which can be used to find senders."
	(SpecialSelectors includes: selector) ifTrue: [^self].
	self addLiteral: aMessageNode!

addToFrame: aLiteralNode
	| value |
	value := aLiteralNode value.
	value isImmediate ifTrue: [^self].
	value isString
		ifTrue: [(value isSymbol not and: [(stringLiterals addNewElement: value) not]) ifTrue: [^self]]
		ifFalse: [(value == true or: [value == false or: [value isNil]]) ifTrue: [^self]].
	self addLiteral: aLiteralNode!

addToFrameStatic: aLiteralNode
	| value |
	value := aLiteralNode value.
	"When parsing static expressions we record all the symbols, literal arrays, and variables
	that are referenced in the static expression so that these can be searched on later."
	(value isSymbol or: [(value isKindOf: Array) or: [value isKindOf: VariableBinding]])
		ifFalse: [^self].
	self addLiteral: aLiteralNode!

bindingFor: aStVariableNode
	| identifier |
	identifier := aStVariableNode name.
	(self isTempVariable: aStVariableNode)
		ifTrue: 
			["If hosted in the debugger can make a stab at these"
			^self contextBindingFor: identifier].
	((evaluationContext isKindOf: methodClass) and: [self isInstVar: identifier])
		ifTrue: 
			["In the debugger will have an evaluation context which is the receiver."

			"Concoct a fake variable binding"
			^(VariableBinding key: identifier value: (evaluationContext instVarNamed: identifier))
				isImmutable: evaluationContext isImmutable;
				yourself].
	^methodClass fullBindingFor: identifier!

checkIfStubMessage: aStMessageNode
	(aStMessageNode isUnary and: 
			[#(#subclassResponsibility #shouldNotImplement #notYetImplemented)
				identityIncludes: aStMessageNode selector])
		ifTrue: [isStub := true]!

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

checkLiteralFrameSize: aLiteralNode
	literals size > VMConstants.MaxLiterals
		ifTrue: 
			[self
				signalError: CErrTooManyLiterals
				forNode: aLiteralNode
				extra: aLiteralNode value]!

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

checkMessage: aStMessageNode hasNiladicBlockArg: aStProgramNode isError: aBoolean 
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
			[| code |
			code := aBoolean ifTrue: [CErrExpectLiteralBlock] ifFalse: [CWarnExpectNiladicBlockArg].
			self 
				signalError: code
				forNode: aStProgramNode
				extra: aStMessageNode selector].
	^false!

checkMessage: aStMessageNode hasNiladicOrMonadicBlockArg: aStProgramNode isError: aBoolean 
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
			[| code |
			code := aBoolean ifTrue: [CErrExpectLiteralBlock] ifFalse: [CWarnExpectMonadicOrNiladicBlockArg].
			self 
				signalError: code
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
						isError: false].
			(selector == #whileTrue: or: [selector == #whileFalse:])
				ifTrue: 
					[^(self checkMessageHasNiladicBlockReceiver: aMessageNode) and: 
							[self
								checkMessage: aMessageNode
								hasNiladicBlockArg: arguments first
								isError: false]].
			selector == #ifNotNil:
				ifTrue: 
					[^self
						checkMessage: aMessageNode
						hasNiladicOrMonadicBlockArg: arguments first
						isError: false].
			^false].
	(#ifTrue:ifFalse: == selector or: [selector == #ifFalse:ifTrue:])
		ifTrue: 
			[^(self
				checkMessage: aMessageNode
				hasNiladicBlockArg: arguments first
				isError: false) and: 
						[self
							checkMessage: aMessageNode
							hasNiladicBlockArg: arguments second
							isError: false]].
	selector == #ifNil:ifNotNil:
		ifTrue: 
			[^(self
				checkMessage: aMessageNode
				hasNiladicBlockArg: arguments first
				isError: false) and: 
						[self
							checkMessage: aMessageNode
							hasNiladicOrMonadicBlockArg: arguments second
							isError: true]].
	selector == #ifNotNil:ifNil:
		ifTrue: 
			[^(self
				checkMessage: aMessageNode
				hasNiladicOrMonadicBlockArg: arguments first
				isError: false) and: 
						[self
							checkMessage: aMessageNode
							hasNiladicBlockArg: arguments second
							isError: true]].
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

checkRedefines: aVariableNode isArg: aBoolean
	| identifier |
	identifier := aVariableNode name.
	(methodClass fullBindingFor: identifier)
		ifNotNil: 
			[self signalError: CWarnRedefiningStatic forNode: aVariableNode.
			^self].
	(self isInstVar: identifier)
		ifTrue: 
			[self signalError: CWarnRedefiningInstVar forNode: aVariableNode.
			^self].
	"Don''t need to check for duplicate temps/args at the same scope, because the parser has
	already done that as an error check. Note that we interpret the ANSI standard as stating that
	duplicate temporary/argument names at the same scope are not permitted (which is certainly
	true), but that duplicate names in nested scopes (i.e. temps/args that shadow outer temps)
	are permitted (which seems appropriate), but for which we issue a warning."
	scopeStack size - 1 to: 1
		by: -1
		do: 
			[:i |
			| scope |
			scope := scopeStack at: i.
			(scope includesArg: identifier)
				ifTrue: [self signalError: CWarnRedefiningArg forNode: aVariableNode]
				ifFalse: 
					[(scope includesTemp: identifier)
						ifTrue: [self signalError: CWarnRedefiningTemp forNode: aVariableNode]]]!

checkRestrictedSelectors: aMethodNode 
	| last first |
	(self restrictedSelectors identityIncludes: aMethodNode selector) ifFalse: [^self].
	OptimizedMessages at: methodClass
		ifPresent: [:selectors | (selectors identityIncludes: aMethodNode selector) ifTrue: [^self]].
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
	| receiver |
	receiver := aMessageNode receiver.
	(receiver isVariable and: [receiver name = 'super']) ifFalse: [^self].
	methodClass superclass isNil ifTrue: [^self signalError: CErrUndeclared forNode: receiver].
	aMessageNode selector == methodNode selector 
		ifFalse: 
			[self 
				signalError: CInfoSupersendsOther
				forNode: aMessageNode
				extra: aMessageNode selector]!

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

contextBindingFor: aString 
	evaluationPools do: [:each | (each bindingFor: aString) ifNotNil: [:binding | ^binding]].
	^nil!

countOuterTemps
	| i scope count |
	i := scopeStack size.
	scope := scopeStack at: i.
	count := 0.
	[i > 1 and: [scope isInlined]] whileTrue: 
			[i := i - 1.
			scope := scopeStack at: i.
			count := count + scope argumentCount + scope tempCount].
	^count!

createScope: aNode 
	^scopeStack add: (StLexicalScope forScopeNode: aNode)!

currentMethodClass
	^inStaticExpression 
		ifTrue: [methodClass isMeta ifTrue: [methodClass] ifFalse: [methodClass class]]
		ifFalse: [methodClass]!

currentScope
	^scopeStack last!

errorAssignConstant: aVariableNode
	self
		signalError: CErrAssignConstant
		forNode: aVariableNode parent
		extra: aVariableNode name.
	^nil!

initialize
	super initialize.
	scopeStack := OrderedCollection new.
	scopeDepth := 0.
	literals := IdentityDictionary new.
	stringLiterals := Set new.
	addToFrame := [:literal | self addToFrame: literal].
	inStaticExpression := isStub := false.
	literalCount := 0!

isInstVar: aString
	^(methodClass indexOfInstVar: aString ifAbsent: [0]) > 0!

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

	self tempDecls do: [:each | each = anStVariableNode ifTrue: [^true]].
	^false!

lineOfSourcePosition: position 
	| line stream |
	stream := methodNode source readStream.
	line := 1.
	[stream atEnd not and: [stream position < position]] 
		whileTrue: [stream next == Character lf ifTrue: [line := line + 1]].
	^line!

newLiteralsCollection
	^IdentityDictionary new!

pushActiveFrame
	!

pushConst: anObject
	!

pushImmediate: anInteger!

pushInstVar: aVariableNode
	!

pushSelf
!

pushStatic: aVariableNode!

pushSuper
!

pushTemp: aVariableNode
	!

removeScope
	^scopeStack removeLast!

restrictedSelectors
	^RestrictedSelectors!

setMethodNode: aStMethodNode methodClass: aClass context: anObject pools: anArray
	methodNode := aStMethodNode.
	methodClass := aClass.
	evaluationContext := anObject.
	evaluationPools := anArray!

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

storeInstVar: aVariableNode
	!

storeStatic: aVariableNode!

storeTemp: aVariableNode
!

targetOfMessage: aStMessageNode 
	| receiver |
	receiver := aStMessageNode receiver.
	receiver isVariable 
		ifTrue: 
			[| identifier |
			identifier := receiver name.
			identifier = 'self' ifTrue: [^self currentMethodClass].
			identifier = 'super' ifTrue: [^self currentMethodClass superclass].
			identifier = 'thisContext' ifTrue: [^Integer].
			(self bindingFor: receiver) 
				ifNotNil: 
					[:var | 
					"In the case of other variables, we can only offer a
					variable type with confidence (without resort to type
					inference) if the variable binding is constant. If it isn't
					then the variable could assume different types through the
					course of the method or even across different invocations
					(if a global, or class variable). This might cause false
					reports of unimplemented messages in the debugger. Therefore
					we have to be conservative here in suggesting the variable
					type."
					var isImmutable ifTrue: [^var value basicClass]].
			^nil].
	receiver isLiteralNode ifTrue: [^aStMessageNode receiver value basicClass].
	^nil!

tempDecls
	tempDecls ifNil: [tempDecls := methodNode allDefinedVariableNodes].
	^tempDecls!

varRef: aVariableNode isAssignment: aBoolean
	| identifier |
	identifier := aVariableNode name.
	identifier = 'self'
		ifTrue: [^aBoolean ifTrue: [self errorAssignConstant: aVariableNode] ifFalse: [self pushSelf]].
	identifier = 'super'
		ifTrue: [^aBoolean ifTrue: [self errorAssignConstant: aVariableNode] ifFalse: [self pushSuper]].
	identifier = 'thisContext'
		ifTrue: [^aBoolean ifTrue: [self errorAssignConstant: aVariableNode] ifFalse: [self pushActiveFrame]].
	scopeStack size to: 1
		by: -1
		do: 
			[:i |
			| scope |
			scope := scopeStack at: i.
			(scope refsToTemp: identifier)
				ifNil: 
					[(scope referenceArg: identifier)
						ifTrue: 
							[^aBoolean
								ifTrue: 
									[self
										signalError: CErrAssignmentToArgument
										forNode: aVariableNode parent
										extra: identifier.
									nil]
								ifFalse: [self pushTemp: aVariableNode]]]
				ifNotNil: 
					[:nodes |
					^aBoolean
						ifTrue: 
							[nodes first ifNil: [nodes at: 1 put: aVariableNode].
							self storeTemp: aVariableNode]
						ifFalse: 
							[nodes second
								ifNil: 
									[nodes at: 2 put: aVariableNode.
									(nodes first isNil and: [(self isReceiverOfNilTest: aVariableNode) not])
										ifTrue: [self signalError: CWarnReadBeforeWritten forNode: aVariableNode]
										ifFalse: [self pushTemp: aVariableNode]]]]].
	(self isInstVar: identifier)
		ifTrue: 
			[^aBoolean ifTrue: [self storeInstVar: aVariableNode] ifFalse: [self pushInstVar: aVariableNode]].
	^(methodClass fullBindingFor: identifier)
		ifNil: 
			[(evaluationPools anySatisfy: [:each | each includesKey: identifier])
				ifTrue: [^aBoolean ifTrue: [self storeStatic: aVariableNode] ifFalse: [self pushStatic: aVariableNode]]
				ifFalse: [self signalError: CErrUndeclared forNode: aVariableNode]]
		ifNotNil: 
			[:var |
			aBoolean
				ifTrue: 
					[var isImmutable
						ifTrue: [self errorAssignConstant: aVariableNode]
						ifFalse: [self storeStatic: aVariableNode]]
				ifFalse: 
					[(var value == true class or: [var value == false class])
						ifTrue: 
							[self
								signalError: CWarnUsesBooleanClass
								forNode: aVariableNode
								extra: identifier asLowercase].
					self pushStatic: aVariableNode]]!

visitArguments: aNodeCollection 
	| count max |
	aNodeCollection isEmpty ifTrue: [^self].
	count := self countOuterTemps.
	max := VMConstants.MaxTemps.
	aNodeCollection do: 
			[:each | 
			self checkRedefines: each isArg: true.
			count := count + 1.
			count > max 
				ifTrue: 
					[self 
						signalError: CErrTooManyTemps
						forNode: each
						extra: each name]]!

visitTempDecls: aNodeCollection 
	| max count scope |
	aNodeCollection isEmpty ifTrue: [^self].
	scope := self currentScope.
	max := VMConstants.MaxTemps.
	count := self countOuterTemps + scope argumentCount.
	aNodeCollection do: 
			[:each | 
			| identifier |
			self checkRedefines: each isArg: false.
			identifier := each name.
			scope addTemp: identifier.
			count := count + 1.
			count > max 
				ifTrue: 
					[self 
						signalError: CErrTooManyTemps
						forNode: each
						extra: identifier]]! !
!StParseNodeAnalyzer categoriesFor: #acceptAssignmentNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #acceptBlockNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #acceptLiteralArrayNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #acceptLiteralNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #acceptMessageNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #acceptMethodNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #acceptOptimizedNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #acceptSequenceNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #acceptVariableNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #addLiteral:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addMessageToFrame:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addToFrame:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addToFrameStatic:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #bindingFor:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkIfStubMessage:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkIsLiteralBlockHandler:forMessage:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkLiteralFrameSize:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessage:hasMonadicBlockArg:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessage:hasNiladicBlockArg:isError:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessage:hasNiladicOrMonadicBlockArg:isError:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessageArgumentCount:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkMessageHasNiladicBlockReceiver:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkOptimizedKeywordMessages:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkOptimizedMessages:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkOptimizedUnaryMessages:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkRedefines:isArg:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkRestrictedSelectors:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkSupersend:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #checkTryBlock:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #compilationErrorClass!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #contextBindingFor:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #countOuterTemps!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #createScope:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #currentMethodClass!commands!private!refactoring! !
!StParseNodeAnalyzer categoriesFor: #currentScope!accessing!private! !
!StParseNodeAnalyzer categoriesFor: #errorAssignConstant:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #initialize!initializing!public! !
!StParseNodeAnalyzer categoriesFor: #isInstVar:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #isReceiverOfNilTest:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #isTempVariable:!private!refactoring! !
!StParseNodeAnalyzer categoriesFor: #lineOfSourcePosition:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #newLiteralsCollection!helpers!initializing!private! !
!StParseNodeAnalyzer categoriesFor: #pushActiveFrame!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushConst:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #pushImmediate:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushInstVar:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushSelf!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushStatic:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushSuper!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #pushTemp:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #removeScope!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #restrictedSelectors!constants!private! !
!StParseNodeAnalyzer categoriesFor: #setMethodNode:methodClass:context:pools:!initializing!private! !
!StParseNodeAnalyzer categoriesFor: #signalError:forNode:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #signalError:forNode:extra:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #signalError:forNode:extras:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #signalError:forNode:range:extras:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #storeInstVar:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #storeStatic:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #storeTemp:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #targetOfMessage:!commands!private!refactoring! !
!StParseNodeAnalyzer categoriesFor: #tempDecls!accessing!private! !
!StParseNodeAnalyzer categoriesFor: #varRef:isAssignment:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #visitArguments:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitTempDecls:!public!visiting! !

!StParseNodeAnalyzer class methodsFor!

initialize
	" self initialize "

	| boolean |
	OptimizedMessages := IdentityDictionary new.
	boolean := #(#and: #or: #ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:).
	OptimizedMessages
		at: Object
			put: #(#== #basicAt: #basicAt:put: #basicClass #basicSize #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil: #yourself);
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
	SpecialSelectors := VMLibrary default specialSelectors asIdentitySet.
	SpecialSelectors isImmutable: true! !
!StParseNodeAnalyzer class categoriesFor: #initialize!public! !

