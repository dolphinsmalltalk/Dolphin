"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #OPENFILENAME
	instanceVariableNames: 'fileName title filter defExt initialDir'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OPENFILENAME guid: (GUID fromString: '{87b4c603-026e-11d3-9fd7-00a0cc3e4a32}')!
OPENFILENAME comment: 'OPENFILENAME is a <Win32Structure> which represent the Windows Common Dialog structure of the same name. It is used in conjunction with the GetOpenFileName() and GetSaveFileName() APIs which pop a common file dialog to browser for a file to load or save respectively. See the <FileDialog> and the Win32 documentation for further details.

The following instance variables hold <String> objects whose addresses have been stored into the structure. This is necessary to prevent premature garbage collection of these objects occurring during an external API call.

Instance Variables:
	fileName		<String>
	title 		<String>
	filter 		<String>
	defExt 		<String>
	fileTitle		<String>
	initialDir		<String>'!
!OPENFILENAME categoriesForClass!Win32-Structs! !
!OPENFILENAME methodsFor!

defaultExtension
	"Answer the default extension for the file open/save, or nil if none is set."

	^defExt!

defaultExtension: aString
	"Set the default extension for the file open/save.
	We store down the String in an instance variable to prevent it being GC'd."

	defExt := aString.
	self lpstrDefExt: aString!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

fileName: aString
	"Set the file name to be opened/saved.
	We store down the String in an instance variable to prevent it being GC'd."

	fileName := aString.
	self lpstrFile: aString!

fileTypes: aString
	"Set the file type filter to be used for the the common file dialog.
	We store down the String in an instance variable to prevent it being GC'd."

	filter := aString.
	self lpstrFilter: aString!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject 
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

flagsEx
	"Answer the receiver's flagsEx field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flagsEx)!

flagsEx: anObject 
	"Set the receiver's flagsEx field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flagsEx) put: anObject!

hookFlag
	^OFN_ENABLEHOOK!

hwndOwner: anObject 
	"Set the receiver's hwndOwner field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner) put: anObject!

initialDirectory: aString
	"Set the initial directory path name to be opened/saved.
	We store down the String in an instance variable to prevent it being GC'd."

	initialDir := aString.
	self lpstrInitialDir: aString!

lpfnHook: anObject 
	"Set the receiver's lpfnHook field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anObject!

lpstrDefExt: anObject 
	"Set the receiver's lpstrDefExt field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrDefExt) put: anObject yourAddress!

lpstrFile
	"Answer the receiver's lpstrFile field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpstrFile))!

lpstrFile: anObject 
	"Set the receiver's lpstrFile field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrFile) put: anObject yourAddress!

lpstrFileTitle
	"Answer the receiver's lpstrFileTitle field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpstrFileTitle))!

lpstrFileTitle: anObject 
	"Set the receiver's lpstrFileTitle field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrFileTitle) put: anObject yourAddress!

lpstrFilter: anObject 
	"Set the receiver's lpstrFilter field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrFilter) put: anObject yourAddress!

lpstrInitialDir: anObject 
	"Set the receiver's lpstrInitialDir field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrInitialDir) put: anObject yourAddress!

lpstrTitle: anObject 
	"Set the receiver's lpstrTitle field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrTitle) put: anObject yourAddress!

nFilterIndex
	"Answer the receiver's nFilterIndex field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nFilterIndex)!

nFilterIndex: anObject 
	"Set the receiver's nFilterIndex field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nFilterIndex) put: anObject!

nMaxFile: anObject 
	"Set the receiver's nMaxFile field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nMaxFile) put: anObject!

nMaxFileTitle: anObject 
	"Set the receiver's nMaxFileTitle field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nMaxFileTitle) put: anObject!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull
		ifTrue: [self hwndOwner: 0]
		ifFalse: [self hwndOwner: hWnd].!

title: aString
	"Set the title to be used for the the common file dialog caption.
	We store down the String in an instance variable to prevent it being GC'd."

	title := aString.
	self lpstrTitle: aString! !
!OPENFILENAME categoriesFor: #defaultExtension!accessing!public! !
!OPENFILENAME categoriesFor: #defaultExtension:!accessing!public! !
!OPENFILENAME categoriesFor: #dwSize:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #fileName:!accessing!public! !
!OPENFILENAME categoriesFor: #fileTypes:!accessing!public! !
!OPENFILENAME categoriesFor: #flags!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #flags:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #flagsEx!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #flagsEx:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #hookFlag!accessing!public! !
!OPENFILENAME categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #initialDirectory:!accessing!public! !
!OPENFILENAME categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #lpstrDefExt:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #lpstrFile!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #lpstrFile:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #lpstrFileTitle!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #lpstrFileTitle:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #lpstrFilter:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #lpstrInitialDir:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #lpstrTitle:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #nFilterIndex!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #nFilterIndex:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #nMaxFile:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #nMaxFileTitle:!**compiled accessors**!public! !
!OPENFILENAME categoriesFor: #ownerView:!accessing!public! !
!OPENFILENAME categoriesFor: #title:!accessing!public! !

!OPENFILENAME class methodsFor!

defineFields
	"Define the fields of the OPENFILENAME structure.

	OPENFILENAME  compileDefinition

		typedef [uuid(87B4C603-026E-11D3-9FD7-00A0CC3E4A32)]
		struct tagOPENFILENAME {
			DWORD lStructSize;
			HWND hwndOwner;
			HINSTANCE HINSTANCE;
			LPSTR lpstrFilter;
			LPSTR lpstrCustomFilter;
			DWORD nMaxCustFilter;
			DWORD nFilterIndex;
			LPSTR lpstrFile;
			DWORD nMaxFile;
			LPSTR lpstrFileTitle;
			DWORD nMaxFileTitle;
			LPSTR lpstrInitialDir;
			LPSTR lpstrTitle;
			DWORD flags;
			WORD nFileOffset;
			WORD nFileExtension;
			LPSTR lpstrDefExt;
			DWORD lCustData;
			LPVOID lpfnHook;
			LPSTR lpTemplateName;
			void* pvReserved;
			DWORD dwReserved;
			DWORD FlagsEx;
		} OPENFILENAME;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner type: HANDLEField writeOnly;
		defineField: #hInstance type: HANDLEField filler;
		defineField: #lpstrFilter type: (PointerField type: String) beWriteOnly;
		defineField: #lpstrCustomFilter type: (PointerField type: String) beFiller;
		defineField: #nMaxCustFilter type: DWORDField filler;
		defineField: #nFilterIndex type: DWORDField new;
		defineField: #lpstrFile type: (PointerField type: String);
		defineField: #nMaxFile type: DWORDField writeOnly;
		defineField: #lpstrFileTitle type: (PointerField type: String);
		defineField: #nMaxFileTitle type: DWORDField writeOnly;
		defineField: #lpstrInitialDir type: (PointerField type: String) beWriteOnly;
		defineField: #lpstrTitle type: (PointerField type: String) beWriteOnly;
		defineField: #flags type: DWORDField new beOverride;
		defineField: #nFileOffset type: WORDField new beUncompiled;
		defineField: #nFileExtension type: WORDField new beUncompiled;
		defineField: #lpstrDefExt type: (PointerField type: String) beWriteOnly;
		defineField: #lCustData type: DWORDField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName type: (PointerField type: String) beFiller;
		defineField: #pvReserved type: LPVOIDField filler;
		defineField: #dwReserved type: DWORDField filler;
		defineField: #flagsEx type: DWORDField new! !
!OPENFILENAME class categoriesFor: #defineFields!initializing!public! !

