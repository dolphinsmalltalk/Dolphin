"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #DRAWITEMSTRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DRAWITEMSTRUCT guid: (GUID fromString: '{87B4C5E9-026E-11D3-9FD7-00A0CC3E4A32}')!
DRAWITEMSTRUCT comment: '<DRAWITEMSTRUCT> is an <ExternalStructure> class to wrap the struct ''Win.DRAWITEMSTRUCT'' from type information in the ''Windows API (ANSI)'' library.

From MSDN: "The DRAWITEMSTRUCT structure provides information the owner window must have to determine how to paint an owner-drawn control or menu item. The owner window of the owner-drawn control or menu item receives a pointer to this structure as the lParam parameter of the WM_DRAWITEM message."
'!
!DRAWITEMSTRUCT categoriesForClass!Win-Structs! !
!DRAWITEMSTRUCT methodsFor!

CtlID
	"Answer the receiver's CtlID field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #CtlID)!

CtlType
	"Answer the receiver's CtlType field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

hDC
	"Answer the receiver's hDC field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #hDC)!

hwndItem
	"Answer the receiver's hwndItem field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #hwndItem)!

isGrayed
	"Answer whether the drawn menu item should be grayed. Only applicable when drawing menus."

	^self itemState allMask: ODS_GRAYED!

isSelected
	"Answer whether the drawn menu item is selected. Only applicable when drawing menus."

	^self itemState allMask: ODS_SELECTED!

itemAction
	"Answer the receiver's itemAction field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #itemAction)!

itemID
	"Answer the receiver's itemID field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #itemID)!

itemState
	"Answer the receiver's itemState field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #itemState)!

rcItem
	"Answer the receiver's rcItem field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rcItem)! !
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
		defineField: #itemData type: UINT_PTRField filler! !
!DRAWITEMSTRUCT class categoriesFor: #defineFields!initializing!public! !

