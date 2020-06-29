"Filed out from Dolphin Smalltalk 7"!

NotificationSignal subclass: #WarningSignal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WarningSignal guid: (GUID fromString: '{9b47c071-b28d-4461-a804-607f147269bc}')!
WarningSignal comment: ''!
!WarningSignal categoriesForClass!Kernel-Exception Handling! !
!WarningSignal methodsFor!

defaultAction: exception
	"Private - Perform the default action for the raised incarnation of the receiver,
	exception, as it has not been handled.
	Implementation Note: forward to the SessionManager for application specific handling."

	^SessionManager current onUnhandledWarning: exception! !
!WarningSignal categoriesFor: #defaultAction:!handling!private! !

