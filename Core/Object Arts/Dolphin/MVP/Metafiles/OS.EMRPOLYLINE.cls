"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYLINE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_aptl' -> 16r1C.
		'_OffsetOf_cptl' -> 16r18.
		'_OffsetOf_rclBounds' -> 16r8
	}!
EMRPOLYLINE guid: (GUID fromString: '{d4e9a638-aade-4ece-a3f4-9e54a0929730}')!
EMRPOLYLINE comment: '<EMRPOLYLINE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYLINE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(D4E9A638-AADE-4ECE-A3F4-9E54A0929730)]
struct tagEMRPOLYLINE {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	DWORD cptl;
	POINTL* aptl;
} EMRPOLYLINE;
'!
!EMRPOLYLINE categoriesForClass!Win32-Structs! !
!EMRPOLYLINE methodsFor!

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
!EMRPOLYLINE categoriesFor: #aptl!**compiled accessors**!public! !
!EMRPOLYLINE categoriesFor: #aptl:!**compiled accessors**!public! !
!EMRPOLYLINE categoriesFor: #cptl!**compiled accessors**!public! !
!EMRPOLYLINE categoriesFor: #cptl:!**compiled accessors**!public! !
!EMRPOLYLINE categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRPOLYLINE categoriesFor: #rclBounds:!**compiled accessors**!public! !

!EMRPOLYLINE class methodsFor!

defineFields
	"Define the fields of the EMRPOLYLINE structure.

	EMRPOLYLINE  compileDefinition

		typedef [uuid(D4E9A638-AADE-4ECE-A3F4-9E54A0929730)]
		struct tagEMRPOLYLINE {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			DWORD cptl;
			POINTL* aptl;
		} EMRPOLYLINE;
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
			offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#iType #nSize #rclBounds #cptl #aptl)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_POLYLINE. EMR_POLYBEZIER. EMR_POLYGON. EMR_POLYBEZIERTO. EMR_POLYLINETO}! !
!EMRPOLYLINE class categoriesFor: #defineFields!public!template definition! !
!EMRPOLYLINE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRPOLYLINE class categoriesFor: #iTypes!constants!public! !

