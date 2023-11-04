"Filed out from Dolphin Smalltalk"!

OS.CommonDialogStructure
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
	"Answer the <Integer> value of the receiver's 'rgbColors' field."

	^bytes uint32AtOffset: _OffsetOf_rgbColors!

rgbColors: anInteger
	"Set the receiver's 'rgbColors' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_rgbColors put: anInteger! !
!OS.CHOOSEFONTW categoriesForMethods!
color!public! !
color:!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hDC:!**compiled accessors**!public! !
hookFlag!accessing!public! !
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

	super defineFields.
	self
		defineField: #hDC type: HANDLEField writeOnly;
		defineField: #lpLogFont type: (PointerField type: LOGFONTW);
		defineField: #iPointSize type: UInt32Field readOnly;
		defineField: #flags type: UInt32Field new beOverride;
		defineField: #rgbColors type: UInt32Field new;
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

