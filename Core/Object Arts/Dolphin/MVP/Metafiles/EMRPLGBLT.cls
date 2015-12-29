"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRPLGBLT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPLGBLT guid: (GUID fromString: '{CDAE1F25-39C4-4555-985B-3B2CD197D3E0}')!
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
	"Answer the receiver's aptlDest field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #aptlDest)
		length: 3
		elementClass: POINTL!

aptlDest: anObject 
	"Set the receiver's aptlDest field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(3 * POINTL basicByteSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #aptlDest) + 1)
		to: ##(self offsetOf: #aptlDest) + size
		startingAt: 1!

cbBitsMask
	"Answer the receiver's cbBitsMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBitsMask)!

cbBitsMask: anObject 
	"Set the receiver's cbBitsMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbBitsMask) put: anObject!

cbBitsSrc
	"Answer the receiver's cbBitsSrc field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBitsSrc)!

cbBitsSrc: anObject 
	"Set the receiver's cbBitsSrc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbBitsSrc) put: anObject!

cbBmiMask
	"Answer the receiver's cbBmiMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBmiMask)!

cbBmiMask: anObject 
	"Set the receiver's cbBmiMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbBmiMask) put: anObject!

cbBmiSrc
	"Answer the receiver's cbBmiSrc field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBmiSrc)!

cbBmiSrc: anObject 
	"Set the receiver's cbBmiSrc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbBmiSrc) put: anObject!

crBkColorSrc
	"Answer the receiver's crBkColorSrc field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #crBkColorSrc)!

crBkColorSrc: anObject 
	"Set the receiver's crBkColorSrc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #crBkColorSrc) put: anObject!

cxSrc
	"Answer the receiver's cxSrc field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cxSrc)!

cxSrc: anObject 
	"Set the receiver's cxSrc field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cxSrc) put: anObject!

cySrc
	"Answer the receiver's cySrc field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cySrc)!

cySrc: anObject 
	"Set the receiver's cySrc field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cySrc) put: anObject!

iUsageMask
	"Answer the receiver's iUsageMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iUsageMask)!

iUsageMask: anObject 
	"Set the receiver's iUsageMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iUsageMask) put: anObject!

iUsageSrc
	"Answer the receiver's iUsageSrc field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iUsageSrc)!

iUsageSrc: anObject 
	"Set the receiver's iUsageSrc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iUsageSrc) put: anObject!

offBitsMask
	"Answer the receiver's offBitsMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #offBitsMask)!

offBitsMask: anObject 
	"Set the receiver's offBitsMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #offBitsMask) put: anObject!

offBitsSrc
	"Answer the receiver's offBitsSrc field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #offBitsSrc)!

offBitsSrc: anObject 
	"Set the receiver's offBitsSrc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #offBitsSrc) put: anObject!

offBmiMask
	"Answer the receiver's offBmiMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #offBmiMask)!

offBmiMask: anObject 
	"Set the receiver's offBmiMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #offBmiMask) put: anObject!

offBmiSrc
	"Answer the receiver's offBmiSrc field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #offBmiSrc)!

offBmiSrc: anObject 
	"Set the receiver's offBmiSrc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #offBmiSrc) put: anObject!

rclBounds
	"Answer the receiver's rclBounds field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: anObject 
	"Set the receiver's rclBounds field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1!

xformSrc
	"Answer the receiver's xformSrc field as a Smalltalk object."

	^XFORM fromAddress: bytes yourAddress + ##(self offsetOf: #xformSrc)!

xformSrc: anObject 
	"Set the receiver's xformSrc field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #xformSrc) + 1)
		to: ##((self offsetOf: #xformSrc) + XFORM basicByteSize)
		startingAt: 1!

xMask
	"Answer the receiver's xMask field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #xMask)!

xMask: anObject 
	"Set the receiver's xMask field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #xMask) put: anObject!

xSrc
	"Answer the receiver's xSrc field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #xSrc)!

xSrc: anObject 
	"Set the receiver's xSrc field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #xSrc) put: anObject!

yMask
	"Answer the receiver's yMask field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #yMask)!

yMask: anObject 
	"Set the receiver's yMask field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #yMask) put: anObject!

ySrc
	"Answer the receiver's ySrc field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #ySrc)!

ySrc: anObject 
	"Set the receiver's ySrc field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #ySrc) put: anObject! !
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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_PLGBLT! !
!EMRPLGBLT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRPLGBLT class categoriesFor: #iTypes!constants!public! !

