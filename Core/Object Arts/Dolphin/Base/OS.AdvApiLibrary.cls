"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.AdvApiLibrary'
	instanceVariableNames: 'isRunningElevated'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'MaxTokenInfoClass' -> 16r32.
			'TOKEN_ADJUST_DEFAULT' -> 16r80.
			'TOKEN_ADJUST_GROUPS' -> 16r40.
			'TOKEN_ADJUST_PRIVILEGES' -> 16r20.
			'TOKEN_ADJUST_SESSIONID' -> 16r100.
			'TOKEN_ASSIGN_PRIMARY' -> 16r1.
			'TOKEN_DUPLICATE' -> 16r2.
			'TOKEN_IMPERSONATE' -> 16r4.
			'TOKEN_QUERY' -> 16r8.
			'TOKEN_QUERY_SOURCE' -> 16r10.
			'TokenAccessInformation' -> 16r16.
			'TokenAppContainerNumber' -> 16r20.
			'TokenAppContainerSid' -> 16r1F.
			'TokenAuditPolicy' -> 16r10.
			'TokenBnoIsolation' -> 16r2C.
			'TokenCapabilities' -> 16r1E.
			'TokenChildProcessFlags' -> 16r2D.
			'TokenDefaultDacl' -> 16r6.
			'TokenDeviceClaimAttributes' -> 16r22.
			'TokenDeviceGroups' -> 16r25.
			'TokenElevation' -> 16r14.
			'TokenElevationType' -> 16r12.
			'TokenGroups' -> 16r2.
			'TokenGroupsAndPrivileges' -> 16rD.
			'TokenHasRestrictions' -> 16r15.
			'TokenImpersonationLevel' -> 16r9.
			'TokenIntegrityLevel' -> 16r19.
			'TokenIsAppContainer' -> 16r1D.
			'TokenIsAppSilo' -> 16r30.
			'TokenIsLessPrivilegedAppContainer' -> 16r2E.
			'TokenIsRestricted' -> 16r28.
			'TokenIsSandboxed' -> 16r2F.
			'TokenLinkedToken' -> 16r13.
			'TokenLoggingInformation' -> 16r31.
			'TokenLogonSid' -> 16r1C.
			'TokenMandatoryPolicy' -> 16r1B.
			'TokenOrigin' -> 16r11.
			'TokenOwner' -> 16r4.
			'TokenPrimaryGroup' -> 16r5.
			'TokenPrivateNameSpace' -> 16r2A.
			'TokenPrivileges' -> 16r3.
			'TokenProcessTrustLevel' -> 16r29.
			'TokenRestrictedDeviceClaimAttributes' -> 16r24.
			'TokenRestrictedDeviceGroups' -> 16r26.
			'TokenRestrictedSids' -> 16rB.
			'TokenRestrictedUserClaimAttributes' -> 16r23.
			'TokenSandBoxInert' -> 16rF.
			'TokenSecurityAttributes' -> 16r27.
			'TokenSessionId' -> 16rC.
			'TokenSessionReference' -> 16rE.
			'TokenSingletonAttributes' -> 16r2B.
			'TokenSource' -> 16r7.
			'TokenStatistics' -> 16rA.
			'TokenType' -> 16r8.
			'TokenUIAccess' -> 16r1A.
			'TokenUser' -> 16r1.
			'TokenUserClaimAttributes' -> 16r21.
			'TokenVirtualizationAllowed' -> 16r17.
			'TokenVirtualizationEnabled' -> 16r18
		}!

OS.AdvApiLibrary guid: (Core.GUID fromString: '{64674054-3a82-101b-8181-00aa003743d3}')!

OS.AdvApiLibrary comment: 'AdvApiLibrary is the <ExternalLibrary> class to represent the Win32 system DLL, ADVAPI32.DLL.

This DLL contains functions mainly to do with accessing the registry, high-level access to which is available via Dolphin''s Registry Access package.
'!

!OS.AdvApiLibrary categoriesForClass!External-Libraries-Win32! !

!OS.AdvApiLibrary methodsFor!

clear
	"Private - Reinitialize this dll instance, e.g. on startup."

	super clear.
	isRunningElevated := nil!

deregisterEventSource: anExternalHandle
	<stdcall: bool DeregisterEventSource handle>
	^self invalidCall: _failureCode!

getProcessElevation
	| token buf |
	token := Handle new.
	(self
		openProcessToken: Kernel32 getCurrentProcess
		desiredAccess: TOKEN_QUERY
		tokenHandle: token) ifFalse: [^false].
	buf := ByteArray newFixed: 8.
	self
		getTokenInformation: token
		tokenInformationClass: TokenElevation
		tokenInformation: buf
		tokenInformationLength: 4
		returnLength: buf yourAddress + 4.
	Kernel32 closeHandle: token.
	^(buf uint32AtOffset: 0) ~~ 0!

getTokenInformation: tokenHandle tokenInformationClass: tokenInformationClass tokenInformation: tokenInformation tokenInformationLength: tokenInformationLength returnLength: returnLength
	"Invoke the GetTokenInformation() function of the module wrapped by the receiver.
	Helpstring: Retrieves a specified type of information about an access token.

		BOOL __stdcall GetTokenInformation(
			HANDLE TokenHandle,
			TOKEN_INFORMATION_CLASS TokenInformationClass,
			LPVOID TokenInformation,
			DWORD TokenInformationLength,
			DWORD* ReturnLength);"

	<stdcall: bool GetTokenInformation handle int32 void* uint32 uint32*>
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

isRunningElevated
	"Answer whether the Dolphin process is running with administrator privileges or not. In general this will be false, as since Windows Vista normal user processes do not run with admin privileges unless specifically elevated, e.g. by starting from an administrator command prompt.
		AdvApi32 isRunningElevated
	"

	^isRunningElevated ifNil: [isRunningElevated := self getProcessElevation]!

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

openProcessToken: processHandle desiredAccess: desiredAccess tokenHandle: tokenHandle
	"Invoke the OpenProcessToken() function of the module wrapped by the receiver.
	Helpstring: Opens the access token associated with a process.

		BOOL __stdcall OpenProcessToken(
			HANDLE ProcessHandle,
			DWORD DesiredAccess,
			HANDLE* TokenHandle);"

	<stdcall: bool OpenProcessToken handle uint32 handle*>
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
clear!private!realizing/unrealizing! !
deregisterEventSource:!public!win32 functions-events! !
getProcessElevation!helpers!private! !
getTokenInformation:tokenInformationClass:tokenInformation:tokenInformationLength:returnLength:!**auto generated**!public!win32 functions-security and identity! !
getUserName:nSize:!public!win32 functions-system information! !
invalidCall:!exceptions!private! !
isRunningElevated!public!testing! !
isTextUnicode:iSize:lpiResult:!public!win32 functions-unicode and character set! !
openProcessToken:desiredAccess:tokenHandle:!**auto generated**!public!win32 functions-process and thread! !
regGetString:key:value:!helpers!public! !
regGetUInt32:key:value:!helpers!public! !
regGetValue:lpSubKey:lpValue:dwFlags:pdwType:pvData:pcbData:!public!win32 functions-registry! !
regSetKeyValue:lpSubKey:lpValueName:dwType:lpData:cbData:!public!win32 functions-registry! !
reportEvent:wType:wCategory:dwEventId:lpUserSid:wNumStrings:dwDataSize:lpStrings:lpRawData:!public!win32 functions-events! !
!

!OS.AdvApiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'advapi32'!

sharedVariableName
	^#{OS.AdvApi32}! !

!OS.AdvApiLibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

