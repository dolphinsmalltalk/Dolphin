"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSELECTPALETTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ihPal' -> 16r8
	}!
EMRSELECTPALETTE guid: (GUID fromString: '{2bd77a04-2b0c-4d93-b7b6-a55fbb1003ab}')!
EMRSELECTPALETTE comment: '<EMRSELECTPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSELECTPALETTE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2BD77A04-2B0C-4D93-B7B6-A55FBB1003AB)]
struct tagEMRSELECTPALETTE {
	EMR EMR;
	[helpstring("Palette handle index, background mode only")] DWORD ihPal;
} EMRSELECTPALETTE;
'!
!EMRSELECTPALETTE categoriesForClass!Win32-Structs! !
!EMRSELECTPALETTE methodsFor!

ihPal
	"Answer the <Integer> value of the receiver's 'ihPal' field."

	^bytes dwordAtOffset: _OffsetOf_ihPal!

ihPal: anInteger
	"Set the receiver's 'ihPal' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihPal put: anInteger! !
!EMRSELECTPALETTE categoriesFor: #ihPal!**compiled accessors**!public! !
!EMRSELECTPALETTE categoriesFor: #ihPal:!**compiled accessors**!public! !

!EMRSELECTPALETTE class methodsFor!

defineFields
	"Define the fields of the EMRSELECTPALETTE structure.

	EMRSELECTPALETTE  compileDefinition

		typedef [uuid(2BD77A04-2B0C-4D93-B7B6-A55FBB1003AB)]
		struct tagEMRSELECTPALETTE {
			EMR EMR;
			[helpstring('Palette handle index, background mode only')] DWORD ihPal;
		} EMRSELECTPALETTE;
"

	super defineFields.
	self
		defineField: #ihPal
			type: DWORDField new
			offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #ihPal)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SELECTPALETTE}! !
!EMRSELECTPALETTE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSELECTPALETTE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSELECTPALETTE class categoriesFor: #iTypes!constants!public! !

