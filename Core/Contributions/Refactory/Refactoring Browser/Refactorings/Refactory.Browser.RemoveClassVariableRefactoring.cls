"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring
	subclass: #'Refactory.Browser.RemoveClassVariableRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RemoveClassVariableRefactoring guid: (Core.GUID fromString: '{eb266eb6-0cdb-4099-9a72-207d060e9210}')!

Refactory.Browser.RemoveClassVariableRefactoring comment: ''!

!Refactory.Browser.RemoveClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.RemoveClassVariableRefactoring methodsFor!

checkReferences
	| methods binding |
	methods := Set new.
	binding := class bindingFor: variableName.
	methods := model allReferencesToBinding: binding.
	(methods isEmpty or: [self shouldRemoveVariable: binding referencedIn: methods])
		ifFalse: [self refactoringAborted].
	^true!

preconditions
	^(RBCondition isMetaclass: class) not & (RBCondition definesClassVariable: variableName in: class)
		& (RBCondition withBlock: [self checkReferences])!

shouldRemoveVariable: aVariableBinding referencedIn: aCollectionOfMethods
	^(self lookupOption: #removeReferencedVariable)
		cull: self
		cull: aVariableBinding
		cull: aCollectionOfMethods!

transform
	class removeClassVariable: variableName! !

!Refactory.Browser.RemoveClassVariableRefactoring categoriesForMethods!
checkReferences!preconditions!private! !
preconditions!preconditions!public! !
shouldRemoveVariable:referencedIn:!private!requests! !
transform!public!transforming! !
!

