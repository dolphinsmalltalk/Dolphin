"Filed out from Dolphin Smalltalk 7"!

VariableRefactoring subclass: #RemoveInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RemoveInstanceVariableRefactoring guid: (GUID fromString: '{d2991219-2de3-407c-b2e8-dff3b51b51db}')!
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

