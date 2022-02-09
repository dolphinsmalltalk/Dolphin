"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring subclass: #'Refactory.Browser.ClassRefactoring'
	instanceVariableNames: 'className'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassRefactoring guid: (Core.GUID fromString: '{50c0a330-c04d-4855-a513-f97929846e0f}')!
Refactory.Browser.ClassRefactoring isNonInstantiable: true!
Refactory.Browser.ClassRefactoring comment: ''!
!Refactory.Browser.ClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ClassRefactoring methodsFor!

className
	^className pathString!

className: aString
	className := FullBindingReference fullPathString: aString!

environment
	^className environment!

environment: aNamespace
	self className: (aNamespace fullNameFor: self unqualifiedClassName)!

nameForReferenceToClass: aRBClass fromNode: aStProgramNode
	"Private - Answer the shortest name for the RBClass first argument that will bind to that class from the method of which the StProgramNode 2nd argument is part. The RBClass already has its target name."

	| methodNode |
	methodNode := aStProgramNode methodNode.
	^methodNode environment == aRBClass environment
		ifTrue: 
			["The method's environment is the same, we can definitely use the unqualified name"
			aRBClass unqualifiedName]
		ifFalse: 
			[| unqualified binding |
			"We can also use the unqualified name if it can be bound using the unqualified name from the method."
			binding := methodNode fullBindingFor: (unqualified := aRBClass unqualifiedName).
			(binding notNil and: [binding refersToClass: aRBClass])
				ifTrue: [unqualified]
				ifFalse: [aRBClass fullName]]!

unqualifiedClassName
	^className unqualifiedName!

unqualifiedClassName: aSymbol
	self className: (self environment fullNameFor: aSymbol)! !
!Refactory.Browser.ClassRefactoring categoriesForMethods!
className!accessing!public! !
className:!accessing!public! !
environment!accessing!public! !
environment:!accessing!public! !
nameForReferenceToClass:fromNode:!private!transforming! !
unqualifiedClassName!accessing!public! !
unqualifiedClassName:!accessing!public! !
!

!Refactory.Browser.ClassRefactoring class methodsFor!

className: aName
	^self new className: aName!

model: aRBModel className: aName
	^self new
		model: aRBModel;
		className: aName;
		yourself! !
!Refactory.Browser.ClassRefactoring class categoriesForMethods!
className:!instance creation!public! !
model:className:!instance creation!public! !
!

