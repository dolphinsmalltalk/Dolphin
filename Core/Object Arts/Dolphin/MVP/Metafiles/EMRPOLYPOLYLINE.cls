"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYPOLYLINE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPOLYPOLYLINE guid: (GUID fromString: '{b8dbb77d-883a-49cc-ba50-d75d9d773cdb}')!
EMRPOLYPOLYLINE comment: '<EMRPOLYPOLYLINE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYPOLYLINE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMRPOLYPOLYLINE categoriesForClass!Win32-Structs! !
!EMRPOLYPOLYLINE methodsFor!

aPolyCounts
	"Answer the receiver's aPolyCounts field as a Smalltalk object."

	^DWORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #aPolyCounts) length: self nPolys!

aPolyCounts: anObject 
	"Set the receiver's aPolyCounts field to the value of anObject."

	| size |
	size := anObject byteSize min: self nPolys * ##(DWORDArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #aPolyCounts) + 1)
		to: ##(self offsetOf: #aPolyCounts) + size
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
	^##(self offsetOf: #aPolyCounts) + (4 * self nPolys)!

cptl
	"Answer the receiver's cptl field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cptl)!

cptl: anObject 
	"Set the receiver's cptl field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cptl) put: anObject!

nPolys
	"Answer the receiver's nPolys field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nPolys)!

nPolys: anObject 
	"Set the receiver's nPolys field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nPolys) put: anObject!

rclBounds
	"Answer the receiver's rclBounds field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: anObject 
	"Set the receiver's rclBounds field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1! !
!EMRPOLYPOLYLINE categoriesFor: #aPolyCounts!**compiled accessors**!public! !
!EMRPOLYPOLYLINE categoriesFor: #aPolyCounts:!**compiled accessors**!public! !
!EMRPOLYPOLYLINE categoriesFor: #aptl!public! !
!EMRPOLYPOLYLINE categoriesFor: #aptl:!public! !
!EMRPOLYPOLYLINE categoriesFor: #aptlOffset!private! !
!EMRPOLYPOLYLINE categoriesFor: #cptl!**compiled accessors**!public! !
!EMRPOLYPOLYLINE categoriesFor: #cptl:!**compiled accessors**!public! !
!EMRPOLYPOLYLINE categoriesFor: #nPolys!**compiled accessors**!public! !
!EMRPOLYPOLYLINE categoriesFor: #nPolys:!**compiled accessors**!public! !
!EMRPOLYPOLYLINE categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRPOLYPOLYLINE categoriesFor: #rclBounds:!**compiled accessors**!public! !

!EMRPOLYPOLYLINE class methodsFor!

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
			type: (StructureField type: RECT)
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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_POLYPOLYLINE with: EMR_POLYPOLYGON! !
!EMRPOLYPOLYLINE class categoriesFor: #defineFields!initializing!public! !
!EMRPOLYPOLYLINE class categoriesFor: #iTypes!constants!public! !

