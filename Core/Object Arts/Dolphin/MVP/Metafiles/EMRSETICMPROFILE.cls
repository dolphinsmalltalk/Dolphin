"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRSETICMPROFILE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbData _OffsetOf_cbName _OffsetOf_Data _OffsetOf_dwFlags'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETICMPROFILE guid: (GUID fromString: '{f0dd9705-d88e-4c84-a38c-d8afd0882dc4}')!
EMRSETICMPROFILE addClassConstant: '_OffsetOf_cbData' value: 16r10!
EMRSETICMPROFILE addClassConstant: '_OffsetOf_cbName' value: 16rC!
EMRSETICMPROFILE addClassConstant: '_OffsetOf_Data' value: 16r14!
EMRSETICMPROFILE addClassConstant: '_OffsetOf_dwFlags' value: 16r8!
EMRSETICMPROFILE comment: '<EMRSETICMPROFILE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETICMPROFILE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(F0DD9705-D88E-4C84-A38C-D8AFD0882DC4)]
struct tagEMRSETICMPROFILE {
	EMR EMR;
	[helpstring("flags")] DWORD dwFlags;
	[helpstring("Size of desired profile name")] DWORD cbName;
	[helpstring("Size of raw profile data if attached")] DWORD cbData;
	[helpstring("Array size is cbName + cbData")] BYTE Data[1];
} EMRSETICMPROFILE;
'!
!EMRSETICMPROFILE categoriesForClass!Win32-Structs! !
!EMRSETICMPROFILE methodsFor!

cbData
	"Answer the <Integer> value of the receiver's 'cbData' field."

	^bytes dwordAtOffset: _OffsetOf_cbData!

cbData: anInteger
	"Set the receiver's 'cbData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbData put: anInteger!

cbName
	"Answer the <Integer> value of the receiver's 'cbName' field."

	^bytes dwordAtOffset: _OffsetOf_cbName!

cbName: anInteger
	"Set the receiver's 'cbName' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbName put: anInteger!

Data
	"Answer the <ExternalArray> value of the receiver's 'Data' field."

	^ExternalArray fromAddress: bytes yourAddress + _OffsetOf_Data length: self dataLength!

Data: anExternalArray
	"Set the receiver's 'Data' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize.
	anExternalArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Data + 1)
		to: _OffsetOf_Data + size
		startingAt: 1!

dataLength
	^self cbName + self cbData!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger! !
!EMRSETICMPROFILE categoriesForMethods!
cbData!**compiled accessors**!public! !
cbData:!**compiled accessors**!public! !
cbName!**compiled accessors**!public! !
cbName:!**compiled accessors**!public! !
Data!**compiled accessors**!public! !
Data:!**compiled accessors**!public! !
dataLength!accessing!public! !
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
!

!EMRSETICMPROFILE class methodsFor!

defineFields
	"Define the fields of the EMRSETICMPROFILE structure.

	EMRSETICMPROFILE  compileDefinition

		typedef [uuid(F0DD9705-D88E-4C84-A38C-D8AFD0882DC4)]
		struct tagEMRSETICMPROFILE {
			EMR EMR;
			[helpstring('flags')] DWORD dwFlags;
			[helpstring('Size of desired profile name')] DWORD cbName;
			[helpstring('Size of raw profile data if attached')] DWORD cbData;
			[helpstring('Array size is cbName + cbData')] BYTE Data[];
		} EMRSETICMPROFILE;
"

	super defineFields.
	self
		defineField: #dwFlags
			type: DWORDField new
			offset: 8;
		defineField: #cbName
			type: DWORDField new
			offset: 12;
		defineField: #cbData
			type: DWORDField new
			offset: 16;
		defineField: #Data
			type: (ArrayField type: ExternalArray lengthField: #dataLength)
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #dwFlags #cbName #cbData #Data)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SETICMPROFILEA with: EMR_SETICMPROFILEW! !
!EMRSETICMPROFILE class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

