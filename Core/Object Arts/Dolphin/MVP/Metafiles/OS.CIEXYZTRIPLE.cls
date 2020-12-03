"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.CIEXYZTRIPLE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ciexyzBlue' -> 16r18.
		'_OffsetOf_ciexyzGreen' -> 16rC.
		'_OffsetOf_ciexyzRed' -> 16r0
	}!
OS.CIEXYZTRIPLE guid: (Core.GUID fromString: '{2fd9d553-f2b2-4bfb-9dca-4c245bbff3d2}')!
OS.CIEXYZTRIPLE comment: '<CIEXYZTRIPLE> is an <ExternalStructure> class to wrap the struct ''Win32.CIEXYZTRIPLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.CIEXYZTRIPLE categoriesForClass!Win32-Structs! !
!OS.CIEXYZTRIPLE methodsFor!

ciexyzBlue
	"Answer the <CIEXYZ> value of the receiver's 'ciexyzBlue' field."

	^CIEXYZ fromAddress: bytes yourAddress + _OffsetOf_ciexyzBlue!

ciexyzBlue: aCIEXYZ
	"Set the receiver's 'ciexyzBlue' field to the value of the argument, aCIEXYZ"

	aCIEXYZ
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ciexyzBlue + 1)
		to: ##(_OffsetOf_ciexyzBlue + CIEXYZ basicByteSize)
		startingAt: 1!

ciexyzGreen
	"Answer the <CIEXYZ> value of the receiver's 'ciexyzGreen' field."

	^CIEXYZ fromAddress: bytes yourAddress + _OffsetOf_ciexyzGreen!

ciexyzGreen: aCIEXYZ
	"Set the receiver's 'ciexyzGreen' field to the value of the argument, aCIEXYZ"

	aCIEXYZ
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ciexyzGreen + 1)
		to: ##(_OffsetOf_ciexyzGreen + CIEXYZ basicByteSize)
		startingAt: 1!

ciexyzRed
	"Answer the <CIEXYZ> value of the receiver's 'ciexyzRed' field."

	^CIEXYZ fromAddress: bytes yourAddress!

ciexyzRed: aCIEXYZ
	"Set the receiver's 'ciexyzRed' field to the value of the argument, aCIEXYZ"

	aCIEXYZ
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ciexyzRed + 1)
		to: ##(_OffsetOf_ciexyzRed + CIEXYZ basicByteSize)
		startingAt: 1! !
!OS.CIEXYZTRIPLE categoriesFor: #ciexyzBlue!**compiled accessors**!public! !
!OS.CIEXYZTRIPLE categoriesFor: #ciexyzBlue:!**compiled accessors**!public! !
!OS.CIEXYZTRIPLE categoriesFor: #ciexyzGreen!**compiled accessors**!public! !
!OS.CIEXYZTRIPLE categoriesFor: #ciexyzGreen:!**compiled accessors**!public! !
!OS.CIEXYZTRIPLE categoriesFor: #ciexyzRed!**compiled accessors**!public! !
!OS.CIEXYZTRIPLE categoriesFor: #ciexyzRed:!**compiled accessors**!public! !

!OS.CIEXYZTRIPLE class methodsFor!

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
		defineField: #ciexyzRed
			type: (StructureField type: CIEXYZ)
			offset: 0;
		defineField: #ciexyzGreen
			type: (StructureField type: CIEXYZ)
			offset: 12;
		defineField: #ciexyzBlue
			type: (StructureField type: CIEXYZ)
			offset: 24.
	self byteSize: 36!

getFieldNames
	^#(#ciexyzRed #ciexyzGreen #ciexyzBlue)! !
!OS.CIEXYZTRIPLE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.CIEXYZTRIPLE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

