"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure subclass: #'Graphics.Gdiplus.WmfPlaceableFileHeader'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_BoundingBox' -> 16r6.
		'_OffsetOf_Checksum' -> 16r14.
		'_OffsetOf_Hmf' -> 16r4.
		'_OffsetOf_Inch' -> 16rE.
		'_OffsetOf_Key' -> 16r0.
		'_OffsetOf_Reserved' -> 16r10.
		'_WmfPlaceableFileHeader_Size' -> 16r18
	}!
Graphics.Gdiplus.WmfPlaceableFileHeader guid: (Core.GUID fromString: '{e244edf0-9096-42dd-944d-3be54248689f}')!
Graphics.Gdiplus.WmfPlaceableFileHeader comment: '<GpWmfPlaceableFileHeader> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpWmfPlaceableFileHeader'' from type information in the ''GDI+ Library 1.0'' library.

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
!Graphics.Gdiplus.WmfPlaceableFileHeader methodsFor!

BoundingBox
	"Answer the <GpWMFRect16> value of the receiver's 'BoundingBox' field."

	^WMFRect16 fromAddress: bytes yourAddress + _OffsetOf_BoundingBox!

BoundingBox: aGpWMFRect16
	"Set the receiver's 'BoundingBox' field to the value of the argument, aGpWMFRect16"

	aGpWMFRect16
		replaceBytesOf: bytes
		from: ##(_OffsetOf_BoundingBox + 1)
		to: ##(_OffsetOf_BoundingBox + WMFRect16._WMFRect16_Size)
		startingAt: 1!

Checksum
	"Answer the <Integer> value of the receiver's 'Checksum' field."

	^bytes int16AtOffset: _OffsetOf_Checksum!

Checksum: anInteger
	"Set the receiver's 'Checksum' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_Checksum put: anInteger!

Hmf
	"Answer the <Integer> value of the receiver's 'Hmf' field."

	^bytes int16AtOffset: _OffsetOf_Hmf!

Hmf: anInteger
	"Set the receiver's 'Hmf' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_Hmf put: anInteger!

Inch
	"Answer the <Integer> value of the receiver's 'Inch' field."

	^bytes int16AtOffset: _OffsetOf_Inch!

Inch: anInteger
	"Set the receiver's 'Inch' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_Inch put: anInteger!

Key
	"Answer the <Integer> value of the receiver's 'Key' field."

	^bytes uint32AtOffset: _OffsetOf_Key!

Key: anInteger
	"Set the receiver's 'Key' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Key put: anInteger!

Reserved
	"Answer the <Integer> value of the receiver's 'Reserved' field."

	^bytes uint32AtOffset: _OffsetOf_Reserved!

Reserved: anInteger
	"Set the receiver's 'Reserved' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Reserved put: anInteger! !
!Graphics.Gdiplus.WmfPlaceableFileHeader categoriesForMethods!
BoundingBox!**compiled accessors**!public! !
BoundingBox:!**compiled accessors**!public! !
Checksum!**compiled accessors**!public! !
Checksum:!**compiled accessors**!public! !
Hmf!**compiled accessors**!public! !
Hmf:!**compiled accessors**!public! !
Inch!**compiled accessors**!public! !
Inch:!**compiled accessors**!public! !
Key!**compiled accessors**!public! !
Key:!**compiled accessors**!public! !
Reserved!**compiled accessors**!public! !
Reserved:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.WmfPlaceableFileHeader class methodsFor!

byteSize
	^_WmfPlaceableFileHeader_Size!

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
		defineField: #Key
			type: UInt32Field new
			offset: 0;
		defineField: #Hmf
			type: Int16Field new
			offset: 4;
		defineField: #BoundingBox
			type: (StructureField type: WMFRect16)
			offset: 6;
		defineField: #Inch
			type: Int16Field new
			offset: 14;
		defineField: #Reserved
			type: UInt32Field new
			offset: 16;
		defineField: #Checksum
			type: Int16Field new
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#Key #Hmf #BoundingBox #Inch #Reserved #Checksum)! !
!Graphics.Gdiplus.WmfPlaceableFileHeader class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

