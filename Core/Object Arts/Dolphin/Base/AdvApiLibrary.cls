"Filed out from Dolphin Smalltalk X6"!

ExternalLibrary subclass: #AdvApiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AdvApiLibrary guid: (GUID fromString: '{64674054-3A82-101B-8181-00AA003743D3}')!
AdvApiLibrary comment: 'AdvApiLibrary is the <ExternalLibrary> class to represent the Win32 system DLL, ADVAPI32.DLL.

This DLL contains functions mainly to do with accessing the registry, high-level access to which is available via Dolphin''s RegKey classes.
'!
!AdvApiLibrary categoriesForClass!External-Libraries-Win32! !
!AdvApiLibrary methodsFor!

deregisterEventSource: anExternalHandle 
	<stdcall: bool DeregisterEventSource handle>
	^self invalidCall!

getUserName: buffer nSize: pBufSize 
	"Retrieve the user name of the current thread. This is the name of the user currently 
	logged onto the system. 
		BOOL GetUserName(
  			LPTSTR lpBuffer,	// address of name buffer 
			LPDWORD nSize 		// address of size of name buffer 
		);"

	<stdcall: bool GetUserNameA lpstr DWORD*>
	^self invalidCall!

regCloseKey: hKey
	"Release the handle of the specified registry key.

		LONG RegCloseKey( 
			HKEYhKey 	// handle of key to close 
		);"

	<stdcall: sdword RegCloseKey handle>
	^self invalidCall!

regConnectRegistry: lpMachineName hKey: hKey phkResult: phkResult
	"
		LONG RegConnectRegistry( 
			LPTSTRlpMachineName,	// address of name of remote computer 
			HKEYhKey,			// predefined registry handle 
			PHKEYphkResult 		// address of buffer for remote registry handle);
	"

	<stdcall: sdword RegConnectRegistryA lpstr handle lpvoid>
	^self invalidCall!

regCreateKeyEx: hKey lpSubKey: lpSubKey reserved: reserved lpClass: lpClass dwOptions: dwOptions samDesired: samDesired lpSecurityAttributes: lpSecurityAttributes phkResult: phkResult lpdwDisposition: lpdwDisposition 
	"Create or opens the specified registry key. Answers appropriate Win32 extended error code.

		LONG RegCreateKeyEx( 
			HKEY hKey, 			// handle of an open key 
			LPCTSTR lpSubKey, 		// address of subkey name 
			DWORD Reserved, 		// reserved 
			LPTSTR lpClass, 			// address of class string 
			DWORD dwOptions,		// special options flag 
			REGSAM samDesired, 		// desired security access 
			LPSECURITY_ATTRIBUTES lpSecurityAttributes, // address of key security structure 
			PHKEY phkResult, 		// address of buffer for opened handle 
			LPDWORD lpdwDisposition	// address of disposition value buffer 
		); "

	<stdcall: sdword RegCreateKeyExA handle lpstr dword lpstr dword dword lpvoid lpvoid DWORD*>
	^self invalidCall!

regDeleteKey: hKey lpSubKey: lpSubKey
	"Delete the specified sub-key of the key whose handle is hKey.

	Note that the exact behaviour depends on the host OS:
		Windows 95:	The RegDeleteKeyfunction deletes a subkey and all its descendants. 
		Windows NT:	The RegDeleteKeyfunction deletes the specified subkey. 
				The subkey to be deleted must not have subkeys. 

		LONG RegDeleteKey( 
			HKEYhKey, 		// handle of open key 
			LPCTSTRlpSubKey	// address of name of subkey to delete 
		);"

	<stdcall: sdword RegDeleteKeyA handle lpstr>
	^self invalidCall!

regDeleteValue: hKey lpValueName: lpValueName
	"Delete the specified registry value of the key whose handle is hKey.

		LONG RegDeleteValue(
			HKEYhKey,			// handle of key 
			LPCTSTRlpValueName	// address of value name 
		);"

	<stdcall: sdword RegDeleteValueA handle lpstr>
	^self invalidCall!

regEnumKeyEx: hKey dwIndex: dwIndex lpName: lpName lpcbName: lpcbName lpReserved: lpReserved lpClass: lpClass lpcbClass: lpcbClass lpftLastWriteTime: lpftLastWriteTime 
	"Get details for the sub-key of hKey with the specified index.

		LONG RegEnumKeyEx(
			HKEY hKey, 			// handle of key to query 
			DWORD dwIndex, 		// index of subkey to query 
			LPTSTR lpName, 			// address of buffer for subkey name 
			LPDWORD lpcbName, 		// address for size of subkey buffer 
			LPDWORD lpReserved,
			LPTSTR lpClass,			// address of buffer for class string 
			LPDWORD lpcbClass, 		// address for size of class buffer 
			PFILETIME lpftLastWriteTime	// address for time key last written to 
		);"

	<stdcall: sdword RegEnumKeyExA handle sdword lpstr DWORD* DWORD* lpstr DWORD* FILETIME*>
	^self invalidCall!

regEnumValue: hKey dwIndex: dwIndex lpValueName: lpValueName lpcbValueName: lpcbValueName lpReserved: lpReserved lpType: lpType lpData: lpData lpcbData: lpcbData 
	"
		LONG RegEnumValue( 
			HKEY hKey, 			// handle of key to query 
			DWORD dwIndex, 		// index of value to query 
			LPTSTR lpValueName, 		// address of buffer for value string 
			LPDWORD lpcbValueName,	// address for size of value buffer 
			LPDWORD lpReserved, 		// reserved 
			LPDWORD lpType, 		// address of buffer for type code 
			LPBYTE lpData, 			// address of buffer for value data 
			LPDWORD lpcbData 		// address for size of data buffer 
		); "

	<stdcall: sdword RegEnumValueA handle dword lpstr DWORD* DWORD* DWORD* lpvoid DWORD*>
	^self invalidCall!

registerEventSource: stringUNCServerName lpSourceName: stringSourceName 
	"HANDLE RegisterEventSource(
		LPCTSTR lpUNCServerName,	// server name for source 
		LPCTSTR lpSourceName 	// source name for registered handle  
	);"

	<stdcall: handle RegisterEventSourceA lpstr lpstr>
	^self invalidCall!

regOpenKeyEx: hKey lpSubKey: lpSubKey ulOptions: ulOptions samDesired: samDesired phkResult: phkResult 
	"Opens the specified registry key. Answers appropriate Win32 extended error code.
		LONG RegOpenKeyEx(
  			HKEY hKey,		// handle of open key 
			LPCTSTR lpSubKey,	// address of name of subkey to open 
			DWORD ulOptions,	// reserved 
			REGSAM samDesired,	// security access mask 
			PHKEY phkResult 	// address of handle of open key 
		);"

	<stdcall: sdword RegOpenKeyExA handle lpstr dword dword lpvoid>
	^self invalidCall!

regQueryInfoKey: hKey lpClass: lpClass lpcbClass: lpcbClass lpReserved: lpReserved lpcSubKeys: lpcSubKeys lpcbMaxSubKeyLen: lpcbMaxSubKeyLen lpcbMaxClassLen: lpcbMaxClassLen lpcValues: lpcValues lpcbMaxValueNameLen: lpcbMaxValueNameLen lpcbMaxValueLen: lpcbMaxValueLen lpcbSecurityDescriptor: lpcbSecurityDescriptor lpftLastWriteTime: lpftLastWriteTime 
	"Answer (a lot of) information about a specified registry key. 

		LONG RegQueryInfoKey ( 
			HKEY hKey, 					// handle of key to query 
			LPTSTR lpClass, 					// address of buffer for class string 
			LPDWORD lpcbClass, 				// address of size of class string buffer 
			LPDWORD lpReserved, 				// reserved 
			LPDWORD lpcSubKeys, 			// address of buffer for number of subkeys 
			LPDWORD lpcbMaxSubKeyLen,	// address of buffer for longest subkey name length 
			LPDWORD lpcbMaxClassLen,			// address of buffer for longest class string length 
			LPDWORD lpcValues, 				// address of buffer for number of value entries 
			LPDWORD lpcbMaxValueNameLen,	// address of buffer for longest value name length 
			LPDWORD lpcbMaxValueLen, 		// address of buffer for longest value data length 
			LPDWORD lpcbSecurityDescriptor,// address of buffer for security descriptor length 
			PFILETIME lpftLastWriteTime			// address of buffer for last write time 
	 ); "

	<stdcall: sdword RegQueryInfoKeyA handle lpstr DWORD* DWORD* DWORD* DWORD* DWORD* DWORD* DWORD* DWORD* DWORD* FILETIME*>
	^self invalidCall!

regQueryValueEx: kKey lpValueName: lpValueName lpReserved: lpReserved lpType: lpType lpData: lpData lpcbData: lpcbData 
	"Retrieves the type and data for a specified value name associated with an open registry key.
		LONG RegQueryValueEx(
			HKEY hKey,			// handle of key to query 
			LPTSTR lpValueName,		// address of name of value to query 
			LPDWORD lpReserved,		// reserved 
			LPDWORD lpType,		// address of buffer for value type 
			LPBYTE lpData,			// address of data buffer 
			LPDWORD lpcbData 		// address of data buffer size 
		);"

	<stdcall: sdword RegQueryValueExA handle lpstr DWORD* DWORD* lpvoid DWORD*>
	^self invalidCall!

regSetValueEx: kKey lpValueName: lpValueName reserved: dwReserved dwType: dwType lpData: lpData cbData: cbData 
	"Store the type and data for a specified value name associated with an open registry key.
		LONG RegSetValueEx( 
			HKEY hKey,		// handle of key
			LPTSTR lpValueName,	// address of name of value
			DWORD lpReserved,	// reserved 
			DWORD lpType,		// value type 
			CONST BYTE *lpData, 	// address of data buffer 
			DWORD lpcbData 	// data buffer size 
		);"

	<stdcall: sdword RegSetValueExA handle lpstr dword dword lpvoid dword>
	^self invalidCall!

reportEvent: hEventLog wType: wType wCategory: wCategory dwEventId: dwEventId lpUserSid: lpUserSid wNumStrings: wNumStrings dwDataSize: dwDataSize lpStrings: lpStrings lpRawData: lpRawData 
	"
		BOOL ReportEvent(
			HANDLE hEventLog,	// handle returned by RegisterEventSource 
			WORD wType,		// event type to log 
			WORD wCategory,	// event category 
			DWORD dwEventID,	// event identifier 
			PSID lpUserSid,		// user security identifier (optional) 
			WORD wNumStrings,	// number of strings to merge with message  
			DWORD dwDataSize,	// size of binary data, in bytes
			LPCTSTR *lpStrings,	// array of strings to merge with message 
			LPVOID lpRawData 	// address of binary data 
		);"

	<stdcall: bool ReportEventA handle word word dword lpvoid word dword lpvoid lpvoid>
	^self invalidCall! !
!AdvApiLibrary categoriesFor: #deregisterEventSource:!public!win32 functions-events! !
!AdvApiLibrary categoriesFor: #getUserName:nSize:!public!win32 functions-system information! !
!AdvApiLibrary categoriesFor: #regCloseKey:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regConnectRegistry:hKey:phkResult:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regCreateKeyEx:lpSubKey:reserved:lpClass:dwOptions:samDesired:lpSecurityAttributes:phkResult:lpdwDisposition:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regDeleteKey:lpSubKey:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regDeleteValue:lpValueName:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regEnumKeyEx:dwIndex:lpName:lpcbName:lpReserved:lpClass:lpcbClass:lpftLastWriteTime:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regEnumValue:dwIndex:lpValueName:lpcbValueName:lpReserved:lpType:lpData:lpcbData:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #registerEventSource:lpSourceName:!public!win32 functions-events! !
!AdvApiLibrary categoriesFor: #regOpenKeyEx:lpSubKey:ulOptions:samDesired:phkResult:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regQueryInfoKey:lpClass:lpcbClass:lpReserved:lpcSubKeys:lpcbMaxSubKeyLen:lpcbMaxClassLen:lpcValues:lpcbMaxValueNameLen:lpcbMaxValueLen:lpcbSecurityDescriptor:lpftLastWriteTime:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regQueryValueEx:lpValueName:lpReserved:lpType:lpData:lpcbData:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #regSetValueEx:lpValueName:reserved:dwType:lpData:cbData:!public!win32 functions-registry! !
!AdvApiLibrary categoriesFor: #reportEvent:wType:wCategory:dwEventId:lpUserSid:wNumStrings:dwDataSize:lpStrings:lpRawData:!public!win32 functions-events! !

!AdvApiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'ADVAPI32'! !
!AdvApiLibrary class categoriesFor: #fileName!constants!public! !

