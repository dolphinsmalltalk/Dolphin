"Filed out from Dolphin Smalltalk X6"!

ExternalLibrary subclass: #VersionLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VersionLibrary guid: (GUID fromString: '{64674068-3A82-101B-8181-00AA003743D3}')!
VersionLibrary comment: 'VersionLibrary is the <ExternalLibrary> class to represent the Win32 version library, VERSION.DLL.

The version libraries API is somewhat esoteric and best accessed via the services of the VersionInfo class.
'!
!VersionLibrary categoriesForClass!External-Libraries! !
!VersionLibrary methodsFor!

getFileVersionInfo: lpstrFilename 
	"Private - Answer file version info for the specified file."

	| dwHandle size buf |
	dwHandle := DWORDBytes new.
	size := self getFileVersionInfoSize: lpstrFilename lpdwHandle: dwHandle.
	size == 0 ifTrue: [^self systemError].
	buf := ByteArray newFixed: size.
	(self 
		getFileVersionInfo: lpstrFilename
		dwHandle: dwHandle asParameter
		dwLen: size
		lpData: buf) ifFalse: [^self systemError].
	^buf!

getFileVersionInfo: lpstrFilename dwHandle: dwHandle dwLen: dwLen lpData: lpData
	"Returns version information about the specified file.
		BOOL GetFileVersionInfo( 
			LPTSTR lptstrFilename,	// pointer to filename string	
			DWORD dwHandle,	// ignored	
			DWORD dwLen,	// size of buffer	
			LPVOID lpData 	// pointer to buffer to receive file-version info.	
		);"

	<stdcall: bool GetFileVersionInfoA lpstr dword dword lpvoid>
	^self invalidCall
!

getFileVersionInfoSize: lpstrFilename lpdwHandle: aDWORD
	"Answer the size of the version information reported by the host OS.

		DWORD GetFileVersionInfoSize( 
			LPTSTR lptstrFilename,	// pointer to filename string	
			LPDWORD lpdwHandle 	// pointer to variable to receive zero	
		);"

	<stdcall: dword GetFileVersionInfoSizeA lpstr DWORD* >
	^self invalidCall
!

verQueryValue: pBlock lpSubBlock: lpstrSubBlock lplpBuffer: lplpBuffer puLen: puLen
	"Query selected version information from the specified version information resource
		BOOL VerQueryValue( 
			const LPVOID pBlock,	// address of buffer for version resource	
			LPTSTR lpSubBlock,	// address of value to retrieve	
			LPVOID *lplpBuffer,	// address of buffer for version value pointer	
			PUINT puLen 	// address of length buffer	
		);" 

	<stdcall: bool VerQueryValueA lpvoid lpstr lppvoid DWORD* >
	^self invalidCall

! !
!VersionLibrary categoriesFor: #getFileVersionInfo:!helpers!private! !
!VersionLibrary categoriesFor: #getFileVersionInfo:dwHandle:dwLen:lpData:!private!win32 functions-file installation! !
!VersionLibrary categoriesFor: #getFileVersionInfoSize:lpdwHandle:!private!win32 functions-file installation! !
!VersionLibrary categoriesFor: #verQueryValue:lpSubBlock:lplpBuffer:puLen:!private!win32 functions-file installation! !

!VersionLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'Version'
! !
!VersionLibrary class categoriesFor: #fileName!constants!public! !

