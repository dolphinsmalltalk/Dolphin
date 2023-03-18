"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.MoveVariableDefinitionRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.MoveVariableDefinitionRefactoringTest guid: (Core.GUID fromString: '{dc2344f4-f0f3-4fc5-af74-d852d5d036ae}')!
Refactory.Browser.Tests.MoveVariableDefinitionRefactoringTest comment: ''!
!Refactory.Browser.Tests.MoveVariableDefinitionRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.MoveVariableDefinitionRefactoringTest methodsFor!

testMoveDefinition
	| refactoring |
	refactoring := MoveVariableDefinitionRefactoring
				bindTight: (self convertInterval: (19 to: 22)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				in: RefactoryTestDataApp
				selector: #moveDefinition.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #moveDefinition)
		equals: (self
				parseMethod: 'moveDefinition
								^(self collect: 
										[:each | 
										| temp |
										temp := each printString.
										temp , temp]) 
									select: 
										[:each | 
										| temp |
										temp := each size.
										temp odd]')!

testMoveDefinitionIntoBlockThatIsAReceiverOfACascadedMessage
	| refactoring |
	refactoring := MoveVariableDefinitionRefactoring
				bindTight: (self convertInterval: (48 to: 58)
						for: (RefactoryTestDataApp sourceCodeAt: #referencesConditionFor:))
				in: RefactoryTestDataApp
				selector: #referencesConditionFor:.
	self executeRefactoring: refactoring.
	self
		assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #referencesConditionFor:)
		equals: (self
				parseMethod: 'referencesConditionFor: aClass 
								| environment  |
								^(RBCondition withBlock: 
										[| association |association := Smalltalk associationAt: aClass name
													ifAbsent: [self refactoringError: ''Could not find class''].
										environment := (self environment referencesTo: association) 
													| (self environment referencesTo: aClass name).
										environment isEmpty])
									errorMacro: aClass , '' is referenced.<n>Browse references?'';
									errorBlock: [environment openEditor];
									yourself')!

testNoMoveDefinition
	self shouldFail: (MoveVariableDefinitionRefactoring
				bindTight: (self convertInterval: (21 to: 24)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				in: RefactoryTestDataApp
				selector: #noMoveDefinition)
		withMessage: '''temp'' is possibly read before written'!

testNonExistantName
	| aRefactoring |
	self
		shouldFail: (MoveVariableDefinitionRefactoring
					bindTight: (1 to: 10)
					in: LintRuleTestData
					selector: #name1)
			withMessage: 'LintRuleTestData does not define #name1';
		shouldFail: (MoveVariableDefinitionRefactoring
					bindTight: (self convertInterval: (44 to: 54) for: (LintRuleTestData sourceCodeAt: #displayName))
					in: LintRuleTestData
					selector: #displayName)
			withMessage: 'WriteStream does not seem to be a valid variable name.'.
	"This isn't a test of a non-existant name, but of a move that is already as tightly bound as possible"
	aRefactoring := MoveVariableDefinitionRefactoring
				bindTight: (self convertInterval: (16 to: 25) for: (LintRuleTestData sourceCodeAt: #displayName))
				in: LintRuleTestData
				selector: #displayName.
	self should: [self executeRefactoring: aRefactoring] raise: Refactoring abortSignal! !
!Refactory.Browser.Tests.MoveVariableDefinitionRefactoringTest categoriesForMethods!
testMoveDefinition!public!tests! !
testMoveDefinitionIntoBlockThatIsAReceiverOfACascadedMessage!public!tests! !
testNoMoveDefinition!public!tests! !
testNonExistantName!public!tests! !
!

