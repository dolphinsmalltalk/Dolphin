"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.PushDownMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PushDownMethodTest guid: (Core.GUID fromString: '{0795b490-f7d0-4814-9b01-1f2f86ac9c20}')!
Refactory.Browser.Tests.PushDownMethodTest comment: ''!
!Refactory.Browser.Tests.PushDownMethodTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PushDownMethodTest methodsFor!

testPushDownMethod
	| refactoring class |
	refactoring := PushDownMethodRefactoring pushDown: #(#name:) from: LintRuleTestData.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: LintRuleTestData.
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
	refactoring := PushDownMethodRefactoring pushDown: #(#junk) from: LintRuleTestData.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: LintRuleTestData.
	self deny: (class directlyDefinesMethod: #junk).
	class subclasses do: 
			[:each |
			self assert: (each parseTreeFor: #junk) equals: parseTree.
			#rbFix.	"On Dolphin pools are inherited, so in fact the pool should NOT have been copied down."
			self deny: (each directlyImportsNamespace: #{OS.CRTConstants})]!

testPushDownNonExistantMenu
	| refactoring |
	refactoring := PushDownMethodRefactoring pushDown: #(#someMethodThatDoesNotExist)
				from: LintRuleTestData.
	self shouldFail: refactoring
		withMessage: 'LintRuleTestData does not define #someMethodThatDoesNotExist'! !
!Refactory.Browser.Tests.PushDownMethodTest categoriesForMethods!
testPushDownMethod!public!tests! !
testPushDownMethodOnNonAbstractClass!failure tests!public! !
testPushDownMethodThatReferencesPoolDictionary!public!tests! !
testPushDownNonExistantMenu!failure tests!public! !
!

