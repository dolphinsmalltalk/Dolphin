"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETPALETTEENTRIES
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_aPalEntries' -> 16r14.
		'_OffsetOf_cEntries' -> 16r10.
		'_OffsetOf_ihPal' -> 16r8.
		'_OffsetOf_iStart' -> 16rC
	}!
EMRSETPALETTEENTRIES guid: (GUID fromString: '{e7bfc219-37e0-4690-bf26-61e47ef6ccfb}')!
EMRSETPALETTEENTRIES comment: '<EMRSETPALETTEENTRIES> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETPALETTEENTRIES'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(E7BFC219-37E0-4690-BF26-61E47EF6CCFB)]
struct tagEMRSETPALETTEENTRIES {
	EMR EMR;
	[helpstring("Palette handle index")] DWORD ihPal;
	DWORD iStart;
	DWORD cEntries;
	PALETTEENTRY* aPalEntries;
} EMRSETPALETTEENTRIES;
'!
!EMRSETPALETTEENTRIES categoriesForClass!Win32-Structs! !
!EMRSETPALETTEENTRIES methodsFor!

aPalEntries
	"Answer the <StructureArray> value of the receiver's 'aPalEntries' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_aPalEntries
		length: self cEntries
		elementClass: PALETTEENTRY!

aPalEntries: aStructureArrayOfPALETTEENTRY
	"Set the receiver's 'aPalEntries' field to the value of the argument, aStructureArrayOfPALETTEENTRY"

	| size |
	size := aStructureArrayOfPALETTEENTRY byteSize.
	aStructureArrayOfPALETTEENTRY
		replaceBytesOf: bytes
		from: ##(_OffsetOf_aPalEntries + 1)
		to: _OffsetOf_aPalEntries + size
		startingAt: 1.
	self cEntries: aStructureArrayOfPALETTEENTRY size!

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

	bytes dwordAtOffset: _OffsetOf_ihPal put: anInteger!

iStart
	"Answer the <Integer> value of the receiver's 'iStart' field."

	^bytes dwordAtOffset: _OffsetOf_iStart!

iStart: anInteger
	"Set the receiver's 'iStart' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iStart put: anInteger! !
!EMRSETPALETTEENTRIES categoriesFor: #aPalEntries!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #aPalEntries:!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #cEntries!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #cEntries:!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #ihPal!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #ihPal:!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #iStart!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #iStart:!**compiled accessors**!public! !

!EMRSETPALETTEENTRIES class methodsFor!

defineFields
	"Define the fields of the EMRSETPALETTEENTRIES structure.

	EMRSETPALETTEENTRIES  compileDefinition

		typedef [uuid(E7BFC219-37E0-4690-BF26-61E47EF6CCFB)]
		struct tagEMRSETPALETTEENTRIES {
			EMR EMR;
			[helpstring('Palette handle index')] DWORD ihPal;
			DWORD iStart;
			DWORD cEntries;
			PALETTEENTRY* aPalEntries;
		} EMRSETPALETTEENTRIES;
"

	super defineFields.
	self
		defineField: #ihPal
			type: DWORDField new
			offset: 8;
		defineField: #iStart
			type: DWORDField new
			offset: 12;
		defineField: #cEntries
			type: DWORDField new
			offset: 16;
		defineField: #aPalEntries
			type: (StructureArrayField type: PALETTEENTRY lengthField: #cEntries)
			offset: 20!

getFieldNames
	^#(#iType #nSize #ihPal #iStart #cEntries #aPalEntries)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETPALETTEENTRIES}! !
!EMRSETPALETTEENTRIES class categoriesFor: #defineFields!public!template definition! !
!EMRSETPALETTEENTRIES class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETPALETTEENTRIES class categoriesFor: #iTypes!constants!public! !

