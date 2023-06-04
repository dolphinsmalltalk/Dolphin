"Filed out from Dolphin Smalltalk"!

Kernel.StSemanticAnalyser
	subclass: #'Tools.BrowserSemanticAnalyser'
	instanceVariableNames: 'isStub'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.BrowserSemanticAnalyser guid: (Core.GUID fromString: '{590e979a-62f2-4b0e-9722-469cfb549990}')!
Tools.BrowserSemanticAnalyser comment: '`Tools.BrowserSemanticAnalyser` is an extended semantic analyser for use in the IDE that detects and reports some additional semantic warnings that may help with early detection of issues while coding, e.g. sending unimplemented messages, or subclass responsbilities that are not implemented in all subclasses. All of these issues are reported by SmallLint (i.e. the Code Mentor), but the browser analyser runs unobtrusively and automatically, providing more immediate feedback.'!
!Tools.BrowserSemanticAnalyser methodsFor!

checkHardBreakpoint: aStMessageNode 
	aStMessageNode selector == #halt 
		ifTrue: [self signalError: CInfoHardBreakpoint forNode: aStMessageNode]!

checkIfStubMessage: aStMessageNode
	(aStMessageNode isUnary and: 
			[#(#subclassResponsibility #shouldNotImplement #notYetImplemented)
				identityIncludes: aStMessageNode selector])
		ifTrue: [isStub := true]!

checkSupersend: aMessageNode
	super checkSupersend: aMessageNode.
	aMessageNode selector == methodNode selector
		ifFalse: 
			[self
				signalError: CInfoSupersendsOther
				forNode: aMessageNode
				extra: aMessageNode selector]!

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
					(receiverClass == self methodClass and: [selector = methodNode selector])
						ifFalse: 
							[self
								signalError: CWarnMsgUnimplemented
								forNode: aStMessageNode
								extras: {selector. receiver isVariable ifTrue: [receiver name] ifFalse: ['literal']. receiverClass}]].
			^self].
	(self methodClass model includesImplementorsOf: selector)
		ifFalse: 
			[self
				signalError: CWarnUndefinedSelector
				forNode: aStMessageNode
				extra: selector]!

checkUnimplementedSubclassResponsibility: aStMessageNode
	"Private - Warn for any leaf classes that don't implement the subclass responsibility?"

	| selector methodClass |
	aStMessageNode selector == #subclassResponsibility ifFalse: [^self].
	selector := methodNode selector.
	methodClass := self methodClass.
	methodClass allSubclassesDo: 
			[:class |
			(class subclasses isEmpty and: [(class whichClassIncludesSelector: selector) == methodClass])
				ifTrue: 
					[self
						signalError: CWarnUnimplementedAbstractMethod
						forNode: aStMessageNode
						extras: {methodClass. selector. class}]]!

contextBindingFor: aStVariableNode
	^evalScope ifNotNil: [(aStVariableNode lookupInScope: evalScope) ifNotNil: [:var | var binding]]!

initialize
	isStub := false.
	^super initialize!

readStaticVariable: aStVariableNode
	| binding |
	super readStaticVariable: aStVariableNode.
	binding := aStVariableNode variable binding.
	(binding value == true class or: [binding value == false class])
		ifTrue: 
			[self
				signalError: CWarnUsesBooleanClass
				forNode: aStVariableNode
				extra: binding key asLowercase]!

targetOfMessage: aStMessageNode
	| receiver |
	receiver := aStMessageNode receiver.
	receiver isVariable ifTrue: [^receiver variable ifNotNil: [:var | var staticValueClass]].
	receiver isLiteralNode ifTrue: [^receiver valueClass].
	^nil!

visitMessageNode: aMessageNode
	"Process a message send (check for unimplemented selectors)"

	super visitMessageNode: aMessageNode.
	self checkIfStubMessage: aMessageNode.
	self checkUnimplemented: aMessageNode.
	self checkUnimplementedSubclassResponsibility: aMessageNode.
	self checkHardBreakpoint: aMessageNode!

visitSequenceNode: aSequenceNode
	| answer |
	answer := super visitSequenceNode: aSequenceNode.
	isStub
		ifFalse: 
			[currentScope unreferencedArguments
				do: [:each | self signalError: CInfoUnreferencedArg forNode: each node]].
	^answer! !
!Tools.BrowserSemanticAnalyser categoriesForMethods!
checkHardBreakpoint:!helpers!private! !
checkIfStubMessage:!helpers!private! !
checkSupersend:!helpers!private! !
checkUnimplemented:!helpers!private! !
checkUnimplementedSubclassResponsibility:!helpers!private! !
contextBindingFor:!helpers!private! !
initialize!initializing!public! !
readStaticVariable:!helpers!private! !
targetOfMessage:!commands!private!refactoring! !
visitMessageNode:!public!visitor/double dispatching! !
visitSequenceNode:!public!visitor/double dispatching! !
!

