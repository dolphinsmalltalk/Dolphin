"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring subclass: #'Refactory.Browser.ClassRefactoring'
	instanceVariableNames: 'className'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassRefactoring guid: (Core.GUID fromString: '{50c0a330-c04d-4855-a513-f97929846e0f}')!
Refactory.Browser.ClassRefactoring comment: ''!
!Refactory.Browser.ClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ClassRefactoring methodsFor!

className
	^className!

className: aString 
	className := aString asSymbol!

environment
	^self className asQualifiedReference environment!

environment: aNamespace
	self className: (aNamespace fullNameFor: self unqualifiedClassName)!

nameForReferenceToClass: aRBClass fromNode: aStProgramNode
	"Private - Answer the shortest name for the RBClass first argument that will bind to that class from the method of which the StProgramNode 2nd argument is part. The RBClass already has its target name.
	As noted in RenameNamespacedClassRefactory>>buildParseTreeRewriter, this is currently a hack that will sometimes use a fully-qualified name when it is not actually required, but a correct implementation really requires a proper RB model of the Namespace hierarchy."

	| unqualifiedName methodClass |
	methodClass := aStProgramNode methodNode methodClass.
	unqualifiedName := aRBClass unqualifiedName.
	methodClass == aRBClass
		ifTrue: 
			["A method of the renamed class itself, which is self-referential"
			^unqualifiedName].
	^methodClass environment == aRBClass environment
		ifTrue: 
			["The method's environment is the same, we can definitely use the unqualified name"
			unqualifiedName]
		ifFalse: 
			[| found |
			"We can also use the unqualified name if it can be bound using the unqualified name from the method."
			#namespaceToDo.	"Does not take account of method customEnvironments. Is the use of the old unqualified name correct here?"
			found := methodClass fullBindingFor: unqualifiedName.
			(found notNil and: [found value = aRBClass]) ifTrue: [unqualifiedName] ifFalse: [aRBClass fullName]]!

unqualifiedClassName
	^className asQualifiedReference unqualifiedName!

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

model: aRBNamespace className: aName 
	^(self new)
		model: aRBNamespace;
		className: aName;
		yourself! !
!Refactory.Browser.ClassRefactoring class categoriesForMethods!
className:!instance creation!public! !
model:className:!instance creation!public! !
!

