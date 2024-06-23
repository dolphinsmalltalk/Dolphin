"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRPOLYDRAW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRPOLYDRAW_Size' -> 16r28.
			'_OffsetOf_abTypes' -> 16r24.
			'_OffsetOf_aptl' -> 16r1C.
			'_OffsetOf_cptl' -> 16r18.
			'_OffsetOf_rclBounds' -> 16r8
		}!

OS.EMRPOLYDRAW guid: (Core.GUID fromString: '{5be172c2-6045-4143-8550-377acd60fd3f}')!

OS.EMRPOLYDRAW comment: '<EMRPOLYDRAW> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYDRAW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(5BE172C2-6045-4143-8550-377ACD60FD3F)]
struct tagEMRPOLYDRAW {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Number of points")] DWORD cptl;
	[helpstring("Array of points")] POINTL aptl[1];
	[helpstring("Array of point types")] BYTE* abTypes;
} EMRPOLYDRAW;
'!

!OS.EMRPOLYDRAW categoriesForClass!Win32-Structs! !

!OS.EMRPOLYDRAW methodsFor!

abTypes
	"Answer the receiver's abTypes field as a Smalltalk object."

	^ExternalArray fromAddress: bytes yourAddress + self abTypesOffset length: self cptl!

abTypes: anObject 
	"Set the receiver's abTypes field to the value of anObject."

	| size offset |
	size := anObject byteSize min: self cptl.
	offset := self abTypesOffset.
	anObject 
		replaceBytesOf: bytes
		from: offset + 1
		to: offset + size
		startingAt: 1!

abTypesOffset
	^28 + (8 * self cptl)	"8 = POINTL byteSize"!

aptl
	"Answer the <StructureArray> value of the receiver's 'aptl' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_aptl
		length: self cptl
		elementClass: POINTL!

aptl: aStructureArrayOfPOINTL
	"Set the receiver's 'aptl' field to the value of the argument, aStructureArrayOfPOINTL"

	| size |
	size := aStructureArrayOfPOINTL byteSize.
	aStructureArrayOfPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_aptl + 1)
		to: _OffsetOf_aptl + size
		startingAt: 1.
	self cptl: aStructureArrayOfPOINTL size!

cptl
	"Answer the <Integer> value of the receiver's 'cptl' field."

	^bytes uint32AtOffset: _OffsetOf_cptl!

cptl: anInteger
	"Set the receiver's 'cptl' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cptl put: anInteger!

rclBounds
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECTL
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL._RECTL_Size)
		startingAt: 1! !

!OS.EMRPOLYDRAW categoriesForMethods!
abTypes!public! !
abTypes:!public! !
abTypesOffset!accessing!private! !
aptl!**compiled accessors**!public! !
aptl:!**compiled accessors**!public! !
cptl!**compiled accessors**!public! !
cptl:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

!OS.EMRPOLYDRAW class methodsFor!

byteSize
	^_EMRPOLYDRAW_Size!

defineFields
	"Define the fields of the EMRPOLYDRAW structure.

	EMRPOLYDRAW  compileDefinition

		typedef [uuid(5BE172C2-6045-4143-8550-377ACD60FD3F)]
		struct tagEMRPOLYDRAW {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Number of points')] DWORD cptl;
			[helpstring('Array of points'),size_is(cptl)] POINTL aptl[];
			[helpstring('Array of point types'),size_is(cptl)] BYTE abTypes[];
		} EMRPOLYDRAW;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #cptl
			type: UInt32Field new
			offset: 24;
		defineField: #aptl
			type: (StructureArrayField type: POINTL lengthField: #cptl)
			offset: 28;
		defineField: #abTypes type: (ArrayField type: ExternalArray lengthField: #cptl)!

getFieldNames
	^#(#iType #nSize #rclBounds #cptl #aptl #abTypes)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_POLYDRAW}! !

!OS.EMRPOLYDRAW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

