"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #LOGCOLORSPACE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
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
LOGCOLORSPACE guid: (GUID fromString: '{2b6b91b8-caef-4fdf-ac3d-f032417ca840}')!
LOGCOLORSPACE comment: '<LOGCOLORSPACE> is an <ExternalStructure> class to wrap the struct ''Win32.LOGCOLORSPACE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2B6B91B8-CAEF-4FDF-AC3D-F032417CA840)]
struct tagLOGCOLORSPACE {
	DWORD lcsSignature;
	DWORD lcsVersion;
	DWORD lcsSize;
	long lcsCSType;
	long lcsIntent;
	CIEXYZTRIPLE lcsEndpoints;
	DWORD lcsGammaRed;
	DWORD lcsGammaGreen;
	DWORD lcsGammaBlue;
	BYTE lcsFilename[260];
} LOGCOLORSPACE;
'!
!LOGCOLORSPACE categoriesForClass!Win32-Structs! !
!LOGCOLORSPACE methodsFor!

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
!LOGCOLORSPACE categoriesFor: #lcsCSType!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsCSType:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsEndpoints!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsEndpoints:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsFilename!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsFilename:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsGammaBlue!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsGammaBlue:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsGammaGreen!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsGammaGreen:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsGammaRed!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsGammaRed:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsIntent!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsIntent:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsSignature!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsSignature:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsSize!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsSize:!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsVersion!**compiled accessors**!public! !
!LOGCOLORSPACE categoriesFor: #lcsVersion:!**compiled accessors**!public! !

!LOGCOLORSPACE class methodsFor!

defineFields
	"Define the fields of the LOGCOLORSPACE structure.

	LOGCOLORSPACE  compileDefinition

		typedef [uuid(2B6B91B8-CAEF-4FDF-AC3D-F032417CA840)]
		struct tagLOGCOLORSPACE {
			DWORD lcsSignature;
			DWORD lcsVersion;
			DWORD lcsSize;
			long lcsCSType;
			long lcsIntent;
			CIEXYZTRIPLE lcsEndpoints;
			DWORD lcsGammaRed;
			DWORD lcsGammaGreen;
			DWORD lcsGammaBlue;
			BYTE lcsFilename[260];
		} LOGCOLORSPACE;
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
!LOGCOLORSPACE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!LOGCOLORSPACE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

