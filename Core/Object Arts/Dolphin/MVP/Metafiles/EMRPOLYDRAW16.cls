"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRPOLYDRAW16
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_abTypes _OffsetOf_apts _OffsetOf_cpts _OffsetOf_rclBounds'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMRPOLYDRAW16 guid: (GUID fromString: '{f3d1f8c2-c73d-4ae7-9717-b798c4956a06}')!

EMRPOLYDRAW16 addClassConstant: '_OffsetOf_abTypes' value: 16r20!
EMRPOLYDRAW16 addClassConstant: '_OffsetOf_apts' value: 16r1C!
EMRPOLYDRAW16 addClassConstant: '_OffsetOf_cpts' value: 16r18!
EMRPOLYDRAW16 addClassConstant: '_OffsetOf_rclBounds' value: 16r8!

EMRPOLYDRAW16 comment: '<EMRPOLYDRAW16> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYDRAW16'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(F3D1F8C2-C73D-4AE7-9717-B798C4956A06)]
struct tagEMRPOLYDRAW16 {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Number of points")] DWORD cpts;
	[helpstring("Array of points")] POINTS apts[1];
	[helpstring("Array of point types")] BYTE* abTypes;
} EMRPOLYDRAW16;
'!

!EMRPOLYDRAW16 categoriesForClass!Win32-Structs! !

!EMRPOLYDRAW16 methodsFor!

abTypes
	"Answer the receiver's abTypes field as a Smalltalk object."

	^ExternalArray fromAddress: bytes yourAddress + self abTypesOffset length: self cpts!

abTypes: anObject 
	"Set the receiver's abTypes field to the value of anObject."

	| size offset |
	size := anObject byteSize min: self cpts.
	offset := self abTypesOffset.
	anObject 
		replaceBytesOf: bytes
		from: offset + 1
		to: offset + size
		startingAt: 1!

abTypesOffset
	^28 + (4 * self cpts)	"4 = POINTS byteSize"!

apts
	"Answer the <StructureArray> value of the receiver's 'apts' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_apts
		length: self cpts
		elementClass: POINTS!

apts: aStructureArrayOfPOINTS
	"Set the receiver's 'apts' field to the value of the argument, aStructureArrayOfPOINTS"

	| size |
	size := aStructureArrayOfPOINTS byteSize.
	aStructureArrayOfPOINTS
		replaceBytesOf: bytes
		from: ##(_OffsetOf_apts + 1)
		to: _OffsetOf_apts + size
		startingAt: 1.
	self cpts: aStructureArrayOfPOINTS size!

cpts
	"Answer the <Integer> value of the receiver's 'cpts' field."

	^bytes dwordAtOffset: _OffsetOf_cpts!

cpts: anInteger
	"Set the receiver's 'cpts' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cpts put: anInteger!

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

!EMRPOLYDRAW16 categoriesForMethods!
abTypes!public! !
abTypes:!public! !
abTypesOffset!accessing!private! !
apts!**compiled accessors**!public! !
apts:!**compiled accessors**!public! !
cpts!**compiled accessors**!public! !
cpts:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

!EMRPOLYDRAW16 class methodsFor!

defineFields
	"Define the fields of the EMRPOLYDRAW16 structure.

	EMRPOLYDRAW16  compileDefinition

		typedef [uuid(F3D1F8C2-C73D-4AE7-9717-B798C4956A06)]
		struct tagEMRPOLYDRAW16 {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Number of points')] DWORD cpts;
			[helpstring('Array of points')] POINTS apts[1];
			[helpstring('Array of point types')] BYTE* abTypes;
		} EMRPOLYDRAW16;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #cpts
			type: DWORDField new
			offset: 24;
		defineField: #apts
			type: (StructureArrayField type: POINTS lengthField: #cpts)
			offset: 28;
		defineField: #abTypes
			type: (ArrayField type: ExternalArray lengthField: #cpts)
			offset: 32.
	self byteSize: 36!

getFieldNames
	^#(#iType #nSize #rclBounds #cpts #apts #abTypes)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_POLYDRAW16! !

!EMRPOLYDRAW16 class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

