"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #DRAWITEMSTRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_CtlID' -> 16r4.
		'_OffsetOf_CtlType' -> 16r0.
		'_OffsetOf_hDC' -> 16r18.
		'_OffsetOf_hwndItem' -> 16r14.
		'_OffsetOf_itemAction' -> 16rC.
		'_OffsetOf_itemData' -> 16r2C.
		'_OffsetOf_itemID' -> 16r8.
		'_OffsetOf_itemState' -> 16r10.
		'_OffsetOf_rcItem' -> 16r1C
	}!
DRAWITEMSTRUCT guid: (GUID fromString: '{87b4c5e9-026e-11d3-9fd7-00a0cc3e4a32}')!
DRAWITEMSTRUCT comment: '<DRAWITEMSTRUCT> is an <ExternalStructure> class to wrap the struct ''Win.DRAWITEMSTRUCT'' from type information in the ''Windows API (ANSI)'' library.

From MSDN: "The DRAWITEMSTRUCT structure provides information the owner window must have to determine how to paint an owner-drawn control or menu item. The owner window of the owner-drawn control or menu item receives a pointer to this structure as the lParam parameter of the WM_DRAWITEM message."
'!
!DRAWITEMSTRUCT categoriesForClass!Win-Structs! !
!DRAWITEMSTRUCT methodsFor!

CtlID
	"Answer the <Integer> value of the receiver's 'CtlID' field."

	^bytes dwordAtOffset: _OffsetOf_CtlID!

CtlType
	"Answer the <Integer> value of the receiver's 'CtlType' field."

	^bytes dwordAtOffset: _OffsetOf_CtlType!

hDC
	"Answer the <Integer> value of the receiver's 'hDC' field."

	^bytes dwordAtOffset: _OffsetOf_hDC!

hwndItem
	"Answer the <Integer> value of the receiver's 'hwndItem' field."

	^bytes dwordAtOffset: _OffsetOf_hwndItem!

isGrayed
	"Answer whether the drawn menu item should be grayed. Only applicable when drawing menus."

	^self itemState allMask: ODS_GRAYED!

isSelected
	"Answer whether the drawn menu item is selected. Only applicable when drawing menus."

	^self itemState allMask: ODS_SELECTED!

itemAction
	"Answer the <Integer> value of the receiver's 'itemAction' field."

	^bytes dwordAtOffset: _OffsetOf_itemAction!

itemID
	"Answer the <Integer> value of the receiver's 'itemID' field."

	^bytes dwordAtOffset: _OffsetOf_itemID!

itemState
	"Answer the <Integer> value of the receiver's 'itemState' field."

	^bytes dwordAtOffset: _OffsetOf_itemState!

rcItem
	"Answer the <RECT> value of the receiver's 'rcItem' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcItem! !
!DRAWITEMSTRUCT categoriesFor: #CtlID!**compiled accessors**!public! !
!DRAWITEMSTRUCT categoriesFor: #CtlType!**compiled accessors**!public! !
!DRAWITEMSTRUCT categoriesFor: #hDC!**compiled accessors**!public! !
!DRAWITEMSTRUCT categoriesFor: #hwndItem!**compiled accessors**!public! !
!DRAWITEMSTRUCT categoriesFor: #isGrayed!public!testing! !
!DRAWITEMSTRUCT categoriesFor: #isSelected!public!testing! !
!DRAWITEMSTRUCT categoriesFor: #itemAction!**compiled accessors**!public! !
!DRAWITEMSTRUCT categoriesFor: #itemID!**compiled accessors**!public! !
!DRAWITEMSTRUCT categoriesFor: #itemState!**compiled accessors**!public! !
!DRAWITEMSTRUCT categoriesFor: #rcItem!**compiled accessors**!public! !

!DRAWITEMSTRUCT class methodsFor!

defineFields
	"Define the fields of the DRAWITEMSTRUCT structure.
		DRAWITEMSTRUCT compileDefinition
	
		typedef 
		struct tagDRAWITEMSTRUCT {
			UINT CtlType;
			UINT CtlID;
			UINT itemID;
			UINT itemAction;
			UINT itemState;
			HWND hwndItem;
			HDC hDC;
			RECT rcItem;
			ULONG_PTR itemData;
		} DRAWITEMSTRUCT;
"

	self
		defineField: #CtlType type: DWORDField readOnly;
		defineField: #CtlID type: DWORDField readOnly;
		defineField: #itemID type: DWORDField readOnly;
		defineField: #itemAction type: DWORDField readOnly;
		defineField: #itemState type: DWORDField readOnly;
		defineField: #hwndItem type: DWORDField readOnly;
		defineField: #hDC type: DWORDField readOnly;
		defineField: #rcItem type: (StructureField type: RECT) beReadOnly;
		defineField: #itemData type: UINT_PTRField filler!

getFieldNames
	^#(#CtlType #CtlID #itemID #itemAction #itemState #hwndItem #hDC #rcItem)! !
!DRAWITEMSTRUCT class categoriesFor: #defineFields!public!template definition! !
!DRAWITEMSTRUCT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

