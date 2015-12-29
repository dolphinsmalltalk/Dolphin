"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPWORDPRONUNCIATIONLIST
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPWORDPRONUNCIATIONLIST guid: (GUID fromString: '{B01AF98A-48D9-4A8F-88A6-A99412328B63}')!
SPWORDPRONUNCIATIONLIST comment: '<SPWORDPRONUNCIATIONLIST> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPWORDPRONUNCIATIONLIST'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPWORDPRONUNCIATIONLIST {
	unsigned long ulSize;
	BYTE* pvBuffer;
	SPWORDPRONUNCIATION* pFirstWordPronunciation;
} SPWORDPRONUNCIATIONLIST;
'!
!SPWORDPRONUNCIATIONLIST categoriesForClass!SpeechLib-Structs! !
!SPWORDPRONUNCIATIONLIST methodsFor!

pFirstWordPronunciation
	"Answer the receiver's pFirstWordPronunciation field as a Smalltalk object."

	^SPWORDPRONUNCIATION fromAddress: (bytes sdwordAtOffset: 8)!

pFirstWordPronunciation: anObject
	"Set the receiver's pFirstWordPronunciation field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject yourAddress!

pvBuffer
	"Answer the receiver's pvBuffer field as a Smalltalk object."

	^BYTE fromAddress: (bytes sdwordAtOffset: 4)!

pvBuffer: anObject
	"Set the receiver's pvBuffer field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject yourAddress!

ulSize
	"Answer the receiver's ulSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

ulSize: anObject
	"Set the receiver's ulSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!SPWORDPRONUNCIATIONLIST categoriesFor: #pFirstWordPronunciation!**compiled accessors**!public! !
!SPWORDPRONUNCIATIONLIST categoriesFor: #pFirstWordPronunciation:!**compiled accessors**!public! !
!SPWORDPRONUNCIATIONLIST categoriesFor: #pvBuffer!**compiled accessors**!public! !
!SPWORDPRONUNCIATIONLIST categoriesFor: #pvBuffer:!**compiled accessors**!public! !
!SPWORDPRONUNCIATIONLIST categoriesFor: #ulSize!**compiled accessors**!public! !
!SPWORDPRONUNCIATIONLIST categoriesFor: #ulSize:!**compiled accessors**!public! !

!SPWORDPRONUNCIATIONLIST class methodsFor!

defineFields
	"Define the fields of the SPWORDPRONUNCIATIONLIST structure.
		SPWORDPRONUNCIATIONLIST compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPWORDPRONUNCIATIONLIST {
			unsigned long ulSize;
			BYTE* pvBuffer;
			SPWORDPRONUNCIATION* pFirstWordPronunciation;
		} SPWORDPRONUNCIATIONLIST;
"

	self
		defineField: #ulSize type: DWORDField new offset: 0;
		defineField: #pvBuffer type: (PointerField type: BYTE) offset: 4;
		defineField: #pFirstWordPronunciation type: (PointerField type: SPWORDPRONUNCIATION) offset: 8.
	self byteSize: 12!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 227! !
!SPWORDPRONUNCIATIONLIST class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPWORDPRONUNCIATIONLIST class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

