"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPLGBLT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPLGBLT guid: (GUID fromString: '{cdae1f25-39c4-4555-985b-3b2cd197d3e0}')!
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
		fromAddress: bytes yourAddress + ##(self offsetOf: #aptlDest)
		length: 3
		elementClass: POINTL!

aptlDest: aStructureArrayOfPOINTL
	"Set the receiver's 'aptlDest' field to the value of the argument, aStructureArrayOfPOINTL"

	| size |
	size := aStructureArrayOfPOINTL byteSize min: ##(3 * POINTL basicByteSize).
	aStructureArrayOfPOINTL
		replaceBytesOf: bytes
		from: ##((self offsetOf: #aptlDest) + 1)
		to: ##(self offsetOf: #aptlDest) + size
		startingAt: 1!

cbBitsMask
	"Answer the <Integer> value of the receiver's 'cbBitsMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBitsMask)!

cbBitsMask: anInteger
	"Set the receiver's 'cbBitsMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbBitsMask) put: anInteger!

cbBitsSrc
	"Answer the <Integer> value of the receiver's 'cbBitsSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBitsSrc)!

cbBitsSrc: anInteger
	"Set the receiver's 'cbBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbBitsSrc) put: anInteger!

cbBmiMask
	"Answer the <Integer> value of the receiver's 'cbBmiMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBmiMask)!

cbBmiMask: anInteger
	"Set the receiver's 'cbBmiMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbBmiMask) put: anInteger!

cbBmiSrc
	"Answer the <Integer> value of the receiver's 'cbBmiSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBmiSrc)!

cbBmiSrc: anInteger
	"Set the receiver's 'cbBmiSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbBmiSrc) put: anInteger!

crBkColorSrc
	"Answer the <Integer> value of the receiver's 'crBkColorSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #crBkColorSrc)!

crBkColorSrc: anInteger
	"Set the receiver's 'crBkColorSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #crBkColorSrc) put: anInteger!

cxSrc
	"Answer the <Integer> value of the receiver's 'cxSrc' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cxSrc)!

cxSrc: anInteger
	"Set the receiver's 'cxSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cxSrc) put: anInteger!

cySrc
	"Answer the <Integer> value of the receiver's 'cySrc' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cySrc)!

cySrc: anInteger
	"Set the receiver's 'cySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cySrc) put: anInteger!

iUsageMask
	"Answer the <Integer> value of the receiver's 'iUsageMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #iUsageMask)!

iUsageMask: anInteger
	"Set the receiver's 'iUsageMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #iUsageMask) put: anInteger!

iUsageSrc
	"Answer the <Integer> value of the receiver's 'iUsageSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #iUsageSrc)!

iUsageSrc: anInteger
	"Set the receiver's 'iUsageSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #iUsageSrc) put: anInteger!

offBitsMask
	"Answer the <Integer> value of the receiver's 'offBitsMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offBitsMask)!

offBitsMask: anInteger
	"Set the receiver's 'offBitsMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offBitsMask) put: anInteger!

offBitsSrc
	"Answer the <Integer> value of the receiver's 'offBitsSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offBitsSrc)!

offBitsSrc: anInteger
	"Set the receiver's 'offBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offBitsSrc) put: anInteger!

offBmiMask
	"Answer the <Integer> value of the receiver's 'offBmiMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offBmiMask)!

offBmiMask: anInteger
	"Set the receiver's 'offBmiMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offBmiMask) put: anInteger!

offBmiSrc
	"Answer the <Integer> value of the receiver's 'offBmiSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offBmiSrc)!

offBmiSrc: anInteger
	"Set the receiver's 'offBmiSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offBmiSrc) put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1!

xformSrc
	"Answer the <XFORM> value of the receiver's 'xformSrc' field."

	^XFORM fromAddress: bytes yourAddress + ##(self offsetOf: #xformSrc)!

xformSrc: aXFORM
	"Set the receiver's 'xformSrc' field to the value of the argument, aXFORM"

	aXFORM
		replaceBytesOf: bytes
		from: ##((self offsetOf: #xformSrc) + 1)
		to: ##((self offsetOf: #xformSrc) + XFORM basicByteSize)
		startingAt: 1!

xMask
	"Answer the <Integer> value of the receiver's 'xMask' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #xMask)!

xMask: anInteger
	"Set the receiver's 'xMask' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #xMask) put: anInteger!

xSrc
	"Answer the <Integer> value of the receiver's 'xSrc' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #xSrc)!

xSrc: anInteger
	"Set the receiver's 'xSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #xSrc) put: anInteger!

yMask
	"Answer the <Integer> value of the receiver's 'yMask' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #yMask)!

yMask: anInteger
	"Set the receiver's 'yMask' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #yMask) put: anInteger!

ySrc
	"Answer the <Integer> value of the receiver's 'ySrc' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #ySrc)!

ySrc: anInteger
	"Set the receiver's 'ySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #ySrc) put: anInteger! !
!EMRPLGBLT categoriesFor: #aptlDest!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #aptlDest:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cbBitsMask!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cbBitsMask:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cbBitsSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cbBitsSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cbBmiMask!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cbBmiMask:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cbBmiSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cbBmiSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #crBkColorSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #crBkColorSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cxSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cxSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cySrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #cySrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #iUsageMask!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #iUsageMask:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #iUsageSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #iUsageSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #offBitsMask!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #offBitsMask:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #offBitsSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #offBitsSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #offBmiMask!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #offBmiMask:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #offBmiSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #offBmiSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #xformSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #xformSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #xMask!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #xMask:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #xSrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #xSrc:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #yMask!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #yMask:!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #ySrc!**compiled accessors**!public! !
!EMRPLGBLT categoriesFor: #ySrc:!**compiled accessors**!public! !

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
!EMRPLGBLT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRPLGBLT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRPLGBLT class categoriesFor: #iTypes!constants!public! !

