"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRSETWORLDTRANSFORM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETWORLDTRANSFORM guid: (GUID fromString: '{025EF1A8-7714-4E3C-BCF0-755137290843}')!
EMRSETWORLDTRANSFORM comment: '<EMRSETWORLDTRANSFORM> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETWORLDTRANSFORM'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(025EF1A8-7714-4E3C-BCF0-755137290843)]
struct tagEMRSETWORLDTRANSFORM {
	EMR EMR;
	XFORM XFORM;
} EMRSETWORLDTRANSFORM;
'!
!EMRSETWORLDTRANSFORM categoriesForClass!Win32-Structs! !
!EMRSETWORLDTRANSFORM methodsFor!

XFORM
	"Answer the receiver's XFORM field as a Smalltalk object."

	^XFORM fromAddress: bytes yourAddress + ##(self offsetOf: #XFORM)!

XFORM: anObject 
	"Set the receiver's XFORM field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #XFORM) + 1)
		to: ##((self offsetOf: #XFORM) + XFORM basicByteSize)
		startingAt: 1! !
!EMRSETWORLDTRANSFORM categoriesFor: #XFORM!**compiled accessors**!public! !
!EMRSETWORLDTRANSFORM categoriesFor: #XFORM:!**compiled accessors**!public! !

!EMRSETWORLDTRANSFORM class methodsFor!

defineFields
	"Define the fields of the EMRSETWORLDTRANSFORM structure.

	EMRSETWORLDTRANSFORM  compileDefinition

		typedef [uuid(025EF1A8-7714-4E3C-BCF0-755137290843)]
		struct tagEMRSETWORLDTRANSFORM {
			EMR EMR;
			XFORM XFORM;
		} EMRSETWORLDTRANSFORM;
"

	super defineFields.
	self
		defineField: #XFORM
			type: (StructureField type: XFORM)
			offset: 8.
	self byteSize: 32!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SETWORLDTRANSFORM! !
!EMRSETWORLDTRANSFORM class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRSETWORLDTRANSFORM class categoriesFor: #iTypes!constants!public! !

