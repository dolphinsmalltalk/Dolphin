"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRPLGBLT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRPLGBLT_Size' -> 16r8C.
			'_OffsetOf_aptlDest' -> 16r18.
			'_OffsetOf_cbBitsMask' -> 16r88.
			'_OffsetOf_cbBitsSrc' -> 16r6C.
			'_OffsetOf_cbBmiMask' -> 16r80.
			'_OffsetOf_cbBmiSrc' -> 16r64.
			'_OffsetOf_crBkColorSrc' -> 16r58.
			'_OffsetOf_cxSrc' -> 16r38.
			'_OffsetOf_cySrc' -> 16r3C.
			'_OffsetOf_iUsageMask' -> 16r78.
			'_OffsetOf_iUsageSrc' -> 16r5C.
			'_OffsetOf_offBitsMask' -> 16r84.
			'_OffsetOf_offBitsSrc' -> 16r68.
			'_OffsetOf_offBmiMask' -> 16r7C.
			'_OffsetOf_offBmiSrc' -> 16r60.
			'_OffsetOf_rclBounds' -> 16r8.
			'_OffsetOf_xformSrc' -> 16r40.
			'_OffsetOf_xMask' -> 16r70.
			'_OffsetOf_xSrc' -> 16r30.
			'_OffsetOf_yMask' -> 16r74.
			'_OffsetOf_ySrc' -> 16r34
		}!
OS.EMRPLGBLT guid: (Core.GUID fromString: '{cdae1f25-39c4-4555-985b-3b2cd197d3e0}')!
OS.EMRPLGBLT comment: '<EMRPLGBLT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPLGBLT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(CDAE1F25-39C4-4555-985B-3B2CD197D3E0)]
struct tagEMRPLGBLT {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	POINTL aptlDest[3];
	long xSrc;
	long ySrc;
	long cxSrc;
	long cySrc;
	[helpstring("Source DC transform")] XFORM xformSrc;
	[helpstring("Source DC BkColor in RGB")] COLORREF crBkColorSrc;
	[helpstring("Source bitmap info color table usage")] DWORD iUsageSrc;
	[helpstring("Offset to the source BITMAPINFO structure")] DWORD offBmiSrc;
	[helpstring("Size of the source BITMAPINFO structure")] DWORD cbBmiSrc;
	[helpstring("Offset to the source bitmap bits")] DWORD offBitsSrc;
	[helpstring("Size of the source bitmap bits")] DWORD cbBitsSrc;
	long xMask;
	long yMask;
	[helpstring("Mask bitmap info color table usage")] DWORD iUsageMask;
	[helpstring("Offset to the mask BITMAPINFO structure if any")] DWORD offBmiMask;
	[helpstring("Size of the mask BITMAPINFO structure if any")] DWORD cbBmiMask;
	[helpstring("Offset to the mask bitmap bits if any")] DWORD offBitsMask;
	[helpstring("Size of the mask bitmap bits if any")] DWORD cbBitsMask;
} EMRPLGBLT;
'!
!OS.EMRPLGBLT categoriesForClass!Win32-Structs! !
!OS.EMRPLGBLT methodsFor!

aptlDest
	"Answer the <StructureArray> value of the receiver's 'aptlDest' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_aptlDest
		length: 3
		elementClass: POINTL!

aptlDest: aStructureArrayOfPOINTL
	"Set the receiver's 'aptlDest' field to the value of the argument, aStructureArrayOfPOINTL"

	| size |
	size := aStructureArrayOfPOINTL byteSize min: ##(3 * POINTL._POINTL_Size).
	aStructureArrayOfPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_aptlDest + 1)
		to: _OffsetOf_aptlDest + size
		startingAt: 1!

cbBitsMask
	"Answer the <Integer> value of the receiver's 'cbBitsMask' field."

	^bytes uint32AtOffset: _OffsetOf_cbBitsMask!

cbBitsMask: anInteger
	"Set the receiver's 'cbBitsMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbBitsMask put: anInteger!

cbBitsSrc
	"Answer the <Integer> value of the receiver's 'cbBitsSrc' field."

	^bytes uint32AtOffset: _OffsetOf_cbBitsSrc!

cbBitsSrc: anInteger
	"Set the receiver's 'cbBitsSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbBitsSrc put: anInteger!

cbBmiMask
	"Answer the <Integer> value of the receiver's 'cbBmiMask' field."

	^bytes uint32AtOffset: _OffsetOf_cbBmiMask!

cbBmiMask: anInteger
	"Set the receiver's 'cbBmiMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbBmiMask put: anInteger!

cbBmiSrc
	"Answer the <Integer> value of the receiver's 'cbBmiSrc' field."

	^bytes uint32AtOffset: _OffsetOf_cbBmiSrc!

cbBmiSrc: anInteger
	"Set the receiver's 'cbBmiSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbBmiSrc put: anInteger!

crBkColorSrc
	"Answer the <Integer> value of the receiver's 'crBkColorSrc' field."

	^bytes uint32AtOffset: _OffsetOf_crBkColorSrc!

crBkColorSrc: anInteger
	"Set the receiver's 'crBkColorSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_crBkColorSrc put: anInteger!

cxSrc
	"Answer the <Integer> value of the receiver's 'cxSrc' field."

	^bytes int32AtOffset: _OffsetOf_cxSrc!

cxSrc: anInteger
	"Set the receiver's 'cxSrc' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cxSrc put: anInteger!

cySrc
	"Answer the <Integer> value of the receiver's 'cySrc' field."

	^bytes int32AtOffset: _OffsetOf_cySrc!

cySrc: anInteger
	"Set the receiver's 'cySrc' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cySrc put: anInteger!

iUsageMask
	"Answer the <Integer> value of the receiver's 'iUsageMask' field."

	^bytes uint32AtOffset: _OffsetOf_iUsageMask!

iUsageMask: anInteger
	"Set the receiver's 'iUsageMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iUsageMask put: anInteger!

iUsageSrc
	"Answer the <Integer> value of the receiver's 'iUsageSrc' field."

	^bytes uint32AtOffset: _OffsetOf_iUsageSrc!

iUsageSrc: anInteger
	"Set the receiver's 'iUsageSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iUsageSrc put: anInteger!

offBitsMask
	"Answer the <Integer> value of the receiver's 'offBitsMask' field."

	^bytes uint32AtOffset: _OffsetOf_offBitsMask!

offBitsMask: anInteger
	"Set the receiver's 'offBitsMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offBitsMask put: anInteger!

offBitsSrc
	"Answer the <Integer> value of the receiver's 'offBitsSrc' field."

	^bytes uint32AtOffset: _OffsetOf_offBitsSrc!

offBitsSrc: anInteger
	"Set the receiver's 'offBitsSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offBitsSrc put: anInteger!

offBmiMask
	"Answer the <Integer> value of the receiver's 'offBmiMask' field."

	^bytes uint32AtOffset: _OffsetOf_offBmiMask!

offBmiMask: anInteger
	"Set the receiver's 'offBmiMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offBmiMask put: anInteger!

offBmiSrc
	"Answer the <Integer> value of the receiver's 'offBmiSrc' field."

	^bytes uint32AtOffset: _OffsetOf_offBmiSrc!

offBmiSrc: anInteger
	"Set the receiver's 'offBmiSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offBmiSrc put: anInteger!

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

xformSrc
	"Answer the <XFORM> value of the receiver's 'xformSrc' field."

	^XFORM fromAddress: bytes yourAddress + _OffsetOf_xformSrc!

xformSrc: aXFORM
	"Set the receiver's 'xformSrc' field to the value of the argument, aXFORM"

	aXFORM
		replaceBytesOf: bytes
		from: ##(_OffsetOf_xformSrc + 1)
		to: ##(_OffsetOf_xformSrc + XFORM._XFORM_Size)
		startingAt: 1!

xMask
	"Answer the <Integer> value of the receiver's 'xMask' field."

	^bytes int32AtOffset: _OffsetOf_xMask!

xMask: anInteger
	"Set the receiver's 'xMask' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_xMask put: anInteger!

xSrc
	"Answer the <Integer> value of the receiver's 'xSrc' field."

	^bytes int32AtOffset: _OffsetOf_xSrc!

xSrc: anInteger
	"Set the receiver's 'xSrc' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_xSrc put: anInteger!

yMask
	"Answer the <Integer> value of the receiver's 'yMask' field."

	^bytes int32AtOffset: _OffsetOf_yMask!

yMask: anInteger
	"Set the receiver's 'yMask' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_yMask put: anInteger!

ySrc
	"Answer the <Integer> value of the receiver's 'ySrc' field."

	^bytes int32AtOffset: _OffsetOf_ySrc!

ySrc: anInteger
	"Set the receiver's 'ySrc' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_ySrc put: anInteger! !
!OS.EMRPLGBLT categoriesForMethods!
aptlDest!**compiled accessors**!public! !
aptlDest:!**compiled accessors**!public! !
cbBitsMask!**compiled accessors**!public! !
cbBitsMask:!**compiled accessors**!public! !
cbBitsSrc!**compiled accessors**!public! !
cbBitsSrc:!**compiled accessors**!public! !
cbBmiMask!**compiled accessors**!public! !
cbBmiMask:!**compiled accessors**!public! !
cbBmiSrc!**compiled accessors**!public! !
cbBmiSrc:!**compiled accessors**!public! !
crBkColorSrc!**compiled accessors**!public! !
crBkColorSrc:!**compiled accessors**!public! !
cxSrc!**compiled accessors**!public! !
cxSrc:!**compiled accessors**!public! !
cySrc!**compiled accessors**!public! !
cySrc:!**compiled accessors**!public! !
iUsageMask!**compiled accessors**!public! !
iUsageMask:!**compiled accessors**!public! !
iUsageSrc!**compiled accessors**!public! !
iUsageSrc:!**compiled accessors**!public! !
offBitsMask!**compiled accessors**!public! !
offBitsMask:!**compiled accessors**!public! !
offBitsSrc!**compiled accessors**!public! !
offBitsSrc:!**compiled accessors**!public! !
offBmiMask!**compiled accessors**!public! !
offBmiMask:!**compiled accessors**!public! !
offBmiSrc!**compiled accessors**!public! !
offBmiSrc:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
xformSrc!**compiled accessors**!public! !
xformSrc:!**compiled accessors**!public! !
xMask!**compiled accessors**!public! !
xMask:!**compiled accessors**!public! !
xSrc!**compiled accessors**!public! !
xSrc:!**compiled accessors**!public! !
yMask!**compiled accessors**!public! !
yMask:!**compiled accessors**!public! !
ySrc!**compiled accessors**!public! !
ySrc:!**compiled accessors**!public! !
!

!OS.EMRPLGBLT class methodsFor!

byteSize
	^_EMRPLGBLT_Size!

defineFields
	"Define the fields of the EMRPLGBLT structure.

	EMRPLGBLT  compileDefinition

		typedef [uuid(CDAE1F25-39C4-4555-985B-3B2CD197D3E0)]
		struct tagEMRPLGBLT {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			POINTL aptlDest[3];
			long xSrc;
			long ySrc;
			long cxSrc;
			long cySrc;
			[helpstring('Source DC transform')] XFORM xformSrc;
			[helpstring('Source DC BkColor in RGB')] COLORREF crBkColorSrc;
			[helpstring('Source bitmap info color table usage')] DWORD iUsageSrc;
			[helpstring('Offset to the source BITMAPINFO structure')] DWORD offBmiSrc;
			[helpstring('Size of the source BITMAPINFO structure')] DWORD cbBmiSrc;
			[helpstring('Offset to the source bitmap bits')] DWORD offBitsSrc;
			[helpstring('Size of the source bitmap bits')] DWORD cbBitsSrc;
			long xMask;
			long yMask;
			[helpstring('Mask bitmap info color table usage')] DWORD iUsageMask;
			[helpstring('Offset to the mask BITMAPINFO structure if any')] DWORD offBmiMask;
			[helpstring('Size of the mask BITMAPINFO structure if any')] DWORD cbBmiMask;
			[helpstring('Offset to the mask bitmap bits if any')] DWORD offBitsMask;
			[helpstring('Size of the mask bitmap bits if any')] DWORD cbBitsMask;
		} EMRPLGBLT;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #aptlDest
			type: (StructureArrayField type: POINTL length: 3)
			offset: 24;
		defineField: #xSrc
			type: Int32Field new
			offset: 48;
		defineField: #ySrc
			type: Int32Field new
			offset: 52;
		defineField: #cxSrc
			type: Int32Field new
			offset: 56;
		defineField: #cySrc
			type: Int32Field new
			offset: 60;
		defineField: #xformSrc
			type: (StructureField type: XFORM)
			offset: 64;
		defineField: #crBkColorSrc
			type: UInt32Field new
			offset: 88;
		defineField: #iUsageSrc
			type: UInt32Field new
			offset: 92;
		defineField: #offBmiSrc
			type: UInt32Field new
			offset: 96;
		defineField: #cbBmiSrc
			type: UInt32Field new
			offset: 100;
		defineField: #offBitsSrc
			type: UInt32Field new
			offset: 104;
		defineField: #cbBitsSrc
			type: UInt32Field new
			offset: 108;
		defineField: #xMask
			type: Int32Field new
			offset: 112;
		defineField: #yMask
			type: Int32Field new
			offset: 116;
		defineField: #iUsageMask
			type: UInt32Field new
			offset: 120;
		defineField: #offBmiMask
			type: UInt32Field new
			offset: 124;
		defineField: #cbBmiMask
			type: UInt32Field new
			offset: 128;
		defineField: #offBitsMask
			type: UInt32Field new
			offset: 132;
		defineField: #cbBitsMask
			type: UInt32Field new
			offset: 136.
	self byteSize: 140!

getFieldNames
	^#(#iType #nSize #rclBounds #aptlDest #xSrc #ySrc #cxSrc #cySrc #xformSrc #crBkColorSrc #iUsageSrc #offBmiSrc #cbBmiSrc #offBitsSrc #cbBitsSrc #xMask #yMask #iUsageMask #offBmiMask #cbBmiMask #offBitsMask #cbBitsMask)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_PLGBLT}! !
!OS.EMRPLGBLT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

