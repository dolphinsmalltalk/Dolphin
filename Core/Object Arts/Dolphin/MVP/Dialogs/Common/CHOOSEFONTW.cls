"Filed out from Dolphin Smalltalk"!

CommonDialogStructure subclass: #CHOOSEFONTW
	instanceVariableNames: 'logFont'
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_flags _OffsetOf_hDC _OffsetOf_hInstance _OffsetOf_hwndOwner _OffsetOf_iPointSize _OffsetOf_lCustData _OffsetOf_lpfnHook _OffsetOf_lpLogFont _OffsetOf_lpszStyle _OffsetOf_lpTemplateName _OffsetOf_nFontType _OffsetOf_nSizeMax _OffsetOf_nSizeMin _OffsetOf_rgbColors'
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!

CHOOSEFONTW guid: (GUID fromString: '{87b4c5d2-026e-11d3-9fd7-00a0cc3e4a32}')!

CHOOSEFONTW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
CHOOSEFONTW addClassConstant: '_OffsetOf_flags' value: 16r14!
CHOOSEFONTW addClassConstant: '_OffsetOf_hDC' value: 16r8!
CHOOSEFONTW addClassConstant: '_OffsetOf_hInstance' value: 16r28!
CHOOSEFONTW addClassConstant: '_OffsetOf_hwndOwner' value: 16r4!
CHOOSEFONTW addClassConstant: '_OffsetOf_iPointSize' value: 16r10!
CHOOSEFONTW addClassConstant: '_OffsetOf_lCustData' value: 16r1C!
CHOOSEFONTW addClassConstant: '_OffsetOf_lpfnHook' value: 16r20!
CHOOSEFONTW addClassConstant: '_OffsetOf_lpLogFont' value: 16rC!
CHOOSEFONTW addClassConstant: '_OffsetOf_lpszStyle' value: 16r2C!
CHOOSEFONTW addClassConstant: '_OffsetOf_lpTemplateName' value: 16r24!
CHOOSEFONTW addClassConstant: '_OffsetOf_nFontType' value: 16r30!
CHOOSEFONTW addClassConstant: '_OffsetOf_nSizeMax' value: 16r38!
CHOOSEFONTW addClassConstant: '_OffsetOf_nSizeMin' value: 16r34!
CHOOSEFONTW addClassConstant: '_OffsetOf_rgbColors' value: 16r18!

CHOOSEFONTW comment: 'CHOOSEFONT is the class of <ExternalStructure> which represent the Windows Common Dialog structure of the same name.

CHOOSEFONT is used in conjunction with <FontDialog> to pop a common file dialog to select a font.
'!

!CHOOSEFONTW categoriesForClass!External-Data-Structured-Win32! !

!CHOOSEFONTW methodsFor!

color
	^Color fromCOLORREF: self rgbColors!

color: aColor 
	self rgbColors: aColor asCOLORREF!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_flags put: anInteger!

hDC: anExternalHandle
	"Set the receiver's 'hDC' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hDC put: anExternalHandle!

hookFlag
	^CF_ENABLEHOOK!

hwndOwner: anExternalHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndOwner put: anExternalHandle!

iPointSize
	"Answer the <Integer> value of the receiver's 'iPointSize' field."

	^bytes dwordAtOffset: _OffsetOf_iPointSize!

logFont
	^logFont!

logFont: aLOGFONT 
	logFont := aLOGFONT.
	self lpLogFont: aLOGFONT!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anExternalAddress!

lpLogFont
	"Answer the <LOGFONTW> value of the receiver's 'lpLogFont' field."

	^LOGFONTW fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpLogFont)!

lpLogFont: aLOGFONTW
	"Set the receiver's 'lpLogFont' field to the value of the argument, aLOGFONTW"

	bytes uintPtrAtOffset: _OffsetOf_lpLogFont put: aLOGFONTW yourAddress!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

rgbColors
	"Answer the <Integer> value of the receiver's 'rgbColors' field."

	^bytes dwordAtOffset: _OffsetOf_rgbColors!

rgbColors: anInteger
	"Set the receiver's 'rgbColors' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_rgbColors put: anInteger! !

!CHOOSEFONTW categoriesForMethods!
color!public! !
color:!public! !
dwSize:!**compiled accessors**!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hDC:!**compiled accessors**!public! !
hookFlag!accessing!public! !
hwndOwner:!**compiled accessors**!public! !
iPointSize!**compiled accessors**!public! !
logFont!private! !
logFont:!private! !
lpfnHook:!**compiled accessors**!public! !
lpLogFont!**compiled accessors**!public! !
lpLogFont:!**compiled accessors**!public! !
ownerView:!accessing!public! !
rgbColors!**compiled accessors**!public! !
rgbColors:!**compiled accessors**!public! !
!

!CHOOSEFONTW class methodsFor!

defineFields
	"Define the fields of the Win32 CHOOSEFONTW structure.

		self compileDefinition

	typedef struct	{
		DWORD		lStructSize;
		HWND		hwndOwner;
		HDC			hDC;
		LPLOGFONT	lpLogFont;
		INT			iPointSize;
		DWORD		Flags;
		DWORD		rgbColors;
		LPARAM		lCustData;
		LPCFHOOKPROC	lpfnHook;
		LPCTSTR		lpTemplateName;
		HINSTANCE	hInstance;
		LPTSTR		lpszStyle;
		WORD		nFontType;		// N.B. Packing required after this
		INT			nSizeMin;
		INT			nSizeMax;
	} CHOOSEFONT;"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner type: HANDLEField writeOnly;
		defineField: #hDC type: HANDLEField writeOnly;
		defineField: #lpLogFont type: (PointerField type: LOGFONTW);
		defineField: #iPointSize type: DWORDField readOnly;
		defineField: #flags type: DWORDField new beOverride;
		defineField: #rgbColors type: DWORDField new;
		defineField: #lCustData type: INT_PTRField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName type: (PointerField type: Utf16String) beFiller;
		defineField: #hInstance type: HANDLEField filler;
		defineField: #lpszStyle type: (PointerField type: Utf16String) beUncompiled;
		defineField: #nFontType type: WORDField readOnly beUncompiled;
		defineField: #nSizeMin type: DWORDField writeOnly beUncompiled;
		defineField: #nSizeMax type: DWORDField writeOnly beUncompiled!

getFieldNames
	^#(#dwSize #hwndOwner #hDC #lpLogFont #iPointSize #flags #rgbColors #lpfnHook #lpszStyle #nFontType #nSizeMin #nSizeMax)! !

!CHOOSEFONTW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

