"Filed out from Dolphin Smalltalk"!

ExternalLibrary subclass: #SHCoreLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SHCoreLibrary guid: (GUID fromString: '{b2b33d35-56b5-4b8d-bee9-2a4ada5b9d7a}')!

SHCoreLibrary comment: ''!

!SHCoreLibrary categoriesForClass!External-Libraries! !

!SHCoreLibrary methodsFor!

getDpiForMonitor: hmonitor dpiType: dpiType dpiX: dpiX dpiY: dpiY
	<stdcall: hresult GetDpiForMonitor handle sdword dword* dword*>
	^self invalidCall: _failureCode! !

!SHCoreLibrary categoriesForMethods!
getDpiForMonitor:dpiType:dpiX:dpiY:!public!win32 functions-high DPI! !
!

!SHCoreLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'SHCore'! !

!SHCoreLibrary class categoriesForMethods!
fileName!constants!public! !
!

