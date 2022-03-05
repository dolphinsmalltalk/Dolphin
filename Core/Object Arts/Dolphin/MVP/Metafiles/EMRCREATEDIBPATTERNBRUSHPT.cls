"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRCREATEDIBPATTERNBRUSHPT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbBits _OffsetOf_cbBmi _OffsetOf_ihBrush _OffsetOf_iUsage _OffsetOf_offBits _OffsetOf_offBmi'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCREATEDIBPATTERNBRUSHPT guid: (GUID fromString: '{ae1203b9-a6b7-4cca-8fc6-408d43a80c8c}')!
EMRCREATEDIBPATTERNBRUSHPT addClassConstant: '_OffsetOf_cbBits' value: 16r1C!
EMRCREATEDIBPATTERNBRUSHPT addClassConstant: '_OffsetOf_cbBmi' value: 16r14!
EMRCREATEDIBPATTERNBRUSHPT addClassConstant: '_OffsetOf_ihBrush' value: 16r8!
EMRCREATEDIBPATTERNBRUSHPT addClassConstant: '_OffsetOf_iUsage' value: 16rC!
EMRCREATEDIBPATTERNBRUSHPT addClassConstant: '_OffsetOf_offBits' value: 16r18!
EMRCREATEDIBPATTERNBRUSHPT addClassConstant: '_OffsetOf_offBmi' value: 16r10!
EMRCREATEDIBPATTERNBRUSHPT comment: '<EMRCREATEDIBPATTERNBRUSHPT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEDIBPATTERNBRUSHPT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(AE1203B9-A6B7-4CCA-8FC6-408D43A80C8C)]
struct tagEMRCREATEDIBPATTERNBRUSHPT {
	EMR EMR;
	[helpstring("Brush handle index")] DWORD ihBrush;
	[helpstring("Bitmap info color table usage")] DWORD iUsage;
	[helpstring("Offset to the BITMAPINFO structure")] DWORD offBmi;
	[helpstring("Size of the BITMAPINFO structure")] DWORD cbBmi;
	[helpstring("Offset to the bitmap bits")] DWORD offBits;
	[helpstring("Size of the bitmap bits")] DWORD cbBits;
} EMRCREATEDIBPATTERNBRUSHPT;
'!
!EMRCREATEDIBPATTERNBRUSHPT categoriesForClass!Win32-Structs! !
!EMRCREATEDIBPATTERNBRUSHPT methodsFor!

cbBits
	"Answer the <Integer> value of the receiver's 'cbBits' field."

	^bytes dwordAtOffset: _OffsetOf_cbBits!

cbBits: anInteger
	"Set the receiver's 'cbBits' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBits put: anInteger!

cbBmi
	"Answer the <Integer> value of the receiver's 'cbBmi' field."

	^bytes dwordAtOffset: _OffsetOf_cbBmi!

cbBmi: anInteger
	"Set the receiver's 'cbBmi' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBmi put: anInteger!

ihBrush
	"Answer the <Integer> value of the receiver's 'ihBrush' field."

	^bytes dwordAtOffset: _OffsetOf_ihBrush!

ihBrush: anInteger
	"Set the receiver's 'ihBrush' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihBrush put: anInteger!

iUsage
	"Answer the <Integer> value of the receiver's 'iUsage' field."

	^bytes dwordAtOffset: _OffsetOf_iUsage!

iUsage: anInteger
	"Set the receiver's 'iUsage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iUsage put: anInteger!

offBits
	"Answer the <Integer> value of the receiver's 'offBits' field."

	^bytes dwordAtOffset: _OffsetOf_offBits!

offBits: anInteger
	"Set the receiver's 'offBits' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBits put: anInteger!

offBmi
	"Answer the <Integer> value of the receiver's 'offBmi' field."

	^bytes dwordAtOffset: _OffsetOf_offBmi!

offBmi: anInteger
	"Set the receiver's 'offBmi' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBmi put: anInteger! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesForMethods!
cbBits!**compiled accessors**!public! !
cbBits:!**compiled accessors**!public! !
cbBmi!**compiled accessors**!public! !
cbBmi:!**compiled accessors**!public! !
ihBrush!**compiled accessors**!public! !
ihBrush:!**compiled accessors**!public! !
iUsage!**compiled accessors**!public! !
iUsage:!**compiled accessors**!public! !
offBits!**compiled accessors**!public! !
offBits:!**compiled accessors**!public! !
offBmi!**compiled accessors**!public! !
offBmi:!**compiled accessors**!public! !
!

!EMRCREATEDIBPATTERNBRUSHPT class methodsFor!

defineFields
	"Define the fields of the EMRCREATEDIBPATTERNBRUSHPT structure.

	EMRCREATEDIBPATTERNBRUSHPT  compileDefinition

		typedef [uuid(AE1203B9-A6B7-4CCA-8FC6-408D43A80C8C)]
		struct tagEMRCREATEDIBPATTERNBRUSHPT {
			EMR EMR;
			[helpstring('Brush handle index')] DWORD ihBrush;
			[helpstring('Bitmap info color table usage')] DWORD iUsage;
			[helpstring('Offset to the BITMAPINFO structure')] DWORD offBmi;
			[helpstring('Size of the BITMAPINFO structure')] DWORD cbBmi;
			[helpstring('Offset to the bitmap bits')] DWORD offBits;
			[helpstring('Size of the bitmap bits')] DWORD cbBits;
		} EMRCREATEDIBPATTERNBRUSHPT;
"

	super defineFields.
	self
		defineField: #ihBrush type: DWORDField new offset: 8;
		defineField: #iUsage type: DWORDField new offset: 12;
		defineField: #offBmi type: DWORDField new offset: 16;
		defineField: #cbBmi type: DWORDField new offset: 20;
		defineField: #offBits type: DWORDField new offset: 24;
		defineField: #cbBits type: DWORDField new offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#iType #nSize #ihBrush #iUsage #offBmi #cbBmi #offBits #cbBits)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_CREATEDIBPATTERNBRUSHPT! !
!EMRCREATEDIBPATTERNBRUSHPT class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

