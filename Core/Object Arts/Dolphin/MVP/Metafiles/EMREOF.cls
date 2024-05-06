"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMREOF
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_nPalEntries _OffsetOf_nSizeLast _OffsetOf_offPalEntries'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMREOF guid: (GUID fromString: '{52606b1b-28c5-4ffa-b16d-13bcf0dd77b0}')!

EMREOF addClassConstant: '_OffsetOf_nPalEntries' value: 16r8!
EMREOF addClassConstant: '_OffsetOf_nSizeLast' value: 16r10!
EMREOF addClassConstant: '_OffsetOf_offPalEntries' value: 16rC!

EMREOF comment: '<EMREOF> is an <ExternalStructure> class to wrap the struct ''Win32.EMREOF'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!EMREOF categoriesForClass!Win32-Structs! !

!EMREOF methodsFor!

nPalEntries
	"Answer the <Integer> value of the receiver's 'nPalEntries' field."

	^bytes dwordAtOffset: _OffsetOf_nPalEntries!

nPalEntries: anInteger
	"Set the receiver's 'nPalEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nPalEntries put: anInteger!

nSizeLast
	"Answer the <Integer> value of the receiver's 'nSizeLast' field."

	^bytes dwordAtOffset: _OffsetOf_nSizeLast!

nSizeLast: anInteger
	"Set the receiver's 'nSizeLast' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nSizeLast put: anInteger!

offPalEntries
	"Answer the <Integer> value of the receiver's 'offPalEntries' field."

	^bytes dwordAtOffset: _OffsetOf_offPalEntries!

offPalEntries: anInteger
	"Set the receiver's 'offPalEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offPalEntries put: anInteger! !

!EMREOF categoriesForMethods!
nPalEntries!**compiled accessors**!public! !
nPalEntries:!**compiled accessors**!public! !
nSizeLast!**compiled accessors**!public! !
nSizeLast:!**compiled accessors**!public! !
offPalEntries!**compiled accessors**!public! !
offPalEntries:!**compiled accessors**!public! !
!

!EMREOF class methodsFor!

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
		defineField: #nPalEntries type: DWORDField new offset: 8;
		defineField: #offPalEntries type: DWORDField new offset: 12;
		defineField: #nSizeLast type: DWORDField new offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#iType #nSize #nPalEntries #offPalEntries #nSizeLast)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_EOF! !

!EMREOF class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

