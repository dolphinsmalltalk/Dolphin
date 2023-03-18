"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRSETPIXELV'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRSETPIXELV_Size' -> 16r14.
		'_OffsetOf_crColor' -> 16r10.
		'_OffsetOf_ptlPixel' -> 16r8
	}!
OS.EMRSETPIXELV guid: (Core.GUID fromString: '{a1dc1f6e-41ae-4ffa-90d8-778106a60b0b}')!
OS.EMRSETPIXELV comment: '<EMRSETPIXELV> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETPIXELV'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A1DC1F6E-41AE-4FFA-90D8-778106A60B0B)]
struct tagEMRSETPIXELV {
	EMR EMR;
	POINTL ptlPixel;
	COLORREF crColor;
} EMRSETPIXELV;
'!
!OS.EMRSETPIXELV categoriesForClass!Win32-Structs! !
!OS.EMRSETPIXELV methodsFor!

crColor
	"Answer the <Integer> value of the receiver's 'crColor' field."

	^bytes uint32AtOffset: _OffsetOf_crColor!

crColor: anInteger
	"Set the receiver's 'crColor' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_crColor put: anInteger!

ptlPixel
	"Answer the <POINTL> value of the receiver's 'ptlPixel' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlPixel!

ptlPixel: aPOINTL
	"Set the receiver's 'ptlPixel' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlPixel + 1)
		to: ##(_OffsetOf_ptlPixel + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.EMRSETPIXELV categoriesForMethods!
crColor!**compiled accessors**!public! !
crColor:!**compiled accessors**!public! !
ptlPixel!**compiled accessors**!public! !
ptlPixel:!**compiled accessors**!public! !
!

!OS.EMRSETPIXELV class methodsFor!

byteSize
	^_EMRSETPIXELV_Size!

defineFields
	"Define the fields of the EMRSETPIXELV structure.

	EMRSETPIXELV  compileDefinition

		typedef [uuid(A1DC1F6E-41AE-4FFA-90D8-778106A60B0B)]
		struct tagEMRSETPIXELV {
			EMR EMR;
			POINTL ptlPixel;
			COLORREF crColor;
		} EMRSETPIXELV;
"

	super defineFields.
	self
		defineField: #ptlPixel
			type: (StructureField type: POINTL)
			offset: 8;
		defineField: #crColor
			type: UInt32Field new
			offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#iType #nSize #ptlPixel #crColor)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETPIXELV}! !
!OS.EMRSETPIXELV class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

