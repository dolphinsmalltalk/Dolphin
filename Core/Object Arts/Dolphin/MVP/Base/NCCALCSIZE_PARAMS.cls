"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #NCCALCSIZE_PARAMS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NCCALCSIZE_PARAMS guid: (GUID fromString: '{DBC3695F-4C20-411C-8110-539CE4BE4B4A}')!
NCCALCSIZE_PARAMS comment: '<NCCALCSIZE_PARAMS> is an <ExternalStructure> class to wrap the struct ''Win32.NCCALCSIZE_PARAMS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(DBC3695F-4C20-411C-8110-539CE4BE4B4A)]
struct tagNCCALCSIZE_PARAMS {
	RECT rgrc[3];
	WINDOWPOS* lppos;
} NCCALCSIZE_PARAMS;
'!
!NCCALCSIZE_PARAMS categoriesForClass!Win32-Structs! !
!NCCALCSIZE_PARAMS methodsFor!

lppos
	"Answer the receiver's lppos field as a Smalltalk object."

	^WINDOWPOS fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lppos))!

lppos: anObject 
	"Set the receiver's lppos field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lppos) put: anObject yourAddress!

rgrc
	"Answer the receiver's rgrc field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress
		length: 3
		elementClass: RECT!

rgrc: anObject 
	"Set the receiver's rgrc field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(3 * RECT basicByteSize).
	anObject 
		replaceBytesOf: bytes
		from: 1
		to: size
		startingAt: 1! !
!NCCALCSIZE_PARAMS categoriesFor: #lppos!**compiled accessors**!public! !
!NCCALCSIZE_PARAMS categoriesFor: #lppos:!**compiled accessors**!public! !
!NCCALCSIZE_PARAMS categoriesFor: #rgrc!**compiled accessors**!public! !
!NCCALCSIZE_PARAMS categoriesFor: #rgrc:!**compiled accessors**!public! !

!NCCALCSIZE_PARAMS class methodsFor!

defineFields
	"Define the fields of the NCCALCSIZE_PARAMS structure.

	NCCALCSIZE_PARAMS  compileDefinition

		typedef [uuid(DBC3695F-4C20-411C-8110-539CE4BE4B4A)]
		struct tagNCCALCSIZE_PARAMS {
			RECT rgrc[3];
			WINDOWPOS* lppos;
		} NCCALCSIZE_PARAMS;
"

	self
		defineField: #rgrc type: (StructureArrayField type: RECT length: 3);
		defineField: #lppos type: (PointerField type: WINDOWPOS)! !
!NCCALCSIZE_PARAMS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

