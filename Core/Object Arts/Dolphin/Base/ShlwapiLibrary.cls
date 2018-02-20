"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #ShlwapiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ShlwapiLibrary guid: (GUID fromString: '{64674074-3a82-101b-8181-00aa003743d3}')!
ShlwapiLibrary comment: 'ShlwapiLibrary is the <ExternalLibrary> class to represent the Win32 "Shell Lightweight API Library", SHLWAPI.DLL.'!
!ShlwapiLibrary categoriesForClass!External-Libraries-Win32! !
!ShlwapiLibrary methodsFor!

pathCombine: szDest lpszDir: lpszDir lpszFile: lpszFile
	"Invoke the PathCombine() function of the module wrapped by the receiver.
	Helpstring: Concatenates two strings that represent properly formed paths into one path, as well as any relative path pieces

		LPCSTR __stdcall PathCombine(
			LPSTR szDest,
			LPCSTR lpszDir,
			LPCSTR lpszFile);"

	<stdcall: lpstr PathCombineA lpstr lpstr lpstr>
	^self invalidCall!

pathCommonPrefix: pszFile1 pszFile2: pszFile2 achPath: achPath
	"Invoke the PathCommonPrefix() function of the module wrapped by the receiver.
	Helpstring: Compares two paths to determine if they share a common prefix. A prefix is one of these types: 'C:', '.', '..', '..'. 

		int __stdcall PathCommonPrefix(
			LPCSTR pszFile1,
			LPCSTR pszFile2,
			LPSTR achPath);"

	<stdcall: sdword PathCommonPrefixA lpstr lpstr lpstr>
	^self invalidCall!

pathCompactPath: hdc pszPath: pszPath dx: dx
	"Invoke the PathCompactPath() function of the module wrapped by the receiver.
	Helpstring: Truncates a file path to fit within a given pixel width by replacing path components with ellipses

		BOOL __stdcall PathCompactPath(
			HDC HDC,
			LPSTR pszPath,
			UINT dx);"

	<stdcall: bool PathCompactPathA handle lpstr dword>
	^self invalidCall!

pathCompactPathEx: pszOut pszSrc: pszSrc cchMax: cchMax dwFlags: dwFlags
	"Invoke the PathCompactPathEx() function of the module wrapped by the receiver.
	Helpstring: Truncates a path to fit within a certain number of characters by replacing path components with ellipses

		BOOL __stdcall PathCompactPathEx(
			LPSTR pszOut,
			LPCSTR pszSrc,
			UINT cchMax,
			DWORD dwFlags);"

	<stdcall: bool PathCompactPathExA lpstr lpstr dword dword>
	^self invalidCall!

pathFindNextComponent: pszPath
	"Invoke the PathFindNextComponent() function of the module wrapped by the receiver.
	Helpstring: Parses a path for the next path component. Paths are delimited by backslashes or by the NULL at the end of the path

		LPCSTR __stdcall PathFindNextComponent(
			LPCSTR pszPath);"

	<stdcall: lpstr PathFindNextComponentA lpstr>
	^self invalidCall!

pathIsRelative: pszPath
	"Invoke the PathIsRelative() function of the module wrapped by the receiver.
	Helpstring: Searches a path and determines if it is relative

		BOOL __stdcall PathIsRelative(
			LPCSTR pszPath);"

	<stdcall: bool PathIsRelativeA lpstr>
	^self invalidCall!

pathIsRoot: pszPath
	"Invoke the PathIsRoot() function of the module wrapped by the receiver.
	Helpstring: Parses a path to determine if a root directory path part exists

		BOOL __stdcall PathIsRoot(
			LPCSTR pszPath);"

	<stdcall: bool PathIsRootA lpstr>
	^self invalidCall!

pathIsURL: pszPath
	"Invoke the PathIsURL() function of the module wrapped by the receiver.
	Helpstring: Tests a given string to determine if it conforms to the URL format. This function does not verify that the path points to an existing site only that it is a legal URL format

		BOOL __stdcall PathIsURL(
			LPCSTR pszPath);"

	<stdcall: bool PathIsURLA lpstr>
	^self invalidCall!

pathParseIconLocation: pszIconFile
	"Invoke the PathParseIconLocation() function of the module wrapped by the receiver.
	Helpstring: Parses a file location string for its file component and icon index

		int __stdcall PathParseIconLocation(
			LPSTR pszIconFile);"

	<stdcall: sdword PathParseIconLocationA lpstr>
	^self invalidCall!

pathRelativePathTo: pszPath pszFrom: pszFrom dwAttrFrom: dwAttrFrom pszTo: pszTo dwAttrTo: dwAttrTo
	"Invoke the PathRelativePathTo() function of the module wrapped by the receiver.
	Helpstring: Creates a relative path from two paths

		BOOL __stdcall PathRelativePathTo(
			LPSTR pszPath,
			LPCSTR pszFrom,
			DWORD dwAttrFrom,
			LPCSTR pszTo,
			DWORD dwAttrTo);"

	<stdcall: bool PathRelativePathToA lpstr lpstr dword lpstr dword>
	^self invalidCall!

pathSetDlgItemPath: hDlg id: id pszPath: pszPath
	"Invoke the PathSetDlgItemPath() function of the module wrapped by the receiver.
	Helpstring: Sets the text of a child control in a window or dialog box, using PathCompactPath to make sure the path fits in the control

		void __stdcall PathSetDlgItemPath(
			HWND hDlg,
			int id,
			LPCSTR pszPath);"

	<stdcall: void PathSetDlgItemPathW handle sdword lpwstr>
	^self invalidCall!

shMessageBoxCheck: hwnd pszText: pszText pszTitle: pszTitle uType: uType iDefault: iDefault pszRegVal: pszRegVal
	"Invoke the SHMessageBoxCheck() function of the module wrapped by the receiver.
	Helpstring: Displays a message box that gives the user the option of suppressing further occurrences

		int __stdcall SHMessageBoxCheck(
			[in]HWND HWND,
			[in]LPCSTR pszText,
			[in]LPCSTR pszTitle,
			[in]UINT uType,
			[in]int iDefault,
			[in]LPCSTR pszRegVal);"

	<stdcall: sdword 185 handle lpstr lpstr dword sdword lpstr>
	^self invalidCall! !
!ShlwapiLibrary categoriesFor: #pathCombine:lpszDir:lpszFile:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathCommonPrefix:pszFile2:achPath:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathCompactPath:pszPath:dx:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathCompactPathEx:pszSrc:cchMax:dwFlags:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathFindNextComponent:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathIsRelative:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathIsRoot:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathIsURL:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathParseIconLocation:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathRelativePathTo:pszFrom:dwAttrFrom:pszTo:dwAttrTo:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #pathSetDlgItemPath:id:pszPath:!**auto generated**!public! !
!ShlwapiLibrary categoriesFor: #shMessageBoxCheck:pszText:pszTitle:uType:iDefault:pszRegVal:!**auto generated**!public! !

!ShlwapiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'SHLWAPI'! !
!ShlwapiLibrary class categoriesFor: #fileName!constants!public! !

