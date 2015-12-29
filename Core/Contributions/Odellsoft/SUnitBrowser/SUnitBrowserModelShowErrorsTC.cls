"Filed out from Dolphin Smalltalk XP"!

SUnitBrowserModelSUnitTestsTC subclass: #SUnitBrowserModelShowErrorsTC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserModelShowErrorsTC guid: (GUID fromString: '{E8472B8F-6B43-43F1-A715-A6CAF15B0D26}')!
SUnitBrowserModelShowErrorsTC comment: ''!
!SUnitBrowserModelShowErrorsTC categoriesForClass!Unclassified! !
!SUnitBrowserModelShowErrorsTC methodsFor!

assertInitialSunitTestState

	super assertInitialSunitTestState.

	self assert: self model listItems isEmpty
			!

assertSunitTestAllRunState

	super assertInitialSunitTestState.

	self assert: self model listItems size = 2
			!

setUpShowAllState

	self model showAll: false
			! !
!SUnitBrowserModelShowErrorsTC categoriesFor: #assertInitialSunitTestState!asserting!private! !
!SUnitBrowserModelShowErrorsTC categoriesFor: #assertSunitTestAllRunState!asserting!private! !
!SUnitBrowserModelShowErrorsTC categoriesFor: #setUpShowAllState!private!running! !

!SUnitBrowserModelShowErrorsTC class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have TestCase instances 
	 built from it"

	^false
			! !
!SUnitBrowserModelShowErrorsTC class categoriesFor: #isAbstract!public!Testing! !

