"Filed out from Dolphin Smalltalk X6"!

Notification subclass: #HRESULTNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HRESULTNotification guid: (GUID fromString: '{87B4C56E-026E-11D3-9FD7-00A0CC3E4A32}')!
HRESULTNotification comment: ''!
!HRESULTNotification categoriesForClass!System-Exception Handling! !
!HRESULTNotification methodsFor!

_descriptionArguments
	"Answer the arguments to be substitued into the receiver's Win32 description format String."

	| hresult |
	hresult := self hresult.
	^Array with: hresult with: hresult displayString with: hresult facility!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'HRESULT Success: %2 (%3)'!

hresult
	"Answer the HRESULT error code associated with the receiver."

	^self tag! !
!HRESULTNotification categoriesFor: #_descriptionArguments!displaying!public! !
!HRESULTNotification categoriesFor: #_descriptionFormat!displaying!public! !
!HRESULTNotification categoriesFor: #hresult!accessing!public! !

