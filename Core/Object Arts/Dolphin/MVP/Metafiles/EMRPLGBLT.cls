"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRPLGBLT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_aptlDest _OffsetOf_cbBitsMask _OffsetOf_cbBitsSrc _OffsetOf_cbBmiMask _OffsetOf_cbBmiSrc _OffsetOf_crBkColorSrc _OffsetOf_cxSrc _OffsetOf_cySrc _OffsetOf_iUsageMask _OffsetOf_iUsageSrc _OffsetOf_offBitsMask _OffsetOf_offBitsSrc _OffsetOf_offBmiMask _OffsetOf_offBmiSrc _OffsetOf_rclBounds _OffsetOf_xformSrc _OffsetOf_xMask _OffsetOf_xSrc _OffsetOf_yMask _OffsetOf_ySrc'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMRPLGBLT guid: (GUID fromString: '{cdae1f25-39c4-4555-985b-3b2cd197d3e0}')!

EMRPLGBLT addClassConstant: '_OffsetOf_aptlDest' value: 16r18!
EMRPLGBLT addClassConstant: '_OffsetOf_cbBitsMask' value: 16r88!
EMRPLGBLT addClassConstant: '_OffsetOf_cbBitsSrc' value: 16r6C!
EMRPLGBLT addClassConstant: '_OffsetOf_cbBmiMask' value: 16r80!
EMRPLGBLT addClassConstant: '_OffsetOf_cbBmiSrc' value: 16r64!
EMRPLGBLT addClassConstant: '_OffsetOf_crBkColorSrc' value: 16r58!
EMRPLGBLT addClassConstant: '_OffsetOf_cxSrc' value: 16r38!
EMRPLGBLT addClassConstant: '_OffsetOf_cySrc' value: 16r3C!
EMRPLGBLT addClassConstant: '_OffsetOf_iUsageMask' value: 16r78!
EMRPLGBLT addClassConstant: '_OffsetOf_iUsageSrc' value: 16r5C!
EMRPLGBLT addClassConstant: '_OffsetOf_offBitsMask' value: 16r84!
EMRPLGBLT addClassConstant: '_OffsetOf_offBitsSrc' value: 16r68!
EMRPLGBLT addClassConstant: '_OffsetOf_offBmiMask' value: 16r7C!
EMRPLGBLT addClassConstant: '_OffsetOf_offBmiSrc' value: 16r60!
EMRPLGBLT addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
EMRPLGBLT addClassConstant: '_OffsetOf_xformSrc' value: 16r40!
EMRPLGBLT addClassConstant: '_OffsetOf_xMask' value: 16r70!
EMRPLGBLT addClassConstant: '_OffsetOf_xSrc' value: 16r30!
EMRPLGBLT addClassConstant: '_OffsetOf_yMask' value: 16r74!
EMRPLGBLT addClassConstant: '_OffsetOf_ySrc' value: 16r34!

EMRPLGBLT comment: '<EMRPLGBLT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPLGBLT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!EMRPLGBLT categoriesForClass!Win32-Structs! !

!EMRPLGBLT methodsFor!

aptlDest
	"Answer the <StructureArray> value of the receiver's 'aptlDest' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_aptlDest
		length: 3
		elementClass: POINTL!

aptlDest: aStructureArrayOfPOINTL
	"Set the receiver's 'aptlDest' field to the value of the argument, aStructureArrayOfPOINTL"

	| size |
	size := aStructureArrayOfPOINTL byteSize min: ##(3 * POINTL basicByteSize).
	aStructureArrayOfPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_aptlDest + 1)
		to: _OffsetOf_aptlDest + size
		startingAt: 1!

cbBitsMask
	"Answer the <Integer> value of the receiver's 'cbBitsMask' field."

	^bytes dwordAtOffset: _OffsetOf_cbBitsMask!

cbBitsMask: anInteger
	"Set the receiver's 'cbBitsMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBitsMask put: anInteger!

cbBitsSrc
	"Answer the <Integer> value of the receiver's 'cbBitsSrc' field."

	^bytes dwordAtOffset: _OffsetOf_cbBitsSrc!

cbBitsSrc: anInteger
	"Set the receiver's 'cbBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBitsSrc put: anInteger!

cbBmiMask
	"Answer the <Integer> value of the receiver's 'cbBmiMask' field."

	^bytes dwordAtOffset: _OffsetOf_cbBmiMask!

cbBmiMask: anInteger
	"Set the receiver's 'cbBmiMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBmiMask put: anInteger!

cbBmiSrc
	"Answer the <Integer> value of the receiver's 'cbBmiSrc' field."

	^bytes dwordAtOffset: _OffsetOf_cbBmiSrc!

cbBmiSrc: anInteger
	"Set the receiver's 'cbBmiSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBmiSrc put: anInteger!

crBkColorSrc
	"Answer the <Integer> value of the receiver's 'crBkColorSrc' field."

	^bytes dwordAtOffset: _OffsetOf_crBkColorSrc!

crBkColorSrc: anInteger
	"Set the receiver's 'crBkColorSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_crBkColorSrc put: anInteger!

cxSrc
	"Answer the <Integer> value of the receiver's 'cxSrc' field."

	^bytes sdwordAtOffset: _OffsetOf_cxSrc!

cxSrc: anInteger
	"Set the receiver's 'cxSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxSrc put: anInteger!

cySrc
	"Answer the <Integer> value of the receiver's 'cySrc' field."

	^bytes sdwordAtOffset: _OffsetOf_cySrc!

cySrc: anInteger
	"Set the receiver's 'cySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cySrc put: anInteger!

iUsageMask
	"Answer the <Integer> value of the receiver's 'iUsageMask' field."

	^bytes dwordAtOffset: _OffsetOf_iUsageMask!

iUsageMask: anInteger
	"Set the receiver's 'iUsageMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iUsageMask put: anInteger!

iUsageSrc
	"Answer the <Integer> value of the receiver's 'iUsageSrc' field."

	^bytes dwordAtOffset: _OffsetOf_iUsageSrc!

iUsageSrc: anInteger
	"Set the receiver's 'iUsageSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iUsageSrc put: anInteger!

offBitsMask
	"Answer the <Integer> value of the receiver's 'offBitsMask' field."

	^bytes dwordAtOffset: _OffsetOf_offBitsMask!

offBitsMask: anInteger
	"Set the receiver's 'offBitsMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBitsMask put: anInteger!

offBitsSrc
	"Answer the <Integer> value of the receiver's 'offBitsSrc' field."

	^bytes dwordAtOffset: _OffsetOf_offBitsSrc!

offBitsSrc: anInteger
	"Set the receiver's 'offBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBitsSrc put: anInteger!

offBmiMask
	"Answer the <Integer> value of the receiver's 'offBmiMask' field."

	^bytes dwordAtOffset: _OffsetOf_offBmiMask!

offBmiMask: anInteger
	"Set the receiver's 'offBmiMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBmiMask put: anInteger!

offBmiSrc
	"Answer the <Integer> value of the receiver's 'offBmiSrc' field."

	^bytes dwordAtOffset: _OffsetOf_offBmiSrc!

offBmiSrc: anInteger
	"Set the receiver's 'offBmiSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBmiSrc put: anInteger!

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

xformSrc
	"Answer the <XFORM> value of the receiver's 'xformSrc' field."

	^XFORM fromAddress: bytes yourAddress + _OffsetOf_xformSrc!

xformSrc: aXFORM
	"Set the receiver's 'xformSrc' field to the value of the argument, aXFORM"

	aXFORM
		replaceBytesOf: bytes
		from: ##(_OffsetOf_xformSrc + 1)
		to: ##(_OffsetOf_xformSrc + XFORM basicByteSize)
		startingAt: 1!

xMask
	"Answer the <Integer> value of the receiver's 'xMask' field."

	^bytes sdwordAtOffset: _OffsetOf_xMask!

xMask: anInteger
	"Set the receiver's 'xMask' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xMask put: anInteger!

xSrc
	"Answer the <Integer> value of the receiver's 'xSrc' field."

	^bytes sdwordAtOffset: _OffsetOf_xSrc!

xSrc: anInteger
	"Set the receiver's 'xSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xSrc put: anInteger!

yMask
	"Answer the <Integer> value of the receiver's 'yMask' field."

	^bytes sdwordAtOffset: _OffsetOf_yMask!

yMask: anInteger
	"Set the receiver's 'yMask' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_yMask put: anInteger!

ySrc
	"Answer the <Integer> value of the receiver's 'ySrc' field."

	^bytes sdwordAtOffset: _OffsetOf_ySrc!

ySrc: anInteger
	"Set the receiver's 'ySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_ySrc put: anInteger! !

!EMRPLGBLT categoriesForMethods!
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

!EMRPLGBLT class methodsFor!

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
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #aptlDest
			type: (StructureArrayField type: POINTL length: 3)
			offset: 24;
		defineField: #xSrc
			type: SDWORDField new
			offset: 48;
		defineField: #ySrc
			type: SDWORDField new
			offset: 52;
		defineField: #cxSrc
			type: SDWORDField new
			offset: 56;
		defineField: #cySrc
			type: SDWORDField new
			offset: 60;
		defineField: #xformSrc
			type: (StructureField type: XFORM)
			offset: 64;
		defineField: #crBkColorSrc
			type: DWORDField new
			offset: 88;
		defineField: #iUsageSrc
			type: DWORDField new
			offset: 92;
		defineField: #offBmiSrc
			type: DWORDField new
			offset: 96;
		defineField: #cbBmiSrc
			type: DWORDField new
			offset: 100;
		defineField: #offBitsSrc
			type: DWORDField new
			offset: 104;
		defineField: #cbBitsSrc
			type: DWORDField new
			offset: 108;
		defineField: #xMask
			type: SDWORDField new
			offset: 112;
		defineField: #yMask
			type: SDWORDField new
			offset: 116;
		defineField: #iUsageMask
			type: DWORDField new
			offset: 120;
		defineField: #offBmiMask
			type: DWORDField new
			offset: 124;
		defineField: #cbBmiMask
			type: DWORDField new
			offset: 128;
		defineField: #offBitsMask
			type: DWORDField new
			offset: 132;
		defineField: #cbBitsMask
			type: DWORDField new
			offset: 136.
	self byteSize: 140!

getFieldNames
	^#(#iType #nSize #rclBounds #aptlDest #xSrc #ySrc #cxSrc #cySrc #xformSrc #crBkColorSrc #iUsageSrc #offBmiSrc #cbBmiSrc #offBitsSrc #cbBitsSrc #xMask #yMask #iUsageMask #offBmiMask #cbBmiMask #offBitsMask #cbBitsMask)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_PLGBLT! !

!EMRPLGBLT class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

