"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.WinMMLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.WinMMLibrary guid: (Core.GUID fromString: '{6467404e-3a82-101b-8181-00aa003743d3}')!
OS.WinMMLibrary comment: ''!
!OS.WinMMLibrary categoriesForClass!External-Libraries-Win32! !
!OS.WinMMLibrary methodsFor!

mciGetErrorString: code lpszErrorText: returnString cchErrorText: retsize
	"Convert an MCI error code into a String.
	Answer whether the conversion succeeded.
  		BOOL mciGetErrorString(DWORD fdwError, LPTSTR lpszErrorText, UINT cchErrorText);"

	<stdcall: bool mciGetErrorStringW uint32 lpwstr uint32>
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

	<stdcall: uint32 mciSendStringW lpwstr lpwstr uint32 handle>
	^self invalidCall: _failureCode!

playSound: aString hmod: anExternalHandle fdwSound: anInteger
	"Plays a sound specified by the given filename, resource, or system event. 
	A system event may be associated with a sound in the registry. 
	Answers whether successful.
			
		BOOL PlaySound(LPCWSTR pszSound, HMODULE hmod, DWORD fdwSound);"

	<stdcall: bool PlaySoundW lpvoid handle uint32>
	^self invalidCall: _failureCode! !
!OS.WinMMLibrary categoriesForMethods!
mciGetErrorString:lpszErrorText:cchErrorText:!public!win32 functions-MCI! !
mciSendString:!public!win32 functions-MCI! !
mciSendString:lpszReturnString:cchReturn:hwndCallback:!public!win32 functions-MCI! !
playSound:hmod:fdwSound:!public!win32 functions-wave audio! !
!

!OS.WinMMLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'WinMM'! !
!OS.WinMMLibrary class categoriesForMethods!
fileName!constants!public! !
!

