"Filed out from Dolphin Smalltalk X6"!

RefactoringTest subclass: #PushDownMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushDownMethodTest guid: (GUID fromString: '{0795B490-F7D0-4814-9B01-1F2F86AC9C20}')!
PushDownMethodTest comment: ''!
!PushDownMethodTest categoriesForClass!Refactory-Testing! !
!PushDownMethodTest methodsFor!

testPushDownMethod
	| refactoring class |
	refactoring := PushDownMethodRefactoring pushDown: #(#name:)
				from: LintRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #LintRuleTest.
	self deny: (class directlyDefinesMethod: #name:).
	class subclasses do: 
			[:each | 
			self assert: (each parseTreeFor: #name:) 
						= (RBParser parseMethod: 'name: aString name := aString')]!

testPushDownMethodOnNonAbstractClass
	| refactoring |
	refactoring := PushDownMethodRefactoring pushDown: #(#yourself)
				from: Object.
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
			self assert: (each parseTreeFor: #junk) = parseTree.
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

