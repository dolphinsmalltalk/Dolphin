"Filed out from Dolphin Smalltalk"!

External.PermanentLibrary subclass: #'OS.KernelLibrary'
	instanceVariableNames: ''
	classVariableNames: 'WinVerOrGreaterMask'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.KernelLibrary guid: (Core.GUID fromString: '{64674048-3a82-101b-8181-00aa003743d3}')!
OS.KernelLibrary comment: 'KernelLibrary is the <ExternalLibrary> which represents the Win32 System DLL, KERNEL32.DLL. 

The default instance of this class provides access to most of the base operating system services. New functions may be added as required, but the external function naming convention should be followed.

KernelLibrary is a special case in that its handle is cached by the VM on startup into the VM registry, and it is the means by which all other libraries are opened.

All functions in this library use the stdcall calling convention.'!
!OS.KernelLibrary categoriesForClass!External-Libraries-Win32! !
!OS.KernelLibrary methodsFor!

addAtom: aString
	"The AddAtom function adds a character string to the local atom table and returns a unique value (an atom) identifying the string. 
	Answer the value is the newly created atom or zero if the function fails.

		ATOM AddAtom(
			LPCWSTR  lpString 	// address of string to add 
		);"

	<stdcall: word AddAtomW lpwstr>
	^self invalidCall: _failureCode!

allocConsole
	"Invoke the AllocConsole() function of the module wrapped by the receiver.
	Helpstring: Allocates a new console for the calling process.

		BOOL __stdcall AllocConsole();"

	<stdcall: bool AllocConsole>
	^self invalidCall: _failureCode!

attachConsole: dwProcessId
	"Invoke the AttachConsole() function of the module wrapped by the receiver.
	Helpstring: Attaches the calling process to the console of the specified process.

		BOOL __stdcall AttachConsole(
			[in]DWORD dwProcessId);"

	<stdcall: bool AttachConsole dword>
	^self invalidCall: _failureCode!

beep: anInteger dwDuration: dwDuration
	"Generates simple tones on the speaker. 
		BOOL Beep(
  			DWORD dwFreq,	// sound frequency, in hertz 
			DWORD dwDuration 	// sound duration, in milliseconds 
		);
	Implementation Note:  One might be tempted to make this an overlapped
	call, and that might indeed be usful when buzzing for long durations, however
	that would reduce the usefulness of Sound>>bell as a debugging aid by
	slowing it down and introducing the complication of process switching.
	It would also make it unsuitable for use from the idle process, which really
	shouldn't be made to wait on Semaphores (which causes a VM idle panic
	interrupt, handled by starting a new idle process). Of course you can always
	add a new overlapped entry point if you wish."

	<stdcall: bool Beep dword dword>
	^self invalidCall: _failureCode!

beginUpdateResource: fileNameString bDeleteExistingResources: aBoolean
	"BeginUpdateResource returns a handle that can be used by the UpdateResource
	function to add, delete, or replace resources in an executable file. 

	HANDLE BeginUpdateResource(
		LPCWSTR pFileName <>,             // executable file name
		BOOL bDeleteExistingResources <>  // deletion option
		);"

	<stdcall: handle BeginUpdateResourceW lpwstr bool>
	^self invalidCall: _failureCode!

close
	"The kernel library cannot be closed."

	^false!

closeHandle: aHandle
	"Close an open Win32 object handle, freeing any resources held by it.
	Once closed a handle is no longer valid. Answer whether the function
	succeeds.	 See Win32 SDK help for more information.

	BOOL CloseHandle(
		HANDLE  hObject 	// handle of object to close  
	);"

	<stdcall: bool CloseHandle handle>
	^self invalidCall: _failureCode!

compareString: locale dwCmpFlags: dwCmpFlags lpString1: lpString1 cchCount1: cchCount1 lpString2: lpString2 cchCount2: cchCount2
	<stdcall: sdword CompareStringW dword dword lpwstr sdword lpwstr sdword>
	^self invalidCall: _failureCode!

compareStringOrdinal: lpString1 cchCount1: cchCount1 lpString2: lpString2 cchCount2: cchCount2 bIgnoreCase: bIgnoreCase
	<stdcall: sdword CompareStringOrdinal lpwstr sdword lpwstr sdword bool>
	^self invalidCall: _failureCode!

copyFile: fromString lpNewFileName: toString bfailIfExists: fail
	"Copies the file named fromString to a file named toString. If
	toString already exists then the copy will only proceed if fail
	is false.

	BOOL	CopyFileW(
		LPCWSTR lpExistingFileName,
		LPCWSTR lpNewFileName,
		BOOL bFailIfExists
		);"

	<overlap stdcall: bool CopyFileW lpwstr lpwstr bool>
	^self invalidCall: _failureCode!

copyMemory: destination source: source length: length
	"CopyMemory is a macro defined to RtlCopyMemory, which in turn is a macro defined to memcpy"

	Ucrt
		memcpy_s: destination
		destSize: length
		src: source
		count: length!

createDirectory: path lpSecurityAttributes: aSECURITYATTRIBUTES
	"Create a new directory with the specified <String> path, 
	answering whether successful.

		BOOL CreateDirectory(
			LPCTSTR lpPathName,
			LPSECURITY_ATTRIBUTES lpSecurityAttributes
		);"

	<stdcall: bool CreateDirectoryW lpwstr lpvoid>
	^self invalidCall: _failureCode!

createEvent: lpEventAttributes bManualReset: bManualReset bInitialState: bInitialState lpName: lpName
	"Invoke the CreateEvent() function of the module wrapped by the receiver.
	Helpstring: Creates a named or unnamed event object

		HANDLE __stdcall CreateEvent(
			[in]SECURITY_ATTRIBUTES* lpEventAttributes,
			BOOL bManualReset,
			BOOL bInitialState,
			LPCSTR lpName);"

	<stdcall: handle CreateEventW lpvoid bool bool lpwstr>
	^self invalidCall: _failureCode!

createFile: aStringFileName dwDesiredAccess: anIntegerAccessMode dwSharedMode: anIntegerShareMode lpSecurityAttributes: aSECURITYATTRIBUTES dwCreationDistribution: anIntegerCreateMode dwFlagsAndAttributes: anIntegerAttributeFlag hTemplateFile: aHandle
	"The CreateFile function creates, opens, or truncates a file, pipe, communications resource, disk device,
	or console. Answer a handle that can be used to access the object. It can also open and return a handle to a directory.

	HANDLE CreateFile(
		LPCTSTR lpFileName, // address of name of the file 
		DWORD dwDesiredAccess, // access (read-write) mode 
		DWORD dwShareMode, // share mode 
		LPSECURITY_ATTRIBUTES lpSecurityAttributes, // address of security descriptor 
		DWORD dwCreationDistribution, // how to create 
		DWORD dwFlagsAndAttributes, // file attributes 
		HANDLE hTemplateFile // handle of file with attributes to copy  
	);
	Please see Win32 SDK help for more information."

	<stdcall: handle CreateFileW lpwstr dword dword lpvoid dword dword handle>
	^self invalidCall: _failureCode!

createMutex: lpMutexAttributes bInitialOwner: bInitialOwner lpName: lpName
	"Invoke the CreateMutex() function of the module wrapped by the receiver.
	Helpstring: Creates a named or unnamed mutex object

		HANDLE __stdcall CreateMutex(
			[in]void* lpMutexAttributes,
			BOOL bInitialOwner,
			LPSTR lpName);"

	<stdcall: handle CreateMutexW void* bool lpwstr>
	^self invalidCall: _failureCode!

debugBreak
	"Invoke the DebugBreak() function of the module wrapped by the receiver.
	Helpstring: Break into a debugger

		void __stdcall DebugBreak();"

	<stdcall: void DebugBreak>
	^self invalidCall: _failureCode!

deleteFile: aStringFileName
	"The DeleteFile function deletes an existing file. Answer true if the function succeeds.

		BOOL DeleteFile( LPCWSTR lpFileName);

	If the file does not exist, the DeleteFile function fails. The function fails if an
	application attempts to delete a file that is open for normal I/O or as a memory-mapped
	file."

	<stdcall: bool DeleteFileW lpwstr>
	^self invalidCall: _failureCode!

deviceIoControl: hDevice dwIoControlCode: dwIoControlCode lpInBuffer: lpInBuffer nInBufferSize: nInBufferSize lpOutBuffer: lpOutBuffer nOutBufferSize: nOutBufferSize lpBytesReturned: lpBytesReturned lpoverlapped: lpoverlapped
	"Invoke the DeviceIoControl() function of the module wrapped by the receiver.
	Helpstring: Sends a control code directly to a specified device driver, causing the corresponding device to perform the corresponding operation.

		BOOL __stdcall DeviceIoControl(
			[in]HANDLE hDevice,
			[in]DWORD dwIoControlCode,
			[in]LPVOID lpInBuffer,
			[in]DWORD nInBufferSize,
			[out]LPVOID lpOutBuffer,
			[in]DWORD nOutBufferSize,
			[out]unsigned long* lpBytesReturned,
			[in, out]LPOVERLAPPED LPOVERLAPPED);"

	<stdcall: bool DeviceIoControl handle dword void* dword void* dword dword* void*>
	^self invalidCall: _failureCode!

duplicateHandle: sourceProcHandle hSourceHandle: sourceHandle hTargetProcessHandle: targetProcHandle lpTargetHandle: targetHandle dwDesiredAccess: accessFlagsInteger bInheritHandle: inheritBool dwOptions: optionsFlagInteger
	"Duplicate a Win32 handle, sourceHandle, belonging to a Win32 Process, 
		sourceProcHandle, for another Win32 Process, targetProcHandle, writing
		the result into targetHandle, with the specified access (accessFlagsInteger),
		inheritance (inheritBool), and options (optionsFlagInteger). Answer whether
		the functions succeeds or fails. See Win32 SDK help for more information.
		BOOL DuplicateHandle(
			HANDLE  hSourceProcessHandle,	// handle of process with handle to duplicate 
			HANDLE  hSourceHandle,	// handle to duplicate 
			HANDLE  hTargetProcessHandle,	// handle of process to duplicate to 
			LPHANDLE  lpTargetHandle,	// address of duplicate handle 
			DWORD  dwDesiredAccess,	// access for duplicate handle 
			BOOL  bInheritHandle,	// handle inheritance flag
			DWORD  dwOptions 	// optional actions 
		);"

	<stdcall: bool DuplicateHandle handle handle handle lpvoid dword bool dword>
	^self invalidCall: _failureCode!

endUpdateResource: hUpdate fDiscard: aBoolean
	"EndUpdateResource ends a resource update in an executable file. 
	
	BOOL EndUpdateResource(
		HANDLE hUpdate <>, // update-file handle
		BOOL fDiscard <>   // write option 
		);"

	<stdcall: bool EndUpdateResourceW handle bool>
	^self invalidCall: _failureCode!

enumDateFormats: aCallbackThunk locale: locale dwFlags: dwFlags
	"Enumerates the long or short date formats that are available for the specified locale, including 
	date formats for any alternate calendars. The argument, dwFlags, determines whether the long 
	or short date formats are enumerated. The function enumerates the date formats by passing 
	date format string pointers, one at a time, to the callback thunk, aCallbackThunk, continuing
	until all date formats are enumerated, or the callback returns false.

		BOOL EnumDateFormats(
			DATEFMT_ENUMPROC lpDateFmtEnumProc,	// pointer to enumeration callback function
			LCID Locale,						// locale whose date formats are of interest
			DWORD dwFlags 						// date formats to enumerate
		);"

	<stdcall: bool EnumDateFormatsW lpvoid dword dword>
	^self invalidCall: _failureCode!

enumSystemCodePages: aCallbackThunk dwFlags: dwFlags
	<stdcall: bool EnumSystemCodePagesW lpvoid dword>
	^self invalidCall: _failureCode!

enumSystemLocales: aCallbackThunk dwFlags: dwFlags
	"Enumerates the locales that are either installed on or supported by a system, depending on the 
	dwFlags parameter. The callback is invoked repeatedly until all locales are exhausted, or the
	callback function returns false.

		BOOL EnumSystemLocales(
			LOCALE_ENUMPROC lpLocaleEnumProc,	// pointer to enumeration callback function
			DWORD dwFlags 	// indicates which locales to enumerate
		);"

	<stdcall: bool EnumSystemLocalesW lpvoid dword>
	^self invalidCall: _failureCode!

enumTimeFormats: aCallbackThunk locale: locale dwFlags: dwFlags
	"Enumerates the time formats that are available for the specified locale. The function passes
	the time format strings, one at a time, to the callback thunk, aCallbackThunk, continuing
	until all time formats are enumerated, or the callback returns false.

		BOOL EnumTimeFormats(
			TIMEFMT_ENUMPROC lpTimeFmtEnumProc,	// pointer to enumeration callback function
			LCID Locale,						// locale whose time formats are of interest
			DWORD dwFlags 						// unused
		);"

	<stdcall: bool EnumTimeFormatsW lpvoid dword dword>
	^self invalidCall: _failureCode!

enumUILanguages: aCallbackThunk dwFlags: dwFlags lParam: lParam
	<stdcall: bool EnumUILanguagesW lpvoid dword uintptr>
	^self invalidCall: _failureCode!

expandEnvironmentStrings: aString
	"Answer the <String> result of replacing environment-variable references of the form
	%VariableName% with their defined values.
		(self default expandEnvironmentStrings: '%username% is cool') 
	"

	| answer size |
	aString isEmpty ifTrue: [^aString].
	size := self
				expandEnvironmentStrings: aString
				lpDst: nil
				nSize: 0.
	size = 0 ifTrue: [self systemError].
	"If the function succeeds, the return value is the number of TCHARs stored in the
	destination buffer, including the terminating null character."
	answer := Utf16String newFixed: size - 1.
	(self
		expandEnvironmentStrings: aString
		lpDst: answer
		nSize: size) = 0
		ifTrue: [self systemError].
	^answer!

expandEnvironmentStrings: lpSrc lpDst: lpDst nSize: bufSize
	"Replace environment-variable strings with their defined values. 
		DWORD ExpandEnvironmentStrings(
			LPCTSTR lpSrc,
			LPTSTR lpDst,
			DWORD nSize);"

	<stdcall: dword ExpandEnvironmentStringsW lpwstr lpwstr dword>
	^self invalidCall: _failureCode!

fileTimeToLocalTime: lpFileTime lpLocalFileTime: lpLocalFileTime
	"Convert a UTC FILETIME to a local FILETIME, answering whether the conversion succeeded.
		BOOL FileTimeToLocalTime(
  			CONST FILETIME *lpFileTime,	// pointer to UTC file time to convert 
			LPFILETIME lpLocalFileTime		// pointer to structure to receive local time  
		);
	Implenentation Note: In order to prevent FILETIME>>displayOn: acting as the root of a 
	dependency tree which keeps FILETIME and SYSTEMTIME in the image regardless of
	whether they are referenced elsewhere, we have to use void* arguments here to break
	the  dependencies."

	"<stdcall: bool FileTimeToLocalFileTime FILETIME* FILETIME*>"

	<stdcall: bool FileTimeToLocalFileTime void* void*>
	^self invalidCall: _failureCode!

fileTimeToSystemTime: lpFileTime lpSystemTime: lpSystemTime
	"Convert a FILETIME to a SYSTEMTIME, answering whether the conversion succeeded.
		BOOL FileTimeToSystemTime(
  			CONST FILETIME *lpFileTime,	// pointer to file time to convert 
			LPSYSTEMTIME lpSystemTime 		// pointer to structure to receive system time  
		);

	Implenentation Note: In order to prevent FILETIME>>displayOn: acting as the root of a 
	dependency tree which keeps FILETIME and SYSTEMTIME in the image regardless of
	whether they are referenced elsewhere, we have to use void* arguments here to break
	the  dependencies."

	"<stdcall: bool FileTimeToSystemTime FILETIME* SYSTEMTIME*>"

	<stdcall: bool FileTimeToSystemTime void* SYSTEMTIME*>
	^self invalidCall: _failureCode!

findClose: hFindFile
	"Close the specified find file handle returned by a previous call to FindFirstFile().

		BOOL FindClose( 
			HANDLE hFindFile
		);"

	<stdcall: bool FindClose handle>
	^self invalidCall: _failureCode!

findFirstFile: lpFileName lpFindFileData: aWIN32_FIND_DATA
	"Search a directory for a file or subdirectory whose name matches the specified filename.

		HANDLE FindFirstFile( 
			LPCWSTR lpFileName, 
			LPWIN32_FIND_DATAW lpFindFileData 
		);"

	<stdcall: handle FindFirstFileW lpwstr WIN32_FIND_DATAW*>
	^self invalidCall: _failureCode!

findNextFile: hFindFile lpFindFileData: aWIN32_FIND_DATA
	"Continue a file search initiated by a previous call to FindFirstFile()
	which returned the handle, hFindFile. Answer whether the call succeeded.
	No more files is determined by a false return value with GetLastError()
	returning ERROR_NO_MORE_FILES.

		BOOL FindNextFile( 
			HANDLE hFindFile, 
			LPWIN32_FIND_DATAW lpFindFileData 
		);"

	<stdcall: bool FindNextFileW handle WIN32_FIND_DATAW*>
	^self invalidCall: _failureCode!

findResource: anInstanceHandle lpName: anIntegerId lpType: anIntegerType
	"Determine the location of a resource with the specified type and name in the specified module. 
		HRSRC FindResource(
  			HMODULE hModule,	// resource-module handle 
			LPCWSTR lpName,	// pointer to resource name  
			LPCWSTR lpType 	// pointer to resource type 
		);"

	<stdcall: handle FindResourceW handle lpvoid lpvoid>
	^self invalidCall: _failureCode!

flushFileBuffers: aHandle
	"The FlushFileBuffers function clears the buffers for the specified file
	and causes all buffered data to be written to the file. 
	Answer a boolean indicating if the operation was successful.

	BOOL FlushFileBuffers(
		HANDLE hFile // open handle to file whose buffers are to be flushed 
		);"

	<stdcall: bool FlushFileBuffers handle>
	^self invalidCall: _failureCode!

formatMessage: dwFlags lpSource: aStringOrHandleOrNil dwMessageId: dwMessageId dwLanguageId: dwLanguageId lpBuffer: aBufString nSize: nBufSize arguments: vaArgs
	"Format a message string from a message definition, from the format string or module handle specified
	by the argument, aStringOrHandleOrNil. If the flags specify a system message, aStringOrHandle may be nil,
	and the function finds the appropriate message in the system message table resource.
	The function copies the formatted message text to an output buffer, populating any embedded insert 
	sequences with arguments from vaArgs if requested.
		DWORD FormatMessage(
			DWORD dwFlags,	// source and processing options 
			LPCVOID lpSource,	// pointer to  message source 
			DWORD dwMessageId,	// requested message identifier 
			DWORD dwLanguageId,	// language identifier for requested message 
			LPTSTR lpBuffer,	// pointer to message buffer 
			DWORD nSize,	// maximum size of message buffer 
			va_list *Arguments 	// address of array of message inserts 
		);"

	<stdcall: dword FormatMessageW dword lpvoid dword dword lpvoid dword lpvoid>
	^self invalidCall: _failureCode!

formatMessage: messageId source: aHandleOrString flags: dwFlag withArguments: arguments
	"Answer a <readableString> which is a message formatted from the specified Win32 format
	string (see Win32 help) and the arguments in the <sequencedReadableCollection>, arguments,
	which will be substitued for the argument identified as %1..%n in the format string."

	| ptr len msg args wideStrings argc |
	ptr := External.Address new.
	argc := arguments size.
	args := ByteArray new: argc * VMConstants.IntPtrSize.
	wideStrings := Array writeStream: argc.
	arguments keysAndValuesDo: 
			[:i :a |
			args uintPtrAtOffset: (i - 1) * VMConstants.IntPtrSize
				put: (a isInteger
						ifTrue: [a]
						ifFalse: 
							[a isString ifTrue: [(wideStrings nextPut: a asUtf16String) yourAddress] ifFalse: [a yourAddress]])].
	len := self
				setLastError: 0;
				formatMessage: (dwFlag bitOr: ##(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_ARGUMENT_ARRAY))
					lpSource: aHandleOrString asUtf16String
					dwMessageId: messageId
					dwLanguageId: 0
					lpBuffer: ptr basicYourAddress
					nSize: 0
					arguments: args.	"To enable us to distinguish the error case from the empty string case"

	"FormatMessage() unhelpfully treats the empty string result as an error, so we must handle specially."
	len == 0
		ifTrue: 
			[| err |
			err := self getLastError.
			err ~~ 0 ifTrue: [self systemError: err].
			msg := String new]
		ifFalse: 
			[msg := Utf16String fromAddress: ptr length: len.
			self
				heapFree: self getProcessHeap
				dwFlags: 0
				lpMem: ptr].
	^msg

	"
('Blah %1 blah %2!!d!!' formatWithArguments: #('abc' 123)) 
"!

freeConsole
	"Invoke the FreeConsole() function of the module wrapped by the receiver.
	Helpstring: Detaches the calling process from its console.

		BOOL __stdcall FreeConsole();"

	<stdcall: bool FreeConsole>
	^self invalidCall: _failureCode!

freeLibrary: anExternalHandle
	<stdcall: bool FreeLibrary handle>
	^self invalidCall: _failureCode!

getACP
	"Invoke the GetACP() function of the module wrapped by the receiver.
	Helpstring: Retrieves the current ANSI code-page identifier for the system

		UINT __stdcall GetACP();"

	<stdcall: dword GetACP>
	^self invalidCall: _failureCode!

getAtomName: id lpBuffer: aString nSize: anInteger
	"The GetAtomName function retrieves a copy of the character string associated with the specified local atom.
	This function replaces the GetAtomHandle function. 

		UINT GetAtomName(
			ATOM  nAtom,		// atom identifying character string 
			LPWSTR  lpBuffer,	// address of buffer for atom string  
			int  nSize 		// size of buffer 
			);	

	Return Value
	If the function succeeds, the return value is the length of the string copied to the buffer, in characters, not including the terminating null character.
	If the function fails, the return value is zero. To get extended error information, call GetLastError."

	<stdcall: dword GetAtomNameW word lpwstr sdword>
	^self invalidCall: _failureCode!

getCalendarInfo: locale calendar: calendar calType: calType lpCalData: lpCalData cchData: cchData lpValue: lpValue
	"Invoke the GetCalendarInfo() function of the module wrapped by the receiver.
	Helpstring: Retrieves information about a calendar for a locale specified by identifier.

		int __stdcall GetCalendarInfo(
			[in]unsigned long Locale,
			[in]DWORD Calendar,
			[in]DWORD CalType,
			[out]LPWSTR lpCalData,
			[in]int cchData,
			[out]unsigned long* lpValue);"

	<stdcall: sdword GetCalendarInfoW dword dword dword lpwstr sdword dword*>
	^self invalidCall: _failureCode!

getCommandLine
	"Answer a pointer to the command-line string.

		LPWSTR GetCommandLine(VOID)"

	<stdcall: lpwstr GetCommandLineW>
	^self invalidCall: _failureCode!

getComputerName: buffer nSize: pBufSize
	"Retrieves the computer name of the current system into the argument, buffer (which must be large
	enough to contain MAX_COMPUTERNAME_LENGTH+1 characters). Answers whether the name
	was successfully retrieved. If successful then the value of pBufSize will be the number of characters
	in the name.

		BOOL GetComputerName(
			LPWSTR lpBuffer,	// address of name buffer 
			LPDWORD nSize 		// address of size of lpBuffer
		);"

	<stdcall: bool GetComputerNameW lpwstr dword*>
	^self invalidCall: _failureCode!

getConsoleTitle: lpConsoleTitle nSize: nSize
	"Invoke the GetConsoleTitle() function of the module wrapped by the receiver.
	Helpstring: Retrieves the title for the current console window.

		DWORD __stdcall GetConsoleTitle(
			[out]LPWSTR lpConsoleTitle,
			[in]DWORD nSize);"

	<stdcall: dword GetConsoleTitleW lpwstr dword>
	^self invalidCall: _failureCode!

getCPInfoExW: codepage dwFlags: dwFlags lpCPInfoEx: lpCPInfoEx
	"Invoke the GetCPInfoExW() function of the module wrapped by the receiver.
	Helpstring: Retrieves information about any valid installed or available code page.

		BOOL __stdcall GetCPInfoExW(
			[in]unsigned int codepage,
			[in]DWORD dwFlags,
			[out]CPINFOEXW* lpCPInfoEx);"

	<stdcall: bool GetCPInfoExW dword dword CPINFOEXW*>
	^self invalidCall: _failureCode!

getCurrentDirectory: nBufferLength lpBuffer: lpBuffer
	<stdcall: dword GetCurrentDirectoryW dword lpwstr>
	^self invalidCall: _failureCode!

getCurrentProcess
	"Answer handle of the Dolphin process.

		HANDLE GetCurrentProcess()"

	<stdcall: handle GetCurrentProcess>
	^self invalidCall: _failureCode!

getCurrentThread
	"Answer the handle of the current thread

		DWORD GetCurrentThread()"

	<stdcall: handle GetCurrentThread>
	^self invalidCall: _failureCode!

getCurrentThreadId
	"Answer thread identifier of the currently executing thread (like Processor activeProcess).

		DWORD GetCurrentThreadId(VOID)"

	<stdcall: dword GetCurrentThreadId>
	^self invalidCall: _failureCode!

getDiskFreeSpace: lpRootPathName lpSectorsPerCluster: lpSectorsPerCluster lpBytesPerSector: lpBytesPerSector lpNumberOfFreeClusters: lpNumberOfFreeClusters lpTotalNumberOfClusters: lpTotalNumberOfClusters
	"
		BOOL GetDiskFreeSpace( 
			LPCTSTR lpRootPathName,
			LPDWORD lpSectorsPerCluster,
			LPDWORD lpBytesPerSector,
			LPDWORD lpNumberOfFreeClusters,
			LPDWORD lpTotalNumberOfClusters
		);
	"

	<stdcall: bool GetDiskFreeSpaceW lpwstr dword* dword* dword* dword*>
	^self invalidCall: _failureCode!

getDiskFreeSpaceEx: lpDirectoryName lpFreeBytesAvailable: lpFreeBytesAvailable lpTotalNumberOfBytes: lpTotalNumberOfBytes lpTotalNumberOfFreeBytes: lpTotalNumberOfFreeBytes
	"
		BOOL GetDiskFreeSpaceEx( 
			LPCTSTR lpDirectoryName,
			LPQWORD  lpFreeBytesAvailable,
			LPQWORD lpTotalNumberOfBytes,
			LPQWORD lpTotalNumberOfFreeBytes
		);
	"

	<stdcall: bool GetDiskFreeSpaceExW lpwstr qword* qword* qword*>
	^self invalidCall: _failureCode!

getEnvironmentVariable: nameString lpBuffer: bufString nSize: bufSize
	"Populate bufString with the value of the specified environment variable.
		DWORD GetEnvironmentVariable(
			LPCWSTR lpName,	// address of environment variable name 
			LPWSTR lpBuffer,	// address of buffer for variable value 
			DWORD nSize 	// size of buffer, in characters 
		);"

	<stdcall: dword GetEnvironmentVariableW lpwstr lpwstr dword>
	^self invalidCall: _failureCode!

getFileAttributes: aFileName
	"Answer attributes for the specified file or directory. 
		DWORD GetFileAttributes(
			LPCWSTR  lpFileName 	// address of the name of a file or directory  
		);"

	<stdcall: sdword GetFileAttributesW lpwstr>
	^self invalidCall: _failureCode!

getFileSizeEx: hfile lpFileSize: lpFileSize
	"Invoke the GetFileSizeEx() function of the module wrapped by the receiver.
	Helpstring: Retrieves the size, in bytes, of the specified file

		BOOL __stdcall GetFileSizeEx(
			[in]HANDLE HFILE,
			[out]LARGE_INTEGER* lpFileSize);"

	<stdcall: bool GetFileSizeEx handle sqword*>
	^self invalidCall: _failureCode!

getFileTime: hFile lpCreationTime: lpCreationTime lpLastAccessTime: lpLastAccessTime lpLastWriteTime: lpLastWriteTime
	"Answer file times for the File with the specified handle.
		BOOL GetFileTime(
			HANDLE hFile, // 
			LPFILETIME lpCreationTime, 
			LPFILETIME lpLastAccessTime, 
			LPFILETIME lpLastWriteTime 
		);"

	<stdcall: bool GetFileTime handle FILETIME* FILETIME* FILETIME*>
	^self invalidCall: _failureCode!

getFileType: anExternalHandle
	<stdcall: dword GetFileType handle>
	^self invalidCall: _failureCode!

getFinalPathNameByHandle: hFile lpszFilePath: lpszFilePath cchFilePath: cchFilePath dwFlags: dwFlags
	"DWORD GetFinalPathNameByHandleW(
		HANDLE hFile,
		LPSTR  lpszFilePath,
		DWORD  cchFilePath,
		DWORD  dwFlags
	);"

	<stdcall: dword GetFinalPathNameByHandleW handle lpwstr dword dword>
	^self invalidCall: _failureCode!

getFullPathName: fname nBufferLength: anInteger lpBuffer: path lpFilePart: aDWORD
	"Retrieves the full path and filename of the file with name fname, into the buffer, path.

		DWORD GetFullPathName(
  			LPCWSTR  lpFileName,	// address of name of file to find path for 
			DWORD  nBufferLength,	// size, in characters, of path buffer 
			LPWSTR  lpBuffer,		// address of path buffer 
			LPWSTR  *lpFilePart 	// address of filename in path 
		);"

	<stdcall: dword GetFullPathNameW lpwstr dword lpwstr lpvoid>
	^self invalidCall: _failureCode!

getLastError
	"Answer the last Win32 error code which occurred.
		DWORD GetLastError(VOID)"

	<stdcall: dword GetLastError>
	^self invalidCall: _failureCode!

getLocaleInfo: locale lCType: lcType lpLCData: outputStringOutput cchData: anInteger
	"Answer information about a locale. 
		int GetLocaleInfo(
	  		LCID  Locale,		// locale identifier 
			LCTYPE  LCType,	// type of information 
			LPWSTR  lpLCData,	// address of buffer for information 
			int  cchData 		// size of buffer 
		);"

	<stdcall: sdword GetLocaleInfoW dword dword lpvoid sdword>
	^self invalidCall: _failureCode!

getLocaleInfoEx: lpLocalName lCType: lcType lpLCData: outputStringOutput cchData: anInteger
	"Answer information about a locale. 
		int GetLocaleInfoEx(
	  		LPCWSTR lpLocaleName,
			LCTYPE  LCType,
			LPWSTR  lpLCData,
			int  cchData
		);"

	<stdcall: sdword GetLocaleInfoExW lpwstr dword lpvoid sdword>
	^self invalidCall: _failureCode!

getLocalTime: aWinSYSTEMTIME
	"Retrieve the current local date and time.
		VOID GetLocalTime(
  			LPSYSTEMTIME  lpSystemTime 	// address of system time structure  
		);"

	<stdcall: void GetLocalTime SYSTEMTIME*>
	^self invalidCall: _failureCode!

getModuleFileName: aHandle lpFilename: aString nSize: anInteger
	"Retrieve the full path and filename for the executable file containing the specified module.

		DWORD GetModuleFileName(
  			HMODULE  hModule,		// handle to module to find filename for 
			LPWSTR  lpFilename,	// pointer to buffer for module path 
			DWORD  nSize 			// size of buffer, in characters 
		);"

	<stdcall: dword GetModuleFileNameW handle lpwstr dword>
	^self invalidCall: _failureCode!

getModuleHandle: aString
	<stdcall: handle GetModuleHandleW lpwstr>
	^self invalidCall: _failureCode!

getNumberFormat: locale dwFlags: dwFlags lpValue: lpValue lpFormat: lpFormat lpNumberStr: lpNumberStr cchNumber: cchNumber
	"Invoke the GetNumberFormat() function of the module wrapped by the receiver.

		int __stdcall GetNumberFormat(
			unsigned long Locale,
			DWORD dwFlags,
			LPWSTR lpValue,
			NUMBERFMT* lpFormat,
			LPWSTR lpNumberStr,
			int cchNumber);"

	<stdcall: sdword GetNumberFormatW dword dword lpwstr void* lpwstr sdword>
	^self invalidCall: _failureCode!

getProcAddress: aHandle lpProcName: aStringOrOrdinal
	"Answer the address of an exported function with name, aString, in the
	module with handle, aHandle. If the function fails, NULL is returned,
	and #getLastError should be used to retrieve extended error information.

		FARPROC GetProcAddress(
			HMODULE  hModule,	// handle to DLL module  
			LPCSTR  lpProcName 	// name of function 
		);"

	<stdcall: lpvoid GetProcAddress handle lpvoid>
	^self invalidCall: _failureCode!

getProcAddressDWORD: aHandle lpProcName: aString
	"Private - As #getProcAddress:name:, but answers the result as a Windows DWORD (unsigned
	double word). This is useful in conjunction with SetWindowLong() etc."

	<stdcall: dword GetProcAddress handle lpvoid>
	^self invalidCall: _failureCode!

getProcessHeap
	"Answer the handle of the heap of the calling process for use with other
	memory management functions.

		HANDLE GetProcessHeap()"

	<stdcall: handle GetProcessHeap>
	^self invalidCall: _failureCode!

getShortPathName: lpszLongPath lpszShortPath: lpszShortPath cchBuffer: cchBuffer
	"Answers the short pathname form of lpszLongPath in lpszShortPath"

	<stdcall: dword GetShortPathNameW lpwstr lpwstr dword>
	^self invalidCall: _failureCode!

getStdHandle: nStdHandle
	"Get the handle for the standard input, standard output, or standard error device.
		HANDLE GetStdHandle(
  			DWORD nStdHandle,	// input, output, or error device 
		);"

	<stdcall: handle GetStdHandle dword>
	^self invalidCall: _failureCode!

getStringType: dwInfoType lpSrcStr: lpSrcStr cchSrc: cchSrc lpCharType: lpCharType
	<stdcall: bool GetStringTypeW dword lpwstr sdword word*>
	^self invalidCall: _failureCode!

getSystemDefaultLCID
	"Answer the system default locale identifier. 

			LCID GetSystemDefaultLCID(VOID)"

	<stdcall: dword GetSystemDefaultLCID>
	^self invalidCall: _failureCode!

getSystemDirectory: lpBuffer uSize: uSize
	"Answer the path of the windows system directory.

		UINT GetSystemDirectory(
			LPTSTR lpBuffer, 
			UINT uSize);"

	<stdcall: dword GetSystemDirectoryW lpwstr dword>
	^self invalidCall: _failureCode!

getSystemTime: lpSystemTime
	"Invoke the GetSystemTime() function of the module wrapped by the receiver.
	Helpstring: Gets the current system time and date

		void __stdcall GetSystemTime(
			SYSTEMTIME* lpSystemTime);"

	<stdcall: void GetSystemTime SYSTEMTIME*>
	^self invalidCall: _failureCode!

getSystemTimeAsFileTime: lpSystemTimeAsFileTime
	"Invoke the GetSystemTimeAsFileTime() function of the module wrapped by the receiver.
	Helpstring: Retrieves the current system date and time. The information is in Coordinated Universal Time (UTC) format.

		void __stdcall GetSystemTimeAsFileTime(
			FILETIME* lpSystemTimeAsFileTime);"

	<stdcall: void GetSystemTimeAsFileTime FILETIME*>
	^self invalidCall: _failureCode!

getSystemTimePreciseAsFileTime: lpSystemTimeAsFileTime
	"Invoke the GetSystemTimeAsFileTime() function of the module wrapped by the receiver.
	Helpstring: Retrieves the current system date and time. The information is in Coordinated Universal Time (UTC) format.

		void __stdcall GetSystemTimeAsFileTime(
			FILETIME* lpSystemTimeAsFileTime);"

	<stdcall: void GetSystemTimePreciseAsFileTime FILETIME*>
	"Introduced in Windows 8. Windows 7 support will end in January 2020, but until then fall back on GetSystemTimeAsFileTime"
	^self getSystemTimeAsFileTime: lpSystemTimeAsFileTime!

getSystemWindowsDirectory: lpBuffer uSize: uSize
	"	UINT GetSystemWindowsDirectory(
			LPTSTR lpBuffer, 
			UINT uSize); "

	<stdcall: dword GetSystemWindowsDirectoryW lpwstr dword>
	^self invalidCall: _failureCode!

getTempFileName: pathString lpPrefixString: prefixString uUnique: anInteger lpTempFileName: bufferString
	"Generate a temporary file name by concatenating the specified path and prefix strings, and a hexadecimal string formed from 
	the Integer, unique, and the .TMP extension. If anInteger is zero, the function generates a suitable value and creates
	the temporary file in the specified directory, otherwise the function generates the name (using the specified value) but does
	not create the file.

		UINT GetTempFileName(
  			LPCWSTR  lpPathName,		// address of directory name for temporary file 
			LPCWSTR  lpPrefixString,	// address of filename prefix 
			UINT  uUnique,	// number used to create temporary filename 
			LPWSTR  lpTempFileName 	// address of buffer that receives the new filename 
		);"

	<stdcall: dword GetTempFileNameW lpwstr lpwstr dword lpwstr>
	^self invalidCall: _failureCode!

getTempPath: nBufferLength lpBuffer: lpBuffer
	"Populate the <String> buffer, lpBuffer, with the system directory designated for temporary files.
	Answers the number of characters written to the buffer."

	<stdcall: dword GetTempPathW dword lpwstr>
	^self invalidCall: _failureCode!

getThreadTimes: hThread lpCreationTime: creationFILETIME lpExitTime: exitFILETIME lpKernelTime: kernelFILETIME lpUserTime: userFILETIME
	"
		BOOL GetThreadTimes(
			HANDLE hThread, 		// handle to thread 
			LPFILETIME lpCreationTime,	// thread creation time 
			LPFILETIME lpExitTime,	// thread exit time 
			LPFILETIME lpKernelTime,	// thread kernel-mode time 
			LPFILETIME lpUserTime	// thread user-mode time );
	"

	<stdcall: bool GetThreadTimes handle FILETIME* FILETIME* FILETIME* FILETIME*>
	^self invalidCall: _failureCode!

getThreadUILanguage 
	"Returns the language identifier of the first user interface language for the current thread.
		LANGID GetThreadUILanguage();"

	<stdcall: word GetThreadUILanguage>
	^self invalidCall: _failureCode!

getTickCount
	"
	Kernel32 getTickCount.

The return value is the number of milliseconds that have elapsed since the system was started.

The resolution of the GetTickCount function is limited to the resolution of the system timer, which is typically in the range of 10 milliseconds to 16 milliseconds. 
The resolution of the GetTickCount function is not affected by adjustments made by the GetSystemTimeAdjustment function.

The elapsed time is stored as a DWORD value. Therefore, the time will wrap around to zero if the system is run continuously for 49.7 days. 
To avoid this problem, use the GetTickCount64 function. Otherwise, check for an overflow condition when comparing times.

If you need a higher resolution timer, use a multimedia timer or a high-resolution timer.

To obtain the time elapsed since the computer was started, retrieve the System Up Time counter in the performance data in the registry key HKEY_PERFORMANCE_DATA. 
The value returned is an 8-byte value. For more information, see Performance Counters.

To obtain the time the system has spent in the working state since it was started, use the QueryUnbiasedInterruptTime function.

https://msdn.microsoft.com/en-us/library/windows/desktop/ms724408(v=vs.85).aspx"

	<stdcall: dword GetTickCount>
	^self invalidCall: _failureCode!

getTimeZoneInformation: lpTimeZoneInformation
	"Populate the fields of lpTimeZoneInformation with the current
	time-zone parameters. These parameters control the translations between 
	Coordinated Universal Time (UTC) and local time. Answers an integer from 
	the TIME_ZONE_XXXX enumeration.

		DWORD GetTimeZoneInformation(
			LPTIME_ZONE_INFORMATION lpTimeZoneInformation
		);

	Implementation Note: The error return value is 0xFFFFFFFF so to make stay
	within SmallInteger range we declare a signed integer return type so that the
	error return is instead -1."

	<stdcall: sdword GetTimeZoneInformation TIME_ZONE_INFORMATION*>
	^self invalidCall: _failureCode!

getUserDefaultLCID
	"Answer the user default locale identifier. 

		LCID GetUserDefaultLCID(VOID)"

	<stdcall: dword GetUserDefaultLCID>
	^self invalidCall: _failureCode!

getVolumeInformation: lpRootPathName lpVolumeNameBuffer: lpVolumeNameBuffer nVolumeNameSize: nVolumeNameSize lpVolumeSerialNumber: lpVolumeSerialNumber lpMaximumComponentLength: lpMaximumComponentLength lpFileSystemFlags: lpFileSystemFlags lpFileSystemNameBuffer: lpFileSystemNameBuffer nFileSystemNameSize: nFileSystemNameSize
	"Invoke the GetVolumeInformation() function of the module wrapped by the receiver.
	Helpstring: Gets information about a disk including volume name, serial number, maximum component length, and file system name

		BOOL __stdcall GetVolumeInformation(
			LPCSTR lpRootPathName,
			LPSTR lpVolumeNameBuffer,
			DWORD nVolumeNameSize,
			DWORD* lpVolumeSerialNumber,
			DWORD* lpMaximumComponentLength,
			DWORD* lpFileSystemFlags,
			LPSTR lpFileSystemNameBuffer,
			DWORD nFileSystemNameSize);"

	<stdcall: bool GetVolumeInformationW lpwstr lpwstr dword dword* dword* dword* lpwstr dword>
	^self invalidCall: _failureCode!

getWindowsDirectory: lpBuffer uSize: uSize
	"Answer the path of the windows directory.

		UINT GetWindowsDirectory(
			LPWSTR lpBuffer, 
			UINT uSize); "

	<stdcall: dword GetWindowsDirectoryW lpwstr dword>
	^self invalidCall: _failureCode!

globalAlloc: uFlags dwBytes: dwBytes
	"Allocates the specified number of bytes from the heap.

		HGLOBAL GlobalAlloc( 
			UINT uFlags, 		// object allocation attributes 
			DWORD dwBytes  	// number of bytes to allocate 
		);"

	<stdcall: handle GlobalAlloc dword dword>
	^self invalidCall: _failureCode!

globalFree: hGlobal
	<stdcall: void GlobalFree handle>
	^self invalidCall: _failureCode!

globalLock: hGlobal
	"Answer a pointer to a block of global memory object that was allocated 
	by the GlobalAlloc(...GMEM_MOVEABLE flag), incrementing its lock count."

	<stdcall: lpvoid GlobalLock handle>
	^self invalidCall: _failureCode!

globalUnlock: hGlobal
	"Decrement the lock count of a global memory object that was allocated 
	by the GlobalAlloc(...GMEM_MOVEABLE flag)."

	<stdcall: bool GlobalUnlock handle>
	^self invalidCall: _failureCode!

heapAlloc: aHandle dwFlags: flagsInteger dwBytes: byteSizeInteger
	"Allocate a block of memory from a heap.

		LPVOID HeapAlloc(
			HANDLE hHeap,	// handle to the private heap block 
			DWORD dwFlags,	// heap allocation control flags 
			DWORD dwBytes 	// number of bytes to allocate 
		);"

	<stdcall: lpvoid HeapAlloc handle dword dword>
	^self invalidCall: _failureCode!

heapCompact: aHandle dwFlags: anInteger
	"Minimize the size of the specified heap. Answer the size of the largest
	available free block (fairly meaningless), or zero on failure.
		UINT HeapCompact(
			HANDLE hHeap,	// handle to the heap to compact
			DWORD dwFlags 	// control flags
		);"

	<stdcall: dword HeapCompact handle dword>
	^self invalidCall: _failureCode!

heapFree: aHandle dwFlags: flagsInteger lpMem: byteSizeInteger
	"Free a block of memory to a heap, answering whether it succeeed.
	N.B. There is no distinction under Win32 between memory blocks allocated
	with GlobalAlloc(), LocalAlloc(), or from the default process heap using
	HeapAlloc(). We therefore standardise on the HeapXXX() set of functions
	(which are more powerful and allow multiple heaps), and use HeapFree() to
	free memory blocks where LocalFree()/GlobalFree() are specified.

		LPVOID HeapFree(
			HANDLE hHeap,	// handle to the heap
			DWORD dwFlags,	// heap freeing flags 
			LPVOID lpMem 	// pointer to the memory to free
		);"

	<stdcall: bool HeapFree handle dword lpvoid>
	^self invalidCall: _failureCode!

heapReAlloc: aHandle dwFlags: flagsInteger lpMem: anAddress dwBytes: byteSizeInteger
	"Resize an block of heap memory, answering the new block address (which may or may not change).

		LPVOID HeapReAlloc(
			HANDLE hHeap,	// handle of a heap 
			DWORD dwFlags,	// heap reallocation flags 
			LPVOID lpMem,	// pointer to the memory to reallocate 
			DWORD dwBytes 	// number of bytes to reallocate 
		);"

	<stdcall: lpvoid HeapReAlloc handle dword lpvoid dword>
	^self invalidCall: _failureCode!

heapSize: aHandle dwFlags: flagsInteger lpMem: anAddress
	"Answer the size of the block of memory allocated at the specified address.
  
		DWORD HeapSize(
			HANDLE hHeap,	// handle to a heap
			DWORD dwFlags,	// heap size control flags
			LPCVOID lpMem,	// pointer to the memory block of interest
		);"

	<stdcall: dword HeapSize handle dword lpvoid>
	^self invalidCall: _failureCode!

heapValidate: aHandle dwFlags: anInteger lpMem: anAddress
	"Answer whether the specified heap/memory block in a heap, is valid.

		BOOL HeapValidate(
			HANDLE hHeap,	// handle to the heap of interest
			DWORD dwFlags,	// bit flags that control heap access during function operation
			LPCVOID lpMem 	// optional pointer to individual memory block to validate
		);"

	<stdcall: bool HeapValidate handle dword lpvoid>
	^self invalidCall: _failureCode!

inputQueueMask
	"Private - Answer the 16-bit <integer> mask to be used when querying for Windows message queue
	input on the host platform. This may vary depending on the version of Windows on which
	Dolphin is running."

	"Implementation Note: See the WinUser.h header file in the Windows SDK"

	| qs_Input |
	qs_Input := self isWindows8OrGreater
				ifTrue: [##(QS_MOUSE | QS_KEY | QS_RAWINPUT | QS_TOUCH | QS_POINTER)]
				ifFalse: [##(QS_MOUSE | QS_KEY | QS_RAWINPUT)].
	^qs_Input | ##(QS_POSTMESSAGE | QS_TIMER | QS_PAINT | QS_HOTKEY | QS_SENDMESSAGE)!

isValidLocale: locale dwFlags: dwFlags
	<stdcall: bool IsValidLocale dword dword>
	^self invalidCall: _failureCode!

isWindows10OrGreater
	^self
		isWindowsVersionOrGreater: 10
		wMinorVersion: 0
		wServicePackMajor: 0!

isWindows7OrGreater
	^self
		isWindowsVersionOrGreater: 6
		wMinorVersion: 1
		wServicePackMajor: 0!

isWindows7SP1OrGreater
	^self
		isWindowsVersionOrGreater: 6
		wMinorVersion: 1
		wServicePackMajor: 1!

isWindows8OrGreater
	^self
		isWindowsVersionOrGreater: 6
		wMinorVersion: 2
		wServicePackMajor: 0!

isWindows8Point1OrGreater
	^self
		isWindowsVersionOrGreater: 6
		wMinorVersion: 3
		wServicePackMajor: 0!

isWindowsServer
	"Answers whether the current OS is a Windows Server release."

	"Implementation Note: This is the equivalent of the IsWindowsServer() version helper
	function, which is provided as an inline function in VersionHelpers.h in the Windows SDK."

	| osvi |
	osvi := OSVERSIONINFOEXW new
				wProductType: VER_NT_WORKSTATION;
				yourself.
	^(self
		verifyVersionInfo: osvi
		dwTypeMask: VER_PRODUCT_TYPE
		dwlConditionMask: (self
				verSetConditionMask: 0
				typeMask: VER_PRODUCT_TYPE
				condition: VER_EQUAL))
			not!

isWindowsVersionOrGreater: wMajorVersion wMinorVersion: wMinorVersion wServicePackMajor: wServicePackMajor
	"Answers whether the current OS version matches, or is greater than, the provided version information."

	"Implementation Note: This is the equivalent of the IsWindowsVersionOrGreater() version
	helper function, which is provided as an inline function in VersionHelpers.h in the Windows
	SDK."

	| osvi |
	osvi := OSVERSIONINFOEXW newBuffer
				dwMajorVersion: wMajorVersion;
				dwMinorVersion: wMinorVersion;
				wServicePackMajor: wServicePackMajor;
				yourself.
	^self
		verifyVersionInfo: osvi
		dwTypeMask: ##(VER_MAJORVERSION | VER_MINORVERSION | VER_SERVICEPACKMAJOR)
		dwlConditionMask: (WinVerOrGreaterMask
				ifNil: 
					[WinVerOrGreaterMask := self
								verSetConditionMask: (self
										verSetConditionMask: (self
												verSetConditionMask: 0
												typeMask: VER_MAJORVERSION
												condition: VER_GREATER_EQUAL)
										typeMask: VER_MINORVERSION
										condition: VER_GREATER_EQUAL)
								typeMask: VER_SERVICEPACKMAJOR
								condition: VER_GREATER_EQUAL])!

isWindowsVistaOrGreater
	"Dolphin 7 and later no longer run on platforms prior to Vista."

	^true!

isWindowsVistaSP1OrGreater
	^self
		isWindowsVersionOrGreater: 6
		wMinorVersion: 0
		wServicePackMajor: 1!

isWindowsVistaSP2OrGreater
	^self
		isWindowsVersionOrGreater: 6
		wMinorVersion: 0
		wServicePackMajor: 2!

isWindowsXPOrGreater
	"Dolphin 7 and later no longer run on platforms prior to Vista."

	^true!

isWow64
	"Answers whether this Dolphin process is running on 64-bit Windows on the WOW64 subsystem. The answer will be false if the host is 32-bit Windows."

	| bool |
	bool := BOOL new.
	(self isWow64Process: self getCurrentProcess wow64Process: bool) ifFalse: [self systemError].
	^bool value!

isWow64Process: hProcess wow64Process: wow64Process
	<stdcall: bool IsWow64Process handle bool*>
	^self invalidCall: _failureCode!

lcMapString: locale dwMapFlags: dwMapFlags lpScrStr: lpSrcStr cchSrc: cchSrc lpDestStr: lpDestStr cchDest: cchDest
	<stdcall: sdword LCMapStringW sdword dword lpwstr sdword lpvoid sdword>
	^self invalidCall: _failureCode!

loadLibraryEx: aString hFile: reserved dwFlags: anInteger
	"Map the specified executable module into the address space of the calling process, and answer the module
	handle. If the function fails, the return value is nil.

		HINSTANCE LoadLibraryEx(
			LPCWSTR lpLibFileName,	// points to name of executable module
			HANDLE hFile,	// reserved, must be NULL 
			DWORD dwFlags 	// entry-point execution flag 
		);
	
	The library is loaded from either the directory from which Dolphin was loaded, the current directory, 
	the Windows system directory, the Windows directory, or a directory on the path (in that order)."

	<stdcall: handle LoadLibraryExW lpwstr handle dword>
	^self invalidCall: _failureCode!

loadResource: anInstanceHandle hResInfo: aResourceHandle
	"Load the specified resource into global memory. 
		HGLOBAL LoadResource(
  			HMODULE hModule,	// resource-module handle  
			HRSRC hResInfo 	// resource handle 
		);"

	<stdcall: handle LoadResource handle handle>
	^self invalidCall: _failureCode!

localeNameToLCID: lpName dwFlags: dwFlags
	"Converts a locale name to a locale identifier.

	LCID LocaleNameToLCID(
		LPCWSTR lpName,
		DWORD   dwFlags
	)"

	<stdcall: dword LocaleNameToLCID lpwstr dword>
	^self invalidCall: _failureCode!

localFileTimeToFileTime: lpLocalFileTime lpFileTime: lpFileTime
	"Convert a UTC FILETIME to a local FILETIME, answering whether the conversion succeeded.
		BOOL LocalFileTimeToFileTime(
  			CONST FILETIME *lpLocalFileTime,	// pointer to UTC file time to convert 
			LPFILETIME lpFileTime			// pointer to structure to receive UTC
		);"

	<stdcall: bool LocalFileTimeToFileTime FILETIME* FILETIME*>
	^self invalidCall: _failureCode!

localFree: hMem
	"Invoke the LocalFree() function of the module wrapped by the receiver.

		wireHGLOBAL __stdcall LocalFree(
			wireHGLOBAL hMem);"

	<stdcall: handle LocalFree handle>
	^self invalidCall: _failureCode!

lockResource: anExternalHandle
	"Lock the specified resource in memory. 
		LPVOID LockResource(
  			HGLOBAL hResData 	// handle to resource to lock 
		);"

	<stdcall: dword LockResource handle>
	^self invalidCall: _failureCode!

moveFile: aStringOldFileName lpNewFileName: aStringnewFileName
	"The MoveFile function will move (rename) either a file or a directory (including all its children)
	either in the same directory or across directories. The one caveat is that the MoveFile function will
	fail on directory moves when the destination is on a different volume. 
	Answer true if the function succeeds. 

	BOOL MoveFile(
		LPCWSTR lpExistingFileName, // address of name of the existing file  
		LPCWSTR lpNewFileName // address of new name for the file 
		);"

	<stdcall: bool MoveFileW lpwstr lpwstr>
	^self invalidCall: _failureCode!

moveFileEx: aStringOldFileName lpNewFileName: aStringnewFileName dwFlags: flags
	"The MoveFileEx function will move (rename) either a file or a directory (including all its children)
	either in the same directory or across directories. The one caveat is that the MoveFile function will
	fail on directory moves when the destination is on a different volume. 
	Answer true if the function succeeds. 

	BOOL MoveFile(
		LPCWSTR lpExistingFileName, // address of name of the existing file  
		LPCWSTR lpNewFileName // address of new name for the file 
		DWORD dwFlags <> // move options 
		);"

	<stdcall: bool MoveFileExW lpwstr lpwstr dword>
	^self invalidCall: _failureCode!

multiByteToWideChar: intCP dwFlags: intFlags lpMultiByteStr: aStringIn cchMultiByte: intLenIn lpWideCharStr: aUtf16StringOut cchWideChar: intLenOut
	"Maps a string to a wide-character (UTF16) string. 
	Despite the name, aStringIn, need not contain MBCS characters.

		int MultiByteToWideChar(
			UINT CodePage,	// code page 
			DWORD dwFlags,	// character-type options 
			LPCSTR lpMultiByteStr,	// address of string to map 
			int cchMultiByte,	// number of characters in string 
			LPWSTR lpWideCharStr,	// address of wide-character buffer 
			int cchWideChar 	// size of buffer 
		);"

	<stdcall: sdword MultiByteToWideChar dword dword lpvoid sdword lpvoid sdword>
	^self invalidCall: _failureCode!

openProcess: dwDesiredAccess bInheritHandle: bInheritHandle dwProcessId: dwProcessId
	"Invoke the OpenProcess() function of the module wrapped by the receiver.
	Helpstring: Given a process ID number, returns handle of existing process

		long __stdcall OpenProcess(
			EPROCESSACCESS dwDesiredAccess,
			long bInheritHandle,
			unsigned long dwProcessId);"

	<stdcall: sdword OpenProcess sdword sdword dword>
	^self invalidCall: _failureCode!

outputDebugString: aString
	"Send aString to the debugger.

		VOID OutputDebugString(
  			LPCWSTR  lpOutputString 	// address of string to be displayed  
		);"

	<stdcall: void OutputDebugStringW lpwstr>
	^self invalidCall: _failureCode!

overlappedSleepEx: anInteger bAlertable: aBoolean
	<overlap stdcall: void SleepEx dword bool>
	^self invalidCall: _failureCode!

pulseEvent: hEvent
	"Invoke the PulseEvent() function of the module wrapped by the receiver.
	Helpstring: Sets the specified event object to the signaled state and then resets it to the nonsignaled state after releasing the appropriate number of waiting threads

		BOOL __stdcall PulseEvent(
			HANDLE hEvent);"

	<stdcall: bool PulseEvent handle>
	^self invalidCall: _failureCode!

queryPerformanceCounter: aLargeInteger
	"The QueryPerformanceCounter function retrieves the current value of the high-resolution performance counter, if one exists. 
		BOOL QueryPerformanceCounter(
			LARGE_INTEGER *lpPerformanceCount 	// address of current counter value
		);"

	<stdcall: bool QueryPerformanceCounter sqword*>
	^self invalidCall: _failureCode!

queryPerformanceFrequency: aLargeInteger
	"The QueryPerformanceFrequency function retrieves the frequency of the high-resolution performance counter, if one exists. 
		BOOL QueryPerformanceFrequency(
  			LARGE_INTEGER *lpFrequency 	// address of current frequency
		);"

	<stdcall: bool QueryPerformanceFrequency sqword*>
	^self invalidCall: _failureCode!

raiseException: dwExceptionCode dwExceptionFlags: dwExceptionFlags nNumberOfArguments: nNumberOfArguments lpArguments: lpArguments
	"Invoke the RaiseException() function of the module wrapped by the receiver.
	Helpstring: Raises an exception in the calling thread.

		void __stdcall RaiseException(
			[in]unsigned long dwExceptionCode,
			[in]unsigned long dwExceptionFlags,
			[in]unsigned long nNumberOfArguments,
			[in]ULONG_PTR* lpArguments);"

	<stdcall: void RaiseException dword dword dword lpvoid>
	^self invalidCall: _failureCode!

readFile: aHandle lpBuffer: anAddress nNumberOfBytesToRead: anIntegerBytesToRead lpNumberOfBytesRead: anAddressBytesRead lpOverlapped: anOVERLAPPED
	"The ReadFile function reads data from a file, starting at the position indicated by the file pointer.
	After the read operation has been completed, the file pointer is adjusted by the number of bytes actually read,
	unless the file handle is created with the overlapped attribute. If the file handle is created for overlapped
	input and output (I/O), the application must adjust the position of the file pointer after the read operation. 

	BOOL ReadFile(
		HANDLE hFile, // handle of file to read 
		LPVOID lpBuffer, // address of buffer that receives data  
		DWORD nNumberOfBytesToRead, // number of bytes to read 
		LPDWORD lpNumberOfBytesRead, // address of number of bytes read 
		LPOVERLAPPED lpOverlapped // address of structure for data 
		);

	Answer a boolean indicating whether the function succeeds. If successful and bytesRead is left set to zero,
	the file pointer was beyond the current end of the file at the time of the read operation."

	<stdcall: bool ReadFile handle lpvoid dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

releaseMutex: hMutex
	"Invoke the ReleaseMutex() function of the module wrapped by the receiver.
	Helpstring: Releases the Mutex once

		BOOL __stdcall ReleaseMutex(
			HANDLE hMutex);"

	<stdcall: bool ReleaseMutex handle>
	^self invalidCall: _failureCode!

removeDirectory: aStringFileName
	<stdcall: bool RemoveDirectoryW lpwstr>
	^self invalidCall: _failureCode!

resetEvent: hEvent
	"Invoke the ResetEvent() function of the module wrapped by the receiver.
	Helpstring: Sets the specified event object to the nonsignaled state

		BOOL __stdcall ResetEvent(
			HANDLE hEvent);"

	<stdcall: bool ResetEvent handle>
	^self invalidCall: _failureCode!

setConsoleCP: wCodePageID
	"Invoke the SetConsoleCP() function of the module wrapped by the receiver.
	Helpstring: Sets the input code page used by the console associated with the calling process. A console uses its input code page to translate keyboard input into the corresponding character value.

		BOOL __stdcall SetConsoleCP(
			[in]unsigned int wCodePageID);"

	<stdcall: bool SetConsoleCP dword>
	^self invalidCall: _failureCode!

setConsoleCtrlHandler: pHandlerRoutine add: aBoolean
	"Set the handler function which receives console control events."

	<stdcall: bool SetConsoleCtrlHandler void* bool>
	^self invalidCall: _failureCode!

setConsoleOutputCP: wCodePageID
	"Invoke the SetConsoleOutputCP() function of the module wrapped by the receiver.
	Helpstring: Sets the output code page used by the console associated with the calling process. A console uses its output code page to translate the character values written by the various output functions into the images displayed in the console window.

		BOOL __stdcall SetConsoleOutputCP(
			[in]unsigned int wCodePageID);"

	<stdcall: bool SetConsoleOutputCP dword>
	^self invalidCall: _failureCode!

setConsoleTitle: lpConsoleTitle
	"Invoke the SetConsoleTitle() function of the module wrapped by the receiver.
	Helpstring: Sets the title for the current console window.

		BOOL __stdcall SetConsoleTitle(
			[in]LPCWSTR lpConsoleTitle);"

	<stdcall: bool SetConsoleTitleW lpwstr>
	^self invalidCall: _failureCode!

setCurrentDirectory: lpPathName
	<stdcall: bool SetCurrentDirectoryW lpwstr>
	^self invalidCall: _failureCode!

setEndOfFile: anExternalHandle
	<stdcall: bool SetEndOfFile handle>
	^self invalidCall: _failureCode!

setEnvironmentVariable: lpName lpValue: lpValue
	"Sets the value of an environment variable for the current process. Answer whether the
	request was successful.
		BOOL SetEnvironmentVariable(
			LPCWSTR lpName,	// address of environment variable name  
  			LPCWSTR lpValue 	// address of new value for variable 
		);"

	<stdcall: bool SetEnvironmentVariableW lpwstr lpwstr>
	^self invalidCall: _failureCode!

setEvent: hEvent
	"Invoke the SetEvent() function of the module wrapped by the receiver.
	Helpstring: Sets the specified event object to the signaled state

		BOOL __stdcall SetEvent(
			HANDLE hEvent);"

	<stdcall: bool SetEvent handle>
	^self invalidCall: _failureCode!

setFileAttributes: aFileName value: attributes
	"Set the attributes for the specified file or directory. 
		BOOL SetFileAttributes(
			LPCWSTR lpFileName,		// file name
			DWORD dwFileAttributes		// attributes );"

	<stdcall: bool SetFileAttributesW lpwstr dword>
	^self invalidCall: _failureCode!

setFilePointerEx: hfile liDistanceToMove: liDistanceToMove lpNewFilePointer: lpNewFilePointer dwMoveMethod: dwMoveMethod
	"Invoke the SetFilePointerEx() function of the module wrapped by the receiver.
	Helpstring: Moves the file pointer of the specified file.

		BOOL __stdcall SetFilePointerEx(
			[in]HANDLE HFILE,
			[in]LARGE_INTEGER liDistanceToMove,
			[out]LARGE_INTEGER* lpNewFilePointer,
			[in]DWORD dwMoveMethod);"

	<stdcall: bool SetFilePointerEx handle sqword sqword* dword>
	^self invalidCall: _failureCode!

setLastError: anInteger
	"Set the last Win32 error code which occurred.
		VOID SetLastError(DWORD dwErrCode)"

	<stdcall: void SetLastError dword>
	^self invalidCall: _failureCode!

setStdHandle: nStdHandle hHandle: aHandle
	"Set the handle for the standard input, standard output, or standard error device.
		BOOL SetStdHandle(
  			DWORD nStdHandle,	// input, output, or error device 
			HANDLE hHandle 	// handle to be a standard handle  
		);"

	<stdcall: bool SetStdHandle dword handle>
	^self invalidCall: _failureCode!

setVolumeLabel: lpRootPathName lpVolumeName: lpVolumeName
	"Set the label of a a file system volume. Answer whether the operation succeeded.
		BOOL SetVolumeLabel( 
			LPCWSTR lpRootPathName,
			LPCWSTR lpVolumeName
		);"

	<stdcall: bool SetVolumeLabelW lpwstr lpwstr>
	^self invalidCall: _failureCode!

sizeOfResource: anExternalHandleInstance hResInfo: anExternalHandleResource
	"Answer the byte size of the specified resource. 
		DWORD SizeofResource(
			HMODULE hModule,	// resource-module handle  
			HRSRC hResInfo 	// resource handle 
		);"

	<stdcall: dword SizeofResource handle handle>
	^self invalidCall: _failureCode!

sleep: anInteger
	"Put the calling Win32 thread to sleep for anInteger milliseconds.
		void Sleep(
			DWORD dwMilliseconds	// sleep duration in millisecs
		);
	N.B. This is an overlapped call, and will not interrupt the execution
	of Dolphin's background threads since it is performed on a separate
	thread. Only the calling Process will be delayed.!!
	"

	<overlap stdcall: void Sleep dword>
	^self invalidCall: _failureCode!

sleepEx: anInteger bAlertable: aBoolean
	<stdcall: void SleepEx dword bool>
	^self invalidCall: _failureCode!

systemTimeToFileTime: lpSystemTime lpFileTime: lpFileTime
	"Convert a SYSTEMTIME to a FILETIME, answering whether the conversion succeeded.
		BOOL SystemTimeToFileTime(
			CONST SYSTEMTIME *lpSystemTime,	// address of system time to convert 
			LPFILETIME lpFileTime 	// address of buffer for converted file time 
		);"

	<stdcall: bool SystemTimeToFileTime SYSTEMTIME* FILETIME*>
	^self invalidCall: _failureCode!

terminateProcess: aProcessHandle exitCode: anUnsignedInteger
	"The TerminateProcess function terminates the specified process and all of its threads. 

	BOOL TerminateProcess(
						HANDLE hProcess, // handle to the process
						UINT uExitCode   // exit code for the process
						);
	Parameters
		hProcess  [in]		Handle to the process to terminate. 
						Windows NT/2000: The handle must have PROCESS_TERMINATE
										access. For more information, see Process
										Security and Access Rights. 
		uExitCode [in]		Specifies the exit code for the process and for all threads terminated
						as a result of this call. Use the GetExitCodeProcess function to
						retrieve the process's exit value. Use the GetExitCodeThread
						function to retrieve a thread's exit value."

	<stdcall: bool TerminateProcess handle dword>
	^self invalidCall: _failureCode!

terminateProcessId: anInteger 
	| hProcess |
	hProcess := self 
				openProcess: PROCESS_TERMINATE
				bInheritHandle: false asParameter
				dwProcessId: anInteger.
	hProcess isNull ifTrue: [self systemError].
	[(self terminateProcess: hProcess exitCode: 0) ifFalse: [self systemError]] 
		ensure: [self closeHandle: hProcess]!

threadGetLastError
	"Answer the last Win32 error code which last occurred in the overlapped call thread
	associated with the current <Process>."

	<overlap stdcall: dword GetLastError>
	^self invalidCall: _failureCode!

threadSetLastError: anInteger
	"Set the last Win32 error code which occurred for the overlapped call thread associated with
	the calling <Process>"

	<overlap stdcall: void SetLastError dword>
	^self invalidCall: _failureCode!

updateResource: hUpdate lpType: resTypeString lpName: resName wLanguage: langId lpData: pData cbData: dataSize
	"UpdateResource adds, deletes, or replaces a resource in an executable file. 

	BOOL UpdateResource(
		HANDLE hUpdate <>, // update-file handle
		LPCWSTR lpType <>, // resource type
		LPCWSTR lpName <>, // resource name
		WORD wLanguage <>, // language identifier
		LPVOID lpData <>,  // resource data
		DWORD cbData <>    // length of resource data
		);"

	<stdcall: bool UpdateResourceW handle lpvoid lpvoid word lpvoid dword>
	^self invalidCall: _failureCode!

updateResourcesOf: aString do: aMonadicValuable 
	| hUpdate |
	hUpdate := self beginUpdateResource: aString bDeleteExistingResources: false.
	[aMonadicValuable value: hUpdate] ifCurtailed: [self endUpdateResource: hUpdate fDiscard: true].
	(self endUpdateResource: hUpdate fDiscard: false) ifFalse: [self systemError]!

verifyVersionInfo: lpVersionInformation dwTypeMask: dwTypeMask dwlConditionMask: dwlConditionMask
	"Invoke the VerifyVersionInfo() function of the module wrapped by the receiver.
	Helpstring: Compares a set of operating system version requirements to the corresponding values for the currently running version of the system

		BOOL __stdcall VerifyVersionInfo(
			[in, out]OSVERSIONINFOEXW* lpVersionInformation,
			[in]DWORD dwTypeMask,
			[in]unsigned __int64 dwlConditionMask);"

	<stdcall: bool VerifyVersionInfoW OSVERSIONINFOEXW* dword qword>
	^self invalidCall: _failureCode!

verSetConditionMask: conditionMask typeMask: typeMask condition: condition
	"Invoke the VerSetConditionMask() function of the module wrapped by the receiver.
	Helpstring: Sets the bits of a 64-bit value to indicate the comparison operator to use for a specified operating system version attribute

		unsigned __int64 __stdcall VerSetConditionMask(
			[in]unsigned __int64 ConditionMask,
			[in]DWORD TypeMask,
			[in]BYTE Condition);"

	<stdcall: qword VerSetConditionMask qword dword byte>
	^self invalidCall: _failureCode!

virtualAlloc: lpAddress dwSize: dwSize flAllocationType: flAllocationType flProtect: flProtect
	"Invoke the VirtualAlloc() function of the module wrapped by the receiver.
	Helpstring: Reserves or commits a region of pages in the virtual address space

		LPVOID __stdcall VirtualAlloc(
			LPVOID lpAddress,
			DWORD dwSize,
			DWORD flAllocationType,
			DWORD flProtect);"

	<stdcall: void* VirtualAlloc void* dword dword dword>
	^self invalidCall: _failureCode!

virtualFree: lpAddress dwSize: dwSize dwFreeType: dwFreeType
	"Invoke the VirtualFree() function of the module wrapped by the receiver.
	Helpstring: Releases or decommits (or both) a region of pages within the virtual address space

		BOOL __stdcall VirtualFree(
			LPVOID lpAddress,
			DWORD dwSize,
			DWORD dwFreeType);"

	<stdcall: bool VirtualFree void* dword dword>
	^self invalidCall: _failureCode!

virtualProtect: lpAddress dwSize: dwSize flNewProtect: flNewProtect lpflOldProtect: lpflOldProtect
	"Invoke the VirtualProtect() function of the module wrapped by the receiver.
	Helpstring: Changes the access protection on a region of committed pages in the virtual address space

		BOOL __stdcall VirtualProtect(
			LPVOID lpAddress,
			DWORD dwSize,
			DWORD flNewProtect,
			DWORD* lpflOldProtect);"

	<stdcall: bool VirtualProtect void* dword dword dword*>
	^self invalidCall: _failureCode!

virtualQuery: lpAddress lpBuffer: lpBuffer dwLength: dwLength
	"Invoke the VirtualQuery() function of the module wrapped by the receiver.
	Helpstring: Provides information about a range of pages in the virtual address space

		DWORD __stdcall VirtualQuery(
			LPVOID lpAddress,
			MEMORY_BASIC_INFORMATION* lpBuffer,
			DWORD dwLength);"

	<stdcall: dword VirtualQuery void* lpvoid dword>
	^self invalidCall: _failureCode!

waitForSingleObject: hHandle dwMilliseconds: dwMilliseconds
	"Invoke the WaitForSingleObject() function of the module wrapped by the receiver.
	Helpstring: Waits until the specified object reaches the signaled state, or until the time-out elapses

		unsigned long __stdcall WaitForSingleObject(
			HANDLE hHandle,
			unsigned long dwMilliseconds);"

	<overlap stdcall: dword WaitForSingleObject handle dword>
	^self invalidCall: _failureCode!

wideCharToMultiByte: codePage dwFlags: dwFlags lpWideCharStr: lpWideCharStr cchWideChar: cchWideChar lpMultiByteStr: lpMultiByteStr cchMultiByte: cchMultiByte lpDefaultChar: lpDefaultChar lpUsedDefaultChar: lpUsedDefaultChar
	"Maps a Unicode string to a multi-byte character string. 
	Despite the name, aStringOut, need not contain MBCS characters.

		int WideCharToMultiByte(
			UINT CodePage,			// code page 
			DWORD dwFlags,			// performance and mapping flags 
			LPCWSTR lpWideCharStr,	// address of wide-character string 
			int cchWideChar,		// number of characters in string 
			LPSTR lpMultiByteStr,	// address of buffer for new string 
			int cchMultiByte,		// size of buffer 
			LPCSTR lpDefaultChar,	// address of default for unmappable characters  
			LPBOOL lpUsedDefaultChar// address of flag set when default char. used 
		);"

	<stdcall: sdword WideCharToMultiByte dword dword lpvoid sdword lpvoid sdword lpstr lpvoid>
	^self invalidCall: _failureCode!

winExec: lpstrCmdLine uCmdShow: nCmdShow
	"Spawn the specified application. 
		UINT WinExec(
  			LPCSTR lpCmdLine,	// address of command line 
			UINT uCmdShow 	// window style for new application 
		);
	Note that this is run as an overlapped call to avoid delaying the entire
	Smalltalk image."

	<overlap stdcall: dword WinExec lpstr dword>
	^self invalidCall: _failureCode!

writeFile: aHandle lpBuffer: anAddress nNumberOfBytesToWrite: anIntegerBytesToWrite lpNumberOfBytesWritten: anAddressBytesWritten lpOverlapped: anOVERLAPPED
	"The WriteFile function writes data to a file and is designed for both synchronous and asynchronous operation.
	The function starts writing data to the file at the position indicated by the file pointer. After the write
	operation has been completed, the file pointer is adjusted by the number of bytes actually written, except when
	the file is opened with FILE_FLAG_OVERLAPPED. If the file handle was created for overlapped input and output
	(I/O), the application must adjust the position of the file pointer after the write operation is finished. 

	BOOL WriteFile(
		HANDLE hFile, // handle of file to write to 
		LPCVOID lpBuffer, // address of data to write to file 
		DWORD nNumberOfBytesToWrite, // number of bytes to write 
		LPDWORD lpNumberOfBytesWritten, // address of number of bytes written 
		LPOVERLAPPED lpOverlapped // addr. of structure needed for overlapped I/O  
		);

	Answer a boolean indicating whether the function succeeds."

	<stdcall: bool WriteFile handle lpvoid dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

zeroMemory: pvDest length: cBytes
	<stdcall: void RtlZeroMemory void* dword>
	^self invalidCall: _failureCode! !
!OS.KernelLibrary categoriesForMethods!
addAtom:!public!win32 functions-atom! !
allocConsole!**auto generated**!public!win32 functions-console! !
attachConsole:!**auto generated**!public!win32 functions-console! !
beep:dwDuration:!public!win32 functions-error! !
beginUpdateResource:bDeleteExistingResources:!public!win32 functions-resource! !
close!public!realizing/unrealizing! !
closeHandle:!public!win32 functions-handles and objects! !
compareString:dwCmpFlags:lpString1:cchCount1:lpString2:cchCount2:!public!win32 functions-national language support! !
compareStringOrdinal:cchCount1:lpString2:cchCount2:bIgnoreCase:!public!win32 functions-national language support! !
copyFile:lpNewFileName:bfailIfExists:!public!win32 functions-file management! !
copyMemory:source:length:!public!win32 functions-memory management! !
createDirectory:lpSecurityAttributes:!public!win32 functions-file management! !
createEvent:bManualReset:bInitialState:lpName:!**auto generated**!public!win32 functions-synchronization! !
createFile:dwDesiredAccess:dwSharedMode:lpSecurityAttributes:dwCreationDistribution:dwFlagsAndAttributes:hTemplateFile:!public!win32 functions-file management! !
createMutex:bInitialOwner:lpName:!**auto generated**!public!win32 functions-synchronization! !
debugBreak!**auto generated**!public!win32 functions-debugging! !
deleteFile:!public!win32 functions-file management! !
deviceIoControl:dwIoControlCode:lpInBuffer:nInBufferSize:lpOutBuffer:nOutBufferSize:lpBytesReturned:lpoverlapped:!public! !
duplicateHandle:hSourceHandle:hTargetProcessHandle:lpTargetHandle:dwDesiredAccess:bInheritHandle:dwOptions:!public!win32 functions-handles and objects! !
endUpdateResource:fDiscard:!public!win32 functions-resource! !
enumDateFormats:locale:dwFlags:!public!win32 functions-national language support! !
enumSystemCodePages:dwFlags:!public!win32 functions-national language support! !
enumSystemLocales:dwFlags:!public!win32 functions-national language support! !
enumTimeFormats:locale:dwFlags:!public!win32 functions-national language support! !
enumUILanguages:dwFlags:lParam:!public!win32 functions-national language support! !
expandEnvironmentStrings:!public!win32 functions-process and thread! !
expandEnvironmentStrings:lpDst:nSize:!public!win32 functions-process and thread! !
fileTimeToLocalTime:lpLocalFileTime:!public!win32 functions-date and time! !
fileTimeToSystemTime:lpSystemTime:!public!win32 functions-date and time! !
findClose:!public!win32 functions-file management! !
findFirstFile:lpFindFileData:!public!win32 functions-file management! !
findNextFile:lpFindFileData:!public!win32 functions-file management! !
findResource:lpName:lpType:!public!win32 functions-resource! !
flushFileBuffers:!public!win32 functions-file management! !
formatMessage:lpSource:dwMessageId:dwLanguageId:lpBuffer:nSize:arguments:!public!win32 functions-error! !
formatMessage:source:flags:withArguments:!helpers!public! !
freeConsole!**auto generated**!public!win32 functions-console! !
freeLibrary:!public!win32 functions-dynamic link library! !
getACP!**auto generated**!public!win32 functions-national language support! !
getAtomName:lpBuffer:nSize:!public!win32 functions-atom! !
getCalendarInfo:calendar:calType:lpCalData:cchData:lpValue:!**auto generated**!public!win32 functions-national language support! !
getCommandLine!public!win32 functions-process and thread! !
getComputerName:nSize:!public!win32 functions-system information! !
getConsoleTitle:nSize:!**auto generated**!public!win32 functions-console! !
getCPInfoExW:dwFlags:lpCPInfoEx:!**auto generated**!public!win32 functions-national language support! !
getCurrentDirectory:lpBuffer:!public!win32 functions-directory management! !
getCurrentProcess!public!win32 functions-process and thread! !
getCurrentThread!public!win32 functions-process and thread! !
getCurrentThreadId!public!win32 functions-process and thread! !
getDiskFreeSpace:lpSectorsPerCluster:lpBytesPerSector:lpNumberOfFreeClusters:lpTotalNumberOfClusters:!public!win32 functions-file management! !
getDiskFreeSpaceEx:lpFreeBytesAvailable:lpTotalNumberOfBytes:lpTotalNumberOfFreeBytes:!public!win32 functions-file system! !
getEnvironmentVariable:lpBuffer:nSize:!public!win32 functions-process and thread! !
getFileAttributes:!public!win32 functions-file management! !
getFileSizeEx:lpFileSize:!**auto generated**!public!win32 functions-file management! !
getFileTime:lpCreationTime:lpLastAccessTime:lpLastWriteTime:!public!win32 functions-file management! !
getFileType:!public!win32 functions-file system! !
getFinalPathNameByHandle:lpszFilePath:cchFilePath:dwFlags:!public!win32 functions-file management! !
getFullPathName:nBufferLength:lpBuffer:lpFilePart:!public!win32 functions-file management! !
getLastError!public!win32 functions-error! !
getLocaleInfo:lCType:lpLCData:cchData:!public!win32 functions-national language support! !
getLocaleInfoEx:lCType:lpLCData:cchData:!public!win32 functions-national language support! !
getLocalTime:!public!win32 functions-date and time! !
getModuleFileName:lpFilename:nSize:!public!win32 functions-dynamic link library! !
getModuleHandle:!public!win32 functions-dynamic link library! !
getNumberFormat:dwFlags:lpValue:lpFormat:lpNumberStr:cchNumber:!**auto generated**!public!win32 functions-national language support! !
getProcAddress:lpProcName:!public!win32 functions-dynamic link library! !
getProcAddressDWORD:lpProcName:!private!win32 functions-dynamic link library! !
getProcessHeap!public!win32 functions-memory management! !
getShortPathName:lpszShortPath:cchBuffer:!public!win32 functions-file management! !
getStdHandle:!public!win32 functions-console! !
getStringType:lpSrcStr:cchSrc:lpCharType:!**auto generated**!public!win32 functions-national language support! !
getSystemDefaultLCID!public!win32 functions-national language support! !
getSystemDirectory:uSize:!public!win32 functions-system information! !
getSystemTime:!**auto generated**!public!win32 functions-date and time! !
getSystemTimeAsFileTime:!**auto generated**!public!win32 functions-date and time! !
getSystemTimePreciseAsFileTime:!**auto generated**!public!win32 functions-date and time! !
getSystemWindowsDirectory:uSize:!public!win32 functions-system information! !
getTempFileName:lpPrefixString:uUnique:lpTempFileName:!public!win32 functions-file management! !
getTempPath:lpBuffer:!public!win32 functions-file management! !
getThreadTimes:lpCreationTime:lpExitTime:lpKernelTime:lpUserTime:!public!win32 functions-process and thread! !
getThreadUILanguage!public!win32 functions-national language support! !
getTickCount!public!win32 functions-date and time!win32 functions-system information! !
getTimeZoneInformation:!public!win32 functions-date and time! !
getUserDefaultLCID!public!win32 functions-national language support! !
getVolumeInformation:lpVolumeNameBuffer:nVolumeNameSize:lpVolumeSerialNumber:lpMaximumComponentLength:lpFileSystemFlags:lpFileSystemNameBuffer:nFileSystemNameSize:!**auto generated**!public!win32 functions-file system! !
getWindowsDirectory:uSize:!public!win32 functions-system information! !
globalAlloc:dwBytes:!public!win32 functions-memory management! !
globalFree:!public!win32 functions-memory management! !
globalLock:!public!win32 functions-memory management! !
globalUnlock:!public!win32 functions-memory management! !
heapAlloc:dwFlags:dwBytes:!public!win32 functions-memory management! !
heapCompact:dwFlags:!public!win32 functions-memory management! !
heapFree:dwFlags:lpMem:!public!win32 functions-memory management! !
heapReAlloc:dwFlags:lpMem:dwBytes:!public!win32 functions-memory management! !
heapSize:dwFlags:lpMem:!public!win32 functions-memory management! !
heapValidate:dwFlags:lpMem:!public!win32 functions-memory management! !
inputQueueMask!constants!private! !
isValidLocale:dwFlags:!public!win32 functions-national language support! !
isWindows10OrGreater!public!win32 functions-version helpers! !
isWindows7OrGreater!public!win32 functions-version helpers! !
isWindows7SP1OrGreater!public!win32 functions-version helpers! !
isWindows8OrGreater!public!win32 functions-version helpers! !
isWindows8Point1OrGreater!public!win32 functions-version helpers! !
isWindowsServer!public!win32 functions-version helpers! !
isWindowsVersionOrGreater:wMinorVersion:wServicePackMajor:!public!win32 functions-version helpers! !
isWindowsVistaOrGreater!public!win32 functions-version helpers! !
isWindowsVistaSP1OrGreater!public!win32 functions-version helpers! !
isWindowsVistaSP2OrGreater!public!win32 functions-version helpers! !
isWindowsXPOrGreater!public!win32 functions-version helpers! !
isWow64!public!win32 functions-system information! !
isWow64Process:wow64Process:!public!win32 functions-system information! !
lcMapString:dwMapFlags:lpScrStr:cchSrc:lpDestStr:cchDest:!public!win32 functions-national language support! !
loadLibraryEx:hFile:dwFlags:!public!win32 functions-dynamic link library! !
loadResource:hResInfo:!public!win32 functions-resource! !
localeNameToLCID:dwFlags:!public!win32 functions-national language support! !
localFileTimeToFileTime:lpFileTime:!public!win32 functions-date and time! !
localFree:!**auto generated**!public!win32 functions-memory management! !
lockResource:!public!win32 functions-resource! !
moveFile:lpNewFileName:!public!win32 functions-file management! !
moveFileEx:lpNewFileName:dwFlags:!public!win32 functions-file management! !
multiByteToWideChar:dwFlags:lpMultiByteStr:cchMultiByte:lpWideCharStr:cchWideChar:!public!win32 functions-string manipulation! !
openProcess:bInheritHandle:dwProcessId:!public!win32 functions-process and thread! !
outputDebugString:!public!win32 functions-debugging! !
overlappedSleepEx:bAlertable:!public!win32 functions-process and thread! !
pulseEvent:!**auto generated**!public!win32 functions-synchronization! !
queryPerformanceCounter:!public!win32 functions-performance monitoring! !
queryPerformanceFrequency:!public!win32 functions-performance monitoring! !
raiseException:dwExceptionFlags:nNumberOfArguments:lpArguments:!**auto generated**!public! !
readFile:lpBuffer:nNumberOfBytesToRead:lpNumberOfBytesRead:lpOverlapped:!public!win32 functions-file management! !
releaseMutex:!**auto generated**!public!win32 functions-synchronization! !
removeDirectory:!public!win32 functions-file management! !
resetEvent:!**auto generated**!public!win32 functions-synchronization! !
setConsoleCP:!**auto generated**!public!win32 functions-console! !
setConsoleCtrlHandler:add:!public!win32 functions-console! !
setConsoleOutputCP:!**auto generated**!public!win32 functions-console! !
setConsoleTitle:!**auto generated**!public! !
setCurrentDirectory:!public!win32 functions-directory management! !
setEndOfFile:!public!win32 functions-file management! !
setEnvironmentVariable:lpValue:!public!win32 functions-process and thread! !
setEvent:!**auto generated**!public!win32 functions-synchronization! !
setFileAttributes:value:!public! !
setFilePointerEx:liDistanceToMove:lpNewFilePointer:dwMoveMethod:!**auto generated**!public!win32 functions-file management! !
setLastError:!public!win32 functions-error! !
setStdHandle:hHandle:!public!win32 functions-console! !
setVolumeLabel:lpVolumeName:!public!win32 functions-file system! !
sizeOfResource:hResInfo:!public!win32 functions-resource! !
sleep:!public!win32 functions-process and thread! !
sleepEx:bAlertable:!public!win32 functions-process and thread! !
systemTimeToFileTime:lpFileTime:!public!win32 functions-date and time! !
terminateProcess:exitCode:!public!win32 functions-process and thread! !
terminateProcessId:!helpers!public! !
threadGetLastError!public!win32 functions-error! !
threadSetLastError:!public!win32 functions-error! !
updateResource:lpType:lpName:wLanguage:lpData:cbData:!public!win32 functions-resource! !
updateResourcesOf:do:!operations!public! !
verifyVersionInfo:dwTypeMask:dwlConditionMask:!**auto generated**!public!win32 functions-system information! !
verSetConditionMask:typeMask:condition:!**auto generated**!public!win32 functions-system information! !
virtualAlloc:dwSize:flAllocationType:flProtect:!**auto generated**!public!win32 functions-memory management! !
virtualFree:dwSize:dwFreeType:!**auto generated**!public!win32 functions-memory management! !
virtualProtect:dwSize:flNewProtect:lpflOldProtect:!**auto generated**!public!win32 functions-memory management! !
virtualQuery:lpBuffer:dwLength:!**auto generated**!public!win32 functions-memory management! !
waitForSingleObject:dwMilliseconds:!**auto generated**!public!win32 functions-synchronization! !
wideCharToMultiByte:dwFlags:lpWideCharStr:cchWideChar:lpMultiByteStr:cchMultiByte:lpDefaultChar:lpUsedDefaultChar:!public!win32 functions-string manipulation! !
winExec:uCmdShow:!public!win32 functions-process and thread! !
writeFile:lpBuffer:nNumberOfBytesToWrite:lpNumberOfBytesWritten:lpOverlapped:!public!win32 functions-file management! !
zeroMemory:length:!public!win32 functions-memory management! !
!

!OS.KernelLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which
	the receiver represents."

	^'KERNEL32'!

open
	"Answer a new instance of the receiver to represent the Kernel32 DLL. Special handling 
	is required for this library because opening a library is normally done through the 
	receiver's singleton instance. The VM stores the current Kernel32 handle into the 
	VM object registry on startup."

	WinVerOrGreaterMask := nil.
	^self fromHandle: VM kernelHandle!

sharedVariableName
	^#{Kernel32}! !
!OS.KernelLibrary class categoriesForMethods!
fileName!constants!public! !
open!instance creation!public! !
sharedVariableName!constants!initializing!private! !
!

