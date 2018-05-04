"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYDRAW16
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPOLYDRAW16 guid: (GUID fromString: '{f3d1f8c2-c73d-4ae7-9717-b798c4956a06}')!
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
	"Answer the receiver's apts field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #apts)
		length: self cpts
		elementClass: POINTS!

apts: anObject 
	"Set the receiver's apts field to the value of anObject."

	| size |
	size := anObject byteSize min: self cpts * ##(POINTS basicByteSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #apts) + 1)
		to: ##(self offsetOf: #apts) + size
		startingAt: 1!

cpts
	"Answer the receiver's cpts field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cpts)!

cpts: anObject 
	"Set the receiver's cpts field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cpts) put: anObject!

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
!EMRPOLYDRAW16 categoriesFor: #abTypes!public! !
!EMRPOLYDRAW16 categoriesFor: #abTypes:!public! !
!EMRPOLYDRAW16 categoriesFor: #abTypesOffset!accessing!private! !
!EMRPOLYDRAW16 categoriesFor: #apts!**compiled accessors**!public! !
!EMRPOLYDRAW16 categoriesFor: #apts:!**compiled accessors**!public! !
!EMRPOLYDRAW16 categoriesFor: #cpts!**compiled accessors**!public! !
!EMRPOLYDRAW16 categoriesFor: #cpts:!**compiled accessors**!public! !
!EMRPOLYDRAW16 categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRPOLYDRAW16 categoriesFor: #rclBounds:!**compiled accessors**!public! !

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
			type: (ConformantStructureArrayField type: POINTS length: #cpts)
			offset: 28;
		defineField: #abTypes
			type: (ConformantArrayField type: ExternalArray length: #cpts)
			offset: 32.
	self byteSize: 36!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_POLYDRAW16! !
!EMRPOLYDRAW16 class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRPOLYDRAW16 class categoriesFor: #iTypes!constants!public! !

