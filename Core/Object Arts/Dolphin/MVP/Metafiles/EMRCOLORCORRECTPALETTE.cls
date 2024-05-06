"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRCOLORCORRECTPALETTE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_ihPalette _OffsetOf_nFirstEntry _OffsetOf_nPalEntries _OffsetOf_nReserved'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMRCOLORCORRECTPALETTE guid: (GUID fromString: '{b425fd3a-cd17-44a5-972f-7f4d44d06495}')!

EMRCOLORCORRECTPALETTE addClassConstant: '_OffsetOf_ihPalette' value: 16r8!
EMRCOLORCORRECTPALETTE addClassConstant: '_OffsetOf_nFirstEntry' value: 16rC!
EMRCOLORCORRECTPALETTE addClassConstant: '_OffsetOf_nPalEntries' value: 16r10!
EMRCOLORCORRECTPALETTE addClassConstant: '_OffsetOf_nReserved' value: 16r14!

EMRCOLORCORRECTPALETTE comment: '<COLORCORRECTPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.COLORCORRECTPALETTE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagCOLORCORRECTPALETTE {
	EMR EMR;
	[helpstring("Palette handle index")] DWORD ihPalette;
	[helpstring("Index of first entry to correct")] DWORD nFirstEntry;
	[helpstring("Number of palette entries to correct")] DWORD nPalEntries;
	[helpstring("Reserved")] DWORD nReserved;
} COLORCORRECTPALETTE;
'!

!EMRCOLORCORRECTPALETTE categoriesForClass!Win32-Structs! !

!EMRCOLORCORRECTPALETTE methodsFor!

ihPalette
	"Answer the <Integer> value of the receiver's 'ihPalette' field."

	^bytes dwordAtOffset: _OffsetOf_ihPalette!

ihPalette: anInteger
	"Set the receiver's 'ihPalette' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihPalette put: anInteger!

nFirstEntry
	"Answer the <Integer> value of the receiver's 'nFirstEntry' field."

	^bytes dwordAtOffset: _OffsetOf_nFirstEntry!

nFirstEntry: anInteger
	"Set the receiver's 'nFirstEntry' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nFirstEntry put: anInteger!

nPalEntries
	"Answer the <Integer> value of the receiver's 'nPalEntries' field."

	^bytes dwordAtOffset: _OffsetOf_nPalEntries!

nPalEntries: anInteger
	"Set the receiver's 'nPalEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nPalEntries put: anInteger!

nReserved
	"Answer the <Integer> value of the receiver's 'nReserved' field."

	^bytes dwordAtOffset: _OffsetOf_nReserved!

nReserved: anInteger
	"Set the receiver's 'nReserved' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nReserved put: anInteger! !

!EMRCOLORCORRECTPALETTE categoriesForMethods!
ihPalette!**compiled accessors**!public! !
ihPalette:!**compiled accessors**!public! !
nFirstEntry!**compiled accessors**!public! !
nFirstEntry:!**compiled accessors**!public! !
nPalEntries!**compiled accessors**!public! !
nPalEntries:!**compiled accessors**!public! !
nReserved!**compiled accessors**!public! !
nReserved:!**compiled accessors**!public! !
!

!EMRCOLORCORRECTPALETTE class methodsFor!

defineFields
	"Define the fields of the COLORCORRECTPALETTE structure.

	COLORCORRECTPALETTE  compileDefinition

		typedef 
		struct tagCOLORCORRECTPALETTE {
			EMR EMR;
			[helpstring('Palette handle index')] DWORD ihPalette;
			[helpstring('Index of first entry to correct')] DWORD nFirstEntry;
			[helpstring('Number of palette entries to correct')] DWORD nPalEntries;
			[helpstring('Reserved')] DWORD nReserved;
		} COLORCORRECTPALETTE;
"

	super defineFields.
	self
		defineField: #ihPalette
			type: DWORDField new
			offset: 8;
		defineField: #nFirstEntry
			type: DWORDField new
			offset: 12;
		defineField: #nPalEntries
			type: DWORDField new
			offset: 16;
		defineField: #nReserved
			type: DWORDField new
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #ihPalette #nFirstEntry #nPalEntries #nReserved)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_COLORCORRECTPALETTE! !

!EMRCOLORCORRECTPALETTE class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

