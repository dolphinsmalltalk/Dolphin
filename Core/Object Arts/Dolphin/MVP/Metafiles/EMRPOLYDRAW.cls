"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYDRAW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
	"Answer the receiver's aptl field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #aptl)
		length: self cptl
		elementClass: POINTL!

aptl: anObject 
	"Set the receiver's aptl field to the value of anObject."

	| size |
	size := anObject byteSize min: self cptl * ##(POINTL basicByteSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #aptl) + 1)
		to: ##(self offsetOf: #aptl) + size
		startingAt: 1!

cptl
	"Answer the receiver's cptl field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cptl)!

cptl: anObject 
	"Set the receiver's cptl field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cptl) put: anObject!

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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_POLYDRAW! !
!EMRPOLYDRAW class categoriesFor: #defineFields!initializing!public! !
!EMRPOLYDRAW class categoriesFor: #iTypes!constants!public! !

