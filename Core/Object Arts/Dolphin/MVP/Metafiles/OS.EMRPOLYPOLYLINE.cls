"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRPOLYPOLYLINE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRPOLYPOLYLINE_Size' -> 16r28.
			'_OffsetOf_aPolyCounts' -> 16r20.
			'_OffsetOf_aptl' -> 16r24.
			'_OffsetOf_cptl' -> 16r1C.
			'_OffsetOf_nPolys' -> 16r18.
			'_OffsetOf_rclBounds' -> 16r8
		}!

OS.EMRPOLYPOLYLINE guid: (Core.GUID fromString: '{b8dbb77d-883a-49cc-ba50-d75d9d773cdb}')!

OS.EMRPOLYPOLYLINE comment: '<EMRPOLYPOLYLINE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYPOLYLINE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(B8DBB77D-883A-49CC-BA50-D75D9D773CDB)]
struct tagEMRPOLYPOLYLINE {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Number of polys")] DWORD nPolys;
	[helpstring("Total number of points in all polys")] DWORD cptl;
	[helpstring("Array of point counts for each poly")] DWORD aPolyCounts[1];
	[helpstring("Array of points")] POINTL* aptl;
} EMRPOLYPOLYLINE;
'!

!OS.EMRPOLYPOLYLINE categoriesForClass!Win32-Structs! !

!OS.EMRPOLYPOLYLINE methodsFor!

aPolyCounts
	"Answer the <aUInt32Array> value of the receiver's 'aPolyCounts' field."

	^UInt32Array fromAddress: bytes yourAddress + _OffsetOf_aPolyCounts length: self nPolys!

aPolyCounts: aUInt32Array
	"Set the receiver's 'aPolyCounts' field to the value of the argument, aUInt32Array"

	| size |
	size := aUInt32Array byteSize.
	aUInt32Array
		replaceBytesOf: bytes
		from: ##(_OffsetOf_aPolyCounts + 1)
		to: _OffsetOf_aPolyCounts + size
		startingAt: 1.
	self nPolys: aUInt32Array size!

aptl
	"Answer the receiver's aptl field as a Smalltalk object."

	"Implementation Note: Custom accessor needed because the offset will vary depending on the number of elements in aPolyCounts"

	^StructureArray
		fromAddress: bytes yourAddress + self aptlOffset
		length: self cptl
		elementClass: POINTL!

aptl: anObject
	"Set the receiver's aptl field to the value of anObject."

	"Implementation Note: Custom accessor needed because the offset will vary depending on the number of elements in aPolyCounts"

	| size offset |
	size := anObject byteSize min: self cptl * POINTL._POINTL_Size.
	offset := self aptlOffset.
	anObject
		replaceBytesOf: bytes
		from: offset + 1
		to: offset + size
		startingAt: 1!

aptlOffset
	^_OffsetOf_aPolyCounts + (4 * self nPolys)!

cptl
	"Answer the <Integer> value of the receiver's 'cptl' field."

	^bytes uint32AtOffset: _OffsetOf_cptl!

cptl: anInteger
	"Set the receiver's 'cptl' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cptl put: anInteger!

nPolys
	"Answer the <Integer> value of the receiver's 'nPolys' field."

	^bytes uint32AtOffset: _OffsetOf_nPolys!

nPolys: anInteger
	"Set the receiver's 'nPolys' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nPolys put: anInteger!

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

!OS.EMRPOLYPOLYLINE categoriesForMethods!
aPolyCounts!**compiled accessors**!public! !
aPolyCounts:!**compiled accessors**!public! !
aptl!public! !
aptl:!public! !
aptlOffset!private! !
cptl!**compiled accessors**!public! !
cptl:!**compiled accessors**!public! !
nPolys!**compiled accessors**!public! !
nPolys:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

!OS.EMRPOLYPOLYLINE class methodsFor!

byteSize
	^_EMRPOLYPOLYLINE_Size!

defineFields
	"Define the fields of the EMRPOLYPOLYLINE structure.

	EMRPOLYPOLYLINE  compileDefinition

		typedef [uuid(B8DBB77D-883A-49CC-BA50-D75D9D773CDB)]
		struct tagEMRPOLYPOLYLINE {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Number of polys')] DWORD nPolys;
			[helpstring('Total number of points in all polys')] DWORD cptl;
			[helpstring('Array of point counts for each poly')] DWORD aPolyCounts[1];
			[helpstring('Array of points')] POINTL* aptl;
		} EMRPOLYPOLYLINE;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #nPolys
			type: UInt32Field new
			offset: 24;
		defineField: #cptl
			type: UInt32Field new
			offset: 28;
		defineField: #aPolyCounts
			type: (ArrayField type: UInt32Array lengthField: #nPolys)
			offset: 32;
		defineField: #aptl type: (StructureArrayField type: POINTL lengthField: #cptl).
	self byteSize: 40!

getFieldNames
	^#(#iType #nSize #rclBounds #nPolys #cptl #aPolyCounts #aptl)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_POLYPOLYLINE. EMR_POLYPOLYGON}! !

!OS.EMRPOLYPOLYLINE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

