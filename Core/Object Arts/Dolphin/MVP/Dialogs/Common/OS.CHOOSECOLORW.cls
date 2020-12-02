"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #CHOOSECOLORW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_flags' -> 16r14.
		'_OffsetOf_hInstance' -> 16r8.
		'_OffsetOf_hwndOwner' -> 16r4.
		'_OffsetOf_lCustData' -> 16r18.
		'_OffsetOf_lpCustColors' -> 16r10.
		'_OffsetOf_lpfnHook' -> 16r1C.
		'_OffsetOf_lpTemplateName' -> 16r20.
		'_OffsetOf_rgbResult' -> 16rC
	}!
CHOOSECOLORW guid: (GUID fromString: '{87b4c5d1-026e-11d3-9fd7-00a0cc3e4a32}')!
CHOOSECOLORW comment: '<CHOOSECOLOR> is an <ExternalStructure> class to wrap the struct ''Win32.CHOOSECOLOR'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"CHOOSECOLOR is used in conjunction with <ColorDialog> to pop a common file dialog to select a colour."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(87b4c5d1-026e-11d3-9fd7-00a0cc3e4a32), helpstring("CHOOSECOLOR is used in conjunction with <ColorDialog> to pop a common file dialog to select a colour.")]
struct tagCHOOSECOLOR {
	[restricted] DWORD dwSize;
	[restricted] HWND hwndOwner;
	[restricted] HWND hInstance;
	COLORREF rgbResult;
	COLORREF[16]* lpCustColors;
	DWORD flags;
	[hidden] LPARAM lCustData;
	[restricted] LPCCHOOKPROC lpfnHook;
	[hidden] LPSTR lpTemplateName;
} CHOOSECOLOR;
'!
!CHOOSECOLORW categoriesForClass!Win32-Structs! !
!CHOOSECOLORW methodsFor!

color
	"Answer the chosen colour."

	^Color fromCOLORREF: self rgbResult!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_flags put: anInteger!

hInstance: anExternalHandle
	"Set the receiver's 'hInstance' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hInstance put: anExternalHandle!

hookFlag
	^CC_ENABLEHOOK!

hwndOwner: anExternalHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndOwner put: anExternalHandle!

lpCustColors
	"Answer the <DWORDArray> value of the receiver's 'lpCustColors' field."

	^DWORDArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpCustColors) length: 16!

lpCustColors: aDWORDArray
	"Set the receiver's 'lpCustColors' field to the value of the argument, aDWORDArray"

	bytes uintPtrAtOffset: _OffsetOf_lpCustColors put: aDWORDArray yourAddress!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anExternalAddress!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

rgbResult
	"Answer the <Integer> value of the receiver's 'rgbResult' field."

	^bytes dwordAtOffset: _OffsetOf_rgbResult!

rgbResult: anInteger
	"Set the receiver's 'rgbResult' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_rgbResult put: anInteger! !
!CHOOSECOLORW categoriesFor: #color!accessing!public! !
!CHOOSECOLORW categoriesFor: #dwSize:!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #flags!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #flags:!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #hInstance:!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #hookFlag!constants!public! !
!CHOOSECOLORW categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #lpCustColors!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #lpCustColors:!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #ownerView:!accessing!public! !
!CHOOSECOLORW categoriesFor: #rgbResult!**compiled accessors**!public! !
!CHOOSECOLORW categoriesFor: #rgbResult:!**compiled accessors**!public! !

!CHOOSECOLORW class methodsFor!

defineFields
	"Define the fields of the CHOOSECOLOR structure.

	self compileDefinition

		typedef [uuid(87b4c5d1-026e-11d3-9fd7-00a0cc3e4a32), helpstring('CHOOSECOLOR is used in conjunction with <ColorDialog> to pop a common file dialog to select a colour.')]
		struct tagCHOOSECOLOR {
			[restricted] DWORD dwSize;
			[restricted] HWND hwndOwner;
			[restricted] HWND hInstance;
			COLORREF rgbResult;
			COLORREF[16]* lpCustColors;
			DWORD flags;
			[hidden] LPARAM lCustData;
			[restricted] LPCCHOOKPROC lpfnHook;
			[hidden] LPWSTR lpTemplateName;
		} CHOOSECOLOR;
"

	self
		defineField: #dwSize type: DWORDField new beWriteOnly offset: 0;
		defineField: #hwndOwner type: HANDLEField new beWriteOnly offset: 4;
		defineField: #hInstance type: HANDLEField new beWriteOnly offset: 8;
		defineField: #rgbResult type: DWORDField new offset: 12;
		defineField: #lpCustColors type: (ArrayPointerField type: DWORDArray length: 16) offset: 16;
		defineField: #flags type: DWORDField new offset: 20;
		defineField: #lCustData type: INT_PTRField new beFiller offset: 24;
		defineField: #lpfnHook type: LPVOIDField new beWriteOnly offset: 28;
		defineField: #lpTemplateName type: (PointerField type: Utf16String) beFiller offset: 32.
	self byteSize: 36!

getFieldNames
	^#(#dwSize #hwndOwner #hInstance #rgbResult #lpCustColors #flags #lpfnHook)! !
!CHOOSECOLORW class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!CHOOSECOLORW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

