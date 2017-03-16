"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRMASKBLT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRMASKBLT guid: (GUID fromString: '{99001d44-ed7a-4cee-84b9-dbcf1f67898b}')!
EMRMASKBLT comment: '<EMRMASKBLT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRMASKBLT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(99001D44-ED7A-4CEE-84B9-DBCF1F67898B)]
struct tagEMRMASKBLT {
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
	long xMask;
	long yMask;
	[helpstring("Mask bitmap info color table usage")] DWORD iUsageMask;
	[helpstring("Offset to the mask BITMAPINFO structure if any")] DWORD offBmiMask;
	[helpstring("Size of the mask BITMAPINFO structure if any")] DWORD cbBmiMask;
	[helpstring("Offset to the mask bitmap bits if any")] DWORD offBitsMask;
	[helpstring("Size of the mask bitmap bits if any")] DWORD cbBitsMask;
} EMRMASKBLT;
'!
!EMRMASKBLT categoriesForClass!Win32-Structs! !
!EMRMASKBLT methodsFor!

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

cxDest
	"Answer the receiver's cxDest field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cxDest)!

cxDest: anObject 
	"Set the receiver's cxDest field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cxDest) put: anObject!

cyDest
	"Answer the receiver's cyDest field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cyDest)!

cyDest: anObject 
	"Set the receiver's cyDest field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cyDest) put: anObject!

dwRop
	"Answer the receiver's dwRop field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwRop)!

dwRop: anObject 
	"Set the receiver's dwRop field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwRop) put: anObject!

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

xDest
	"Answer the receiver's xDest field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #xDest)!

xDest: anObject 
	"Set the receiver's xDest field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #xDest) put: anObject!

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

yDest
	"Answer the receiver's yDest field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #yDest)!

yDest: anObject 
	"Set the receiver's yDest field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #yDest) put: anObject!

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
!EMRMASKBLT categoriesFor: #cbBitsMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBitsMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBitsSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBitsSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBmiMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBmiMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBmiSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBmiSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #crBkColorSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #crBkColorSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cxDest!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cxDest:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cyDest!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cyDest:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #dwRop!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #dwRop:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #iUsageMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #iUsageMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #iUsageSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #iUsageSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBitsMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBitsMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBitsSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBitsSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBmiMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBmiMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBmiSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBmiSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xDest!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xDest:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xformSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xformSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #yDest!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #yDest:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #yMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #yMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #ySrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #ySrc:!**compiled accessors**!public! !

!EMRMASKBLT class methodsFor!

defineFields
	"Define the fields of the EMRMASKBLT structure.

	EMRMASKBLT  compileDefinition

		typedef [uuid(99001D44-ED7A-4CEE-84B9-DBCF1F67898B)]
		struct tagEMRMASKBLT {
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
			long xMask;
			long yMask;
			[helpstring('Mask bitmap info color table usage')] DWORD iUsageMask;
			[helpstring('Offset to the mask BITMAPINFO structure if any')] DWORD offBmiMask;
			[helpstring('Size of the mask BITMAPINFO structure if any')] DWORD cbBmiMask;
			[helpstring('Offset to the mask bitmap bits if any')] DWORD offBitsMask;
			[helpstring('Size of the mask bitmap bits if any')] DWORD cbBitsMask;
		} EMRMASKBLT;
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
		defineField: #xMask
			type: SDWORDField new
			offset: 100;
		defineField: #yMask
			type: SDWORDField new
			offset: 104;
		defineField: #iUsageMask
			type: DWORDField new
			offset: 108;
		defineField: #offBmiMask
			type: DWORDField new
			offset: 112;
		defineField: #cbBmiMask
			type: DWORDField new
			offset: 116;
		defineField: #offBitsMask
			type: DWORDField new
			offset: 120;
		defineField: #cbBitsMask
			type: DWORDField new
			offset: 124.
	self byteSize: 128!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_MASKBLT! !
!EMRMASKBLT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRMASKBLT class categoriesFor: #iTypes!constants!public! !

