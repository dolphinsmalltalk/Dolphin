"Filed out from Dolphin Smalltalk XP"!

SUnitBrowserModelSUnitTestsTC subclass: #SUnitBrowserModelTC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserModelTC guid: (GUID fromString: '{26E348EE-0F86-4B6A-B349-1E3F12C27C54}')!
SUnitBrowserModelTC comment: ''!
!SUnitBrowserModelTC categoriesForClass!Unclassified! !
!SUnitBrowserModelTC methodsFor!

assertInitialSunitTestState

	super assertInitialSunitTestState.

	self assert: self model listItems size = 15
			!

assertSunitTestAllRunState

	super assertInitialSunitTestState
			!

setUpShowAllState

	self model showAll: true
			!

testRemoveSelectedItem

	super testRemoveSelectedItem.
	self
		assert: self model listItems size = 12;
		assert: self browser numberOfCallbacks = 3;
		assert:
			self browser callbackSymbols = #(
				callbackResetList callbackSelectedItems callbackResetList)
			! !
!SUnitBrowserModelTC categoriesFor: #assertInitialSunitTestState!asserting!private! !
!SUnitBrowserModelTC categoriesFor: #assertSunitTestAllRunState!asserting!private! !
!SUnitBrowserModelTC categoriesFor: #setUpShowAllState!private!running! !
!SUnitBrowserModelTC categoriesFor: #testRemoveSelectedItem!public!running! !

!SUnitBrowserModelTC class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have TestCase instances 
	 built from it"

	^false
			! !
!SUnitBrowserModelTC class categoriesFor: #isAbstract!public!Testing! !

