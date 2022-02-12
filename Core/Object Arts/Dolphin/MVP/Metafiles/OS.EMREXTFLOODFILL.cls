"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMREXTFLOODFILL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMREXTFLOODFILL_Size' -> 16r18.
		'_OffsetOf_crColor' -> 16r10.
		'_OffsetOf_iMode' -> 16r14.
		'_OffsetOf_ptlStart' -> 16r8
	}!
OS.EMREXTFLOODFILL guid: (Core.GUID fromString: '{bd14ca2b-d9cd-4146-ad72-d15f18031a50}')!
OS.EMREXTFLOODFILL comment: '<EMREXTFLOODFILL> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXTFLOODFILL'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BD14CA2B-D9CD-4146-AD72-D15F18031A50)]
struct tagEMREXTFLOODFILL {
	EMR EMR;
	POINTL ptlStart;
	COLORREF crColor;
	DWORD iMode;
} EMREXTFLOODFILL;
'!
!OS.EMREXTFLOODFILL categoriesForClass!Win32-Structs! !
!OS.EMREXTFLOODFILL methodsFor!

crColor
	"Answer the <Integer> value of the receiver's 'crColor' field."

	^bytes dwordAtOffset: _OffsetOf_crColor!

crColor: anInteger
	"Set the receiver's 'crColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_crColor put: anInteger!

iMode
	"Answer the <Integer> value of the receiver's 'iMode' field."

	^bytes dwordAtOffset: _OffsetOf_iMode!

iMode: anInteger
	"Set the receiver's 'iMode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iMode put: anInteger!

ptlStart
	"Answer the <POINTL> value of the receiver's 'ptlStart' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlStart!

ptlStart: aPOINTL
	"Set the receiver's 'ptlStart' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlStart + 1)
		to: ##(_OffsetOf_ptlStart + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.EMREXTFLOODFILL categoriesForMethods!
crColor!**compiled accessors**!public! !
crColor:!**compiled accessors**!public! !
iMode!**compiled accessors**!public! !
iMode:!**compiled accessors**!public! !
ptlStart!**compiled accessors**!public! !
ptlStart:!**compiled accessors**!public! !
!

!OS.EMREXTFLOODFILL class methodsFor!

byteSize
	^_EMREXTFLOODFILL_Size!

defineFields
	"Define the fields of the EMREXTFLOODFILL structure.

	EMREXTFLOODFILL  compileDefinition

		typedef [uuid(BD14CA2B-D9CD-4146-AD72-D15F18031A50)]
		struct tagEMREXTFLOODFILL {
			EMR EMR;
			POINTL ptlStart;
			COLORREF crColor;
			DWORD iMode;
		} EMREXTFLOODFILL;
"

	super defineFields.
	self
		defineField: #ptlStart
			type: (StructureField type: POINTL)
			offset: 8;
		defineField: #crColor
			type: DWORDField new
			offset: 16;
		defineField: #iMode
			type: DWORDField new
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #ptlStart #crColor #iMode)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EXTFLOODFILL}! !
!OS.EMREXTFLOODFILL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

