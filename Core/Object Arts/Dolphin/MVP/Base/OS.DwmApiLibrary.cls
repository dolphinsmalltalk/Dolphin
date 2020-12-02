"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #DwmApiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DwmApiLibrary guid: (GUID fromString: '{fcb369e6-2d71-4ff5-ad95-d88dba33698c}')!
DwmApiLibrary comment: ''!
!DwmApiLibrary categoriesForClass!External-Libraries! !
!DwmApiLibrary methodsFor!

dwmIsCompositionEnabled: pfEnabled
	"HRESULT DwmIsCompositionEnabled( BOOL *pfEnabled);"

	<stdcall: hresult DwmIsCompositionEnabled BOOL*>
	^self invalidCall: _failureCode! !
!DwmApiLibrary categoriesFor: #dwmIsCompositionEnabled:!public! !

!DwmApiLibrary class methodsFor!

fileName
	^'dwmapi'!

isDesktopCompositionEnabled
	^SystemMetrics current hasDesktopComposition and: 
			[| answer |
			answer := BOOL new.
			self default dwmIsCompositionEnabled: answer.
			answer asObject]! !
!DwmApiLibrary class categoriesFor: #fileName!constants!public! !
!DwmApiLibrary class categoriesFor: #isDesktopCompositionEnabled!public!queries! !

