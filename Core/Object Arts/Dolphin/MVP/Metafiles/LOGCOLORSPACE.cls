"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #LOGCOLORSPACE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGCOLORSPACE guid: (GUID fromString: '{2B6B91B8-CAEF-4FDF-AC3D-F032417CA840}')!
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
	self byteSize: 328! !
!LOGCOLORSPACE class categoriesFor: #defineFields!**auto generated**!initializing!public! !

