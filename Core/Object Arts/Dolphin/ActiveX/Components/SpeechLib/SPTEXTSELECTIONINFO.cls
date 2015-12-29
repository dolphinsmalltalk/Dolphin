"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPTEXTSELECTIONINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPTEXTSELECTIONINFO guid: (GUID fromString: '{9CFC5FBB-9585-4E9A-A605-761AB031DB60}')!
SPTEXTSELECTIONINFO comment: '<SPTEXTSELECTIONINFO> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPTEXTSELECTIONINFO'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden]
struct tagSPTEXTSELECTIONINFO {
	unsigned long ulStartActiveOffset;
	unsigned long cchActiveChars;
	unsigned long ulStartSelection;
	unsigned long cchSelection;
} SPTEXTSELECTIONINFO;
'!
!SPTEXTSELECTIONINFO categoriesForClass!SpeechLib-Structs! !
!SPTEXTSELECTIONINFO methodsFor!

cchActiveChars
	"Answer the receiver's cchActiveChars field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

cchActiveChars: anObject
	"Set the receiver's cchActiveChars field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

cchSelection
	"Answer the receiver's cchSelection field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

cchSelection: anObject
	"Set the receiver's cchSelection field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

ulStartActiveOffset
	"Answer the receiver's ulStartActiveOffset field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

ulStartActiveOffset: anObject
	"Set the receiver's ulStartActiveOffset field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

ulStartSelection
	"Answer the receiver's ulStartSelection field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

ulStartSelection: anObject
	"Set the receiver's ulStartSelection field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject! !
!SPTEXTSELECTIONINFO categoriesFor: #cchActiveChars!**compiled accessors**!public! !
!SPTEXTSELECTIONINFO categoriesFor: #cchActiveChars:!**compiled accessors**!public! !
!SPTEXTSELECTIONINFO categoriesFor: #cchSelection!**compiled accessors**!public! !
!SPTEXTSELECTIONINFO categoriesFor: #cchSelection:!**compiled accessors**!public! !
!SPTEXTSELECTIONINFO categoriesFor: #ulStartActiveOffset!**compiled accessors**!public! !
!SPTEXTSELECTIONINFO categoriesFor: #ulStartActiveOffset:!**compiled accessors**!public! !
!SPTEXTSELECTIONINFO categoriesFor: #ulStartSelection!**compiled accessors**!public! !
!SPTEXTSELECTIONINFO categoriesFor: #ulStartSelection:!**compiled accessors**!public! !

!SPTEXTSELECTIONINFO class methodsFor!

defineFields
	"Define the fields of the SPTEXTSELECTIONINFO structure.
		SPTEXTSELECTIONINFO compileDefinition
	
		typedef [hidden]
		struct tagSPTEXTSELECTIONINFO {
			unsigned long ulStartActiveOffset;
			unsigned long cchActiveChars;
			unsigned long ulStartSelection;
			unsigned long cchSelection;
		} SPTEXTSELECTIONINFO;
"

	self
		defineField: #ulStartActiveOffset type: DWORDField new offset: 0;
		defineField: #cchActiveChars type: DWORDField new offset: 4;
		defineField: #ulStartSelection type: DWORDField new offset: 8;
		defineField: #cchSelection type: DWORDField new offset: 12.
	self byteSize: 16!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 211! !
!SPTEXTSELECTIONINFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPTEXTSELECTIONINFO class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

