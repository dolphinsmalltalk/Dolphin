"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPEVENTSOURCEINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPEVENTSOURCEINFO guid: (GUID fromString: '{19ac5f6d-6863-490b-879b-95d93cb77ef6}')!
SPEVENTSOURCEINFO comment: '<SPEVENTSOURCEINFO> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPEVENTSOURCEINFO'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPEVENTSOURCEINFO {
	unsigned __int64 ullEventInterest;
	unsigned __int64 ullQueuedInterest;
	unsigned long ulCount;
} SPEVENTSOURCEINFO;
'!
!SPEVENTSOURCEINFO categoriesForClass!SpeechLib-Structs! !
!SPEVENTSOURCEINFO methodsFor!

ulCount
	"Answer the receiver's ulCount field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

ulCount: anObject
	"Set the receiver's ulCount field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

ullEventInterest
	"Answer the receiver's ullEventInterest field as a Smalltalk object."

	^(bytes qwordAtOffset: 0)!

ullEventInterest: anObject
	"Set the receiver's ullEventInterest field to the value of anObject."

	bytes qwordAtOffset: 0 put: anObject!

ullQueuedInterest
	"Answer the receiver's ullQueuedInterest field as a Smalltalk object."

	^(bytes qwordAtOffset: 8)!

ullQueuedInterest: anObject
	"Set the receiver's ullQueuedInterest field to the value of anObject."

	bytes qwordAtOffset: 8 put: anObject! !
!SPEVENTSOURCEINFO categoriesFor: #ulCount!**compiled accessors**!public! !
!SPEVENTSOURCEINFO categoriesFor: #ulCount:!**compiled accessors**!public! !
!SPEVENTSOURCEINFO categoriesFor: #ullEventInterest!**compiled accessors**!public! !
!SPEVENTSOURCEINFO categoriesFor: #ullEventInterest:!**compiled accessors**!public! !
!SPEVENTSOURCEINFO categoriesFor: #ullQueuedInterest!**compiled accessors**!public! !
!SPEVENTSOURCEINFO categoriesFor: #ullQueuedInterest:!**compiled accessors**!public! !

!SPEVENTSOURCEINFO class methodsFor!

defineFields
	"Define the fields of the SPEVENTSOURCEINFO structure.
		SPEVENTSOURCEINFO compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPEVENTSOURCEINFO {
			unsigned __int64 ullEventInterest;
			unsigned __int64 ullQueuedInterest;
			unsigned long ulCount;
		} SPEVENTSOURCEINFO;
"

	self
		defineField: #ullEventInterest type: QWORDField new offset: 0;
		defineField: #ullQueuedInterest type: QWORDField new offset: 8;
		defineField: #ulCount type: DWORDField new offset: 16.
	self byteSize: 24!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 167! !
!SPEVENTSOURCEINFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPEVENTSOURCEINFO class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

