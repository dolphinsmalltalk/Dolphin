"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRMASKBLT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRMASKBLT_Size' -> 16r80.
			'_OffsetOf_cbBitsMask' -> 16r7C.
			'_OffsetOf_cbBitsSrc' -> 16r60.
			'_OffsetOf_cbBmiMask' -> 16r74.
			'_OffsetOf_cbBmiSrc' -> 16r58.
			'_OffsetOf_crBkColorSrc' -> 16r4C.
			'_OffsetOf_cxDest' -> 16r20.
			'_OffsetOf_cyDest' -> 16r24.
			'_OffsetOf_dwRop' -> 16r28.
			'_OffsetOf_iUsageMask' -> 16r6C.
			'_OffsetOf_iUsageSrc' -> 16r50.
			'_OffsetOf_offBitsMask' -> 16r78.
			'_OffsetOf_offBitsSrc' -> 16r5C.
			'_OffsetOf_offBmiMask' -> 16r70.
			'_OffsetOf_offBmiSrc' -> 16r54.
			'_OffsetOf_rclBounds' -> 16r8.
			'_OffsetOf_xDest' -> 16r18.
			'_OffsetOf_xformSrc' -> 16r34.
			'_OffsetOf_xMask' -> 16r64.
			'_OffsetOf_xSrc' -> 16r2C.
			'_OffsetOf_yDest' -> 16r1C.
			'_OffsetOf_yMask' -> 16r68.
			'_OffsetOf_ySrc' -> 16r30
		}!

OS.EMRMASKBLT guid: (Core.GUID fromString: '{99001d44-ed7a-4cee-84b9-dbcf1f67898b}')!

OS.EMRMASKBLT comment: '<EMRMASKBLT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRMASKBLT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(99001D44-ED7A-4CEE-84B9-DBCF1F67898B)]
struct tagEMRMASKBLT {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	long xDest;
	long yDest;
	long cxDest;
	long cyDest;
	DWORD dwRop;
	long xSrc;
	long ySrc;
	[helpstring("Source DC transform")] XFORM xformSrc;
	[helpstring("Source DC BkColor in RGB")] COLORREF crBkColorSrc;
	[helpstring("Source bitmap info color table usage (DIB_RGB_COLORS)")] DWORD iUsageSrc;
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
} EMRMASKBLT;
'!

!OS.EMRMASKBLT categoriesForClass!Win32-Structs! !

!OS.EMRMASKBLT methodsFor!

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

cxDest
	"Answer the <Integer> value of the receiver's 'cxDest' field."

	^bytes int32AtOffset: _OffsetOf_cxDest!

cxDest: anInteger
	"Set the receiver's 'cxDest' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cxDest put: anInteger!

cyDest
	"Answer the <Integer> value of the receiver's 'cyDest' field."

	^bytes int32AtOffset: _OffsetOf_cyDest!

cyDest: anInteger
	"Set the receiver's 'cyDest' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cyDest put: anInteger!

dwRop
	"Answer the <Integer> value of the receiver's 'dwRop' field."

	^bytes uint32AtOffset: _OffsetOf_dwRop!

dwRop: anInteger
	"Set the receiver's 'dwRop' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwRop put: anInteger!

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

xDest
	"Answer the <Integer> value of the receiver's 'xDest' field."

	^bytes int32AtOffset: _OffsetOf_xDest!

xDest: anInteger
	"Set the receiver's 'xDest' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_xDest put: anInteger!

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

yDest
	"Answer the <Integer> value of the receiver's 'yDest' field."

	^bytes int32AtOffset: _OffsetOf_yDest!

yDest: anInteger
	"Set the receiver's 'yDest' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_yDest put: anInteger!

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

!OS.EMRMASKBLT categoriesForMethods!
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
cxDest!**compiled accessors**!public! !
cxDest:!**compiled accessors**!public! !
cyDest!**compiled accessors**!public! !
cyDest:!**compiled accessors**!public! !
dwRop!**compiled accessors**!public! !
dwRop:!**compiled accessors**!public! !
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
xDest!**compiled accessors**!public! !
xDest:!**compiled accessors**!public! !
xformSrc!**compiled accessors**!public! !
xformSrc:!**compiled accessors**!public! !
xMask!**compiled accessors**!public! !
xMask:!**compiled accessors**!public! !
xSrc!**compiled accessors**!public! !
xSrc:!**compiled accessors**!public! !
yDest!**compiled accessors**!public! !
yDest:!**compiled accessors**!public! !
yMask!**compiled accessors**!public! !
yMask:!**compiled accessors**!public! !
ySrc!**compiled accessors**!public! !
ySrc:!**compiled accessors**!public! !
!

!OS.EMRMASKBLT class methodsFor!

byteSize
	^_EMRMASKBLT_Size!

defineFields
	"Define the fields of the EMRMASKBLT structure.

	EMRMASKBLT  compileDefinition

		typedef [uuid(99001D44-ED7A-4CEE-84B9-DBCF1F67898B)]
		struct tagEMRMASKBLT {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			long xDest;
			long yDest;
			long cxDest;
			long cyDest;
			DWORD dwRop;
			long xSrc;
			long ySrc;
			[helpstring('Source DC transform')] XFORM xformSrc;
			[helpstring('Source DC BkColor in RGB')] COLORREF crBkColorSrc;
			[helpstring('Source bitmap info color table usage (DIB_RGB_COLORS)')] DWORD iUsageSrc;
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
		} EMRMASKBLT;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #xDest
			type: Int32Field new
			offset: 24;
		defineField: #yDest
			type: Int32Field new
			offset: 28;
		defineField: #cxDest
			type: Int32Field new
			offset: 32;
		defineField: #cyDest
			type: Int32Field new
			offset: 36;
		defineField: #dwRop
			type: UInt32Field new
			offset: 40;
		defineField: #xSrc
			type: Int32Field new
			offset: 44;
		defineField: #ySrc
			type: Int32Field new
			offset: 48;
		defineField: #xformSrc
			type: (StructureField type: XFORM)
			offset: 52;
		defineField: #crBkColorSrc
			type: UInt32Field new
			offset: 76;
		defineField: #iUsageSrc
			type: UInt32Field new
			offset: 80;
		defineField: #offBmiSrc
			type: UInt32Field new
			offset: 84;
		defineField: #cbBmiSrc
			type: UInt32Field new
			offset: 88;
		defineField: #offBitsSrc
			type: UInt32Field new
			offset: 92;
		defineField: #cbBitsSrc
			type: UInt32Field new
			offset: 96;
		defineField: #xMask
			type: Int32Field new
			offset: 100;
		defineField: #yMask
			type: Int32Field new
			offset: 104;
		defineField: #iUsageMask
			type: UInt32Field new
			offset: 108;
		defineField: #offBmiMask
			type: UInt32Field new
			offset: 112;
		defineField: #cbBmiMask
			type: UInt32Field new
			offset: 116;
		defineField: #offBitsMask
			type: UInt32Field new
			offset: 120;
		defineField: #cbBitsMask
			type: UInt32Field new
			offset: 124.
	self byteSize: 128!

getFieldNames
	^#(#iType #nSize #rclBounds #xDest #yDest #cxDest #cyDest #dwRop #xSrc #ySrc #xformSrc #crBkColorSrc #iUsageSrc #offBmiSrc #cbBmiSrc #offBitsSrc #cbBitsSrc #xMask #yMask #iUsageMask #offBmiMask #cbBmiMask #offBitsMask #cbBitsMask)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_MASKBLT}! !

!OS.EMRMASKBLT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

