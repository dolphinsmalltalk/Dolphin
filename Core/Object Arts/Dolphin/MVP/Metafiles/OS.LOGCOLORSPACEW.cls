"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.LOGCOLORSPACEW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_LOGCOLORSPACEW_Size' -> 16r148.
			'_OffsetOf_lcsCSType' -> 16rC.
			'_OffsetOf_lcsEndpoints' -> 16r14.
			'_OffsetOf_lcsFilename' -> 16r44.
			'_OffsetOf_lcsGammaBlue' -> 16r40.
			'_OffsetOf_lcsGammaGreen' -> 16r3C.
			'_OffsetOf_lcsGammaRed' -> 16r38.
			'_OffsetOf_lcsIntent' -> 16r10.
			'_OffsetOf_lcsSignature' -> 16r0.
			'_OffsetOf_lcsSize' -> 16r8.
			'_OffsetOf_lcsVersion' -> 16r4
		}!

OS.LOGCOLORSPACEW guid: (Core.GUID fromString: '{8b3e3016-08e0-4e61-835b-ff4cfbcec91a}')!

OS.LOGCOLORSPACEW comment: '<LOGCOLORSPACEW> is an <ExternalStructure> class to wrap the struct ''Win32.LOGCOLORSPACEW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(8B3E3016-08E0-4E61-835B-FF4CFBCEC91A)]
struct tagLOGCOLORSPACEW {
	unsigned long lcsSignature;
	unsigned long lcsVersion;
	unsigned long lcsSize;
	long lcsCSType;
	long lcsIntent;
	CIEXYZTRIPLE lcsEndpoints;
	unsigned long lcsGammaRed;
	unsigned long lcsGammaGreen;
	unsigned long lcsGammaBlue;
	BYTE lcsFilename[260];
} LOGCOLORSPACEW;
'!

!OS.LOGCOLORSPACEW categoriesForClass!Win32-Structs! !

!OS.LOGCOLORSPACEW methodsFor!

lcsCSType
	"Answer the <Integer> value of the receiver's 'lcsCSType' field."

	^bytes int32AtOffset: _OffsetOf_lcsCSType!

lcsCSType: anInteger
	"Set the receiver's 'lcsCSType' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_lcsCSType put: anInteger!

lcsEndpoints
	"Answer the <CIEXYZTRIPLE> value of the receiver's 'lcsEndpoints' field."

	^CIEXYZTRIPLE fromAddress: bytes yourAddress + _OffsetOf_lcsEndpoints!

lcsEndpoints: aCIEXYZTRIPLE
	"Set the receiver's 'lcsEndpoints' field to the value of the argument, aCIEXYZTRIPLE"

	aCIEXYZTRIPLE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lcsEndpoints + 1)
		to: ##(_OffsetOf_lcsEndpoints + CIEXYZTRIPLE._CIEXYZTRIPLE_Size)
		startingAt: 1!

lcsFilename
	"Answer the <ByteArray> value of the receiver's 'lcsFilename' field."

	^ByteArray fromAddress: bytes yourAddress + _OffsetOf_lcsFilename length: 260!

lcsFilename: aByteArray
	"Set the receiver's 'lcsFilename' field to the value of the argument, aByteArray"

	| size |
	size := aByteArray byteSize min: ##(260 * ByteArray elementSize).
	aByteArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lcsFilename + 1)
		to: _OffsetOf_lcsFilename + size
		startingAt: 1!

lcsGammaBlue
	"Answer the <Integer> value of the receiver's 'lcsGammaBlue' field."

	^bytes uint32AtOffset: _OffsetOf_lcsGammaBlue!

lcsGammaBlue: anInteger
	"Set the receiver's 'lcsGammaBlue' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lcsGammaBlue put: anInteger!

lcsGammaGreen
	"Answer the <Integer> value of the receiver's 'lcsGammaGreen' field."

	^bytes uint32AtOffset: _OffsetOf_lcsGammaGreen!

lcsGammaGreen: anInteger
	"Set the receiver's 'lcsGammaGreen' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lcsGammaGreen put: anInteger!

lcsGammaRed
	"Answer the <Integer> value of the receiver's 'lcsGammaRed' field."

	^bytes uint32AtOffset: _OffsetOf_lcsGammaRed!

lcsGammaRed: anInteger
	"Set the receiver's 'lcsGammaRed' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lcsGammaRed put: anInteger!

lcsIntent
	"Answer the <Integer> value of the receiver's 'lcsIntent' field."

	^bytes int32AtOffset: _OffsetOf_lcsIntent!

lcsIntent: anInteger
	"Set the receiver's 'lcsIntent' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_lcsIntent put: anInteger!

lcsSignature
	"Answer the <Integer> value of the receiver's 'lcsSignature' field."

	^bytes uint32AtOffset: _OffsetOf_lcsSignature!

lcsSignature: anInteger
	"Set the receiver's 'lcsSignature' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lcsSignature put: anInteger!

lcsSize
	"Answer the <Integer> value of the receiver's 'lcsSize' field."

	^bytes uint32AtOffset: _OffsetOf_lcsSize!

lcsSize: anInteger
	"Set the receiver's 'lcsSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lcsSize put: anInteger!

lcsVersion
	"Answer the <Integer> value of the receiver's 'lcsVersion' field."

	^bytes uint32AtOffset: _OffsetOf_lcsVersion!

lcsVersion: anInteger
	"Set the receiver's 'lcsVersion' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lcsVersion put: anInteger! !

!OS.LOGCOLORSPACEW categoriesForMethods!
lcsCSType!**compiled accessors**!public! !
lcsCSType:!**compiled accessors**!public! !
lcsEndpoints!**compiled accessors**!public! !
lcsEndpoints:!**compiled accessors**!public! !
lcsFilename!**compiled accessors**!public! !
lcsFilename:!**compiled accessors**!public! !
lcsGammaBlue!**compiled accessors**!public! !
lcsGammaBlue:!**compiled accessors**!public! !
lcsGammaGreen!**compiled accessors**!public! !
lcsGammaGreen:!**compiled accessors**!public! !
lcsGammaRed!**compiled accessors**!public! !
lcsGammaRed:!**compiled accessors**!public! !
lcsIntent!**compiled accessors**!public! !
lcsIntent:!**compiled accessors**!public! !
lcsSignature!**compiled accessors**!public! !
lcsSignature:!**compiled accessors**!public! !
lcsSize!**compiled accessors**!public! !
lcsSize:!**compiled accessors**!public! !
lcsVersion!**compiled accessors**!public! !
lcsVersion:!**compiled accessors**!public! !
!

!OS.LOGCOLORSPACEW class methodsFor!

byteSize
	^_LOGCOLORSPACEW_Size!

defineFields
	"Define the fields of the LOGCOLORSPACEW structure.

	LOGCOLORSPACEW  compileDefinition

		typedef [uuid(8B3E3016-08E0-4E61-835B-FF4CFBCEC91A)]
		struct tagLOGCOLORSPACEW {
			unsigned long lcsSignature;
			unsigned long lcsVersion;
			unsigned long lcsSize;
			long lcsCSType;
			long lcsIntent;
			CIEXYZTRIPLE lcsEndpoints;
			unsigned long lcsGammaRed;
			unsigned long lcsGammaGreen;
			unsigned long lcsGammaBlue;
			BYTE lcsFilename[260];
		} LOGCOLORSPACEW;
"

	self
		defineField: #lcsSignature
			type: UInt32Field new
			offset: 0;
		defineField: #lcsVersion
			type: UInt32Field new
			offset: 4;
		defineField: #lcsSize
			type: UInt32Field new
			offset: 8;
		defineField: #lcsCSType
			type: Int32Field new
			offset: 12;
		defineField: #lcsIntent
			type: Int32Field new
			offset: 16;
		defineField: #lcsEndpoints
			type: (StructureField type: CIEXYZTRIPLE)
			offset: 20;
		defineField: #lcsGammaRed
			type: UInt32Field new
			offset: 56;
		defineField: #lcsGammaGreen
			type: UInt32Field new
			offset: 60;
		defineField: #lcsGammaBlue
			type: UInt32Field new
			offset: 64;
		defineField: #lcsFilename
			type: (ArrayField type: ByteArray length: 260)
			offset: 68.
	self byteSize: 328!

getFieldNames
	^#(#lcsSignature #lcsVersion #lcsSize #lcsCSType #lcsIntent #lcsEndpoints #lcsGammaRed #lcsGammaGreen #lcsGammaBlue #lcsFilename)! !

!OS.LOGCOLORSPACEW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

