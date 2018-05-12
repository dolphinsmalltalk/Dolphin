"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #LOGCOLORSPACEW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGCOLORSPACEW guid: (GUID fromString: '{8b3e3016-08e0-4e61-835b-ff4cfbcec91a}')!
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
	"Answer the receiver's lcsCSType field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #lcsCSType)!

lcsCSType: anObject 
	"Set the receiver's lcsCSType field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #lcsCSType) put: anObject!

lcsEndpoints
	"Answer the receiver's lcsEndpoints field as a Smalltalk object."

	^CIEXYZTRIPLE fromAddress: bytes yourAddress + ##(self offsetOf: #lcsEndpoints)!

lcsEndpoints: anObject 
	"Set the receiver's lcsEndpoints field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lcsEndpoints) + 1)
		to: ##((self offsetOf: #lcsEndpoints) + CIEXYZTRIPLE basicByteSize)
		startingAt: 1!

lcsFilename
	"Answer the receiver's lcsFilename field as a Smalltalk object."

	^ByteArray fromAddress: bytes yourAddress + ##(self offsetOf: #lcsFilename) length: 260!

lcsFilename: anObject 
	"Set the receiver's lcsFilename field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(260 * ByteArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lcsFilename) + 1)
		to: ##(self offsetOf: #lcsFilename) + size
		startingAt: 1!

lcsGammaBlue
	"Answer the receiver's lcsGammaBlue field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lcsGammaBlue)!

lcsGammaBlue: anObject 
	"Set the receiver's lcsGammaBlue field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lcsGammaBlue) put: anObject!

lcsGammaGreen
	"Answer the receiver's lcsGammaGreen field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lcsGammaGreen)!

lcsGammaGreen: anObject 
	"Set the receiver's lcsGammaGreen field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lcsGammaGreen) put: anObject!

lcsGammaRed
	"Answer the receiver's lcsGammaRed field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lcsGammaRed)!

lcsGammaRed: anObject 
	"Set the receiver's lcsGammaRed field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lcsGammaRed) put: anObject!

lcsIntent
	"Answer the receiver's lcsIntent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #lcsIntent)!

lcsIntent: anObject 
	"Set the receiver's lcsIntent field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #lcsIntent) put: anObject!

lcsSignature
	"Answer the receiver's lcsSignature field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

lcsSignature: anObject 
	"Set the receiver's lcsSignature field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

lcsSize
	"Answer the receiver's lcsSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lcsSize)!

lcsSize: anObject 
	"Set the receiver's lcsSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lcsSize) put: anObject!

lcsVersion
	"Answer the receiver's lcsVersion field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lcsVersion)!

lcsVersion: anObject 
	"Set the receiver's lcsVersion field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lcsVersion) put: anObject! !
!LOGCOLORSPACEW categoriesFor: #lcsCSType!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsCSType:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsEndpoints!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsEndpoints:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsFilename!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsFilename:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsGammaBlue!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsGammaBlue:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsGammaGreen!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsGammaGreen:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsGammaRed!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsGammaRed:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsIntent!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsIntent:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsSignature!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsSignature:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsSize!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsSize:!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsVersion!**compiled accessors**!public! !
!LOGCOLORSPACEW categoriesFor: #lcsVersion:!**compiled accessors**!public! !

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
	self byteSize: 328! !
!LOGCOLORSPACEW class categoriesFor: #defineFields!**auto generated**!initializing!public! !

