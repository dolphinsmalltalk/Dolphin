"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPPHRASERULE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPPHRASERULE guid: (GUID fromString: '{64a6f931-7d5c-49a1-a894-9d7a4290bc92}')!
SPPHRASERULE comment: '<SPPHRASERULE> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPPHRASERULE'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPPHRASERULE {
	unsigned short* pszName;
	unsigned long ulId;
	unsigned long ulFirstElement;
	unsigned long ulCountOfElements;
	SPPHRASERULE* pNextSibling;
	SPPHRASERULE* pFirstChild;
	single SREngineConfidence;
	CHAR Confidence;
} SPPHRASERULE;
'!
!SPPHRASERULE categoriesForClass!SpeechLib-Structs! !
!SPPHRASERULE methodsFor!

Confidence
	"Answer the receiver's Confidence field as a Smalltalk object."

	^(bytes sbyteAtOffset: 28)!

Confidence: anObject
	"Set the receiver's Confidence field to the value of anObject."

	bytes sbyteAtOffset: 28 put: anObject!

pFirstChild
	"Answer the receiver's pFirstChild field as a Smalltalk object."

	^SPPHRASERULE fromAddress: (bytes sdwordAtOffset: 20)!

pFirstChild: anObject
	"Set the receiver's pFirstChild field to the value of anObject."

	bytes dwordAtOffset: 20 put: anObject yourAddress!

pNextSibling
	"Answer the receiver's pNextSibling field as a Smalltalk object."

	^SPPHRASERULE fromAddress: (bytes sdwordAtOffset: 16)!

pNextSibling: anObject
	"Set the receiver's pNextSibling field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject yourAddress!

pszName
	"Answer the receiver's pszName field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 0)!

pszName: anObject
	"Set the receiver's pszName field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject yourAddress!

SREngineConfidence
	"Answer the receiver's SREngineConfidence field as a Smalltalk object."

	^(bytes floatAtOffset: 24)!

SREngineConfidence: anObject
	"Set the receiver's SREngineConfidence field to the value of anObject."

	bytes floatAtOffset: 24 put: anObject!

ulCountOfElements
	"Answer the receiver's ulCountOfElements field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

ulCountOfElements: anObject
	"Set the receiver's ulCountOfElements field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

ulFirstElement
	"Answer the receiver's ulFirstElement field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

ulFirstElement: anObject
	"Set the receiver's ulFirstElement field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

ulId
	"Answer the receiver's ulId field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

ulId: anObject
	"Set the receiver's ulId field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject! !
!SPPHRASERULE categoriesFor: #Confidence!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #Confidence:!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #pFirstChild!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #pFirstChild:!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #pNextSibling!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #pNextSibling:!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #pszName!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #pszName:!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #SREngineConfidence!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #SREngineConfidence:!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #ulCountOfElements!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #ulCountOfElements:!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #ulFirstElement!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #ulFirstElement:!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #ulId!**compiled accessors**!public! !
!SPPHRASERULE categoriesFor: #ulId:!**compiled accessors**!public! !

!SPPHRASERULE class methodsFor!

defineFields
	"Define the fields of the SPPHRASERULE structure.
		SPPHRASERULE compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPPHRASERULE {
			unsigned short* pszName;
			unsigned long ulId;
			unsigned long ulFirstElement;
			unsigned long ulCountOfElements;
			SPPHRASERULE* pNextSibling;
			SPPHRASERULE* pFirstChild;
			single SREngineConfidence;
			CHAR Confidence;
		} SPPHRASERULE;
"

	self
		defineField: #pszName type: (PointerField type: WORD) offset: 0;
		defineField: #ulId type: DWORDField new offset: 4;
		defineField: #ulFirstElement type: DWORDField new offset: 8;
		defineField: #ulCountOfElements type: DWORDField new offset: 12;
		defineField: #pNextSibling type: (PointerField type: SPPHRASERULE) offset: 16;
		defineField: #pFirstChild type: (PointerField type: SPPHRASERULE) offset: 20;
		defineField: #SREngineConfidence type: FLOATField new offset: 24;
		defineField: #Confidence type: SBYTEField new offset: 28.
	self byteSize: 32!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 197! !
!SPPHRASERULE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPPHRASERULE class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

