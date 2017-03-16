"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #ShellLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ShellConstants Win32Constants'
	classInstanceVariableNames: ''!
ShellLibrary guid: (GUID fromString: '{64674052-3a82-101b-8181-00aa003743d3}')!
ShellLibrary comment: 'ShellLibrary is the <ExternalLibrary> class to represent the Win32 system library, Shell32.DLL'!
!ShellLibrary categoriesForClass!External-Libraries-Win32! !
!ShellLibrary methodsFor!

allocator
	"Answer the shell's <IMalloc>."

	| answer |
	answer := IMalloc newPointer.
	self SHGetMalloc: answer.
	^answer!

dragAcceptFiles: hwnd fAccept: fAccept
	"Invoke the DragAcceptFiles() function of the module wrapped by the receiver.
	Helpstring: Registers whether a window accepts dropped files

		void __stdcall DragAcceptFiles(
			HWND HWND,
			BOOL fAccept);"

	<stdcall: void DragAcceptFiles handle bool>
	^self invalidCall!

dragFinish: hDrop
	"Invoke the DragFinish() function of the module wrapped by the receiver.
	Helpstring: Releases memory that the system allocated for use in transferring file names to the application

		void __stdcall DragFinish(
			hDrop hDrop);"

	<stdcall: void DragFinish handle>
	^self invalidCall!

dragQueryFile: hDrop iFile: iFile lpszFile: lpszFile cch: cch
	"Invoke the DragQueryFile() function of the module wrapped by the receiver.
	Helpstring: Retrieves the names of dropped files that result from a successful drag-and-drop operation

		UINT __stdcall DragQueryFile(
			hDrop hDrop,
			UINT iFile,
			LPSTR lpszFile,
			UINT cch);"

	<stdcall: dword DragQueryFileA handle dword lpstr dword>
	^self invalidCall!

dragQueryPoint: hDrop lppt: lppt
	"Invoke the DragQueryPoint() function of the module wrapped by the receiver.
	Helpstring: Retrieves the position of the mouse pointer at the time a file was dropped during a drag-and-drop operation

		BOOL __stdcall DragQueryPoint(
			hDrop hDrop,
			POINTL* lppt);"

	<stdcall: bool DragQueryPoint handle POINTL*>
	^self invalidCall!

extractAssociatedIcon: hInst lpIconPath: lpIconPath lpiIcon: lpiIcon
	"Invoke the ExtractAssociatedIcon() function of the module wrapped by the receiver.
	Helpstring: Returns handle of indexed icon found in a file or in an associated executable file

		HICON __stdcall ExtractAssociatedIcon(
			HINSTANCE hInst,
			LPSTR lpIconPath,
			WORD* lpiIcon);"

	<stdcall: handle ExtractAssociatedIconA handle lpstr word*>
	^self invalidCall!

findExecutable: pathName
	"Retrieves the name of the executable associated with the specified path."

	^self findExecutable: pathName directory: nil!

findExecutable: lpFile directory: directoryString
	"Retrieves the name of the executable associated with the specified path."

	| buf hInst |
	buf := File pathBuffer.
	hInst := self findExecutable: lpFile lpDirectory: directoryString lpResult: buf.
	^hInst asInteger <= 32
		ifTrue: [ "FindExecutable() error reporting not consistent with normal Win32 mechanism"
			hInst asInteger == 31
				ifTrue: [Win32Error signalWith: 16r483]
				ifFalse: [self systemError]]
		ifFalse: [buf trimNulls]!

findExecutable: lpFile lpDirectory: directoryStringIn lpResult: buf
	"Retrieves the name and handle of the executable associated with the specified filename.

		HINSTANCE FindExecutable(
			LPCTSTR lpFile,		// filename string [in]
			LPCTSTR lpDirectory,	// default directory string [in]
			LPTSTR lpResult 		// buffer for executable file name [out]
		);"

	<stdcall: handle FindExecutableA lpstr lpstr lpstr>
	^self invalidCall
!

getDesktopFolder
	"Answer an <IShellFolder> on the desktop (top-level) folder.

		sh := ShellLibrary default getDesktopFolder.
	"

	| answer |
	answer := IShellFolder newPointer.
	self SHGetDesktopFolder: answer.
	^answer
!

getSpecialFolderLocation: anInteger 
	"
	self default getSpecialFolderLocation: CSIDL_PERSONAL
	"

	| pszPath |
	pszPath := File pathBuffer.
	self 
		shGetFolderPath: nil
		nFolder: anInteger
		hToken: nil
		dwFlags: SHGFP_TYPE_CURRENT
		pszPath: pszPath.
	^pszPath trimNulls!

isUserAnAdmin
	"Invoke the IsUserAnAdmin() function of the module wrapped by the receiver.
	Helpstring: Tests whether the current user is a member of the Administrator's group

		BOOL __stdcall IsUserAnAdmin();"

	<stdcall: bool IsUserAnAdmin>
	^self invalidCall!

pathFromIDList: idList 
	| pathname |
	pathname := File pathBuffer.
	^(self SHGetPathFromIDList: idList pszPath: pathname) ifTrue: [pathname trimNulls]!

SHBrowseForFolder: aWin32BROWSEINFO

	<stdcall: handle SHBrowseForFolderA lpvoid>
	^self invalidCall!

SHChangeNotify: wEventId uFlags: unit dwItem1: aLPCVOID1 dwItem2: aLPCVOID2
	"Notify the system of an event that an application has performed that may affect the Shell.
		wEventId, a Windows SHCNE constant that specifies the event.
		uFlags, a WIndows SHCNF constant that specifies what type of objects dwItem1 and dwItem2 are.
		dwItem1 and dwItem2, objects involved in the change."

	<stdcall: void SHChangeNotify dword dword lpvoid lpvoid>
	^self invalidCall!

shellExecute: hwnd lpOperation: opString lpFile: fileString lpParameters: parmString lpDirectory: dirString nShowCmd: anInteger
	"Opens or prints the specified file, which can be an executable or document file.
		HINSTANCE ShellExecute(
	  		HWND hwnd,			// handle to parent window
			LPCTSTR lpOperation,	// pointer to string that specifies operation to perform
			LPCTSTR lpFile,		// pointer to filename or folder name string
			LPCTSTR lpParameters,	// pointer to string that specifies executable-file parameters 
			LPCTSTR lpDirectory,	// pointer to string that specifies default directory
			INT nShowCmd 			// whether file is shown when opened
		);"

	<stdcall: handle ShellExecuteA handle lpstr lpstr lpstr lpstr sdword>
	^self invalidCall!

shellOpen: fileString
	"Opens the specified file, which can be an executable or document file.
	Simplified wrapper around ShellExecute() to open a document."

	^self shellOpen: fileString directory: nil!

shellOpen: fileString directory: dirString 
	"Opens the specified file, which can be an executable or document file.
	Simplified wrapper around ShellExecute() to open a document."

	^self 
		shellOpen: fileString
		directory: dirString
		parameters: nil!

shellOpen: fileString directory: dirString parameters: paramString 
	"Opens the specified file, which can be an executable or document file, in the specified
	directory, with the specified parameters. The directory string and parameter string can be
	nil, in which case they are treated as unspecified. "

	| hInst |
	hInst := self 
				shellExecute: nil
				lpOperation: 'open'
				lpFile: fileString
				lpParameters: paramString
				lpDirectory: dirString
				nShowCmd: SW_SHOWNORMAL.
	^hInst asInteger <= 32 ifTrue: [self systemError] ifFalse: [hInst]!

SHGetDesktopFolder: ppshf

	<stdcall: hresult SHGetDesktopFolder IShellFolder**>
	^self invalidCall!

shGetFolderPath: hwndOwner nFolder: nFolder hToken: hToken dwFlags: dwFlags pszPath: pszPath
	"Invoke the SHGetFolderPath() function of the module wrapped by the receiver.
	Helpstring: Takes the CSIDL of a folder and returns the path

		HRESULT __stdcall SHGetFolderPath(
			HWND hwndOwner,
			int nFolder,
			HANDLE hToken,
			DWORD dwFlags,
			LPSTR pszPath);"

	<stdcall: hresult SHGetFolderPathA handle sdword handle dword lpstr>
	^self invalidCall!

SHGetMalloc: ppMalloc
	"Get a pointer to the shell's IMalloc."

	<stdcall: hresult SHGetMalloc IMalloc**>
	^self invalidCall!

SHGetPathFromIDList: pidl pszPath: pszPath

	<stdcall: bool SHGetPathFromIDListA handle lpstr>
	^self invalidCall! !
!ShellLibrary categoriesFor: #allocator!accessing!public! !
!ShellLibrary categoriesFor: #dragAcceptFiles:fAccept:!**auto generated**!public! !
!ShellLibrary categoriesFor: #dragFinish:!**auto generated**!public! !
!ShellLibrary categoriesFor: #dragQueryFile:iFile:lpszFile:cch:!**auto generated**!public! !
!ShellLibrary categoriesFor: #dragQueryPoint:lppt:!**auto generated**!public! !
!ShellLibrary categoriesFor: #extractAssociatedIcon:lpIconPath:lpiIcon:!**auto generated**!public! !
!ShellLibrary categoriesFor: #findExecutable:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #findExecutable:directory:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #findExecutable:lpDirectory:lpResult:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #getDesktopFolder!accessing!public! !
!ShellLibrary categoriesFor: #getSpecialFolderLocation:!**auto generated**!public! !
!ShellLibrary categoriesFor: #isUserAnAdmin!**auto generated**!public! !
!ShellLibrary categoriesFor: #pathFromIDList:!helpers!private! !
!ShellLibrary categoriesFor: #SHBrowseForFolder:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #SHChangeNotify:uFlags:dwItem1:dwItem2:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #shellExecute:lpOperation:lpFile:lpParameters:lpDirectory:nShowCmd:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #shellOpen:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #shellOpen:directory:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #shellOpen:directory:parameters:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #SHGetDesktopFolder:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #shGetFolderPath:nFolder:hToken:dwFlags:pszPath:!**auto generated**!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #SHGetMalloc:!public!win32 functions-shell library! !
!ShellLibrary categoriesFor: #SHGetPathFromIDList:pszPath:!public!win32 functions-shell library! !

!ShellLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'Shell32'! !
!ShellLibrary class categoriesFor: #fileName!constants!public! !

