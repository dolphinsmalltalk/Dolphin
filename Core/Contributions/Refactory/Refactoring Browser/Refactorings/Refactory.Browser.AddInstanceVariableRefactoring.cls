"Filed out from Dolphin Smalltalk 7"!

VariableRefactoring subclass: #AddInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AddInstanceVariableRefactoring guid: (GUID fromString: '{7704d23e-01ce-425c-9615-7cd32b5e5183}')!
AddInstanceVariableRefactoring comment: ''!
!AddInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!AddInstanceVariableRefactoring methodsFor!

preconditions
	^(RBCondition isValidInstanceVariableName: variableName for: class) 
		& (RBCondition hierarchyOf: class definesVariable: variableName) not 
			& (RBCondition isGlobal: variableName in: self model) not!

transform
	class addInstanceVariable: variableName! !
!AddInstanceVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!AddInstanceVariableRefactoring categoriesFor: #transform!public!transforming! !

