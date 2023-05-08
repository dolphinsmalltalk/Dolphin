"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTestClassResource
	subclass: #'Core.Tests.ExceptionTesterClasses'
	instanceVariableNames: 'testNotificationClass resumableErrorClass testErrorClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ExceptionTesterClasses guid: (Core.GUID fromString: '{b20c60c4-bfd3-4bd6-b2c9-15a04318e517}')!
Core.Tests.ExceptionTesterClasses comment: ''!
!Core.Tests.ExceptionTesterClasses methodsFor!

createClasses
	testNotificationClass := self
				createClass: #MyTestNotification
				superclass: Notification
				instVars: ''
				imports: #()
				classVars: ''
				classConsts: #().
	resumableErrorClass := self
				createClass: #MyResumableTestError
				superclass: Error
				instVars: ''
				imports: #()
				classVars: ''
				classConsts: #().
	resumableErrorClass compile: 'isResumable ^true'.
	testErrorClass := self
				createClass: #MyTestError
				superclass: Error
				instVars: ''
				imports: #()
				classVars: ''
				classConsts: #()!

isAvailable
	^testNotificationClass notNil!

resumableErrorClass
	^resumableErrorClass!

tearDown
	super tearDown.
	testNotificationClass := resumableErrorClass := nil!

testErrorClass
	^testErrorClass!

testNotificationClass
	^testNotificationClass! !
!Core.Tests.ExceptionTesterClasses categoriesForMethods!
createClasses!Init / Release!public! !
isAvailable!public!Testing! !
resumableErrorClass!accessing!public! !
tearDown!public!Running! !
testErrorClass!accessing!public! !
testNotificationClass!accessing!public! !
!

