"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRBITBLT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cbBitsSrc' -> 16r60.
		'_OffsetOf_cbBmiSrc' -> 16r58.
		'_OffsetOf_crBkColorSrc' -> 16r4C.
		'_OffsetOf_cxDest' -> 16r20.
		'_OffsetOf_cyDest' -> 16r24.
		'_OffsetOf_dwRop' -> 16r28.
		'_OffsetOf_iUsageSrc' -> 16r50.
		'_OffsetOf_offBitsSrc' -> 16r5C.
		'_OffsetOf_offBmiSrc' -> 16r54.
		'_OffsetOf_rclBounds' -> 16r8.
		'_OffsetOf_xDest' -> 16r18.
		'_OffsetOf_xformSrc' -> 16r34.
		'_OffsetOf_xSrc' -> 16r2C.
		'_OffsetOf_yDest' -> 16r1C.
		'_OffsetOf_ySrc' -> 16r30
	}!
OS.EMRBITBLT guid: (Core.GUID fromString: '{d5466d52-7472-4ffd-bd6b-49157e55918d}')!
OS.EMRBITBLT comment: '<EMRBITBLT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRBITBLT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(D5466D52-7472-4FFD-BD6B-49157E55918D)]
struct tagEMRBITBLT {
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
	[helpstring("Source bitmap info color table usage (DIB_RGB_COLORS")] DWORD iUsageSrc;
	[helpstring("Offset to the source BITMAPINFO structure")] DWORD offBmiSrc;
	[helpstring("Size of the source BITMAPINFO structure")] DWORD cbBmiSrc;
	[helpstring("Offset to the source bitmap bits")] DWORD offBitsSrc;
	[helpstring("Size of the source bitmap bits")] DWORD cbBitsSrc;
} EMRBITBLT;
'!
!OS.EMRBITBLT categoriesForClass!Win32-Structs! !
!OS.EMRBITBLT methodsFor!

cbBitsSrc
	"Answer the <Integer> value of the receiver's 'cbBitsSrc' field."

	^bytes dwordAtOffset: _OffsetOf_cbBitsSrc!

cbBitsSrc: anInteger
	"Set the receiver's 'cbBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBitsSrc put: anInteger!

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

cxDest
	"Answer the <Integer> value of the receiver's 'cxDest' field."

	^bytes sdwordAtOffset: _OffsetOf_cxDest!

cxDest: anInteger
	"Set the receiver's 'cxDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxDest put: anInteger!

cyDest
	"Answer the <Integer> value of the receiver's 'cyDest' field."

	^bytes sdwordAtOffset: _OffsetOf_cyDest!

cyDest: anInteger
	"Set the receiver's 'cyDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cyDest put: anInteger!

dwRop
	"Answer the <Integer> value of the receiver's 'dwRop' field."

	^bytes dwordAtOffset: _OffsetOf_dwRop!

dwRop: anInteger
	"Set the receiver's 'dwRop' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwRop put: anInteger!

iUsageSrc
	"Answer the <Integer> value of the receiver's 'iUsageSrc' field."

	^bytes dwordAtOffset: _OffsetOf_iUsageSrc!

iUsageSrc: anInteger
	"Set the receiver's 'iUsageSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iUsageSrc put: anInteger!

offBitsSrc
	"Answer the <Integer> value of the receiver's 'offBitsSrc' field."

	^bytes dwordAtOffset: _OffsetOf_offBitsSrc!

offBitsSrc: anInteger
	"Set the receiver's 'offBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBitsSrc put: anInteger!

offBmiSrc
	"Answer the <Integer> value of the receiver's 'offBmiSrc' field."

	^bytes dwordAtOffset: _OffsetOf_offBmiSrc!

offBmiSrc: anInteger
	"Set the receiver's 'offBmiSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBmiSrc put: anInteger!

rclBounds
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL basicByteSize)
		startingAt: 1!

xDest
	"Answer the <Integer> value of the receiver's 'xDest' field."

	^bytes sdwordAtOffset: _OffsetOf_xDest!

xDest: anInteger
	"Set the receiver's 'xDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xDest put: anInteger!

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

xSrc
	"Answer the <Integer> value of the receiver's 'xSrc' field."

	^bytes sdwordAtOffset: _OffsetOf_xSrc!

xSrc: anInteger
	"Set the receiver's 'xSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xSrc put: anInteger!

yDest
	"Answer the <Integer> value of the receiver's 'yDest' field."

	^bytes sdwordAtOffset: _OffsetOf_yDest!

yDest: anInteger
	"Set the receiver's 'yDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_yDest put: anInteger!

ySrc
	"Answer the <Integer> value of the receiver's 'ySrc' field."

	^bytes sdwordAtOffset: _OffsetOf_ySrc!

ySrc: anInteger
	"Set the receiver's 'ySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_ySrc put: anInteger! !
!OS.EMRBITBLT categoriesFor: #cbBitsSrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #cbBitsSrc:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #cbBmiSrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #cbBmiSrc:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #crBkColorSrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #crBkColorSrc:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #cxDest!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #cxDest:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #cyDest!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #cyDest:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #dwRop!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #dwRop:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #iUsageSrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #iUsageSrc:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #offBitsSrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #offBitsSrc:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #offBmiSrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #offBmiSrc:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #rclBounds!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #rclBounds:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #xDest!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #xDest:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #xformSrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #xformSrc:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #xSrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #xSrc:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #yDest!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #yDest:!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #ySrc!**compiled accessors**!public! !
!OS.EMRBITBLT categoriesFor: #ySrc:!**compiled accessors**!public! !

!OS.EMRBITBLT class methodsFor!

defineFields
	"Define the fields of the EMRBITBLT structure.

	EMRBITBLT  compileDefinition

		typedef [uuid(D5466D52-7472-4FFD-BD6B-49157E55918D)]
		struct tagEMRBITBLT {
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
			[helpstring('Source bitmap info color table usage (DIB_RGB_COLORS')] DWORD iUsageSrc;
			[helpstring('Offset to the source BITMAPINFO structure')] DWORD offBmiSrc;
			[helpstring('Size of the source BITMAPINFO structure')] DWORD cbBmiSrc;
			[helpstring('Offset to the source bitmap bits')] DWORD offBitsSrc;
			[helpstring('Size of the source bitmap bits')] DWORD cbBitsSrc;
		} EMRBITBLT;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #xDest
			type: SDWORDField new
			offset: 24;
		defineField: #yDest
			type: SDWORDField new
			offset: 28;
		defineField: #cxDest
			type: SDWORDField new
			offset: 32;
		defineField: #cyDest
			type: SDWORDField new
			offset: 36;
		defineField: #dwRop
			type: DWORDField new
			offset: 40;
		defineField: #xSrc
			type: SDWORDField new
			offset: 44;
		defineField: #ySrc
			type: SDWORDField new
			offset: 48;
		defineField: #xformSrc
			type: (StructureField type: XFORM)
			offset: 52;
		defineField: #crBkColorSrc
			type: DWORDField new
			offset: 76;
		defineField: #iUsageSrc
			type: DWORDField new
			offset: 80;
		defineField: #offBmiSrc
			type: DWORDField new
			offset: 84;
		defineField: #cbBmiSrc
			type: DWORDField new
			offset: 88;
		defineField: #offBitsSrc
			type: DWORDField new
			offset: 92;
		defineField: #cbBitsSrc
			type: DWORDField new
			offset: 96.
	self byteSize: 100!

getFieldNames
	^#(#iType #nSize #rclBounds #xDest #yDest #cxDest #cyDest #dwRop #xSrc #ySrc #xformSrc #crBkColorSrc #iUsageSrc #offBmiSrc #cbBmiSrc #offBitsSrc #cbBitsSrc)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_BITBLT}! !
!OS.EMRBITBLT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMRBITBLT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRBITBLT class categoriesFor: #iTypes!constants!public! !

