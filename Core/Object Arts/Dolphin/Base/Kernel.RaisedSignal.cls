"Filed out from Dolphin Smalltalk 7"!

Error subclass: #RaisedSignal
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RaisedSignal guid: (GUID fromString: '{87b4c55f-026e-11d3-9fd7-00a0cc3e4a32}')!
RaisedSignal comment: ''!
!RaisedSignal categoriesForClass!Kernel-Exception Handling! !
!RaisedSignal methodsFor!

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
!RaisedSignal categoriesFor: #_descriptionFormat!displaying!public! !
!RaisedSignal categoriesFor: #defaultAction!handling!public! !
!RaisedSignal categoriesFor: #isResumable!public!testing! !
!RaisedSignal categoriesFor: #messageText!accessing!public! !
!RaisedSignal categoriesFor: #signalType!accessing!private! !
!RaisedSignal categoriesFor: #signalType:!accessing!private! !

