"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRARC
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_ptlEnd _OffsetOf_ptlStart _OffsetOf_rclBox'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRARC guid: (GUID fromString: '{a4d8acff-7c86-450e-ab37-011f1b1a9754}')!
EMRARC addClassConstant: '_OffsetOf_ptlEnd' value: 16r20!
EMRARC addClassConstant: '_OffsetOf_ptlStart' value: 16r18!
EMRARC addClassConstant: '_OffsetOf_rclBox' value: 16r8!
EMRARC comment: '<EMRARC> is an <ExternalStructure> class to wrap the struct ''Win32.EMRARC'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMRARC categoriesForClass!Win32-Structs! !
!EMRARC methodsFor!

ptlEnd
	"Answer the <POINTL> value of the receiver's 'ptlEnd' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlEnd!

ptlEnd: aPOINTL
	"Set the receiver's 'ptlEnd' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlEnd + 1)
		to: ##(_OffsetOf_ptlEnd + POINTL basicByteSize)
		startingAt: 1!

ptlStart
	"Answer the <POINTL> value of the receiver's 'ptlStart' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlStart!

ptlStart: aPOINTL
	"Set the receiver's 'ptlStart' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlStart + 1)
		to: ##(_OffsetOf_ptlStart + POINTL basicByteSize)
		startingAt: 1!

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
!EMRARC categoriesForMethods!
ptlEnd!**compiled accessors**!public! !
ptlEnd:!**compiled accessors**!public! !
ptlStart!**compiled accessors**!public! !
ptlStart:!**compiled accessors**!public! !
rclBox!**compiled accessors**!public! !
rclBox:!**compiled accessors**!public! !
!

!EMRARC class methodsFor!

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
		defineField: #rclBox type: (StructureField type: RECT) offset: 8;
		defineField: #ptlStart type: (StructureField type: POINTL) offset: 24;
		defineField: #ptlEnd type: (StructureField type: POINTL) offset: 32.
	self byteSize: 40!

getFieldNames
	^#(#iType #nSize #rclBox #ptlStart #ptlEnd)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array 
		with: EMR_ARC
		with: EMR_ARCTO
		with: EMR_CHORD
		with: EMR_PIE! !
!EMRARC class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

