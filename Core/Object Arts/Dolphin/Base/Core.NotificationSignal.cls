"Filed out from Dolphin Smalltalk 7"!

Core.Signal subclass: #'Core.NotificationSignal'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.NotificationSignal guid: (Core.GUID fromString: '{87b4c6de-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.NotificationSignal comment: ''!
!Core.NotificationSignal categoriesForClass!Kernel-Exception Handling! !
!Core.NotificationSignal methodsFor!

defaultAction: exception
	"Private - Perform the default action for the raised incarnation of the receiver,
	exception, as it has not been handled.
	Implementation Note: forward to the SessionManager for application specific handling."

	^SessionManager current onUnhandledNotification: exception!

defaultResumption
	"Private - Answer the default setting for the receiver's resumable flag."

	^true!

exceptionClass
	"Private - Answer the class of Exception to be raised when the receiver
	is signalled."

	^RaisedNotificationSignal! !
!Core.NotificationSignal categoriesFor: #defaultAction:!handling!private! !
!Core.NotificationSignal categoriesFor: #defaultResumption!constants!private! !
!Core.NotificationSignal categoriesFor: #exceptionClass!constants!private! !

