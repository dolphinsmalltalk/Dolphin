"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPPHRASE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPPHRASE guid: (GUID fromString: '{cbb5366a-334c-4650-8b7e-4ad0c4532f22}')!
SPPHRASE comment: '<SPPHRASE> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPPHRASE'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPPHRASE {
	unsigned long cbSize;
	unsigned short LangId;
	unsigned short wReserved;
	unsigned __int64 ullGrammarID;
	unsigned __int64 ftStartTime;
	unsigned __int64 ullAudioStreamPosition;
	unsigned long ulAudioSizeBytes;
	unsigned long ulRetainedSizeBytes;
	unsigned long ulAudioSizeTime;
	SPPHRASERULE Rule;
	SPPHRASEPROPERTY* pProperties;
	SPPHRASEELEMENT* pElements;
	unsigned long cReplacements;
	SPPHRASEREPLACEMENT* pReplacements;
	GUID SREngineID;
	unsigned long ulSREnginePrivateDataSize;
	BYTE* pSREnginePrivateData;
} SPPHRASE;
'!
!SPPHRASE categoriesForClass!SpeechLib-Structs! !
!SPPHRASE methodsFor!

cbSize
	"Answer the receiver's cbSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

cbSize: anObject
	"Set the receiver's cbSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

cReplacements
	"Answer the receiver's cReplacements field as a Smalltalk object."

	^(bytes dwordAtOffset: 84)!

cReplacements: anObject
	"Set the receiver's cReplacements field to the value of anObject."

	bytes dwordAtOffset: 84 put: anObject!

ftStartTime
	"Answer the receiver's ftStartTime field as a Smalltalk object."

	^(bytes qwordAtOffset: 16)!

ftStartTime: anObject
	"Set the receiver's ftStartTime field to the value of anObject."

	bytes qwordAtOffset: 16 put: anObject!

LangId
	"Answer the receiver's LangId field as a Smalltalk object."

	^(bytes wordAtOffset: 4)!

LangId: anObject
	"Set the receiver's LangId field to the value of anObject."

	bytes wordAtOffset: 4 put: anObject!

pElements
	"Answer the receiver's pElements field as a Smalltalk object."

	^SPPHRASEELEMENT fromAddress: (bytes sdwordAtOffset: 80)!

pElements: anObject
	"Set the receiver's pElements field to the value of anObject."

	bytes dwordAtOffset: 80 put: anObject yourAddress!

pProperties
	"Answer the receiver's pProperties field as a Smalltalk object."

	^SPPHRASEPROPERTY fromAddress: (bytes sdwordAtOffset: 76)!

pProperties: anObject
	"Set the receiver's pProperties field to the value of anObject."

	bytes dwordAtOffset: 76 put: anObject yourAddress!

pReplacements
	"Answer the receiver's pReplacements field as a Smalltalk object."

	^SPPHRASEREPLACEMENT fromAddress: (bytes sdwordAtOffset: 88)!

pReplacements: anObject
	"Set the receiver's pReplacements field to the value of anObject."

	bytes dwordAtOffset: 88 put: anObject yourAddress!

pSREnginePrivateData
	"Answer the receiver's pSREnginePrivateData field as a Smalltalk object."

	^BYTE fromAddress: (bytes sdwordAtOffset: 112)!

pSREnginePrivateData: anObject
	"Set the receiver's pSREnginePrivateData field to the value of anObject."

	bytes dwordAtOffset: 112 put: anObject yourAddress!

Rule
	"Answer the receiver's Rule field as a Smalltalk object."

	^SPPHRASERULE fromAddress: (bytes yourAddress + 44)!

Rule: anObject
	"Set the receiver's Rule field to the value of anObject."

	anObject replaceBytesOf: bytes from: 45 to: 44 startingAt: 1!

SREngineID
	"Answer the receiver's SREngineID field as a Smalltalk object."

	^GUID fromAddress: (bytes yourAddress + 92)!

SREngineID: anObject
	"Set the receiver's SREngineID field to the value of anObject."

	anObject replaceBytesOf: bytes from: 93 to: 108 startingAt: 1!

ulAudioSizeBytes
	"Answer the receiver's ulAudioSizeBytes field as a Smalltalk object."

	^(bytes dwordAtOffset: 32)!

ulAudioSizeBytes: anObject
	"Set the receiver's ulAudioSizeBytes field to the value of anObject."

	bytes dwordAtOffset: 32 put: anObject!

ulAudioSizeTime
	"Answer the receiver's ulAudioSizeTime field as a Smalltalk object."

	^(bytes dwordAtOffset: 40)!

ulAudioSizeTime: anObject
	"Set the receiver's ulAudioSizeTime field to the value of anObject."

	bytes dwordAtOffset: 40 put: anObject!

ullAudioStreamPosition
	"Answer the receiver's ullAudioStreamPosition field as a Smalltalk object."

	^(bytes qwordAtOffset: 24)!

ullAudioStreamPosition: anObject
	"Set the receiver's ullAudioStreamPosition field to the value of anObject."

	bytes qwordAtOffset: 24 put: anObject!

ullGrammarID
	"Answer the receiver's ullGrammarID field as a Smalltalk object."

	^(bytes qwordAtOffset: 8)!

ullGrammarID: anObject
	"Set the receiver's ullGrammarID field to the value of anObject."

	bytes qwordAtOffset: 8 put: anObject!

ulRetainedSizeBytes
	"Answer the receiver's ulRetainedSizeBytes field as a Smalltalk object."

	^(bytes dwordAtOffset: 36)!

ulRetainedSizeBytes: anObject
	"Set the receiver's ulRetainedSizeBytes field to the value of anObject."

	bytes dwordAtOffset: 36 put: anObject!

ulSREnginePrivateDataSize
	"Answer the receiver's ulSREnginePrivateDataSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 108)!

ulSREnginePrivateDataSize: anObject
	"Set the receiver's ulSREnginePrivateDataSize field to the value of anObject."

	bytes dwordAtOffset: 108 put: anObject!

wReserved
	"Answer the receiver's wReserved field as a Smalltalk object."

	^(bytes wordAtOffset: 6)!

wReserved: anObject
	"Set the receiver's wReserved field to the value of anObject."

	bytes wordAtOffset: 6 put: anObject! !
!SPPHRASE categoriesFor: #cbSize!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #cbSize:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #cReplacements!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #cReplacements:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ftStartTime!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ftStartTime:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #LangId!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #LangId:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #pElements!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #pElements:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #pProperties!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #pProperties:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #pReplacements!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #pReplacements:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #pSREnginePrivateData!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #pSREnginePrivateData:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #Rule!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #Rule:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #SREngineID!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #SREngineID:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ulAudioSizeBytes!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ulAudioSizeBytes:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ulAudioSizeTime!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ulAudioSizeTime:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ullAudioStreamPosition!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ullAudioStreamPosition:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ullGrammarID!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ullGrammarID:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ulRetainedSizeBytes!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ulRetainedSizeBytes:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ulSREnginePrivateDataSize!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #ulSREnginePrivateDataSize:!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #wReserved!**compiled accessors**!public! !
!SPPHRASE categoriesFor: #wReserved:!**compiled accessors**!public! !

!SPPHRASE class methodsFor!

defineFields
	"Define the fields of the SPPHRASE structure.
		SPPHRASE compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPPHRASE {
			unsigned long cbSize;
			unsigned short LangId;
			unsigned short wReserved;
			unsigned __int64 ullGrammarID;
			unsigned __int64 ftStartTime;
			unsigned __int64 ullAudioStreamPosition;
			unsigned long ulAudioSizeBytes;
			unsigned long ulRetainedSizeBytes;
			unsigned long ulAudioSizeTime;
			SPPHRASERULE Rule;
			SPPHRASEPROPERTY* pProperties;
			SPPHRASEELEMENT* pElements;
			unsigned long cReplacements;
			SPPHRASEREPLACEMENT* pReplacements;
			GUID SREngineID;
			unsigned long ulSREnginePrivateDataSize;
			BYTE* pSREnginePrivateData;
		} SPPHRASE;
"

	self
		defineField: #cbSize type: DWORDField new offset: 0;
		defineField: #LangId type: WORDField new offset: 4;
		defineField: #wReserved type: WORDField new offset: 6;
		defineField: #ullGrammarID type: QWORDField new offset: 8;
		defineField: #ftStartTime type: QWORDField new offset: 16;
		defineField: #ullAudioStreamPosition type: QWORDField new offset: 24;
		defineField: #ulAudioSizeBytes type: DWORDField new offset: 32;
		defineField: #ulRetainedSizeBytes type: DWORDField new offset: 36;
		defineField: #ulAudioSizeTime type: DWORDField new offset: 40;
		defineField: #Rule type: (StructureField type: SPPHRASERULE) offset: 44;
		defineField: #pProperties type: (PointerField type: SPPHRASEPROPERTY) offset: 76;
		defineField: #pElements type: (PointerField type: SPPHRASEELEMENT) offset: 80;
		defineField: #cReplacements type: DWORDField new offset: 84;
		defineField: #pReplacements type: (PointerField type: SPPHRASEREPLACEMENT) offset: 88;
		defineField: #SREngineID type: (StructureField type: GUID) offset: 92;
		defineField: #ulSREnginePrivateDataSize type: DWORDField new offset: 108;
		defineField: #pSREnginePrivateData type: (PointerField type: BYTE) offset: 112.
	self byteSize: 120!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 196! !
!SPPHRASE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPPHRASE class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

