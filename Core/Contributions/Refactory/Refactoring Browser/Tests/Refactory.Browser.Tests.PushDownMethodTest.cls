"Filed out from Dolphin Smalltalk 7"!

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
	refactoring := PushDownMethodRefactoring pushDown: #(#name:) from: LintRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest'.
	self deny: (class directlyDefinesMethod: #name:).
	class subclasses do: 
			[:each |
			self assert: (each parseTreeFor: #name:)
				equals: (RBParser parseMethod: 'name: aString name := aString')]!

testPushDownMethodOnNonAbstractClass
	| refactoring |
	refactoring := PushDownMethodRefactoring pushDown: #(#key) from: Association.
	self shouldFail: refactoring!

testPushDownMethodThatReferencesPoolDictionary
	| refactoring class parseTree |
	parseTree := LintRuleTest parseTreeFor: #junk.
	self proceedThroughWarning: 
			[refactoring := PushDownMethodRefactoring pushDown: #(#junk) from: LintRuleTest.
			self executeRefactoring: refactoring].
	class := refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest'.
	self deny: (class directlyDefinesMethod: #junk).
	class subclasses do: 
			[:each |
			self assert: (each parseTreeFor: #junk) equals: parseTree.
			#rbFix.	"On Dolphin pools are inherited, so in fact the pool should NOT have been copied down."
			self deny: (each directlyImportsNamespace: 'CRTConstants' asSymbol)]!

testPushDownNonExistantMenu
	| refactoring |
	refactoring := PushDownMethodRefactoring pushDown: #(#someMethodThatDoesNotExist) from: LintRuleTest.
	self shouldFail: refactoring! !
!Refactory.Browser.Tests.PushDownMethodTest categoriesFor: #testPushDownMethod!public!tests! !
!Refactory.Browser.Tests.PushDownMethodTest categoriesFor: #testPushDownMethodOnNonAbstractClass!failure tests!public! !
!Refactory.Browser.Tests.PushDownMethodTest categoriesFor: #testPushDownMethodThatReferencesPoolDictionary!public!tests! !
!Refactory.Browser.Tests.PushDownMethodTest categoriesFor: #testPushDownNonExistantMenu!failure tests!public! !

