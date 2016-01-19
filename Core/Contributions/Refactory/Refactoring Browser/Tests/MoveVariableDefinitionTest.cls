"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #MoveVariableDefinitionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MoveVariableDefinitionTest guid: (GUID fromString: '{DC2344F4-F0F3-4FC5-AF74-D852D5D036AE}')!
MoveVariableDefinitionTest comment: ''!
!MoveVariableDefinitionTest categoriesForClass!Refactory-Testing! !
!MoveVariableDefinitionTest methodsFor!

testNoMoveDefinition
	self shouldFail: (MoveVariableDefinitionRefactoring 
				bindTight: (self convertInterval: (21 to: 24)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				in: RefactoryTestDataApp
				selector: #noMoveDefinition)! !
!MoveVariableDefinitionTest categoriesFor: #testNoMoveDefinition!public!tests! !

