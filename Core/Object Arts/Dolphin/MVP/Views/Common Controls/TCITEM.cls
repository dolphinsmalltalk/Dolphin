"Filed out from Dolphin Smalltalk 7"!

CCITEM subclass: #TCITEM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'TabViewConstants'
	classInstanceVariableNames: ''!
TCITEM guid: (GUID fromString: '{87b4c621-026e-11d3-9fd7-00a0cc3e4a32}')!
TCITEM comment: 'TCITEM is an <ExternalStructure> class which represents the Windows common control structure of the same name.

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
!TCITEM categoriesForClass!External-Data-Structured-Win32! !
!TCITEM methodsFor!

cchTextMaxOffset
	^16!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwState)!

dwState: anObject 
	"Set the receiver's dwState field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwState) put: anObject!

dwStateOffset
	^4!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self shouldNotImplement!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anObject 
	"Set the receiver's iImage field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anObject!

iImageOffset
	^20!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^TCIF_IMAGE!

lParamOffset
	"typedef [uuid(3264BE55-8AF9-47AE-889A-3CE56B575CA4)] struct TCITEMA
    {
        UINT mask;
        DWORD dwState;
        DWORD dwStateMask;
        LPTSTR pszText;
        int cchTextMax;
        int iImage;

        LPARAM	lParam;  
    } TCITEMA, *LPTCITEMA;"

	^##(VMConstants.IntSize + 4 + 4 + VMConstants.IntPtrSize + VMConstants.IntSize 
		+ VMConstants.IntSize)!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the lParam
	field has valid contents."

	^TCIF_PARAM!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))!

pszText: anObject 
	"Set the receiver's pszText field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pszText) put: anObject yourAddress!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #stateMask)!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #stateMask) put: anObject!

stateMaskOffset
	^8!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	^TCIF_STATE!

text
	"Answer the text of the receiver"

	^text trimNulls!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^12!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^TCIF_TEXT! !
!TCITEM categoriesFor: #cchTextMaxOffset!constants!private! !
!TCITEM categoriesFor: #dwState!**compiled accessors**!public! !
!TCITEM categoriesFor: #dwState:!**compiled accessors**!public! !
!TCITEM categoriesFor: #dwStateOffset!constants!private! !
!TCITEM categoriesFor: #handle!accessing!public! !
!TCITEM categoriesFor: #iImage!**compiled accessors**!public! !
!TCITEM categoriesFor: #iImage:!**compiled accessors**!public! !
!TCITEM categoriesFor: #iImageOffset!constants!private! !
!TCITEM categoriesFor: #imageValidMask!constants!private! !
!TCITEM categoriesFor: #lParamOffset!constants!private! !
!TCITEM categoriesFor: #paramValidMask!constants!private! !
!TCITEM categoriesFor: #pszText!**compiled accessors**!public! !
!TCITEM categoriesFor: #pszText:!**compiled accessors**!public! !
!TCITEM categoriesFor: #stateMask!**compiled accessors**!public! !
!TCITEM categoriesFor: #stateMask:!**compiled accessors**!public! !
!TCITEM categoriesFor: #stateMaskOffset!constants!private! !
!TCITEM categoriesFor: #stateValidMask!constants!private! !
!TCITEM categoriesFor: #text!accessing!public! !
!TCITEM categoriesFor: #textPointerOffset!constants!private! !
!TCITEM categoriesFor: #textValidMask!constants!private! !

!TCITEM class methodsFor!

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
		defineField: #dwState type: DWORDField new;
		defineField: #stateMask type: DWORDField new;
		defineField: #pszText type: (PointerField type: String);
		defineField: #cchTextMax type: SDWORDField uncompiled;
		defineField: #iImage type: SDWORDField new;
		defineField: #lParam type: UINT_PTRField uncompiled! !
!TCITEM class categoriesFor: #defineFields!initializing!public! !

