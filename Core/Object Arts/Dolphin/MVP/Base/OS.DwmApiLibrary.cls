"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.DwmApiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.DwmApiLibrary guid: (Core.GUID fromString: '{fcb369e6-2d71-4ff5-ad95-d88dba33698c}')!
OS.DwmApiLibrary comment: ''!
!OS.DwmApiLibrary categoriesForClass!External-Libraries! !
!OS.DwmApiLibrary methodsFor!

dwmIsCompositionEnabled: pfEnabled
	"HRESULT DwmIsCompositionEnabled( BOOL *pfEnabled);"

	<stdcall: hresult DwmIsCompositionEnabled bool*>
	^self invalidCall: _failureCode! !
!OS.DwmApiLibrary categoriesForMethods!
dwmIsCompositionEnabled:!public! !
!

!OS.DwmApiLibrary class methodsFor!

fileName
	^'dwmapi'!

isDesktopCompositionEnabled
	| answer |
	answer := BOOL new.
	self default dwmIsCompositionEnabled: answer.
	^answer asObject! !
!OS.DwmApiLibrary class categoriesForMethods!
fileName!constants!public! !
isDesktopCompositionEnabled!public!queries! !
!

