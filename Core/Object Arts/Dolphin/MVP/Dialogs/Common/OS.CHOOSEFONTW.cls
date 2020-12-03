"Filed out from Dolphin Smalltalk 7"!

OS.CommonDialogStructure subclass: #'OS.CHOOSEFONTW'
	instanceVariableNames: 'logFont'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_flags' -> 16r14.
		'_OffsetOf_hDC' -> 16r8.
		'_OffsetOf_hInstance' -> 16r28.
		'_OffsetOf_hwndOwner' -> 16r4.
		'_OffsetOf_iPointSize' -> 16r10.
		'_OffsetOf_lCustData' -> 16r1C.
		'_OffsetOf_lpfnHook' -> 16r20.
		'_OffsetOf_lpLogFont' -> 16rC.
		'_OffsetOf_lpszStyle' -> 16r2C.
		'_OffsetOf_lpTemplateName' -> 16r24.
		'_OffsetOf_nFontType' -> 16r30.
		'_OffsetOf_nSizeMax' -> 16r38.
		'_OffsetOf_nSizeMin' -> 16r34.
		'_OffsetOf_rgbColors' -> 16r18
	}!
OS.CHOOSEFONTW guid: (Core.GUID fromString: '{87b4c5d2-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.CHOOSEFONTW comment: 'CHOOSEFONT is the class of <ExternalStructure> which represent the Windows Common Dialog structure of the same name.

CHOOSEFONT is used in conjunction with <FontDialog> to pop a common file dialog to select a font.
'!
!OS.CHOOSEFONTW categoriesForClass!External-Data-Structured-Win32! !
!OS.CHOOSEFONTW methodsFor!

color
	^Graphics.Color fromCOLORREF: self rgbColors!

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
!OS.CHOOSEFONTW categoriesFor: #color!public! !
!OS.CHOOSEFONTW categoriesFor: #color:!public! !
!OS.CHOOSEFONTW categoriesFor: #dwSize:!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #flags!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #flags:!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #hDC:!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #hookFlag!accessing!public! !
!OS.CHOOSEFONTW categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #iPointSize!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #logFont!private! !
!OS.CHOOSEFONTW categoriesFor: #logFont:!private! !
!OS.CHOOSEFONTW categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #lpLogFont!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #lpLogFont:!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #ownerView:!accessing!public! !
!OS.CHOOSEFONTW categoriesFor: #rgbColors!**compiled accessors**!public! !
!OS.CHOOSEFONTW categoriesFor: #rgbColors:!**compiled accessors**!public! !

!OS.CHOOSEFONTW class methodsFor!

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
!OS.CHOOSEFONTW class categoriesFor: #defineFields!public!template definition! !
!OS.CHOOSEFONTW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

