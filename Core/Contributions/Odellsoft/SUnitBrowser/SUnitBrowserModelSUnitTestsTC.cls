"Filed out from Dolphin Smalltalk XP"!

SUnitBrowserModelAbsTC subclass: #SUnitBrowserModelSUnitTestsTC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserModelSUnitTestsTC guid: (GUID fromString: '{EBA15374-F27F-431E-A4CF-DFCC41C87F30}')!
SUnitBrowserModelSUnitTestsTC comment: ''!
!SUnitBrowserModelSUnitTestsTC categoriesForClass!Unclassified! !
!SUnitBrowserModelSUnitTestsTC methodsFor!

assertInitialSunitTestState

	self
		assert: self model selectedItem isNil;
		assert: self model selectedItems isEmpty
			!

assertSunitTestAllRunState

	self
		assert: self model selectedItem isNil;
		assert: self model selectedItems isEmpty
			!

setUp

	super setUp.

	self setUpShowAllState
			!

testInitialState

	self
		assertInitialSunitTestState;
		assert: self browser numberOfCallbacks = 1;
		assert: self browser callbackSymbols = #(callbackResetList)
			!

testQueries

	| testCase |

	self
		deny: self model canAnalyze;
		deny: self model canDebug;
		deny: self model canInspect;
		deny: self model canRemove;
		deny: self model canRun.

	self model runAll.
	testCase := self model listItems at: 1.
	self model selectItems: (OrderedCollection with: testCase).

	self
		assert: self model canAnalyze;
		assert: self model canDebug;
		assert: self model canInspect;
		assert: self model canRemove;
		assert: self model canRun
			!

testReset

	self model runAll.
	self model reset.

	self
		assertInitialSunitTestState;
		assert: self browser callbackSymbols last = #callbackResetList
			! !
!SUnitBrowserModelSUnitTestsTC categoriesFor: #assertInitialSunitTestState!asserting!private! !
!SUnitBrowserModelSUnitTestsTC categoriesFor: #assertSunitTestAllRunState!asserting!private! !
!SUnitBrowserModelSUnitTestsTC categoriesFor: #setUp!public!running! !
!SUnitBrowserModelSUnitTestsTC categoriesFor: #testInitialState!public!running! !
!SUnitBrowserModelSUnitTestsTC categoriesFor: #testQueries!public!running! !
!SUnitBrowserModelSUnitTestsTC categoriesFor: #testReset!public!running! !

