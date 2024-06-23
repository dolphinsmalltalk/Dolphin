"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.DwmApiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'DWMWA_USE_IMMERSIVE_DARK_MODE' -> 16r14 }!

OS.DwmApiLibrary guid: (Core.GUID fromString: '{fcb369e6-2d71-4ff5-ad95-d88dba33698c}')!

OS.DwmApiLibrary comment: ''!

!OS.DwmApiLibrary categoriesForClass!External-Libraries! !

!OS.DwmApiLibrary methodsFor!

dwmGetWindowAttribute: hwnd dwAttribute: dwAttribute pvAttribute: pvAttribute cbAttribute: cbAttribute
	"HRESULT DwmGetWindowAttribute(
		HWND    hwnd,
		DWORD   dwAttribute,
		[out] LPCVOID pvAttribute,
		DWORD   cbAttribute
	);"

	<stdcall: hresult DwmGetWindowAttribute handle uint32 lpvoid uint32>
	^self invalidCall: _failureCode!

dwmIsCompositionEnabled: pfEnabled
	"HRESULT DwmIsCompositionEnabled( BOOL *pfEnabled);"

	<stdcall: hresult DwmIsCompositionEnabled bool*>
	^self invalidCall: _failureCode!

dwmSetWindowAttribute: hwnd dwAttribute: dwAttribute pvAttribute: pvAttribute cbAttribute: cbAttribute
	"HRESULT DwmSetWindowAttribute(
		HWND    hwnd,
		DWORD   dwAttribute,
		[in] LPCVOID pvAttribute,
		DWORD   cbAttribute
	);"

	<stdcall: hresult DwmSetWindowAttribute handle uint32 lpvoid uint32>
	^self invalidCall: _failureCode!

hasDarkWindowFrame: aView
	| answer |
	answer := ByteArray new: 4.
	self
		dwmGetWindowAttribute: aView asParameter
		dwAttribute: DWMWA_USE_IMMERSIVE_DARK_MODE
		pvAttribute: answer
		cbAttribute: 4.
	^(answer int32AtOffset: 0) ~~ 0!

hasDarkWindowFrame: aView set: aBoolean
	| attrib |
	attrib := ByteArray new: 4.
	attrib int32AtOffset: 0 put: aBoolean asParameter.
	self
		dwmSetWindowAttribute: aView asParameter
		dwAttribute: DWMWA_USE_IMMERSIVE_DARK_MODE
		pvAttribute: attrib
		cbAttribute: 4!

isDesktopCompositionEnabled
	"As of Windows 8, this is always true. Since versions of Windows older than 10 are out of support, this should always be true."

	| answer |
	answer := ByteArray new: 4.
	self dwmIsCompositionEnabled: answer.
	^(answer int32AtOffset: 0) ~~ 0! !

!OS.DwmApiLibrary categoriesForMethods!
dwmGetWindowAttribute:dwAttribute:pvAttribute:cbAttribute:!public!win32 functions-desktop window manager! !
dwmIsCompositionEnabled:!public!win32 functions-desktop window manager! !
dwmSetWindowAttribute:dwAttribute:pvAttribute:cbAttribute:!public!win32 functions-desktop window manager! !
hasDarkWindowFrame:!public!queries! !
hasDarkWindowFrame:set:!operations!public! !
isDesktopCompositionEnabled!public!queries! !
!

!OS.DwmApiLibrary class methodsFor!

fileName
	^'dwmapi'!

isDesktopCompositionEnabled
	| answer |
	answer := BOOL new.
	self default dwmIsCompositionEnabled: answer.
	^answer asObject!

sharedVariableName
	^#{OS.Dwmapi}! !

!OS.DwmApiLibrary class categoriesForMethods!
fileName!constants!public! !
isDesktopCompositionEnabled!public!queries! !
sharedVariableName!constants!private! !
!

