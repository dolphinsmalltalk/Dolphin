"Filed out from Dolphin Smalltalk 7"!

DolphinTestClassResource subclass: #ExceptionTesterClasses
	instanceVariableNames: 'testNotificationClass resumableErrorClass testErrorClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExceptionTesterClasses guid: (GUID fromString: '{b20c60c4-bfd3-4bd6-b2c9-15a04318e517}')!
ExceptionTesterClasses comment: ''!
!ExceptionTesterClasses categoriesForClass!Unclassified! !
!ExceptionTesterClasses methodsFor!

createClasses
	testNotificationClass := self
				createClass: #MyTestNotification
				superclass: Notification
				instVars: ''
				pools: ''
				classVars: ''.
	resumableErrorClass := self
				createClass: #MyResumableTestError
				superclass: Error
				instVars: ''
				pools: ''
				classVars: ''.
	resumableErrorClass compile: 'isResumable ^true'.
	testErrorClass := self
				createClass: #MyTestError
				superclass: Error
				instVars: ''
				pools: ''
				classVars: ''!

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
!ExceptionTesterClasses categoriesFor: #createClasses!Init / Release!public! !
!ExceptionTesterClasses categoriesFor: #isAvailable!public!Testing! !
!ExceptionTesterClasses categoriesFor: #resumableErrorClass!accessing!public! !
!ExceptionTesterClasses categoriesFor: #tearDown!public!Running! !
!ExceptionTesterClasses categoriesFor: #testErrorClass!accessing!public! !
!ExceptionTesterClasses categoriesFor: #testNotificationClass!accessing!public! !

