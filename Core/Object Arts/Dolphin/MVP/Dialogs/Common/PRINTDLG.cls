"Filed out from Dolphin Smalltalk X6"!

CommonDialogStructure subclass: #PRINTDLG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'PrintDialogConstants'
	classInstanceVariableNames: ''!
PRINTDLG guid: (GUID fromString: '{87B4C609-026E-11D3-9FD7-00A0CC3E4A32}')!
PRINTDLG comment: ''!
!PRINTDLG categoriesForClass!External-Data-Structured-Win32! !
!PRINTDLG methodsFor!

dwSize: anObject
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 20 put: anObject!

hDC
	"Answer the receiver's hDC field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

hDC: anObject
	"Set the receiver's hDC field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

hookFlag
	^PD_ENABLEPRINTHOOK!

hwndOwner: anObject
	"Set the receiver's hwndOwner field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

lpfnHook: anObject
	"Set the receiver's lpfnHook field to the value of anObject."

	bytes dwordAtOffset: 42 put: anObject!

nCopies
	"Answer the receiver's nCopies field as a Smalltalk object."

	^(bytes wordAtOffset: 32)!

nCopies: anObject
	"Set the receiver's nCopies field to the value of anObject."

	bytes wordAtOffset: 32 put: anObject!

nFromPage
	"Answer the receiver's nFromPage field as a Smalltalk object."

	^(bytes wordAtOffset: 24)!

nFromPage: anObject
	"Set the receiver's nFromPage field to the value of anObject."

	bytes wordAtOffset: 24 put: anObject!

nMaxPage: anObject
	"Set the receiver's nMaxPage field to the value of anObject."

	bytes wordAtOffset: 30 put: anObject!

nMinPage: anObject
	"Set the receiver's nMinPage field to the value of anObject."

	bytes wordAtOffset: 28 put: anObject!

nToPage
	"Answer the receiver's nToPage field as a Smalltalk object."

	^(bytes wordAtOffset: 26)!

nToPage: anObject
	"Set the receiver's nToPage field to the value of anObject."

	bytes wordAtOffset: 26 put: anObject!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].! !
!PRINTDLG categoriesFor: #dwSize:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #flags!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #flags:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #hDC!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #hDC:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #hookFlag!accessing!public! !
!PRINTDLG categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #nCopies!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #nCopies:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #nFromPage!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #nFromPage:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #nMaxPage:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #nMinPage:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #nToPage!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #nToPage:!**compiled accessors**!public! !
!PRINTDLG categoriesFor: #ownerView:!accessing!public! !

!PRINTDLG class methodsFor!

defineFields
	"Define the fields of the Win32 PRINTDLG structure.

		PRINTDLG compileDefinition

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
		LPCTSTR				lpPrintTemplateName;
		LPCTSTR				lpSetupTemplateName;
		HANDLE				hPrintTemplate;
		HANDLE				hSetupTemplate;
	} PRINTDLG;"

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
		defineField: #lpPrintTemplateName type: (PointerField type: String) beFiller;
		defineField: #lpSetupTemplateName type: (PointerField type: String) beFiller;
		defineField: #hPrintTemplate type: DWORDField filler;
		defineField: #hSetupTemplate type: DWORDField filler!

packing
	"Answer the default packing for instances of the receiver.
	This is the maximum alignment to which members of the structure
	after the first are padded. Each field type has a natural alignment
	(e.g. ints align to 32-bit boundaries), and it is the smaller of the
	packing and the natural alignment which is used to decide the
	padding necessary for the field in the structure.
	PRINTDLG is an old Win16 structure with byte packing."

	^1! !
!PRINTDLG class categoriesFor: #defineFields!initializing!public! !
!PRINTDLG class categoriesFor: #packing!constants!public! !

