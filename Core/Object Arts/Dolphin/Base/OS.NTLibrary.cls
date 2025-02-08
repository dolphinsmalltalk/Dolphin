"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.NTLibrary'
	instanceVariableNames: 'isWine'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.NTLibrary guid: (Core.GUID fromString: '{8293e458-7d81-4aba-97a5-c1001c4b2153}')!

OS.NTLibrary comment: 'NtDllLibrary is the <ExternalLibrary> class to represent the dynamic link library, ''ntdll.dll''. It was generated from type information in the ''Win32 API'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring For this Module
	"Windows NT Runtime Library"

Warning: This comment was automatically generated from the Module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.
'!

!OS.NTLibrary categoriesForClass!External-Libraries! !

!OS.NTLibrary methodsFor!

initialize
	super initialize.
	isWine := self wineGetVersion notNil!

isWine
	^isWine!

ntQueryTimerResolution: pulMinimumResolution maximum: pulMaximumResolution actual: pulActualResolution
	<stdcall: int32 NtQueryTimerResolution lpvoid lpvoid lpvoid>
	^self invalidCall: _failureCode!

rtlNtStatusToDosError: anInteger
	<stdcall: uint32 RtlNtStatusToDosError ntstatus>
	^self invalidCall: _failureCode!

setTimerResolution: anInteger set: aBoolean actualResolution: actualResolution
	"NTSYSAPI
		NTSTATUS
		NTAPI
		NtSetTimerResolution(
			IN ULONG RequestedResolution,
			IN BOOLEAN Set,
			OUT PULONG ActualResolution"

	<stdcall: uint32 NtSetTimerResolution uint32 bool uint32*>
	^self invalidCall: _failureCode!

wineGetVersion
	"static const char * (CDECL *pwine_get_version)(void);"

	<stdcall: lpstr wine_get_version>
	^nil	"instead of reporting an error"! !

!OS.NTLibrary categoriesForMethods!
initialize!initializing!public! !
isWine!public!testing! !
ntQueryTimerResolution:maximum:actual:!public!win32 functions-timer! !
rtlNtStatusToDosError:!public!win32 functions-error handling! !
setTimerResolution:set:actualResolution:!public!win32 functions-timer! !
wineGetVersion!public! !
!

!OS.NTLibrary class methodsFor!

fileName
	"Answer the host system file name for the external library the 
	receiver represents."

	^'ntdll'!

sharedVariableName
	^#{NtDll}! !

!OS.NTLibrary class categoriesForMethods!
fileName!**auto generated**!constants!public! !
sharedVariableName!constants!private!realizing/unrealizing! !
!

