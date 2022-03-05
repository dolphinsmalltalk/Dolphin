"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRSTRETCHBLT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbBitsSrc _OffsetOf_cbBmiSrc _OffsetOf_crBkColorSrc _OffsetOf_cxDest _OffsetOf_cxSrc _OffsetOf_cyDest _OffsetOf_cySrc _OffsetOf_dwRop _OffsetOf_iUsageSrc _OffsetOf_offBitsSrc _OffsetOf_offBmiSrc _OffsetOf_rclBounds _OffsetOf_xDest _OffsetOf_xformSrc _OffsetOf_xSrc _OffsetOf_yDest _OffsetOf_ySrc'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSTRETCHBLT guid: (GUID fromString: '{04e7165e-c2d6-4a3d-8a28-d197f35d85a3}')!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_cbBitsSrc' value: 16r60!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_cbBmiSrc' value: 16r58!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_crBkColorSrc' value: 16r4C!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_cxDest' value: 16r20!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_cxSrc' value: 16r64!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_cyDest' value: 16r24!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_cySrc' value: 16r68!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_dwRop' value: 16r28!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_iUsageSrc' value: 16r50!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_offBitsSrc' value: 16r5C!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_offBmiSrc' value: 16r54!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_xDest' value: 16r18!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_xformSrc' value: 16r34!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_xSrc' value: 16r2C!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_yDest' value: 16r1C!
EMRSTRETCHBLT addClassConstant: '_OffsetOf_ySrc' value: 16r30!
EMRSTRETCHBLT comment: '<EMRSTRETCHBLT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSTRETCHBLT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(04E7165E-C2D6-4A3D-8A28-D197F35D85A3)]
struct tagEMRSTRETCHBLT {
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
	long cxSrc;
	long cySrc;
} EMRSTRETCHBLT;
'!
!EMRSTRETCHBLT categoriesForClass!Win32-Structs! !
!EMRSTRETCHBLT methodsFor!

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

cxSrc
	"Answer the <Integer> value of the receiver's 'cxSrc' field."

	^bytes sdwordAtOffset: _OffsetOf_cxSrc!

cxSrc: anInteger
	"Set the receiver's 'cxSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxSrc put: anInteger!

cyDest
	"Answer the <Integer> value of the receiver's 'cyDest' field."

	^bytes sdwordAtOffset: _OffsetOf_cyDest!

cyDest: anInteger
	"Set the receiver's 'cyDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cyDest put: anInteger!

cySrc
	"Answer the <Integer> value of the receiver's 'cySrc' field."

	^bytes sdwordAtOffset: _OffsetOf_cySrc!

cySrc: anInteger
	"Set the receiver's 'cySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cySrc put: anInteger!

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
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
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
!EMRSTRETCHBLT categoriesForMethods!
cbBitsSrc!**compiled accessors**!public! !
cbBitsSrc:!**compiled accessors**!public! !
cbBmiSrc!**compiled accessors**!public! !
cbBmiSrc:!**compiled accessors**!public! !
crBkColorSrc!**compiled accessors**!public! !
crBkColorSrc:!**compiled accessors**!public! !
cxDest!**compiled accessors**!public! !
cxDest:!**compiled accessors**!public! !
cxSrc!**compiled accessors**!public! !
cxSrc:!**compiled accessors**!public! !
cyDest!**compiled accessors**!public! !
cyDest:!**compiled accessors**!public! !
cySrc!**compiled accessors**!public! !
cySrc:!**compiled accessors**!public! !
dwRop!**compiled accessors**!public! !
dwRop:!**compiled accessors**!public! !
iUsageSrc!**compiled accessors**!public! !
iUsageSrc:!**compiled accessors**!public! !
offBitsSrc!**compiled accessors**!public! !
offBitsSrc:!**compiled accessors**!public! !
offBmiSrc!**compiled accessors**!public! !
offBmiSrc:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
xDest!**compiled accessors**!public! !
xDest:!**compiled accessors**!public! !
xformSrc!**compiled accessors**!public! !
xformSrc:!**compiled accessors**!public! !
xSrc!**compiled accessors**!public! !
xSrc:!**compiled accessors**!public! !
yDest!**compiled accessors**!public! !
yDest:!**compiled accessors**!public! !
ySrc!**compiled accessors**!public! !
ySrc:!**compiled accessors**!public! !
!

!EMRSTRETCHBLT class methodsFor!

defineFields
	"Define the fields of the EMRSTRETCHBLT structure.

	EMRSTRETCHBLT  compileDefinition

		typedef [uuid(04E7165E-C2D6-4A3D-8A28-D197F35D85A3)]
		struct tagEMRSTRETCHBLT {
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
			long cxSrc;
			long cySrc;
		} EMRSTRETCHBLT;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
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
			offset: 96;
		defineField: #cxSrc
			type: SDWORDField new
			offset: 100;
		defineField: #cySrc
			type: SDWORDField new
			offset: 104.
	self byteSize: 108!

getFieldNames
	^#(#iType #nSize #rclBounds #xDest #yDest #cxDest #cyDest #dwRop #xSrc #ySrc #xformSrc #crBkColorSrc #iUsageSrc #offBmiSrc #cbBmiSrc #offBitsSrc #cbBitsSrc #cxSrc #cySrc)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_STRETCHBLT! !
!EMRSTRETCHBLT class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

