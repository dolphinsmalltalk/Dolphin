"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYDRAW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_abTypes' -> 16r24.
		'_OffsetOf_aptl' -> 16r1C.
		'_OffsetOf_cptl' -> 16r18.
		'_OffsetOf_rclBounds' -> 16r8
	}!
EMRPOLYDRAW guid: (GUID fromString: '{5be172c2-6045-4143-8550-377acd60fd3f}')!
EMRPOLYDRAW comment: '<EMRPOLYDRAW> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYDRAW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMRPOLYDRAW categoriesForClass!Win32-Structs! !
!EMRPOLYDRAW methodsFor!

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

	^bytes dwordAtOffset: _OffsetOf_cptl!

cptl: anInteger
	"Set the receiver's 'cptl' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cptl put: anInteger!

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
!EMRPOLYDRAW categoriesFor: #abTypes!public! !
!EMRPOLYDRAW categoriesFor: #abTypes:!public! !
!EMRPOLYDRAW categoriesFor: #abTypesOffset!accessing!private! !
!EMRPOLYDRAW categoriesFor: #aptl!**compiled accessors**!public! !
!EMRPOLYDRAW categoriesFor: #aptl:!**compiled accessors**!public! !
!EMRPOLYDRAW categoriesFor: #cptl!**compiled accessors**!public! !
!EMRPOLYDRAW categoriesFor: #cptl:!**compiled accessors**!public! !
!EMRPOLYDRAW categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRPOLYDRAW categoriesFor: #rclBounds:!**compiled accessors**!public! !

!EMRPOLYDRAW class methodsFor!

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
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #cptl
			type: DWORDField new
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
!EMRPOLYDRAW class categoriesFor: #defineFields!public!template definition! !
!EMRPOLYDRAW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRPOLYDRAW class categoriesFor: #iTypes!constants!public! !

