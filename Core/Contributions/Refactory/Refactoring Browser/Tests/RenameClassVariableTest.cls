"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoringTest subclass: #RenameClassVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameClassVariableTest comment: ''!

RenameClassVariableTest guid: (GUID fromString: '{5D45357D-1056-4B27-B1A1-1DF41EE18851}')!

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
	self 
		assert: (class metaclass parseTreeFor: #initializeAfterLoad1) = (RBParser 
						parseMethod: 'initializeAfterLoad1
								RSR := ParseTreeSearcher new.
								RSR
									addMethodSearches: #(''`@methodName: `@args | `@temps | self `@methodName: `@args'' ''`@methodName: `@args | `@temps | ^self `@methodName: `@args'')
											-> [:aNode :answer | true]').
	self assert: (class metaclass parseTreeFor: #nuke) 
				= (RBParser parseMethod: 'nuke
								RSR := nil').
	self 
		assert: (class parseTreeFor: #checkMethod:) = (RBParser 
						parseMethod: 'checkMethod: aSmalllintContext 
								class := aSmalllintContext selectedClass.
								(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
										[(RSR executeTree: rewriteRule tree initialAnswer: false)
											ifFalse: 
												[builder compile: rewriteRule tree printString
													in: class
													classified: aSmalllintContext protocols]]')! !
!RenameClassVariableTest categoriesFor: #testAlreadyExistingName!failure tests!public! !
!RenameClassVariableTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!RenameClassVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!RenameClassVariableTest categoriesFor: #testRenameClassVar!public!tests! !

