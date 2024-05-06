"Filed out from Dolphin Smalltalk"!

VariableRefactoring subclass: #AddClassVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AddClassVariableRefactoring guid: (GUID fromString: '{b5dcf149-adbd-42de-9205-bcc093e0f2fc}')!

AddClassVariableRefactoring comment: ''!

!AddClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !

!AddClassVariableRefactoring methodsFor!

preconditions
	^(RBCondition isMetaclass: class) not 
		& (RBCondition isValidClassVarName: variableName for: class) 
			& (RBCondition hierarchyOf: class definesVariable: variableName asString) 
					not 
			& (RBCondition isGlobal: variableName in: self model) not!

transform
	class addClassVariable: variableName! !

!AddClassVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
transform!public!transforming! !
!

