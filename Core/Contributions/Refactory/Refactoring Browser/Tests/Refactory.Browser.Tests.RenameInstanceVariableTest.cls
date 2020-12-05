"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RenameInstanceVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameInstanceVariableTest guid: (Core.GUID fromString: '{1ce9a0d9-f614-43b2-bcf9-c02a3681f34f}')!
Refactory.Browser.Tests.RenameInstanceVariableTest comment: ''!
!Refactory.Browser.Tests.RenameInstanceVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameInstanceVariableTest methodsFor!

testAlreadyExistingName
	self shouldFail: (RenameInstanceVariableRefactoring
				rename: 'classBlock'
				to: 'name'
				in: BasicLintRuleTest)!

testNonExistantName
	self shouldFail: (RenameInstanceVariableRefactoring
				rename: 'foo'
				to: 'newFoo'
				in: BasicLintRuleTest)!

testRenameInstVar
	| refactoring class |
	refactoring := RenameInstanceVariableRefactoring
				rename: 'classBlock'
				to: 'asdf'
				in: BasicLintRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.BasicLintRuleTest'.
	self assert: (class directlyDefinesInstanceVariable: 'asdf').
	self deny: (class directlyDefinesInstanceVariable: 'classBlock').
	self assert: (class parseTreeFor: #checkClass:)
		equals: (RBParser
				parseMethod: 'checkClass: aSmalllintContext 
								^asdf value: aSmalllintContext value: result').
	self assert: (class parseTreeFor: #classBlock:)
		equals: (RBParser parseMethod: 'classBlock: aBlock
								asdf := aBlock testMethod1').
	self assert: (class parseTreeFor: #initialize)
		equals: (RBParser
				parseMethod: 'initialize
								super initialize.
								asdf := [:context :aResult | ].
								methodBlock := [:context :aResult | ].
								self resultClass: SelectorEnvironment.')! !
!Refactory.Browser.Tests.RenameInstanceVariableTest categoriesFor: #testAlreadyExistingName!failure tests!public! !
!Refactory.Browser.Tests.RenameInstanceVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.RenameInstanceVariableTest categoriesFor: #testRenameInstVar!public!tests! !

