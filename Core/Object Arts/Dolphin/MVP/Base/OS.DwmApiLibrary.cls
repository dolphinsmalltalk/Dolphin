"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.DwmApiLibrary'
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

	<stdcall: hresult DwmIsCompositionEnabled BOOL*>
	^self invalidCall: _failureCode! !
!OS.DwmApiLibrary categoriesFor: #dwmIsCompositionEnabled:!public! !

!OS.DwmApiLibrary class methodsFor!

fileName
	^'dwmapi'!

isDesktopCompositionEnabled
	^SystemMetrics current hasDesktopComposition and: 
			[| answer |
			answer := BOOL new.
			self default dwmIsCompositionEnabled: answer.
			answer asObject]! !
!OS.DwmApiLibrary class categoriesFor: #fileName!constants!public! !
!OS.DwmApiLibrary class categoriesFor: #isDesktopCompositionEnabled!public!queries! !

