"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRELLIPSE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_rclBox' -> 16r8
	}!
OS.EMRELLIPSE guid: (Core.GUID fromString: '{23d57ddc-4a1e-4927-ae53-094c3485ebb1}')!
OS.EMRELLIPSE comment: '<EMRELLIPSE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRELLIPSE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(23D57DDC-4A1E-4927-AE53-094C3485EBB1)]
struct tagEMRELLIPSE {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounding rectangle")] RECTL rclBox;
} EMRELLIPSE;
'!
!OS.EMRELLIPSE categoriesForClass!Win32-Structs! !
!OS.EMRELLIPSE methodsFor!

rclBox
	"Answer the <RECTL> value of the receiver's 'rclBox' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBox!

rclBox: aRECT
	"Set the receiver's 'rclBox' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBox + 1)
		to: ##(_OffsetOf_rclBox + RECTL basicByteSize)
		startingAt: 1! !
!OS.EMRELLIPSE categoriesFor: #rclBox!**compiled accessors**!public! !
!OS.EMRELLIPSE categoriesFor: #rclBox:!**compiled accessors**!public! !

!OS.EMRELLIPSE class methodsFor!

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
		defineField: #rclBox
		type: (StructureField type: RECTL)
		offset: 8.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #rclBox)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_ELLIPSE. EMR_RECTANGLE}! !
!OS.EMRELLIPSE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMRELLIPSE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRELLIPSE class categoriesFor: #iTypes!constants!public! !

