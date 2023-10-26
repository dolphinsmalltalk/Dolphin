"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.AdvApiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.AdvApiLibrary guid: (Core.GUID fromString: '{64674054-3a82-101b-8181-00aa003743d3}')!
OS.AdvApiLibrary comment: 'AdvApiLibrary is the <ExternalLibrary> class to represent the Win32 system DLL, ADVAPI32.DLL.

This DLL contains functions mainly to do with accessing the registry, high-level access to which is available via Dolphin''s Registry Access package.
'!
!OS.AdvApiLibrary categoriesForClass!External-Libraries-Win32! !
!OS.AdvApiLibrary methodsFor!

deregisterEventSource: anExternalHandle
	<stdcall: bool DeregisterEventSource handle>
	^self invalidCall: _failureCode!

getUserName: buffer nSize: pBufSize
	"Retrieve the user name of the current thread. This is the name of the user currently 
	logged onto the system. 
		BOOL GetUserName(
  			LPTSTR lpBuffer,	// address of name buffer 
			LPDWORD nSize 		// address of size of name buffer 
		);"

	<stdcall: bool GetUserNameW lpwstr uint32*>
	^self invalidCall: _failureCode!

invalidCall: anInteger
	"Private - An invalid external call was attempted through one of the receiver's methods. The argument is the failure code from the external call primitive."

	^anInteger > 0
		ifTrue: [self systemError: anInteger]
		ifFalse: [self invalidCall: anInteger fromFrame: Processor activeProcess topFrame sender]!

isTextUnicode: lpv iSize: iSize lpiResult: lpiResult
	"
	BOOL IsTextUnicode(
		_In_        const VOID  *lpv,
		_In_              int   iSize,
	_Inout_opt_       LPINT lpiResult
	);
	"

	<stdcall: bool IsTextUnicode lpvoid int32 int32*>
	^self invalidCall: _failureCode!

regGetString: hiveInteger key: keyString value: valueString
	| sizeBuf status buf |
	sizeBuf := ByteArray newFixed: 4.
	status := AdvApi32
				regGetValue: hiveInteger
				lpSubKey: keyString
				lpValue: valueString
				dwFlags: WinRegConstants.RRF_RT_REG_SZ
				pdwType: nil
				pvData: nil
				pcbData: sizeBuf.
	status == ERROR_SUCCESS ifFalse: [^nil].
	"Note that the size returned seems to be one larger than needed, but we can't assume that is always the case"
	buf := Utf16String newFixed: ((sizeBuf uint32AtOffset: 0) bitShift: -1) - 1.
	status := AdvApi32
				regGetValue: hiveInteger
				lpSubKey: keyString
				lpValue: valueString
				dwFlags: WinRegConstants.RRF_RT_REG_SZ
				pdwType: nil
				pvData: buf
				pcbData: sizeBuf.
	^status == ERROR_SUCCESS ifTrue: [buf resize: ((sizeBuf uint32AtOffset: 0) bitShift: -1) - 1]!

regGetUInt32: hiveInteger key: keyString value: valueString
	| status buf |
	buf := ByteArray newFixed: 8.
	buf uint32AtOffset: 4 put: 4.
	status := self
				regGetValue: hiveInteger
				lpSubKey: keyString
				lpValue: valueString
				dwFlags: WinRegConstants.RRF_RT_DWORD
				pdwType: nil
				pvData: buf
				pcbData: buf yourAddress + 4.
	^status == ERROR_SUCCESS ifTrue: [buf uint32AtOffset: 0]!

regGetValue: hKey lpSubKey: lpSubKey lpValue: lpValue dwFlags: dwFlags pdwType: pdwType pvData: pvData pcbData: pcbData
	"Invoke the RegGetValue() function of the module wrapped by the receiver.
	Helpstring: Retrieves the type and data for the specified registry value.

		LSTATUS __stdcall RegGetValue(
			void* hKey,
			LPCWSTR lpSubKey,
			LPCWSTR lpValue,
			DWORD dwFlags,
			unsigned long* pdwType,
			void* pvData,
			unsigned long* pcbData);"

	<stdcall: int32 RegGetValueW handle lpwstr lpwstr uint32 uint32* void* uint32*>
	^self invalidCall: _failureCode!

regSetKeyValue: hKey lpSubKey: lpSubKey lpValueName: lpValue dwType: dwType lpData: lpData cbData: cbData
	"Invoke the RegSetKeyValue() function of the module wrapped by the receiver.
	Helpstring: Sets the data for the specified value in the specified registry key and subkey..

		LSTATUS __stdcall RegSetKeyValue(
			HKEY hKey,
			LPCWSTR lpSubKey,
			LPCWSTR lpValueName,
			DWORD dwType,
			void* pvData,
			DWORD pcbData);"

	<stdcall: errno RegSetKeyValueW handle lpwstr lpwstr uint32 void* uint32>
	^self invalidCall: _failureCode!

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
			LPCWSTR *lpStrings,	// array of strings to merge with message 
			LPVOID lpRawData 	// address of binary data 
		);"

	<stdcall: bool ReportEventW handle uint16 uint16 uint32 lpvoid uint16 uint32 lpvoid lpvoid>
	^self invalidCall: _failureCode! !
!OS.AdvApiLibrary categoriesForMethods!
deregisterEventSource:!public!win32 functions-events! !
getUserName:nSize:!public!win32 functions-system information! !
invalidCall:!exceptions!private! !
isTextUnicode:iSize:lpiResult:!public!win32 functions-unicode and character set! !
regGetString:key:value:!helpers!public! !
regGetUInt32:key:value:!helpers!public! !
regGetValue:lpSubKey:lpValue:dwFlags:pdwType:pvData:pcbData:!public!win32 functions-registry! !
regSetKeyValue:lpSubKey:lpValueName:dwType:lpData:cbData:!public!win32 functions-registry! !
reportEvent:wType:wCategory:dwEventId:lpUserSid:wNumStrings:dwDataSize:lpStrings:lpRawData:!public!win32 functions-events! !
!

!OS.AdvApiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'ADVAPI32'!

sharedVariableName
	^#{OS.AdvApi32}! !
!OS.AdvApiLibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

