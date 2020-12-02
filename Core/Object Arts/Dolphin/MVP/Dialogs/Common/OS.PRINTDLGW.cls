"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #PRINTDLGW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'PrintDialogConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_flags' -> 16r14.
		'_OffsetOf_hDC' -> 16r10.
		'_OffsetOf_hDevMode' -> 16r8.
		'_OffsetOf_hDevNames' -> 16rC.
		'_OffsetOf_hInstance' -> 16r22.
		'_OffsetOf_hPrintTemplate' -> 16r3A.
		'_OffsetOf_hSetupTemplate' -> 16r3E.
		'_OffsetOf_hwndOwner' -> 16r4.
		'_OffsetOf_lCustData' -> 16r26.
		'_OffsetOf_lpfnHook' -> 16r2A.
		'_OffsetOf_lpfnSetupHook' -> 16r2E.
		'_OffsetOf_lpPrintTemplateName' -> 16r32.
		'_OffsetOf_lpSetupTemplateName' -> 16r36.
		'_OffsetOf_nCopies' -> 16r20.
		'_OffsetOf_nFromPage' -> 16r18.
		'_OffsetOf_nMaxPage' -> 16r1E.
		'_OffsetOf_nMinPage' -> 16r1C.
		'_OffsetOf_nToPage' -> 16r1A
	}!
PRINTDLGW guid: (GUID fromString: '{87b4c609-026e-11d3-9fd7-00a0cc3e4a32}')!
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
!PRINTDLGW categoriesFor: #dwSize:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #flags!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #flags:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #hDC!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #hDC:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #hookFlag!accessing!public! !
!PRINTDLGW categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #nCopies!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #nCopies:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #nFromPage!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #nFromPage:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #nMaxPage:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #nMinPage:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #nToPage!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #nToPage:!**compiled accessors**!public! !
!PRINTDLGW categoriesFor: #ownerView:!accessing!public! !

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
!PRINTDLGW class categoriesFor: #defineFields!public!template definition! !
!PRINTDLGW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!PRINTDLGW class categoriesFor: #packing!constants!public! !

