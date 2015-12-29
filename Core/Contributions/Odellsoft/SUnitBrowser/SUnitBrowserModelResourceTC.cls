"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

SUnitBrowserModelAbsTC subclass: #SUnitBrowserModelResourceTC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserModelResourceTC guid: (GUID fromString: '{69FC224F-4A39-4DC6-A67C-4596FE8C481D}')!
SUnitBrowserModelResourceTC comment: ''!
!SUnitBrowserModelResourceTC categoriesForClass!Unclassified! !
!SUnitBrowserModelResourceTC methodsFor!

setUp

	super setUp.

	self setUpAutoInitializeState
			!

setUpAutoInitializeState

	self model shouldInitializeResources: true			!

sunitTestCaseClass
	^SUnitResourceTC!

testResourceIsInitialized
	| testResult |

	ExampleTestResource current tearDown.

	self deny: ExampleTestResource isAvailable.

	self model runAll.

	testResult := self model testResult.

	self
		assert: testResult passedCount = 1;
		assert: testResult failureCount = 0;
		assert: testResult errorCount = 0! !
!SUnitBrowserModelResourceTC categoriesFor: #setUp!public!running! !
!SUnitBrowserModelResourceTC categoriesFor: #setUpAutoInitializeState!private!running! !
!SUnitBrowserModelResourceTC categoriesFor: #sunitTestCaseClass!constants!private! !
!SUnitBrowserModelResourceTC categoriesFor: #testResourceIsInitialized!*-unreferenced selectors!public!running! !

!SUnitBrowserModelResourceTC class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have TestCase instances 
	 built from it"

	^false	! !
!SUnitBrowserModelResourceTC class categoriesFor: #isAbstract!public!Testing! !

