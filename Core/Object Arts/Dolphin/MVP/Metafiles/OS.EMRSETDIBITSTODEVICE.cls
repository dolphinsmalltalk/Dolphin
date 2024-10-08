﻿"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSETDIBITSTODEVICE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRSETDIBITSTODEVICE_Size' -> 16r4C.
			'_OffsetOf_cbBitsSrc' -> 16r3C.
			'_OffsetOf_cbBmiSrc' -> 16r34.
			'_OffsetOf_cScans' -> 16r48.
			'_OffsetOf_cxSrc' -> 16r28.
			'_OffsetOf_cySrc' -> 16r2C.
			'_OffsetOf_iStartScan' -> 16r44.
			'_OffsetOf_iUsageSrc' -> 16r40.
			'_OffsetOf_offBitsSrc' -> 16r38.
			'_OffsetOf_offBmiSrc' -> 16r30.
			'_OffsetOf_rclBounds' -> 16r8.
			'_OffsetOf_xDest' -> 16r18.
			'_OffsetOf_xSrc' -> 16r20.
			'_OffsetOf_yDest' -> 16r1C.
			'_OffsetOf_ySrc' -> 16r24
		}!

OS.EMRSETDIBITSTODEVICE guid: (Core.GUID fromString: '{3929212b-c9b8-4281-b17e-91160985d892}')!

OS.EMRSETDIBITSTODEVICE comment: '<EMRSETDIBITSTODEVICE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETDIBITSTODEVICE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(3929212B-C9B8-4281-B17E-91160985D892)]
struct tagEMRSETDIBITSTODEVICE {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	long xDest;
	long yDest;
	long xSrc;
	long ySrc;
	long cxSrc;
	long cySrc;
	[helpstring("Offset to the source BITMAPINFO structure")] DWORD offBmiSrc;
	[helpstring("Size of the source BITMAPINFO structure")] DWORD cbBmiSrc;
	[helpstring("Offset to the source bitmap bits")] DWORD offBitsSrc;
	[helpstring("Size of the source bitmap bits")] DWORD cbBitsSrc;
	[helpstring("Source bitmap info color table usage")] DWORD iUsageSrc;
	DWORD iStartScan;
	DWORD cScans;
} EMRSETDIBITSTODEVICE;
'!

!OS.EMRSETDIBITSTODEVICE categoriesForClass!Win32-Structs! !

!OS.EMRSETDIBITSTODEVICE methodsFor!

cbBitsSrc
	"Answer the <Integer> value of the receiver's 'cbBitsSrc' field."

	^bytes uint32AtOffset: _OffsetOf_cbBitsSrc!

cbBitsSrc: anInteger
	"Set the receiver's 'cbBitsSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbBitsSrc put: anInteger!

cbBmiSrc
	"Answer the <Integer> value of the receiver's 'cbBmiSrc' field."

	^bytes uint32AtOffset: _OffsetOf_cbBmiSrc!

cbBmiSrc: anInteger
	"Set the receiver's 'cbBmiSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbBmiSrc put: anInteger!

cScans
	"Answer the <Integer> value of the receiver's 'cScans' field."

	^bytes uint32AtOffset: _OffsetOf_cScans!

cScans: anInteger
	"Set the receiver's 'cScans' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cScans put: anInteger!

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

iStartScan
	"Answer the <Integer> value of the receiver's 'iStartScan' field."

	^bytes uint32AtOffset: _OffsetOf_iStartScan!

iStartScan: anInteger
	"Set the receiver's 'iStartScan' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iStartScan put: anInteger!

iUsageSrc
	"Answer the <Integer> value of the receiver's 'iUsageSrc' field."

	^bytes uint32AtOffset: _OffsetOf_iUsageSrc!

iUsageSrc: anInteger
	"Set the receiver's 'iUsageSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iUsageSrc put: anInteger!

offBitsSrc
	"Answer the <Integer> value of the receiver's 'offBitsSrc' field."

	^bytes uint32AtOffset: _OffsetOf_offBitsSrc!

offBitsSrc: anInteger
	"Set the receiver's 'offBitsSrc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offBitsSrc put: anInteger!

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

ySrc
	"Answer the <Integer> value of the receiver's 'ySrc' field."

	^bytes int32AtOffset: _OffsetOf_ySrc!

ySrc: anInteger
	"Set the receiver's 'ySrc' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_ySrc put: anInteger! !

!OS.EMRSETDIBITSTODEVICE categoriesForMethods!
cbBitsSrc!**compiled accessors**!public! !
cbBitsSrc:!**compiled accessors**!public! !
cbBmiSrc!**compiled accessors**!public! !
cbBmiSrc:!**compiled accessors**!public! !
cScans!**compiled accessors**!public! !
cScans:!**compiled accessors**!public! !
cxSrc!**compiled accessors**!public! !
cxSrc:!**compiled accessors**!public! !
cySrc!**compiled accessors**!public! !
cySrc:!**compiled accessors**!public! !
iStartScan!**compiled accessors**!public! !
iStartScan:!**compiled accessors**!public! !
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
xSrc!**compiled accessors**!public! !
xSrc:!**compiled accessors**!public! !
yDest!**compiled accessors**!public! !
yDest:!**compiled accessors**!public! !
ySrc!**compiled accessors**!public! !
ySrc:!**compiled accessors**!public! !
!

!OS.EMRSETDIBITSTODEVICE class methodsFor!

byteSize
	^_EMRSETDIBITSTODEVICE_Size!

defineFields
	"Define the fields of the EMRSETDIBITSTODEVICE structure.

	EMRSETDIBITSTODEVICE  compileDefinition

		typedef [uuid(3929212B-C9B8-4281-B17E-91160985D892)]
		struct tagEMRSETDIBITSTODEVICE {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			long xDest;
			long yDest;
			long xSrc;
			long ySrc;
			long cxSrc;
			long cySrc;
			[helpstring('Offset to the source BITMAPINFO structure')] DWORD offBmiSrc;
			[helpstring('Size of the source BITMAPINFO structure')] DWORD cbBmiSrc;
			[helpstring('Offset to the source bitmap bits')] DWORD offBitsSrc;
			[helpstring('Size of the source bitmap bits')] DWORD cbBitsSrc;
			[helpstring('Source bitmap info color table usage')] DWORD iUsageSrc;
			DWORD iStartScan;
			DWORD cScans;
		} EMRSETDIBITSTODEVICE;
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
		defineField: #xSrc
			type: Int32Field new
			offset: 32;
		defineField: #ySrc
			type: Int32Field new
			offset: 36;
		defineField: #cxSrc
			type: Int32Field new
			offset: 40;
		defineField: #cySrc
			type: Int32Field new
			offset: 44;
		defineField: #offBmiSrc
			type: UInt32Field new
			offset: 48;
		defineField: #cbBmiSrc
			type: UInt32Field new
			offset: 52;
		defineField: #offBitsSrc
			type: UInt32Field new
			offset: 56;
		defineField: #cbBitsSrc
			type: UInt32Field new
			offset: 60;
		defineField: #iUsageSrc
			type: UInt32Field new
			offset: 64;
		defineField: #iStartScan
			type: UInt32Field new
			offset: 68;
		defineField: #cScans
			type: UInt32Field new
			offset: 72.
	self byteSize: 76!

getFieldNames
	^#(#iType #nSize #rclBounds #xDest #yDest #xSrc #ySrc #cxSrc #cySrc #offBmiSrc #cbBmiSrc #offBitsSrc #cbBitsSrc #iUsageSrc #iStartScan #cScans)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETDIBITSTODEVICE}! !

!OS.EMRSETDIBITSTODEVICE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

