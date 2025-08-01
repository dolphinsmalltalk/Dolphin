﻿"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.VersionLibrary'
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

	| size buf |
	size := self getFileVersionInfoSize: lpstrFilename lpdwHandle: nil.
	size == 0 ifTrue: [^self systemError].
	buf := ByteArray newFixed: size.
	(self
		getFileVersionInfo: lpstrFilename
		dwHandle: nil
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

	<stdcall: bool GetFileVersionInfoW lpwstr uint32 uint32 lpvoid>
	^self invalidCall: _failureCode!

getFileVersionInfoSize: lpstrFilename lpdwHandle: aDWORD
	"Answer the size of the version information reported by the host OS.

		DWORD GetFileVersionInfoSize( 
			LPTSTR lptstrFilename,	// pointer to filename string	
			LPDWORD lpdwHandle 	// pointer to variable to receive zero	
		);"

	<stdcall: uint32 GetFileVersionInfoSizeW lpwstr uint32*>
	^self invalidCall: _failureCode!

verQueryValue: pBlock lpSubBlock: lpstrSubBlock lplpBuffer: lplpBuffer puLen: puLen
	"Query selected version information from the specified version information resource
		BOOL VerQueryValue( 
			const LPVOID pBlock,	// address of buffer for version resource	
			LPWSTR lpSubBlock,	// address of value to retrieve	
			LPVOID *lplpBuffer,	// address of buffer for version value pointer	
			PUINT puLen 	// address of length buffer	
		);"

	<stdcall: bool VerQueryValueW lpvoid lpwstr lppvoid uint32*>
	^self invalidCall: _failureCode! !

!OS.VersionLibrary categoriesForMethods!
getFileVersionInfo:!helpers!private! !
getFileVersionInfo:dwHandle:dwLen:lpData:!private!win32 functions-file installation! !
getFileVersionInfoSize:lpdwHandle:!private!win32 functions-file installation! !
verQueryValue:lpSubBlock:lplpBuffer:puLen:!private!win32 functions-file installation! !
!

!OS.VersionLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'version'
! !

!OS.VersionLibrary class categoriesForMethods!
fileName!constants!public! !
!

