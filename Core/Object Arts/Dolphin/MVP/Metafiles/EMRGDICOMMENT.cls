"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRGDICOMMENT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbData _OffsetOf_Data'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMRGDICOMMENT guid: (GUID fromString: '{5b2c2616-4205-49f8-86dc-fa73c7092f5b}')!

EMRGDICOMMENT addClassConstant: '_OffsetOf_cbData' value: 16r8!
EMRGDICOMMENT addClassConstant: '_OffsetOf_Data' value: 16rC!

EMRGDICOMMENT comment: '<EMRGDICOMMENT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGDICOMMENT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(5B2C2616-4205-49F8-86DC-FA73C7092F5B)]
struct tagEMRGDICOMMENT {
	EMR EMR;
	[helpstring("Size of data in bytes")] DWORD cbData;
	BYTE* Data;
} EMRGDICOMMENT;
'!

!EMRGDICOMMENT categoriesForClass!Win32-Structs! !

!EMRGDICOMMENT methodsFor!

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
	self cbData: anExternalArray size! !

!EMRGDICOMMENT categoriesForMethods!
cbData!**compiled accessors**!public! !
cbData:!**compiled accessors**!public! !
Data!**compiled accessors**!public! !
Data:!**compiled accessors**!public! !
!

!EMRGDICOMMENT class methodsFor!

defineFields
	"Define the fields of the EMRGDICOMMENT structure.

	EMRGDICOMMENT  compileDefinition

		typedef [uuid(5B2C2616-4205-49F8-86DC-FA73C7092F5B)]
		struct tagEMRGDICOMMENT {
			EMR EMR;
			[helpstring('Size of data in bytes')] DWORD cbData;
			BYTE Data[];
		} EMRGDICOMMENT;
"

	super defineFields.
	self
		defineField: #cbData
			type: DWORDField new
			offset: 8;
		defineField: #Data
			type: (ArrayField type: ExternalArray lengthField: #cbData)
			offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#iType #nSize #cbData #Data)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_GDICOMMENT! !

!EMRGDICOMMENT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

