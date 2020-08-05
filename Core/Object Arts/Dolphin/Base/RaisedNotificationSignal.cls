"Filed out from Dolphin Smalltalk 7"!

Notification subclass: #RaisedNotificationSignal
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
RaisedNotificationSignal guid: (GUID fromString: '{586eb660-437d-11d3-97aa-0080c8d59432}')!
RaisedNotificationSignal comment: 'RaisedNotificationSignal is the class of Error whose instances are used to represent NotificationSignal instances when raised. That is it enables instance based notifications (NotificationSignals) to be raised within Dolphin''s class based exception framework.

Instances Variables:
	signalType		<Signal>. The signal instance which originated this exception.'!
!RaisedNotificationSignal categoriesForClass!Kernel-Exception Handling! !
!RaisedNotificationSignal methodsFor!

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
!RaisedNotificationSignal categoriesFor: #_descriptionFormat!displaying!public! !
!RaisedNotificationSignal categoriesFor: #defaultAction!handling!public! !
!RaisedNotificationSignal categoriesFor: #isResumable!public!testing! !
!RaisedNotificationSignal categoriesFor: #signalType!accessing!private! !
!RaisedNotificationSignal categoriesFor: #signalType:!accessing!private! !

