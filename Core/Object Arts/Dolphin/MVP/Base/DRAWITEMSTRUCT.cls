"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #DRAWITEMSTRUCT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_CtlID _OffsetOf_CtlType _OffsetOf_hDC _OffsetOf_hwndItem _OffsetOf_itemAction _OffsetOf_itemData _OffsetOf_itemID _OffsetOf_itemState _OffsetOf_rcItem'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DRAWITEMSTRUCT guid: (GUID fromString: '{87b4c5e9-026e-11d3-9fd7-00a0cc3e4a32}')!

DRAWITEMSTRUCT addClassConstant: '_OffsetOf_CtlID' value: 16r4!
DRAWITEMSTRUCT addClassConstant: '_OffsetOf_CtlType' value: 16r0!
DRAWITEMSTRUCT addClassConstant: '_OffsetOf_hDC' value: 16r18!
DRAWITEMSTRUCT addClassConstant: '_OffsetOf_hwndItem' value: 16r14!
DRAWITEMSTRUCT addClassConstant: '_OffsetOf_itemAction' value: 16rC!
DRAWITEMSTRUCT addClassConstant: '_OffsetOf_itemData' value: 16r2C!
DRAWITEMSTRUCT addClassConstant: '_OffsetOf_itemID' value: 16r8!
DRAWITEMSTRUCT addClassConstant: '_OffsetOf_itemState' value: 16r10!
DRAWITEMSTRUCT addClassConstant: '_OffsetOf_rcItem' value: 16r1C!

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

!DRAWITEMSTRUCT categoriesForMethods!
CtlID!**compiled accessors**!public! !
CtlType!**compiled accessors**!public! !
hDC!**compiled accessors**!public! !
hwndItem!**compiled accessors**!public! !
isGrayed!public!testing! !
isSelected!public!testing! !
itemAction!**compiled accessors**!public! !
itemID!**compiled accessors**!public! !
itemState!**compiled accessors**!public! !
rcItem!**compiled accessors**!public! !
!

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

!DRAWITEMSTRUCT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

