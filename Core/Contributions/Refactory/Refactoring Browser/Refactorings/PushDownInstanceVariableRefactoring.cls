"Filed out from Dolphin Smalltalk"!

VariableRefactoring subclass: #PushDownInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushDownInstanceVariableRefactoring guid: (GUID fromString: '{a7d8c9b2-b844-4249-9044-5afc69d8a41f}')!
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
!PushDownInstanceVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
transform!public! !
!

