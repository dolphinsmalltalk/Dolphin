"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRRESIZEPALETTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRRESIZEPALETTE guid: (GUID fromString: '{7a0359ce-039f-4128-a1ed-09dc1fb5e2e5}')!
EMRRESIZEPALETTE comment: '<EMRRESIZEPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRRESIZEPALETTE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7A0359CE-039F-4128-A1ED-09DC1FB5E2E5)]
struct tagEMRRESIZEPALETTE {
	EMR EMR;
	[helpstring("Palette handle index")] DWORD ihPal;
	DWORD cEntries;
} EMRRESIZEPALETTE;
'!
!EMRRESIZEPALETTE categoriesForClass!Win32-Structs! !
!EMRRESIZEPALETTE methodsFor!

cEntries
	"Answer the receiver's cEntries field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cEntries)!

cEntries: anObject 
	"Set the receiver's cEntries field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cEntries) put: anObject!

ihPal
	"Answer the receiver's ihPal field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihPal)!

ihPal: anObject 
	"Set the receiver's ihPal field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihPal) put: anObject! !
!EMRRESIZEPALETTE categoriesFor: #cEntries!**compiled accessors**!public! !
!EMRRESIZEPALETTE categoriesFor: #cEntries:!**compiled accessors**!public! !
!EMRRESIZEPALETTE categoriesFor: #ihPal!**compiled accessors**!public! !
!EMRRESIZEPALETTE categoriesFor: #ihPal:!**compiled accessors**!public! !

!EMRRESIZEPALETTE class methodsFor!

defineFields
	"Define the fields of the EMRRESIZEPALETTE structure.

	EMRRESIZEPALETTE  compileDefinition

		typedef [uuid(7A0359CE-039F-4128-A1ED-09DC1FB5E2E5)]
		struct tagEMRRESIZEPALETTE {
			EMR EMR;
			[helpstring('Palette handle index')] DWORD ihPal;
			DWORD cEntries;
		} EMRRESIZEPALETTE;
"

	super defineFields.
	self
		defineField: #ihPal
			type: DWORDField new
			offset: 8;
		defineField: #cEntries
			type: DWORDField new
			offset: 12.
	self byteSize: 16!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_RESIZEPALETTE! !
!EMRRESIZEPALETTE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRRESIZEPALETTE class categoriesFor: #iTypes!constants!public! !

