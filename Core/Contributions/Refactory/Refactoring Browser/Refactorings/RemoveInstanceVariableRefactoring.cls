"Filed out from Dolphin Smalltalk XP"!

VariableRefactoring subclass: #RemoveInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveInstanceVariableRefactoring guid: (GUID fromString: '{D2991219-2DE3-407C-B2E8-DFF3B51B51DB}')!
RemoveInstanceVariableRefactoring comment: ''!
!RemoveInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!RemoveInstanceVariableRefactoring methodsFor!

preconditions
	| references |
	references := RBCondition hierarchyOf: class referencesInstanceVariable: variableName.
	class realClass isNil 
		ifTrue: [references errorMacro: ('<1s> is referenced.' expandMacrosWith: variableName)]
		ifFalse: 
			[references
				errorMacro: ('<1p> is still referenced.<n><n>Browse references?' expandMacrosWith: variableName);
				errorBlock: 
						[#rbFix.	"Use environment for reference search."
						self openBrowserOn: (self model environment instVarRefsTo: variableName in: class realClass)]].
	^(RBCondition definesInstanceVariable: variableName asString in: class) & references not!

transform
	class removeInstanceVariable: variableName! !
!RemoveInstanceVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!RemoveInstanceVariableRefactoring categoriesFor: #transform!public!transforming! !

