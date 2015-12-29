"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPPHRASEELEMENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPPHRASEELEMENT guid: (GUID fromString: '{C0A3B7E6-135C-4E59-A122-1595FE98C1E9}')!
SPPHRASEELEMENT comment: '<SPPHRASEELEMENT> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPPHRASEELEMENT'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPPHRASEELEMENT {
	unsigned long ulAudioTimeOffset;
	unsigned long ulAudioSizeTime;
	unsigned long ulAudioStreamOffset;
	unsigned long ulAudioSizeBytes;
	unsigned long ulRetainedStreamOffset;
	unsigned long ulRetainedSizeBytes;
	unsigned short* pszDisplayText;
	unsigned short* pszLexicalForm;
	unsigned short* pszPronunciation;
	BYTE bDisplayAttributes;
	CHAR RequiredConfidence;
	CHAR ActualConfidence;
	BYTE reserved;
	single SREngineConfidence;
} SPPHRASEELEMENT;
'!
!SPPHRASEELEMENT categoriesForClass!SpeechLib-Structs! !
!SPPHRASEELEMENT methodsFor!

ActualConfidence
	"Answer the receiver's ActualConfidence field as a Smalltalk object."

	^(bytes sbyteAtOffset: 38)!

ActualConfidence: anObject
	"Set the receiver's ActualConfidence field to the value of anObject."

	bytes sbyteAtOffset: 38 put: anObject!

bDisplayAttributes
	"Answer the receiver's bDisplayAttributes field as a Smalltalk object."

	^(bytes byteAtOffset: 36)!

bDisplayAttributes: anObject
	"Set the receiver's bDisplayAttributes field to the value of anObject."

	bytes byteAtOffset: 36 put: anObject!

pszDisplayText
	"Answer the receiver's pszDisplayText field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 24)!

pszDisplayText: anObject
	"Set the receiver's pszDisplayText field to the value of anObject."

	bytes dwordAtOffset: 24 put: anObject yourAddress!

pszLexicalForm
	"Answer the receiver's pszLexicalForm field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 28)!

pszLexicalForm: anObject
	"Set the receiver's pszLexicalForm field to the value of anObject."

	bytes dwordAtOffset: 28 put: anObject yourAddress!

pszPronunciation
	"Answer the receiver's pszPronunciation field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 32)!

pszPronunciation: anObject
	"Set the receiver's pszPronunciation field to the value of anObject."

	bytes dwordAtOffset: 32 put: anObject yourAddress!

RequiredConfidence
	"Answer the receiver's RequiredConfidence field as a Smalltalk object."

	^(bytes sbyteAtOffset: 37)!

RequiredConfidence: anObject
	"Set the receiver's RequiredConfidence field to the value of anObject."

	bytes sbyteAtOffset: 37 put: anObject!

reserved
	"Answer the receiver's reserved field as a Smalltalk object."

	^(bytes byteAtOffset: 39)!

reserved: anObject
	"Set the receiver's reserved field to the value of anObject."

	bytes byteAtOffset: 39 put: anObject!

SREngineConfidence
	"Answer the receiver's SREngineConfidence field as a Smalltalk object."

	^(bytes floatAtOffset: 40)!

SREngineConfidence: anObject
	"Set the receiver's SREngineConfidence field to the value of anObject."

	bytes floatAtOffset: 40 put: anObject!

ulAudioSizeBytes
	"Answer the receiver's ulAudioSizeBytes field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

ulAudioSizeBytes: anObject
	"Set the receiver's ulAudioSizeBytes field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

ulAudioSizeTime
	"Answer the receiver's ulAudioSizeTime field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

ulAudioSizeTime: anObject
	"Set the receiver's ulAudioSizeTime field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

ulAudioStreamOffset
	"Answer the receiver's ulAudioStreamOffset field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

ulAudioStreamOffset: anObject
	"Set the receiver's ulAudioStreamOffset field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

ulAudioTimeOffset
	"Answer the receiver's ulAudioTimeOffset field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

ulAudioTimeOffset: anObject
	"Set the receiver's ulAudioTimeOffset field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

ulRetainedSizeBytes
	"Answer the receiver's ulRetainedSizeBytes field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

ulRetainedSizeBytes: anObject
	"Set the receiver's ulRetainedSizeBytes field to the value of anObject."

	bytes dwordAtOffset: 20 put: anObject!

ulRetainedStreamOffset
	"Answer the receiver's ulRetainedStreamOffset field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

ulRetainedStreamOffset: anObject
	"Set the receiver's ulRetainedStreamOffset field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject! !
!SPPHRASEELEMENT categoriesFor: #ActualConfidence!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ActualConfidence:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #bDisplayAttributes!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #bDisplayAttributes:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #pszDisplayText!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #pszDisplayText:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #pszLexicalForm!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #pszLexicalForm:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #pszPronunciation!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #pszPronunciation:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #RequiredConfidence!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #RequiredConfidence:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #reserved!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #reserved:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #SREngineConfidence!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #SREngineConfidence:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulAudioSizeBytes!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulAudioSizeBytes:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulAudioSizeTime!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulAudioSizeTime:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulAudioStreamOffset!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulAudioStreamOffset:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulAudioTimeOffset!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulAudioTimeOffset:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulRetainedSizeBytes!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulRetainedSizeBytes:!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulRetainedStreamOffset!**compiled accessors**!public! !
!SPPHRASEELEMENT categoriesFor: #ulRetainedStreamOffset:!**compiled accessors**!public! !

!SPPHRASEELEMENT class methodsFor!

defineFields
	"Define the fields of the SPPHRASEELEMENT structure.
		SPPHRASEELEMENT compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPPHRASEELEMENT {
			unsigned long ulAudioTimeOffset;
			unsigned long ulAudioSizeTime;
			unsigned long ulAudioStreamOffset;
			unsigned long ulAudioSizeBytes;
			unsigned long ulRetainedStreamOffset;
			unsigned long ulRetainedSizeBytes;
			unsigned short* pszDisplayText;
			unsigned short* pszLexicalForm;
			unsigned short* pszPronunciation;
			BYTE bDisplayAttributes;
			CHAR RequiredConfidence;
			CHAR ActualConfidence;
			BYTE reserved;
			single SREngineConfidence;
		} SPPHRASEELEMENT;
"

	self
		defineField: #ulAudioTimeOffset type: DWORDField new offset: 0;
		defineField: #ulAudioSizeTime type: DWORDField new offset: 4;
		defineField: #ulAudioStreamOffset type: DWORDField new offset: 8;
		defineField: #ulAudioSizeBytes type: DWORDField new offset: 12;
		defineField: #ulRetainedStreamOffset type: DWORDField new offset: 16;
		defineField: #ulRetainedSizeBytes type: DWORDField new offset: 20;
		defineField: #pszDisplayText type: (PointerField type: WORD) offset: 24;
		defineField: #pszLexicalForm type: (PointerField type: WORD) offset: 28;
		defineField: #pszPronunciation type: (PointerField type: WORD) offset: 32;
		defineField: #bDisplayAttributes type: BYTEField new offset: 36;
		defineField: #RequiredConfidence type: SBYTEField new offset: 37;
		defineField: #ActualConfidence type: SBYTEField new offset: 38;
		defineField: #reserved type: BYTEField new offset: 39;
		defineField: #SREngineConfidence type: FLOATField new offset: 40.
	self byteSize: 44!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 199! !
!SPPHRASEELEMENT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPPHRASEELEMENT class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

