"Filed out from Dolphin Smalltalk"!

OS.CCITEM
	subclass: #'OS.TCITEMW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.TabViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_cchTextMax' -> 16r10.
			'_OffsetOf_dwState' -> 16r4.
			'_OffsetOf_iImage' -> 16r14.
			'_OffsetOf_lParam' -> 16r18.
			'_OffsetOf_pszText' -> 16rC.
			'_OffsetOf_stateMask' -> 16r8.
			'_TCITEMW_Size' -> 16r1C
		}!
OS.TCITEMW guid: (Core.GUID fromString: '{87b4c621-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.TCITEMW comment: 'TCITEM is an <ExternalStructure> class which represents the Windows common control structure of the same name.

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
!OS.TCITEMW categoriesForClass!External-Data-Structured-Win32! !
!OS.TCITEMW methodsFor!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes int32AtOffset: _OffsetOf_cchTextMax!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cchTextMax put: anInteger!

cchTextMaxOffset
	^_OffsetOf_cchTextMax!

dwState
	"Answer the <Integer> value of the receiver's 'dwState' field."

	^bytes uint32AtOffset: _OffsetOf_dwState!

dwState: anInteger
	"Set the receiver's 'dwState' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwState put: anInteger!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self shouldNotImplement!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes int32AtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iImage put: anInteger!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

lParam: anInteger
	"Set the receiver's 'lParam' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_lParam put: anInteger!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the lParam
	field has valid contents."

	^TCIF_PARAM!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszText)!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszText put: anUtf16String yourAddress!

stateMask
	"Answer the <Integer> value of the receiver's 'stateMask' field."

	^bytes uint32AtOffset: _OffsetOf_stateMask!

stateMask: anInteger
	"Set the receiver's 'stateMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_stateMask put: anInteger!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	^TCIF_STATE!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^_OffsetOf_pszText! !
!OS.TCITEMW categoriesForMethods!
cchTextMax!**compiled accessors**!public! !
cchTextMax:!**compiled accessors**!public! !
cchTextMaxOffset!constants!private! !
dwState!**compiled accessors**!public! !
dwState:!**compiled accessors**!public! !
handle!accessing!public! !
iImage!**compiled accessors**!public! !
iImage:!**compiled accessors**!public! !
lParam!**compiled accessors**!public! !
lParam:!**compiled accessors**!public! !
paramValidMask!constants!private! !
pszText!**compiled accessors**!public! !
pszText:!**compiled accessors**!public! !
stateMask!**compiled accessors**!public! !
stateMask:!**compiled accessors**!public! !
stateValidMask!constants!private! !
textPointerOffset!constants!private! !
!

!OS.TCITEMW class methodsFor!

byteSize
	^_TCITEMW_Size!

defineFields
	"Define the fields of the Win32 TCITEM structure.

		self compileDefinition

	typedef struct _TCITEM { 
		UINT mask;			// value specifying which members to retrieve or set 
		DWORD dwState;		// Current item state
		DWORD dwStateMask;	// Mask of valid bits in dwState
		LPWSTR pszText;		// pointer to string containing tab text 
		int cchTextMax;		// size of buffer pointed to by the pszText member 
		int iImage;			// index to tab control's image 
		LPARAM lParam;		// application-defined data associated with tab 
		} TCITEM;
	"

	super defineFields.
	self
		defineField: #dwState
			type: UInt32Field new
			offset: 4;
		defineField: #stateMask
			type: UInt32Field new
			offset: 8;
		defineField: #pszText
			type: (PointerField type: Utf16String)
			offset: 12;
		defineField: #cchTextMax
			type: Int32Field new
			offset: 16;
		defineField: #iImage
			type: Int32Field new
			offset: 20;
		defineField: #lParam
			type: UIntPtrField new
			offset: 24!

getFieldNames
	^#(#mask #dwState #stateMask #pszText #cchTextMax #iImage #lParam)! !
!OS.TCITEMW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

