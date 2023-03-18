"Filed out from Dolphin Smalltalk"!

Core.NotificationSignal
	subclass: #'Core.WarningSignal'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WarningSignal guid: (Core.GUID fromString: '{9b47c071-b28d-4461-a804-607f147269bc}')!
Core.WarningSignal comment: ''!
!Core.WarningSignal categoriesForClass!Kernel-Exception Handling! !
!Core.WarningSignal methodsFor!

defaultAction: exception
	"Private - Perform the default action for the raised incarnation of the receiver,
	exception, as it has not been handled.
	Implementation Note: forward to the SessionManager for application specific handling."

	^SessionManager current onUnhandledWarning: exception! !
!Core.WarningSignal categoriesForMethods!
defaultAction:!handling!private! !
!

