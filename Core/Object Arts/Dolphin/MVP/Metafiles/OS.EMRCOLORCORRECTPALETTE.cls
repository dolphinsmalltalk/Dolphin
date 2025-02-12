﻿"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRCOLORCORRECTPALETTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRCOLORCORRECTPALETTE_Size' -> 16r18.
			'_OffsetOf_ihPalette' -> 16r8.
			'_OffsetOf_nFirstEntry' -> 16rC.
			'_OffsetOf_nPalEntries' -> 16r10.
			'_OffsetOf_nReserved' -> 16r14
		}!

OS.EMRCOLORCORRECTPALETTE guid: (Core.GUID fromString: '{b425fd3a-cd17-44a5-972f-7f4d44d06495}')!

OS.EMRCOLORCORRECTPALETTE comment: '<COLORCORRECTPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.COLORCORRECTPALETTE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!OS.EMRCOLORCORRECTPALETTE categoriesForClass!Win32-Structs! !

!OS.EMRCOLORCORRECTPALETTE methodsFor!

ihPalette
	"Answer the <Integer> value of the receiver's 'ihPalette' field."

	^bytes uint32AtOffset: _OffsetOf_ihPalette!

ihPalette: anInteger
	"Set the receiver's 'ihPalette' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ihPalette put: anInteger!

nFirstEntry
	"Answer the <Integer> value of the receiver's 'nFirstEntry' field."

	^bytes uint32AtOffset: _OffsetOf_nFirstEntry!

nFirstEntry: anInteger
	"Set the receiver's 'nFirstEntry' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nFirstEntry put: anInteger!

nPalEntries
	"Answer the <Integer> value of the receiver's 'nPalEntries' field."

	^bytes uint32AtOffset: _OffsetOf_nPalEntries!

nPalEntries: anInteger
	"Set the receiver's 'nPalEntries' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nPalEntries put: anInteger!

nReserved
	"Answer the <Integer> value of the receiver's 'nReserved' field."

	^bytes uint32AtOffset: _OffsetOf_nReserved!

nReserved: anInteger
	"Set the receiver's 'nReserved' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nReserved put: anInteger! !

!OS.EMRCOLORCORRECTPALETTE categoriesForMethods!
ihPalette!**compiled accessors**!public! !
ihPalette:!**compiled accessors**!public! !
nFirstEntry!**compiled accessors**!public! !
nFirstEntry:!**compiled accessors**!public! !
nPalEntries!**compiled accessors**!public! !
nPalEntries:!**compiled accessors**!public! !
nReserved!**compiled accessors**!public! !
nReserved:!**compiled accessors**!public! !
!

!OS.EMRCOLORCORRECTPALETTE class methodsFor!

byteSize
	^_EMRCOLORCORRECTPALETTE_Size!

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
			type: UInt32Field new
			offset: 8;
		defineField: #nFirstEntry
			type: UInt32Field new
			offset: 12;
		defineField: #nPalEntries
			type: UInt32Field new
			offset: 16;
		defineField: #nReserved
			type: UInt32Field new
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #ihPalette #nFirstEntry #nPalEntries #nReserved)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_COLORCORRECTPALETTE}! !

!OS.EMRCOLORCORRECTPALETTE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

