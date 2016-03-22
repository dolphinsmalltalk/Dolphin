"Filed out from Dolphin Smalltalk 7"!

StParseNodeVisitor subclass: #StSemanticAnalyser
	instanceVariableNames: 'methodNode scopeStack methodClass instVars scopeDepth evaluationContext evaluationPools literals stringLiterals addToFrame tempDecls isStub inStaticExpression'
	classVariableNames: 'OptimizedMessages RestrictedSelectors SpecialSelectors'
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
StSemanticAnalyser guid: (GUID fromString: '{590E979A-62F2-4B0E-9722-469CFB549990}')!
StSemanticAnalyser comment: 'StSemanticAnalyser is a <StParseNodeVisitor> that performs checks for semantic errors (e.g. referencing an undeclared variable, sending an unimplemented message, etc) against a parse tree. It is used for dynamic error highlighting in the browsers. Most of the issues are reported as warnings, since they may not definitely be errors. The <SmalltalkParser> itself detects some actual semantic errors.'!
!StSemanticAnalyser categoriesForClass!System-Compiler! !
!StSemanticAnalyser methodsFor!

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
	super acceptBlockNode: aBlockNode.
	self removeScope.
	inlined ifFalse: [scopeDepth := scopeDepth - 1]!

acceptLiteralArrayNode: aLiteralArrayNode
	"We don't want to visit the individual elements"!

acceptLiteralNode: aLiteralNode 
	addToFrame value: aLiteralNode.!

acceptMessageNode: aMessageNode 
	"Process a message send (check for unimplemented selectors)"

	super acceptMessageNode: aMessageNode.
	self checkUnimplemented: aMessageNode.
	self checkUnimplementedSubclassResponsibility: aMessageNode.
	(self checkOptimizedMessages: aMessageNode) ifFalse: [self addMessageToFrame: aMessageNode].
	self checkSupersend: aMessageNode.
	self checkMessageArgumentCount: aMessageNode.
	self checkHardBreakpoint: aMessageNode.
	self checkIfStubMessage: aMessageNode.
	self checkTryBlock: aMessageNode!

acceptMethodNode: aMethodNode 
	self checkRestrictedSelectors: aMethodNode.
	self createScope: aMethodNode.
	super acceptMethodNode: aMethodNode.
	self removeScope!

acceptOptimizedNode: anOptimizedNode 
	| wasInStaticExpression |
	addToFrame := [:literal | self addToFrameStatic: literal].
	wasInStaticExpression := inStaticExpression.
	inStaticExpression := true.
	[super acceptOptimizedNode: anOptimizedNode] ensure: 
			[inStaticExpression := wasInStaticExpression.
			addToFrame := [:literal | self addToFrame: literal]]!

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

addMessageToFrame: aMessageNode 
	| selector |
	selector := aMessageNode selector.
	(SpecialSelectors identityIncludes: selector) ifTrue: [^self].
	literals add: selector.
	self tooManyLiterals 
		ifTrue: 
			[self 
				signalError: CErrTooManyLiterals
				forNode: aMessageNode
				extra: aMessageNode selector]!

addToFrame: aLiteralNode 
	| value |
	value := aLiteralNode value.
	value isInteger 
		ifTrue: 
			[(value between: -32768 and: 32767) ifTrue: [^self].
			literals add: value].
	value isString 
		ifTrue: [value isSymbol ifTrue: [literals add: value] ifFalse: [stringLiterals add: value]]
		ifFalse: 
			[(value == true or: [value == false or: [value == nil or: [value class == Character]]]) 
				ifTrue: [^self].
			literals add: value].
	self tooManyLiterals 
		ifTrue: 
			[self 
				signalError: CErrTooManyLiterals
				forNode: aLiteralNode
				extra: value]!

addToFrameStatic: aLiteralNode 
	| value |
	value := aLiteralNode value.
	(value isSymbol or: [(value isKindOf: Array) or: [value isKindOf: VariableBinding]]) 
		ifFalse: [^self].
	literals add: value.
	self tooManyLiterals 
		ifTrue: 
			[self 
				signalError: CErrTooManyLiterals
				forNode: aLiteralNode
				extra: value]!

bindingFor: aStVariableNode 
	| identifier |
	identifier := aStVariableNode name.
	(self isTempVariable: aStVariableNode) 
		ifTrue: 
			["If hosted in the debugger can make a stab at these"
			^self contextBindingFor: identifier].
	((evaluationContext isKindOf: methodClass) and: [instVars includes: identifier]) 
		ifTrue: 
			["In the debugger will have an evaluation context which is the receiver."

			"Concoct a fake variable binding"
			^(VariableBinding key: identifier value: (evaluationContext instVarNamed: identifier))
				isImmutable: evaluationContext isImmutable;
				yourself].
	^methodClass fullBindingFor: identifier!

checkHardBreakpoint: aStMessageNode 
	aStMessageNode selector == #halt 
		ifTrue: [self signalError: CInfoHardBreakpoint forNode: aStMessageNode]!

checkIfStubMessage: aStMessageNode 
	(aStMessageNode isUnary and: 
			[#(#subclassResponsibility #shouldNotImplement #notYetImplemented) includes: aStMessageNode selector]) 
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
	| selector arguments |
	arguments := aMessageNode arguments.
	selector := aMessageNode selector.
	(#(#ifTrue: #ifFalse: #and: #or: #ifNil: #timesRepeat:) identityIncludes: selector) 
		ifTrue: 
			[^self 
				checkMessage: aMessageNode
				hasNiladicBlockArg: arguments first
				isError: false].
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
	(instVars includes: identifier) 
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

checkUnimplemented: aStMessageNode 
	| selector |
	selector := aStMessageNode selector.
	(self targetOfMessage: aStMessageNode) 
		ifNotNil: 
			[:receiverClass | 
			(receiverClass canUnderstand: selector) 
				ifFalse: 
					[| receiver |
					receiver := aStMessageNode receiver.
					"Could be a reflexive self-send (i.e. a recursive call) that
					is not yet defined"
					(receiverClass == methodClass and: [selector = methodNode selector]) 
						ifFalse: 
							[self 
								signalError: CWarnMsgUnimplemented
								forNode: aStMessageNode
								extras: (Array 
										with: selector
										with: (receiver isVariable ifTrue: [receiver name] ifFalse: ['literal'])
										with: receiverClass)]].
			^self].
	(SmalltalkSystem current allSelectors includes: selector) 
		ifFalse: 
			[self 
				signalError: CWarnUndefinedSelector
				forNode: aStMessageNode
				extra: selector.
			^self]!

checkUnimplementedSubclassResponsibility: aStMessageNode 
	"Private - Warn for any leaf classes that don't implement the subclass responsibility?"

	| selector |
	aStMessageNode selector == #subclassResponsibility ifFalse: [^self].
	selector := methodNode selector.
	methodClass allSubclassesDo: 
			[:class | 
			(class subclasses isEmpty and: [(class whichClassIncludesSelector: selector) == methodClass]) 
				ifTrue: 
					[self 
						signalError: CWarnUnimplementedAbstractMethod
						forNode: aStMessageNode
						extras: (Array 
								with: methodClass
								with: selector
								with: class)]]!

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

initialize
	super initialize.
	scopeStack := OrderedCollection new.
	scopeDepth := 0.
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

	self tempDecls do: [:each | each = anStVariableNode ifTrue: [^true]].
	^false!

lineOfSourcePosition: position 
	| line stream |
	stream := methodNode source readStream.
	line := 1.
	[stream atEnd not and: [stream position < position]] 
		whileTrue: [stream next == Character lf ifTrue: [line := line + 1]].
	^line!

removeScope
	^scopeStack removeLast!

restrictedSelectors
	^RestrictedSelectors!

setMethodNode: aStMethodNode methodClass: aClass context: anObject pools: anArray 
	methodNode := aStMethodNode.
	methodClass := aClass.
	instVars := methodClass allInstVarNames.
	evaluationContext := anObject.
	evaluationPools := anArray.
	isStub := false!

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

tooManyLiterals
	^literals size + stringLiterals size > VMConstants.MaxLiterals!

varRef: aVariableNode isAssignment: aBoolean 
	| identifier |
	identifier := aVariableNode name.
	(#('self' 'super' 'thisContext') includes: identifier) 
		ifTrue: 
			[aBoolean 
				ifTrue: 
					[self 
						signalError: CErrAssignConstant
						forNode: aVariableNode parent
						extra: identifier].
			^self].
	scopeStack reverseDo: 
			[:each | 
			(each refsToTemp: identifier) 
				ifNil: 
					[(each referenceArg: identifier) 
						ifTrue: 
							[aBoolean 
								ifTrue: 
									[self 
										signalError: CErrAssignmentToArgument
										forNode: aVariableNode parent
										extra: identifier].
							^self]]
				ifNotNil: 
					[:nodes | 
					aBoolean 
						ifTrue: [nodes first ifNil: [nodes at: 1 put: aVariableNode]]
						ifFalse: 
							[nodes second 
								ifNil: 
									[nodes at: 2 put: aVariableNode.
									(nodes first isNil and: [(self isReceiverOfNilTest: aVariableNode) not]) 
										ifTrue: [self signalError: CWarnReadBeforeWritten forNode: aVariableNode]]].
					^self]].
	(instVars includes: identifier) ifTrue: [^self].
	(methodClass fullBindingFor: identifier) 
		ifNil: 
			[(evaluationPools anySatisfy: [:each | each includesKey: identifier]) ifTrue: [^self].
			self signalError: CErrUndeclared forNode: aVariableNode]
		ifNotNil: 
			[:var | 
			(aBoolean and: [var isImmutable]) 
				ifTrue: 
					[self 
						signalError: CErrAssignConstant
						forNode: aVariableNode parent
						extra: identifier].
			(var == (methodClass environment bindingFor: #True) or: [var == (methodClass environment bindingFor: #False)]) 
				ifTrue: 
					[self 
						signalError: CWarnUsesBooleanClass
						forNode: aVariableNode
						extra: identifier asLowercase]].
	^self!

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
!StSemanticAnalyser categoriesFor: #acceptAssignmentNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #acceptBlockNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #acceptLiteralArrayNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #acceptLiteralNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #acceptMessageNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #acceptMethodNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #acceptOptimizedNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #acceptSequenceNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #acceptVariableNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #addMessageToFrame:!helpers!private! !
!StSemanticAnalyser categoriesFor: #addToFrame:!helpers!private! !
!StSemanticAnalyser categoriesFor: #addToFrameStatic:!helpers!private! !
!StSemanticAnalyser categoriesFor: #bindingFor:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkHardBreakpoint:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkIfStubMessage:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkIsLiteralBlockHandler:forMessage:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkMessage:hasMonadicBlockArg:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkMessage:hasNiladicBlockArg:isError:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkMessage:hasNiladicOrMonadicBlockArg:isError:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkMessageArgumentCount:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkMessageHasNiladicBlockReceiver:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkOptimizedKeywordMessages:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkOptimizedMessages:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkOptimizedUnaryMessages:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkRedefines:isArg:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkRestrictedSelectors:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkSupersend:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkTryBlock:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkUnimplemented:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkUnimplementedSubclassResponsibility:!helpers!private! !
!StSemanticAnalyser categoriesFor: #compilationErrorClass!helpers!private! !
!StSemanticAnalyser categoriesFor: #contextBindingFor:!helpers!private! !
!StSemanticAnalyser categoriesFor: #countOuterTemps!helpers!private! !
!StSemanticAnalyser categoriesFor: #createScope:!helpers!private! !
!StSemanticAnalyser categoriesFor: #currentMethodClass!commands!private!refactoring! !
!StSemanticAnalyser categoriesFor: #currentScope!accessing!private! !
!StSemanticAnalyser categoriesFor: #initialize!initializing!public! !
!StSemanticAnalyser categoriesFor: #isReceiverOfNilTest:!helpers!private! !
!StSemanticAnalyser categoriesFor: #isTempVariable:!private!refactoring! !
!StSemanticAnalyser categoriesFor: #lineOfSourcePosition:!helpers!private! !
!StSemanticAnalyser categoriesFor: #removeScope!private!removing! !
!StSemanticAnalyser categoriesFor: #restrictedSelectors!constants!private! !
!StSemanticAnalyser categoriesFor: #setMethodNode:methodClass:context:pools:!initializing!private! !
!StSemanticAnalyser categoriesFor: #signalError:forNode:!helpers!private! !
!StSemanticAnalyser categoriesFor: #signalError:forNode:extra:!helpers!private! !
!StSemanticAnalyser categoriesFor: #signalError:forNode:extras:!helpers!private! !
!StSemanticAnalyser categoriesFor: #signalError:forNode:range:extras:!helpers!private! !
!StSemanticAnalyser categoriesFor: #targetOfMessage:!commands!private!refactoring! !
!StSemanticAnalyser categoriesFor: #tempDecls!accessing!private! !
!StSemanticAnalyser categoriesFor: #tooManyLiterals!adding!private! !
!StSemanticAnalyser categoriesFor: #varRef:isAssignment:!helpers!private! !
!StSemanticAnalyser categoriesFor: #visitArguments:!public!visiting! !
!StSemanticAnalyser categoriesFor: #visitTempDecls:!public!visiting! !

!StSemanticAnalyser class methodsFor!

checkParseTree: aParseTree for: aClass context: anObject pools: anArray 
	| methodNode |
	methodNode := aParseTree isMethod ifTrue: [aParseTree] ifFalse: [aParseTree methodNode].
	(self new)
		setMethodNode: methodNode
			methodClass: aClass
			context: anObject
			pools: anArray;
		visitNode: methodNode!

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
!StSemanticAnalyser class categoriesFor: #checkParseTree:for:context:pools:!accessing!public! !
!StSemanticAnalyser class categoriesFor: #initialize!public! !

