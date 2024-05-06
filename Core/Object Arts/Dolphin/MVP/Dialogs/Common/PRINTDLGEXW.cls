"Filed out from Dolphin Smalltalk"!

CommonDialogStructure subclass: #PRINTDLGEXW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwResultAction _OffsetOf_ExclusionFlags _OffsetOf_flags _OffsetOf_Flags2 _OffsetOf_hDC _OffsetOf_hDevMode _OffsetOf_hDevNames _OffsetOf_hInstance _OffsetOf_hwndOwner _OffsetOf_lpCallback _OffsetOf_lphPropertyPages _OffsetOf_lpPageRanges _OffsetOf_lpPrintTemplateName _OffsetOf_lStructSize _OffsetOf_nCopies _OffsetOf_nMaxPage _OffsetOf_nMaxPageRanges _OffsetOf_nMinPage _OffsetOf_nPageRanges _OffsetOf_nPropertyPages _OffsetOf_nStartPage'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PRINTDLGEXW guid: (GUID fromString: '{46f06e70-1bb5-4b02-98ee-6ab442f3b43f}')!

PRINTDLGEXW addClassConstant: '_OffsetOf_dwResultAction' value: 16r50!
PRINTDLGEXW addClassConstant: '_OffsetOf_ExclusionFlags' value: 16r1C!
PRINTDLGEXW addClassConstant: '_OffsetOf_flags' value: 16r14!
PRINTDLGEXW addClassConstant: '_OffsetOf_Flags2' value: 16r18!
PRINTDLGEXW addClassConstant: '_OffsetOf_hDC' value: 16r10!
PRINTDLGEXW addClassConstant: '_OffsetOf_hDevMode' value: 16r8!
PRINTDLGEXW addClassConstant: '_OffsetOf_hDevNames' value: 16rC!
PRINTDLGEXW addClassConstant: '_OffsetOf_hInstance' value: 16r38!
PRINTDLGEXW addClassConstant: '_OffsetOf_hwndOwner' value: 16r4!
PRINTDLGEXW addClassConstant: '_OffsetOf_lpCallback' value: 16r40!
PRINTDLGEXW addClassConstant: '_OffsetOf_lphPropertyPages' value: 16r48!
PRINTDLGEXW addClassConstant: '_OffsetOf_lpPageRanges' value: 16r28!
PRINTDLGEXW addClassConstant: '_OffsetOf_lpPrintTemplateName' value: 16r3C!
PRINTDLGEXW addClassConstant: '_OffsetOf_lStructSize' value: 16r0!
PRINTDLGEXW addClassConstant: '_OffsetOf_nCopies' value: 16r34!
PRINTDLGEXW addClassConstant: '_OffsetOf_nMaxPage' value: 16r30!
PRINTDLGEXW addClassConstant: '_OffsetOf_nMaxPageRanges' value: 16r24!
PRINTDLGEXW addClassConstant: '_OffsetOf_nMinPage' value: 16r2C!
PRINTDLGEXW addClassConstant: '_OffsetOf_nPageRanges' value: 16r20!
PRINTDLGEXW addClassConstant: '_OffsetOf_nPropertyPages' value: 16r44!
PRINTDLGEXW addClassConstant: '_OffsetOf_nStartPage' value: 16r4C!

PRINTDLGEXW comment: '<PRINTDLGEX> is an <ExternalStructure> class to wrap the struct ''Win32.PRINTDLGEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(46F06E70-1BB5-4B02-98EE-6AB442F3B43F)]
struct tagPRINTDLGEX {
	DWORD lStructSize;
	HWND hwndOwner;
	HGLOBAL hDevMode;
	HGLOBAL hDevNames;
	HDC HDC;
	DWORD flags;
	DWORD Flags2;
	DWORD ExclusionFlags;
	DWORD nPageRanges;
	DWORD nMaxPageRanges;
	PRINTPAGERANGE* lpPageRanges;
	DWORD nMinPage;
	DWORD nMaxPage;
	DWORD nCopies;
	HINSTANCE HINSTANCE;
	LPCSTR lpPrintTemplateName;
	IUnknown* lpCallback;
	DWORD nPropertyPages;
	HPROPSHEETPAGE* lphPropertyPages;
	DWORD nStartPage;
	DWORD dwResultAction;
} PRINTDLGEX;
'!

!PRINTDLGEXW categoriesForClass!Win32-Structs! !

!PRINTDLGEXW methodsFor!

dwResultAction
	"Answer the <Integer> value of the receiver's 'dwResultAction' field."

	^bytes dwordAtOffset: _OffsetOf_dwResultAction!

dwResultAction: anInteger
	"Set the receiver's 'dwResultAction' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwResultAction put: anInteger!

ExclusionFlags
	"Answer the <Integer> value of the receiver's 'ExclusionFlags' field."

	^bytes dwordAtOffset: _OffsetOf_ExclusionFlags!

ExclusionFlags: anInteger
	"Set the receiver's 'ExclusionFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ExclusionFlags put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_flags put: anInteger!

Flags2
	"Answer the <Integer> value of the receiver's 'Flags2' field."

	^bytes dwordAtOffset: _OffsetOf_Flags2!

Flags2: anInteger
	"Set the receiver's 'Flags2' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Flags2 put: anInteger!

hDC
	"Answer the <ExternalHandle> value of the receiver's 'hDC' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hDC) asExternalHandle!

hDC: anExternalHandle
	"Set the receiver's 'hDC' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hDC put: anExternalHandle!

hDevMode
	"Answer the <ExternalHandle> value of the receiver's 'hDevMode' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hDevMode) asExternalHandle!

hDevMode: anExternalHandle
	"Set the receiver's 'hDevMode' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hDevMode put: anExternalHandle!

hDevNames
	"Answer the <ExternalHandle> value of the receiver's 'hDevNames' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hDevNames) asExternalHandle!

hDevNames: anExternalHandle
	"Set the receiver's 'hDevNames' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hDevNames put: anExternalHandle!

hInstance
	"Answer the <ExternalHandle> value of the receiver's 'hInstance' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hInstance) asExternalHandle!

hInstance: anExternalHandle
	"Set the receiver's 'hInstance' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hInstance put: anExternalHandle!

hwndOwner
	"Answer the <ExternalHandle> value of the receiver's 'hwndOwner' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwndOwner) asExternalHandle!

hwndOwner: anExternalHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndOwner put: anExternalHandle!

lpCallback
	"Answer the <IUnknown> value of the receiver's 'lpCallback' field."

	^IUnknown fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpCallback)!

lpCallback: anIUnknown
	"Set the receiver's 'lpCallback' field to the value of the argument, anIUnknown"

	bytes uintPtrAtOffset: _OffsetOf_lpCallback put: anIUnknown yourAddress!

lphPropertyPages
	"Answer the <ExternalHandle> value of the receiver's 'lphPropertyPages' field."

	^ExternalHandle fromAddress: (bytes intPtrAtOffset: _OffsetOf_lphPropertyPages)!

lphPropertyPages: anExternalHandle
	"Set the receiver's 'lphPropertyPages' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_lphPropertyPages put: anExternalHandle yourAddress!

lpPageRanges
	"Answer the <PRINTPAGERANGE> value of the receiver's 'lpPageRanges' field."

	^PRINTPAGERANGE fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpPageRanges)!

lpPageRanges: aPRINTPAGERANGE
	"Set the receiver's 'lpPageRanges' field to the value of the argument, aPRINTPAGERANGE"

	bytes uintPtrAtOffset: _OffsetOf_lpPageRanges put: aPRINTPAGERANGE yourAddress!

lpPrintTemplateName
	"Answer the <Utf16String> value of the receiver's 'lpPrintTemplateName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpPrintTemplateName)!

lpPrintTemplateName: anUtf16String
	"Set the receiver's 'lpPrintTemplateName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpPrintTemplateName put: anUtf16String yourAddress!

lStructSize
	"Answer the <Integer> value of the receiver's 'lStructSize' field."

	^bytes dwordAtOffset: _OffsetOf_lStructSize!

lStructSize: anInteger
	"Set the receiver's 'lStructSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lStructSize put: anInteger!

nCopies
	"Answer the <Integer> value of the receiver's 'nCopies' field."

	^bytes dwordAtOffset: _OffsetOf_nCopies!

nCopies: anInteger
	"Set the receiver's 'nCopies' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nCopies put: anInteger!

nMaxPage
	"Answer the <Integer> value of the receiver's 'nMaxPage' field."

	^bytes dwordAtOffset: _OffsetOf_nMaxPage!

nMaxPage: anInteger
	"Set the receiver's 'nMaxPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nMaxPage put: anInteger!

nMaxPageRanges
	"Answer the <Integer> value of the receiver's 'nMaxPageRanges' field."

	^bytes dwordAtOffset: _OffsetOf_nMaxPageRanges!

nMaxPageRanges: anInteger
	"Set the receiver's 'nMaxPageRanges' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nMaxPageRanges put: anInteger!

nMinPage
	"Answer the <Integer> value of the receiver's 'nMinPage' field."

	^bytes dwordAtOffset: _OffsetOf_nMinPage!

nMinPage: anInteger
	"Set the receiver's 'nMinPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nMinPage put: anInteger!

nPageRanges
	"Answer the <Integer> value of the receiver's 'nPageRanges' field."

	^bytes dwordAtOffset: _OffsetOf_nPageRanges!

nPageRanges: anInteger
	"Set the receiver's 'nPageRanges' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nPageRanges put: anInteger!

nPropertyPages
	"Answer the <Integer> value of the receiver's 'nPropertyPages' field."

	^bytes dwordAtOffset: _OffsetOf_nPropertyPages!

nPropertyPages: anInteger
	"Set the receiver's 'nPropertyPages' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nPropertyPages put: anInteger!

nStartPage
	"Answer the <Integer> value of the receiver's 'nStartPage' field."

	^bytes dwordAtOffset: _OffsetOf_nStartPage!

nStartPage: anInteger
	"Set the receiver's 'nStartPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nStartPage put: anInteger! !

!PRINTDLGEXW categoriesForMethods!
dwResultAction!**compiled accessors**!public! !
dwResultAction:!**compiled accessors**!public! !
ExclusionFlags!**compiled accessors**!public! !
ExclusionFlags:!**compiled accessors**!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
Flags2!**compiled accessors**!public! !
Flags2:!**compiled accessors**!public! !
hDC!**compiled accessors**!public! !
hDC:!**compiled accessors**!public! !
hDevMode!**compiled accessors**!public! !
hDevMode:!**compiled accessors**!public! !
hDevNames!**compiled accessors**!public! !
hDevNames:!**compiled accessors**!public! !
hInstance!**compiled accessors**!public! !
hInstance:!**compiled accessors**!public! !
hwndOwner!**compiled accessors**!public! !
hwndOwner:!**compiled accessors**!public! !
lpCallback!**compiled accessors**!public! !
lpCallback:!**compiled accessors**!public! !
lphPropertyPages!**compiled accessors**!public! !
lphPropertyPages:!**compiled accessors**!public! !
lpPageRanges!**compiled accessors**!public! !
lpPageRanges:!**compiled accessors**!public! !
lpPrintTemplateName!**compiled accessors**!public! !
lpPrintTemplateName:!**compiled accessors**!public! !
lStructSize!**compiled accessors**!public! !
lStructSize:!**compiled accessors**!public! !
nCopies!**compiled accessors**!public! !
nCopies:!**compiled accessors**!public! !
nMaxPage!**compiled accessors**!public! !
nMaxPage:!**compiled accessors**!public! !
nMaxPageRanges!**compiled accessors**!public! !
nMaxPageRanges:!**compiled accessors**!public! !
nMinPage!**compiled accessors**!public! !
nMinPage:!**compiled accessors**!public! !
nPageRanges!**compiled accessors**!public! !
nPageRanges:!**compiled accessors**!public! !
nPropertyPages!**compiled accessors**!public! !
nPropertyPages:!**compiled accessors**!public! !
nStartPage!**compiled accessors**!public! !
nStartPage:!**compiled accessors**!public! !
!

!PRINTDLGEXW class methodsFor!

defineFields
	"Define the fields of the PRINTDLGEX structure.

	self compileDefinition

		typedef [uuid(46F06E70-1BB5-4B02-98EE-6AB442F3B43F)]
		struct tagPRINTDLGEX {
			DWORD lStructSize;
			HWND hwndOwner;
			HGLOBAL hDevMode;
			HGLOBAL hDevNames;
			HDC HDC;
			DWORD flags;
			DWORD Flags2;
			DWORD ExclusionFlags;
			DWORD nPageRanges;
			DWORD nMaxPageRanges;
			PRINTPAGERANGE* lpPageRanges;
			DWORD nMinPage;
			DWORD nMaxPage;
			DWORD nCopies;
			HINSTANCE HINSTANCE;
			LPCSTR lpPrintTemplateName;
			IUnknown* lpCallback;
			DWORD nPropertyPages;
			HPROPSHEETPAGE* lphPropertyPages;
			DWORD nStartPage;
			DWORD dwResultAction;
		} PRINTDLGEX;
"

	self
		defineField: #lStructSize type: DWORDField new;
		defineField: #hwndOwner type: HANDLEField new;
		defineField: #hDevMode type: HANDLEField new;
		defineField: #hDevNames type: HANDLEField new;
		defineField: #hDC type: HANDLEField new;
		defineField: #flags type: DWORDField new;
		defineField: #Flags2 type: DWORDField new;
		defineField: #ExclusionFlags type: DWORDField new;
		defineField: #nPageRanges type: DWORDField new;
		defineField: #nMaxPageRanges type: DWORDField new;
		defineField: #lpPageRanges type: (PointerField type: PRINTPAGERANGE);
		defineField: #nMinPage type: DWORDField new;
		defineField: #nMaxPage type: DWORDField new;
		defineField: #nCopies type: DWORDField new;
		defineField: #hInstance type: HANDLEField new;
		defineField: #lpPrintTemplateName type: (PointerField type: Utf16String);
		defineField: #lpCallback type: (PointerField type: IUnknown);
		defineField: #nPropertyPages type: DWORDField new;
		defineField: #lphPropertyPages type: (PointerField type: ExternalHandle);
		defineField: #nStartPage type: DWORDField new;
		defineField: #dwResultAction type: DWORDField new!

getFieldNames
	^#(#lStructSize #hwndOwner #hDevMode #hDevNames #hDC #flags #Flags2 #ExclusionFlags #nPageRanges #nMaxPageRanges #lpPageRanges #nMinPage #nMaxPage #nCopies #hInstance #lpPrintTemplateName #lpCallback #nPropertyPages #lphPropertyPages #nStartPage #dwResultAction)! !

!PRINTDLGEXW class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

