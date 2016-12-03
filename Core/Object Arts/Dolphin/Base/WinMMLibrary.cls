"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #WinMMLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WinMMLibrary guid: (GUID fromString: '{6467404E-3A82-101B-8181-00AA003743D3}')!
WinMMLibrary comment: ''!
!WinMMLibrary categoriesForClass!External-Libraries-Win32! !
!WinMMLibrary methodsFor!

mciGetErrorString: code lpszErrorText: returnString cchErrorText: retsize
	"Convert an MCI error code into a String.
	Answer whether the conversion succeeded.
  		BOOL mciGetErrorString(DWORD fdwError, LPTSTR lpszErrorText, UINT cchErrorText);"

	<stdcall: bool mciGetErrorStringA dword lpvoid dword>
	^self invalidCall!

mciSendString: commandString
	"Send an MCI command, ignoring any return."

	^self mciSendString: commandString lpszReturnString: nil cchReturn: 0 hwndCallback: nil!

mciSendString: commandString lpszReturnString: returnString cchReturn: retsize hwndCallback: hWnd
	"Send a command string to an MCI device.
	Answers zero or an error encoded in the low-word (generic) or
	high-word (device specific).
	
	MCIERROR mciSendString(LPCTSTR lpszCommand, LPTSTR lpszReturnString,
		UINT cchReturn, HANDLE hwndCallback);"

	<stdcall: dword mciSendStringA lpvoid lpvoid dword handle>
	^self invalidCall!

midiOutCloseHmo: hmo

	"cdemers - 9/3/2004"
	"Private Declare Function midiOutClose Lib 'winmm.dll' (ByVal hMidiOut As Long) As Long"
"MMRESULT midiOutClose(
  HMIDIOUT hmo  
);"
	<stdcall: dword midiOutClose dword >
	^self invalidCall
!

midiOutGetNumDevs

	"cdemers - 9/3/2004"
	"UINT midiOutGetNumDevs(VOID); "
	<stdcall: dword midiOutGetNumDevs>
	^self invalidCall
!

midiOutOpenLphmo: midiOutHandle uDeviceID: uDeviceID dwCallback: dwCallback dwCallbackInstance: dwCallbackInstance dwFlags: dwFlags

	"cdemers - 9/3/2004"
"Private Declare Function midiOutOpen Lib 'winmm.dll' (lphMidiOut As Long, ByVal uDeviceID As Long, ByVal dwCallback As Long, ByVal dwInstance As Long, ByVal dwFlags As Long) As Long"
"MMRESULT midiOutOpen(
  LPHMIDIOUT lphmo,              
  UINT_PTR   uDeviceID,          
  DWORD_PTR  dwCallback,         
  DWORD_PTR  dwCallbackInstance, 
  DWORD      dwFlags             
);"
	
	<stdcall: dword midiOutOpen dword* dword dword dword dword>
	^self invalidCall
!

midiOutShortMsgHmo: hmo dwMsg: dwMsg

	"cdemers - 9/3/2004"
	"Private Declare Function midiOutShortMsg Lib 'winmm.dll' (ByVal hMidiOut As Long, ByVal dwMsg As Long) As Long"
	"MMRESULT midiOutShortMsg(
		  HMIDIOUT hmo,  
		  DWORD dwMsg);"
	<stdcall: dword midiOutShortMsg dword dword >
	^self invalidCall
!

playSound: aString hmod: anExternalHandle fdwSound: anInteger
	"Plays a sound specified by the given filename, resource, or system event. 
	A system event may be associated with a sound in the registry. 
	Answers whether successful.
			
		BOOL PlaySound(LPCSTR pszSound, HMODULE hmod, DWORD fdwSound);"

	<stdcall: bool PlaySoundA lpvoid handle dword>
	^self invalidCall!

timeGetTime

	<stdcall: dword timeGetTime>
	^self invalidCall! !
!WinMMLibrary categoriesFor: #mciGetErrorString:lpszErrorText:cchErrorText:!public!win32 functions-MCI! !
!WinMMLibrary categoriesFor: #mciSendString:!public!win32 functions-MCI! !
!WinMMLibrary categoriesFor: #mciSendString:lpszReturnString:cchReturn:hwndCallback:!public!win32 functions-MCI! !
!WinMMLibrary categoriesFor: #midiOutCloseHmo:!public! !
!WinMMLibrary categoriesFor: #midiOutGetNumDevs!public! !
!WinMMLibrary categoriesFor: #midiOutOpenLphmo:uDeviceID:dwCallback:dwCallbackInstance:dwFlags:!public! !
!WinMMLibrary categoriesFor: #midiOutShortMsgHmo:dwMsg:!public! !
!WinMMLibrary categoriesFor: #playSound:hmod:fdwSound:!public!win32 functions-wave audio! !
!WinMMLibrary categoriesFor: #timeGetTime!public!win32 functions-timer! !

!WinMMLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'WinMM'! !
!WinMMLibrary class categoriesFor: #fileName!constants!public! !

