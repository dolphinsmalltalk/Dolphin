"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCOLORCORRECTPALETTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCOLORCORRECTPALETTE guid: (GUID fromString: '{b425fd3a-cd17-44a5-972f-7f4d44d06495}')!
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

	^bytes dwordAtOffset: ##(self offsetOf: #ihPalette)!

ihPalette: anInteger
	"Set the receiver's 'ihPalette' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #ihPalette) put: anInteger!

nFirstEntry
	"Answer the <Integer> value of the receiver's 'nFirstEntry' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nFirstEntry)!

nFirstEntry: anInteger
	"Set the receiver's 'nFirstEntry' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nFirstEntry) put: anInteger!

nPalEntries
	"Answer the <Integer> value of the receiver's 'nPalEntries' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nPalEntries)!

nPalEntries: anInteger
	"Set the receiver's 'nPalEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nPalEntries) put: anInteger!

nReserved
	"Answer the <Integer> value of the receiver's 'nReserved' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nReserved)!

nReserved: anInteger
	"Set the receiver's 'nReserved' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nReserved) put: anInteger! !
!EMRCOLORCORRECTPALETTE categoriesFor: #ihPalette!**compiled accessors**!public! !
!EMRCOLORCORRECTPALETTE categoriesFor: #ihPalette:!**compiled accessors**!public! !
!EMRCOLORCORRECTPALETTE categoriesFor: #nFirstEntry!**compiled accessors**!public! !
!EMRCOLORCORRECTPALETTE categoriesFor: #nFirstEntry:!**compiled accessors**!public! !
!EMRCOLORCORRECTPALETTE categoriesFor: #nPalEntries!**compiled accessors**!public! !
!EMRCOLORCORRECTPALETTE categoriesFor: #nPalEntries:!**compiled accessors**!public! !
!EMRCOLORCORRECTPALETTE categoriesFor: #nReserved!**compiled accessors**!public! !
!EMRCOLORCORRECTPALETTE categoriesFor: #nReserved:!**compiled accessors**!public! !

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
!EMRCOLORCORRECTPALETTE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRCOLORCORRECTPALETTE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRCOLORCORRECTPALETTE class categoriesFor: #iTypes!constants!public! !

