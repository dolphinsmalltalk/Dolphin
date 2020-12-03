"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRSETDIBITSTODEVICE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
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

cScans
	"Answer the <Integer> value of the receiver's 'cScans' field."

	^bytes dwordAtOffset: _OffsetOf_cScans!

cScans: anInteger
	"Set the receiver's 'cScans' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cScans put: anInteger!

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

iStartScan
	"Answer the <Integer> value of the receiver's 'iStartScan' field."

	^bytes dwordAtOffset: _OffsetOf_iStartScan!

iStartScan: anInteger
	"Set the receiver's 'iStartScan' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iStartScan put: anInteger!

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
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cbBitsSrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cbBitsSrc:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cbBmiSrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cbBmiSrc:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cScans!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cScans:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cxSrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cxSrc:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cySrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #cySrc:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #iStartScan!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #iStartScan:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #iUsageSrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #iUsageSrc:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #offBitsSrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #offBitsSrc:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #offBmiSrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #offBmiSrc:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #rclBounds!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #rclBounds:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #xDest!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #xDest:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #xSrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #xSrc:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #yDest!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #yDest:!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #ySrc!**compiled accessors**!public! !
!OS.EMRSETDIBITSTODEVICE categoriesFor: #ySrc:!**compiled accessors**!public! !

!OS.EMRSETDIBITSTODEVICE class methodsFor!

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
			type: SDWORDField new
			offset: 24;
		defineField: #yDest
			type: SDWORDField new
			offset: 28;
		defineField: #xSrc
			type: SDWORDField new
			offset: 32;
		defineField: #ySrc
			type: SDWORDField new
			offset: 36;
		defineField: #cxSrc
			type: SDWORDField new
			offset: 40;
		defineField: #cySrc
			type: SDWORDField new
			offset: 44;
		defineField: #offBmiSrc
			type: DWORDField new
			offset: 48;
		defineField: #cbBmiSrc
			type: DWORDField new
			offset: 52;
		defineField: #offBitsSrc
			type: DWORDField new
			offset: 56;
		defineField: #cbBitsSrc
			type: DWORDField new
			offset: 60;
		defineField: #iUsageSrc
			type: DWORDField new
			offset: 64;
		defineField: #iStartScan
			type: DWORDField new
			offset: 68;
		defineField: #cScans
			type: DWORDField new
			offset: 72.
	self byteSize: 76!

getFieldNames
	^#(#iType #nSize #rclBounds #xDest #yDest #xSrc #ySrc #cxSrc #cySrc #offBmiSrc #cbBmiSrc #offBitsSrc #cbBitsSrc #iUsageSrc #iStartScan #cScans)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETDIBITSTODEVICE}! !
!OS.EMRSETDIBITSTODEVICE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMRSETDIBITSTODEVICE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRSETDIBITSTODEVICE class categoriesFor: #iTypes!constants!public! !

