"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #ENHMETAHEADER3
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dSignature _OffsetOf_iType _OffsetOf_nBytes _OffsetOf_nDescription _OffsetOf_nHandles _OffsetOf_nPalEntries _OffsetOf_nRecords _OffsetOf_nSize _OffsetOf_nVersion _OffsetOf_offDescription _OffsetOf_rclBounds _OffsetOf_rclFrame _OffsetOf_sReserved _OffsetOf_szlDevice _OffsetOf_szlMillimeters'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ENHMETAHEADER3 guid: (GUID fromString: '{1b5c3dcf-8ea0-47df-b752-442dd272a353}')!

ENHMETAHEADER3 addClassConstant: '_OffsetOf_dSignature' value: 16r28!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_iType' value: 16r0!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_nBytes' value: 16r30!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_nDescription' value: 16r3C!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_nHandles' value: 16r38!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_nPalEntries' value: 16r44!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_nRecords' value: 16r34!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_nSize' value: 16r4!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_nVersion' value: 16r2C!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_offDescription' value: 16r40!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_rclFrame' value: 16r18!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_sReserved' value: 16r3A!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_szlDevice' value: 16r48!
ENHMETAHEADER3 addClassConstant: '_OffsetOf_szlMillimeters' value: 16r50!

ENHMETAHEADER3 comment: '<ENHMETAHEADER3> is an <ExternalStructure> class to wrap the struct ''Gdiplus.ENHMETAHEADER3'' from type information in the ''GDI+ Library 1.0'' library.

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

!ENHMETAHEADER3 categoriesForClass!Unclassified! !

!ENHMETAHEADER3 methodsFor!

dSignature
	"Answer the <Integer> value of the receiver's 'dSignature' field."

	^bytes dwordAtOffset: _OffsetOf_dSignature!

dSignature: anInteger
	"Set the receiver's 'dSignature' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dSignature put: anInteger!

iType
	"Answer the <Integer> value of the receiver's 'iType' field."

	^bytes dwordAtOffset: _OffsetOf_iType!

iType: anInteger
	"Set the receiver's 'iType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iType put: anInteger!

nBytes
	"Answer the <Integer> value of the receiver's 'nBytes' field."

	^bytes dwordAtOffset: _OffsetOf_nBytes!

nBytes: anInteger
	"Set the receiver's 'nBytes' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nBytes put: anInteger!

nDescription
	"Answer the <Integer> value of the receiver's 'nDescription' field."

	^bytes dwordAtOffset: _OffsetOf_nDescription!

nDescription: anInteger
	"Set the receiver's 'nDescription' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nDescription put: anInteger!

nHandles
	"Answer the <Integer> value of the receiver's 'nHandles' field."

	^bytes wordAtOffset: _OffsetOf_nHandles!

nHandles: anInteger
	"Set the receiver's 'nHandles' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_nHandles put: anInteger!

nPalEntries
	"Answer the <Integer> value of the receiver's 'nPalEntries' field."

	^bytes dwordAtOffset: _OffsetOf_nPalEntries!

nPalEntries: anInteger
	"Set the receiver's 'nPalEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nPalEntries put: anInteger!

nRecords
	"Answer the <Integer> value of the receiver's 'nRecords' field."

	^bytes dwordAtOffset: _OffsetOf_nRecords!

nRecords: anInteger
	"Set the receiver's 'nRecords' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nRecords put: anInteger!

nSize
	"Answer the <Integer> value of the receiver's 'nSize' field."

	^bytes dwordAtOffset: _OffsetOf_nSize!

nSize: anInteger
	"Set the receiver's 'nSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nSize put: anInteger!

nVersion
	"Answer the <Integer> value of the receiver's 'nVersion' field."

	^bytes dwordAtOffset: _OffsetOf_nVersion!

nVersion: anInteger
	"Set the receiver's 'nVersion' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nVersion put: anInteger!

offDescription
	"Answer the <Integer> value of the receiver's 'offDescription' field."

	^bytes dwordAtOffset: _OffsetOf_offDescription!

offDescription: anInteger
	"Set the receiver's 'offDescription' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offDescription put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
		startingAt: 1!

rclFrame
	"Answer the <RECT> value of the receiver's 'rclFrame' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclFrame!

rclFrame: aRECT
	"Set the receiver's 'rclFrame' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclFrame + 1)
		to: ##(_OffsetOf_rclFrame + RECT basicByteSize)
		startingAt: 1!

sReserved
	"Answer the <Integer> value of the receiver's 'sReserved' field."

	^bytes wordAtOffset: _OffsetOf_sReserved!

sReserved: anInteger
	"Set the receiver's 'sReserved' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_sReserved put: anInteger!

szlDevice
	"Answer the <SIZE> value of the receiver's 'szlDevice' field."

	^SIZE fromAddress: bytes yourAddress + _OffsetOf_szlDevice!

szlDevice: aSIZE
	"Set the receiver's 'szlDevice' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlDevice + 1)
		to: ##(_OffsetOf_szlDevice + SIZE basicByteSize)
		startingAt: 1!

szlMillimeters
	"Answer the <SIZE> value of the receiver's 'szlMillimeters' field."

	^SIZE fromAddress: bytes yourAddress + _OffsetOf_szlMillimeters!

szlMillimeters: aSIZE
	"Set the receiver's 'szlMillimeters' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlMillimeters + 1)
		to: ##(_OffsetOf_szlMillimeters + SIZE basicByteSize)
		startingAt: 1! !

!ENHMETAHEADER3 categoriesForMethods!
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

!ENHMETAHEADER3 class methodsFor!

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
		defineField: #iType type: DWORDField new offset: 0;
		defineField: #nSize type: DWORDField new offset: 4;
		defineField: #rclBounds type: (StructureField type: RECT) offset: 8;
		defineField: #rclFrame type: (StructureField type: RECT) offset: 24;
		defineField: #dSignature type: DWORDField new offset: 40;
		defineField: #nVersion type: DWORDField new offset: 44;
		defineField: #nBytes type: DWORDField new offset: 48;
		defineField: #nRecords type: DWORDField new offset: 52;
		defineField: #nHandles type: WORDField new offset: 56;
		defineField: #sReserved type: WORDField new offset: 58;
		defineField: #nDescription type: DWORDField new offset: 60;
		defineField: #offDescription type: DWORDField new offset: 64;
		defineField: #nPalEntries type: DWORDField new offset: 68;
		defineField: #szlDevice type: (StructureField type: SIZE) offset: 72;
		defineField: #szlMillimeters type: (StructureField type: SIZE) offset: 80.
	self byteSize: 88!

getFieldNames
	^#(#iType #nSize #rclBounds #rclFrame #dSignature #nVersion #nBytes #nRecords #nHandles #sReserved #nDescription #offDescription #nPalEntries #szlDevice #szlMillimeters)! !

!ENHMETAHEADER3 class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

