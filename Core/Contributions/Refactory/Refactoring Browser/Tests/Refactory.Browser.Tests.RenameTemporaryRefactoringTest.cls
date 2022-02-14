"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RenameTemporaryRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameTemporaryRefactoringTest guid: (Core.GUID fromString: '{04723e90-17c0-4d20-b025-d17029763fab}')!
Refactory.Browser.Tests.RenameTemporaryRefactoringTest comment: ''!
!Refactory.Browser.Tests.RenameTemporaryRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameTemporaryRefactoringTest methodsFor!

testBadInterval
	self shouldFail: (RenameTemporaryRefactoring
				renameTemporaryFrom: (self convertInterval: (14 to: 17)
						for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
				to: 'asdf'
				in: RefactoryTestDataApp
				selector: #testMethod)
		withMessage: 'self isn''t defined by the method'!

testBadName
	self
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (self convertInterval: (15 to: 19)
							for: (LintRuleTestData sourceCodeAt: #openEditor))
					to: 'name'
					in: LintRuleTestData
					selector: #openEditor)
			withMessage: 'LintRuleTestData or a superclass defines an instance variable ''name''';
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (self convertInterval: (15 to: 19)
							for: (LintRuleTestData sourceCodeAt: #openEditor))
					to: 'rules'
					in: LintRuleTestData
					selector: #openEditor)
			withMessage: 'amesp isn''t a valid variable';
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (self convertInterval: (15 to: 19)
							for: (LintRuleTestData sourceCodeAt: #openEditor))
					to: 'DependentFields'
					in: LintRuleTestData
					selector: #openEditor)
			withMessage: '''DependentFields'' is not a valid temporary variable name';
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (self convertInterval: (15 to: 19)
							for: (LintRuleTestData sourceCodeAt: #openEditor))
					to: 'a b'
					in: LintRuleTestData
					selector: #openEditor)
			withMessage: '''a b'' is not a valid temporary variable name'!

testModelBadName
	| class |
	model := RBModel new.
	class := model classNamed: #'Core.Object'.
	class compile: 'aMethod: temp1 ^[| temp2 | temp2 := [:temp3 | temp3 = 5] value: 5. temp2] value'
		classified: #accessing.
	self
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (20 to: 24)
					to: 'temp3'
					in: class
					selector: #aMethod:)
			withMessage: 'temp3 is already defined';
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (20 to: 24)
					to: 'temp1'
					in: class
					selector: #aMethod:)
			withMessage: 'temp1 is already defined'!

testRenameTemporary
	| source start stop refactoring |
	source := LintRuleTestData sourceCodeAt: #openEditor.
	start := (source indexOf: $|) + 2.
	stop := (source
				nextIndexOf: $|
				from: start
				to: source size) - 2.
	refactoring := RenameTemporaryRefactoring
				renameTemporaryFrom: (start to: stop)
				to: 'asdf'
				in: LintRuleTestData
				selector: #openEditor.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: LintRuleTestData) parseTreeFor: #openEditor)
		equals: (self
				parseMethod: 'openEditor
								<namespace: Tools>
								| asdf |
								asdf := self failedRules.
								asdf isEmpty ifTrue: [^self].
								asdf size == 1 ifTrue: [^asdf first viewResults].
								self result openEditor')! !
!Refactory.Browser.Tests.RenameTemporaryRefactoringTest categoriesForMethods!
testBadInterval!failure tests!public! !
testBadName!failure tests!public! !
testModelBadName!failure tests!public! !
testRenameTemporary!public!tests! !
!

