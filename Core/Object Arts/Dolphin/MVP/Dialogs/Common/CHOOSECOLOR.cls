"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #CHOOSECOLOR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!
CHOOSECOLOR guid: (GUID fromString: '{87b4c5d1-026e-11d3-9fd7-00a0cc3e4a32}')!
CHOOSECOLOR comment: '<CHOOSECOLOR> is an <ExternalStructure> class to wrap the struct ''Win32.CHOOSECOLOR'' from type information in the ''Win32 API'' library.

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
!CHOOSECOLOR categoriesForClass!Win32-Structs! !
!CHOOSECOLOR methodsFor!

color
	"Answer the chosen colour."

	^Color fromInteger: self rgbResult!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anInteger!

hInstance: anExternalHandle
	"Set the receiver's 'hInstance' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hInstance) put: anExternalHandle!

hookFlag
	^CC_ENABLEHOOK!

hwndOwner: anExternalHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner) put: anExternalHandle!

lpCustColors
	"Answer the <DWORDArray> value of the receiver's 'lpCustColors' field."

	^DWORDArray fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpCustColors)) length: 16!

lpCustColors: aDWORDArray
	"Set the receiver's 'lpCustColors' field to the value of the argument, aDWORDArray"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpCustColors) put: aDWORDArray yourAddress!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anExternalAddress!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

rgbResult
	"Answer the <Integer> value of the receiver's 'rgbResult' field."

	^bytes dwordAtOffset: ##(self offsetOf: #rgbResult)!

rgbResult: anInteger
	"Set the receiver's 'rgbResult' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #rgbResult) put: anInteger! !
!CHOOSECOLOR categoriesFor: #color!accessing!public! !
!CHOOSECOLOR categoriesFor: #dwSize:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #flags!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #flags:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #hInstance:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #hookFlag!constants!public! !
!CHOOSECOLOR categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #lpCustColors!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #lpCustColors:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #ownerView:!accessing!public! !
!CHOOSECOLOR categoriesFor: #rgbResult!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #rgbResult:!**compiled accessors**!public! !

!CHOOSECOLOR class methodsFor!

defineFields
	"Define the fields of the CHOOSECOLOR structure.

	CHOOSECOLOR compileDefinition

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
			[hidden] LPSTR lpTemplateName;
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
		defineField: #lpTemplateName type: (PointerField type: String) beFiller offset: 32.
	self byteSize: 36! !
!CHOOSECOLOR class categoriesFor: #defineFields!**auto generated**!initializing!public! !

