"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPSERIALIZEDRESULT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPSERIALIZEDRESULT guid: (GUID fromString: '{a9eac435-2b94-45ba-a3c6-a2962e6812d3}')!
SPSERIALIZEDRESULT comment: '<SPSERIALIZEDRESULT> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPSERIALIZEDRESULT'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden]
struct tagSPSERIALIZEDRESULT {
	unsigned long ulSerializedSize;
} SPSERIALIZEDRESULT;
'!
!SPSERIALIZEDRESULT categoriesForClass!SpeechLib-Structs! !
!SPSERIALIZEDRESULT methodsFor!

ulSerializedSize
	"Answer the receiver's ulSerializedSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

ulSerializedSize: anObject
	"Set the receiver's ulSerializedSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!SPSERIALIZEDRESULT categoriesFor: #ulSerializedSize!**compiled accessors**!public! !
!SPSERIALIZEDRESULT categoriesFor: #ulSerializedSize:!**compiled accessors**!public! !

!SPSERIALIZEDRESULT class methodsFor!

defineFields
	"Define the fields of the SPSERIALIZEDRESULT structure.
		SPSERIALIZEDRESULT compileDefinition
	
		typedef [hidden]
		struct tagSPSERIALIZEDRESULT {
			unsigned long ulSerializedSize;
		} SPSERIALIZEDRESULT;
"

	self
		defineField: #ulSerializedSize type: DWORDField new offset: 0.
	self byteSize: 4!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 217! !
!SPSERIALIZEDRESULT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPSERIALIZEDRESULT class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

