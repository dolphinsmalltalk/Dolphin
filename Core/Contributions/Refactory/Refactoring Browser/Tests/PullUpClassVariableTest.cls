"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoringTest subclass: #PullUpClassVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PullUpClassVariableTest comment: ''!

PullUpClassVariableTest guid: (GUID fromString: '{714D19BA-E40B-447B-B1D3-72E8D1F543EA}')!

!PullUpClassVariableTest categoriesForClass!Refactory-Testing! !
!PullUpClassVariableTest methodsFor!

testMetaClassFailure
	self 
		shouldFail: (PullUpClassVariableRefactoring variable: #RecursiveSelfRule
				class: LintRuleTest class)!

testNonExistantName
	self shouldFail: (PullUpClassVariableRefactoring variable: #Foo
				class: LintRuleTest)!

testPullUpClassVariable
	| refactoring |
	refactoring := PullUpClassVariableRefactoring variable: #RecursiveSelfRule
				class: LintRuleTest.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #LintRuleTest) 
				directlyDefinesClassVariable: #RecursiveSelfRule).
	self deny: ((refactoring model classNamed: #TransformationRuleTest) 
				directlyDefinesClassVariable: #RecursiveSelfRule)! !
!PullUpClassVariableTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!PullUpClassVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!PullUpClassVariableTest categoriesFor: #testPullUpClassVariable!public!tests! !

