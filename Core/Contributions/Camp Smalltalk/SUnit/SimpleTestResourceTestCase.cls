"Filed out from Dolphin Smalltalk X6.1"!

TestCase subclass: #SimpleTestResourceTestCase
	instanceVariableNames: 'resource'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimpleTestResourceTestCase guid: (GUID fromString: '{8998FFB7-787B-4DA1-99FD-2F92B2C4E993}')!
SimpleTestResourceTestCase comment: ''!
!SimpleTestResourceTestCase categoriesForClass!SUnit! !
!SimpleTestResourceTestCase methodsFor!

dummy
	self assert: true!

error
	1 zork!

fail
	self assert: false!

setRun
	resource setRun!

setUp
	resource := SimpleTestResource current!

testRan
	| case |

	case := self class selector: #setRun.
	case run.
	self assert: resource hasSetup.
	self assert: resource hasRun!

testResourceInitRelease
	| result suite error failure |
	suite := TestSuite new.
	suite addTest: (error := self class selector: #error).
	suite addTest: (failure := self class selector: #fail).
	suite addTest: (self class selector: #dummy).
	result := suite run.
	self assert: resource hasSetup!

testResourcesCollection
	| collection |
	collection := self resources.
	self assert: collection size = 1! !
!SimpleTestResourceTestCase categoriesFor: #dummy!public! !
!SimpleTestResourceTestCase categoriesFor: #error!public! !
!SimpleTestResourceTestCase categoriesFor: #fail!public! !
!SimpleTestResourceTestCase categoriesFor: #setRun!public! !
!SimpleTestResourceTestCase categoriesFor: #setUp!public! !
!SimpleTestResourceTestCase categoriesFor: #testRan!public! !
!SimpleTestResourceTestCase categoriesFor: #testResourceInitRelease!public! !
!SimpleTestResourceTestCase categoriesFor: #testResourcesCollection!public! !

!SimpleTestResourceTestCase class methodsFor!

resources
	^Set new add: SimpleTestResource; yourself! !
!SimpleTestResourceTestCase class categoriesFor: #resources!public! !

