"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.SHCoreLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.SHCoreLibrary guid: (Core.GUID fromString: '{b2b33d35-56b5-4b8d-bee9-2a4ada5b9d7a}')!

OS.SHCoreLibrary comment: ''!

!OS.SHCoreLibrary categoriesForClass!External-Libraries! !

!OS.SHCoreLibrary methodsFor!

getDpiForMonitor: hmonitor dpiType: dpiType dpiX: dpiX dpiY: dpiY
	<stdcall: hresult GetDpiForMonitor handle int32 uint32* uint32*>
	^self invalidCall: _failureCode! !

!OS.SHCoreLibrary categoriesForMethods!
getDpiForMonitor:dpiType:dpiX:dpiY:!public!win32 functions-high DPI! !
!

!OS.SHCoreLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'SHCore'! !

!OS.SHCoreLibrary class categoriesForMethods!
fileName!constants!public! !
!

