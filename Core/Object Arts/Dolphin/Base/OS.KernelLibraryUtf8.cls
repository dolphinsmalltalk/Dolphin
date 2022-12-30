"Filed out from Dolphin Smalltalk"!

OS.KernelLibrary subclass: #'OS.KernelLibraryUtf8'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.KernelLibraryUtf8 guid: (Core.GUID fromString: '{563e8c94-2eb8-4216-b8ba-382e02ed65b4}')!
OS.KernelLibraryUtf8 comment: ''!
!OS.KernelLibraryUtf8 methodsFor!

addAtom: aString
	"The AddAtom function adds a character string to the local atom table and returns a unique value (an atom) identifying the string. 
	Answer the value is the newly created atom or zero if the function fails.

		ATOM AddAtom(
			LPCWSTR  lpString 	// address of string to add 
		);"

	<stdcall: word AddAtomA lpstr>
	^self invalidCall: _failureCode!

beginUpdateResource: fileNameString bDeleteExistingResources: aBoolean
	"BeginUpdateResource returns a handle that can be used by the UpdateResource
	function to add, delete, or replace resources in an executable file. 

	HANDLE BeginUpdateResource(
		LPCSTR pFileName <>,             // executable file name
		BOOL bDeleteExistingResources <>  // deletion option
		);"

	<stdcall: handle BeginUpdateResourceA lpstr bool>
	^self invalidCall: _failureCode!

compareString: locale dwCmpFlags: dwCmpFlags lpString1: lpString1 cchCount1: cchCount1 lpString2: lpString2 cchCount2: cchCount2
	<stdcall: sdword CompareStringA dword dword lpstr sdword lpstr sdword>
	^self invalidCall: _failureCode!

compareString: localeInteger dwCmpFlags: flagsInteger string1: aString1 string2: aString2
	| utf1 utf2 |
	utf1 := aString1 asUtf8String.
	utf2 := aString2 asUtf8String.
	^self
		compareString: localeInteger
		dwCmpFlags: flagsInteger
		lpString1: utf1
		cchCount1: utf1 size
		lpString2: utf2
		cchCount2: utf2 size!

copyFile: fromString lpNewFileName: toString bfailIfExists: fail
	"Copies the file named fromString to a file named toString. If toString already exists then the copy will only proceed if fail is false.

	BOOL	CopyFile(
		LPCSTR lpExistingFileName,
		LPCSTR lpNewFileName,
		BOOL bFailIfExists
		);"

	<overlap stdcall: bool CopyFileA lpstr lpstr bool>
	^self invalidCall: _failureCode!

copyFile: fromString to: toString
	"Copies the file named fromString to a file named toString."

	#todo.	"Due to a VM bug, auto-conversion of Strings is not thread-safe in overlapped calls, so convert explicitly."
	^(self
		copyFile: fromString asUtf8String
		lpNewFileName: toString asUtf8String
		bfailIfExists: false) ifFalse: [self systemError: Processor activeProcess lastError]!

createDirectory: path lpSecurityAttributes: aSECURITYATTRIBUTES
	"Create a new directory with the specified <String> path, 
	answering whether successful.

		BOOL CreateDirectory(
			LPCSTR lpPathName,
			LPSECURITY_ATTRIBUTES lpSecurityAttributes
		);"

	<stdcall: bool CreateDirectoryA lpstr lpvoid>
	^self invalidCall: _failureCode!

createEvent: lpEventAttributes bManualReset: bManualReset bInitialState: bInitialState lpName: lpName
	"Invoke the CreateEvent() function of the module wrapped by the receiver.
	Helpstring: Creates a named or unnamed event object

		HANDLE __stdcall CreateEvent(
			[in]SECURITY_ATTRIBUTES* lpEventAttributes,
			BOOL bManualReset,
			BOOL bInitialState,
			LPCSTR lpName);"

	<stdcall: handle CreateEventA lpvoid bool bool lpstr>
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

	<stdcall: handle CreateFileA lpstr dword dword lpvoid dword dword handle>
	^self invalidCall: _failureCode!

createMutex: lpMutexAttributes bInitialOwner: bInitialOwner lpName: lpName
	"Invoke the CreateMutex() function of the module wrapped by the receiver.
	Helpstring: Creates a named or unnamed mutex object

		HANDLE __stdcall CreateMutex(
			[in]void* lpMutexAttributes,
			BOOL bInitialOwner,
			LPSTR lpName);"

	<stdcall: handle CreateMutexA void* bool lpstr>
	^self invalidCall: _failureCode!

deleteFile: aStringFileName
	"The DeleteFile function deletes an existing file. Answer true if the function succeeds.

		BOOL DeleteFile( LPCSTR lpFileName);

	If the file does not exist, the DeleteFile function fails. The function fails if an
	application attempts to delete a file that is open for normal I/O or as a memory-mapped
	file."

	<stdcall: bool DeleteFileA lpstr>
	^self invalidCall: _failureCode!

endUpdateResource: hUpdate fDiscard: aBoolean
	"EndUpdateResource ends a resource update in an executable file. 
	
	BOOL EndUpdateResource(
		HANDLE hUpdate <>, // update-file handle
		BOOL fDiscard <>   // write option 
		);"

	<stdcall: bool EndUpdateResourceA handle bool>
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

	<stdcall: bool EnumDateFormatsA lpvoid dword dword>
	^self invalidCall: _failureCode!

enumSystemCodePages: aCallbackThunk dwFlags: dwFlags
	<stdcall: bool EnumSystemCodePagesA lpvoid dword>
	^self invalidCall: _failureCode!

enumSystemLocales: aCallbackThunk dwFlags: dwFlags
	"Enumerates the locales that are either installed on or supported by a system, depending on the 
	dwFlags parameter. The callback is invoked repeatedly until all locales are exhausted, or the
	callback function returns false.

		BOOL EnumSystemLocales(
			LOCALE_ENUMPROC lpLocaleEnumProc,	// pointer to enumeration callback function
			DWORD dwFlags 	// indicates which locales to enumerate
		);"

	<stdcall: bool EnumSystemLocalesA lpvoid dword>
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

	<stdcall: bool EnumTimeFormatsA lpvoid dword dword>
	^self invalidCall: _failureCode!

enumUILanguages: aCallbackThunk dwFlags: dwFlags lParam: lParam
	<stdcall: bool EnumUILanguagesA lpvoid dword uintptr>
	^self invalidCall: _failureCode!

expandEnvironmentStrings: aString
	"Answer the <String> result of replacing environment-variable references of the form
	%VariableName% with their defined values.
		(Kernel32 expandEnvironmentStrings: '%username% is cool') 
	"

	| answer size |
	aString isEmpty ifTrue: [^aString].
	size := self
				expandEnvironmentStrings: aString
				lpDst: nil
				nSize: 0.
	size == 0 ifTrue: [^self systemError].
	"Note an oddity of the 'A' version of this function, that is documented: 'When using ANSI strings, the buffer size should be the string length, plus terminating null character, plus one.'
	There is no obvious reason for the 'plus one' (it seems like a bug), but it does get nulled out so we need to make sure the buffer has space for the extra null, and then discard later."
	answer := Utf8String newFixed: size - 1.
	^(self
		expandEnvironmentStrings: aString
		lpDst: answer
		nSize: size) == 0
		ifTrue: [self systemError]
		ifFalse: [answer copyFrom: 1 to: size - 2]!

expandEnvironmentStrings: lpSrc lpDst: lpDst nSize: bufSize
	"Replace environment-variable strings with their defined values. 
		DWORD ExpandEnvironmentStrings(
			LPCTSTR lpSrc,
			LPTSTR lpDst,
			DWORD nSize);"

	<stdcall: dword ExpandEnvironmentStringsA lpstr lpstr dword>
	^self invalidCall: _failureCode!

getAtomName: id lpBuffer: aString nSize: anInteger
	"The GetAtomName function retrieves a copy of the character string associated with the specified local atom.
	This function replaces the GetAtomHandle function. 

		UINT GetAtomName(
			ATOM  nAtom,		// atom identifying character string 
			LPSTR  lpBuffer,	// address of buffer for atom string  
			int  nSize 		// size of buffer 
			);	

	Return Value
	If the function succeeds, the return value is the length of the string copied to the buffer, in characters, not including the terminating null character.
	If the function fails, the return value is zero. To get extended error information, call GetLastError."

	<stdcall: dword GetAtomNameA word lpstr sdword>
	^self invalidCall: _failureCode!

getComputerName: buffer nSize: pBufSize
	"Retrieves the computer name of the current system into the argument, buffer (which must be large
	enough to contain MAX_COMPUTERNAME_LENGTH+1 characters). Answers whether the name
	was successfully retrieved. If successful then the value of pBufSize will be the number of characters
	in the name.

		BOOL GetComputerName(
			LPSTR lpBuffer,	// address of name buffer 
			LPDWORD nSize 		// address of size of lpBuffer
		);"

	<stdcall: bool GetComputerNameA lpstr dword*>
	^self invalidCall: _failureCode!

getCurrentDirectory: nBufferLength lpBuffer: lpBuffer
	<stdcall: dword GetCurrentDirectoryA dword lpstr>
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

	<stdcall: bool GetDiskFreeSpaceA lpstr dword* dword* dword* dword*>
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

	<stdcall: bool GetDiskFreeSpaceExA lpstr qword* qword* qword*>
	^self invalidCall: _failureCode!

getEnvironmentVariable: nameString lpBuffer: bufString nSize: bufSize
	"Populate bufString with the value of the specified environment variable.
		DWORD GetEnvironmentVariable(
			LPCSTR lpName,	// address of environment variable name 
			LPSTR lpBuffer,	// address of buffer for variable value 
			DWORD nSize 	// size of buffer, in characters 
		);"

	<stdcall: dword GetEnvironmentVariableA lpstr lpstr dword>
	^self invalidCall: _failureCode!

getFileAttributes: aFileName
	"Answer attributes for the specified file or directory. 
		DWORD GetFileAttributes(
			LPCSTR  lpFileName 	// address of the name of a file or directory  
		);"

	<stdcall: sdword GetFileAttributesA lpstr>
	^self invalidCall: _failureCode!

getFinalPathNameByHandle: hFile
	| size buf |
	size := self
				getFinalPathNameByHandle: hFile
				lpszFilePath: nil
				cchFilePath: 0
				dwFlags: FILE_NAME_NORMALIZED.
	size == 0 ifTrue: [^self systemError].
	"Note that for the 'A' version of the function, the returned size does not include the null terminator"
	buf := Utf8String newFixed: size.
	(self
		getFinalPathNameByHandle: hFile
		lpszFilePath: buf
		cchFilePath: size + 1
		dwFlags: FILE_NAME_NORMALIZED) == 0
		ifTrue: [^self systemError].
	^buf!

getFinalPathNameByHandle: hFile lpszFilePath: lpszFilePath cchFilePath: cchFilePath dwFlags: dwFlags
	"DWORD GetFinalPathNameByHandleA(
		HANDLE hFile,
		LPSTR  lpszFilePath,
		DWORD  cchFilePath,
		DWORD  dwFlags
	);"

	<stdcall: dword GetFinalPathNameByHandleA handle lpstr dword dword>
	^self invalidCall: _failureCode!

getModuleFileName: aHandle lpFilename: aString nSize: anInteger
	"Retrieve the full path and filename for the executable file containing the specified module.

		DWORD GetModuleFileName(
  			HMODULE  hModule,		// handle to module to find filename for 
			LPWSTR  lpFilename,	// pointer to buffer for module path 
			DWORD  nSize 			// size of buffer, in characters 
		);"

	<stdcall: dword GetModuleFileNameA handle lpstr dword>
	^self invalidCall: _failureCode!

getModuleHandle: aString
	<stdcall: handle GetModuleHandleA lpstr>
	^self invalidCall: _failureCode!

getShortPathName: lpszLongPath lpszShortPath: lpszShortPath cchBuffer: cchBuffer
	"Answers the short pathname form of lpszLongPath in lpszShortPath"

	<stdcall: dword GetShortPathNameA lpstr lpstr dword>
	^self invalidCall: _failureCode!

getSystemDirectory: lpBuffer uSize: uSize
	"Answer the path of the windows system directory.

		UINT GetSystemDirectory(
			LPTSTR lpBuffer, 
			UINT uSize);"

	<stdcall: dword GetSystemDirectoryA lpstr dword>
	^self invalidCall: _failureCode!

getSystemWindowsDirectory: lpBuffer uSize: uSize
	"	UINT GetSystemWindowsDirectory(
			LPTSTR lpBuffer, 
			UINT uSize); "

	<stdcall: dword GetSystemWindowsDirectoryA lpstr dword>
	^self invalidCall: _failureCode!

getTempFileName: pathString lpPrefixString: prefixString uUnique: anInteger lpTempFileName: bufferString
	"Generate a temporary file name by concatenating the specified path and prefix strings, and a hexadecimal string formed from 
	the Integer, unique, and the .TMP extension. If anInteger is zero, the function generates a suitable value and creates
	the temporary file in the specified directory, otherwise the function generates the name (using the specified value) but does
	not create the file.

		UINT GetTempFileName(
  			LPCSTR  lpPathName,		// address of directory name for temporary file 
			LPCSTR  lpPrefixString,	// address of filename prefix 
			UINT  uUnique,	// number used to create temporary filename 
			LPSTR  lpTempFileName 	// address of buffer that receives the new filename 
		);"

	<stdcall: dword GetTempFileNameA lpstr lpstr dword lpstr>
	^self invalidCall: _failureCode!

getTempPath: nBufferLength lpBuffer: lpBuffer
	"Populate the <String> buffer, lpBuffer, with the system directory designated for temporary files.
	Answers the number of characters written to the buffer."

	<stdcall: dword GetTempPathA dword lpstr>
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

	<stdcall: bool GetVolumeInformationA lpstr lpstr dword dword* dword* dword* lpstr dword>
	^self invalidCall: _failureCode!

moveFile: aStringOldFileName lpNewFileName: aStringnewFileName
	"The MoveFile function will move (rename) either a file or a directory (including all its children)
	either in the same directory or across directories. The one caveat is that the MoveFile function will
	fail on directory moves when the destination is on a different volume. 
	Answer true if the function succeeds. 

	BOOL MoveFile(
		LPCSTR lpExistingFileName, // address of name of the existing file  
		LPCSTR lpNewFileName // address of new name for the file 
		);"

	<stdcall: bool MoveFileA lpstr lpstr>
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

	<stdcall: bool MoveFileExA lpstr lpstr dword>
	^self invalidCall: _failureCode!

outputDebugString: aString
	"Send aString to the debugger.

		VOID OutputDebugString(
  			LPCSTR  lpOutputString 	// address of string to be displayed  
		);"

	<stdcall: void OutputDebugStringA lpstr>
	^self invalidCall: _failureCode!

removeDirectory: aStringFileName
	<stdcall: bool RemoveDirectoryA lpstr>
	^self invalidCall: _failureCode!

setCurrentDirectory: lpPathName
	<stdcall: bool SetCurrentDirectoryA lpstr>
	^self invalidCall: _failureCode!

setEnvironmentVariable: lpName lpValue: lpValue
	"Sets the value of an environment variable for the current process. Answer whether the
	request was successful.
		BOOL SetEnvironmentVariable(
			LPCSTR lpName,	// address of environment variable name  
  			LPCSTR lpValue 	// address of new value for variable 
		);"

	<stdcall: bool SetEnvironmentVariableA lpstr lpstr>
	^self invalidCall: _failureCode!

setFileAttributes: aFileName value: attributes
	"Set the attributes for the specified file or directory. 
		BOOL SetFileAttributes(
			LPCSTR lpFileName,		// file name
			DWORD dwFileAttributes		// attributes );"

	<stdcall: bool SetFileAttributesA lpstr dword>
	^self invalidCall: _failureCode!

setVolumeLabel: lpRootPathName lpVolumeName: lpVolumeName
	"Set the label of a a file system volume. Answer whether the operation succeeded.
		BOOL SetVolumeLabel( 
			LPCSTR lpRootPathName,
			LPCSTR lpVolumeName
		);"

	<stdcall: bool SetVolumeLabelA lpstr lpstr>
	^self invalidCall: _failureCode!

stringBufferClass
	^Utf8String! !
!OS.KernelLibraryUtf8 categoriesForMethods!
addAtom:!public!win32 functions-atom! !
beginUpdateResource:bDeleteExistingResources:!public!win32 functions-resource! !
compareString:dwCmpFlags:lpString1:cchCount1:lpString2:cchCount2:!public!win32 functions-national language support! !
compareString:dwCmpFlags:string1:string2:!public!win32 functions-national language support! !
copyFile:lpNewFileName:bfailIfExists:!public!win32 functions-file management! !
copyFile:to:!public!win32 functions-file management! !
createDirectory:lpSecurityAttributes:!public!win32 functions-file management! !
createEvent:bManualReset:bInitialState:lpName:!**auto generated**!public!win32 functions-synchronization! !
createFile:dwDesiredAccess:dwSharedMode:lpSecurityAttributes:dwCreationDistribution:dwFlagsAndAttributes:hTemplateFile:!public!win32 functions-file management! !
createMutex:bInitialOwner:lpName:!**auto generated**!public!win32 functions-synchronization! !
deleteFile:!public!win32 functions-file management! !
endUpdateResource:fDiscard:!public!win32 functions-resource! !
enumDateFormats:locale:dwFlags:!public!win32 functions-national language support! !
enumSystemCodePages:dwFlags:!public!win32 functions-national language support! !
enumSystemLocales:dwFlags:!public!win32 functions-national language support! !
enumTimeFormats:locale:dwFlags:!public!win32 functions-national language support! !
enumUILanguages:dwFlags:lParam:!public!win32 functions-national language support! !
expandEnvironmentStrings:!public!win32 functions-process and thread! !
expandEnvironmentStrings:lpDst:nSize:!public!win32 functions-process and thread! !
getAtomName:lpBuffer:nSize:!public!win32 functions-atom! !
getComputerName:nSize:!public!win32 functions-system information! !
getCurrentDirectory:lpBuffer:!public!win32 functions-directory management! !
getDiskFreeSpace:lpSectorsPerCluster:lpBytesPerSector:lpNumberOfFreeClusters:lpTotalNumberOfClusters:!public!win32 functions-file management! !
getDiskFreeSpaceEx:lpFreeBytesAvailable:lpTotalNumberOfBytes:lpTotalNumberOfFreeBytes:!public!win32 functions-file system! !
getEnvironmentVariable:lpBuffer:nSize:!public!win32 functions-process and thread! !
getFileAttributes:!public!win32 functions-file management! !
getFinalPathNameByHandle:!public!win32 functions-file management! !
getFinalPathNameByHandle:lpszFilePath:cchFilePath:dwFlags:!public!win32 functions-file management! !
getModuleFileName:lpFilename:nSize:!public!win32 functions-dynamic link library! !
getModuleHandle:!public!win32 functions-dynamic link library! !
getShortPathName:lpszShortPath:cchBuffer:!public!win32 functions-file management! !
getSystemDirectory:uSize:!public!win32 functions-system information! !
getSystemWindowsDirectory:uSize:!public!win32 functions-system information! !
getTempFileName:lpPrefixString:uUnique:lpTempFileName:!public!win32 functions-file management! !
getTempPath:lpBuffer:!public!win32 functions-file management! !
getVolumeInformation:lpVolumeNameBuffer:nVolumeNameSize:lpVolumeSerialNumber:lpMaximumComponentLength:lpFileSystemFlags:lpFileSystemNameBuffer:nFileSystemNameSize:!**auto generated**!public!win32 functions-file system! !
moveFile:lpNewFileName:!public!win32 functions-file management! !
moveFileEx:lpNewFileName:dwFlags:!public!win32 functions-file management! !
outputDebugString:!public!win32 functions-debugging! !
removeDirectory:!public!win32 functions-file management! !
setCurrentDirectory:!public!win32 functions-directory management! !
setEnvironmentVariable:lpValue:!public!win32 functions-process and thread! !
setFileAttributes:value:!public! !
setVolumeLabel:lpVolumeName:!public!win32 functions-file system! !
stringBufferClass!constants!public! !
!

!OS.KernelLibraryUtf8 class methodsFor!

enumUILanguagesDescriptor
	^FunctionDescriptor returnType: 'bool' argumentTypes: 'lpstr uintptr'!

initialize
	enumNamesDescriptor := FunctionDescriptor returnType: 'bool' argumentTypes: 'lpstr'! !
!OS.KernelLibraryUtf8 class categoriesForMethods!
enumUILanguagesDescriptor!constants!private! !
initialize!class initialization!development!public! !
!

