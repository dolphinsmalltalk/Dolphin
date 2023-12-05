"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.OwnerDrawStruct'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_CtlID' -> 16r4.
			'_OffsetOf_CtlType' -> 16r0.
			'_OffsetOf_itemID' -> 16r8
		}!
OS.OwnerDrawStruct guid: (Core.GUID fromString: '{7208da36-0f29-40ae-b974-07c3a81db8f5}')!
OS.OwnerDrawStruct isNonInstantiable: true!
OS.OwnerDrawStruct comment: ''!
!OS.OwnerDrawStruct categoriesForClass!External-Data-Structured-Win32! !
!OS.OwnerDrawStruct methodsFor!

CtlID
	"Answer the <Integer> value of the receiver's 'CtlID' field."

	^bytes uint32AtOffset: _OffsetOf_CtlID!

CtlType
	"Answer the <Integer> value of the receiver's 'CtlType' field."

	^bytes uint32AtOffset: _OffsetOf_CtlType!

itemID
	"Answer the <Integer> value of the receiver's 'itemID' field."

	^bytes uint32AtOffset: _OffsetOf_itemID! !
!OS.OwnerDrawStruct categoriesForMethods!
CtlID!**compiled accessors**!public! !
CtlType!**compiled accessors**!public! !
itemID!**compiled accessors**!public! !
!

!OS.OwnerDrawStruct class methodsFor!

defineFields
	"Define the fields common to the DRAWITEMSTRUCT and MEASUREITEMSTRUCT structures.
		OwnerDrawStruct compileDefinition
	"

	self
		defineField: #CtlType type: UInt32Field readOnly;
		defineField: #CtlID type: UInt32Field readOnly;
		defineField: #itemID type: UInt32Field readOnly! !
!OS.OwnerDrawStruct class categoriesForMethods!
defineFields!public!template definition! !
!

