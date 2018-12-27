"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #CHOOSEFONTW
	instanceVariableNames: 'logFont'
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!
CHOOSEFONTW guid: (GUID fromString: '{87b4c5d2-026e-11d3-9fd7-00a0cc3e4a32}')!
CHOOSEFONTW comment: 'CHOOSEFONT is the class of <ExternalStructure> which represent the Windows Common Dialog structure of the same name.

CHOOSEFONT is used in conjunction with <FontDialog> to pop a common file dialog to select a font.
'!
!CHOOSEFONTW categoriesForClass!External-Data-Structured-Win32! !
!CHOOSEFONTW methodsFor!

color
	^Color fromInteger: self rgbColors!

color: aColor 
	self rgbColors: aColor asRGB asParameter!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anInteger!

hDC: anExternalHandle
	"Set the receiver's 'hDC' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hDC) put: anExternalHandle!

hookFlag
	^CF_ENABLEHOOK!

hwndOwner: anExternalHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner) put: anExternalHandle!

iPointSize
	"Answer the <Integer> value of the receiver's 'iPointSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #iPointSize)!

logFont
	^logFont!

logFont: aLOGFONT 
	logFont := aLOGFONT.
	self lpLogFont: aLOGFONT!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anExternalAddress!

lpLogFont
	"Answer the <LOGFONTW> value of the receiver's 'lpLogFont' field."

	^LOGFONTW fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpLogFont))!

lpLogFont: aLOGFONTW
	"Set the receiver's 'lpLogFont' field to the value of the argument, aLOGFONTW"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpLogFont) put: aLOGFONTW yourAddress!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

rgbColors
	"Answer the <Integer> value of the receiver's 'rgbColors' field."

	^bytes dwordAtOffset: ##(self offsetOf: #rgbColors)!

rgbColors: anInteger
	"Set the receiver's 'rgbColors' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #rgbColors) put: anInteger! !
!CHOOSEFONTW categoriesFor: #color!public! !
!CHOOSEFONTW categoriesFor: #color:!public! !
!CHOOSEFONTW categoriesFor: #dwSize:!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #flags!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #flags:!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #hDC:!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #hookFlag!accessing!public! !
!CHOOSEFONTW categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #iPointSize!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #logFont!private! !
!CHOOSEFONTW categoriesFor: #logFont:!private! !
!CHOOSEFONTW categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #lpLogFont!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #lpLogFont:!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #ownerView:!accessing!public! !
!CHOOSEFONTW categoriesFor: #rgbColors!**compiled accessors**!public! !
!CHOOSEFONTW categoriesFor: #rgbColors:!**compiled accessors**!public! !

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
!CHOOSEFONTW class categoriesFor: #defineFields!initializing!public! !
!CHOOSEFONTW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

