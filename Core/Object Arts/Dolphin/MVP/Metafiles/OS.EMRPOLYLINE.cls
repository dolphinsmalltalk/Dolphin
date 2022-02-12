"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRPOLYLINE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRPOLYLINE_Size' -> 16r20.
		'_OffsetOf_aptl' -> 16r1C.
		'_OffsetOf_cptl' -> 16r18.
		'_OffsetOf_rclBounds' -> 16r8
	}!
OS.EMRPOLYLINE guid: (Core.GUID fromString: '{d4e9a638-aade-4ece-a3f4-9e54a0929730}')!
OS.EMRPOLYLINE comment: '<EMRPOLYLINE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYLINE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRPOLYLINE categoriesForClass!Win32-Structs! !
!OS.EMRPOLYLINE methodsFor!

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
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECTL
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL._RECTL_Size)
		startingAt: 1! !
!OS.EMRPOLYLINE categoriesForMethods!
aptl!**compiled accessors**!public! !
aptl:!**compiled accessors**!public! !
cptl!**compiled accessors**!public! !
cptl:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

!OS.EMRPOLYLINE class methodsFor!

byteSize
	^_EMRPOLYLINE_Size!

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
			type: (StructureField type: RECTL)
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
!OS.EMRPOLYLINE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

