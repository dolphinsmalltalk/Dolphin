"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRMODIFYWORLDTRANSFORM
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iMode _OffsetOf_XFORM'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRMODIFYWORLDTRANSFORM guid: (GUID fromString: '{2144962d-5610-4388-bb45-8b820efac2e7}')!
EMRMODIFYWORLDTRANSFORM addClassConstant: '_OffsetOf_iMode' value: 16r20!
EMRMODIFYWORLDTRANSFORM addClassConstant: '_OffsetOf_XFORM' value: 16r8!
EMRMODIFYWORLDTRANSFORM comment: '<EMRMODIFYWORLDTRANSFORM> is an <ExternalStructure> class to wrap the struct ''Win32.EMRMODIFYWORLDTRANSFORM'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2144962D-5610-4388-BB45-8B820EFAC2E7)]
struct tagEMRMODIFYWORLDTRANSFORM {
	EMR EMR;
	XFORM XFORM;
	DWORD iMode;
} EMRMODIFYWORLDTRANSFORM;
'!
!EMRMODIFYWORLDTRANSFORM categoriesForClass!Win32-Structs! !
!EMRMODIFYWORLDTRANSFORM methodsFor!

iMode
	"Answer the <Integer> value of the receiver's 'iMode' field."

	^bytes dwordAtOffset: _OffsetOf_iMode!

iMode: anInteger
	"Set the receiver's 'iMode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iMode put: anInteger!

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
!EMRMODIFYWORLDTRANSFORM categoriesForMethods!
iMode!**compiled accessors**!public! !
iMode:!**compiled accessors**!public! !
XFORM!**compiled accessors**!public! !
XFORM:!**compiled accessors**!public! !
!

!EMRMODIFYWORLDTRANSFORM class methodsFor!

defineFields
	"Define the fields of the EMRMODIFYWORLDTRANSFORM structure.

	EMRMODIFYWORLDTRANSFORM  compileDefinition

		typedef [uuid(2144962D-5610-4388-BB45-8B820EFAC2E7)]
		struct tagEMRMODIFYWORLDTRANSFORM {
			EMR EMR;
			XFORM XFORM;
			DWORD iMode;
		} EMRMODIFYWORLDTRANSFORM;
"

	super defineFields.
	self
		defineField: #XFORM
			type: (StructureField type: XFORM)
			offset: 8;
		defineField: #iMode
			type: DWORDField new
			offset: 32.
	self byteSize: 36!

getFieldNames
	^#(#iType #nSize #XFORM #iMode)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_MODIFYWORLDTRANSFORM! !
!EMRMODIFYWORLDTRANSFORM class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

