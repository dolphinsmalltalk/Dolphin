﻿"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSETICMPROFILE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRSETICMPROFILE_Size' -> 16r18.
			'_OffsetOf_cbData' -> 16r10.
			'_OffsetOf_cbName' -> 16rC.
			'_OffsetOf_Data' -> 16r14.
			'_OffsetOf_dwFlags' -> 16r8
		}!

OS.EMRSETICMPROFILE guid: (Core.GUID fromString: '{f0dd9705-d88e-4c84-a38c-d8afd0882dc4}')!

OS.EMRSETICMPROFILE comment: '<EMRSETICMPROFILE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETICMPROFILE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!OS.EMRSETICMPROFILE categoriesForClass!Win32-Structs! !

!OS.EMRSETICMPROFILE methodsFor!

cbData
	"Answer the <Integer> value of the receiver's 'cbData' field."

	^bytes uint32AtOffset: _OffsetOf_cbData!

cbData: anInteger
	"Set the receiver's 'cbData' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbData put: anInteger!

cbName
	"Answer the <Integer> value of the receiver's 'cbName' field."

	^bytes uint32AtOffset: _OffsetOf_cbName!

cbName: anInteger
	"Set the receiver's 'cbName' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbName put: anInteger!

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

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwFlags put: anInteger! !

!OS.EMRSETICMPROFILE categoriesForMethods!
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

!OS.EMRSETICMPROFILE class methodsFor!

byteSize
	^_EMRSETICMPROFILE_Size!

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
			type: UInt32Field new
			offset: 8;
		defineField: #cbName
			type: UInt32Field new
			offset: 12;
		defineField: #cbData
			type: UInt32Field new
			offset: 16;
		defineField: #Data
			type: (ArrayField type: ExternalArray lengthField: #dataLength)
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #dwFlags #cbName #cbData #Data)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETICMPROFILEA. EMR_SETICMPROFILEW}! !

!OS.EMRSETICMPROFILE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

