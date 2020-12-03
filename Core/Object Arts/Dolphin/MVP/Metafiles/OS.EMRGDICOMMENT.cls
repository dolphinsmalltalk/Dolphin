"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRGDICOMMENT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cbData' -> 16r8.
		'_OffsetOf_Data' -> 16rC
	}!
OS.EMRGDICOMMENT guid: (Core.GUID fromString: '{5b2c2616-4205-49f8-86dc-fa73c7092f5b}')!
OS.EMRGDICOMMENT comment: '<EMRGDICOMMENT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGDICOMMENT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRGDICOMMENT categoriesForClass!Win32-Structs! !
!OS.EMRGDICOMMENT methodsFor!

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
!OS.EMRGDICOMMENT categoriesFor: #cbData!**compiled accessors**!public! !
!OS.EMRGDICOMMENT categoriesFor: #cbData:!**compiled accessors**!public! !
!OS.EMRGDICOMMENT categoriesFor: #Data!**compiled accessors**!public! !
!OS.EMRGDICOMMENT categoriesFor: #Data:!**compiled accessors**!public! !

!OS.EMRGDICOMMENT class methodsFor!

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

	^{EMR_GDICOMMENT}! !
!OS.EMRGDICOMMENT class categoriesFor: #defineFields!public!template definition! !
!OS.EMRGDICOMMENT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRGDICOMMENT class categoriesFor: #iTypes!constants!public! !

