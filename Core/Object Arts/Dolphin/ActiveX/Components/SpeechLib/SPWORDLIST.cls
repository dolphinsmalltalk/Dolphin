"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPWORDLIST
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPWORDLIST guid: (GUID fromString: '{5f797d3b-46d2-4199-95d3-48002591d9f8}')!
SPWORDLIST comment: '<SPWORDLIST> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPWORDLIST'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPWORDLIST {
	unsigned long ulSize;
	BYTE* pvBuffer;
	SPWORD* pFirstWord;
} SPWORDLIST;
'!
!SPWORDLIST categoriesForClass!SpeechLib-Structs! !
!SPWORDLIST methodsFor!

pFirstWord
	"Answer the receiver's pFirstWord field as a Smalltalk object."

	^SPWORD fromAddress: (bytes sdwordAtOffset: 8)!

pFirstWord: anObject
	"Set the receiver's pFirstWord field to the value of anObject."

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
!SPWORDLIST categoriesFor: #pFirstWord!**compiled accessors**!public! !
!SPWORDLIST categoriesFor: #pFirstWord:!**compiled accessors**!public! !
!SPWORDLIST categoriesFor: #pvBuffer!**compiled accessors**!public! !
!SPWORDLIST categoriesFor: #pvBuffer:!**compiled accessors**!public! !
!SPWORDLIST categoriesFor: #ulSize!**compiled accessors**!public! !
!SPWORDLIST categoriesFor: #ulSize:!**compiled accessors**!public! !

!SPWORDLIST class methodsFor!

defineFields
	"Define the fields of the SPWORDLIST structure.
		SPWORDLIST compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPWORDLIST {
			unsigned long ulSize;
			BYTE* pvBuffer;
			SPWORD* pFirstWord;
		} SPWORDLIST;
"

	self
		defineField: #ulSize type: DWORDField new offset: 0;
		defineField: #pvBuffer type: (PointerField type: BYTE) offset: 4;
		defineField: #pFirstWord type: (PointerField type: SPWORD) offset: 8.
	self byteSize: 12!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 231! !
!SPWORDLIST class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPWORDLIST class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

