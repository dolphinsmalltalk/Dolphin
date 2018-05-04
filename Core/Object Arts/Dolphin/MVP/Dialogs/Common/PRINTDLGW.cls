"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #PRINTDLGW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'PrintDialogConstants'
	classInstanceVariableNames: ''!
PRINTDLGW guid: (GUID fromString: '{87b4c609-026e-11d3-9fd7-00a0cc3e4a32}')!
PRINTDLGW comment: ''!
!PRINTDLGW categoriesForClass!External-Data-Structured-Win32! !
!PRINTDLGW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anInteger!

hDC
	"Answer the <Integer> value of the receiver's 'hDC' field."

	^bytes dwordAtOffset: ##(self offsetOf: #hDC)!

hDC: anInteger
	"Set the receiver's 'hDC' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #hDC) put: anInteger!

hookFlag
	^PD_ENABLEPRINTHOOK!

hwndOwner: anInteger
	"Set the receiver's 'hwndOwner' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #hwndOwner) put: anInteger!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anExternalAddress!

nCopies
	"Answer the <Integer> value of the receiver's 'nCopies' field."

	^bytes wordAtOffset: ##(self offsetOf: #nCopies)!

nCopies: anInteger
	"Set the receiver's 'nCopies' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #nCopies) put: anInteger!

nFromPage
	"Answer the <Integer> value of the receiver's 'nFromPage' field."

	^bytes wordAtOffset: ##(self offsetOf: #nFromPage)!

nFromPage: anInteger
	"Set the receiver's 'nFromPage' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #nFromPage) put: anInteger!

nMaxPage: anInteger
	"Set the receiver's 'nMaxPage' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #nMaxPage) put: anInteger!

nMinPage: anInteger
	"Set the receiver's 'nMinPage' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #nMinPage) put: anInteger!

nToPage
	"Answer the <Integer> value of the receiver's 'nToPage' field."

	^bytes wordAtOffset: ##(self offsetOf: #nToPage)!

nToPage: anInteger
	"Set the receiver's 'nToPage' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #nToPage) put: anInteger!

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

packing
	"Answer the default packing for instances of the receiver.
	This is the maximum alignment to which members of the structure
	after the first are padded. Each field type has a natural alignment
	(e.g. ints align to 32-bit boundaries), and it is the smaller of the
	packing and the natural alignment which is used to decide the
	padding necessary for the field in the structure.
	PRINTDLG is an old Win16 structure with byte packing."

	^1! !
!PRINTDLGW class categoriesFor: #defineFields!initializing!public! !
!PRINTDLGW class categoriesFor: #packing!constants!public! !

