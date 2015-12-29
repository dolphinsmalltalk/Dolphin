"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #GpWmfPlaceableFileHeader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpWmfPlaceableFileHeader guid: (GUID fromString: '{E244EDF0-9096-42DD-944D-3BE54248689F}')!
GpWmfPlaceableFileHeader comment: '<GpWmfPlaceableFileHeader> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpWmfPlaceableFileHeader'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(E244EDF0-9096-42DD-944D-3BE54248689F)]
struct tagGpWmfPlaceableFileHeader {
	unsigned long Key;
	short Hmf;
	GpWMFRect16 BoundingBox;
	short Inch;
	unsigned long Reserved;
	short Checksum;
} GpWmfPlaceableFileHeader;
'!
!GpWmfPlaceableFileHeader categoriesForClass!Unclassified! !
!GpWmfPlaceableFileHeader methodsFor!

BoundingBox
	"Answer the receiver's BoundingBox field as a Smalltalk object."

	^GpWMFRect16 fromAddress: (bytes yourAddress + 6)!

BoundingBox: anObject
	"Set the receiver's BoundingBox field to the value of anObject."

	anObject replaceBytesOf: bytes from: 7 to: 14 startingAt: 1!

Checksum
	"Answer the receiver's Checksum field as a Smalltalk object."

	^(bytes swordAtOffset: 20)!

Checksum: anObject
	"Set the receiver's Checksum field to the value of anObject."

	bytes swordAtOffset: 20 put: anObject!

Hmf
	"Answer the receiver's Hmf field as a Smalltalk object."

	^(bytes swordAtOffset: 4)!

Hmf: anObject
	"Set the receiver's Hmf field to the value of anObject."

	bytes swordAtOffset: 4 put: anObject!

Inch
	"Answer the receiver's Inch field as a Smalltalk object."

	^(bytes swordAtOffset: 14)!

Inch: anObject
	"Set the receiver's Inch field to the value of anObject."

	bytes swordAtOffset: 14 put: anObject!

Key
	"Answer the receiver's Key field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

Key: anObject
	"Set the receiver's Key field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

Reserved
	"Answer the receiver's Reserved field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

Reserved: anObject
	"Set the receiver's Reserved field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject! !
!GpWmfPlaceableFileHeader categoriesFor: #BoundingBox!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #BoundingBox:!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Checksum!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Checksum:!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Hmf!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Hmf:!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Inch!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Inch:!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Key!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Key:!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Reserved!**compiled accessors**!public! !
!GpWmfPlaceableFileHeader categoriesFor: #Reserved:!**compiled accessors**!public! !

!GpWmfPlaceableFileHeader class methodsFor!

defineFields
	"Define the fields of the GpWmfPlaceableFileHeader structure.
		GpWmfPlaceableFileHeader compileDefinition
	
		typedef [uuid(E244EDF0-9096-42DD-944D-3BE54248689F)]
		struct tagGpWmfPlaceableFileHeader {
			[helpstring('GDIP_WMF_PLACEABLEKEY')] unsigned long Key;
			[helpstring('Metafile HANDLE number (always 0)')] short Hmf;
			[helpstring('Coordinates in metafile units')] GpWMFRect16 BoundingBox;
			[helpstring('Number of metafile units per inch')] short Inch;
			[helpstring('Reserved (always 0)')] unsigned long Reserved;
			[helpstring('Checksum value for previous 10 WORDs')] short Checksum;
		} GpWmfPlaceableFileHeader;
"

	self
		defineField: #Key type: DWORDField new offset: 0;
		defineField: #Hmf type: SWORDField new offset: 4;
		defineField: #BoundingBox type: (StructureField type: GpWMFRect16) offset: 6;
		defineField: #Inch type: SWORDField new offset: 14;
		defineField: #Reserved type: DWORDField new offset: 16;
		defineField: #Checksum type: SWORDField new offset: 20.
	self byteSize: 24! !
!GpWmfPlaceableFileHeader class categoriesFor: #defineFields!**auto generated**!initializing!public! !

