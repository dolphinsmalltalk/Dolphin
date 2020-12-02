"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETWORLDTRANSFORM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_XFORM' -> 16r8
	}!
EMRSETWORLDTRANSFORM guid: (GUID fromString: '{025ef1a8-7714-4e3c-bcf0-755137290843}')!
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
	"Answer the <XFORM> value of the receiver's 'XFORM' field."

	^XFORM fromAddress: bytes yourAddress + _OffsetOf_XFORM!

XFORM: aXFORM
	"Set the receiver's 'XFORM' field to the value of the argument, aXFORM"

	aXFORM
		replaceBytesOf: bytes
		from: ##(_OffsetOf_XFORM + 1)
		to: ##(_OffsetOf_XFORM + XFORM basicByteSize)
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

getFieldNames
	^#(#iType #nSize #XFORM)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETWORLDTRANSFORM}! !
!EMRSETWORLDTRANSFORM class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSETWORLDTRANSFORM class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETWORLDTRANSFORM class categoriesFor: #iTypes!constants!public! !

