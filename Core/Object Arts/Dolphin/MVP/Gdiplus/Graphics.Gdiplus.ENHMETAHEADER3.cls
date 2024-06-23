"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'Graphics.Gdiplus.ENHMETAHEADER3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ENHMETAHEADER3_Size' -> 16r58.
			'_OffsetOf_dSignature' -> 16r28.
			'_OffsetOf_iType' -> 16r0.
			'_OffsetOf_nBytes' -> 16r30.
			'_OffsetOf_nDescription' -> 16r3C.
			'_OffsetOf_nHandles' -> 16r38.
			'_OffsetOf_nPalEntries' -> 16r44.
			'_OffsetOf_nRecords' -> 16r34.
			'_OffsetOf_nSize' -> 16r4.
			'_OffsetOf_nVersion' -> 16r2C.
			'_OffsetOf_offDescription' -> 16r40.
			'_OffsetOf_rclBounds' -> 16r8.
			'_OffsetOf_rclFrame' -> 16r18.
			'_OffsetOf_sReserved' -> 16r3A.
			'_OffsetOf_szlDevice' -> 16r48.
			'_OffsetOf_szlMillimeters' -> 16r50
		}!

Graphics.Gdiplus.ENHMETAHEADER3 guid: (Core.GUID fromString: '{1b5c3dcf-8ea0-47df-b752-442dd272a353}')!

Graphics.Gdiplus.ENHMETAHEADER3 comment: '<ENHMETAHEADER3> is an <ExternalStructure> class to wrap the struct ''Gdiplus.ENHMETAHEADER3'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(1B5C3DCF-8EA0-47DF-B752-442DD272A353)]
struct tagENHMETAHEADER3 {
	unsigned long iType;
	unsigned long nSize;
	RECTL rclBounds;
	RECTL rclFrame;
	unsigned long dSignature;
	unsigned long nVersion;
	unsigned long nBytes;
	unsigned long nRecords;
	unsigned short nHandles;
	unsigned short sReserved;
	unsigned long nDescription;
	unsigned long offDescription;
	unsigned long nPalEntries;
	SIZEL szlDevice;
	SIZEL szlMillimeters;
} ENHMETAHEADER3;
'!

!Graphics.Gdiplus.ENHMETAHEADER3 methodsFor!

dSignature
	"Answer the <Integer> value of the receiver's 'dSignature' field."

	^bytes uint32AtOffset: _OffsetOf_dSignature!

dSignature: anInteger
	"Set the receiver's 'dSignature' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dSignature put: anInteger!

iType
	"Answer the <Integer> value of the receiver's 'iType' field."

	^bytes uint32AtOffset: _OffsetOf_iType!

iType: anInteger
	"Set the receiver's 'iType' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iType put: anInteger!

nBytes
	"Answer the <Integer> value of the receiver's 'nBytes' field."

	^bytes uint32AtOffset: _OffsetOf_nBytes!

nBytes: anInteger
	"Set the receiver's 'nBytes' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nBytes put: anInteger!

nDescription
	"Answer the <Integer> value of the receiver's 'nDescription' field."

	^bytes uint32AtOffset: _OffsetOf_nDescription!

nDescription: anInteger
	"Set the receiver's 'nDescription' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nDescription put: anInteger!

nHandles
	"Answer the <Integer> value of the receiver's 'nHandles' field."

	^bytes uint16AtOffset: _OffsetOf_nHandles!

nHandles: anInteger
	"Set the receiver's 'nHandles' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_nHandles put: anInteger!

nPalEntries
	"Answer the <Integer> value of the receiver's 'nPalEntries' field."

	^bytes uint32AtOffset: _OffsetOf_nPalEntries!

nPalEntries: anInteger
	"Set the receiver's 'nPalEntries' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nPalEntries put: anInteger!

nRecords
	"Answer the <Integer> value of the receiver's 'nRecords' field."

	^bytes uint32AtOffset: _OffsetOf_nRecords!

nRecords: anInteger
	"Set the receiver's 'nRecords' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nRecords put: anInteger!

nSize
	"Answer the <Integer> value of the receiver's 'nSize' field."

	^bytes uint32AtOffset: _OffsetOf_nSize!

nSize: anInteger
	"Set the receiver's 'nSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nSize put: anInteger!

nVersion
	"Answer the <Integer> value of the receiver's 'nVersion' field."

	^bytes uint32AtOffset: _OffsetOf_nVersion!

nVersion: anInteger
	"Set the receiver's 'nVersion' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nVersion put: anInteger!

offDescription
	"Answer the <Integer> value of the receiver's 'offDescription' field."

	^bytes uint32AtOffset: _OffsetOf_offDescription!

offDescription: anInteger
	"Set the receiver's 'offDescription' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offDescription put: anInteger!

rclBounds
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECTL
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL._RECTL_Size)
		startingAt: 1!

rclFrame
	"Answer the <RECTL> value of the receiver's 'rclFrame' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclFrame!

rclFrame: aRECTL
	"Set the receiver's 'rclFrame' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclFrame + 1)
		to: ##(_OffsetOf_rclFrame + RECTL._RECTL_Size)
		startingAt: 1!

sReserved
	"Answer the <Integer> value of the receiver's 'sReserved' field."

	^bytes uint16AtOffset: _OffsetOf_sReserved!

sReserved: anInteger
	"Set the receiver's 'sReserved' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_sReserved put: anInteger!

szlDevice
	"Answer the <SIZEL> value of the receiver's 'szlDevice' field."

	^SIZEL fromAddress: bytes yourAddress + _OffsetOf_szlDevice!

szlDevice: aSIZEL
	"Set the receiver's 'szlDevice' field to the value of the argument, aSIZEL"

	aSIZEL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlDevice + 1)
		to: ##(_OffsetOf_szlDevice + SIZEL._SIZEL_Size)
		startingAt: 1!

szlMillimeters
	"Answer the <SIZEL> value of the receiver's 'szlMillimeters' field."

	^SIZEL fromAddress: bytes yourAddress + _OffsetOf_szlMillimeters!

szlMillimeters: aSIZEL
	"Set the receiver's 'szlMillimeters' field to the value of the argument, aSIZEL"

	aSIZEL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlMillimeters + 1)
		to: ##(_OffsetOf_szlMillimeters + SIZEL._SIZEL_Size)
		startingAt: 1! !

!Graphics.Gdiplus.ENHMETAHEADER3 categoriesForMethods!
dSignature!**compiled accessors**!public! !
dSignature:!**compiled accessors**!public! !
iType!**compiled accessors**!public! !
iType:!**compiled accessors**!public! !
nBytes!**compiled accessors**!public! !
nBytes:!**compiled accessors**!public! !
nDescription!**compiled accessors**!public! !
nDescription:!**compiled accessors**!public! !
nHandles!**compiled accessors**!public! !
nHandles:!**compiled accessors**!public! !
nPalEntries!**compiled accessors**!public! !
nPalEntries:!**compiled accessors**!public! !
nRecords!**compiled accessors**!public! !
nRecords:!**compiled accessors**!public! !
nSize!**compiled accessors**!public! !
nSize:!**compiled accessors**!public! !
nVersion!**compiled accessors**!public! !
nVersion:!**compiled accessors**!public! !
offDescription!**compiled accessors**!public! !
offDescription:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
rclFrame!**compiled accessors**!public! !
rclFrame:!**compiled accessors**!public! !
sReserved!**compiled accessors**!public! !
sReserved:!**compiled accessors**!public! !
szlDevice!**compiled accessors**!public! !
szlDevice:!**compiled accessors**!public! !
szlMillimeters!**compiled accessors**!public! !
szlMillimeters:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.ENHMETAHEADER3 class methodsFor!

byteSize
	^_ENHMETAHEADER3_Size!

defineFields
	"Define the fields of the ENHMETAHEADER3 structure.
		ENHMETAHEADER3 compileDefinition
	
		typedef [uuid(1B5C3DCF-8EA0-47DF-B752-442DD272A353)]
		struct tagENHMETAHEADER3 {
			unsigned long iType;
			unsigned long nSize;
			RECTL rclBounds;
			RECTL rclFrame;
			unsigned long dSignature;
			unsigned long nVersion;
			unsigned long nBytes;
			unsigned long nRecords;
			unsigned short nHandles;
			unsigned short sReserved;
			unsigned long nDescription;
			unsigned long offDescription;
			unsigned long nPalEntries;
			SIZEL szlDevice;
			SIZEL szlMillimeters;
		} ENHMETAHEADER3;
"

	self
		defineField: #iType
			type: UInt32Field new
			offset: 0;
		defineField: #nSize
			type: UInt32Field new
			offset: 4;
		defineField: #rclBounds
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #rclFrame
			type: (StructureField type: RECTL)
			offset: 24;
		defineField: #dSignature
			type: UInt32Field new
			offset: 40;
		defineField: #nVersion
			type: UInt32Field new
			offset: 44;
		defineField: #nBytes
			type: UInt32Field new
			offset: 48;
		defineField: #nRecords
			type: UInt32Field new
			offset: 52;
		defineField: #nHandles
			type: UInt16Field new
			offset: 56;
		defineField: #sReserved
			type: UInt16Field new
			offset: 58;
		defineField: #nDescription
			type: UInt32Field new
			offset: 60;
		defineField: #offDescription
			type: UInt32Field new
			offset: 64;
		defineField: #nPalEntries
			type: UInt32Field new
			offset: 68;
		defineField: #szlDevice
			type: (StructureField type: SIZEL)
			offset: 72;
		defineField: #szlMillimeters
			type: (StructureField type: SIZEL)
			offset: 80.
	self byteSize: 88!

getFieldNames
	^#(#iType #nSize #rclBounds #rclFrame #dSignature #nVersion #nBytes #nRecords #nHandles #sReserved #nDescription #offDescription #nPalEntries #szlDevice #szlMillimeters)! !

!Graphics.Gdiplus.ENHMETAHEADER3 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

