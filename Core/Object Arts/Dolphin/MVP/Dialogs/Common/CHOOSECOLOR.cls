"Filed out from Dolphin Smalltalk X6.1"!

CommonDialogStructure subclass: #CHOOSECOLOR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!
CHOOSECOLOR guid: (GUID fromString: '{87B4C5D1-026E-11D3-9FD7-00A0CC3E4A32}')!
CHOOSECOLOR comment: 'CHOOSECOLOR is the class of <ExternalStructure> which represent the Windows Common Dialog structure of the same name.

CHOOSECOLOR is used in conjunction with <ColorDialog> to pop a common file dialog to select a colour.

Instance Variables:
	None'!
!CHOOSECOLOR categoriesForClass!External-Data-Structured-Win32! !
!CHOOSECOLOR methodsFor!

color
	"Answer the chosen colour."

	^Color fromInteger: self rgbResult!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject 
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

hInstance: anObject 
	"Set the receiver's hInstance field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hInstance) put: anObject!

hookFlag
	^CC_ENABLEHOOK!

hwndOwner: anObject 
	"Set the receiver's hwndOwner field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner) put: anObject!

lpCustColors: anObject 
	"Set the receiver's lpCustColors field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpCustColors) put: anObject yourAddress!

lpfnHook: anObject 
	"Set the receiver's lpfnHook field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anObject!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

rgbResult
	"Answer the receiver's rgbResult field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #rgbResult)!

rgbResult: anObject 
	"Set the receiver's rgbResult field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #rgbResult) put: anObject! !
!CHOOSECOLOR categoriesFor: #color!accessing!public! !
!CHOOSECOLOR categoriesFor: #dwSize:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #flags!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #flags:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #hInstance:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #hookFlag!constants!public! !
!CHOOSECOLOR categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #lpCustColors:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #ownerView:!accessing!public! !
!CHOOSECOLOR categoriesFor: #rgbResult!**compiled accessors**!public! !
!CHOOSECOLOR categoriesFor: #rgbResult:!**compiled accessors**!public! !

!CHOOSECOLOR class methodsFor!

defineFields
	"Define the fields of the Win32 CHOOSECOLOR structure.

		CHOOSECOLOR compileDefinition

	typedef struct {   // cc  
		DWORD		lStructSize;
		HWND			hwndOwner;
		HWND			hInstance;
		COLORREF		rgbResult;
		COLORREF*		lpCustColors;
		DWORD		Flags;
		LPARAM		lCustData;
		LPCCHOOKPROC	lpfnHook;
		LPCTSTR		lpTemplateName;
		} CHOOSECOLOR;"

	self 
		defineField: #dwSize			type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner			type: HANDLEField writeOnly;
		defineField: #hInstance			type: HANDLEField writeOnly;
		defineField: #rgbResult			type: DWORDField new;
		defineField: #lpCustColors		type: (ArrayPointerField type: DWORDArray length: 16) beWriteOnly;
		defineField: #flags				type: DWORDField new beOverride;
		defineField: #lCustData			type: INT_PTRField filler;
		defineField: #lpfnHook			type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName		type: (PointerField type: String) beFiller! !
!CHOOSECOLOR class categoriesFor: #defineFields!initializing!public! !

