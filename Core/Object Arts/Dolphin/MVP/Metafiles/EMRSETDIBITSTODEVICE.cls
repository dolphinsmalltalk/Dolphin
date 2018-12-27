"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETDIBITSTODEVICE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETDIBITSTODEVICE guid: (GUID fromString: '{3929212b-c9b8-4281-b17e-91160985d892}')!
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

	^bytes dwordAtOffset: ##(self offsetOf: #cbBitsSrc)!

cbBitsSrc: anInteger
	"Set the receiver's 'cbBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbBitsSrc) put: anInteger!

cbBmiSrc
	"Answer the <Integer> value of the receiver's 'cbBmiSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBmiSrc)!

cbBmiSrc: anInteger
	"Set the receiver's 'cbBmiSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbBmiSrc) put: anInteger!

cScans
	"Answer the <Integer> value of the receiver's 'cScans' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cScans)!

cScans: anInteger
	"Set the receiver's 'cScans' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cScans) put: anInteger!

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

iStartScan
	"Answer the <Integer> value of the receiver's 'iStartScan' field."

	^bytes dwordAtOffset: ##(self offsetOf: #iStartScan)!

iStartScan: anInteger
	"Set the receiver's 'iStartScan' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #iStartScan) put: anInteger!

iUsageSrc
	"Answer the <Integer> value of the receiver's 'iUsageSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #iUsageSrc)!

iUsageSrc: anInteger
	"Set the receiver's 'iUsageSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #iUsageSrc) put: anInteger!

offBitsSrc
	"Answer the <Integer> value of the receiver's 'offBitsSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offBitsSrc)!

offBitsSrc: anInteger
	"Set the receiver's 'offBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offBitsSrc) put: anInteger!

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

xDest
	"Answer the <Integer> value of the receiver's 'xDest' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #xDest)!

xDest: anInteger
	"Set the receiver's 'xDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #xDest) put: anInteger!

xSrc
	"Answer the <Integer> value of the receiver's 'xSrc' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #xSrc)!

xSrc: anInteger
	"Set the receiver's 'xSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #xSrc) put: anInteger!

yDest
	"Answer the <Integer> value of the receiver's 'yDest' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #yDest)!

yDest: anInteger
	"Set the receiver's 'yDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #yDest) put: anInteger!

ySrc
	"Answer the <Integer> value of the receiver's 'ySrc' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #ySrc)!

ySrc: anInteger
	"Set the receiver's 'ySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #ySrc) put: anInteger! !
!EMRSETDIBITSTODEVICE categoriesFor: #cbBitsSrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cbBitsSrc:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cbBmiSrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cbBmiSrc:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cScans!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cScans:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cxSrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cxSrc:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cySrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #cySrc:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #iStartScan!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #iStartScan:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #iUsageSrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #iUsageSrc:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #offBitsSrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #offBitsSrc:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #offBmiSrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #offBmiSrc:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #xDest!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #xDest:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #xSrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #xSrc:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #yDest!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #yDest:!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #ySrc!**compiled accessors**!public! !
!EMRSETDIBITSTODEVICE categoriesFor: #ySrc:!**compiled accessors**!public! !

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
!EMRSETDIBITSTODEVICE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRSETDIBITSTODEVICE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETDIBITSTODEVICE class categoriesFor: #iTypes!constants!public! !

