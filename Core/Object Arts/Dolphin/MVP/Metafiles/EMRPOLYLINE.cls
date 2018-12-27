"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYLINE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
		fromAddress: bytes yourAddress + ##(self offsetOf: #aptl)
		length: self cptl
		elementClass: POINTL!

aptl: aStructureArrayOfPOINTL
	"Set the receiver's 'aptl' field to the value of the argument, aStructureArrayOfPOINTL"

	| size |
	size := aStructureArrayOfPOINTL byteSize.
	aStructureArrayOfPOINTL
		replaceBytesOf: bytes
		from: ##((self offsetOf: #aptl) + 1)
		to: ##(self offsetOf: #aptl) + size
		startingAt: 1.
	self cptl: aStructureArrayOfPOINTL size!

cptl
	"Answer the <Integer> value of the receiver's 'cptl' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cptl)!

cptl: anInteger
	"Set the receiver's 'cptl' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cptl) put: anInteger!

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

	^Array 
		with: EMR_POLYLINE
		with: EMR_POLYBEZIER
		with: EMR_POLYGON
		with: EMR_POLYBEZIERTO
		with: EMR_POLYLINETO! !
!EMRPOLYLINE class categoriesFor: #defineFields!initializing!public! !
!EMRPOLYLINE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRPOLYLINE class categoriesFor: #iTypes!constants!public! !

