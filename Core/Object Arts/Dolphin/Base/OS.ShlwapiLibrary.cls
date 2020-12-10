"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.ShlwapiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.ShlwapiLibrary guid: (Core.GUID fromString: '{64674074-3a82-101b-8181-00aa003743d3}')!
OS.ShlwapiLibrary comment: 'ShlwapiLibrary is the <ExternalLibrary> class to represent the Win32 "Shell Lightweight API Library", SHLWAPI.DLL.'!
!OS.ShlwapiLibrary categoriesForClass!External-Libraries-Win32! !
!OS.ShlwapiLibrary methodsFor!

pathCombine: szDest lpszDir: lpszDir lpszFile: lpszFile
	"Invoke the PathCombine() function of the module wrapped by the receiver.
	Helpstring: Concatenates two strings that represent properly formed paths into one path, as well as any relative path pieces

		LPCWSTR __stdcall PathCombine(
			LPWSTR szDest,
			LPCWSTR lpszDir,
			LPCWSTR lpszFile);"

	<stdcall: lpwstr PathCombineW lpwstr lpwstr lpwstr>
	^self invalidCall: _failureCode!

pathCommonPrefix: pszFile1 pszFile2: pszFile2 achPath: achPath
	"Invoke the PathCommonPrefix() function of the module wrapped by the receiver.
	Helpstring: Compares two paths to determine if they share a common prefix. A prefix is one of these types: 'C:', '.', '..', '..'. 

		int __stdcall PathCommonPrefix(
			LPCWSTR pszFile1,
			LPCWSTR pszFile2,
			LPCWSTR achPath);"

	<stdcall: sdword PathCommonPrefixW lpwstr lpwstr lpwstr>
	^self invalidCall: _failureCode!

pathCompactPath: hdc pszPath: pszPath dx: dx
	"Invoke the PathCompactPath() function of the module wrapped by the receiver.
	Helpstring: Truncates a file path to fit within a given pixel width by replacing path components with ellipses

		BOOL __stdcall PathCompactPath(
			HDC HDC,
			LPWSTR pszPath,
			UINT dx);"

	<stdcall: bool PathCompactPathW handle lpwstr dword>
	^self invalidCall: _failureCode!

pathCompactPathEx: pszOut pszSrc: pszSrc cchMax: cchMax dwFlags: dwFlags
	"Invoke the PathCompactPathEx() function of the module wrapped by the receiver.
	Helpstring: Truncates a path to fit within a certain number of characters by replacing path components with ellipses

		BOOL __stdcall PathCompactPathEx(
			LPWSTR pszOut,
			LPCWSTR pszSrc,
			UINT cchMax,
			DWORD dwFlags);"

	<stdcall: bool PathCompactPathExW lpwstr lpwstr dword dword>
	^self invalidCall: _failureCode!

pathFindNextComponent: pszPath
	"Invoke the PathFindNextComponent() function of the module wrapped by the receiver.
	Helpstring: Parses a path for the next path component. Paths are delimited by backslashes or by the NULL at the end of the path

		LPCWSTR __stdcall PathFindNextComponent(
			LPCWSTR pszPath);"

	<stdcall: lpwstr PathFindNextComponentW lpwstr>
	^self invalidCall: _failureCode!

pathIsRelative: pszPath
	"Invoke the PathIsRelative() function of the module wrapped by the receiver.
	Helpstring: Searches a path and determines if it is relative

		BOOL __stdcall PathIsRelative(
			LPCWSTR pszPath);"

	<stdcall: bool PathIsRelativeW lpwstr>
	^self invalidCall: _failureCode!

pathIsRoot: pszPath
	"Invoke the PathIsRoot() function of the module wrapped by the receiver.
	Helpstring: Parses a path to determine if a root directory path part exists

		BOOL __stdcall PathIsRoot(
			LPCWSTR pszPath);"

	<stdcall: bool PathIsRootW lpwstr>
	^self invalidCall: _failureCode!

pathIsURL: pszPath
	"Invoke the PathIsURL() function of the module wrapped by the receiver.
	Helpstring: Tests a given string to determine if it conforms to the URL format. This function does not verify that the path points to an existing site only that it is a legal URL format

		BOOL __stdcall PathIsURL(
			LPCWSTR pszPath);"

	<stdcall: bool PathIsURLW lpwstr>
	^self invalidCall: _failureCode!

pathParseIconLocation: pszIconFile
	"Invoke the PathParseIconLocation() function of the module wrapped by the receiver.
	Helpstring: Parses a file location string for its file component and icon index

		int __stdcall PathParseIconLocation(
			LPWSTR pszIconFile);"

	<stdcall: sdword PathParseIconLocationW lpwstr>
	^self invalidCall: _failureCode!

pathRelativePathTo: pszPath pszFrom: pszFrom dwAttrFrom: dwAttrFrom pszTo: pszTo dwAttrTo: dwAttrTo
	"Invoke the PathRelativePathTo() function of the module wrapped by the receiver.
	Helpstring: Creates a relative path from two paths

		BOOL __stdcall PathRelativePathTo(
			LPWSTR pszPath,
			LPCWSTR pszFrom,
			DWORD dwAttrFrom,
			LPCWSTR pszTo,
			DWORD dwAttrTo);"

	<stdcall: bool PathRelativePathToW lpwstr lpwstr dword lpwstr dword>
	^self invalidCall: _failureCode!

pathSetDlgItemPath: hDlg id: id pszPath: pszPath
	"Invoke the PathSetDlgItemPath() function of the module wrapped by the receiver.
	Helpstring: Sets the text of a child control in a window or dialog box, using PathCompactPath to make sure the path fits in the control

		void __stdcall PathSetDlgItemPath(
			HWND hDlg,
			int id,
			LPCSTR pszPath);"

	<stdcall: void PathSetDlgItemPathW handle sdword lpwstr>
	^self invalidCall: _failureCode! !
!OS.ShlwapiLibrary categoriesFor: #pathCombine:lpszDir:lpszFile:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathCommonPrefix:pszFile2:achPath:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathCompactPath:pszPath:dx:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathCompactPathEx:pszSrc:cchMax:dwFlags:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathFindNextComponent:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathIsRelative:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathIsRoot:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathIsURL:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathParseIconLocation:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathRelativePathTo:pszFrom:dwAttrFrom:pszTo:dwAttrTo:!**auto generated**!public! !
!OS.ShlwapiLibrary categoriesFor: #pathSetDlgItemPath:id:pszPath:!**auto generated**!public! !

!OS.ShlwapiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'SHLWAPI'! !
!OS.ShlwapiLibrary class categoriesFor: #fileName!constants!public! !

