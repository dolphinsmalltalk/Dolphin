"Filed out from Dolphin Smalltalk"!

OS.OwnerDrawStruct
	subclass: #'OS.DRAWITEMSTRUCT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_DRAWITEMSTRUCT_Size' -> 16r30.
			'_OffsetOf_hDC' -> 16r18.
			'_OffsetOf_hwndItem' -> 16r14.
			'_OffsetOf_itemAction' -> 16rC.
			'_OffsetOf_itemData' -> 16r2C.
			'_OffsetOf_itemState' -> 16r10.
			'_OffsetOf_rcItem' -> 16r1C
		}!
OS.DRAWITEMSTRUCT guid: (Core.GUID fromString: '{87b4c5e9-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.DRAWITEMSTRUCT comment: '<DRAWITEMSTRUCT> is an <ExternalStructure> class to wrap the struct ''Win.DRAWITEMSTRUCT'' from type information in the ''Windows API (ANSI)'' library.

From MSDN: "The DRAWITEMSTRUCT structure provides information the owner window must have to determine how to paint an owner-drawn control or menu item. The owner window of the owner-drawn control or menu item receives a pointer to this structure as the lParam parameter of the WM_DRAWITEM message."
'!
!OS.DRAWITEMSTRUCT categoriesForClass!Win-Structs! !
!OS.DRAWITEMSTRUCT methodsFor!

hDC
	"Answer the <Integer> value of the receiver's 'hDC' field."

	^bytes uint32AtOffset: _OffsetOf_hDC!

hwndItem
	"Answer the <Integer> value of the receiver's 'hwndItem' field."

	^bytes uint32AtOffset: _OffsetOf_hwndItem!

isGrayed
	"Answer whether the drawn menu item should be grayed. Only applicable when drawing menus."

	^self itemState allMask: OS.Win32Constants.ODS_GRAYED!

isSelected
	"Answer whether the drawn menu item is selected. Only applicable when drawing menus."

	^self itemState allMask: OS.Win32Constants.ODS_SELECTED!

itemAction
	"Answer the <Integer> value of the receiver's 'itemAction' field."

	^bytes uint32AtOffset: _OffsetOf_itemAction!

itemState
	"Answer the <Integer> value of the receiver's 'itemState' field."

	^bytes uint32AtOffset: _OffsetOf_itemState!

rcItem
	"Answer the <RECTL> value of the receiver's 'rcItem' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcItem! !
!OS.DRAWITEMSTRUCT categoriesForMethods!
hDC!**compiled accessors**!public! !
hwndItem!**compiled accessors**!public! !
isGrayed!public!testing! !
isSelected!public!testing! !
itemAction!**compiled accessors**!public! !
itemState!**compiled accessors**!public! !
rcItem!**compiled accessors**!public! !
!

!OS.DRAWITEMSTRUCT class methodsFor!

byteSize
	^_DRAWITEMSTRUCT_Size!

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
			RECTL rcItem;
			ULONG_PTR itemData;
		} DRAWITEMSTRUCT;
"

	super defineFields.
	self
		defineField: #itemAction type: UInt32Field readOnly;
		defineField: #itemState type: UInt32Field readOnly;
		defineField: #hwndItem type: UInt32Field readOnly;
		defineField: #hDC type: UInt32Field readOnly;
		defineField: #rcItem type: (StructureField type: RECTL) beReadOnly;
		defineField: #itemData type: UIntPtrField filler!

getFieldNames
	^#(#CtlType #CtlID #itemID #itemAction #itemState #hwndItem #hDC #rcItem)! !
!OS.DRAWITEMSTRUCT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

