"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPWORDPRONUNCIATION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPWORDPRONUNCIATION guid: (GUID fromString: '{25AC4F4F-0ECF-42F9-9C74-D264B8385092}')!
SPWORDPRONUNCIATION comment: '<SPWORDPRONUNCIATION> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPWORDPRONUNCIATION'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPWORDPRONUNCIATION {
	SPWORDPRONUNCIATION* pNextWordPronunciation;
	SPLEXICONTYPE eLexiconType;
	unsigned short LangId;
	unsigned short wReserved;
	SPPARTOFSPEECH ePartOfSpeech;
	unsigned short szPronunciation[1];
} SPWORDPRONUNCIATION;
'!
!SPWORDPRONUNCIATION categoriesForClass!SpeechLib-Structs! !
!SPWORDPRONUNCIATION methodsFor!

eLexiconType
	"Answer the receiver's eLexiconType field as a Smalltalk object."

	^(bytes sdwordAtOffset: 4)!

eLexiconType: anObject
	"Set the receiver's eLexiconType field to the value of anObject."

	bytes sdwordAtOffset: 4 put: anObject!

ePartOfSpeech
	"Answer the receiver's ePartOfSpeech field as a Smalltalk object."

	^(bytes sdwordAtOffset: 12)!

ePartOfSpeech: anObject
	"Set the receiver's ePartOfSpeech field to the value of anObject."

	bytes sdwordAtOffset: 12 put: anObject!

LangId
	"Answer the receiver's LangId field as a Smalltalk object."

	^(bytes wordAtOffset: 8)!

LangId: anObject
	"Set the receiver's LangId field to the value of anObject."

	bytes wordAtOffset: 8 put: anObject!

pNextWordPronunciation
	"Answer the receiver's pNextWordPronunciation field as a Smalltalk object."

	^SPWORDPRONUNCIATION fromAddress: (bytes sdwordAtOffset: 0)!

pNextWordPronunciation: anObject
	"Set the receiver's pNextWordPronunciation field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject yourAddress!

szPronunciation
	"Answer the receiver's szPronunciation field as a Smalltalk object."

	^WORDArray fromAddress: (bytes yourAddress + 16) length: 1!

szPronunciation: anObject
	"Set the receiver's szPronunciation field to the value of anObject."

	| size |
	size := anObject byteSize min: (1 * 2).
	anObject replaceBytesOf: bytes from: 17 to: 16 + size startingAt: 1!

wReserved
	"Answer the receiver's wReserved field as a Smalltalk object."

	^(bytes wordAtOffset: 10)!

wReserved: anObject
	"Set the receiver's wReserved field to the value of anObject."

	bytes wordAtOffset: 10 put: anObject! !
!SPWORDPRONUNCIATION categoriesFor: #eLexiconType!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #eLexiconType:!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #ePartOfSpeech!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #ePartOfSpeech:!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #LangId!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #LangId:!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #pNextWordPronunciation!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #pNextWordPronunciation:!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #szPronunciation!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #szPronunciation:!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #wReserved!**compiled accessors**!public! !
!SPWORDPRONUNCIATION categoriesFor: #wReserved:!**compiled accessors**!public! !

!SPWORDPRONUNCIATION class methodsFor!

defineFields
	"Define the fields of the SPWORDPRONUNCIATION structure.
		SPWORDPRONUNCIATION compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPWORDPRONUNCIATION {
			SPWORDPRONUNCIATION* pNextWordPronunciation;
			SPLEXICONTYPE eLexiconType;
			unsigned short LangId;
			unsigned short wReserved;
			SPPARTOFSPEECH ePartOfSpeech;
			unsigned short szPronunciation[1];
		} SPWORDPRONUNCIATION;
"

	self
		defineField: #pNextWordPronunciation type: (PointerField type: SPWORDPRONUNCIATION) offset: 0;
		defineField: #eLexiconType type: SDWORDField new offset: 4;
		defineField: #LangId type: WORDField new offset: 8;
		defineField: #wReserved type: WORDField new offset: 10;
		defineField: #ePartOfSpeech type: SDWORDField new offset: 12;
		defineField: #szPronunciation type: (ArrayField type: WORDArray length: 1) offset: 16.
	self byteSize: 20!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 228! !
!SPWORDPRONUNCIATION class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPWORDPRONUNCIATION class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

