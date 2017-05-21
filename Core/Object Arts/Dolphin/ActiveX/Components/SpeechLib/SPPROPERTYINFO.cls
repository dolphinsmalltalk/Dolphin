"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SPPROPERTYINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPPROPERTYINFO guid: (GUID fromString: '{c0190740-cbf2-4609-b954-36a2faca1581}')!
SPPROPERTYINFO comment: '<SPPROPERTYINFO> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPPROPERTYINFO'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden]
struct tagSPPROPERTYINFO {
	unsigned short* pszName;
	unsigned long ulId;
	unsigned short* pszValue;
	VARIANT vValue;
} SPPROPERTYINFO;
'!
!SPPROPERTYINFO categoriesForClass!SpeechLib-Structs! !
!SPPROPERTYINFO methodsFor!

pszName
	"Answer the receiver's pszName field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 0)!

pszName: anObject
	"Set the receiver's pszName field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject yourAddress!

pszValue
	"Answer the receiver's pszValue field as a Smalltalk object."

	^WORD fromAddress: (bytes sdwordAtOffset: 8)!

pszValue: anObject
	"Set the receiver's pszValue field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject yourAddress!

ulId
	"Answer the receiver's ulId field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

ulId: anObject
	"Set the receiver's ulId field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

vValue
	"Answer the receiver's vValue field as a Smalltalk object."

	^VARIANT fromAddress: (bytes yourAddress + 16)!

vValue: anObject
	"Set the receiver's vValue field to the value of anObject."

	anObject replaceBytesOf: bytes from: 17 to: 32 startingAt: 1! !
!SPPROPERTYINFO categoriesFor: #pszName!**compiled accessors**!public! !
!SPPROPERTYINFO categoriesFor: #pszName:!**compiled accessors**!public! !
!SPPROPERTYINFO categoriesFor: #pszValue!**compiled accessors**!public! !
!SPPROPERTYINFO categoriesFor: #pszValue:!**compiled accessors**!public! !
!SPPROPERTYINFO categoriesFor: #ulId!**compiled accessors**!public! !
!SPPROPERTYINFO categoriesFor: #ulId:!**compiled accessors**!public! !
!SPPROPERTYINFO categoriesFor: #vValue!**compiled accessors**!public! !
!SPPROPERTYINFO categoriesFor: #vValue:!**compiled accessors**!public! !

!SPPROPERTYINFO class methodsFor!

defineFields
	"Define the fields of the SPPROPERTYINFO structure.
		SPPROPERTYINFO compileDefinition
	
		typedef [hidden]
		struct tagSPPROPERTYINFO {
			unsigned short* pszName;
			unsigned long ulId;
			unsigned short* pszValue;
			VARIANT vValue;
		} SPPROPERTYINFO;
"

	self
		defineField: #pszName type: (PointerField type: WORD) offset: 0;
		defineField: #ulId type: DWORDField new offset: 4;
		defineField: #pszValue type: (PointerField type: WORD) offset: 8;
		defineField: #vValue type: (StructureField type: VARIANT) offset: 16.
	self byteSize: 32!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 206! !
!SPPROPERTYINFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPPROPERTYINFO class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

