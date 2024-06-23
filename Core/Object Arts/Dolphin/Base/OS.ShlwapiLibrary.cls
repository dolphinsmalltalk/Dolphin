"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.ShlwapiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.ShlwapiLibrary guid: (Core.GUID fromString: '{64674074-3a82-101b-8181-00aa003743d3}')!

OS.ShlwapiLibrary comment: 'ShlwapiLibrary is the <ExternalLibrary> class to represent the Win32 "Shell Lightweight API Library", SHLWAPI.DLL.'!

!OS.ShlwapiLibrary categoriesForClass!External-Libraries-Win32! !

!OS.ShlwapiLibrary methodsFor!

pathCommonPrefix: pszFile1 pszFile2: pszFile2 achPath: achPath
	"Invoke the PathCommonPrefix() function of the module wrapped by the receiver.
	Helpstring: Compares two paths to determine if they share a common prefix. A prefix is one of these types: 'C:', '.', '..', '..'. 

		int __stdcall PathCommonPrefix(
			LPCWSTR pszFile1,
			LPCWSTR pszFile2,
			LPCWSTR achPath);"

	<stdcall: int32 PathCommonPrefixW lpwstr lpwstr lpwstr>
	^self invalidCall: _failureCode!

pathCompactPathEx: pszOut pszSrc: pszSrc cchMax: cchMax dwFlags: dwFlags
	"Invoke the PathCompactPathEx() function of the module wrapped by the receiver.
	Helpstring: Truncates a path to fit within a certain number of characters by replacing path components with ellipses

		BOOL __stdcall PathCompactPathEx(
			LPWSTR pszOut,
			LPCWSTR pszSrc,
			UINT cchMax,
			DWORD dwFlags);"

	<stdcall: bool PathCompactPathExW lpwstr lpwstr uint32 uint32>
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

	<stdcall: bool PathRelativePathToW lpwstr lpwstr uint32 lpwstr uint32>
	^self invalidCall: _failureCode! !

!OS.ShlwapiLibrary categoriesForMethods!
pathCommonPrefix:pszFile2:achPath:!public!win32 functions-path! !
pathCompactPathEx:pszSrc:cchMax:dwFlags:!public!win32 functions-path! !
pathIsURL:!public!win32 functions-path! !
pathRelativePathTo:pszFrom:dwAttrFrom:pszTo:dwAttrTo:!public!win32 functions-path! !
!

!OS.ShlwapiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'SHLWAPI'!

sharedVariableName
	^#{OS.Shlwapi}! !

!OS.ShlwapiLibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

