"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #NTLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NTLibrary guid: (GUID fromString: '{8293E458-7D81-4ABA-97A5-C1001C4B2153}')!
NTLibrary comment: ''!
!NTLibrary categoriesForClass!External-Libraries! !
!NTLibrary methodsFor!

ntQueryTimerResolution: pulMinimumResolution maximum: pulMaximumResolution actual: pulActualResolution
	<stdcall: sdword NtQueryTimerResolution dword* dword* dword*>
	^self invalidCall!

setTimerResolution: anInteger set: aBoolean actualResolution: actualResolution 
	"NTSYSAPI
		NTSTATUS
		NTAPI
		NtSetTimerResolution(
			IN ULONG RequestedResolution,
			IN BOOLEAN Set,
			OUT PULONG ActualResolution"

	<stdcall: dword NtSetTimerResolution dword bool dword*>
	^self invalidCall!

wineGetVersion
	"static const char * (CDECL *pwine_get_version)(void);"

	<stdcall: lpstr wine_get_version>
	^nil	"instead of reporting an error"! !
!NTLibrary categoriesFor: #ntQueryTimerResolution:maximum:actual:!public! !
!NTLibrary categoriesFor: #setTimerResolution:set:actualResolution:!accessing!public! !
!NTLibrary categoriesFor: #wineGetVersion!public! !

!NTLibrary class methodsFor!

fileName
	"Answer the host system file name for the external library the 
	receiver represents."

	^'ntdll'!

isWine
"
	NTLibrary isWine.
"
	^self default wineGetVersion notNil! !
!NTLibrary class categoriesFor: #fileName!constants!public! !
!NTLibrary class categoriesFor: #isWine!public! !

