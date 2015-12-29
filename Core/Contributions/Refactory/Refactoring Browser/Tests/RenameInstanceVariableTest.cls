"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoringTest subclass: #RenameInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameInstanceVariableTest comment: ''!

RenameInstanceVariableTest guid: (GUID fromString: '{1CE9A0D9-F614-43B2-BCF9-C02A3681F34F}')!

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
	self 
		assert: (class parseTreeFor: #checkClass:) = (RBParser 
						parseMethod: 'checkClass: aSmalllintContext 
								^asdf value: aSmalllintContext value: result').
	self 
		assert: (class parseTreeFor: #classBlock:) = (RBParser 
						parseMethod: 'classBlock: aBlock
								asdf := aBlock testMethod1').
	self 
		assert: (class parseTreeFor: #initialize) = (RBParser 
						parseMethod: 'initialize
								super initialize.
								asdf := [:context :aResult | ].
								methodBlock := [:context :aResult | ].
								self resultClass: SelectorEnvironment.')! !
!RenameInstanceVariableTest categoriesFor: #testAlreadyExistingName!failure tests!public! !
!RenameInstanceVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!RenameInstanceVariableTest categoriesFor: #testRenameInstVar!public!tests! !

