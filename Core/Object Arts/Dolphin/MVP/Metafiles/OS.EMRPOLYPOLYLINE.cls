"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRPOLYPOLYLINE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
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
	"Answer the <DWORDArray> value of the receiver's 'aPolyCounts' field."

	^DWORDArray fromAddress: bytes yourAddress + _OffsetOf_aPolyCounts length: self nPolys!

aPolyCounts: aDWORDArray
	"Set the receiver's 'aPolyCounts' field to the value of the argument, aDWORDArray"

	| size |
	size := aDWORDArray byteSize.
	aDWORDArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_aPolyCounts + 1)
		to: _OffsetOf_aPolyCounts + size
		startingAt: 1!

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
	size := anObject byteSize min: self cptl * ##(POINTL basicByteSize).
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

	^bytes dwordAtOffset: _OffsetOf_cptl!

cptl: anInteger
	"Set the receiver's 'cptl' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cptl put: anInteger!

nPolys
	"Answer the <Integer> value of the receiver's 'nPolys' field."

	^bytes dwordAtOffset: _OffsetOf_nPolys!

nPolys: anInteger
	"Set the receiver's 'nPolys' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nPolys put: anInteger!

rclBounds
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECTL
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL basicByteSize)
		startingAt: 1! !
!OS.EMRPOLYPOLYLINE categoriesFor: #aPolyCounts!**compiled accessors**!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #aPolyCounts:!**compiled accessors**!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #aptl!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #aptl:!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #aptlOffset!private! !
!OS.EMRPOLYPOLYLINE categoriesFor: #cptl!**compiled accessors**!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #cptl:!**compiled accessors**!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #nPolys!**compiled accessors**!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #nPolys:!**compiled accessors**!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #rclBounds!**compiled accessors**!public! !
!OS.EMRPOLYPOLYLINE categoriesFor: #rclBounds:!**compiled accessors**!public! !

!OS.EMRPOLYPOLYLINE class methodsFor!

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
			type: DWORDField new
			offset: 24;
		defineField: #cptl
			type: DWORDField new
			offset: 28;
		defineField: #aPolyCounts
			type: (ArrayField type: DWORDArray lengthField: #nPolys)
			offset: 32;
		defineField: #aptl type: (StructureArrayField type: POINTL lengthField: #cptl).
	self byteSize: 40!

getFieldNames
	^#(#iType #nSize #rclBounds #nPolys #cptl #aPolyCounts #aptl)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_POLYPOLYLINE. EMR_POLYPOLYGON}! !
!OS.EMRPOLYPOLYLINE class categoriesFor: #defineFields!public!template definition! !
!OS.EMRPOLYPOLYLINE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRPOLYPOLYLINE class categoriesFor: #iTypes!constants!public! !

