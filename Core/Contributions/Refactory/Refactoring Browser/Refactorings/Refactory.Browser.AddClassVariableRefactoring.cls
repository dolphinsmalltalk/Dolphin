"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring
	subclass: #'Refactory.Browser.AddClassVariableRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddClassVariableRefactoring guid: (Core.GUID fromString: '{b5dcf149-adbd-42de-9205-bcc093e0f2fc}')!
Refactory.Browser.AddClassVariableRefactoring comment: ''!
!Refactory.Browser.AddClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AddClassVariableRefactoring methodsFor!

preconditions
	^(RBCondition isMetaclass: class) not & (RBCondition isValidClassVarName: variableName)
		& (RBCondition hierarchyOf: class definesVariable: variableName asString) not
			& (RBCondition isStatic: variableName in: self model) not!

transform
	class addClassVariable: variableName! !
!Refactory.Browser.AddClassVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
transform!public!transforming! !
!

