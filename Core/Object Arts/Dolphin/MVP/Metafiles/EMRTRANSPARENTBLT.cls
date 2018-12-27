"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRTRANSPARENTBLT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRTRANSPARENTBLT guid: (GUID fromString: '{e45acb58-6465-4c29-84da-a3b8e0b9b384}')!
EMRTRANSPARENTBLT comment: '<EMRTRANSPARENTBLT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRTRANSPARENTBLT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(E45ACB58-6465-4C29-84DA-A3B8E0B9B384)]
struct tagEMRTRANSPARENTBLT {
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
} EMRTRANSPARENTBLT;
'!
!EMRTRANSPARENTBLT categoriesForClass!Win32-Structs! !
!EMRTRANSPARENTBLT methodsFor!

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

crBkColorSrc
	"Answer the <Integer> value of the receiver's 'crBkColorSrc' field."

	^bytes dwordAtOffset: ##(self offsetOf: #crBkColorSrc)!

crBkColorSrc: anInteger
	"Set the receiver's 'crBkColorSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #crBkColorSrc) put: anInteger!

cxDest
	"Answer the <Integer> value of the receiver's 'cxDest' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cxDest)!

cxDest: anInteger
	"Set the receiver's 'cxDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cxDest) put: anInteger!

cxSrc
	"Answer the <Integer> value of the receiver's 'cxSrc' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cxSrc)!

cxSrc: anInteger
	"Set the receiver's 'cxSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cxSrc) put: anInteger!

cyDest
	"Answer the <Integer> value of the receiver's 'cyDest' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cyDest)!

cyDest: anInteger
	"Set the receiver's 'cyDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cyDest) put: anInteger!

cySrc
	"Answer the <Integer> value of the receiver's 'cySrc' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cySrc)!

cySrc: anInteger
	"Set the receiver's 'cySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cySrc) put: anInteger!

dwRop
	"Answer the <Integer> value of the receiver's 'dwRop' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwRop)!

dwRop: anInteger
	"Set the receiver's 'dwRop' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwRop) put: anInteger!

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
!EMRTRANSPARENTBLT categoriesFor: #cbBitsSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cbBitsSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cbBmiSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cbBmiSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #crBkColorSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #crBkColorSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cxDest!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cxDest:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cxSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cxSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cyDest!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cyDest:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cySrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #cySrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #dwRop!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #dwRop:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #iUsageSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #iUsageSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #offBitsSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #offBitsSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #offBmiSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #offBmiSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #xDest!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #xDest:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #xformSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #xformSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #xSrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #xSrc:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #yDest!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #yDest:!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #ySrc!**compiled accessors**!public! !
!EMRTRANSPARENTBLT categoriesFor: #ySrc:!**compiled accessors**!public! !

!EMRTRANSPARENTBLT class methodsFor!

defineFields
	"Define the fields of the EMRTRANSPARENTBLT structure.

	EMRTRANSPARENTBLT  compileDefinition

		typedef [uuid(E45ACB58-6465-4C29-84DA-A3B8E0B9B384)]
		struct tagEMRTRANSPARENTBLT {
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
		} EMRTRANSPARENTBLT;
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

	^Array with: EMR_TRANSPARENTBLT! !
!EMRTRANSPARENTBLT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRTRANSPARENTBLT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRTRANSPARENTBLT class categoriesFor: #iTypes!constants!public! !

