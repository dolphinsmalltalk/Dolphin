"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRCREATEPALETTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCREATEPALETTE guid: (GUID fromString: '{B8739ED2-DE47-467F-AA8D-3A62F4C00509}')!
EMRCREATEPALETTE comment: '<EMRCREATEPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEPALETTE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(B8739ED2-DE47-467F-AA8D-3A62F4C00509)]
struct tagEMRCREATEPALETTE {
	EMR EMR;
	[helpstring("Palette handle index")] DWORD ihPal;
	[helpstring("The peFlags fields in the palette entries do not contain any flags")] LOGPALETTE lgpl;
} EMRCREATEPALETTE;
'!
!EMRCREATEPALETTE categoriesForClass!Win32-Structs! !
!EMRCREATEPALETTE methodsFor!

ihPal
	"Answer the receiver's ihPal field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihPal)!

ihPal: anObject 
	"Set the receiver's ihPal field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihPal) put: anObject!

lgpl
	"Answer the receiver's lgpl field as a Smalltalk object."

	^LOGPALETTE fromAddress: bytes yourAddress + ##(self offsetOf: #lgpl)!

lgpl: anObject 
	"Set the receiver's lgpl field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lgpl) + 1)
		to: ##((self offsetOf: #lgpl) + LOGPALETTE basicByteSize)
		startingAt: 1! !
!EMRCREATEPALETTE categoriesFor: #ihPal!**compiled accessors**!public! !
!EMRCREATEPALETTE categoriesFor: #ihPal:!**compiled accessors**!public! !
!EMRCREATEPALETTE categoriesFor: #lgpl!**compiled accessors**!public! !
!EMRCREATEPALETTE categoriesFor: #lgpl:!**compiled accessors**!public! !

!EMRCREATEPALETTE class methodsFor!

defineFields
	"Define the fields of the EMRCREATEPALETTE structure.

	EMRCREATEPALETTE  compileDefinition

		typedef [uuid(B8739ED2-DE47-467F-AA8D-3A62F4C00509)]
		struct tagEMRCREATEPALETTE {
			EMR EMR;
			[helpstring('Palette handle index')] DWORD ihPal;
			[helpstring('The peFlags fields in the palette entries do not contain any flags')] LOGPALETTE lgpl;
		} EMRCREATEPALETTE;
"

	super defineFields.
	self
		defineField: #ihPal
			type: DWORDField new
			offset: 8;
		defineField: #lgpl
			type: (StructureField type: LOGPALETTE)
			offset: 12.
	self byteSize: 20!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_CREATEPALETTE! !
!EMRCREATEPALETTE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRCREATEPALETTE class categoriesFor: #iTypes!constants!public! !

