"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.VersionLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.VersionLibrary guid: (Core.GUID fromString: '{64674068-3a82-101b-8181-00aa003743d3}')!
OS.VersionLibrary comment: 'VersionLibrary is the <ExternalLibrary> class to represent the Win32 version library, VERSION.DLL.

The version libraries API is somewhat esoteric and best accessed via the services of the VersionInfo class.
'!
!OS.VersionLibrary categoriesForClass!External-Libraries! !
!OS.VersionLibrary methodsFor!

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

	<stdcall: bool GetFileVersionInfoW lpwstr dword dword lpvoid>
	^self invalidCall: _failureCode!

getFileVersionInfoSize: lpstrFilename lpdwHandle: aDWORD
	"Answer the size of the version information reported by the host OS.

		DWORD GetFileVersionInfoSize( 
			LPTSTR lptstrFilename,	// pointer to filename string	
			LPDWORD lpdwHandle 	// pointer to variable to receive zero	
		);"

	<stdcall: dword GetFileVersionInfoSizeW lpwstr dword*>
	^self invalidCall: _failureCode!

verQueryValue: pBlock lpSubBlock: lpstrSubBlock lplpBuffer: lplpBuffer puLen: puLen
	"Query selected version information from the specified version information resource
		BOOL VerQueryValue( 
			const LPVOID pBlock,	// address of buffer for version resource	
			LPWSTR lpSubBlock,	// address of value to retrieve	
			LPVOID *lplpBuffer,	// address of buffer for version value pointer	
			PUINT puLen 	// address of length buffer	
		);"

	<stdcall: bool VerQueryValueW lpvoid lpwstr lppvoid dword*>
	^self invalidCall: _failureCode! !
!OS.VersionLibrary categoriesFor: #getFileVersionInfo:!helpers!private! !
!OS.VersionLibrary categoriesFor: #getFileVersionInfo:dwHandle:dwLen:lpData:!private!win32 functions-file installation! !
!OS.VersionLibrary categoriesFor: #getFileVersionInfoSize:lpdwHandle:!private!win32 functions-file installation! !
!OS.VersionLibrary categoriesFor: #verQueryValue:lpSubBlock:lplpBuffer:puLen:!private!win32 functions-file installation! !

!OS.VersionLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'Version'
! !
!OS.VersionLibrary class categoriesFor: #fileName!constants!public! !

