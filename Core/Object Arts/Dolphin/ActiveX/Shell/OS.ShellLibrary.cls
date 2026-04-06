"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.ShellLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'FOLDERID_Desktop' -> (GUID fromString: '{b4bfcc3a-db2c-424c-b029-7fe99a87c641}').
			'FOLDERID_Documents' -> (GUID fromString: '{fdd39ad0-238f-46af-adb4-6c85480369c7}').
			'FOLDERID_Downloads' -> (GUID fromString: '{374de290-123f-4565-9164-39c4925e467b}').
			'FOLDERID_LocalAppData'
				-> (GUID fromString: '{f1b32785-6fba-4fcf-9d55-7b8e7f157091}').
			'FOLDERID_Pictures' -> (GUID fromString: '{33e28130-4e1e-4676-835a-98395c3bc3bb}').
			'FOLDERID_ProgramFilesX86'
				-> (GUID fromString: '{7c5a40ef-a0fb-4bfc-874a-c0f2e0b9fa8e}').
			'FOLDERID_Windows' -> (GUID fromString: '{f38bf404-1d43-42f2-9305-67de0b28fc23}').
			'KF_FLAG_DEFAULT' -> 16r0.
			'SE_ERR_ACCESSDENIED' -> 16r5.
			'SE_ERR_ASSOCINCOMPLETE' -> 16r1B.
			'SE_ERR_DDEBUSY' -> 16r1E.
			'SE_ERR_DDEFAIL' -> 16r1D.
			'SE_ERR_DDETIMEOUT' -> 16r1C.
			'SE_ERR_DLLNOTFOUND' -> 16r20.
			'SE_ERR_FNF' -> 16r2.
			'SE_ERR_NOASSOC' -> 16r1F.
			'SE_ERR_OOM' -> 16r8.
			'SE_ERR_PNF' -> 16r3.
			'SE_ERR_SHARE' -> 16r1A.
			'SEE_MASK_CLASSKEY' -> 16r3.
			'SEE_MASK_CLASSNAME' -> 16r1.
			'SEE_MASK_CONNECTNETDRV' -> 16r80.
			'SEE_MASK_DOENVSUBST' -> 16r200.
			'SEE_MASK_FLAG_DDEWAIT' -> 16r100.
			'SEE_MASK_FLAG_NO_UI' -> 16r400.
			'SEE_MASK_HOTKEY' -> 16r20.
			'SEE_MASK_ICON' -> 16r10.
			'SEE_MASK_IDLIST' -> 16r4.
			'SEE_MASK_INVOKEIDLIST' -> 16rC.
			'SEE_MASK_NOCLOSEPROCESS' -> 16r40.
			'SEE_MASK_UNICODE' -> 16r10000
		}!

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

	<stdcall: uint32 DragQueryFileW handle uint32 lpwstr uint32>
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

	<stdcall: handle ExtractAssociatedIconW handle lpwstr uint16*>
	^self invalidCall: _failureCode!

findExecutable: pathName
	"Retrieves the name of the executable associated with the specified path."

	^self findExecutable: pathName directory: nil!

findExecutable: lpFile directory: directoryString
	"Retrieves the name of the executable associated with the specified path."

	| buf hInst |
	#todo.	"Support long filenames? May not be possible as API does not."
	buf := Utf16String newFixed: MAX_PATH.
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

getKnownFolderLocation: aGUID
	"
	Shell32 getKnownFolderLocation: FOLDERID_Downloads
	"

	| ppszPath pszPath |
	ppszPath := Address new.
	self
		shGetKnownFolderPath: aGUID
		dwFlags: KF_FLAG_DEFAULT
		hToken: nil
		pszPath: ppszPath.
	pszPath := Utf16String fromAddress: ppszPath.
	COM.Ole32 coTaskMemFree: ppszPath.
	^pszPath!

isUserAnAdmin
	"Invoke the IsUserAnAdmin() function of the module wrapped by the receiver.
	Helpstring: Tests whether the current user is a member of the Administrator's group

		BOOL __stdcall IsUserAnAdmin();"

	<stdcall: bool IsUserAnAdmin>
	^self invalidCall: _failureCode!

myPictures
	^Shell32 getKnownFolderLocation: FOLDERID_Pictures!

SHChangeNotify: wEventId uFlags: unit dwItem1: aLPCVOID1 dwItem2: aLPCVOID2
	"Notify the system of an event that an application has performed that may affect the Shell.
		wEventId, a Windows SHCNE constant that specifies the event.
		uFlags, a WIndows SHCNF constant that specifies what type of objects dwItem1 and dwItem2 are.
		dwItem1 and dwItem2, objects involved in the change."

	<stdcall: void SHChangeNotify uint32 uint32 lpvoid lpvoid>
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

	<stdcall: handle ShellExecuteW handle lpwstr lpwstr lpwstr lpwstr int32>
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
				nShowCmd: UserLibrary.SW_SHOWNORMAL.
	^hInst asInteger <= 32 ifTrue: [self systemError] ifFalse: [hInst]!

shGetKnownFolderPath: frid dwFlags: dwFlags hToken: hToken pszPath: pszPath
	<stdcall: hresult SHGetKnownFolderPath GUID* uint32 handle lpwstr*>
	^self invalidCall: _failureCode!

shGetStockIconInfo: siid uFlags: uFlags psii: psii
	"Invoke the SHGetStockIconInfo() function of the module wrapped by the receiver.
	Helpstring: Retrieves information about system-defined Shell icons.

		HRESULT __stdcall SHGetStockIconInfo(
			SHSTOCKICONID siid,
			unsigned int uFlags,
			[in, out]SHSTOCKICONINFO* psii);"

	<stdcall: hresult SHGetStockIconInfo int32 uint32 SHSTOCKICONINFO*>
	^self invalidCall: _failureCode! !

!OS.ShellLibrary categoriesForMethods!
dragAcceptFiles:fAccept:!**auto generated**!public!win32 functions-shell library! !
dragFinish:!**auto generated**!public!win32 functions-shell library! !
dragQueryFile:iFile:lpszFile:cch:!**auto generated**!public!win32 functions-shell library! !
dragQueryPoint:lppt:!**auto generated**!public!win32 functions-shell library! !
extractAssociatedIcon:lpIconPath:lpiIcon:!**auto generated**!public!win32 functions-shell library! !
findExecutable:!public!win32 functions-shell library! !
findExecutable:directory:!public!win32 functions-shell library! !
findExecutable:lpDirectory:lpResult:!public!win32 functions-shell library! !
getKnownFolderLocation:!public!win32 functions-shell library! !
isUserAnAdmin!**auto generated**!public!win32 functions-shell library! !
myPictures!accessing!public! !
SHChangeNotify:uFlags:dwItem1:dwItem2:!public!win32 functions-shell library! !
shellExecute:lpOperation:lpFile:lpParameters:lpDirectory:nShowCmd:!public!win32 functions-shell library! !
shellOpen:!public!win32 functions-shell library! !
shellOpen:directory:!public!win32 functions-shell library! !
shellOpen:directory:parameters:!public!win32 functions-shell library! !
shGetKnownFolderPath:dwFlags:hToken:pszPath:!**auto generated**!public!win32 functions-shell library! !
shGetStockIconInfo:uFlags:psii:!**auto generated**!public!win32 functions-shell library! !
!

!OS.ShellLibrary class methodsFor!

fileName
	"Answer the file name of the external library which the receiver represents."

	^'shell32'!

sharedVariableName
	^#{OS.Shell32}! !

!OS.ShellLibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

