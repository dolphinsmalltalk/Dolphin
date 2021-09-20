"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RenameTemporaryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameTemporaryTest guid: (Core.GUID fromString: '{04723e90-17c0-4d20-b025-d17029763fab}')!
Refactory.Browser.Tests.RenameTemporaryTest comment: ''!
!Refactory.Browser.Tests.RenameTemporaryTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameTemporaryTest methodsFor!

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
					renameTemporaryFrom: (self convertInterval: (15 to: 19) for: (LintRuleTest sourceCodeAt: #openEditor))
					to: 'name'
					in: LintRuleTest
					selector: #openEditor);
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (self convertInterval: (15 to: 19) for: (LintRuleTest sourceCodeAt: #openEditor))
					to: 'rules'
					in: LintRuleTest
					selector: #openEditor);
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (self convertInterval: (15 to: 19) for: (LintRuleTest sourceCodeAt: #openEditor))
					to: 'DependentFields'
					in: LintRuleTest
					selector: #openEditor);
		shouldFail: (RenameTemporaryRefactoring
					renameTemporaryFrom: (self convertInterval: (15 to: 19) for: (LintRuleTest sourceCodeAt: #openEditor))
					to: 'a b'
					in: LintRuleTest
					selector: #openEditor)!

testModelBadName
	| class |
	model := RBNamespace new.
	class := model classNamed: #'Core.Object'.
	class compile: 'aMethod: temp1 ^[| temp2 | temp2 := [:temp3 | temp3 = 5] value: 5. temp2] value'
		classified: #accessing.
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
	| source start stop refactoring |
	source := LintRuleTest sourceCodeAt: #openEditor.
	start := (source indexOf: $|) + 2.
	stop := (source
				nextIndexOf: $|
				from: start
				to: source size) - 2.
	refactoring := RenameTemporaryRefactoring
				renameTemporaryFrom: (start to: stop)
				to: 'asdf'
				in: LintRuleTest
				selector: #openEditor.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest')
				parseTreeFor: #openEditor)
		equals: (RBParser
				parseMethod: 'openEditor
								<namespace: Tools>
								| asdf |
								asdf := self failedRules.
								asdf isEmpty ifTrue: [^self].
								asdf size == 1 ifTrue: [^asdf first viewResults].
								SmalltalkSystem current browseEnvironment: self result')! !
!Refactory.Browser.Tests.RenameTemporaryTest categoriesForMethods!
testBadInterval!failure tests!public! !
testBadName!failure tests!public! !
testModelBadName!failure tests!public! !
testRenameTemporary!public!tests! !
!

