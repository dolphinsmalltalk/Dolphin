"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRCREATECOLORSPACEW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRCREATECOLORSPACEW_Size' -> 16r160.
		'_OffsetOf_cbData' -> 16r158.
		'_OffsetOf_Data' -> 16r15C.
		'_OffsetOf_dwFlags' -> 16r154.
		'_OffsetOf_ihCS' -> 16r8.
		'_OffsetOf_lcs' -> 16rC
	}!
OS.EMRCREATECOLORSPACEW guid: (Core.GUID fromString: '{27b16b33-1f59-4046-ae08-0652f9c089f1}')!
OS.EMRCREATECOLORSPACEW comment: '<EMRCREATECOLORSPACEW> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATECOLORSPACEW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(27B16B33-1F59-4046-AE08-0652F9C089F1)]
struct tagEMRCREATECOLORSPACEW {
	EMR EMR;
	[helpstring("ColorSpace handle index")] DWORD ihCS;
	[helpstring("Unicode version of logical color space structure")] LOGCOLORSPACEW lcs;
	[helpstring("flags")] DWORD dwFlags;
	[helpstring("size of raw source profile data if attached")] DWORD cbData;
	[helpstring("Array size is cbData")] BYTE* Data;
} EMRCREATECOLORSPACEW;
'!
!OS.EMRCREATECOLORSPACEW categoriesForClass!Win32-Structs! !
!OS.EMRCREATECOLORSPACEW methodsFor!

cbData
	"Answer the <Integer> value of the receiver's 'cbData' field."

	^bytes dwordAtOffset: _OffsetOf_cbData!

cbData: anInteger
	"Set the receiver's 'cbData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbData put: anInteger!

Data
	"Answer the <ExternalArray> value of the receiver's 'Data' field."

	^ExternalArray fromAddress: bytes yourAddress + _OffsetOf_Data length: self cbData!

Data: anExternalArray
	"Set the receiver's 'Data' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize.
	anExternalArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Data + 1)
		to: _OffsetOf_Data + size
		startingAt: 1.
	self cbData: anExternalArray size!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger!

ihCS
	"Answer the <Integer> value of the receiver's 'ihCS' field."

	^bytes dwordAtOffset: _OffsetOf_ihCS!

ihCS: anInteger
	"Set the receiver's 'ihCS' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihCS put: anInteger!

lcs
	"Answer the <LOGCOLORSPACEW> value of the receiver's 'lcs' field."

	^LOGCOLORSPACEW fromAddress: bytes yourAddress + _OffsetOf_lcs!

lcs: aLOGCOLORSPACEW
	"Set the receiver's 'lcs' field to the value of the argument, aLOGCOLORSPACEW"

	aLOGCOLORSPACEW
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lcs + 1)
		to: ##(_OffsetOf_lcs + LOGCOLORSPACEW._LOGCOLORSPACEW_Size)
		startingAt: 1! !
!OS.EMRCREATECOLORSPACEW categoriesForMethods!
cbData!**compiled accessors**!public! !
cbData:!**compiled accessors**!public! !
Data!**compiled accessors**!public! !
Data:!**compiled accessors**!public! !
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
ihCS!**compiled accessors**!public! !
ihCS:!**compiled accessors**!public! !
lcs!**compiled accessors**!public! !
lcs:!**compiled accessors**!public! !
!

!OS.EMRCREATECOLORSPACEW class methodsFor!

byteSize
	^_EMRCREATECOLORSPACEW_Size!

defineFields
	"Define the fields of the EMRCREATECOLORSPACEW structure.

	EMRCREATECOLORSPACEW  compileDefinition

		typedef [uuid(27B16B33-1F59-4046-AE08-0652F9C089F1)]
		struct tagEMRCREATECOLORSPACEW {
			EMR EMR;
			[helpstring('ColorSpace handle index')] DWORD ihCS;
			[helpstring('Unicode version of logical color space structure')] LOGCOLORSPACEW lcs;
			[helpstring('flags')] DWORD dwFlags;
			[helpstring('size of raw source profile data if attached')] DWORD cbData;
			[size_is(cbData)] BYTE Data[];
		} EMRCREATECOLORSPACEW;
"

	super defineFields.
	self
		defineField: #ihCS
			type: DWORDField new
			offset: 8;
		defineField: #lcs
			type: (StructureField type: LOGCOLORSPACEW)
			offset: 12;
		defineField: #dwFlags
			type: DWORDField new
			offset: 340;
		defineField: #cbData
			type: DWORDField new
			offset: 344;
		defineField: #Data
			type: (ArrayField type: ExternalArray lengthField: #cbData)
			offset: 348!

getFieldNames
	^#(#iType #nSize #ihCS #lcs #dwFlags #cbData #Data)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_CREATECOLORSPACEW}! !
!OS.EMRCREATECOLORSPACEW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

