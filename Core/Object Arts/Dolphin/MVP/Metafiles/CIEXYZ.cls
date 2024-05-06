"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #CIEXYZ
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_ciexyzX _OffsetOf_ciexyzY _OffsetOf_ciexyzZ'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CIEXYZ guid: (GUID fromString: '{bf6d67a4-8fbc-4f17-825f-465254239f8b}')!

CIEXYZ addClassConstant: '_OffsetOf_ciexyzX' value: 16r0!
CIEXYZ addClassConstant: '_OffsetOf_ciexyzY' value: 16r4!
CIEXYZ addClassConstant: '_OffsetOf_ciexyzZ' value: 16r8!

CIEXYZ comment: '<CIEXYZ> is an <ExternalStructure> class to wrap the struct ''Win32.CIEXYZ'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BF6D67A4-8FBC-4F17-825F-465254239F8B)]
struct tagCIEXYZ {
	long ciexyzX;
	long ciexyzY;
	long ciexyzZ;
} CIEXYZ;
'!

!CIEXYZ categoriesForClass!Win32-Structs! !

!CIEXYZ methodsFor!

ciexyzX
	"Answer the <Integer> value of the receiver's 'ciexyzX' field."

	^bytes sdwordAtOffset: _OffsetOf_ciexyzX!

ciexyzX: anInteger
	"Set the receiver's 'ciexyzX' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_ciexyzX put: anInteger!

ciexyzY
	"Answer the <Integer> value of the receiver's 'ciexyzY' field."

	^bytes sdwordAtOffset: _OffsetOf_ciexyzY!

ciexyzY: anInteger
	"Set the receiver's 'ciexyzY' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_ciexyzY put: anInteger!

ciexyzZ
	"Answer the <Integer> value of the receiver's 'ciexyzZ' field."

	^bytes sdwordAtOffset: _OffsetOf_ciexyzZ!

ciexyzZ: anInteger
	"Set the receiver's 'ciexyzZ' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_ciexyzZ put: anInteger! !

!CIEXYZ categoriesForMethods!
ciexyzX!**compiled accessors**!public! !
ciexyzX:!**compiled accessors**!public! !
ciexyzY!**compiled accessors**!public! !
ciexyzY:!**compiled accessors**!public! !
ciexyzZ!**compiled accessors**!public! !
ciexyzZ:!**compiled accessors**!public! !
!

!CIEXYZ class methodsFor!

defineFields
	"Define the fields of the CIEXYZ structure.

	CIEXYZ  compileDefinition

		typedef [uuid(BF6D67A4-8FBC-4F17-825F-465254239F8B)]
		struct tagCIEXYZ {
			long ciexyzX;
			long ciexyzY;
			long ciexyzZ;
		} CIEXYZ;
"

	self
		defineField: #ciexyzX type: SDWORDField new offset: 0;
		defineField: #ciexyzY type: SDWORDField new offset: 4;
		defineField: #ciexyzZ type: SDWORDField new offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#ciexyzX #ciexyzY #ciexyzZ)! !

!CIEXYZ class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

