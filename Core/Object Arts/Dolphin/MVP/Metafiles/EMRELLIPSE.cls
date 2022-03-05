"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRELLIPSE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_rclBox'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRELLIPSE guid: (GUID fromString: '{23d57ddc-4a1e-4927-ae53-094c3485ebb1}')!
EMRELLIPSE addClassConstant: '_OffsetOf_rclBox' value: 16r8!
EMRELLIPSE comment: '<EMRELLIPSE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRELLIPSE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(23D57DDC-4A1E-4927-AE53-094C3485EBB1)]
struct tagEMRELLIPSE {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounding rectangle")] RECTL rclBox;
} EMRELLIPSE;
'!
!EMRELLIPSE categoriesForClass!Win32-Structs! !
!EMRELLIPSE methodsFor!

rclBox
	"Answer the <RECT> value of the receiver's 'rclBox' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBox!

rclBox: aRECT
	"Set the receiver's 'rclBox' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBox + 1)
		to: ##(_OffsetOf_rclBox + RECT basicByteSize)
		startingAt: 1! !
!EMRELLIPSE categoriesForMethods!
rclBox!**compiled accessors**!public! !
rclBox:!**compiled accessors**!public! !
!

!EMRELLIPSE class methodsFor!

defineFields
	"Define the fields of the EMRELLIPSE structure.

	EMRELLIPSE  compileDefinition

		typedef [uuid(23D57DDC-4A1E-4927-AE53-094C3485EBB1)]
		struct tagEMRELLIPSE {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounding rectangle')] RECTL rclBox;
		} EMRELLIPSE;
"

	super defineFields.
	self
		defineField: #rclBox type: (StructureField type: RECT) offset: 8.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #rclBox)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_ELLIPSE with: EMR_RECTANGLE! !
!EMRELLIPSE class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

