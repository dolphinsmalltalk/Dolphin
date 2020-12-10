"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #'XProgramming.SUnit.SimpleTestResourceTestCase'
	instanceVariableNames: 'resource'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.SimpleTestResourceTestCase guid: (Core.GUID fromString: '{8998ffb7-787b-4da1-99fd-2f92b2c4e993}')!
XProgramming.SUnit.SimpleTestResourceTestCase comment: ''!
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesForClass!SUnit! !
!XProgramming.SUnit.SimpleTestResourceTestCase methodsFor!

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
	self assert: collection size equals: 1! !
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesFor: #dummy!public! !
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesFor: #error!public! !
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesFor: #fail!public! !
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesFor: #setRun!public! !
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesFor: #setUp!public! !
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesFor: #testRan!public! !
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesFor: #testResourceInitRelease!public! !
!XProgramming.SUnit.SimpleTestResourceTestCase categoriesFor: #testResourcesCollection!public! !

!XProgramming.SUnit.SimpleTestResourceTestCase class methodsFor!

resources
	^Set new
		add: SimpleTestResource;
		yourself! !
!XProgramming.SUnit.SimpleTestResourceTestCase class categoriesFor: #resources!public! !

