"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #CHOOSEFONT
	instanceVariableNames: 'logFont'
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!
CHOOSEFONT guid: (GUID fromString: '{87b4c5d2-026e-11d3-9fd7-00a0cc3e4a32}')!
CHOOSEFONT comment: 'CHOOSEFONT is the class of <ExternalStructure> which represent the Windows Common Dialog structure of the same name.

CHOOSEFONT is used in conjunction with <FontDialog> to pop a common file dialog to select a font.
'!
!CHOOSEFONT categoriesForClass!External-Data-Structured-Win32! !
!CHOOSEFONT methodsFor!

color
	^Color fromInteger: self rgbColors!

color: aColor 
	self rgbColors: aColor asRGB asParameter!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject 
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

hDC: anObject 
	"Set the receiver's hDC field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hDC) put: anObject!

hookFlag
	^CF_ENABLEHOOK!

hwndOwner: anObject 
	"Set the receiver's hwndOwner field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner) put: anObject!

iPointSize
	"Answer the receiver's iPointSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iPointSize)!

logFont
	^logFont!

logFont: aLOGFONT 
	logFont := aLOGFONT.
	self lpLogFont: aLOGFONT!

lpfnHook: anObject 
	"Set the receiver's lpfnHook field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anObject!

lpLogFont
	"Answer the receiver's lpLogFont field as a Smalltalk object."

	^LOGFONT fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpLogFont))!

lpLogFont: anObject 
	"Set the receiver's lpLogFont field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpLogFont) put: anObject yourAddress!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

rgbColors
	"Answer the receiver's rgbColors field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #rgbColors)!

rgbColors: anObject 
	"Set the receiver's rgbColors field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #rgbColors) put: anObject! !
!CHOOSEFONT categoriesFor: #color!public! !
!CHOOSEFONT categoriesFor: #color:!public! !
!CHOOSEFONT categoriesFor: #dwSize:!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #flags!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #flags:!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #hDC:!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #hookFlag!accessing!public! !
!CHOOSEFONT categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #iPointSize!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #logFont!private! !
!CHOOSEFONT categoriesFor: #logFont:!private! !
!CHOOSEFONT categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #lpLogFont!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #lpLogFont:!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #ownerView:!accessing!public! !
!CHOOSEFONT categoriesFor: #rgbColors!**compiled accessors**!public! !
!CHOOSEFONT categoriesFor: #rgbColors:!**compiled accessors**!public! !

!CHOOSEFONT class methodsFor!

defineFields
	"Define the fields of the Win32 CHOOSEFONT structure.

		CHOOSEFONT compileDefinition

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
		defineField: #lpLogFont type: (PointerField type: LOGFONT);
		defineField: #iPointSize type: DWORDField readOnly;
		defineField: #flags type: DWORDField new beOverride;
		defineField: #rgbColors type: DWORDField new;
		defineField: #lCustData type: INT_PTRField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName type: (PointerField type: String) beFiller;
		defineField: #hInstance type: HANDLEField filler;
		defineField: #lpszStyle type: (PointerField type: String) beUncompiled;
		defineField: #nFontType type: WORDField readOnly beUncompiled;
		defineField: #nSizeMin type: DWORDField writeOnly beUncompiled;
		defineField: #nSizeMax type: DWORDField writeOnly beUncompiled! !
!CHOOSEFONT class categoriesFor: #defineFields!initializing!public! !

