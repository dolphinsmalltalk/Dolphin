"Filed out from Dolphin Smalltalk 7"!

NotificationSignal subclass: #WarningSignal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WarningSignal guid: (GUID fromString: '{9B47C071-B28D-4461-A804-607F147269BC}')!
WarningSignal comment: ''!
!WarningSignal categoriesForClass!Kernel-Exception Handling! !
!WarningSignal methodsFor!

defaultAction: exception
	"Private - Perform the default action for the raised incarnation of the receiver,
	exception, as it has not been handled.
	Implementation Note: forward to the SessionManager for application specific handling."

	^SessionManager current onUnhandledWarning: exception! !
!WarningSignal categoriesFor: #defaultAction:!handling!private! !

!WarningSignal class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Warning icon! !
!WarningSignal class categoriesFor: #icon!constants!public! !

