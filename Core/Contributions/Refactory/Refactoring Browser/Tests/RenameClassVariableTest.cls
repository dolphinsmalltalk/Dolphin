"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #RenameClassVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RenameClassVariableTest guid: (GUID fromString: '{5d45357d-1056-4b27-b1a1-1df41ee18851}')!

RenameClassVariableTest comment: ''!

!RenameClassVariableTest categoriesForClass!Refactory-Testing! !

!RenameClassVariableTest methodsFor!

testAlreadyExistingName
	self shouldFail: (RenameClassVariableRefactoring 
				rename: #RecursiveSelfRule
				to: self objectClassVariable
				in: TransformationRuleTest)!

testMetaClassFailure
	self shouldFail: (RenameClassVariableRefactoring 
				rename: #RecursiveSelfRule
				to: #Foo
				in: TransformationRuleTest class)!

testNonExistantName
	self shouldFail: (RenameClassVariableRefactoring 
				rename: #foo
				to: #newFoo
				in: BasicLintRuleTest)!

testRenameClassVar
	| refactoring class |
	refactoring := RenameClassVariableRefactoring
				rename: #RecursiveSelfRule
				to: #RSR
				in: TransformationRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #TransformationRuleTest.
	self assert: (class directlyDefinesClassVariable: #RSR).
	self deny: (class directlyDefinesClassVariable: #RecursiveSelfRule).
	self assert: (class metaclass parseTreeFor: #initializeAfterLoad1)
		equals: (RBParser
				parseMethod: 'initializeAfterLoad1
								RSR := ParseTreeSearcher new.
								RSR
									addMethodSearches: #(''`@methodName: `@args | `@temps | self `@methodName: `@args'' ''`@methodName: `@args | `@temps | ^self `@methodName: `@args'')
											-> [:aNode :answer | true]').
	self assert: (class metaclass parseTreeFor: #nuke)
		equals: (RBParser parseMethod: 'nuke
								RSR := nil').
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (RBParser
				parseMethod: 'checkMethod: aSmalllintContext 
								class := aSmalllintContext selectedClass.
								(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
										[(RSR executeTree: rewriteRule tree initialAnswer: false)
											ifFalse: 
												[builder compile: rewriteRule tree printString
													in: class
													classified: aSmalllintContext protocols]]')! !

!RenameClassVariableTest categoriesForMethods!
testAlreadyExistingName!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testNonExistantName!failure tests!public! !
testRenameClassVar!public!tests! !
!

