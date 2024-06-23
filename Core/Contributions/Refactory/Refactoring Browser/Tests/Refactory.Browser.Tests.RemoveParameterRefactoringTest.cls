"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RemoveParameterRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.RemoveParameterRefactoringTest guid: (Core.GUID fromString: '{e5ff0a30-1644-4902-8240-701881d750fe}')!

Refactory.Browser.Tests.RemoveParameterRefactoringTest comment: ''!

!Refactory.Browser.Tests.RemoveParameterRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.RemoveParameterRefactoringTest methodsFor!

testNonExistantName
	self
		shouldFail: (RemoveParameterRefactoring
					removeParameter: 'asdf'
					in: BasicLintRuleTestData
					selector: #checkClass:)
			withMessage: 'Select a parameter!!!!';
		shouldFail: (RemoveParameterRefactoring
					removeParameter: 'aSmalllintContext'
					in: BasicLintRuleTestData
					selector: #checkClass1:)
			withMessage: 'Method doesn''t exist'!

testPrimitiveMethods
	| refactoring |
	(model classNamed: #'Core.Object') compile: 'foo123: a <primitive: 100> ^#() primitiveFailed'
		classified: #accessing.
	refactoring := RemoveParameterRefactoring
				model: model
				removeParameter: 'a'
				in: Object
				selector: #foo123:.
	self shouldFail: refactoring withMessage: 'Object''s implementation of #foo123: is a primitive'!

testRemoveParameter
	| refactoring class |
	refactoring := RemoveParameterRefactoring
				removeParameter: 'anArg'
				in: RefactoryTestDataApp
				selector: ('rename' , 'ThisMethod:') asSymbol.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #renameThisMethod)
		equals: (self parseMethod: 'renameThisMethod
								^self').
	self assert: (class parseTreeFor: #callMethod)
		equals: (self parseMethod: 'callMethod
								^(self renameThisMethod)').
	self deny: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)! !

!Refactory.Browser.Tests.RemoveParameterRefactoringTest categoriesForMethods!
testNonExistantName!failure tests!public! !
testPrimitiveMethods!failure tests!public! !
testRemoveParameter!public!tests! !
!

