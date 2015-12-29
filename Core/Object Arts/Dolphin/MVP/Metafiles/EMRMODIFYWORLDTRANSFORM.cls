"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRMODIFYWORLDTRANSFORM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRMODIFYWORLDTRANSFORM guid: (GUID fromString: '{2144962D-5610-4388-BB45-8B820EFAC2E7}')!
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
	"Answer the receiver's iMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iMode)!

iMode: anObject 
	"Set the receiver's iMode field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iMode) put: anObject!

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
!EMRMODIFYWORLDTRANSFORM categoriesFor: #iMode!**compiled accessors**!public! !
!EMRMODIFYWORLDTRANSFORM categoriesFor: #iMode:!**compiled accessors**!public! !
!EMRMODIFYWORLDTRANSFORM categoriesFor: #XFORM!**compiled accessors**!public! !
!EMRMODIFYWORLDTRANSFORM categoriesFor: #XFORM:!**compiled accessors**!public! !

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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_MODIFYWORLDTRANSFORM! !
!EMRMODIFYWORLDTRANSFORM class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRMODIFYWORLDTRANSFORM class categoriesFor: #iTypes!constants!public! !

