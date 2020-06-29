"Filed out from Dolphin Smalltalk 7"!

VariableRefactoring subclass: #AddClassVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!AddClassVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!AddClassVariableRefactoring categoriesFor: #transform!public!transforming! !

