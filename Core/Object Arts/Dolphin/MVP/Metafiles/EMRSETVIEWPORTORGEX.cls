"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETVIEWPORTORGEX
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_ptlOrigin'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETVIEWPORTORGEX guid: (GUID fromString: '{69136774-602e-4324-aff6-a261d792e0ff}')!
EMRSETVIEWPORTORGEX addClassConstant: '_OffsetOf_ptlOrigin' value: 16r8!
EMRSETVIEWPORTORGEX comment: '<EMRSETVIEWPORTORGEX> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETVIEWPORTORGEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(69136774-602E-4324-AFF6-A261D792E0FF)]
struct tagEMRSETVIEWPORTORGEX {
	EMR EMR;
	POINTL ptlOrigin;
} EMRSETVIEWPORTORGEX;
'!
!EMRSETVIEWPORTORGEX categoriesForClass!Win32-Structs! !
!EMRSETVIEWPORTORGEX methodsFor!

ptlOrigin
	"Answer the <POINTL> value of the receiver's 'ptlOrigin' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlOrigin!

ptlOrigin: aPOINTL
	"Set the receiver's 'ptlOrigin' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlOrigin + 1)
		to: ##(_OffsetOf_ptlOrigin + POINTL basicByteSize)
		startingAt: 1! !
!EMRSETVIEWPORTORGEX categoriesFor: #ptlOrigin!**compiled accessors**!public! !
!EMRSETVIEWPORTORGEX categoriesFor: #ptlOrigin:!**compiled accessors**!public! !

!EMRSETVIEWPORTORGEX class methodsFor!

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
!EMRSETVIEWPORTORGEX class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSETVIEWPORTORGEX class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETVIEWPORTORGEX class categoriesFor: #iTypes!constants!public! !

