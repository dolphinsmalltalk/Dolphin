"Filed out from Dolphin Smalltalk"!

ExternalLibrary subclass: #ShlwapiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ShlwapiLibrary guid: (GUID fromString: '{64674074-3a82-101b-8181-00aa003743d3}')!

ShlwapiLibrary comment: 'ShlwapiLibrary is the <ExternalLibrary> class to represent the Win32 "Shell Lightweight API Library", SHLWAPI.DLL.'!

!ShlwapiLibrary categoriesForClass!External-Libraries-Win32! !

!ShlwapiLibrary methodsFor!

pathCommonPrefix: pszFile1 pszFile2: pszFile2 achPath: achPath
	"Invoke the PathCommonPrefix() function of the module wrapped by the receiver.
	Helpstring: Compares two paths to determine if they share a common prefix. A prefix is one of these types: 'C:', '.', '..', '..'. 

		int __stdcall PathCommonPrefix(
			LPCWSTR pszFile1,
			LPCWSTR pszFile2,
			LPCWSTR achPath);"

	<stdcall: sdword PathCommonPrefixW lpwstr lpwstr lpwstr>
	^self invalidCall: _failureCode!

pathIsURL: pszPath
	"Invoke the PathIsURL() function of the module wrapped by the receiver.
	Helpstring: Tests a given string to determine if it conforms to the URL format. This function does not verify that the path points to an existing site only that it is a legal URL format

		BOOL __stdcall PathIsURL(
			LPCWSTR pszPath);"

	<stdcall: bool PathIsURLW lpwstr>
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

!ShlwapiLibrary categoriesForMethods!
pathCommonPrefix:pszFile2:achPath:!**auto generated**!public! !
pathIsURL:!**auto generated**!public! !
pathRelativePathTo:pszFrom:dwAttrFrom:pszTo:dwAttrTo:!**auto generated**!public! !
pathSetDlgItemPath:id:pszPath:!**auto generated**!public! !
!

!ShlwapiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'SHLWAPI'! !

!ShlwapiLibrary class categoriesForMethods!
fileName!constants!public! !
!

