"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPRECOGNIZERSTATUS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPRECOGNIZERSTATUS guid: (GUID fromString: '{F42B27F3-79B9-467E-A970-DDE133DA371B}')!
SPRECOGNIZERSTATUS comment: '<SPRECOGNIZERSTATUS> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPRECOGNIZERSTATUS'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPRECOGNIZERSTATUS {
	SPAUDIOSTATUS AudioStatus;
	unsigned __int64 ullRecognitionStreamPos;
	unsigned long ulStreamNumber;
	unsigned long ulNumActive;
	GUID ClsidEngine;
	unsigned long cLangIDs;
	unsigned short aLangID[20];
	unsigned long dwReserved1;
	unsigned long dwReserved2;
} SPRECOGNIZERSTATUS;
'!
!SPRECOGNIZERSTATUS categoriesForClass!SpeechLib-Structs! !
!SPRECOGNIZERSTATUS methodsFor!

aLangID
	"Answer the receiver's aLangID field as a Smalltalk object."

	^WORDArray fromAddress: (bytes yourAddress + 76) length: 20!

aLangID: anObject
	"Set the receiver's aLangID field to the value of anObject."

	| size |
	size := anObject byteSize min: (20 * 2).
	anObject replaceBytesOf: bytes from: 77 to: 76 + size startingAt: 1!

AudioStatus
	"Answer the receiver's AudioStatus field as a Smalltalk object."

	^SPAUDIOSTATUS fromAddress: (bytes yourAddress)!

AudioStatus: anObject
	"Set the receiver's AudioStatus field to the value of anObject."

	anObject replaceBytesOf: bytes from: 1 to: 40 startingAt: 1!

cLangIDs
	"Answer the receiver's cLangIDs field as a Smalltalk object."

	^(bytes dwordAtOffset: 72)!

cLangIDs: anObject
	"Set the receiver's cLangIDs field to the value of anObject."

	bytes dwordAtOffset: 72 put: anObject!

ClsidEngine
	"Answer the receiver's ClsidEngine field as a Smalltalk object."

	^GUID fromAddress: (bytes yourAddress + 56)!

ClsidEngine: anObject
	"Set the receiver's ClsidEngine field to the value of anObject."

	anObject replaceBytesOf: bytes from: 57 to: 72 startingAt: 1!

dwReserved1
	"Answer the receiver's dwReserved1 field as a Smalltalk object."

	^(bytes dwordAtOffset: 116)!

dwReserved1: anObject
	"Set the receiver's dwReserved1 field to the value of anObject."

	bytes dwordAtOffset: 116 put: anObject!

dwReserved2
	"Answer the receiver's dwReserved2 field as a Smalltalk object."

	^(bytes dwordAtOffset: 120)!

dwReserved2: anObject
	"Set the receiver's dwReserved2 field to the value of anObject."

	bytes dwordAtOffset: 120 put: anObject!

ullRecognitionStreamPos
	"Answer the receiver's ullRecognitionStreamPos field as a Smalltalk object."

	^(bytes qwordAtOffset: 40)!

ullRecognitionStreamPos: anObject
	"Set the receiver's ullRecognitionStreamPos field to the value of anObject."

	bytes qwordAtOffset: 40 put: anObject!

ulNumActive
	"Answer the receiver's ulNumActive field as a Smalltalk object."

	^(bytes dwordAtOffset: 52)!

ulNumActive: anObject
	"Set the receiver's ulNumActive field to the value of anObject."

	bytes dwordAtOffset: 52 put: anObject!

ulStreamNumber
	"Answer the receiver's ulStreamNumber field as a Smalltalk object."

	^(bytes dwordAtOffset: 48)!

ulStreamNumber: anObject
	"Set the receiver's ulStreamNumber field to the value of anObject."

	bytes dwordAtOffset: 48 put: anObject! !
!SPRECOGNIZERSTATUS categoriesFor: #aLangID!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #aLangID:!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #AudioStatus!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #AudioStatus:!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #cLangIDs!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #cLangIDs:!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #ClsidEngine!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #ClsidEngine:!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #dwReserved1!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #dwReserved1:!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #dwReserved2!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #dwReserved2:!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #ullRecognitionStreamPos!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #ullRecognitionStreamPos:!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #ulNumActive!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #ulNumActive:!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #ulStreamNumber!**compiled accessors**!public! !
!SPRECOGNIZERSTATUS categoriesFor: #ulStreamNumber:!**compiled accessors**!public! !

!SPRECOGNIZERSTATUS class methodsFor!

defineFields
	"Define the fields of the SPRECOGNIZERSTATUS structure.
		SPRECOGNIZERSTATUS compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPRECOGNIZERSTATUS {
			SPAUDIOSTATUS AudioStatus;
			unsigned __int64 ullRecognitionStreamPos;
			unsigned long ulStreamNumber;
			unsigned long ulNumActive;
			GUID ClsidEngine;
			unsigned long cLangIDs;
			unsigned short aLangID[20];
			unsigned long dwReserved1;
			unsigned long dwReserved2;
		} SPRECOGNIZERSTATUS;
"

	self
		defineField: #AudioStatus type: (StructureField type: SPAUDIOSTATUS) offset: 0;
		defineField: #ullRecognitionStreamPos type: QWORDField new offset: 40;
		defineField: #ulStreamNumber type: DWORDField new offset: 48;
		defineField: #ulNumActive type: DWORDField new offset: 52;
		defineField: #ClsidEngine type: (StructureField type: GUID) offset: 56;
		defineField: #cLangIDs type: DWORDField new offset: 72;
		defineField: #aLangID type: (ArrayField type: WORDArray length: 20) offset: 76;
		defineField: #dwReserved1 type: DWORDField new offset: 116;
		defineField: #dwReserved2 type: DWORDField new offset: 120.
	self byteSize: 128!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 192! !
!SPRECOGNIZERSTATUS class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPRECOGNIZERSTATUS class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

