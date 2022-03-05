"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMROFFSETCLIPRGN
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_ptlOffset'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMROFFSETCLIPRGN guid: (GUID fromString: '{a0baa6e7-981f-4e05-8c52-19525eb0e92e}')!
EMROFFSETCLIPRGN addClassConstant: '_OffsetOf_ptlOffset' value: 16r8!
EMROFFSETCLIPRGN comment: '<EMROFFSETCLIPRGN> is an <ExternalStructure> class to wrap the struct ''Win32.EMROFFSETCLIPRGN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A0BAA6E7-981F-4E05-8C52-19525EB0E92E)]
struct tagEMROFFSETCLIPRGN {
	EMR EMR;
	POINTL ptlOffset;
} EMROFFSETCLIPRGN;
'!
!EMROFFSETCLIPRGN categoriesForClass!Win32-Structs! !
!EMROFFSETCLIPRGN methodsFor!

ptlOffset
	"Answer the <POINTL> value of the receiver's 'ptlOffset' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlOffset!

ptlOffset: aPOINTL
	"Set the receiver's 'ptlOffset' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlOffset + 1)
		to: ##(_OffsetOf_ptlOffset + POINTL basicByteSize)
		startingAt: 1! !
!EMROFFSETCLIPRGN categoriesForMethods!
ptlOffset!**compiled accessors**!public! !
ptlOffset:!**compiled accessors**!public! !
!

!EMROFFSETCLIPRGN class methodsFor!

defineFields
	"Define the fields of the EMROFFSETCLIPRGN structure.

	EMROFFSETCLIPRGN  compileDefinition

		typedef [uuid(A0BAA6E7-981F-4E05-8C52-19525EB0E92E)]
		struct tagEMROFFSETCLIPRGN {
			EMR EMR;
			POINTL ptlOffset;
		} EMROFFSETCLIPRGN;
"

	super defineFields.
	self
		defineField: #ptlOffset
			type: (StructureField type: POINTL)
			offset: 8.
	self byteSize: 16!

getFieldNames
	^#(#iType #nSize #ptlOffset)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_OFFSETCLIPRGN! !
!EMROFFSETCLIPRGN class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

