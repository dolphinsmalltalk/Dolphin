"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #PushDownMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PushDownMethodTest guid: (GUID fromString: '{0795b490-f7d0-4814-9b01-1f2f86ac9c20}')!
PushDownMethodTest comment: ''!
!PushDownMethodTest categoriesForClass!Refactory-Testing! !
!PushDownMethodTest methodsFor!

testPushDownMethod
	| refactoring class |
	refactoring := PushDownMethodRefactoring pushDown: #(#name:) from: LintRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #LintRuleTest.
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
	class := refactoring model classNamed: #LintRuleTest.
	self deny: (class directlyDefinesMethod: #junk).
	class subclasses do: 
			[:each |
			self assert: (each parseTreeFor: #junk) equals: parseTree.
			#rbFix.	"On Dolphin pools are inherited, so in fact the pool should NOT have been copied down."
			self deny: (each directlyDefinesPoolDictionary: 'CRTConstants' asSymbol)]!

testPushDownNonExistantMenu
	| refactoring |
	refactoring := PushDownMethodRefactoring 
				pushDown: #(#someMethodThatDoesNotExist)
				from: LintRuleTest.
	self shouldFail: refactoring! !
!PushDownMethodTest categoriesFor: #testPushDownMethod!public!tests! !
!PushDownMethodTest categoriesFor: #testPushDownMethodOnNonAbstractClass!failure tests!public! !
!PushDownMethodTest categoriesFor: #testPushDownMethodThatReferencesPoolDictionary!public!tests! !
!PushDownMethodTest categoriesFor: #testPushDownNonExistantMenu!failure tests!public! !

