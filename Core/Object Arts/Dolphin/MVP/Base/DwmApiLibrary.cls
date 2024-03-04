"Filed out from Dolphin Smalltalk"!

ExternalLibrary subclass: #DwmApiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DwmApiLibrary guid: (GUID fromString: '{fcb369e6-2d71-4ff5-ad95-d88dba33698c}')!

DwmApiLibrary comment: ''!

!DwmApiLibrary categoriesForClass!External-Libraries! !

!DwmApiLibrary methodsFor!

dwmIsCompositionEnabled: pfEnabled
	"HRESULT DwmIsCompositionEnabled( BOOL *pfEnabled);"

	<stdcall: hresult DwmIsCompositionEnabled BOOL*>
	^self invalidCall: _failureCode! !

!DwmApiLibrary categoriesForMethods!
dwmIsCompositionEnabled:!public! !
!

!DwmApiLibrary class methodsFor!

fileName
	^'dwmapi'!

isDesktopCompositionEnabled
	| answer |
	answer := DWORDBytes new.
	self default dwmIsCompositionEnabled: answer.
	^answer value asBoolean! !

!DwmApiLibrary class categoriesForMethods!
fileName!constants!public! !
isDesktopCompositionEnabled!public!queries! !
!

