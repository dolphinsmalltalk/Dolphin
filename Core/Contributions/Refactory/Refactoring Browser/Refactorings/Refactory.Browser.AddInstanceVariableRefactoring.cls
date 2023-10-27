"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring
	subclass: #'Refactory.Browser.AddInstanceVariableRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddInstanceVariableRefactoring guid: (Core.GUID fromString: '{7704d23e-01ce-425c-9615-7cd32b5e5183}')!
Refactory.Browser.AddInstanceVariableRefactoring comment: ''!
!Refactory.Browser.AddInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AddInstanceVariableRefactoring methodsFor!

preconditions
	^(RBCondition isValidInstanceVariableName: variableName)
		& (RBCondition hierarchyOf: class definesVariable: variableName) not
			& (RBCondition isStatic: variableName in: self model) not!

transform
	class addInstanceVariable: variableName! !
!Refactory.Browser.AddInstanceVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
transform!public!transforming! !
!

