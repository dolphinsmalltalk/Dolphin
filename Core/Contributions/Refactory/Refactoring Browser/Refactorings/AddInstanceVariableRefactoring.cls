"Filed out from Dolphin Smalltalk 2000 release 5.00"!

VariableRefactoring subclass: #AddInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddInstanceVariableRefactoring guid: (GUID fromString: '{7704D23E-01CE-425C-9615-7CD32B5E5183}')!
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

