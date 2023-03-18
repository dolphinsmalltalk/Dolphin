"Filed out from Dolphin Smalltalk"!

OS.CommonDialogStructure
	subclass: #'OS.OPENFILENAMEW'
	instanceVariableNames: 'fileName title filter defExt initialDir'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_dwReserved' -> 16r50.
			'_OffsetOf_dwSize' -> 16r0.
			'_OffsetOf_flags' -> 16r34.
			'_OffsetOf_flagsEx' -> 16r54.
			'_OffsetOf_hInstance' -> 16r8.
			'_OffsetOf_hwndOwner' -> 16r4.
			'_OffsetOf_lCustData' -> 16r40.
			'_OffsetOf_lpfnHook' -> 16r44.
			'_OffsetOf_lpstrCustomFilter' -> 16r10.
			'_OffsetOf_lpstrDefExt' -> 16r3C.
			'_OffsetOf_lpstrFile' -> 16r1C.
			'_OffsetOf_lpstrFileTitle' -> 16r24.
			'_OffsetOf_lpstrFilter' -> 16rC.
			'_OffsetOf_lpstrInitialDir' -> 16r2C.
			'_OffsetOf_lpstrTitle' -> 16r30.
			'_OffsetOf_lpTemplateName' -> 16r48.
			'_OffsetOf_nFileExtension' -> 16r3A.
			'_OffsetOf_nFileOffset' -> 16r38.
			'_OffsetOf_nFilterIndex' -> 16r18.
			'_OffsetOf_nMaxCustFilter' -> 16r14.
			'_OffsetOf_nMaxFile' -> 16r20.
			'_OffsetOf_nMaxFileTitle' -> 16r28.
			'_OffsetOf_pvReserved' -> 16r4C.
			'_OPENFILENAMEW_Size' -> 16r58
		}!
OS.OPENFILENAMEW guid: (Core.GUID fromString: '{87b4c603-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.OPENFILENAMEW comment: 'OPENFILENAME is a <Win32Structure> which represents the Windows Common Dialog structure of the same name. It is used in conjunction with the GetOpenFileName() and GetSaveFileName() APIs which pop a common file dialog to browser for a file to load or save respectively. See the <FileDialog> and the Win32 documentation for further details.

The following instance variables hold <String> objects whose addresses have been stored into the structure. This is necessary to prevent premature garbage collection of these objects occurring during an external API call.

Instance Variables:
	fileName		<String>
	title 		<String>
	filter 		<String>
	defExt 		<String>
	fileTitle		<String>
	initialDir		<String>'!
!OS.OPENFILENAMEW categoriesForClass!Win32-Structs! !
!OS.OPENFILENAMEW methodsFor!

defaultExtension
	"Answer the default extension for the file open/save, or nil if none is set."

	^defExt!

defaultExtension: aString
	"Set the default extension for the file open/save.
	We store down the String in an instance variable to prevent it being GC'd."

	defExt := aString asUtf16String.
	self lpstrDefExt: defExt!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

fileName
	"Answer the file name buffer."

	^fileName!

fileName: aString
	"Set the file name to be opened/saved.
	We store down the String in an instance variable to prevent it being GC'd."

	fileName := aString asUtf16String.
	self lpstrFile: fileName!

fileTypes: aString
	"Set the file type filter to be used for the common file dialog.
	We store down the String in an instance variable to prevent it being GC'd."

	filter := aString asUtf16String.
	self lpstrFilter: filter!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

flagsEx
	"Answer the <Integer> value of the receiver's 'flagsEx' field."

	^bytes uint32AtOffset: _OffsetOf_flagsEx!

flagsEx: anInteger
	"Set the receiver's 'flagsEx' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flagsEx put: anInteger!

hookFlag
	^OFN_ENABLEHOOK!

hwndOwner: anExternalHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndOwner put: anExternalHandle!

initialDirectory: aString
	"Set the initial directory path name to be opened/saved.
	We store down the String in an instance variable to prevent it being GC'd."

	initialDir := aString asUtf16String.
	self lpstrInitialDir: initialDir!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anExternalAddress!

lpstrDefExt: anUtf16String
	"Set the receiver's 'lpstrDefExt' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrDefExt put: anUtf16String yourAddress!

lpstrFile
	"Answer the <Utf16String> value of the receiver's 'lpstrFile' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpstrFile)!

lpstrFile: anUtf16String
	"Set the receiver's 'lpstrFile' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrFile put: anUtf16String yourAddress!

lpstrFileTitle
	"Answer the <Utf16String> value of the receiver's 'lpstrFileTitle' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpstrFileTitle)!

lpstrFileTitle: anUtf16String
	"Set the receiver's 'lpstrFileTitle' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrFileTitle put: anUtf16String yourAddress!

lpstrFilter: anUtf16String
	"Set the receiver's 'lpstrFilter' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrFilter put: anUtf16String yourAddress!

lpstrInitialDir: anUtf16String
	"Set the receiver's 'lpstrInitialDir' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrInitialDir put: anUtf16String yourAddress!

lpstrTitle: anUtf16String
	"Set the receiver's 'lpstrTitle' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrTitle put: anUtf16String yourAddress!

nFilterIndex
	"Answer the <Integer> value of the receiver's 'nFilterIndex' field."

	^bytes uint32AtOffset: _OffsetOf_nFilterIndex!

nFilterIndex: anInteger
	"Set the receiver's 'nFilterIndex' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nFilterIndex put: anInteger!

nMaxFile: anInteger
	"Set the receiver's 'nMaxFile' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nMaxFile put: anInteger!

nMaxFileTitle: anInteger
	"Set the receiver's 'nMaxFileTitle' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nMaxFileTitle put: anInteger!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull
		ifTrue: [self hwndOwner: 0]
		ifFalse: [self hwndOwner: hWnd].!

title: aString
	"Set the title to be used for the common file dialog caption.
	We store down the String in an instance variable to prevent it being GC'd."

	title := aString asUtf16String.
	self lpstrTitle: title! !
!OS.OPENFILENAMEW categoriesForMethods!
defaultExtension!accessing!public! !
defaultExtension:!accessing!public! !
dwSize:!**compiled accessors**!public! !
fileName!accessing!public! !
fileName:!accessing!public! !
fileTypes:!accessing!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
flagsEx!**compiled accessors**!public! !
flagsEx:!**compiled accessors**!public! !
hookFlag!accessing!public! !
hwndOwner:!**compiled accessors**!public! !
initialDirectory:!accessing!public! !
lpfnHook:!**compiled accessors**!public! !
lpstrDefExt:!**compiled accessors**!public! !
lpstrFile!**compiled accessors**!public! !
lpstrFile:!**compiled accessors**!public! !
lpstrFileTitle!**compiled accessors**!public! !
lpstrFileTitle:!**compiled accessors**!public! !
lpstrFilter:!**compiled accessors**!public! !
lpstrInitialDir:!**compiled accessors**!public! !
lpstrTitle:!**compiled accessors**!public! !
nFilterIndex!**compiled accessors**!public! !
nFilterIndex:!**compiled accessors**!public! !
nMaxFile:!**compiled accessors**!public! !
nMaxFileTitle:!**compiled accessors**!public! !
ownerView:!accessing!public! !
title:!accessing!public! !
!

!OS.OPENFILENAMEW class methodsFor!

byteSize
	^_OPENFILENAMEW_Size!

defineFields
	"Define the fields of the OPENFILENAME structure.

	self compileDefinition

		typedef [uuid(87B4C603-026E-11D3-9FD7-00A0CC3E4A32)]
		struct tagOPENFILENAME {
			DWORD lStructSize;
			HWND hwndOwner;
			HINSTANCE HINSTANCE;
			LPWSTR lpstrFilter;
			LPWSTR lpstrCustomFilter;
			DWORD nMaxCustFilter;
			DWORD nFilterIndex;
			LPWSTR lpstrFile;
			DWORD nMaxFile;
			LPWSTR lpstrFileTitle;
			DWORD nMaxFileTitle;
			LPWSTR lpstrInitialDir;
			LPWSTR lpstrTitle;
			DWORD flags;
			WORD nFileOffset;
			WORD nFileExtension;
			LPWSTR lpstrDefExt;
			DWORD lCustData;
			LPVOID lpfnHook;
			LPWSTR lpTemplateName;
			void* pvReserved;
			DWORD dwReserved;
			DWORD FlagsEx;
		} OPENFILENAMEW;
"

	self
		defineField: #dwSize type: UInt32Field writeOnly beOverride;
		defineField: #hwndOwner type: HANDLEField writeOnly;
		defineField: #hInstance type: HANDLEField filler;
		defineField: #lpstrFilter type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpstrCustomFilter type: (PointerField type: Utf16String) beFiller;
		defineField: #nMaxCustFilter type: UInt32Field filler;
		defineField: #nFilterIndex type: UInt32Field new;
		defineField: #lpstrFile type: (PointerField type: Utf16String);
		defineField: #nMaxFile type: UInt32Field writeOnly;
		defineField: #lpstrFileTitle type: (PointerField type: Utf16String);
		defineField: #nMaxFileTitle type: UInt32Field writeOnly;
		defineField: #lpstrInitialDir type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpstrTitle type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #flags type: UInt32Field new beOverride;
		defineField: #nFileOffset type: UInt16Field new beUncompiled;
		defineField: #nFileExtension type: UInt16Field new beUncompiled;
		defineField: #lpstrDefExt type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lCustData type: UInt32Field filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName type: (PointerField type: Utf16String) beFiller;
		defineField: #pvReserved type: LPVOIDField filler;
		defineField: #dwReserved type: UInt32Field filler;
		defineField: #flagsEx type: UInt32Field new!

getFieldNames
	^#(#dwSize #hwndOwner #lpstrFilter #nFilterIndex #lpstrFile #nMaxFile #lpstrFileTitle #nMaxFileTitle #lpstrInitialDir #lpstrTitle #flags #nFileOffset #nFileExtension #lpstrDefExt #lpfnHook #flagsEx)! !
!OS.OPENFILENAMEW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

