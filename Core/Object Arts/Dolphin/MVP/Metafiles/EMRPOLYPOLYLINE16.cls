"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYPOLYLINE16
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPOLYPOLYLINE16 guid: (GUID fromString: '{2a9bb18a-1223-4e8d-a462-82c531b52df3}')!
EMRPOLYPOLYLINE16 comment: '<EMRPOLYPOLYLINE16> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYPOLYLINE16''.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

Note that this structure actually contains two variable lenght arrays, aPolyCounts and apts. The first of these contains nPolys elements, and the latter cpts elements.

IDL definition follows:

typedef [uuid(2A9BB18A-1223-4E8D-A462-82C531B52DF3)]
struct tagEMRPOLYPOLYLINE16 {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Number of polys")] DWORD nPolys;
	[helpstring("Total number of points in all polys")] DWORD cpts;
	[helpstring("Array of point counts for each poly")] DWORD aPolyCounts[1];
	[helpstring("Array of points")] POINTS* apts;
} EMRPOLYPOLYLINE16;
'!
!EMRPOLYPOLYLINE16 categoriesForClass!Win32-Structs! !
!EMRPOLYPOLYLINE16 methodsFor!

aPolyCounts
	"Answer the receiver's aPolyCounts field as a Smalltalk object."

	^DWORDArray fromAddress: (bytes yourAddress + 32) length: self nPolys!

aPolyCounts: aDWORDArray
	"Set the receiver's 'aPolyCounts' field to the value of the argument, aDWORDArray"

	| size |
	size := aDWORDArray byteSize.
	aDWORDArray
		replaceBytesOf: bytes
		from: ##((self offsetOf: #aPolyCounts) + 1)
		to: ##(self offsetOf: #aPolyCounts) + size
		startingAt: 1.
	self nPolys: aDWORDArray size!

apts
	"Answer the receiver's apts field as a Smalltalk object."

	"Implementation Note: Custom accessor needed because the offset will vary depending on the number of elements in aPolyCounts"

	^StructureArray 
		fromAddress: bytes yourAddress + self aptsOffset
		length: self cpts
		elementClass: POINTS!

apts: anObject 
	"Set the receiver's apts field to the value of anObject."

	"Implementation Note: Custom accessor needed because the offset will vary depending on the number of elements in aPolyCounts"

	| size offset |
	size := anObject byteSize min: self cpts * ##(POINTS basicSize).
	offset := self aptsOffset.
	anObject 
		replaceBytesOf: bytes
		from: offset + 1
		to: offset + size
		startingAt: 1!

aptsOffset
	^##(self offsetOf: #aPolyCounts) + (4 * self nPolys)!

cpts
	"Answer the <Integer> value of the receiver's 'cpts' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cpts)!

cpts: anInteger
	"Set the receiver's 'cpts' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cpts) put: anInteger!

nPolys
	"Answer the <Integer> value of the receiver's 'nPolys' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nPolys)!

nPolys: anInteger
	"Set the receiver's 'nPolys' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nPolys) put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1! !
!EMRPOLYPOLYLINE16 categoriesFor: #aPolyCounts!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #aPolyCounts:!**compiled accessors**!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #apts!accessing!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #apts:!accessing!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #aptsOffset!private! !
!EMRPOLYPOLYLINE16 categoriesFor: #cpts!**compiled accessors**!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #cpts:!**compiled accessors**!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #nPolys!**compiled accessors**!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #nPolys:!**compiled accessors**!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRPOLYPOLYLINE16 categoriesFor: #rclBounds:!**compiled accessors**!public! !

!EMRPOLYPOLYLINE16 class methodsFor!

defineFields
	"Define the fields of the EMRPOLYPOLYLINE16 structure.

	EMRPOLYPOLYLINE16  compileDefinition

		typedef [uuid(2A9BB18A-1223-4E8D-A462-82C531B52DF3)]
		struct tagEMRPOLYPOLYLINE16 {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Number of polys')] DWORD nPolys;
			[helpstring('Total number of points in all polys')] DWORD cpts;
			[helpstring('Array of point counts for each poly')] DWORD aPolyCounts[];
			[helpstring('Array of points')] POINTS apts[];
		} EMRPOLYPOLYLINE16;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #nPolys
			type: DWORDField new
			offset: 24;
		defineField: #cpts
			type: DWORDField new
			offset: 28;
		defineField: #aPolyCounts
			type: (ArrayField type: DWORDArray lengthField: #nPolys)
			offset: 32;
		defineField: #apts type: (StructureArrayField type: POINTS lengthField: #cpts)!

getFieldNames
	^#(#iType #nSize #rclBounds #nPolys #cpts #aPolyCounts #apts)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_POLYPOLYLINE16 with: EMR_POLYPOLYGON16! !
!EMRPOLYPOLYLINE16 class categoriesFor: #defineFields!initializing!public! !
!EMRPOLYPOLYLINE16 class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRPOLYPOLYLINE16 class categoriesFor: #iTypes!constants!public! !

