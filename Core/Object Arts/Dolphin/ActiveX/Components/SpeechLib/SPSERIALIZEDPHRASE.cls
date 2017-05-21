"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPSERIALIZEDPHRASE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPSERIALIZEDPHRASE guid: (GUID fromString: '{39b4850e-4e3f-4d41-b379-3c4dc5ee2014}')!
SPSERIALIZEDPHRASE comment: '<SPSERIALIZEDPHRASE> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPSERIALIZEDPHRASE'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPSERIALIZEDPHRASE {
	unsigned long ulSerializedSize;
} SPSERIALIZEDPHRASE;
'!
!SPSERIALIZEDPHRASE categoriesForClass!SpeechLib-Structs! !
!SPSERIALIZEDPHRASE methodsFor!

ulSerializedSize
	"Answer the receiver's ulSerializedSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

ulSerializedSize: anObject
	"Set the receiver's ulSerializedSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!SPSERIALIZEDPHRASE categoriesFor: #ulSerializedSize!**compiled accessors**!public! !
!SPSERIALIZEDPHRASE categoriesFor: #ulSerializedSize:!**compiled accessors**!public! !

!SPSERIALIZEDPHRASE class methodsFor!

defineFields
	"Define the fields of the SPSERIALIZEDPHRASE structure.
		SPSERIALIZEDPHRASE compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPSERIALIZEDPHRASE {
			unsigned long ulSerializedSize;
		} SPSERIALIZEDPHRASE;
"

	self
		defineField: #ulSerializedSize type: DWORDField new offset: 0.
	self byteSize: 4!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 201! !
!SPSERIALIZEDPHRASE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPSERIALIZEDPHRASE class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

