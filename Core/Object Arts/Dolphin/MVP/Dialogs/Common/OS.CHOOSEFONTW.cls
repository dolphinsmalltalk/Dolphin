"Filed out from Dolphin Smalltalk"!

OS.ComDlgStructure
	subclass: #'OS.CHOOSEFONTW'
	instanceVariableNames: 'logFont'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_CHOOSEFONTW_Size' -> 16r3C.
			'_OffsetOf_flags' -> 16r14.
			'_OffsetOf_hDC' -> 16r8.
			'_OffsetOf_hInstance' -> 16r28.
			'_OffsetOf_iPointSize' -> 16r10.
			'_OffsetOf_lCustData' -> 16r1C.
			'_OffsetOf_lpfnHook' -> 16r20.
			'_OffsetOf_lpLogFont' -> 16rC.
			'_OffsetOf_lpszStyle' -> 16r2C.
			'_OffsetOf_lpTemplateName' -> 16r24.
			'_OffsetOf_nFontType' -> 16r30.
			'_OffsetOf_nSizeMax' -> 16r38.
			'_OffsetOf_nSizeMin' -> 16r34.
			'_OffsetOf_rgbColors' -> 16r18.
			'CF_ANSIONLY' -> 16r400.
			'CF_APPLY' -> 16r200.
			'CF_BOTH' -> 16r3.
			'CF_EFFECTS' -> 16r100.
			'CF_ENABLEHOOK' -> 16r8.
			'CF_ENABLETEMPLATE' -> 16r10.
			'CF_ENABLETEMPLATEHANDLE' -> 16r20.
			'CF_FIXEDPITCHONLY' -> 16r4000.
			'CF_FORCEFONTEXIST' -> 16r10000.
			'CF_INITTOLOGFONTSTRUCT' -> 16r40.
			'CF_LIMITSIZE' -> 16r2000.
			'CF_NOFACESEL' -> 16r80000.
			'CF_NOOEMFONTS' -> 16r800.
			'CF_NOSCRIPTSEL' -> 16r800000.
			'CF_NOSIMULATIONS' -> 16r1000.
			'CF_NOSIZESEL' -> 16r200000.
			'CF_NOSTYLESEL' -> 16r100000.
			'CF_NOVECTORFONTS' -> 16r800.
			'CF_NOVERTFONTS' -> 16r1000000.
			'CF_PRINTERFONTS' -> 16r2.
			'CF_SCALABLEONLY' -> 16r20000.
			'CF_SCREENFONTS' -> 16r1.
			'CF_SCRIPTSONLY' -> 16r400.
			'CF_SELECTSCRIPT' -> 16r400000.
			'CF_SHOWHELP' -> 16r4.
			'CF_TTONLY' -> 16r40000.
			'CF_USESTYLE' -> 16r80.
			'CF_WYSIWYG' -> 16r8000
		}!

OS.CHOOSEFONTW guid: (Core.GUID fromString: '{87b4c5d2-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.CHOOSEFONTW comment: 'CHOOSEFONT is the class of <ExternalStructure> which represent the Windows Common Dialog structure of the same name.

CHOOSEFONT is used in conjunction with <FontDialog> to pop a common file dialog to select a font.
'!

!OS.CHOOSEFONTW categoriesForClass!External-Data-Structured-Win32! !

!OS.CHOOSEFONTW methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

hDC: aHandle
	"Set the receiver's 'hDC' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hDC put: aHandle!

hookFlag
	^CF_ENABLEHOOK!

iPointSize
	"Answer the <Integer> value of the receiver's 'iPointSize' field."

	^bytes uint32AtOffset: _OffsetOf_iPointSize!

logFont
	^logFont!

logFont: aLOGFONT 
	logFont := aLOGFONT.
	self lpLogFont: aLOGFONT!

lpfnHook: anAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anAddress!

lpLogFont
	"Answer the <LOGFONTW> value of the receiver's 'lpLogFont' field."

	^LOGFONTW fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpLogFont)!

lpLogFont: aLOGFONTW
	"Set the receiver's 'lpLogFont' field to the value of the argument, aLOGFONTW"

	bytes uintPtrAtOffset: _OffsetOf_lpLogFont put: aLOGFONTW yourAddress!

rgbColors
	"Answer the <Graphics.Color> value of the receiver's 'rgbColors' field."

	^Graphics.Color fromCOLORREF: (bytes uint32AtOffset: _OffsetOf_rgbColors)!

rgbColors: aColor
	"Set the receiver's 'rgbColors' field to the value of the argument, aColor"

	bytes uint32AtOffset: _OffsetOf_rgbColors put: aColor asCOLORREF! !

!OS.CHOOSEFONTW categoriesForMethods!
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hDC:!**compiled accessors**!public! !
hookFlag!accessing!private! !
iPointSize!**compiled accessors**!public! !
logFont!private! !
logFont:!private! !
lpfnHook:!**compiled accessors**!public! !
lpLogFont!**compiled accessors**!public! !
lpLogFont:!**compiled accessors**!public! !
rgbColors!**compiled accessors**!public! !
rgbColors:!**compiled accessors**!public! !
!

!OS.CHOOSEFONTW class methodsFor!

byteSize
	^_CHOOSEFONTW_Size!

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
		COLORREF	rgbColors;
		LPARAM		lCustData;
		LPCFHOOKPROC	lpfnHook;
		LPCTSTR		lpTemplateName;
		HINSTANCE	hInstance;
		LPTSTR		lpszStyle;
		WORD		nFontType;		// N.B. Packing required after this
		INT			nSizeMin;
		INT			nSizeMax;
	} CHOOSEFONT;"

	super defineFields.
	self
		defineField: #hDC type: HANDLEField writeOnly;
		defineField: #lpLogFont type: (PointerField type: LOGFONTW);
		defineField: #iPointSize type: UInt32Field readOnly;
		defineField: #flags type: UInt32Field new beOverride;
		defineField: #rgbColors type: COLORREFField new;
		defineField: #lCustData type: IntPtrField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName type: (PointerField type: Utf16String) beFiller;
		defineField: #hInstance type: HANDLEField filler;
		defineField: #lpszStyle type: (PointerField type: Utf16String) beUncompiled;
		defineField: #nFontType type: UInt16Field readOnly beUncompiled;
		defineField: #nSizeMin type: UInt32Field writeOnly beUncompiled;
		defineField: #nSizeMax type: UInt32Field writeOnly beUncompiled!

getFieldNames
	^#(#dwSize #hwndOwner #hDC #lpLogFont #iPointSize #flags #rgbColors #lpfnHook #lpszStyle #nFontType #nSizeMin #nSizeMax)! !

!OS.CHOOSEFONTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

