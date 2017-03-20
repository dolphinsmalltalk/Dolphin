"Filed out from Dolphin Smalltalk 7"!

StParseNodeAnalyzer subclass: #StSemanticAnalyser
	instanceVariableNames: 'isStub'
	classVariableNames: ''
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
StSemanticAnalyser guid: (GUID fromString: '{590e979a-62f2-4b0e-9722-469cfb549990}')!
StSemanticAnalyser comment: 'StSemanticAnalyser is a <StParseNodeVisitor> that performs checks for semantic errors (e.g. referencing an undeclared variable, sending an unimplemented message, etc) against a parse tree. It is used for dynamic error highlighting in the browsers. Most of the issues are reported as warnings, since they may not definitely be errors. The <SmalltalkParser> itself detects some actual semantic errors.'!
!StSemanticAnalyser categoriesForClass!System-Compiler! !
!StSemanticAnalyser methodsFor!

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
	(Smalltalk developmentSystem allSelectors includes: selector)
		ifFalse: 
			[self
				signalError: CWarnUndefinedSelector
				forNode: aStMessageNode
				extra: selector]!

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

initialize
	isStub := false.
	^super initialize!

pushStatic: aVariableNode variable: aVariableBinding
	(aVariableBinding value == true class or: [aVariableBinding value == false class])
		ifTrue: 
			[self
				signalError: CWarnUsesBooleanClass
				forNode: aVariableNode
				extra: aVariableBinding key asLowercase]!

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
			[self currentScope unreferencedArguments
				do: [:each | self signalError: CInfoUnreferencedArg forNode: each]].
	^answer! !
!StSemanticAnalyser categoriesFor: #checkHardBreakpoint:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkIfStubMessage:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkSupersend:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkUnimplemented:!helpers!private! !
!StSemanticAnalyser categoriesFor: #checkUnimplementedSubclassResponsibility:!helpers!private! !
!StSemanticAnalyser categoriesFor: #initialize!initializing!public! !
!StSemanticAnalyser categoriesFor: #pushStatic:variable:!helpers!instructions-stack ops!private! !
!StSemanticAnalyser categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !
!StSemanticAnalyser categoriesFor: #visitSequenceNode:!public!visitor/double dispatching! !

