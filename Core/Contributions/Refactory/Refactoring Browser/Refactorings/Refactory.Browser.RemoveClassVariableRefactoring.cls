"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.VariableRefactoring subclass: #'Refactory.Browser.RemoveClassVariableRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveClassVariableRefactoring guid: (Core.GUID fromString: '{eb266eb6-0cdb-4099-9a72-207d060e9210}')!
Refactory.Browser.RemoveClassVariableRefactoring comment: ''!
!Refactory.Browser.RemoveClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RemoveClassVariableRefactoring methodsFor!

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
!Refactory.Browser.RemoveClassVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.RemoveClassVariableRefactoring categoriesFor: #transform!public!transforming! !

