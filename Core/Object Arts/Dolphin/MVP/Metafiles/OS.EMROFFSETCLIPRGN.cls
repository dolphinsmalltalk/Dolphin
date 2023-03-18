"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMROFFSETCLIPRGN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMROFFSETCLIPRGN_Size' -> 16r10. '_OffsetOf_ptlOffset' -> 16r8 }!
OS.EMROFFSETCLIPRGN guid: (Core.GUID fromString: '{a0baa6e7-981f-4e05-8c52-19525eb0e92e}')!
OS.EMROFFSETCLIPRGN comment: '<EMROFFSETCLIPRGN> is an <ExternalStructure> class to wrap the struct ''Win32.EMROFFSETCLIPRGN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A0BAA6E7-981F-4E05-8C52-19525EB0E92E)]
struct tagEMROFFSETCLIPRGN {
	EMR EMR;
	POINTL ptlOffset;
} EMROFFSETCLIPRGN;
'!
!OS.EMROFFSETCLIPRGN categoriesForClass!Win32-Structs! !
!OS.EMROFFSETCLIPRGN methodsFor!

ptlOffset
	"Answer the <POINTL> value of the receiver's 'ptlOffset' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlOffset!

ptlOffset: aPOINTL
	"Set the receiver's 'ptlOffset' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlOffset + 1)
		to: ##(_OffsetOf_ptlOffset + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.EMROFFSETCLIPRGN categoriesForMethods!
ptlOffset!**compiled accessors**!public! !
ptlOffset:!**compiled accessors**!public! !
!

!OS.EMROFFSETCLIPRGN class methodsFor!

byteSize
	^_EMROFFSETCLIPRGN_Size!

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

	^{EMR_OFFSETCLIPRGN}! !
!OS.EMROFFSETCLIPRGN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

