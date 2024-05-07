"Filed out from Dolphin Smalltalk"!

DolphinTestClassResource subclass: #ExceptionTesterClasses
	instanceVariableNames: 'testNotificationClass resumableErrorClass testErrorClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExceptionTesterClasses guid: (GUID fromString: '{b20c60c4-bfd3-4bd6-b2c9-15a04318e517}')!

ExceptionTesterClasses comment: ''!

!ExceptionTesterClasses categoriesForClass!Unclassified! !

!ExceptionTesterClasses methodsFor!

createClasses
	testNotificationClass := self
				createClass: #MyTestNotification
				superclass: Notification
				instVars: ''
				pools: ''.
	resumableErrorClass := self
				createClass: #MyResumableTestError
				superclass: Error
				instVars: ''
				pools: ''.
	resumableErrorClass compile: 'isResumable ^true'.
	testErrorClass := self
				createClass: #MyTestError
				superclass: Error
				instVars: ''
				pools: ''!

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

!ExceptionTesterClasses categoriesForMethods!
createClasses!Init / Release!public! !
isAvailable!public!Testing! !
resumableErrorClass!accessing!public! !
tearDown!public!Running! !
testErrorClass!accessing!public! !
testNotificationClass!accessing!public! !
!

