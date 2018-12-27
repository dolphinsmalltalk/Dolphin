"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MEASUREITEMSTRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MEASUREITEMSTRUCT guid: (GUID fromString: '{0b195eeb-b134-493b-87f4-a70c213ac690}')!
MEASUREITEMSTRUCT comment: '<MEASUREITEMSTRUCT> is an <ExternalStructure> class to wrap the struct ''Win.MEASUREITEMSTRUCT'' from type information in the ''Windows API (ANSI)'' library.

From MSDN: "The MEASUREITEMSTRUCT structure informs the system of the dimensions of an owner-drawn control or menu item. This allows the system to process user interaction with the control correctly."'!
!MEASUREITEMSTRUCT categoriesForClass!Win-Structs! !
!MEASUREITEMSTRUCT methodsFor!

CtlID
	"Answer the <Integer> value of the receiver's 'CtlID' field."

	^bytes dwordAtOffset: ##(self offsetOf: #CtlID)!

CtlType
	"Answer the <Integer> value of the receiver's 'CtlType' field."

	^bytes dwordAtOffset: 0!

itemHeight
	"Answer the <Integer> value of the receiver's 'itemHeight' field."

	^bytes dwordAtOffset: ##(self offsetOf: #itemHeight)!

itemHeight: anInteger
	"Set the receiver's 'itemHeight' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #itemHeight) put: anInteger!

itemID
	"Answer the <Integer> value of the receiver's 'itemID' field."

	^bytes dwordAtOffset: ##(self offsetOf: #itemID)!

itemWidth
	"Answer the <Integer> value of the receiver's 'itemWidth' field."

	^bytes dwordAtOffset: ##(self offsetOf: #itemWidth)!

itemWidth: anInteger
	"Set the receiver's 'itemWidth' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #itemWidth) put: anInteger! !
!MEASUREITEMSTRUCT categoriesFor: #CtlID!**compiled accessors**!public! !
!MEASUREITEMSTRUCT categoriesFor: #CtlType!**compiled accessors**!public! !
!MEASUREITEMSTRUCT categoriesFor: #itemHeight!**compiled accessors**!public! !
!MEASUREITEMSTRUCT categoriesFor: #itemHeight:!**compiled accessors**!public! !
!MEASUREITEMSTRUCT categoriesFor: #itemID!**compiled accessors**!public! !
!MEASUREITEMSTRUCT categoriesFor: #itemWidth!**compiled accessors**!public! !
!MEASUREITEMSTRUCT categoriesFor: #itemWidth:!**compiled accessors**!public! !

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
!MEASUREITEMSTRUCT class categoriesFor: #defineFields!initializing!public! !
!MEASUREITEMSTRUCT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

