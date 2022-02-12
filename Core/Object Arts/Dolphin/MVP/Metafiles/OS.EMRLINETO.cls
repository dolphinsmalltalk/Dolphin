"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRLINETO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRLINETO_Size' -> 16r10.
		'_OffsetOf_ptl' -> 16r8
	}!
OS.EMRLINETO guid: (Core.GUID fromString: '{fff03eec-0fdc-4448-ac60-d19e59624d01}')!
OS.EMRLINETO comment: '<EMRLINETO> is an <ExternalStructure> class to wrap the struct ''Win32.EMRLINETO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(FFF03EEC-0FDC-4448-AC60-D19E59624D01)]
struct tagEMRLINETO {
	EMR EMR;
	POINTL ptl;
} EMRLINETO;
'!
!OS.EMRLINETO categoriesForClass!Win32-Structs! !
!OS.EMRLINETO methodsFor!

ptl
	"Answer the <POINTL> value of the receiver's 'ptl' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptl!

ptl: aPOINTL
	"Set the receiver's 'ptl' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptl + 1)
		to: ##(_OffsetOf_ptl + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.EMRLINETO categoriesForMethods!
ptl!**compiled accessors**!public! !
ptl:!**compiled accessors**!public! !
!

!OS.EMRLINETO class methodsFor!

byteSize
	^_EMRLINETO_Size!

defineFields
	"Define the fields of the EMRLINETO structure.

	EMRLINETO  compileDefinition

		typedef [uuid(FFF03EEC-0FDC-4448-AC60-D19E59624D01)]
		struct tagEMRLINETO {
			EMR EMR;
			POINTL ptl;
		} EMRLINETO;
"

	super defineFields.
	self
		defineField: #ptl
		type: (StructureField type: POINTL)
		offset: 8.
	self byteSize: 16!

getFieldNames
	^#(#iType #nSize #ptl)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_LINETO. EMR_MOVETOEX}! !
!OS.EMRLINETO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

