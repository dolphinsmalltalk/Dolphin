"Filed out from Dolphin Smalltalk XP"!

VariableRefactoring subclass: #PushDownInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushDownInstanceVariableRefactoring guid: (GUID fromString: '{A7D8C9B2-B844-4249-9044-5AFC69D8A41F}')!
PushDownInstanceVariableRefactoring comment: ''!
!PushDownInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!PushDownInstanceVariableRefactoring methodsFor!

preconditions
	| references |
	references := RBCondition referencesInstanceVariable: variableName in: class.
	class realClass isNil 
		ifTrue: [references errorMacro: ('<1s> is referenced.' expandMacrosWith: variableName)]
		ifFalse: 
			[references
				errorMacro: ('<1s> is referenced.<n>Browse references?' expandMacrosWith: variableName);
				errorBlock: 
						[#rbFix.	"Should use model's environment, not a global BrowserEnvironment"
						self openBrowserOn: (self model environment instVarRefsTo: variableName in: class realClass)]].
	^(RBCondition definesInstanceVariable: variableName in: class) & references not!

transform
	class removeInstanceVariable: variableName.
	class subclasses do: 
			[:each | 
			(each withAllSubclasses 
				anySatisfy: [:aClass | (aClass whichSelectorsReferToInstanceVariable: variableName) notEmpty]) 
					ifTrue: [each addInstanceVariable: variableName]]! !
!PushDownInstanceVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!PushDownInstanceVariableRefactoring categoriesFor: #transform!public! !

