"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRRESIZEPALETTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cEntries' -> 16rC.
		'_OffsetOf_ihPal' -> 16r8
	}!
OS.EMRRESIZEPALETTE guid: (Core.GUID fromString: '{7a0359ce-039f-4128-a1ed-09dc1fb5e2e5}')!
OS.EMRRESIZEPALETTE comment: '<EMRRESIZEPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRRESIZEPALETTE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRRESIZEPALETTE categoriesForClass!Win32-Structs! !
!OS.EMRRESIZEPALETTE methodsFor!

cEntries
	"Answer the <Integer> value of the receiver's 'cEntries' field."

	^bytes dwordAtOffset: _OffsetOf_cEntries!

cEntries: anInteger
	"Set the receiver's 'cEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cEntries put: anInteger!

ihPal
	"Answer the <Integer> value of the receiver's 'ihPal' field."

	^bytes dwordAtOffset: _OffsetOf_ihPal!

ihPal: anInteger
	"Set the receiver's 'ihPal' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihPal put: anInteger! !
!OS.EMRRESIZEPALETTE categoriesFor: #cEntries!**compiled accessors**!public! !
!OS.EMRRESIZEPALETTE categoriesFor: #cEntries:!**compiled accessors**!public! !
!OS.EMRRESIZEPALETTE categoriesFor: #ihPal!**compiled accessors**!public! !
!OS.EMRRESIZEPALETTE categoriesFor: #ihPal:!**compiled accessors**!public! !

!OS.EMRRESIZEPALETTE class methodsFor!

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

getFieldNames
	^#(#iType #nSize #ihPal #cEntries)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_RESIZEPALETTE}! !
!OS.EMRRESIZEPALETTE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMRRESIZEPALETTE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRRESIZEPALETTE class categoriesFor: #iTypes!constants!public! !

