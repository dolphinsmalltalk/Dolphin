"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRCREATEMONOBRUSH
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbBits _OffsetOf_cbBmi _OffsetOf_ihBrush _OffsetOf_iUsage _OffsetOf_offBits _OffsetOf_offBmi'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCREATEMONOBRUSH guid: (GUID fromString: '{93fa5260-561a-45ad-93b2-64f1c310bc26}')!
EMRCREATEMONOBRUSH addClassConstant: '_OffsetOf_cbBits' value: 16r1C!
EMRCREATEMONOBRUSH addClassConstant: '_OffsetOf_cbBmi' value: 16r14!
EMRCREATEMONOBRUSH addClassConstant: '_OffsetOf_ihBrush' value: 16r8!
EMRCREATEMONOBRUSH addClassConstant: '_OffsetOf_iUsage' value: 16rC!
EMRCREATEMONOBRUSH addClassConstant: '_OffsetOf_offBits' value: 16r18!
EMRCREATEMONOBRUSH addClassConstant: '_OffsetOf_offBmi' value: 16r10!
EMRCREATEMONOBRUSH comment: '<EMRCREATEMONOBRUSH> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEMONOBRUSH'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(93FA5260-561A-45AD-93B2-64F1C310BC26)]
struct tagEMRCREATEMONOBRUSH {
	EMR EMR;
	[helpstring("Brush handle index")] DWORD ihBrush;
	[helpstring("Bitmap info color table usage")] DWORD iUsage;
	[helpstring("Offset to the BITMAPINFO structure")] DWORD offBmi;
	[helpstring("Size of the BITMAPINFO structure")] DWORD cbBmi;
	[helpstring("Offset to the bitmap bits")] DWORD offBits;
	[helpstring("Size of the bitmap bits")] DWORD cbBits;
} EMRCREATEMONOBRUSH;
'!
!EMRCREATEMONOBRUSH categoriesForClass!Win32-Structs! !
!EMRCREATEMONOBRUSH methodsFor!

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
!EMRCREATEMONOBRUSH categoriesForMethods!
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

!EMRCREATEMONOBRUSH class methodsFor!

defineFields
	"Define the fields of the EMRCREATEMONOBRUSH structure.

	EMRCREATEMONOBRUSH  compileDefinition

		typedef [uuid(93FA5260-561A-45AD-93B2-64F1C310BC26)]
		struct tagEMRCREATEMONOBRUSH {
			EMR EMR;
			[helpstring('Brush handle index')] DWORD ihBrush;
			[helpstring('Bitmap info color table usage')] DWORD iUsage;
			[helpstring('Offset to the BITMAPINFO structure')] DWORD offBmi;
			[helpstring('Size of the BITMAPINFO structure')] DWORD cbBmi;
			[helpstring('Offset to the bitmap bits')] DWORD offBits;
			[helpstring('Size of the bitmap bits')] DWORD cbBits;
		} EMRCREATEMONOBRUSH;
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

	^Array with: EMR_CREATEMONOBRUSH! !
!EMRCREATEMONOBRUSH class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

