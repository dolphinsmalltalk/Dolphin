"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRPIXELFORMAT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPIXELFORMAT guid: (GUID fromString: '{D3D01D9C-95DB-40F4-9304-D212A548DEF1}')!
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
	"Answer the receiver's pfd field as a Smalltalk object."

	^PIXELFORMATDESCRIPTOR fromAddress: bytes yourAddress + ##(self offsetOf: #pfd)!

pfd: anObject 
	"Set the receiver's pfd field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #pfd) + 1)
		to: ##((self offsetOf: #pfd) + PIXELFORMATDESCRIPTOR basicByteSize)
		startingAt: 1! !
!EMRPIXELFORMAT categoriesFor: #pfd!**compiled accessors**!public! !
!EMRPIXELFORMAT categoriesFor: #pfd:!**compiled accessors**!public! !

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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_PIXELFORMAT! !
!EMRPIXELFORMAT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRPIXELFORMAT class categoriesFor: #iTypes!constants!public! !

