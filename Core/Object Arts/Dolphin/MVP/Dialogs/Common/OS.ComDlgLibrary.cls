"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #ComDlgLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ComDlgLibrary guid: (GUID fromString: '{6467405a-3a82-101b-8181-00aa003743d3}')!
ComDlgLibrary comment: 'ComDlgLibrary is the <ExternalLibrary> class to represent the Win32 system DLL, COMDLG32.DLL.

This DLL implements Windows'' standard "common" dialogs, such as the File Open/Save, Find, Find/Replace, Font, Color and Print dialogs. See subclasses of <CommonDialog>, which wrap these behind a Smalltalk API in Dolphin.'!
!ComDlgLibrary categoriesForClass!External-Libraries-Win32! !
!ComDlgLibrary methodsFor!

chooseColor: aWinCHOOSECOLOR
	"Create a Color common dialog box that enables the user to select a color.

		BOOL ChooseColor(
			LPCHOOSECOLOR  lpcc 	// address of structure with initialization data
		);"

	<stdcall: bool ChooseColorW CHOOSECOLORW*>
	^self invalidCall: _failureCode!

chooseFont: aWinCHOOSEFONT
	"Create a Font common dialog box that enables the user to choose attributes for a logical font.
	These attributes include a typeface name, style (bold, italic, or regular), point size, character set, and 
	effects (underline, strikeout, and text color). 
	
	BOOL ChooseFont(
		LPCHOOSEFONT  lpcf 	// address of structure with initialization data
	);"

	<stdcall: bool ChooseFontW lpvoid>
	^self invalidCall: _failureCode!

commDlgExtendedError
	"The CommDlgExtendedError function returns a common dialog box error code.
	This code indicates the most recent error to occur during the execution of one of 
	the common dialog box functions."

	<stdcall: dword CommDlgExtendedError>
	^self invalidCall: _failureCode!

findText: aWinFINDREPLACE
	"Create a system-defined modeless dialog box that lets the user specify a string to search for and options to 
	use when searching for text in a document.

		HWND FindText(
			LPFINDREPLACE  lpfr 	// address of structure with initialization data
		);"

	<stdcall: handle FindTextW lpvoid>
	^self invalidCall: _failureCode!

getFileTitle: lpszFile lpszTitle: lpszTitle cbBuf: cbBuf
	"Answer the title of the file identified by the lpszFile parameter.
		short GetFileTitle(
			LPCWSTR lpszFile, 	// pointer to full path and filename for file 	
			LPWSTR lpszTitle, 	// pointer to buffer that receives filename 	
			WORD cbBuf 	// length of buffer 	
		);"

	<stdcall: sword GetFileTitleW lpwstr lpwstr word>
	^self invalidCall: _failureCode!

getOpenFileName: aWinOPENFILENAME
	"Creates an Open common dialog box that lets the user specify the drive, directory, and the name 
	of a file or set of files to open. 

		BOOL GetOpenFileName(
			LPOPENFILENAME  lpofn 	// address of structure with initialization data
		);"

	<stdcall: bool GetOpenFileNameW lpvoid>
	^self invalidCall: _failureCode!

getSaveFileName: aWinOPENFILENAME
	"Creates a Save common dialog box that lets the user specify the drive, directory, 
	and name of a file to save.

		BOOL GetSaveFileName(
			LPOPENFILENAME  lpofn 	// address of structure with initialization data
		);"

	<stdcall: bool GetSaveFileNameW lpvoid>
	^self invalidCall: _failureCode!

replaceText: aWinFINDREPLACE
	"Create a system-defined modeless dialog box that lets the user specify
	a string to search for and a replacement string, as well as options to 
	control the find and replace operations.

		HWND ReplaceText(
			LPFINDREPLACE  lpfr 	// address of structure with initialization data
		);"

	<stdcall: handle ReplaceTextW FINDREPLACEW*>
	^self invalidCall: _failureCode!

systemError
	"Generate an error based on the last recorded host system error."

	^self systemError: self commDlgExtendedError! !
!ComDlgLibrary categoriesFor: #chooseColor:!primitives!private!win32 functions-common dialog box! !
!ComDlgLibrary categoriesFor: #chooseFont:!primitives!private!win32 functions-common dialog box! !
!ComDlgLibrary categoriesFor: #commDlgExtendedError!primitives!private!win32 functions-common dialog box! !
!ComDlgLibrary categoriesFor: #findText:!primitives!private!win32 functions-common dialog box! !
!ComDlgLibrary categoriesFor: #getFileTitle:lpszTitle:cbBuf:!primitives!private!win32 functions-file! !
!ComDlgLibrary categoriesFor: #getOpenFileName:!primitives!private!win32 functions-common dialog box! !
!ComDlgLibrary categoriesFor: #getSaveFileName:!primitives!private!win32 functions-common dialog box! !
!ComDlgLibrary categoriesFor: #replaceText:!primitives!private!win32 functions-common dialog box! !
!ComDlgLibrary categoriesFor: #systemError!exceptions!public! !

!ComDlgLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'COMDLG32'! !
!ComDlgLibrary class categoriesFor: #fileName!constants!public! !

