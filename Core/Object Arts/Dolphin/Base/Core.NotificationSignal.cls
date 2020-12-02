"Filed out from Dolphin Smalltalk 7"!

Signal subclass: #NotificationSignal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
NotificationSignal guid: (GUID fromString: '{87b4c6de-026e-11d3-9fd7-00a0cc3e4a32}')!
NotificationSignal comment: ''!
!NotificationSignal categoriesForClass!Kernel-Exception Handling! !
!NotificationSignal methodsFor!

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
!NotificationSignal categoriesFor: #defaultAction:!handling!private! !
!NotificationSignal categoriesFor: #defaultResumption!constants!private! !
!NotificationSignal categoriesFor: #exceptionClass!constants!private! !

