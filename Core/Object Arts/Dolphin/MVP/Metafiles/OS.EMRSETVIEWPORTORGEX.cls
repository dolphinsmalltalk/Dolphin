"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSETVIEWPORTORGEX'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMRSETVIEWPORTORGEX_Size' -> 16r10. '_OffsetOf_ptlOrigin' -> 16r8 }!

OS.EMRSETVIEWPORTORGEX guid: (Core.GUID fromString: '{69136774-602e-4324-aff6-a261d792e0ff}')!

OS.EMRSETVIEWPORTORGEX comment: '<EMRSETVIEWPORTORGEX> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETVIEWPORTORGEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(69136774-602E-4324-AFF6-A261D792E0FF)]
struct tagEMRSETVIEWPORTORGEX {
	EMR EMR;
	POINTL ptlOrigin;
} EMRSETVIEWPORTORGEX;
'!

!OS.EMRSETVIEWPORTORGEX categoriesForClass!Win32-Structs! !

!OS.EMRSETVIEWPORTORGEX methodsFor!

ptlOrigin
	"Answer the <POINTL> value of the receiver's 'ptlOrigin' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlOrigin!

ptlOrigin: aPOINTL
	"Set the receiver's 'ptlOrigin' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlOrigin + 1)
		to: ##(_OffsetOf_ptlOrigin + POINTL._POINTL_Size)
		startingAt: 1! !

!OS.EMRSETVIEWPORTORGEX categoriesForMethods!
ptlOrigin!**compiled accessors**!public! !
ptlOrigin:!**compiled accessors**!public! !
!

!OS.EMRSETVIEWPORTORGEX class methodsFor!

byteSize
	^_EMRSETVIEWPORTORGEX_Size!

defineFields
	"Define the fields of the EMRSETVIEWPORTORGEX structure.

	EMRSETVIEWPORTORGEX  compileDefinition

		typedef [uuid(69136774-602E-4324-AFF6-A261D792E0FF)]
		struct tagEMRSETVIEWPORTORGEX {
			EMR EMR;
			POINTL ptlOrigin;
		} EMRSETVIEWPORTORGEX;
"

	super defineFields.
	self
		defineField: #ptlOrigin
		type: (StructureField type: POINTL)
		offset: 8.
	self byteSize: 16!

getFieldNames
	^#(#iType #nSize #ptlOrigin)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETVIEWPORTORGEX. EMR_SETWINDOWORGEX. EMR_SETBRUSHORGEX}! !

!OS.EMRSETVIEWPORTORGEX class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

