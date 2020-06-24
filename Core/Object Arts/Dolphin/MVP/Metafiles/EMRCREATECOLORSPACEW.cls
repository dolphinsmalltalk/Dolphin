"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCREATECOLORSPACEW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbData _OffsetOf_Data _OffsetOf_dwFlags _OffsetOf_ihCS _OffsetOf_lcs'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCREATECOLORSPACEW guid: (GUID fromString: '{27b16b33-1f59-4046-ae08-0652f9c089f1}')!
EMRCREATECOLORSPACEW addClassConstant: '_OffsetOf_cbData' value: 16r158!
EMRCREATECOLORSPACEW addClassConstant: '_OffsetOf_Data' value: 16r15C!
EMRCREATECOLORSPACEW addClassConstant: '_OffsetOf_dwFlags' value: 16r154!
EMRCREATECOLORSPACEW addClassConstant: '_OffsetOf_ihCS' value: 16r8!
EMRCREATECOLORSPACEW addClassConstant: '_OffsetOf_lcs' value: 16rC!
EMRCREATECOLORSPACEW comment: '<EMRCREATECOLORSPACEW> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATECOLORSPACEW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMRCREATECOLORSPACEW categoriesForClass!Win32-Structs! !
!EMRCREATECOLORSPACEW methodsFor!

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
		to: ##(_OffsetOf_lcs + LOGCOLORSPACEW basicByteSize)
		startingAt: 1! !
!EMRCREATECOLORSPACEW categoriesFor: #cbData!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #cbData:!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #Data!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #Data:!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #dwFlags!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #dwFlags:!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #ihCS!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #ihCS:!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #lcs!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #lcs:!**compiled accessors**!public! !

!EMRCREATECOLORSPACEW class methodsFor!

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
!EMRCREATECOLORSPACEW class categoriesFor: #defineFields!public!template definition! !
!EMRCREATECOLORSPACEW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRCREATECOLORSPACEW class categoriesFor: #iTypes!constants!public! !

