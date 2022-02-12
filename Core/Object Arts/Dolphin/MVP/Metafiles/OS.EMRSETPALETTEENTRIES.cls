"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRSETPALETTEENTRIES'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRSETPALETTEENTRIES_Size' -> 16r18.
		'_OffsetOf_aPalEntries' -> 16r14.
		'_OffsetOf_cEntries' -> 16r10.
		'_OffsetOf_ihPal' -> 16r8.
		'_OffsetOf_iStart' -> 16rC
	}!
OS.EMRSETPALETTEENTRIES guid: (Core.GUID fromString: '{e7bfc219-37e0-4690-bf26-61e47ef6ccfb}')!
OS.EMRSETPALETTEENTRIES comment: '<EMRSETPALETTEENTRIES> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETPALETTEENTRIES'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRSETPALETTEENTRIES categoriesForClass!Win32-Structs! !
!OS.EMRSETPALETTEENTRIES methodsFor!

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
!OS.EMRSETPALETTEENTRIES categoriesForMethods!
aPalEntries!**compiled accessors**!public! !
aPalEntries:!**compiled accessors**!public! !
cEntries!**compiled accessors**!public! !
cEntries:!**compiled accessors**!public! !
ihPal!**compiled accessors**!public! !
ihPal:!**compiled accessors**!public! !
iStart!**compiled accessors**!public! !
iStart:!**compiled accessors**!public! !
!

!OS.EMRSETPALETTEENTRIES class methodsFor!

byteSize
	^_EMRSETPALETTEENTRIES_Size!

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
!OS.EMRSETPALETTEENTRIES class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

