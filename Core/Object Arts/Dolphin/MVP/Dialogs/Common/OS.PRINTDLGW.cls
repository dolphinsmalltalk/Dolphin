"Filed out from Dolphin Smalltalk"!

OS.CommonDialogStructure
	subclass: #'OS.PRINTDLGW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.PrintDialogConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_flags' -> 16r14.
			'_OffsetOf_hDC' -> 16r10.
			'_OffsetOf_hDevMode' -> 16r8.
			'_OffsetOf_hDevNames' -> 16rC.
			'_OffsetOf_hInstance' -> 16r22.
			'_OffsetOf_hPrintTemplate' -> 16r3A.
			'_OffsetOf_hSetupTemplate' -> 16r3E.
			'_OffsetOf_lCustData' -> 16r26.
			'_OffsetOf_lpfnHook' -> 16r2A.
			'_OffsetOf_lpfnSetupHook' -> 16r2E.
			'_OffsetOf_lpPrintTemplateName' -> 16r32.
			'_OffsetOf_lpSetupTemplateName' -> 16r36.
			'_OffsetOf_nCopies' -> 16r20.
			'_OffsetOf_nFromPage' -> 16r18.
			'_OffsetOf_nMaxPage' -> 16r1E.
			'_OffsetOf_nMinPage' -> 16r1C.
			'_OffsetOf_nToPage' -> 16r1A.
			'_PRINTDLGW_Size' -> 16r42
		}!
OS.PRINTDLGW guid: (Core.GUID fromString: '{87b4c609-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.PRINTDLGW comment: ''!
!OS.PRINTDLGW categoriesForClass!External-Data-Structured-Win32! !
!OS.PRINTDLGW methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

hDC
	"Answer the <Integer> value of the receiver's 'hDC' field."

	^bytes uint32AtOffset: _OffsetOf_hDC!

hDC: anInteger
	"Set the receiver's 'hDC' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_hDC put: anInteger!

hookFlag
	^PD_ENABLEPRINTHOOK!

lpfnHook: anAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anAddress!

nCopies
	"Answer the <Integer> value of the receiver's 'nCopies' field."

	^bytes uint16AtOffset: _OffsetOf_nCopies!

nCopies: anInteger
	"Set the receiver's 'nCopies' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_nCopies put: anInteger!

nFromPage
	"Answer the <Integer> value of the receiver's 'nFromPage' field."

	^bytes uint16AtOffset: _OffsetOf_nFromPage!

nFromPage: anInteger
	"Set the receiver's 'nFromPage' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_nFromPage put: anInteger!

nMaxPage: anInteger
	"Set the receiver's 'nMaxPage' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_nMaxPage put: anInteger!

nMinPage: anInteger
	"Set the receiver's 'nMinPage' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_nMinPage put: anInteger!

nToPage
	"Answer the <Integer> value of the receiver's 'nToPage' field."

	^bytes uint16AtOffset: _OffsetOf_nToPage!

nToPage: anInteger
	"Set the receiver's 'nToPage' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_nToPage put: anInteger! !
!OS.PRINTDLGW categoriesForMethods!
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hDC!**compiled accessors**!public! !
hDC:!**compiled accessors**!public! !
hookFlag!accessing!public! !
lpfnHook:!**compiled accessors**!public! !
nCopies!**compiled accessors**!public! !
nCopies:!**compiled accessors**!public! !
nFromPage!**compiled accessors**!public! !
nFromPage:!**compiled accessors**!public! !
nMaxPage:!**compiled accessors**!public! !
nMinPage:!**compiled accessors**!public! !
nToPage!**compiled accessors**!public! !
nToPage:!**compiled accessors**!public! !
!

!OS.PRINTDLGW class methodsFor!

byteSize
	^_PRINTDLGW_Size!

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

	super defineFields.
	self
		defineField: #hDevMode type: UInt32Field new beUncompiled;
		defineField: #hDevNames type: UInt32Field new beUncompiled;
		defineField: #hDC type: UInt32Field new;
		defineField: #flags type: UInt32Field new beOverride;
		defineField: #nFromPage type: UInt16Field new;
		defineField: #nToPage type: UInt16Field new;
		defineField: #nMinPage type: UInt16Field writeOnly;
		defineField: #nMaxPage type: UInt16Field writeOnly;
		defineField: #nCopies type: UInt16Field new;
		defineField: #hInstance type: UInt32Field filler;
		defineField: #lCustData type: UInt32Field filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpfnSetupHook type: (PointerField type: Address) beFiller;
		defineField: #lpPrintTemplateName type: (PointerField type: Utf16String) beFiller;
		defineField: #lpSetupTemplateName type: (PointerField type: Utf16String) beFiller;
		defineField: #hPrintTemplate type: UInt32Field filler;
		defineField: #hSetupTemplate type: UInt32Field filler!

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
!OS.PRINTDLGW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

