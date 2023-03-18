"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRARC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRARC_Size' -> 16r28.
			'_OffsetOf_ptlEnd' -> 16r20.
			'_OffsetOf_ptlStart' -> 16r18.
			'_OffsetOf_rclBox' -> 16r8
		}!
OS.EMRARC guid: (Core.GUID fromString: '{a4d8acff-7c86-450e-ab37-011f1b1a9754}')!
OS.EMRARC comment: '<EMRARC> is an <ExternalStructure> class to wrap the struct ''Win32.EMRARC'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A4D8ACFF-7C86-450E-AB37-011F1B1A9754)]
struct tagEMRARC {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounding rectangle")] RECTL rclBox;
	POINTL ptlStart;
	POINTL ptlEnd;
} EMRARC;
'!
!OS.EMRARC categoriesForClass!Win32-Structs! !
!OS.EMRARC methodsFor!

ptlEnd
	"Answer the <POINTL> value of the receiver's 'ptlEnd' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlEnd!

ptlEnd: aPOINTL
	"Set the receiver's 'ptlEnd' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlEnd + 1)
		to: ##(_OffsetOf_ptlEnd + POINTL._POINTL_Size)
		startingAt: 1!

ptlStart
	"Answer the <POINTL> value of the receiver's 'ptlStart' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlStart!

ptlStart: aPOINTL
	"Set the receiver's 'ptlStart' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlStart + 1)
		to: ##(_OffsetOf_ptlStart + POINTL._POINTL_Size)
		startingAt: 1!

rclBox
	"Answer the <RECTL> value of the receiver's 'rclBox' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBox!

rclBox: aRECTL
	"Set the receiver's 'rclBox' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBox + 1)
		to: ##(_OffsetOf_rclBox + RECTL._RECTL_Size)
		startingAt: 1! !
!OS.EMRARC categoriesForMethods!
ptlEnd!**compiled accessors**!public! !
ptlEnd:!**compiled accessors**!public! !
ptlStart!**compiled accessors**!public! !
ptlStart:!**compiled accessors**!public! !
rclBox!**compiled accessors**!public! !
rclBox:!**compiled accessors**!public! !
!

!OS.EMRARC class methodsFor!

byteSize
	^_EMRARC_Size!

defineFields
	"Define the fields of the EMRARC structure.

	EMRARC  compileDefinition

		typedef [uuid(A4D8ACFF-7C86-450E-AB37-011F1B1A9754)]
		struct tagEMRARC {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounding rectangle')] RECTL rclBox;
			POINTL ptlStart;
			POINTL ptlEnd;
		} EMRARC;
"

	super defineFields.
	self
		defineField: #rclBox
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #ptlStart
			type: (StructureField type: POINTL)
			offset: 24;
		defineField: #ptlEnd
			type: (StructureField type: POINTL)
			offset: 32.
	self byteSize: 40!

getFieldNames
	^#(#iType #nSize #rclBox #ptlStart #ptlEnd)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_ARC. EMR_ARCTO. EMR_CHORD. EMR_PIE}! !
!OS.EMRARC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

