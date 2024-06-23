"Filed out from Dolphin Smalltalk"!

Core.Notification
	subclass: #'OS.HRESULTNotification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.HRESULTNotification guid: (Core.GUID fromString: '{87b4c56e-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.HRESULTNotification comment: ''!

!OS.HRESULTNotification categoriesForClass!System-Exception Handling! !

!OS.HRESULTNotification methodsFor!

_descriptionArguments
	"Answer the arguments to be substitued into the receiver's Win32 description format String."

	| hresult |
	hresult := self hresult.
	^{hresult. hresult displayString. hresult facility}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'HRESULT Success: %2 (%3)'!

hresult
	"Answer the HRESULT error code associated with the receiver."

	^self tag! !

!OS.HRESULTNotification categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
hresult!accessing!public! !
!

