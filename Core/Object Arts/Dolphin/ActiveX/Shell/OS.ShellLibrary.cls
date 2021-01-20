"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.ShellLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ShellConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.ShellLibrary guid: (Core.GUID fromString: '{64674052-3a82-101b-8181-00aa003743d3}')!
OS.ShellLibrary comment: 'ShellLibrary is the <ExternalLibrary> class to represent the Win32 system library, Shell32.DLL'!
!OS.ShellLibrary categoriesForClass!External-Libraries-Win32! !
!OS.ShellLibrary methodsFor!

dragAcceptFiles: hwnd fAccept: fAccept
	"Invoke the DragAcceptFiles() function of the module wrapped by the receiver.
	Helpstring: Registers whether a window accepts dropped files

		void __stdcall DragAcceptFiles(
			HWND HWND,
			BOOL fAccept);"

	<stdcall: void DragAcceptFiles handle bool>
	^self invalidCall: _failureCode!

dragFinish: hDrop
	"Invoke the DragFinish() function of the module wrapped by the receiver.
	Helpstring: Releases memory that the system allocated for use in transferring file names to the application

		void __stdcall DragFinish(
			hDrop hDrop);"

	<stdcall: void DragFinish handle>
	^self invalidCall: _failureCode!

dragQueryFile: hDrop iFile: iFile lpszFile: lpszFile cch: cch
	"Invoke the DragQueryFile() function of the module wrapped by the receiver.
	Helpstring: Retrieves the names of dropped files that result from a successful drag-and-drop operation

		UINT __stdcall DragQueryFile(
			hDrop hDrop,
			UINT iFile,
			LPWSTR lpszFile,
			UINT cch);"

	<stdcall: dword DragQueryFileW handle dword lpwstr dword>
	^self invalidCall: _failureCode!

dragQueryPoint: hDrop lppt: lppt
	"Invoke the DragQueryPoint() function of the module wrapped by the receiver.
	Helpstring: Retrieves the position of the mouse pointer at the time a file was dropped during a drag-and-drop operation

		BOOL __stdcall DragQueryPoint(
			hDrop hDrop,
			POINTL* lppt);"

	<stdcall: bool DragQueryPoint handle POINTL*>
	^self invalidCall: _failureCode!

extractAssociatedIcon: hInst lpIconPath: lpIconPath lpiIcon: lpiIcon
	"Invoke the ExtractAssociatedIcon() function of the module wrapped by the receiver.
	Helpstring: Returns handle of indexed icon found in a file or in an associated executable file

		HICON __stdcall ExtractAssociatedIcon(
			HINSTANCE hInst,
			LPWSTR lpIconPath,
			WORD* lpiIcon);"

	<stdcall: handle ExtractAssociatedIconW handle lpwstr word*>
	^self invalidCall: _failureCode!

findExecutable: pathName
	"Retrieves the name of the executable associated with the specified path."

	^self findExecutable: pathName directory: nil!

findExecutable: lpFile directory: directoryString
	"Retrieves the name of the executable associated with the specified path."

	| buf hInst |
	buf := File pathBuffer.
	hInst := self
				findExecutable: lpFile
				lpDirectory: directoryString
				lpResult: buf.
	^hInst asInteger <= 32
		ifTrue: 
			["FindExecutable() error reporting not consistent with normal Win32 mechanism"
			hInst asInteger == 31 ifTrue: [Win32Error signalWith: 16r483] ifFalse: [self systemError]]
		ifFalse: [buf trimNulls]!

findExecutable: lpFile lpDirectory: directoryStringIn lpResult: buf
	"Retrieves the name and handle of the executable associated with the specified filename.

		HINSTANCE FindExecutable(
			LPCWSTR lpFile,		// filename string [in]
			LPCWSTR lpDirectory,	// default directory string [in]
			LPWSTR lpResult 		// buffer for executable file name [out]
		);"

	<stdcall: handle FindExecutableW lpwstr lpwstr lpwstr>
	^self invalidCall: _failureCode!

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
	^self invalidCall: _failureCode!

SHChangeNotify: wEventId uFlags: unit dwItem1: aLPCVOID1 dwItem2: aLPCVOID2
	"Notify the system of an event that an application has performed that may affect the Shell.
		wEventId, a Windows SHCNE constant that specifies the event.
		uFlags, a WIndows SHCNF constant that specifies what type of objects dwItem1 and dwItem2 are.
		dwItem1 and dwItem2, objects involved in the change."

	<stdcall: void SHChangeNotify dword dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

shellExecute: hwnd lpOperation: opString lpFile: fileString lpParameters: parmString lpDirectory: dirString nShowCmd: anInteger
	"Opens or prints the specified file, which can be an executable or document file.
		HINSTANCE ShellExecute(
	  		HWND hwnd,			// handle to parent window
			LPCWSTR lpOperation,	// pointer to string that specifies operation to perform
			LPCWSTR lpFile,		// pointer to filename or folder name string
			LPCWSTR lpParameters,	// pointer to string that specifies executable-file parameters 
			LPCWSTR lpDirectory,	// pointer to string that specifies default directory
			INT nShowCmd 			// whether file is shown when opened
		);"

	<stdcall: handle ShellExecuteW handle lpwstr lpwstr lpwstr lpwstr sdword>
	^self invalidCall: _failureCode!

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

shGetFolderPath: hwndOwner nFolder: nFolder hToken: hToken dwFlags: dwFlags pszPath: pszPath
	"Invoke the SHGetFolderPath() function of the module wrapped by the receiver.
	Helpstring: Takes the CSIDL of a folder and returns the path

		HRESULT __stdcall SHGetFolderPath(
			HWND hwndOwner,
			int nFolder,
			HANDLE hToken,
			DWORD dwFlags,
			LPWSTR pszPath);"

	<stdcall: hresult SHGetFolderPathW handle sdword handle dword lpwstr>
	^self invalidCall: _failureCode!

shGetStockIconInfo: siid uFlags: uFlags psii: psii
	"Invoke the SHGetStockIconInfo() function of the module wrapped by the receiver.
	Helpstring: Retrieves information about system-defined Shell icons.

		HRESULT __stdcall SHGetStockIconInfo(
			SHSTOCKICONID siid,
			unsigned int uFlags,
			[in, out]SHSTOCKICONINFO* psii);"

	<stdcall: hresult SHGetStockIconInfo sdword dword SHSTOCKICONINFO*>
	^self invalidCall: _failureCode! !
!OS.ShellLibrary categoriesFor: #dragAcceptFiles:fAccept:!**auto generated**!public! !
!OS.ShellLibrary categoriesFor: #dragFinish:!**auto generated**!public! !
!OS.ShellLibrary categoriesFor: #dragQueryFile:iFile:lpszFile:cch:!**auto generated**!public! !
!OS.ShellLibrary categoriesFor: #dragQueryPoint:lppt:!**auto generated**!public! !
!OS.ShellLibrary categoriesFor: #extractAssociatedIcon:lpIconPath:lpiIcon:!**auto generated**!public! !
!OS.ShellLibrary categoriesFor: #findExecutable:!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #findExecutable:directory:!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #findExecutable:lpDirectory:lpResult:!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #getSpecialFolderLocation:!**auto generated**!public! !
!OS.ShellLibrary categoriesFor: #isUserAnAdmin!**auto generated**!public! !
!OS.ShellLibrary categoriesFor: #SHChangeNotify:uFlags:dwItem1:dwItem2:!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #shellExecute:lpOperation:lpFile:lpParameters:lpDirectory:nShowCmd:!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #shellOpen:!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #shellOpen:directory:!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #shellOpen:directory:parameters:!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #shGetFolderPath:nFolder:hToken:dwFlags:pszPath:!**auto generated**!public!win32 functions-shell library! !
!OS.ShellLibrary categoriesFor: #shGetStockIconInfo:uFlags:psii:!**auto generated**!public! !

!OS.ShellLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'Shell32'! !
!OS.ShellLibrary class categoriesFor: #fileName!constants!public! !

