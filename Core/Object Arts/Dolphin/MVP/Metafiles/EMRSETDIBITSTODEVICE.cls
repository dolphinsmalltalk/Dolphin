"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRSETDIBITSTODEVICE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbBitsSrc _OffsetOf_cbBmiSrc _OffsetOf_cScans _OffsetOf_cxSrc _OffsetOf_cySrc _OffsetOf_iStartScan _OffsetOf_iUsageSrc _OffsetOf_offBitsSrc _OffsetOf_offBmiSrc _OffsetOf_rclBounds _OffsetOf_xDest _OffsetOf_xSrc _OffsetOf_yDest _OffsetOf_ySrc'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETDIBITSTODEVICE guid: (GUID fromString: '{3929212b-c9b8-4281-b17e-91160985d892}')!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_cbBitsSrc' value: 16r3C!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_cbBmiSrc' value: 16r34!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_cScans' value: 16r48!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_cxSrc' value: 16r28!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_cySrc' value: 16r2C!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_iStartScan' value: 16r44!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_iUsageSrc' value: 16r40!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_offBitsSrc' value: 16r38!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_offBmiSrc' value: 16r30!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_xDest' value: 16r18!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_xSrc' value: 16r20!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_yDest' value: 16r1C!
EMRSETDIBITSTODEVICE addClassConstant: '_OffsetOf_ySrc' value: 16r24!
EMRSETDIBITSTODEVICE comment: '<EMRSETDIBITSTODEVICE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETDIBITSTODEVICE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMRSETDIBITSTODEVICE categoriesForClass!Win32-Structs! !
!EMRSETDIBITSTODEVICE methodsFor!

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
!EMRSETDIBITSTODEVICE categoriesForMethods!
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

!EMRSETDIBITSTODEVICE class methodsFor!

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
			type: (StructureField type: RECT)
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

	^Array with: EMR_SETDIBITSTODEVICE! !
!EMRSETDIBITSTODEVICE class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

