"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTestClassResource subclass: #'Core.Tests.ExceptionTesterClasses'
	instanceVariableNames: 'testNotificationClass resumableErrorClass testErrorClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ExceptionTesterClasses guid: (Core.GUID fromString: '{b20c60c4-bfd3-4bd6-b2c9-15a04318e517}')!
Core.Tests.ExceptionTesterClasses comment: ''!
!Core.Tests.ExceptionTesterClasses categoriesForClass!Unclassified! !
!Core.Tests.ExceptionTesterClasses methodsFor!

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
!Core.Tests.ExceptionTesterClasses categoriesFor: #createClasses!Init / Release!public! !
!Core.Tests.ExceptionTesterClasses categoriesFor: #isAvailable!public!Testing! !
!Core.Tests.ExceptionTesterClasses categoriesFor: #resumableErrorClass!accessing!public! !
!Core.Tests.ExceptionTesterClasses categoriesFor: #tearDown!public!Running! !
!Core.Tests.ExceptionTesterClasses categoriesFor: #testErrorClass!accessing!public! !
!Core.Tests.ExceptionTesterClasses categoriesFor: #testNotificationClass!accessing!public! !

