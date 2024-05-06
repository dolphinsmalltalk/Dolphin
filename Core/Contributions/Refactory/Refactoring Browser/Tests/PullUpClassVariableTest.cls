"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #PullUpClassVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PullUpClassVariableTest guid: (GUID fromString: '{714d19ba-e40b-447b-b1d3-72e8d1f543ea}')!

PullUpClassVariableTest comment: ''!

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

!PullUpClassVariableTest categoriesForMethods!
testMetaClassFailure!failure tests!public! !
testNonExistantName!failure tests!public! !
testPullUpClassVariable!public!tests! !
!

