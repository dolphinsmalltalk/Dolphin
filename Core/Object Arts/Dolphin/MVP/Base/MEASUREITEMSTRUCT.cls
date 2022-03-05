"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #MEASUREITEMSTRUCT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_CtlID _OffsetOf_CtlType _OffsetOf_itemData _OffsetOf_itemHeight _OffsetOf_itemID _OffsetOf_itemWidth'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MEASUREITEMSTRUCT guid: (GUID fromString: '{0b195eeb-b134-493b-87f4-a70c213ac690}')!
MEASUREITEMSTRUCT addClassConstant: '_OffsetOf_CtlID' value: 16r4!
MEASUREITEMSTRUCT addClassConstant: '_OffsetOf_CtlType' value: 16r0!
MEASUREITEMSTRUCT addClassConstant: '_OffsetOf_itemData' value: 16r14!
MEASUREITEMSTRUCT addClassConstant: '_OffsetOf_itemHeight' value: 16r10!
MEASUREITEMSTRUCT addClassConstant: '_OffsetOf_itemID' value: 16r8!
MEASUREITEMSTRUCT addClassConstant: '_OffsetOf_itemWidth' value: 16rC!
MEASUREITEMSTRUCT comment: '<MEASUREITEMSTRUCT> is an <ExternalStructure> class to wrap the struct ''Win.MEASUREITEMSTRUCT'' from type information in the ''Windows API (ANSI)'' library.

From MSDN: "The MEASUREITEMSTRUCT structure informs the system of the dimensions of an owner-drawn control or menu item. This allows the system to process user interaction with the control correctly."'!
!MEASUREITEMSTRUCT categoriesForClass!Win-Structs! !
!MEASUREITEMSTRUCT methodsFor!

CtlID
	"Answer the <Integer> value of the receiver's 'CtlID' field."

	^bytes dwordAtOffset: _OffsetOf_CtlID!

CtlType
	"Answer the <Integer> value of the receiver's 'CtlType' field."

	^bytes dwordAtOffset: _OffsetOf_CtlType!

itemHeight
	"Answer the <Integer> value of the receiver's 'itemHeight' field."

	^bytes dwordAtOffset: _OffsetOf_itemHeight!

itemHeight: anInteger
	"Set the receiver's 'itemHeight' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_itemHeight put: anInteger!

itemID
	"Answer the <Integer> value of the receiver's 'itemID' field."

	^bytes dwordAtOffset: _OffsetOf_itemID!

itemWidth
	"Answer the <Integer> value of the receiver's 'itemWidth' field."

	^bytes dwordAtOffset: _OffsetOf_itemWidth!

itemWidth: anInteger
	"Set the receiver's 'itemWidth' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_itemWidth put: anInteger! !
!MEASUREITEMSTRUCT categoriesForMethods!
CtlID!**compiled accessors**!public! !
CtlType!**compiled accessors**!public! !
itemHeight!**compiled accessors**!public! !
itemHeight:!**compiled accessors**!public! !
itemID!**compiled accessors**!public! !
itemWidth!**compiled accessors**!public! !
itemWidth:!**compiled accessors**!public! !
!

!MEASUREITEMSTRUCT class methodsFor!

defineFields
	"Define the fields of the MEASUREITEMSTRUCT structure.
		MEASUREITEMSTRUCT compileDefinition
	
		typedef 
		struct tagMEASUREITEMSTRUCT {
			UINT CtlType;
			UINT CtlID;
			UINT itemID;
			UINT itemWidth;
			UINT itemHeight;
			ULONG_PTR  itemData;
		} MEASUREITEMSTRUCT;
"

	self
		defineField: #CtlType type: DWORDField readOnly;
		defineField: #CtlID type: DWORDField readOnly;
		defineField: #itemID type: DWORDField readOnly;
		defineField: #itemWidth type: DWORDField new;
		defineField: #itemHeight type: DWORDField new;
		defineField: #itemData type: UINT_PTRField filler!

getFieldNames
	^#(#CtlType #CtlID #itemID #itemWidth #itemHeight)! !
!MEASUREITEMSTRUCT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

