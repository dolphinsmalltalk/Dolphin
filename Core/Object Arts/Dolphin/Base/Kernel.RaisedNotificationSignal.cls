"Filed out from Dolphin Smalltalk 7"!

Core.Notification subclass: #'Kernel.RaisedNotificationSignal'
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.RaisedNotificationSignal guid: (Core.GUID fromString: '{586eb660-437d-11d3-97aa-0080c8d59432}')!
Kernel.RaisedNotificationSignal comment: 'RaisedNotificationSignal is the class of Error whose instances are used to represent NotificationSignal instances when raised. That is it enables instance based notifications (NotificationSignals) to be raised within Dolphin''s class based exception framework.

Instances Variables:
	signalType		<Signal>. The signal instance which originated this exception.'!
!Kernel.RaisedNotificationSignal categoriesForClass!Kernel-Exception Handling! !
!Kernel.RaisedNotificationSignal methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver -
	we delegate this back to the Signal instance we are representing."

	^self signalType description!

defaultAction
	"The receiver is an unhandled notification, perform the default action
	(forward to the SessionManager for application customisation)."

	^self signalType defaultAction: self!

isResumable
	"Answer whether the receiver represents a resumable error. This depends on the originating Signal."

	^self signalType isResumable!

signalType
	"Private - Answer the instance of Signal for which the receiver is representing
	a raise event."

	^signalType!

signalType: aSignal
	"Private - Set the instance of Signal for which the receiver is representing
	a raise event."

	signalType := aSignal! !
!Kernel.RaisedNotificationSignal categoriesFor: #_descriptionFormat!displaying!public! !
!Kernel.RaisedNotificationSignal categoriesFor: #defaultAction!handling!public! !
!Kernel.RaisedNotificationSignal categoriesFor: #isResumable!public!testing! !
!Kernel.RaisedNotificationSignal categoriesFor: #signalType!accessing!private! !
!Kernel.RaisedNotificationSignal categoriesFor: #signalType:!accessing!private! !

