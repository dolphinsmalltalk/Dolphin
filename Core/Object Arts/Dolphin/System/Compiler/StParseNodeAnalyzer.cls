"Filed out from Dolphin Smalltalk 7"!

StParseNodeVisitor subclass: #StParseNodeAnalyzer
	instanceVariableNames: 'methodNode scopeStack methodClass scopeDepth evaluationContext evaluationPools literals stringLiterals addToFrame tempDecls inStaticExpression'
	classVariableNames: 'OptimizedMessages RestrictedSelectors SpecialSelectors'
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
StParseNodeAnalyzer guid: (GUID fromString: '{3922CAC3-8A81-45A8-ADB3-2795A6E7BC2F}')!
StParseNodeAnalyzer addClassConstant: 'SpecialSelectors' value: #(#+ #- #< #> #<= #>= #= #~= #* #/ #\\ #bitShift: #// #bitAnd: #bitOr: #== #value #value: #class #size #new #new: #at: #at:put: #value:value: #basicNew: #basicClass #basicSize #basicAt: #basicAt:put: #isNil #notNil)!
StParseNodeAnalyzer comment: ''!
!StParseNodeAnalyzer categoriesForClass!System-Compiler! !
!StParseNodeAnalyzer methodsFor!

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

checkRedefines: aVariableNode
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
	(OptimizedMessages at: methodClass ifAbsent: [])
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
	inStaticExpression := false!

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

pushConst: anObject
	!

pushImmediate: anInteger!

pushInstVar: aVariableNode
	!

pushSelf
!

pushStatic: aVariableNode variable: aVariableBinding
	!

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

storeStatic: aVariableNode variable: aVariableBinding
	!

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
										extra: identifier]
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
	((methodClass fullBindingFor: identifier) ifNil: [self contextBindingFor: identifier])
		ifNil: [self signalError: CErrUndeclared forNode: aVariableNode]
		ifNotNil: 
			[:var |
			self addLiteral: aVariableNode value: var.
			aBoolean
				ifTrue: 
					[var isImmutable
						ifTrue: [self errorAssignConstant: aVariableNode]
						ifFalse: [self storeStatic: aVariableNode variable: var]]
				ifFalse: [self pushStatic: aVariableNode variable: var]]!

visitArgumentNodes: aNodeCollection
	| count max |
	aNodeCollection isEmpty ifTrue: [^self].
	count := self countOuterTemps.
	max := VMConstants.MaxTemps.
	aNodeCollection do: 
			[:each |
			self checkRedefines: each.
			count := count + 1.
			count > max
				ifTrue: 
					[self
						signalError: CErrTooManyTemps
						forNode: each
						extra: each name]]!

visitAssignmentNode: anAssignmentNode
	self visitNode: anAssignmentNode value.
	self varRef: anAssignmentNode variable isAssignment: true!

visitBlockNode: aBlockNode
	| inlined |
	self createScope: aBlockNode.
	inlined := aBlockNode isInlined.
	inlined ifFalse: [scopeDepth := scopeDepth + 1].
	scopeDepth > VMConstants.MaxBlockNesting
		ifTrue: [self signalError: CErrBlockNestingTooDeep forNode: aBlockNode].
	self processBlock: aBlockNode.
	self removeScope.
	inlined ifFalse: [scopeDepth := scopeDepth - 1]!

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
	(receiver isVariable and: [receiver name = 'super']) ifTrue: [self checkSupersend: aMessageNode].
	self checkTryBlock: aMessageNode!

visitMethodNode: aMethodNode
	self checkRestrictedSelectors: aMethodNode.
	self createScope: aMethodNode.
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

visitSequenceNode: aSequenceNode
	| answer scope |
	answer := super visitSequenceNode: aSequenceNode.
	scope := self currentScope.
	aSequenceNode temporaries do: 
			[:each |
			| firstWritten firstRead nodes |
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

visitTemporaryNodes: aNodeCollection
	| max count scope |
	aNodeCollection isEmpty ifTrue: [^self].
	scope := self currentScope.
	max := VMConstants.MaxTemps.
	count := self countOuterTemps + scope argumentCount.
	aNodeCollection do: 
			[:each |
			| identifier |
			self checkRedefines: each.
			identifier := each name.
			scope addTemp: identifier.
			count := count + 1.
			count > max
				ifTrue: 
					[self
						signalError: CErrTooManyTemps
						forNode: each
						extra: identifier]]!

visitVariableNode: aVariableNode
	self varRef: aVariableNode isAssignment: false! !
!StParseNodeAnalyzer categoriesFor: #addLiteral:value:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addMessageToFrame:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addToFrame:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #addToFrameStatic:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #bindingFor:!helpers!private! !
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
!StParseNodeAnalyzer categoriesFor: #pushStatic:variable:!instructions-stack ops!private! !
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
!StParseNodeAnalyzer categoriesFor: #storeStatic:variable:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #storeTemp:!instructions-stack ops!private! !
!StParseNodeAnalyzer categoriesFor: #targetOfMessage:!commands!private!refactoring! !
!StParseNodeAnalyzer categoriesFor: #tempDecls!accessing!private! !
!StParseNodeAnalyzer categoriesFor: #varRef:isAssignment:!helpers!private! !
!StParseNodeAnalyzer categoriesFor: #visitArgumentNodes:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitAssignmentNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitBlockNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitLiteralArrayNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitLiteralNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitMethodNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitOptimizedNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitSequenceNode:!public!visitor/double dispatching! !
!StParseNodeAnalyzer categoriesFor: #visitTemporaryNodes:!public!visiting! !
!StParseNodeAnalyzer categoriesFor: #visitVariableNode:!public!visitor/double dispatching! !

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
	self addClassConstant: 'SpecialSelectors' value: VMLibrary default specialSelectors! !
!StParseNodeAnalyzer class categoriesFor: #initialize!public! !

