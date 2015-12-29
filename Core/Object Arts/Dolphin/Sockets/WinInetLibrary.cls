"Filed out from Dolphin Smalltalk X6"!

ExternalLibrary subclass: #WinInetLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WinInetLibrary guid: (GUID fromString: '{96152A1D-1214-4ED9-82F2-10021D755F70}')!
WinInetLibrary comment: ''!
!WinInetLibrary categoriesForClass!External-Libraries-Win32! !
!WinInetLibrary methodsFor!

internetCheckConnection: url dwFlags: flags dwReserved: reserved
	"Allows an application to check if a connection to the Internet can be established.

	BOOL InternetCheckConnection(
		IN LPCTSTR lpszUrl,
		IN DWORD dwFlags,
		IN DWORD dwReserved
		);"

	<stdcall: bool InternetCheckConnectionA lpstr dword dword>
	^self invalidCall!

internetGoOnline: url hwndParent: parent dwReserved: reserved
	"Prompts the user for permission to initiate connection to a URL.

	BOOL InternetGoOnline(
		IN LPTSTR lpszURL,
		IN HWND hwndParent,
		IN DWORD dwReserved
		);"

	<stdcall: bool InternetGoOnline lpstr handle dword>
	^self invalidCall!

internetOpen: agent dwAccessType: access lpszProxyName: proxyName lpszProxyBypass: proxyBypass dwFlags: flags
	"Initializes an application's use of the Win32 Internet functions.

	HINTERNET InternetOpen( IN LPCTSTR lpszAgent, 
		IN DWORD dwAccessType, 
		IN LPCTSTR lpszProxyName, 
		IN LPCTSTR lpszProxyBypass, 
		IN DWORD dwFlags ); "

	<stdcall: handle InternetOpenA lpstr dword lpstr lpstr dword>
	^self invalidCall!

ping: aURL
	"Attempts to ping aURL. Answers true if a reply is received."

	^self internetCheckConnection: aURL dwFlags: 1 dwReserved: 0! !
!WinInetLibrary categoriesFor: #internetCheckConnection:dwFlags:dwReserved:!public!win32 functions-internet! !
!WinInetLibrary categoriesFor: #internetGoOnline:hwndParent:dwReserved:!public!win32 functions-internet! !
!WinInetLibrary categoriesFor: #internetOpen:dwAccessType:lpszProxyName:lpszProxyBypass:dwFlags:!public!win32 functions-internet! !
!WinInetLibrary categoriesFor: #ping:!operations!public! !

!WinInetLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'WinInet'! !
!WinInetLibrary class categoriesFor: #fileName!constants!public! !

