"Filed out from Dolphin Smalltalk"!

Notification subclass: #HRESULTNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HRESULTNotification guid: (GUID fromString: '{87b4c56e-026e-11d3-9fd7-00a0cc3e4a32}')!
HRESULTNotification comment: ''!
!HRESULTNotification categoriesForClass!System-Exception Handling! !
!HRESULTNotification methodsFor!

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
!HRESULTNotification categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
hresult!accessing!public! !
!

