"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #RenameTemporaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameTemporaryTest guid: (GUID fromString: '{04723e90-17c0-4d20-b025-d17029763fab}')!
RenameTemporaryTest comment: ''!
!RenameTemporaryTest categoriesForClass!Refactory-Testing! !
!RenameTemporaryTest methodsFor!

testBadInterval
	self shouldFail: (RenameTemporaryRefactoring 
				renameTemporaryFrom: (self convertInterval: (14 to: 17)
						for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
				to: 'asdf'
				in: RefactoryTestDataApp
				selector: #testMethod)!

testBadName
	self
		shouldFail: (RenameTemporaryRefactoring 
					renameTemporaryFrom: (self convertInterval: (15 to: 19)
							for: (LintRuleTest sourceCodeAt: #openEditor))
					to: 'name'
					in: LintRuleTest
					selector: #openEditor);
		shouldFail: (RenameTemporaryRefactoring 
					renameTemporaryFrom: (self convertInterval: (15 to: 19)
							for: (LintRuleTest sourceCodeAt: #openEditor))
					to: 'rules'
					in: LintRuleTest
					selector: #openEditor);
		shouldFail: (RenameTemporaryRefactoring 
					renameTemporaryFrom: (self convertInterval: (15 to: 19)
							for: (LintRuleTest sourceCodeAt: #openEditor))
					to: 'DependentFields'
					in: LintRuleTest
					selector: #openEditor);
		shouldFail: (RenameTemporaryRefactoring 
					renameTemporaryFrom: (self convertInterval: (15 to: 19)
							for: (LintRuleTest sourceCodeAt: #openEditor))
					to: 'a b'
					in: LintRuleTest
					selector: #openEditor)!

testModelBadName
	| class |
	model := RBNamespace new.
	class := model classNamed: #Object.
	class 
		compile: 'aMethod: temp1 ^[| temp2 | temp2 := [:temp3 | temp3 = 5] value: 5. temp2] value'
		classified: #(#accessing).
	self
		shouldFail: (RenameTemporaryRefactoring 
					renameTemporaryFrom: (20 to: 24)
					to: 'temp3'
					in: class
					selector: #aMethod:);
		shouldFail: (RenameTemporaryRefactoring 
					renameTemporaryFrom: (20 to: 24)
					to: 'temp1'
					in: class
					selector: #aMethod:)!

testRenameTemporary
	| refactoring |
	refactoring := RenameTemporaryRefactoring
				renameTemporaryFrom: (self convertInterval: (15 to: 19) for: (LintRuleTest sourceCodeAt: #openEditor))
				to: 'asdf'
				in: LintRuleTest
				selector: #openEditor.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #LintRuleTest) parseTreeFor: #openEditor)
		equals: (RBParser
				parseMethod: 'openEditor
								| asdf |
								asdf := self failedRules.
								asdf isEmpty ifTrue: [^self].
								asdf size == 1 ifTrue: [^asdf first viewResults].
								SmalllintResultEditor openOn: self label: name')! !
!RenameTemporaryTest categoriesForMethods!
testBadInterval!failure tests!public! !
testBadName!failure tests!public! !
testModelBadName!failure tests!public! !
testRenameTemporary!public!tests! !
!

