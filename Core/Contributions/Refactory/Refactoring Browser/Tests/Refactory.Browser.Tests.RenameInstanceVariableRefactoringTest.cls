"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RenameInstanceVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.RenameInstanceVariableRefactoringTest guid: (Core.GUID fromString: '{1ce9a0d9-f614-43b2-bcf9-c02a3681f34f}')!

Refactory.Browser.Tests.RenameInstanceVariableRefactoringTest comment: ''!

!Refactory.Browser.Tests.RenameInstanceVariableRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.RenameInstanceVariableRefactoringTest methodsFor!

testAlreadyExistingName
	self shouldFail: (RenameInstanceVariableRefactoring
				rename: 'classBlock'
				to: 'name'
				in: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData or one of its subclasses defines variable ''name'''!

testNonExistantName
	self shouldFail: (RenameInstanceVariableRefactoring
				rename: 'foo'
				to: 'newFoo'
				in: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData does not define an instance variable ''foo'''!

testRenameInstVar
	| refactoring class |
	refactoring := RenameInstanceVariableRefactoring
				rename: 'classBlock'
				to: 'asdf'
				in: BasicLintRuleTestData.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.TestData.BasicLintRuleTestData'.
	self assert: (class directlyDefinesInstanceVariable: 'asdf').
	self deny: (class directlyDefinesInstanceVariable: 'classBlock').
	self assert: (class parseTreeFor: #checkClass:)
		equals: (self
				parseMethod: 'checkClass: aSmalllintContext 
								^asdf value: aSmalllintContext value: result').
	self assert: (class parseTreeFor: #classBlock:)
		equals: (self parseMethod: 'classBlock: aBlock
								asdf := aBlock testMethod1').
	self assert: (class parseTreeFor: #initialize)
		equals: (self
				parseMethod: 'initialize
								super initialize.
								asdf := [:context :aResult | ].
								methodBlock := [:context :aResult | ].
								self resultClass: SelectorEnvironment.')! !

!Refactory.Browser.Tests.RenameInstanceVariableRefactoringTest categoriesForMethods!
testAlreadyExistingName!failure tests!public! !
testNonExistantName!failure tests!public! !
testRenameInstVar!public!tests! !
!

