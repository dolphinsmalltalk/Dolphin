"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPWORD guid: (GUID fromString: '{a7375c0e-5ce2-441e-9f2d-4820102170bf}')!
SPWORD comment: '<SPWORD> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPWORD'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPWORD {
	SPWORD* pNextWord;
	unsigned short LangId;
	unsigned short wReserved;
	SPWORDTYPE eWordType;
	unsigned short* pszWord;
	SPWORDPRONUNCIATION* pFirstWordPronunciation;
} SPWORD;
'!
!SPWORD categoriesForClass!SpeechLib-Structs! !
!SPWORD methodsFor!

eWordType
	"Answer the receiver's eWordType field as a Smalltalk object."

	^(bytes sdwordAtOffset: 8)!

eWordType: anObject
	"Set the receiver's eWordType field to the value of anObject."

	bytes sdwordAtOffset: 8 put: anObject!

LangId
	"Answer the receiver's LangId field as a Smalltalk object."

	^(bytes wordAtOffset: 4)!

LangId: anObject
	"Set the receiver's LangId field to the value of anObject."

	bytes wordAtOffset: 4 put: anObject!

pFirstWordPronunciation
	"Answer the receiver's pFirstWordPronunciation field as a Smalltalk object."

	^SPWORDPRONUNCIATION fromAddress: (bytes sdwordAtOffset: 16)!

pFirstWordPronunciation: anObject
	"Set the receiver's pFirstWordPronunciation field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject yourAddress!

pNextWord
	"Answer the receiver's pNextWord field as a Smalltalk object."

	^SPWORD fromAddress: (bytes sdwordAtOffset: 0)!

pNextWord: anObject
	"Set the receiver's pNextWord field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject yourAddress!

pszWord
	"Answer the receiver's pszWord field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 12)!

pszWord: anObject
	"Set the receiver's pszWord field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject yourAddress!

wReserved
	"Answer the receiver's wReserved field as a Smalltalk object."

	^(bytes wordAtOffset: 6)!

wReserved: anObject
	"Set the receiver's wReserved field to the value of anObject."

	bytes wordAtOffset: 6 put: anObject! !
!SPWORD categoriesFor: #eWordType!**compiled accessors**!public! !
!SPWORD categoriesFor: #eWordType:!**compiled accessors**!public! !
!SPWORD categoriesFor: #LangId!**compiled accessors**!public! !
!SPWORD categoriesFor: #LangId:!**compiled accessors**!public! !
!SPWORD categoriesFor: #pFirstWordPronunciation!**compiled accessors**!public! !
!SPWORD categoriesFor: #pFirstWordPronunciation:!**compiled accessors**!public! !
!SPWORD categoriesFor: #pNextWord!**compiled accessors**!public! !
!SPWORD categoriesFor: #pNextWord:!**compiled accessors**!public! !
!SPWORD categoriesFor: #pszWord!**compiled accessors**!public! !
!SPWORD categoriesFor: #pszWord:!**compiled accessors**!public! !
!SPWORD categoriesFor: #wReserved!**compiled accessors**!public! !
!SPWORD categoriesFor: #wReserved:!**compiled accessors**!public! !

!SPWORD class methodsFor!

defineFields
	"Define the fields of the SPWORD structure.
		SPWORD compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPWORD {
			SPWORD* pNextWord;
			unsigned short LangId;
			unsigned short wReserved;
			SPWORDTYPE eWordType;
			unsigned short* pszWord;
			SPWORDPRONUNCIATION* pFirstWordPronunciation;
		} SPWORD;
"

	self
		defineField: #pNextWord type: (PointerField type: SPWORD) offset: 0;
		defineField: #LangId type: WORDField new offset: 4;
		defineField: #wReserved type: WORDField new offset: 6;
		defineField: #eWordType type: SDWORDField new offset: 8;
		defineField: #pszWord type: (PointerField type: WORD) offset: 12;
		defineField: #pFirstWordPronunciation type: (PointerField type: SPWORDPRONUNCIATION) offset: 16.
	self byteSize: 20!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 232! !
!SPWORD class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPWORD class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

