"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPPHRASEREPLACEMENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPPHRASEREPLACEMENT guid: (GUID fromString: '{86E3E2E0-69EF-4FEB-85BA-3D6C671EE46D}')!
SPPHRASEREPLACEMENT comment: '<SPPHRASEREPLACEMENT> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPPHRASEREPLACEMENT'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPPHRASEREPLACEMENT {
	BYTE bDisplayAttributes;
	unsigned short* pszReplacementText;
	unsigned long ulFirstElement;
	unsigned long ulCountOfElements;
} SPPHRASEREPLACEMENT;
'!
!SPPHRASEREPLACEMENT categoriesForClass!SpeechLib-Structs! !
!SPPHRASEREPLACEMENT methodsFor!

bDisplayAttributes
	"Answer the receiver's bDisplayAttributes field as a Smalltalk object."

	^(bytes byteAtOffset: 0)!

bDisplayAttributes: anObject
	"Set the receiver's bDisplayAttributes field to the value of anObject."

	bytes byteAtOffset: 0 put: anObject!

pszReplacementText
	"Answer the receiver's pszReplacementText field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 4)!

pszReplacementText: anObject
	"Set the receiver's pszReplacementText field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject yourAddress!

ulCountOfElements
	"Answer the receiver's ulCountOfElements field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

ulCountOfElements: anObject
	"Set the receiver's ulCountOfElements field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

ulFirstElement
	"Answer the receiver's ulFirstElement field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

ulFirstElement: anObject
	"Set the receiver's ulFirstElement field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject! !
!SPPHRASEREPLACEMENT categoriesFor: #bDisplayAttributes!**compiled accessors**!public! !
!SPPHRASEREPLACEMENT categoriesFor: #bDisplayAttributes:!**compiled accessors**!public! !
!SPPHRASEREPLACEMENT categoriesFor: #pszReplacementText!**compiled accessors**!public! !
!SPPHRASEREPLACEMENT categoriesFor: #pszReplacementText:!**compiled accessors**!public! !
!SPPHRASEREPLACEMENT categoriesFor: #ulCountOfElements!**compiled accessors**!public! !
!SPPHRASEREPLACEMENT categoriesFor: #ulCountOfElements:!**compiled accessors**!public! !
!SPPHRASEREPLACEMENT categoriesFor: #ulFirstElement!**compiled accessors**!public! !
!SPPHRASEREPLACEMENT categoriesFor: #ulFirstElement:!**compiled accessors**!public! !

!SPPHRASEREPLACEMENT class methodsFor!

defineFields
	"Define the fields of the SPPHRASEREPLACEMENT structure.
		SPPHRASEREPLACEMENT compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPPHRASEREPLACEMENT {
			BYTE bDisplayAttributes;
			unsigned short* pszReplacementText;
			unsigned long ulFirstElement;
			unsigned long ulCountOfElements;
		} SPPHRASEREPLACEMENT;
"

	self
		defineField: #bDisplayAttributes type: BYTEField new offset: 0;
		defineField: #pszReplacementText type: (PointerField type: WORD) offset: 4;
		defineField: #ulFirstElement type: DWORDField new offset: 8;
		defineField: #ulCountOfElements type: DWORDField new offset: 12.
	self byteSize: 16!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 200! !
!SPPHRASEREPLACEMENT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPPHRASEREPLACEMENT class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

