"Filed out from Dolphin Smalltalk"!

ExternalLibrary subclass: #WinMMLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WinMMLibrary guid: (GUID fromString: '{6467404e-3a82-101b-8181-00aa003743d3}')!

WinMMLibrary comment: ''!

!WinMMLibrary categoriesForClass!External-Libraries-Win32! !

!WinMMLibrary methodsFor!

mciGetErrorString: code lpszErrorText: returnString cchErrorText: retsize
	"Convert an MCI error code into a String.
	Answer whether the conversion succeeded.
  		BOOL mciGetErrorString(DWORD fdwError, LPTSTR lpszErrorText, UINT cchErrorText);"

	<stdcall: bool mciGetErrorStringW dword lpwstr dword>
	^self invalidCall: _failureCode!

mciSendString: commandString
	"Send an MCI command, ignoring any return."

	^self mciSendString: commandString lpszReturnString: nil cchReturn: 0 hwndCallback: nil!

mciSendString: commandString lpszReturnString: returnString cchReturn: retsize hwndCallback: hWnd
	"Send a command string to an MCI device.
	Answers zero or an error encoded in the low-word (generic) or
	high-word (device specific).
	
	MCIERROR mciSendString(LPCWSTR lpszCommand, LPWSTR lpszReturnString,
		UINT cchReturn, HANDLE hwndCallback);"

	<stdcall: dword mciSendStringW lpwstr lpwstr dword handle>
	^self invalidCall: _failureCode!

playSound: aString hmod: anExternalHandle fdwSound: anInteger
	"Plays a sound specified by the given filename, resource, or system event. 
	A system event may be associated with a sound in the registry. 
	Answers whether successful.
			
		BOOL PlaySound(LPCWSTR pszSound, HMODULE hmod, DWORD fdwSound);"

	<stdcall: bool PlaySoundW lpvoid handle dword>
	^self invalidCall: _failureCode! !

!WinMMLibrary categoriesForMethods!
mciGetErrorString:lpszErrorText:cchErrorText:!public!win32 functions-MCI! !
mciSendString:!public!win32 functions-MCI! !
mciSendString:lpszReturnString:cchReturn:hwndCallback:!public!win32 functions-MCI! !
playSound:hmod:fdwSound:!public!win32 functions-wave audio! !
!

!WinMMLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'WinMM'! !

!WinMMLibrary class categoriesForMethods!
fileName!constants!public! !
!

