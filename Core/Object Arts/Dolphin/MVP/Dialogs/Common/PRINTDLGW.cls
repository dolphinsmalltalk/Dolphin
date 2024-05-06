"Filed out from Dolphin Smalltalk"!

CommonDialogStructure subclass: #PRINTDLGW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_flags _OffsetOf_hDC _OffsetOf_hDevMode _OffsetOf_hDevNames _OffsetOf_hInstance _OffsetOf_hPrintTemplate _OffsetOf_hSetupTemplate _OffsetOf_hwndOwner _OffsetOf_lCustData _OffsetOf_lpfnHook _OffsetOf_lpfnSetupHook _OffsetOf_lpPrintTemplateName _OffsetOf_lpSetupTemplateName _OffsetOf_nCopies _OffsetOf_nFromPage _OffsetOf_nMaxPage _OffsetOf_nMinPage _OffsetOf_nToPage'
	poolDictionaries: 'PrintDialogConstants'
	classInstanceVariableNames: ''!

PRINTDLGW guid: (GUID fromString: '{87b4c609-026e-11d3-9fd7-00a0cc3e4a32}')!

PRINTDLGW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
PRINTDLGW addClassConstant: '_OffsetOf_flags' value: 16r14!
PRINTDLGW addClassConstant: '_OffsetOf_hDC' value: 16r10!
PRINTDLGW addClassConstant: '_OffsetOf_hDevMode' value: 16r8!
PRINTDLGW addClassConstant: '_OffsetOf_hDevNames' value: 16rC!
PRINTDLGW addClassConstant: '_OffsetOf_hInstance' value: 16r22!
PRINTDLGW addClassConstant: '_OffsetOf_hPrintTemplate' value: 16r3A!
PRINTDLGW addClassConstant: '_OffsetOf_hSetupTemplate' value: 16r3E!
PRINTDLGW addClassConstant: '_OffsetOf_hwndOwner' value: 16r4!
PRINTDLGW addClassConstant: '_OffsetOf_lCustData' value: 16r26!
PRINTDLGW addClassConstant: '_OffsetOf_lpfnHook' value: 16r2A!
PRINTDLGW addClassConstant: '_OffsetOf_lpfnSetupHook' value: 16r2E!
PRINTDLGW addClassConstant: '_OffsetOf_lpPrintTemplateName' value: 16r32!
PRINTDLGW addClassConstant: '_OffsetOf_lpSetupTemplateName' value: 16r36!
PRINTDLGW addClassConstant: '_OffsetOf_nCopies' value: 16r20!
PRINTDLGW addClassConstant: '_OffsetOf_nFromPage' value: 16r18!
PRINTDLGW addClassConstant: '_OffsetOf_nMaxPage' value: 16r1E!
PRINTDLGW addClassConstant: '_OffsetOf_nMinPage' value: 16r1C!
PRINTDLGW addClassConstant: '_OffsetOf_nToPage' value: 16r1A!

PRINTDLGW comment: ''!

!PRINTDLGW categoriesForClass!External-Data-Structured-Win32! !

!PRINTDLGW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_flags put: anInteger!

hDC
	"Answer the <Integer> value of the receiver's 'hDC' field."

	^bytes dwordAtOffset: _OffsetOf_hDC!

hDC: anInteger
	"Set the receiver's 'hDC' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hDC put: anInteger!

hookFlag
	^PD_ENABLEPRINTHOOK!

hwndOwner: anInteger
	"Set the receiver's 'hwndOwner' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hwndOwner put: anInteger!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anExternalAddress!

nCopies
	"Answer the <Integer> value of the receiver's 'nCopies' field."

	^bytes wordAtOffset: _OffsetOf_nCopies!

nCopies: anInteger
	"Set the receiver's 'nCopies' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_nCopies put: anInteger!

nFromPage
	"Answer the <Integer> value of the receiver's 'nFromPage' field."

	^bytes wordAtOffset: _OffsetOf_nFromPage!

nFromPage: anInteger
	"Set the receiver's 'nFromPage' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_nFromPage put: anInteger!

nMaxPage: anInteger
	"Set the receiver's 'nMaxPage' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_nMaxPage put: anInteger!

nMinPage: anInteger
	"Set the receiver's 'nMinPage' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_nMinPage put: anInteger!

nToPage
	"Answer the <Integer> value of the receiver's 'nToPage' field."

	^bytes wordAtOffset: _OffsetOf_nToPage!

nToPage: anInteger
	"Set the receiver's 'nToPage' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_nToPage put: anInteger!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].! !

!PRINTDLGW categoriesForMethods!
dwSize:!**compiled accessors**!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hDC!**compiled accessors**!public! !
hDC:!**compiled accessors**!public! !
hookFlag!accessing!public! !
hwndOwner:!**compiled accessors**!public! !
lpfnHook:!**compiled accessors**!public! !
nCopies!**compiled accessors**!public! !
nCopies:!**compiled accessors**!public! !
nFromPage!**compiled accessors**!public! !
nFromPage:!**compiled accessors**!public! !
nMaxPage:!**compiled accessors**!public! !
nMinPage:!**compiled accessors**!public! !
nToPage!**compiled accessors**!public! !
nToPage:!**compiled accessors**!public! !
ownerView:!accessing!public! !
!

!PRINTDLGW class methodsFor!

defineFields
	"Define the fields of the Win32 PRINTDLGW structure.

		self compileDefinition

	typedef struct tagPD {  // pd  
		DWORD				lStructSize;
		HWND				hwndOwner;
		HANDLE				hDevMode;
		HANDLE				hDevNames;
		HDC					hDC;
		DWORD				Flags;
		WORD				nFromPage;
		WORD				nToPage;
		WORD				nMinPage;
		WORD				nMaxPage;
		WORD				nCopies;
		HINSTANCE			hInstance;
		DWORD				lCustData;
		LPPRINTHOOKPROC	lpfnPrintHook;
		LPSETUPHOOKPROC	lpfnSetupHook;
		LPCWSTR				lpPrintTemplateName;
		LPCWSTR				lpSetupTemplateName;
		HANDLE				hPrintTemplate;
		HANDLE				hSetupTemplate;
	} PRINTDLGW;"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner type: DWORDField writeOnly;
		defineField: #hDevMode type: DWORDField new beUncompiled;
		defineField: #hDevNames type: DWORDField new beUncompiled;
		defineField: #hDC type: DWORDField new;
		defineField: #flags type: DWORDField new beOverride;
		defineField: #nFromPage type: WORDField new;
		defineField: #nToPage type: WORDField new;
		defineField: #nMinPage type: WORDField writeOnly;
		defineField: #nMaxPage type: WORDField writeOnly;
		defineField: #nCopies type: WORDField new;
		defineField: #hInstance type: DWORDField filler;
		defineField: #lCustData type: DWORDField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpfnSetupHook type: (PointerField type: ExternalAddress) beFiller;
		defineField: #lpPrintTemplateName type: (PointerField type: Utf16String) beFiller;
		defineField: #lpSetupTemplateName type: (PointerField type: Utf16String) beFiller;
		defineField: #hPrintTemplate type: DWORDField filler;
		defineField: #hSetupTemplate type: DWORDField filler!

getFieldNames
	^#(#dwSize #hwndOwner #hDevMode #hDevNames #hDC #flags #nFromPage #nToPage #nMinPage #nMaxPage #nCopies #lpfnHook)!

packing
	"Answer the default packing for instances of the receiver.
	This is the maximum alignment to which members of the structure
	after the first are padded. Each field type has a natural alignment
	(e.g. ints align to 32-bit boundaries), and it is the smaller of the
	packing and the natural alignment which is used to decide the
	padding necessary for the field in the structure.
	PRINTDLG is an old Win16 structure with byte packing."

	^1! !

!PRINTDLGW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

