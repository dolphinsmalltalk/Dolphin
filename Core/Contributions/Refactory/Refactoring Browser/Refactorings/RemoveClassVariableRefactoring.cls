"Filed out from Dolphin Smalltalk XP"!

VariableRefactoring subclass: #RemoveClassVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveClassVariableRefactoring guid: (GUID fromString: '{EB266EB6-0CDB-4099-9A72-207D060E9210}')!
RemoveClassVariableRefactoring comment: ''!
!RemoveClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!RemoveClassVariableRefactoring methodsFor!

preconditions
	^(RBCondition isMetaclass: class) not & (RBCondition definesClassVariable: variableName in: class) 
		& (RBCondition withBlock: 
					[| block |
					block := 
							[:each | 
							(each whichSelectorsReferToClassVariable: variableName) notEmpty 
								ifTrue: 
									[class realClass isNil 
										ifTrue: [self refactoringError: ('<1s> is referenced.' expandMacrosWith: variableName)]
										ifFalse: 
											[self refactoringError: ('<1s> is referenced.<n>Browse references?' expandMacrosWith: variableName)
												with: 
													[#rbFix.	"Should open browser on refs from the refactoring's environment, not necessarily the global environment"
													self openBrowserOn: (self model environment classVarRefsTo: variableName in: class realClass)]]]].
					class withAllSubclasses do: block.
					class metaclass withAllSubclasses do: block.
					true])!

transform
	class removeClassVariable: variableName! !
!RemoveClassVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!RemoveClassVariableRefactoring categoriesFor: #transform!public!transforming! !

