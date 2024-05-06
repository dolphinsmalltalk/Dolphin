"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRPIXELFORMAT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_pfd'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMRPIXELFORMAT guid: (GUID fromString: '{d3d01d9c-95db-40f4-9304-d212a548def1}')!

EMRPIXELFORMAT addClassConstant: '_OffsetOf_pfd' value: 16r8!

EMRPIXELFORMAT comment: '<EMRPIXELFORMAT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPIXELFORMAT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(D3D01D9C-95DB-40F4-9304-D212A548DEF1)]
struct tagEMRPIXELFORMAT {
	EMR EMR;
	PIXELFORMATDESCRIPTOR pfd;
} EMRPIXELFORMAT;
'!

!EMRPIXELFORMAT categoriesForClass!Win32-Structs! !

!EMRPIXELFORMAT methodsFor!

pfd
	"Answer the <PIXELFORMATDESCRIPTOR> value of the receiver's 'pfd' field."

	^PIXELFORMATDESCRIPTOR fromAddress: bytes yourAddress + _OffsetOf_pfd!

pfd: aPIXELFORMATDESCRIPTOR
	"Set the receiver's 'pfd' field to the value of the argument, aPIXELFORMATDESCRIPTOR"

	aPIXELFORMATDESCRIPTOR
		replaceBytesOf: bytes
		from: ##(_OffsetOf_pfd + 1)
		to: ##(_OffsetOf_pfd + PIXELFORMATDESCRIPTOR basicByteSize)
		startingAt: 1! !

!EMRPIXELFORMAT categoriesForMethods!
pfd!**compiled accessors**!public! !
pfd:!**compiled accessors**!public! !
!

!EMRPIXELFORMAT class methodsFor!

defineFields
	"Define the fields of the EMRPIXELFORMAT structure.

	EMRPIXELFORMAT  compileDefinition

		typedef [uuid(D3D01D9C-95DB-40F4-9304-D212A548DEF1)]
		struct tagEMRPIXELFORMAT {
			EMR EMR;
			PIXELFORMATDESCRIPTOR pfd;
		} EMRPIXELFORMAT;
"

	super defineFields.
	self 
		defineField: #pfd
		type: (StructureField type: PIXELFORMATDESCRIPTOR)
		offset: 8.
	self byteSize: 48!

getFieldNames
	^#(#iType #nSize #pfd)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_PIXELFORMAT! !

!EMRPIXELFORMAT class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

