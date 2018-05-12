"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #CIEXYZTRIPLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CIEXYZTRIPLE guid: (GUID fromString: '{2fd9d553-f2b2-4bfb-9dca-4c245bbff3d2}')!
CIEXYZTRIPLE comment: '<CIEXYZTRIPLE> is an <ExternalStructure> class to wrap the struct ''Win32.CIEXYZTRIPLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2FD9D553-F2B2-4BFB-9DCA-4C245BBFF3D2)]
struct tagCIEXYZTRIPLE {
	CIEXYZ ciexyzRed;
	CIEXYZ ciexyzGreen;
	CIEXYZ ciexyzBlue;
} CIEXYZTRIPLE;
'!
!CIEXYZTRIPLE categoriesForClass!Win32-Structs! !
!CIEXYZTRIPLE methodsFor!

ciexyzBlue
	"Answer the receiver's ciexyzBlue field as a Smalltalk object."

	^CIEXYZ fromAddress: bytes yourAddress + ##(self offsetOf: #ciexyzBlue)!

ciexyzBlue: anObject 
	"Set the receiver's ciexyzBlue field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ciexyzBlue) + 1)
		to: ##((self offsetOf: #ciexyzBlue) + CIEXYZ basicByteSize)
		startingAt: 1!

ciexyzGreen
	"Answer the receiver's ciexyzGreen field as a Smalltalk object."

	^CIEXYZ fromAddress: bytes yourAddress + ##(self offsetOf: #ciexyzGreen)!

ciexyzGreen: anObject 
	"Set the receiver's ciexyzGreen field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ciexyzGreen) + 1)
		to: ##((self offsetOf: #ciexyzGreen) + CIEXYZ basicByteSize)
		startingAt: 1!

ciexyzRed
	"Answer the receiver's ciexyzRed field as a Smalltalk object."

	^CIEXYZ fromAddress: bytes yourAddress!

ciexyzRed: anObject 
	"Set the receiver's ciexyzRed field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: 1
		to: ##(CIEXYZ basicByteSize)
		startingAt: 1! !
!CIEXYZTRIPLE categoriesFor: #ciexyzBlue!**compiled accessors**!public! !
!CIEXYZTRIPLE categoriesFor: #ciexyzBlue:!**compiled accessors**!public! !
!CIEXYZTRIPLE categoriesFor: #ciexyzGreen!**compiled accessors**!public! !
!CIEXYZTRIPLE categoriesFor: #ciexyzGreen:!**compiled accessors**!public! !
!CIEXYZTRIPLE categoriesFor: #ciexyzRed!**compiled accessors**!public! !
!CIEXYZTRIPLE categoriesFor: #ciexyzRed:!**compiled accessors**!public! !

!CIEXYZTRIPLE class methodsFor!

defineFields
	"Define the fields of the CIEXYZTRIPLE structure.

	CIEXYZTRIPLE  compileDefinition

		typedef [uuid(2FD9D553-F2B2-4BFB-9DCA-4C245BBFF3D2)]
		struct tagCIEXYZTRIPLE {
			CIEXYZ ciexyzRed;
			CIEXYZ ciexyzGreen;
			CIEXYZ ciexyzBlue;
		} CIEXYZTRIPLE;
"

	self
		defineField: #ciexyzRed type: (StructureField type: CIEXYZ) offset: 0;
		defineField: #ciexyzGreen type: (StructureField type: CIEXYZ) offset: 12;
		defineField: #ciexyzBlue type: (StructureField type: CIEXYZ) offset: 24.
	self byteSize: 36! !
!CIEXYZTRIPLE class categoriesFor: #defineFields!**auto generated**!initializing!public! !

