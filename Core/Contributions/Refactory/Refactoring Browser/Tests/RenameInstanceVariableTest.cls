"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #RenameInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameInstanceVariableTest guid: (GUID fromString: '{1ce9a0d9-f614-43b2-bcf9-c02a3681f34f}')!
RenameInstanceVariableTest comment: ''!
!RenameInstanceVariableTest categoriesForClass!Refactory-Testing! !
!RenameInstanceVariableTest methodsFor!

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
	class := refactoring model classNamed: #BasicLintRuleTest.
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
!RenameInstanceVariableTest categoriesForMethods!
testAlreadyExistingName!failure tests!public! !
testNonExistantName!failure tests!public! !
testRenameInstVar!public!tests! !
!

