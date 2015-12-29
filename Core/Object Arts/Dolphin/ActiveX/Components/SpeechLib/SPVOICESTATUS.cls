"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPVOICESTATUS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPVOICESTATUS guid: (GUID fromString: '{6809A0AB-64D5-44F6-B7CF-6F79E4EAD98F}')!
SPVOICESTATUS comment: '<SPVOICESTATUS> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPVOICESTATUS'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPVOICESTATUS {
	unsigned long ulCurrentStream;
	unsigned long ulLastStreamQueued;
	HRESULT hrLastResult;
	unsigned long dwRunningState;
	unsigned long ulInputWordPos;
	unsigned long ulInputWordLen;
	unsigned long ulInputSentPos;
	unsigned long ulInputSentLen;
	long lBookmarkId;
	unsigned short PhonemeId;
	SPVISEMES VisemeId;
	unsigned long dwReserved1;
	unsigned long dwReserved2;
} SPVOICESTATUS;
'!
!SPVOICESTATUS categoriesForClass!SpeechLib-Structs! !
!SPVOICESTATUS methodsFor!

dwReserved1
	"Answer the receiver's dwReserved1 field as a Smalltalk object."

	^(bytes dwordAtOffset: 44)!

dwReserved1: anObject
	"Set the receiver's dwReserved1 field to the value of anObject."

	bytes dwordAtOffset: 44 put: anObject!

dwReserved2
	"Answer the receiver's dwReserved2 field as a Smalltalk object."

	^(bytes dwordAtOffset: 48)!

dwReserved2: anObject
	"Set the receiver's dwReserved2 field to the value of anObject."

	bytes dwordAtOffset: 48 put: anObject!

dwRunningState
	"Answer the receiver's dwRunningState field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dwRunningState: anObject
	"Set the receiver's dwRunningState field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

hrLastResult
	"Answer the receiver's hrLastResult field as a Smalltalk object."

	^(bytes sdwordAtOffset: 8)!

hrLastResult: anObject
	"Set the receiver's hrLastResult field to the value of anObject."

	bytes sdwordAtOffset: 8 put: anObject!

lBookmarkId
	"Answer the receiver's lBookmarkId field as a Smalltalk object."

	^(bytes sdwordAtOffset: 32)!

lBookmarkId: anObject
	"Set the receiver's lBookmarkId field to the value of anObject."

	bytes sdwordAtOffset: 32 put: anObject!

PhonemeId
	"Answer the receiver's PhonemeId field as a Smalltalk object."

	^(bytes wordAtOffset: 36)!

PhonemeId: anObject
	"Set the receiver's PhonemeId field to the value of anObject."

	bytes wordAtOffset: 36 put: anObject!

ulCurrentStream
	"Answer the receiver's ulCurrentStream field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

ulCurrentStream: anObject
	"Set the receiver's ulCurrentStream field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

ulInputSentLen
	"Answer the receiver's ulInputSentLen field as a Smalltalk object."

	^(bytes dwordAtOffset: 28)!

ulInputSentLen: anObject
	"Set the receiver's ulInputSentLen field to the value of anObject."

	bytes dwordAtOffset: 28 put: anObject!

ulInputSentPos
	"Answer the receiver's ulInputSentPos field as a Smalltalk object."

	^(bytes dwordAtOffset: 24)!

ulInputSentPos: anObject
	"Set the receiver's ulInputSentPos field to the value of anObject."

	bytes dwordAtOffset: 24 put: anObject!

ulInputWordLen
	"Answer the receiver's ulInputWordLen field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

ulInputWordLen: anObject
	"Set the receiver's ulInputWordLen field to the value of anObject."

	bytes dwordAtOffset: 20 put: anObject!

ulInputWordPos
	"Answer the receiver's ulInputWordPos field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

ulInputWordPos: anObject
	"Set the receiver's ulInputWordPos field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

ulLastStreamQueued
	"Answer the receiver's ulLastStreamQueued field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

ulLastStreamQueued: anObject
	"Set the receiver's ulLastStreamQueued field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

VisemeId
	"Answer the receiver's VisemeId field as a Smalltalk object."

	^(bytes sdwordAtOffset: 40)!

VisemeId: anObject
	"Set the receiver's VisemeId field to the value of anObject."

	bytes sdwordAtOffset: 40 put: anObject! !
!SPVOICESTATUS categoriesFor: #dwReserved1!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #dwReserved1:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #dwReserved2!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #dwReserved2:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #dwRunningState!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #dwRunningState:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #hrLastResult!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #hrLastResult:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #lBookmarkId!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #lBookmarkId:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #PhonemeId!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #PhonemeId:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulCurrentStream!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulCurrentStream:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulInputSentLen!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulInputSentLen:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulInputSentPos!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulInputSentPos:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulInputWordLen!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulInputWordLen:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulInputWordPos!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulInputWordPos:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulLastStreamQueued!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #ulLastStreamQueued:!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #VisemeId!**compiled accessors**!public! !
!SPVOICESTATUS categoriesFor: #VisemeId:!**compiled accessors**!public! !

!SPVOICESTATUS class methodsFor!

defineFields
	"Define the fields of the SPVOICESTATUS structure.
		SPVOICESTATUS compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPVOICESTATUS {
			unsigned long ulCurrentStream;
			unsigned long ulLastStreamQueued;
			HRESULT hrLastResult;
			unsigned long dwRunningState;
			unsigned long ulInputWordPos;
			unsigned long ulInputWordLen;
			unsigned long ulInputSentPos;
			unsigned long ulInputSentLen;
			long lBookmarkId;
			unsigned short PhonemeId;
			SPVISEMES VisemeId;
			unsigned long dwReserved1;
			unsigned long dwReserved2;
		} SPVOICESTATUS;
"

	self
		defineField: #ulCurrentStream type: DWORDField new offset: 0;
		defineField: #ulLastStreamQueued type: DWORDField new offset: 4;
		defineField: #hrLastResult type: SDWORDField new offset: 8;
		defineField: #dwRunningState type: DWORDField new offset: 12;
		defineField: #ulInputWordPos type: DWORDField new offset: 16;
		defineField: #ulInputWordLen type: DWORDField new offset: 20;
		defineField: #ulInputSentPos type: DWORDField new offset: 24;
		defineField: #ulInputSentLen type: DWORDField new offset: 28;
		defineField: #lBookmarkId type: SDWORDField new offset: 32;
		defineField: #PhonemeId type: WORDField new offset: 36;
		defineField: #VisemeId type: SDWORDField new offset: 40;
		defineField: #dwReserved1 type: DWORDField new offset: 44;
		defineField: #dwReserved2 type: DWORDField new offset: 48.
	self byteSize: 52!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 183! !
!SPVOICESTATUS class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPVOICESTATUS class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

