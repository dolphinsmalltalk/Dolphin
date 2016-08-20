"Filed out from Dolphin Smalltalk 7"!

DolphinTestClassResource subclass: #ExceptionTesterClasses
	instanceVariableNames: 'testNotificationClass resumableErrorClass testErrorClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExceptionTesterClasses guid: (GUID fromString: '{B20C60C4-BFD3-4BD6-B2C9-15A04318E517}')!
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
!ExceptionTesterClasses categoriesFor: #createClasses!Init / Release!public! !
!ExceptionTesterClasses categoriesFor: #isAvailable!public!Testing! !
!ExceptionTesterClasses categoriesFor: #resumableErrorClass!accessing!public! !
!ExceptionTesterClasses categoriesFor: #tearDown!public!Running! !
!ExceptionTesterClasses categoriesFor: #testErrorClass!accessing!public! !
!ExceptionTesterClasses categoriesFor: #testNotificationClass!accessing!public! !

