"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETPIXELV
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETPIXELV guid: (GUID fromString: '{a1dc1f6e-41ae-4ffa-90d8-778106a60b0b}')!
EMRSETPIXELV comment: '<EMRSETPIXELV> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETPIXELV'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A1DC1F6E-41AE-4FFA-90D8-778106A60B0B)]
struct tagEMRSETPIXELV {
	EMR EMR;
	POINTL ptlPixel;
	COLORREF crColor;
} EMRSETPIXELV;
'!
!EMRSETPIXELV categoriesForClass!Win32-Structs! !
!EMRSETPIXELV methodsFor!

crColor
	"Answer the receiver's crColor field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #crColor)!

crColor: anObject 
	"Set the receiver's crColor field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #crColor) put: anObject!

ptlPixel
	"Answer the receiver's ptlPixel field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptlPixel)!

ptlPixel: anObject 
	"Set the receiver's ptlPixel field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ptlPixel) + 1)
		to: ##((self offsetOf: #ptlPixel) + POINTL basicByteSize)
		startingAt: 1! !
!EMRSETPIXELV categoriesFor: #crColor!**compiled accessors**!public! !
!EMRSETPIXELV categoriesFor: #crColor:!**compiled accessors**!public! !
!EMRSETPIXELV categoriesFor: #ptlPixel!**compiled accessors**!public! !
!EMRSETPIXELV categoriesFor: #ptlPixel:!**compiled accessors**!public! !

!EMRSETPIXELV class methodsFor!

defineFields
	"Define the fields of the EMRSETPIXELV structure.

	EMRSETPIXELV  compileDefinition

		typedef [uuid(A1DC1F6E-41AE-4FFA-90D8-778106A60B0B)]
		struct tagEMRSETPIXELV {
			EMR EMR;
			POINTL ptlPixel;
			COLORREF crColor;
		} EMRSETPIXELV;
"

	super defineFields.
	self
		defineField: #ptlPixel
			type: (StructureField type: POINTL)
			offset: 8;
		defineField: #crColor
			type: DWORDField new
			offset: 16.
	self byteSize: 20!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SETPIXELV! !
!EMRSETPIXELV class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRSETPIXELV class categoriesFor: #iTypes!constants!public! !

