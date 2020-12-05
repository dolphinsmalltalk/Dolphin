"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RemoveParameterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveParameterTest guid: (Core.GUID fromString: '{e5ff0a30-1644-4902-8240-701881d750fe}')!
Refactory.Browser.Tests.RemoveParameterTest comment: ''!
!Refactory.Browser.Tests.RemoveParameterTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveParameterTest methodsFor!

testNonExistantName
	self
		shouldFail: (RemoveParameterRefactoring
					removeParameter: 'asdf'
					in: BasicLintRuleTest
					selector: #checkClass:);
		shouldFail: (RemoveParameterRefactoring
					removeParameter: 'aSmalllintContext'
					in: BasicLintRuleTest
					selector: #checkClass1:)!

testPrimitiveMethods
	| refactoring |
	(model classNamed: #'Core.Object') compile: 'foo123: a <primitive: 100> ^#() primitiveFailed'
		classified: #(#accessing).
	refactoring := RemoveParameterRefactoring
				model: model
				removeParameter: 'a'
				in: Object
				selector: #foo123:.
	self shouldFail: refactoring!

testRemoveParameter
	| refactoring class |
	refactoring := RemoveParameterRefactoring
				removeParameter: 'anArg'
				in: RefactoryTestDataApp
				selector: ('rename' , 'ThisMethod:') asSymbol.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	self assert: (class parseTreeFor: #renameThisMethod)
		equals: (RBParser parseMethod: 'renameThisMethod
								^self').
	self assert: (class parseTreeFor: #callMethod)
		equals: (RBParser parseMethod: 'callMethod
								^(self renameThisMethod)').
	self deny: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)! !
!Refactory.Browser.Tests.RemoveParameterTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.RemoveParameterTest categoriesFor: #testPrimitiveMethods!failure tests!public! !
!Refactory.Browser.Tests.RemoveParameterTest categoriesFor: #testRemoveParameter!public!tests! !

