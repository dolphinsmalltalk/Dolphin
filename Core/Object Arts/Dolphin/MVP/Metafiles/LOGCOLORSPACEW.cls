"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #LOGCOLORSPACEW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lcsCSType _OffsetOf_lcsEndpoints _OffsetOf_lcsFilename _OffsetOf_lcsGammaBlue _OffsetOf_lcsGammaGreen _OffsetOf_lcsGammaRed _OffsetOf_lcsIntent _OffsetOf_lcsSignature _OffsetOf_lcsSize _OffsetOf_lcsVersion'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LOGCOLORSPACEW guid: (GUID fromString: '{8b3e3016-08e0-4e61-835b-ff4cfbcec91a}')!

LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsCSType' value: 16rC!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsEndpoints' value: 16r14!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsFilename' value: 16r44!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsGammaBlue' value: 16r40!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsGammaGreen' value: 16r3C!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsGammaRed' value: 16r38!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsIntent' value: 16r10!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsSignature' value: 16r0!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsSize' value: 16r8!
LOGCOLORSPACEW addClassConstant: '_OffsetOf_lcsVersion' value: 16r4!

LOGCOLORSPACEW comment: '<LOGCOLORSPACEW> is an <ExternalStructure> class to wrap the struct ''Win32.LOGCOLORSPACEW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!LOGCOLORSPACEW categoriesForClass!Win32-Structs! !

!LOGCOLORSPACEW methodsFor!

lcsCSType
	"Answer the <Integer> value of the receiver's 'lcsCSType' field."

	^bytes sdwordAtOffset: _OffsetOf_lcsCSType!

lcsCSType: anInteger
	"Set the receiver's 'lcsCSType' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lcsCSType put: anInteger!

lcsEndpoints
	"Answer the <CIEXYZTRIPLE> value of the receiver's 'lcsEndpoints' field."

	^CIEXYZTRIPLE fromAddress: bytes yourAddress + _OffsetOf_lcsEndpoints!

lcsEndpoints: aCIEXYZTRIPLE
	"Set the receiver's 'lcsEndpoints' field to the value of the argument, aCIEXYZTRIPLE"

	aCIEXYZTRIPLE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lcsEndpoints + 1)
		to: ##(_OffsetOf_lcsEndpoints + CIEXYZTRIPLE basicByteSize)
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

	^bytes dwordAtOffset: _OffsetOf_lcsGammaBlue!

lcsGammaBlue: anInteger
	"Set the receiver's 'lcsGammaBlue' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lcsGammaBlue put: anInteger!

lcsGammaGreen
	"Answer the <Integer> value of the receiver's 'lcsGammaGreen' field."

	^bytes dwordAtOffset: _OffsetOf_lcsGammaGreen!

lcsGammaGreen: anInteger
	"Set the receiver's 'lcsGammaGreen' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lcsGammaGreen put: anInteger!

lcsGammaRed
	"Answer the <Integer> value of the receiver's 'lcsGammaRed' field."

	^bytes dwordAtOffset: _OffsetOf_lcsGammaRed!

lcsGammaRed: anInteger
	"Set the receiver's 'lcsGammaRed' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lcsGammaRed put: anInteger!

lcsIntent
	"Answer the <Integer> value of the receiver's 'lcsIntent' field."

	^bytes sdwordAtOffset: _OffsetOf_lcsIntent!

lcsIntent: anInteger
	"Set the receiver's 'lcsIntent' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lcsIntent put: anInteger!

lcsSignature
	"Answer the <Integer> value of the receiver's 'lcsSignature' field."

	^bytes dwordAtOffset: _OffsetOf_lcsSignature!

lcsSignature: anInteger
	"Set the receiver's 'lcsSignature' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lcsSignature put: anInteger!

lcsSize
	"Answer the <Integer> value of the receiver's 'lcsSize' field."

	^bytes dwordAtOffset: _OffsetOf_lcsSize!

lcsSize: anInteger
	"Set the receiver's 'lcsSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lcsSize put: anInteger!

lcsVersion
	"Answer the <Integer> value of the receiver's 'lcsVersion' field."

	^bytes dwordAtOffset: _OffsetOf_lcsVersion!

lcsVersion: anInteger
	"Set the receiver's 'lcsVersion' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lcsVersion put: anInteger! !

!LOGCOLORSPACEW categoriesForMethods!
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

!LOGCOLORSPACEW class methodsFor!

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
		defineField: #lcsSignature type: DWORDField new offset: 0;
		defineField: #lcsVersion type: DWORDField new offset: 4;
		defineField: #lcsSize type: DWORDField new offset: 8;
		defineField: #lcsCSType type: SDWORDField new offset: 12;
		defineField: #lcsIntent type: SDWORDField new offset: 16;
		defineField: #lcsEndpoints type: (StructureField type: CIEXYZTRIPLE) offset: 20;
		defineField: #lcsGammaRed type: DWORDField new offset: 56;
		defineField: #lcsGammaGreen type: DWORDField new offset: 60;
		defineField: #lcsGammaBlue type: DWORDField new offset: 64;
		defineField: #lcsFilename type: (ArrayField type: ByteArray length: 260) offset: 68.
	self byteSize: 328!

getFieldNames
	^#(#lcsSignature #lcsVersion #lcsSize #lcsCSType #lcsIntent #lcsEndpoints #lcsGammaRed #lcsGammaGreen #lcsGammaBlue #lcsFilename)! !

!LOGCOLORSPACEW class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

