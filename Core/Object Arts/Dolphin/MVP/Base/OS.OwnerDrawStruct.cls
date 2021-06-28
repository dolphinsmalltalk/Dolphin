"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.OwnerDrawStruct'
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
!OS.OwnerDrawStruct categoriesForClass!Unclassified! !
!OS.OwnerDrawStruct methodsFor!

CtlID
	"Answer the <Integer> value of the receiver's 'CtlID' field."

	^bytes dwordAtOffset: _OffsetOf_CtlID!

CtlType
	"Answer the <Integer> value of the receiver's 'CtlType' field."

	^bytes dwordAtOffset: _OffsetOf_CtlType!

itemID
	"Answer the <Integer> value of the receiver's 'itemID' field."

	^bytes dwordAtOffset: _OffsetOf_itemID! !
!OS.OwnerDrawStruct categoriesFor: #CtlID!**compiled accessors**!public! !
!OS.OwnerDrawStruct categoriesFor: #CtlType!**compiled accessors**!public! !
!OS.OwnerDrawStruct categoriesFor: #itemID!**compiled accessors**!public! !

!OS.OwnerDrawStruct class methodsFor!

defineFields
	"Define the fields common to the DRAWITEMSTRUCT and MEASUREITEMSTRUCT structures.
		OwnerDrawStruct compileDefinition
	"

	self
		defineField: #CtlType type: DWORDField readOnly;
		defineField: #CtlID type: DWORDField readOnly;
		defineField: #itemID type: DWORDField readOnly!

getFieldNames
	^#(#CtlType #CtlID #itemID)! !
!OS.OwnerDrawStruct class categoriesFor: #defineFields!public!template definition! !
!OS.OwnerDrawStruct class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

