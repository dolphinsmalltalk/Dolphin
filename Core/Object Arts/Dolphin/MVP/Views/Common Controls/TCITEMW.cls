"Filed out from Dolphin Smalltalk 7"!

CCITEM subclass: #TCITEMW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'TabViewConstants'
	classInstanceVariableNames: ''!
TCITEMW guid: (GUID fromString: '{87b4c621-026e-11d3-9fd7-00a0cc3e4a32}')!
TCITEMW comment: 'TCITEM is an <ExternalStructure> class which represents the Windows common control structure of the same name.

TCITEM is used to communicate information about the items (tabs) in a Tab Control.

    typedef [uuid(3264BE55-8AF9-47AE-889A-3CE56B575CA4)] struct TCITEMA
    {
        UINT mask;
        DWORD dwState;
        DWORD dwStateMask;
        LPTSTR pszText;
        int cchTextMax;
        int iImage;

        LPARAM	lParam;  
    } TCITEMA, *LPTCITEMA;'!
!TCITEMW categoriesForClass!External-Data-Structured-Win32! !
!TCITEMW methodsFor!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax)!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax) put: anInteger!

cchTextMaxOffset
	^##(self offsetOf: #cchTextMax)!

dwState
	"Answer the <Integer> value of the receiver's 'dwState' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwState)!

dwState: anInteger
	"Set the receiver's 'dwState' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwState) put: anInteger!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self shouldNotImplement!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anInteger!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: ##(self offsetOf: #lParam)!

lParam: anInteger
	"Set the receiver's 'lParam' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: ##(self offsetOf: #lParam) put: anInteger!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the lParam
	field has valid contents."

	^TCIF_PARAM!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #pszText) put: anUtf16String yourAddress!

stateMask
	"Answer the <Integer> value of the receiver's 'stateMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #stateMask)!

stateMask: anInteger
	"Set the receiver's 'stateMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #stateMask) put: anInteger!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	^TCIF_STATE!

text
	"Answer the text of the receiver"

	^text trimNulls!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^##(self offsetOf: #pszText)! !
!TCITEMW categoriesFor: #cchTextMax!**compiled accessors**!public! !
!TCITEMW categoriesFor: #cchTextMax:!**compiled accessors**!public! !
!TCITEMW categoriesFor: #cchTextMaxOffset!constants!private! !
!TCITEMW categoriesFor: #dwState!**compiled accessors**!public! !
!TCITEMW categoriesFor: #dwState:!**compiled accessors**!public! !
!TCITEMW categoriesFor: #handle!accessing!public! !
!TCITEMW categoriesFor: #iImage!**compiled accessors**!public! !
!TCITEMW categoriesFor: #iImage:!**compiled accessors**!public! !
!TCITEMW categoriesFor: #lParam!**compiled accessors**!public! !
!TCITEMW categoriesFor: #lParam:!**compiled accessors**!public! !
!TCITEMW categoriesFor: #paramValidMask!constants!private! !
!TCITEMW categoriesFor: #pszText!**compiled accessors**!public! !
!TCITEMW categoriesFor: #pszText:!**compiled accessors**!public! !
!TCITEMW categoriesFor: #stateMask!**compiled accessors**!public! !
!TCITEMW categoriesFor: #stateMask:!**compiled accessors**!public! !
!TCITEMW categoriesFor: #stateValidMask!constants!private! !
!TCITEMW categoriesFor: #text!accessing!public! !
!TCITEMW categoriesFor: #textPointerOffset!constants!private! !

!TCITEMW class methodsFor!

defineFields
	"Define the fields of the Win32 TCITEM structure.

		TCITEM compileDefinition

	typedef struct _TCITEM { 
		UINT mask;			// value specifying which members to retrieve or set 
		DWORD dwState;		// Current item state
		DWORD dwStateMask;	// Mask of valid bits in dwState
		LPSTR pszText;		// pointer to string containing tab text 
		int cchTextMax;		// size of buffer pointed to by the pszText member 
		int iImage;			// index to tab control's image 
		LPARAM lParam;		// application-defined data associated with tab 
		} TCITEM;
	"

	super defineFields.
	self
		defineField: #dwState type: DWORDField new offset: 4;
		defineField: #stateMask type: DWORDField new offset: 8;
		defineField: #pszText type: (PointerField type: Utf16String) offset: 12;
		defineField: #cchTextMax type: SDWORDField new offset: 16;
		defineField: #iImage type: SDWORDField new offset: 20;
		defineField: #lParam type: UINT_PTRField new offset: 24! !
!TCITEMW class categoriesFor: #defineFields!initializing!public! !

