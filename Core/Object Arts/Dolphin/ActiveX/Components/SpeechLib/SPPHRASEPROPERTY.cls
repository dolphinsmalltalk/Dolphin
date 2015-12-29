"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPPHRASEPROPERTY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPPHRASEPROPERTY guid: (GUID fromString: '{D002D6D7-8270-4DD7-B0B1-4EC4B188999F}')!
SPPHRASEPROPERTY comment: '<SPPHRASEPROPERTY> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPPHRASEPROPERTY'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPPHRASEPROPERTY {
	unsigned short* pszName;
	unsigned long ulId;
	unsigned short* pszValue;
	VARIANT vValue;
	unsigned long ulFirstElement;
	unsigned long ulCountOfElements;
	SPPHRASEPROPERTY* pNextSibling;
	SPPHRASEPROPERTY* pFirstChild;
	single SREngineConfidence;
	CHAR Confidence;
} SPPHRASEPROPERTY;
'!
!SPPHRASEPROPERTY categoriesForClass!SpeechLib-Structs! !
!SPPHRASEPROPERTY methodsFor!

Confidence
	"Answer the receiver's Confidence field as a Smalltalk object."

	^(bytes sbyteAtOffset: 52)!

Confidence: anObject
	"Set the receiver's Confidence field to the value of anObject."

	bytes sbyteAtOffset: 52 put: anObject!

pFirstChild
	"Answer the receiver's pFirstChild field as a Smalltalk object."

	^SPPHRASEPROPERTY fromAddress: (bytes sdwordAtOffset: 44)!

pFirstChild: anObject
	"Set the receiver's pFirstChild field to the value of anObject."

	bytes dwordAtOffset: 44 put: anObject yourAddress!

pNextSibling
	"Answer the receiver's pNextSibling field as a Smalltalk object."

	^SPPHRASEPROPERTY fromAddress: (bytes sdwordAtOffset: 40)!

pNextSibling: anObject
	"Set the receiver's pNextSibling field to the value of anObject."

	bytes dwordAtOffset: 40 put: anObject yourAddress!

pszName
	"Answer the receiver's pszName field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 0)!

pszName: anObject
	"Set the receiver's pszName field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject yourAddress!

pszValue
	"Answer the receiver's pszValue field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 8)!

pszValue: anObject
	"Set the receiver's pszValue field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject yourAddress!

SREngineConfidence
	"Answer the receiver's SREngineConfidence field as a Smalltalk object."

	^(bytes floatAtOffset: 48)!

SREngineConfidence: anObject
	"Set the receiver's SREngineConfidence field to the value of anObject."

	bytes floatAtOffset: 48 put: anObject!

ulCountOfElements
	"Answer the receiver's ulCountOfElements field as a Smalltalk object."

	^(bytes dwordAtOffset: 36)!

ulCountOfElements: anObject
	"Set the receiver's ulCountOfElements field to the value of anObject."

	bytes dwordAtOffset: 36 put: anObject!

ulFirstElement
	"Answer the receiver's ulFirstElement field as a Smalltalk object."

	^(bytes dwordAtOffset: 32)!

ulFirstElement: anObject
	"Set the receiver's ulFirstElement field to the value of anObject."

	bytes dwordAtOffset: 32 put: anObject!

ulId
	"Answer the receiver's ulId field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

ulId: anObject
	"Set the receiver's ulId field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

vValue
	"Answer the receiver's vValue field as a Smalltalk object."

	^VARIANT fromAddress: (bytes yourAddress + 16)!

vValue: anObject
	"Set the receiver's vValue field to the value of anObject."

	anObject replaceBytesOf: bytes from: 17 to: 32 startingAt: 1! !
!SPPHRASEPROPERTY categoriesFor: #Confidence!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #Confidence:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #pFirstChild!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #pFirstChild:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #pNextSibling!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #pNextSibling:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #pszName!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #pszName:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #pszValue!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #pszValue:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #SREngineConfidence!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #SREngineConfidence:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #ulCountOfElements!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #ulCountOfElements:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #ulFirstElement!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #ulFirstElement:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #ulId!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #ulId:!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #vValue!**compiled accessors**!public! !
!SPPHRASEPROPERTY categoriesFor: #vValue:!**compiled accessors**!public! !

!SPPHRASEPROPERTY class methodsFor!

defineFields
	"Define the fields of the SPPHRASEPROPERTY structure.
		SPPHRASEPROPERTY compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPPHRASEPROPERTY {
			unsigned short* pszName;
			unsigned long ulId;
			unsigned short* pszValue;
			VARIANT vValue;
			unsigned long ulFirstElement;
			unsigned long ulCountOfElements;
			SPPHRASEPROPERTY* pNextSibling;
			SPPHRASEPROPERTY* pFirstChild;
			single SREngineConfidence;
			CHAR Confidence;
		} SPPHRASEPROPERTY;
"

	self
		defineField: #pszName type: (PointerField type: WORD) offset: 0;
		defineField: #ulId type: DWORDField new offset: 4;
		defineField: #pszValue type: (PointerField type: WORD) offset: 8;
		defineField: #vValue type: (StructureField type: VARIANT) offset: 16;
		defineField: #ulFirstElement type: DWORDField new offset: 32;
		defineField: #ulCountOfElements type: DWORDField new offset: 36;
		defineField: #pNextSibling type: (PointerField type: SPPHRASEPROPERTY) offset: 40;
		defineField: #pFirstChild type: (PointerField type: SPPHRASEPROPERTY) offset: 44;
		defineField: #SREngineConfidence type: FLOATField new offset: 48;
		defineField: #Confidence type: SBYTEField new offset: 52.
	self byteSize: 56!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 198! !
!SPPHRASEPROPERTY class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPPHRASEPROPERTY class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

