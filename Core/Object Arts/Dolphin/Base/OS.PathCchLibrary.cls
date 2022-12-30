"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary subclass: #'OS.PathCchLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'PATHCCH_MAX_CCH' -> 16r8000
	}!
OS.PathCchLibrary guid: (Core.GUID fromString: '{fef67ac9-c054-4034-859d-92ec9eae8407}')!
OS.PathCchLibrary comment: 'PathCchLibrary is the `DynamicLinkLibrary` class to represent the dynamic link library, ''api-ms-win-core-path-l1-1-0.dll''. It was generated from type information in the ''Win32 API'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"Windows Core Path API"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.
'!
!OS.PathCchLibrary categoriesForClass!Win32-Modules! !
!OS.PathCchLibrary methodsFor!

pathAllocCanonicalize: pszPathIn dwFlags: dwFlags ppszPathOut: ppszPathOut
	"Invoke the PathAllocCanonicalize() function of the module wrapped by the receiver.
	Helpstring: Converts a path string into a canonical form.

		HRESULT __stdcall PathAllocCanonicalize(
			LPCWSTR pszPathIn,
			ULONG dwFlags,
			LPWSTR* ppszPathOut);"

	<stdcall: hresult PathAllocCanonicalize lpwstr dword lpwstr*>
	^self invalidCall: _failureCode!

pathAllocCombine: pszPathIn pszMore: pszMore dwFlags: dwFlags ppszPathOut: ppszPathOut
	"Invoke the PathAllocCombine() function of the module wrapped by the receiver.
	Helpstring: Concatenates two path fragments into a single path. This function also canonicalizes any relative path elements, replacing path elements such as '.' and '..'.

		HRESULT __stdcall PathAllocCombine(
			LPCWSTR pszPathIn,
			LPCWSTR pszMore,
			ULONG dwFlags,
			LPWSTR* ppszPathOut);"

	<stdcall: hresult PathAllocCombine lpwstr lpwstr dword lpwstr*>
	^self invalidCall: _failureCode!

pathCanonicalize: pszPathIn dwFlags: dwFlags
	| pszPathOut result |
	pszPathOut := External.Address new.
	self
		pathAllocCanonicalize: pszPathIn
		dwFlags: dwFlags
		ppszPathOut: pszPathOut.
	result := Utf16String fromAddress: pszPathOut.
	Kernel32 localFree: pszPathOut.
	^result!

pathCchAddBackslash: pszPath cchPath: cchPath
	"Invoke the PathCchAddBackslash() function of the module wrapped by the receiver.
	Helpstring: Adds a backslash to the end of a string to create the correct syntax for a path. If the source path already has a trailing backslash, no backslash will be added.

		HRESULT __stdcall PathCchAddBackslash(
			LPWSTR pszPath,
			ULONG_PTR cchPath);"

	<stdcall: hresult PathCchAddBackslash lpwstr uintptr>
	^self invalidCall: _failureCode!

pathCchAddBackslashEx: pszPath cchPath: cchPath ppszEnd: ppszEnd pcchRemaining: pcchRemaining
	"Invoke the PathCchAddBackslashEx() function of the module wrapped by the receiver.
	Helpstring: Adds a backslash to the end of a string to create the correct syntax for a path. If the source path already has a trailing backslash, no backslash will be added.

		HRESULT __stdcall PathCchAddBackslashEx(
			LPWSTR pszPath,
			ULONG_PTR cchPath,
			LPWSTR* ppszEnd,
			ULONG_PTR* pcchRemaining);"

	<stdcall: hresult PathCchAddBackslashEx lpwstr uintptr lpwstr* uintptr*>
	^self invalidCall: _failureCode!

pathCchAddExtension: pszPath cchPath: cchPath pszExt: pszExt
	"Invoke the PathCchAddExtension() function of the module wrapped by the receiver.
	Helpstring: Adds a file name extension to a path string.

		HRESULT __stdcall PathCchAddExtension(
			LPWSTR pszPath,
			ULONG_PTR cchPath,
			LPCWSTR pszExt);"

	<stdcall: hresult PathCchAddExtension lpwstr uintptr lpwstr>
	^self invalidCall: _failureCode!

pathCchAppend: pszPath cchPath: cchPath pszMore: pszMore
	"Invoke the PathCchAppend() function of the module wrapped by the receiver.
	Helpstring: Appends one path to the end of another.

		HRESULT __stdcall PathCchAppend(
			LPWSTR pszPath,
			ULONG_PTR cchPath,
			LPCWSTR pszMore);"

	<stdcall: hresult PathCchAppend lpwstr uintptr lpwstr>
	^self invalidCall: _failureCode!

pathCchAppendEx: pszPath cchPath: cchPath pszMore: pszMore dwFlags: dwFlags
	"Invoke the PathCchAppendEx() function of the module wrapped by the receiver.
	Helpstring: Appends one path to the end of another.

		HRESULT __stdcall PathCchAppendEx(
			LPWSTR pszPath,
			ULONG_PTR cchPath,
			LPCWSTR pszMore,
			ULONG dwFlags);"

	<stdcall: hresult PathCchAppendEx lpwstr uintptr lpwstr dword>
	^self invalidCall: _failureCode!

pathCchCanonicalize: pszPathOut cchPathOut: cchPathOut pszPathIn: pszPathIn
	"Invoke the PathCchCanonicalize() function of the module wrapped by the receiver.
	Helpstring: Simplifies a path by removing navigation elements such as '.' and '..' to produce a direct, well-formed path.

		HRESULT __stdcall PathCchCanonicalize(
			LPWSTR pszPathOut,
			ULONG_PTR cchPathOut,
			LPCWSTR pszPathIn);"

	<stdcall: hresult PathCchCanonicalize lpwstr uintptr lpwstr>
	^self invalidCall: _failureCode!

pathCchCanonicalizeEx: pszPathOut cchPathOut: cchPathOut pszPathIn: pszPathIn dwFlags: dwFlags
	"Invoke the PathCchCanonicalizeEx() function of the module wrapped by the receiver.
	Helpstring: Simplifies a path by removing navigation elements such as '.' and '..' to produce a direct, well-formed path.

		HRESULT __stdcall PathCchCanonicalizeEx(
			LPWSTR pszPathOut,
			ULONG_PTR cchPathOut,
			LPCWSTR pszPathIn,
			ULONG dwFlags);"

	<stdcall: hresult PathCchCanonicalizeEx lpwstr uintptr lpwstr dword>
	^self invalidCall: _failureCode!

pathCchCombine: pszPathOut cchPathOut: cchPathOut pszPathIn: pszPathIn pszMore: pszMore
	"Invoke the PathCchCombine() function of the module wrapped by the receiver.
	Helpstring: Combines two path fragments into a single path. This function also canonicalizes any relative path elements, removing '.' and '..' elements to simplify the final path.

		HRESULT __stdcall PathCchCombine(
			LPWSTR pszPathOut,
			ULONG_PTR cchPathOut,
			LPCWSTR pszPathIn,
			LPCWSTR pszMore);"

	<stdcall: hresult PathCchCombine lpwstr uintptr lpwstr lpwstr>
	^self invalidCall: _failureCode!

pathCchCombineEx: pszPathOut cchPathOut: cchPathOut pszPathIn: pszPathIn pszMore: pszMore dwFlags: dwFlags
	"Invoke the PathCchCombineEx() function of the module wrapped by the receiver.
	Helpstring: Combines two path fragments into a single path. This function also canonicalizes any relative path elements, removing '.' and '..' elements to simplify the final path.

		HRESULT __stdcall PathCchCombineEx(
			LPWSTR pszPathOut,
			ULONG_PTR cchPathOut,
			LPCWSTR pszPathIn,
			LPCWSTR pszMore,
			ULONG dwFlags);"

	<stdcall: hresult PathCchCombineEx lpwstr uintptr lpwstr lpwstr dword>
	^self invalidCall: _failureCode!

pathCchFindExtension: pszPath cchPath: cchPath ppszExt: ppszExt
	"Invoke the PathCchFindExtension() function of the module wrapped by the receiver.
	Helpstring: Searches a path to find its file name extension, such as '.exe' or '.ini'. This function does not search for a specific extension; it searches for the presence of any extension.

		HRESULT __stdcall PathCchFindExtension(
			LPCWSTR pszPath,
			ULONG_PTR cchPath,
			LPCWSTR* ppszExt);"

	<stdcall: hresult PathCchFindExtension lpwstr uintptr lpwstr*>
	^self invalidCall: _failureCode!

pathCchIsRoot: pszPath
	"Invoke the PathCchIsRoot() function of the module wrapped by the receiver.
	Helpstring: Determines whether a path string refers to the root of a volume.

		BOOL __stdcall PathCchIsRoot(
			LPCWSTR pszPath);"

	<stdcall: bool PathCchIsRoot lpwstr>
	^self invalidCall: _failureCode!

pathCchRemoveBackslash: pszPath cchPath: cchPath
	"Invoke the PathCchRemoveBackslash() function of the module wrapped by the receiver.
	Helpstring: Removes the trailing backslash from the end of a path string.

		HRESULT __stdcall PathCchRemoveBackslash(
			LPWSTR pszPath,
			ULONG_PTR cchPath);"

	<stdcall: hresult PathCchRemoveBackslash lpwstr uintptr>
	^self invalidCall: _failureCode!

pathCchRemoveBackslashEx: pszPath cchPath: cchPath ppszEnd: ppszEnd pcchRemaining: pcchRemaining
	"Invoke the PathCchRemoveBackslashEx() function of the module wrapped by the receiver.
	Helpstring: Removes the trailing backslash from the end of a path string.

		HRESULT __stdcall PathCchRemoveBackslashEx(
			LPWSTR pszPath,
			ULONG_PTR cchPath,
			LPWSTR* ppszEnd,
			ULONG_PTR* pcchRemaining);"

	<stdcall: hresult PathCchRemoveBackslashEx lpwstr uintptr lpwstr* uintptr*>
	^self invalidCall: _failureCode!

pathCchRemoveExtension: pszPath cchPath: cchPath
	"Invoke the PathCchRemoveExtension() function of the module wrapped by the receiver.
	Helpstring: Removes the file name extension from a path, if one is present.

		HRESULT __stdcall PathCchRemoveExtension(
			LPWSTR pszPath,
			ULONG_PTR cchPath);"

	<stdcall: hresult PathCchRemoveExtension lpwstr uintptr>
	^self invalidCall: _failureCode!

pathCchRemoveFileSpec: pszPath cchPath: cchPath
	"Invoke the PathCchRemoveFileSpec() function of the module wrapped by the receiver.
	Helpstring: Removes the last element in a path string, whether that element is a file name or a directory name. The element's leading backslash is also removed.

		HRESULT __stdcall PathCchRemoveFileSpec(
			LPWSTR pszPath,
			ULONG_PTR cchPath);"

	<stdcall: hresult PathCchRemoveFileSpec lpwstr uintptr>
	^self invalidCall: _failureCode!

pathCchRenameExtension: pszPath cchPath: cchPath pszExt: pszExt
	"Invoke the PathCchRenameExtension() function of the module wrapped by the receiver.
	Helpstring: Replaces a file name's extension at the end of a path string with a new extension. If the path string does not end with an extension, the new extension is added.

		HRESULT __stdcall PathCchRenameExtension(
			LPWSTR pszPath,
			ULONG_PTR cchPath,
			LPCWSTR pszExt);"

	<stdcall: hresult PathCchRenameExtension lpwstr uintptr lpwstr>
	^self invalidCall: _failureCode!

pathCchSkipRoot: pszPath ppszRootEnd: ppszRootEnd
	"Invoke the PathCchSkipRoot() function of the module wrapped by the receiver.
	Helpstring: Retrieves a pointer to the first character in a path following the drive letter or Universal Naming Convention (UNC) server/share path elements.

		HRESULT __stdcall PathCchSkipRoot(
			LPCWSTR pszPath,
			LPCWSTR* ppszRootEnd);"

	<stdcall: hresult PathCchSkipRoot lpwstr lpwstr*>
	^self invalidCall: _failureCode!

pathCchStripPrefix: pszPath cchPath: cchPath
	"Invoke the PathCchStripPrefix() function of the module wrapped by the receiver.
	Helpstring: Removes the '\?' prefix, if present, from a file path.

		HRESULT __stdcall PathCchStripPrefix(
			LPWSTR pszPath,
			ULONG_PTR cchPath);"

	<stdcall: hresult PathCchStripPrefix lpwstr uintptr>
	^self invalidCall: _failureCode!

pathCchStripToRoot: pszPath cchPath: cchPath
	"Invoke the PathCchStripToRoot() function of the module wrapped by the receiver.
	Helpstring: Removes all file and directory elements in a path except for the root information.

		HRESULT __stdcall PathCchStripToRoot(
			LPWSTR pszPath,
			ULONG_PTR cchPath);"

	<stdcall: hresult PathCchStripToRoot lpwstr uintptr>
	^self invalidCall: _failureCode!

pathCombine: pszPathIn pszMore: pszMore dwFlags: dwFlags
	| pszPathOut result |
	pszPathOut := External.Address new.
	self
		pathAllocCombine: pszPathIn
		pszMore: pszMore
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
pathAllocCanonicalize:dwFlags:ppszPathOut:!**auto generated**!public!win32 functions-path! !
pathAllocCombine:pszMore:dwFlags:ppszPathOut:!**auto generated**!public!win32 functions-path! !
pathCanonicalize:dwFlags:!public!win32 functions-path! !
pathCchAddBackslash:cchPath:!**auto generated**!public!win32 functions-path! !
pathCchAddBackslashEx:cchPath:ppszEnd:pcchRemaining:!**auto generated**!public!win32 functions-path! !
pathCchAddExtension:cchPath:pszExt:!**auto generated**!public!win32 functions-path! !
pathCchAppend:cchPath:pszMore:!**auto generated**!public!win32 functions-path! !
pathCchAppendEx:cchPath:pszMore:dwFlags:!**auto generated**!public!win32 functions-path! !
pathCchCanonicalize:cchPathOut:pszPathIn:!**auto generated**!public!win32 functions-path! !
pathCchCanonicalizeEx:cchPathOut:pszPathIn:dwFlags:!**auto generated**!public!win32 functions-path! !
pathCchCombine:cchPathOut:pszPathIn:pszMore:!**auto generated**!public!win32 functions-path! !
pathCchCombineEx:cchPathOut:pszPathIn:pszMore:dwFlags:!**auto generated**!public!win32 functions-path! !
pathCchFindExtension:cchPath:ppszExt:!**auto generated**!public!win32 functions-path! !
pathCchIsRoot:!**auto generated**!public!win32 functions-path! !
pathCchRemoveBackslash:cchPath:!**auto generated**!public!win32 functions-path! !
pathCchRemoveBackslashEx:cchPath:ppszEnd:pcchRemaining:!**auto generated**!public!win32 functions-path! !
pathCchRemoveExtension:cchPath:!**auto generated**!public!win32 functions-path! !
pathCchRemoveFileSpec:cchPath:!**auto generated**!public!win32 functions-path! !
pathCchRenameExtension:cchPath:pszExt:!**auto generated**!public!win32 functions-path! !
pathCchSkipRoot:ppszRootEnd:!**auto generated**!public!win32 functions-path! !
pathCchStripPrefix:cchPath:!**auto generated**!public!win32 functions-path! !
pathCchStripToRoot:cchPath:!**auto generated**!public!win32 functions-path! !
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

