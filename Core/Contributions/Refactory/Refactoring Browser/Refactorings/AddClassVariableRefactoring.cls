"Filed out from Dolphin Smalltalk 2000 release 5.00"!

VariableRefactoring subclass: #AddClassVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddClassVariableRefactoring guid: (GUID fromString: '{B5DCF149-ADBD-42DE-9205-BCC093E0F2FC}')!
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

