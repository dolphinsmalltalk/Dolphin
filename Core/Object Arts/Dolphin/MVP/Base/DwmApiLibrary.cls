"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #DwmApiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DwmApiLibrary guid: (GUID fromString: '{FCB369E6-2D71-4FF5-AD95-D88DBA33698C}')!
DwmApiLibrary comment: ''!
!DwmApiLibrary categoriesForClass!External-Libraries! !
!DwmApiLibrary methodsFor!

dwmIsCompositionEnabled: pfEnabled 
	"HRESULT DwmIsCompositionEnabled( BOOL *pfEnabled);"

	<stdcall: hresult DwmIsCompositionEnabled BOOL*>
	^self invalidCall! !
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

