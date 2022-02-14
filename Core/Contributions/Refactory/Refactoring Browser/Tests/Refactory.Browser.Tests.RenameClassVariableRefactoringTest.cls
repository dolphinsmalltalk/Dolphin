"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RenameClassVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameClassVariableRefactoringTest guid: (Core.GUID fromString: '{5d45357d-1056-4b27-b1a1-1df41ee18851}')!
Refactory.Browser.Tests.RenameClassVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.RenameClassVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameClassVariableRefactoringTest methodsFor!

testAlreadyExistingName
	self shouldFail: (RenameClassVariableRefactoring
				rename: #RecursiveSelfRule
				to: self objectClassVariable
				in: TransformationRuleTestData)
		withMessage: 'TransformationRuleTestData or one of its subclasses defines variable ''_EventsRegister'''!

testMetaClassFailure
	self shouldFail: (RenameClassVariableRefactoring
				rename: #RecursiveSelfRule
				to: #Foo
				in: TransformationRuleTestData class)
		withMessage: 'TransformationRuleTestData class is a metaclass'!

testNonExistantName
	self shouldFail: (RenameClassVariableRefactoring
				rename: #foo
				to: #newFoo
				in: BasicLintRuleTestData)
		withMessage: '''newFoo'' is not a valid class variable name'!

testRenameClassVar
	| refactoring class |
	refactoring := RenameClassVariableRefactoring
				rename: #RecursiveSelfRule
				to: #RSR
				in: TransformationRuleTestData.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: TransformationRuleTestData fullName.
	self assert: (class directlyDefinesClassVariable: #RSR).
	self deny: (class directlyDefinesClassVariable: #RecursiveSelfRule).
	self assert: (class metaclass parseTreeFor: #initializeAfterLoad1)
		equals: (self
				parseMethod: 'initializeAfterLoad1
								RSR := ParseTreeSearcher new.
								RSR
									addMethodSearches: #(''`@methodName: `@args | `@temps | self `@methodName: `@args'' ''`@methodName: `@args | `@temps | ^self `@methodName: `@args'')
											-> [:aNode :answer | true]').
	self assert: (class metaclass parseTreeFor: #nuke)
		equals: (self parseMethod: 'nuke
								RSR := nil').
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (self
				parseMethod: 'checkMethod: aSmalllintContext 
								class := aSmalllintContext selectedClass.
								(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
										[(RSR executeTree: rewriteRule tree initialAnswer: false)
											ifFalse: 
												[builder compile: rewriteRule tree printString
													in: class
													categories: aSmalllintContext protocols]]')! !
!Refactory.Browser.Tests.RenameClassVariableRefactoringTest categoriesForMethods!
testAlreadyExistingName!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testNonExistantName!failure tests!public! !
testRenameClassVar!public!tests! !
!

