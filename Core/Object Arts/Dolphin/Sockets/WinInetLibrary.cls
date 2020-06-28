"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #WinInetLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WinInetLibrary guid: (GUID fromString: '{96152a1d-1214-4ed9-82f2-10021d755f70}')!
WinInetLibrary comment: ''!
!WinInetLibrary categoriesForClass!External-Libraries-Win32! !
!WinInetLibrary methodsFor!

internetCheckConnection: url dwFlags: flags dwReserved: reserved
	"Allows an application to check if a connection to the Internet can be established.

	BOOL InternetCheckConnection(
		IN LPCWSTR lpszUrl,
		IN DWORD dwFlags,
		IN DWORD dwReserved
		);"

	<stdcall: bool InternetCheckConnectionW lpwstr dword dword>
	^self invalidCall: _failureCode!

internetGoOnline: url hwndParent: parent dwReserved: reserved
	"Prompts the user for permission to initiate connection to a URL.

	BOOL InternetGoOnline(
		IN LPTSTR lpszURL,
		IN HWND hwndParent,
		IN DWORD dwReserved
		);"

	<stdcall: bool InternetGoOnlineW lpwstr handle dword>
	^self invalidCall: _failureCode!

internetOpen: agent dwAccessType: access lpszProxyName: proxyName lpszProxyBypass: proxyBypass dwFlags: flags
	"Initializes an application's use of the Win32 Internet functions.

	HINTERNET InternetOpen( IN LPCTSTR lpszAgent, 
		IN DWORD dwAccessType, 
		IN LPCTSTR lpszProxyName, 
		IN LPCTSTR lpszProxyBypass, 
		IN DWORD dwFlags ); "

	<stdcall: handle InternetOpenW lpwstr dword lpwstr lpwstr dword>
	^self invalidCall: _failureCode!

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

