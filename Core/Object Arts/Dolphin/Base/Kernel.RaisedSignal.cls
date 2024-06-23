"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Kernel.RaisedSignal'
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.RaisedSignal guid: (Core.GUID fromString: '{87b4c55f-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.RaisedSignal comment: ''!

!Kernel.RaisedSignal categoriesForClass!Kernel-Exception Handling! !

!Kernel.RaisedSignal methodsFor!

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

messageText
	^messageText ifNil: [signalType description]!

signalType
	"Private - Answer the instance of Signal for which the receiver is representing
	a raise event."

	^signalType!

signalType: aSignal
	"Private - Set the instance of Signal for which the receiver is representing
	a raise event."

	signalType := aSignal! !

!Kernel.RaisedSignal categoriesForMethods!
_descriptionFormat!displaying!public! !
defaultAction!handling!public! !
isResumable!public!testing! !
messageText!accessing!public! !
signalType!accessing!private! !
signalType:!accessing!private! !
!

