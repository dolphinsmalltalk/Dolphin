"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.PathCchLibrary'
	instanceVariableNames: 'longPathAware'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'PATHCCH_ALLOW_LONG_PATHS' -> 16r1.
			'PATHCCH_CANONICALIZE_SLASHES' -> 16r40.
			'PATHCCH_DO_NOT_NORMALIZE_SEGMENTS' -> 16r8.
			'PATHCCH_ENSURE_IS_EXTENDED_LENGTH_PATH' -> 16r10.
			'PATHCCH_ENSURE_TRAILING_SLASH' -> 16r20.
			'PATHCCH_FORCE_DISABLE_LONG_NAME_PROCESS' -> 16r4.
			'PATHCCH_FORCE_ENABLE_LONG_NAME_PROCESS' -> 16r2.
			'PATHCCH_MAX_CCH' -> 16r8000.
			'PATHCCH_NONE' -> 16r0
		}!

OS.PathCchLibrary guid: (Core.GUID fromString: '{fef67ac9-c054-4034-859d-92ec9eae8407}')!

OS.PathCchLibrary comment: 'PathCchLibrary is the `DynamicLinkLibrary` class to represent the dynamic link library, ''api-ms-win-core-path-l1-1-0.dll''. It was generated from type information in the ''Win32 API'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"Windows Core Path API"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.
'!

!OS.PathCchLibrary categoriesForClass!Win32-Modules! !

!OS.PathCchLibrary methodsFor!

isLongPathAware
	"Answer whether the process is long path aware (i.e. long paths do not require the \\?\ prefix). For this to be true long paths must be enabled in the host OS, and the process must be marked as long path aware in its application manifest. All supported Windows versions do support long paths without the prefix, and for Windows 11 this is enabled by default. This is controlled by the `HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled` registry value. The standard Dolphin application manifest does include `<longPathAware>true</longPathAware>` to declare the process as long path enabled, but an application developer has the option to remove this. There is no dedicated API to test whether both OS and process configuration is set so as to enable long paths, but we can test for this reliably and without side effect by using the PathCanonicalize API, as this will insert a long path prefix when long paths are not enabled at either a process or OS level."

	^longPathAware
		ifNil: 
			[longPathAware := ((self
						pathCanonicalize: 'c:\aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.tst'
						dwFlags: PATHCCH_ALLOW_LONG_PATHS) beginsWith: LongPathPrefix)
						not]!

pathAllocCanonicalize: pszPathIn dwFlags: dwFlags ppszPathOut: ppszPathOut
	"Private - Invoke the PathAllocCanonicalize() function of the module wrapped by the receiver.
	Helpstring: Converts a path string into a canonical form.

		HRESULT __stdcall PathAllocCanonicalize(
			LPCWSTR pszPathIn,
			ULONG dwFlags,
			LPWSTR* ppszPathOut);"

	<stdcall: hresult PathAllocCanonicalize lpwstr uint32 lpwstr*>
	^self invalidCall: _failureCode!

pathAllocCombine: pszPathIn pszMore: pszMore dwFlags: dwFlags ppszPathOut: ppszPathOut
	"Private - Invoke the PathAllocCombine() function of the module wrapped by the receiver.
	Helpstring: Concatenates two path fragments into a single path. This function also canonicalizes any relative path elements, replacing path elements such as '.' and '..'.

		HRESULT __stdcall PathAllocCombine(
			LPCWSTR pszPathIn,
			LPCWSTR pszMore,
			ULONG dwFlags,
			LPWSTR* ppszPathOut);"

	<stdcall: hresult PathAllocCombine lpwstr lpwstr uint32 lpwstr*>
	^self invalidCall: _failureCode!

pathCanonicalize: pszPathIn dwFlags: dwFlags
	| pszPathOut result |
	pszPathOut := Address new.
	self
		pathAllocCanonicalize: pszPathIn
		dwFlags: dwFlags
		ppszPathOut: pszPathOut.
	result := Utf16String fromAddress: pszPathOut.
	Kernel32 localFree: pszPathOut.
	^result!

pathCchIsRoot: pszPath
	"Invoke the PathCchIsRoot() function of the module wrapped by the receiver.
	Helpstring: Determines whether a path string refers to the root of a volume.

		BOOL __stdcall PathCchIsRoot(
			LPCWSTR pszPath);"

	<stdcall: bool PathCchIsRoot lpwstr>
	^self invalidCall: _failureCode!

pathCombine: pszPathIn pszMore: pszMore dwFlags: dwFlags
	| pszPathOut result |
	pszPathOut := Address new.
	self
		pathAllocCombine: pszPathIn asUtf16String
		pszMore: pszMore asUtf16String
		dwFlags: dwFlags
		ppszPathOut: pszPathOut.
	result := Utf16String fromAddress: pszPathOut.
	Kernel32 localFree: pszPathOut.
	^result!

pathIsUNCEx: pszPath ppszServer: ppszServer
	"Invoke the PathIsUNCEx() function of the module wrapped by the receiver.
	Helpstring: Determines if a path string is a valid Universal Naming Convention (UNC) path, as opposed to a path based on a drive letter.

		BOOL __stdcall PathIsUNCEx(
			LPCWSTR pszPath,
			LPCWSTR* ppszServer);"

	<stdcall: bool PathIsUNCEx lpwstr lpwstr*>
	^self invalidCall: _failureCode! !

!OS.PathCchLibrary categoriesForMethods!
isLongPathAware!public!testing! !
pathAllocCanonicalize:dwFlags:ppszPathOut:!**auto generated**!private!win32 functions-path! !
pathAllocCombine:pszMore:dwFlags:ppszPathOut:!**auto generated**!private!win32 functions-path! !
pathCanonicalize:dwFlags:!public!win32 functions-path! !
pathCchIsRoot:!**auto generated**!public!win32 functions-path! !
pathCombine:pszMore:dwFlags:!public!win32 functions-path! !
pathIsUNCEx:ppszServer:!**auto generated**!public!win32 functions-path! !
!

!OS.PathCchLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'api-ms-win-core-path-l1-1-0'!

sharedVariableName
	^#{OS.PathCch}! !

!OS.PathCchLibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

