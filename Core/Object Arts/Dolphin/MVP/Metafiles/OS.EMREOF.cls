﻿"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMREOF'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMREOF_Size' -> 16r14.
			'_OffsetOf_nPalEntries' -> 16r8.
			'_OffsetOf_nSizeLast' -> 16r10.
			'_OffsetOf_offPalEntries' -> 16rC
		}!

OS.EMREOF guid: (Core.GUID fromString: '{52606b1b-28c5-4ffa-b16d-13bcf0dd77b0}')!

OS.EMREOF comment: '<EMREOF> is an <ExternalStructure> class to wrap the struct ''Win32.EMREOF'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(52606B1B-28C5-4FFA-B16D-13BCF0DD77B0)]
struct tagEMREOF {
	EMR EMR;
	[helpstring("Number of palette entries")] DWORD nPalEntries;
	[helpstring("Offset to the palette entries")] DWORD offPalEntries;
	[helpstring("Same as nSize and must be the last DWORD of the record.  The palette entries, if exist, precede this field.")] DWORD nSizeLast;
} EMREOF;
'!

!OS.EMREOF categoriesForClass!Win32-Structs! !

!OS.EMREOF methodsFor!

nPalEntries
	"Answer the <Integer> value of the receiver's 'nPalEntries' field."

	^bytes uint32AtOffset: _OffsetOf_nPalEntries!

nPalEntries: anInteger
	"Set the receiver's 'nPalEntries' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nPalEntries put: anInteger!

nSizeLast
	"Answer the <Integer> value of the receiver's 'nSizeLast' field."

	^bytes uint32AtOffset: _OffsetOf_nSizeLast!

nSizeLast: anInteger
	"Set the receiver's 'nSizeLast' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nSizeLast put: anInteger!

offPalEntries
	"Answer the <Integer> value of the receiver's 'offPalEntries' field."

	^bytes uint32AtOffset: _OffsetOf_offPalEntries!

offPalEntries: anInteger
	"Set the receiver's 'offPalEntries' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offPalEntries put: anInteger! !

!OS.EMREOF categoriesForMethods!
nPalEntries!**compiled accessors**!public! !
nPalEntries:!**compiled accessors**!public! !
nSizeLast!**compiled accessors**!public! !
nSizeLast:!**compiled accessors**!public! !
offPalEntries!**compiled accessors**!public! !
offPalEntries:!**compiled accessors**!public! !
!

!OS.EMREOF class methodsFor!

byteSize
	^_EMREOF_Size!

defineFields
	"Define the fields of the EMREOF structure.

	EMREOF  compileDefinition

		typedef [uuid(52606B1B-28C5-4FFA-B16D-13BCF0DD77B0)]
		struct tagEMREOF {
			EMR EMR;
			[helpstring('Number of palette entries')] DWORD nPalEntries;
			[helpstring('Offset to the palette entries')] DWORD offPalEntries;
			[helpstring('Same as nSize and must be the last DWORD of the record.  The palette entries, if exist, precede this field.')] DWORD nSizeLast;
		} EMREOF;
"

	super defineFields.
	self
		defineField: #nPalEntries
			type: UInt32Field new
			offset: 8;
		defineField: #offPalEntries
			type: UInt32Field new
			offset: 12;
		defineField: #nSizeLast
			type: UInt32Field new
			offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#iType #nSize #nPalEntries #offPalEntries #nSizeLast)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EOF}! !

!OS.EMREOF class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

