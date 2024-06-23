"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.PushDownMethodRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.PushDownMethodRefactoringTest guid: (Core.GUID fromString: '{0795b490-f7d0-4814-9b01-1f2f86ac9c20}')!

Refactory.Browser.Tests.PushDownMethodRefactoringTest comment: ''!

!Refactory.Browser.Tests.PushDownMethodRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.PushDownMethodRefactoringTest methodsFor!

testPushDownMethod
	| refactoring class |
	refactoring := PushDownMethodRefactoring
				model: model
				pushDown: #(#name:)
				from: LintRuleTestData.
	self executeRefactoring: refactoring.
	class := model classFor: LintRuleTestData.
	self deny: (class directlyDefinesMethod: #name:).
	class subclasses do: 
			[:each |
			self assert: (each parseTreeFor: #name:) equals: (self parseMethod: 'name: aString name := aString')]!

testPushDownMethodOnNonAbstractClass
	| refactoring |
	refactoring := PushDownMethodRefactoring pushDown: #(#key) from: Association.
	self shouldFail: refactoring withMessage: 'Association is not an abstract class'!

testPushDownMethodThatReferencesPoolDictionary
	| refactoring class parseTree |
	parseTree := LintRuleTestData parseTreeFor: #junk.
	refactoring := PushDownMethodRefactoring
				model: model
				pushDown: #(#junk)
				from: LintRuleTestData.
	refactoring setOption: #addImports toUse: [:ref :vars | self fail: 'Unexpected addImports'].
	self executeRefactoring: refactoring.
	class := refactoring model classFor: LintRuleTestData.
	self deny: (class directlyDefinesMethod: #junk).
	class subclasses do: 
			[:each |
			self assert: (each parseTreeFor: #junk) equals: parseTree.
			#rbFix.	"On Dolphin pools (imports) are inherited, so in fact the import should NOT have been copied down."
			self deny: (each directlyImportsNamespace: #{OS.CRTConstants})]!

testPushDownNonExistantMenu
	| refactoring |
	refactoring := PushDownMethodRefactoring pushDown: #(#someMethodThatDoesNotExist)
				from: LintRuleTestData.
	self shouldFail: refactoring
		withMessage: 'LintRuleTestData does not define #someMethodThatDoesNotExist'! !

!Refactory.Browser.Tests.PushDownMethodRefactoringTest categoriesForMethods!
testPushDownMethod!public!tests! !
testPushDownMethodOnNonAbstractClass!failure tests!public! !
testPushDownMethodThatReferencesPoolDictionary!public!tests! !
testPushDownNonExistantMenu!failure tests!public! !
!

