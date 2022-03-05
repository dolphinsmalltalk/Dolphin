"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRPOLYPOLYLINE16
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_aPolyCounts _OffsetOf_apts _OffsetOf_cpts _OffsetOf_nPolys _OffsetOf_rclBounds'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPOLYPOLYLINE16 guid: (GUID fromString: '{2a9bb18a-1223-4e8d-a462-82c531b52df3}')!
EMRPOLYPOLYLINE16 addClassConstant: '_OffsetOf_aPolyCounts' value: 16r20!
EMRPOLYPOLYLINE16 addClassConstant: '_OffsetOf_apts' value: 16r24!
EMRPOLYPOLYLINE16 addClassConstant: '_OffsetOf_cpts' value: 16r1C!
EMRPOLYPOLYLINE16 addClassConstant: '_OffsetOf_nPolys' value: 16r18!
EMRPOLYPOLYLINE16 addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
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
		from: ##(_OffsetOf_aPolyCounts + 1)
		to: _OffsetOf_aPolyCounts + size
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
	^_OffsetOf_aPolyCounts + (4 * self nPolys)!

cpts
	"Answer the <Integer> value of the receiver's 'cpts' field."

	^bytes dwordAtOffset: _OffsetOf_cpts!

cpts: anInteger
	"Set the receiver's 'cpts' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cpts put: anInteger!

nPolys
	"Answer the <Integer> value of the receiver's 'nPolys' field."

	^bytes dwordAtOffset: _OffsetOf_nPolys!

nPolys: anInteger
	"Set the receiver's 'nPolys' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nPolys put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
		startingAt: 1! !
!EMRPOLYPOLYLINE16 categoriesForMethods!
aPolyCounts!public! !
aPolyCounts:!**compiled accessors**!public! !
apts!accessing!public! !
apts:!accessing!public! !
aptsOffset!private! !
cpts!**compiled accessors**!public! !
cpts:!**compiled accessors**!public! !
nPolys!**compiled accessors**!public! !
nPolys:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

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
!EMRPOLYPOLYLINE16 class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

