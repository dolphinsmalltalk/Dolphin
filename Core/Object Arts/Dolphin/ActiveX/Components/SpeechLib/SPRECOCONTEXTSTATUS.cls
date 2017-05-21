"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPRECOCONTEXTSTATUS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPRECOCONTEXTSTATUS guid: (GUID fromString: '{c8b55440-f1a9-490f-a3b4-a6fb4158dc7e}')!
SPRECOCONTEXTSTATUS comment: '<SPRECOCONTEXTSTATUS> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPRECOCONTEXTSTATUS'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPRECOCONTEXTSTATUS {
	SPINTERFERENCE eInterference;
	unsigned short szRequestTypeOfUI[255];
	unsigned long dwReserved1;
	unsigned long dwReserved2;
} SPRECOCONTEXTSTATUS;
'!
!SPRECOCONTEXTSTATUS categoriesForClass!SpeechLib-Structs! !
!SPRECOCONTEXTSTATUS methodsFor!

dwReserved1
	"Answer the receiver's dwReserved1 field as a Smalltalk object."

	^(bytes dwordAtOffset: 516)!

dwReserved1: anObject
	"Set the receiver's dwReserved1 field to the value of anObject."

	bytes dwordAtOffset: 516 put: anObject!

dwReserved2
	"Answer the receiver's dwReserved2 field as a Smalltalk object."

	^(bytes dwordAtOffset: 520)!

dwReserved2: anObject
	"Set the receiver's dwReserved2 field to the value of anObject."

	bytes dwordAtOffset: 520 put: anObject!

eInterference
	"Answer the receiver's eInterference field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

eInterference: anObject
	"Set the receiver's eInterference field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

szRequestTypeOfUI
	"Answer the receiver's szRequestTypeOfUI field as a Smalltalk object."

	^WORDArray fromAddress: (bytes yourAddress + 4) length: 255!

szRequestTypeOfUI: anObject
	"Set the receiver's szRequestTypeOfUI field to the value of anObject."

	| size |
	size := anObject byteSize min: (255 * 2).
	anObject replaceBytesOf: bytes from: 5 to: 4 + size startingAt: 1! !
!SPRECOCONTEXTSTATUS categoriesFor: #dwReserved1!**compiled accessors**!public! !
!SPRECOCONTEXTSTATUS categoriesFor: #dwReserved1:!**compiled accessors**!public! !
!SPRECOCONTEXTSTATUS categoriesFor: #dwReserved2!**compiled accessors**!public! !
!SPRECOCONTEXTSTATUS categoriesFor: #dwReserved2:!**compiled accessors**!public! !
!SPRECOCONTEXTSTATUS categoriesFor: #eInterference!**compiled accessors**!public! !
!SPRECOCONTEXTSTATUS categoriesFor: #eInterference:!**compiled accessors**!public! !
!SPRECOCONTEXTSTATUS categoriesFor: #szRequestTypeOfUI!**compiled accessors**!public! !
!SPRECOCONTEXTSTATUS categoriesFor: #szRequestTypeOfUI:!**compiled accessors**!public! !

!SPRECOCONTEXTSTATUS class methodsFor!

defineFields
	"Define the fields of the SPRECOCONTEXTSTATUS structure.
		SPRECOCONTEXTSTATUS compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPRECOCONTEXTSTATUS {
			SPINTERFERENCE eInterference;
			unsigned short szRequestTypeOfUI[255];
			unsigned long dwReserved1;
			unsigned long dwReserved2;
		} SPRECOCONTEXTSTATUS;
"

	self
		defineField: #eInterference type: SDWORDField new offset: 0;
		defineField: #szRequestTypeOfUI type: (ArrayField type: WORDArray length: 255) offset: 4;
		defineField: #dwReserved1 type: DWORDField new offset: 516;
		defineField: #dwReserved2 type: DWORDField new offset: 520.
	self byteSize: 524!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 214! !
!SPRECOCONTEXTSTATUS class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPRECOCONTEXTSTATUS class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

