"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPBINARYGRAMMAR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPBINARYGRAMMAR guid: (GUID fromString: '{0f584425-1498-4f41-ab1e-f25e3690b78c}')!
SPBINARYGRAMMAR comment: '<SPBINARYGRAMMAR> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPBINARYGRAMMAR'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden]
struct tagSPBINARYGRAMMAR {
	unsigned long ulTotalSerializedSize;
} SPBINARYGRAMMAR;
'!
!SPBINARYGRAMMAR categoriesForClass!SpeechLib-Structs! !
!SPBINARYGRAMMAR methodsFor!

ulTotalSerializedSize
	"Answer the receiver's ulTotalSerializedSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

ulTotalSerializedSize: anObject
	"Set the receiver's ulTotalSerializedSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!SPBINARYGRAMMAR categoriesFor: #ulTotalSerializedSize!**compiled accessors**!public! !
!SPBINARYGRAMMAR categoriesFor: #ulTotalSerializedSize:!**compiled accessors**!public! !

!SPBINARYGRAMMAR class methodsFor!

defineFields
	"Define the fields of the SPBINARYGRAMMAR structure.
		SPBINARYGRAMMAR compileDefinition
	
		typedef [hidden]
		struct tagSPBINARYGRAMMAR {
			unsigned long ulTotalSerializedSize;
		} SPBINARYGRAMMAR;
"

	self
		defineField: #ulTotalSerializedSize type: DWORDField new offset: 0.
	self byteSize: 4!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 208! !
!SPBINARYGRAMMAR class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPBINARYGRAMMAR class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

