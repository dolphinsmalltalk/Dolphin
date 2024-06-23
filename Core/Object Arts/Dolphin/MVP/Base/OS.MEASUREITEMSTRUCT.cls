"Filed out from Dolphin Smalltalk"!

OS.OwnerDrawStruct
	subclass: #'OS.MEASUREITEMSTRUCT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MEASUREITEMSTRUCT_Size' -> 16r18.
			'_OffsetOf_itemData' -> 16r14.
			'_OffsetOf_itemHeight' -> 16r10.
			'_OffsetOf_itemWidth' -> 16rC
		}!

OS.MEASUREITEMSTRUCT guid: (Core.GUID fromString: '{0b195eeb-b134-493b-87f4-a70c213ac690}')!

OS.MEASUREITEMSTRUCT comment: '<MEASUREITEMSTRUCT> is an <ExternalStructure> class to wrap the struct ''Win.MEASUREITEMSTRUCT'' from type information in the ''Windows API (ANSI)'' library.

From MSDN: "The MEASUREITEMSTRUCT structure informs the system of the dimensions of an owner-drawn control or menu item. This allows the system to process user interaction with the control correctly."'!

!OS.MEASUREITEMSTRUCT categoriesForClass!Win-Structs! !

!OS.MEASUREITEMSTRUCT methodsFor!

itemHeight
	"Answer the <Integer> value of the receiver's 'itemHeight' field."

	^bytes uint32AtOffset: _OffsetOf_itemHeight!

itemHeight: anInteger
	"Set the receiver's 'itemHeight' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_itemHeight put: anInteger!

itemWidth
	"Answer the <Integer> value of the receiver's 'itemWidth' field."

	^bytes uint32AtOffset: _OffsetOf_itemWidth!

itemWidth: anInteger
	"Set the receiver's 'itemWidth' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_itemWidth put: anInteger! !

!OS.MEASUREITEMSTRUCT categoriesForMethods!
itemHeight!**compiled accessors**!public! !
itemHeight:!**compiled accessors**!public! !
itemWidth!**compiled accessors**!public! !
itemWidth:!**compiled accessors**!public! !
!

!OS.MEASUREITEMSTRUCT class methodsFor!

byteSize
	^_MEASUREITEMSTRUCT_Size!

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

	super defineFields.
	self
		defineField: #itemWidth type: UInt32Field new;
		defineField: #itemHeight type: UInt32Field new;
		defineField: #itemData type: UIntPtrField filler!

getFieldNames
	^#(#CtlType #CtlID #itemID #itemWidth #itemHeight)! !

!OS.MEASUREITEMSTRUCT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

