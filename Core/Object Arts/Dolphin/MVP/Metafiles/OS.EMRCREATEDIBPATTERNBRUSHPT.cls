"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRCREATEDIBPATTERNBRUSHPT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRCREATEDIBPATTERNBRUSHPT_Size' -> 16r20.
		'_OffsetOf_cbBits' -> 16r1C.
		'_OffsetOf_cbBmi' -> 16r14.
		'_OffsetOf_ihBrush' -> 16r8.
		'_OffsetOf_iUsage' -> 16rC.
		'_OffsetOf_offBits' -> 16r18.
		'_OffsetOf_offBmi' -> 16r10
	}!
OS.EMRCREATEDIBPATTERNBRUSHPT guid: (Core.GUID fromString: '{ae1203b9-a6b7-4cca-8fc6-408d43a80c8c}')!
OS.EMRCREATEDIBPATTERNBRUSHPT comment: '<EMRCREATEDIBPATTERNBRUSHPT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEDIBPATTERNBRUSHPT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRCREATEDIBPATTERNBRUSHPT categoriesForClass!Win32-Structs! !
!OS.EMRCREATEDIBPATTERNBRUSHPT methodsFor!

cbBits
	"Answer the <Integer> value of the receiver's 'cbBits' field."

	^bytes uint32AtOffset: _OffsetOf_cbBits!

cbBits: anInteger
	"Set the receiver's 'cbBits' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbBits put: anInteger!

cbBmi
	"Answer the <Integer> value of the receiver's 'cbBmi' field."

	^bytes uint32AtOffset: _OffsetOf_cbBmi!

cbBmi: anInteger
	"Set the receiver's 'cbBmi' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbBmi put: anInteger!

ihBrush
	"Answer the <Integer> value of the receiver's 'ihBrush' field."

	^bytes uint32AtOffset: _OffsetOf_ihBrush!

ihBrush: anInteger
	"Set the receiver's 'ihBrush' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ihBrush put: anInteger!

iUsage
	"Answer the <Integer> value of the receiver's 'iUsage' field."

	^bytes uint32AtOffset: _OffsetOf_iUsage!

iUsage: anInteger
	"Set the receiver's 'iUsage' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iUsage put: anInteger!

offBits
	"Answer the <Integer> value of the receiver's 'offBits' field."

	^bytes uint32AtOffset: _OffsetOf_offBits!

offBits: anInteger
	"Set the receiver's 'offBits' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offBits put: anInteger!

offBmi
	"Answer the <Integer> value of the receiver's 'offBmi' field."

	^bytes uint32AtOffset: _OffsetOf_offBmi!

offBmi: anInteger
	"Set the receiver's 'offBmi' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offBmi put: anInteger! !
!OS.EMRCREATEDIBPATTERNBRUSHPT categoriesForMethods!
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

!OS.EMRCREATEDIBPATTERNBRUSHPT class methodsFor!

byteSize
	^_EMRCREATEDIBPATTERNBRUSHPT_Size!

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
		defineField: #ihBrush
			type: UInt32Field new
			offset: 8;
		defineField: #iUsage
			type: UInt32Field new
			offset: 12;
		defineField: #offBmi
			type: UInt32Field new
			offset: 16;
		defineField: #cbBmi
			type: UInt32Field new
			offset: 20;
		defineField: #offBits
			type: UInt32Field new
			offset: 24;
		defineField: #cbBits
			type: UInt32Field new
			offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#iType #nSize #ihBrush #iUsage #offBmi #cbBmi #offBits #cbBits)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_CREATEDIBPATTERNBRUSHPT}! !
!OS.EMRCREATEDIBPATTERNBRUSHPT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

