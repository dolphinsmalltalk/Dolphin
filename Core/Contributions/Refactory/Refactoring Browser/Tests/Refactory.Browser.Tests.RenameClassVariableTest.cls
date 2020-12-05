"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RenameClassVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameClassVariableTest guid: (Core.GUID fromString: '{5d45357d-1056-4b27-b1a1-1df41ee18851}')!
Refactory.Browser.Tests.RenameClassVariableTest comment: ''!
!Refactory.Browser.Tests.RenameClassVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameClassVariableTest methodsFor!

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
	class := refactoring model classNamed: TransformationRuleTest fullName.
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
!Refactory.Browser.Tests.RenameClassVariableTest categoriesFor: #testAlreadyExistingName!failure tests!public! !
!Refactory.Browser.Tests.RenameClassVariableTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!Refactory.Browser.Tests.RenameClassVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.RenameClassVariableTest categoriesFor: #testRenameClassVar!public!tests! !

