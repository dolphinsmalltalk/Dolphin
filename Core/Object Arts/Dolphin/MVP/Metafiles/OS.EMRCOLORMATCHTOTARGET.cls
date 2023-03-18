"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRCOLORMATCHTOTARGET'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRCOLORMATCHTOTARGET_Size' -> 16r1C.
			'_OffsetOf_cbData' -> 16r14.
			'_OffsetOf_cbName' -> 16r10.
			'_OffsetOf_Data' -> 16r18.
			'_OffsetOf_dwAction' -> 16r8.
			'_OffsetOf_dwFlags' -> 16rC
		}!
OS.EMRCOLORMATCHTOTARGET guid: (Core.GUID fromString: '{8408e62d-3e54-483c-8938-98e099d9d6a2}')!
OS.EMRCOLORMATCHTOTARGET comment: '<COLORMATCHTOTARGET> is an <ExternalStructure> class to wrap the struct ''Win32.COLORMATCHTOTARGET'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagCOLORMATCHTOTARGET {
	EMR EMR;
	[helpstring("CS_ENABLE, CS_DISABLE or CS_DELETE_TRANSFORM")] DWORD dwAction;
	[helpstring("flags")] DWORD dwFlags;
	[helpstring("Size of desired target profile name")] DWORD cbName;
	[helpstring("Size of raw target profile data if attached")] DWORD cbData;
	[helpstring("Array size is cbName + cbData")] BYTE Data[1];
} COLORMATCHTOTARGET;
'!
!OS.EMRCOLORMATCHTOTARGET categoriesForClass!Win32-Structs! !
!OS.EMRCOLORMATCHTOTARGET methodsFor!

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
	"Answer the number of bytes of data in the Data field."

	^self cbName + self cbData!

dwAction
	"Answer the <Integer> value of the receiver's 'dwAction' field."

	^bytes uint32AtOffset: _OffsetOf_dwAction!

dwAction: anInteger
	"Set the receiver's 'dwAction' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwAction put: anInteger!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwFlags put: anInteger! !
!OS.EMRCOLORMATCHTOTARGET categoriesForMethods!
cbData!**compiled accessors**!public! !
cbData:!**compiled accessors**!public! !
cbName!**compiled accessors**!public! !
cbName:!**compiled accessors**!public! !
Data!**compiled accessors**!public! !
Data:!**compiled accessors**!public! !
dataLength!public! !
dwAction!**compiled accessors**!public! !
dwAction:!**compiled accessors**!public! !
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
!

!OS.EMRCOLORMATCHTOTARGET class methodsFor!

byteSize
	^_EMRCOLORMATCHTOTARGET_Size!

defineFields
	"Define the fields of the EMRCOLORMATCHTOTARGET structure.

	EMRCOLORMATCHTOTARGET  compileDefinition

		typedef 
		struct tagEMRCOLORMATCHTOTARGET {
			EMR EMR;
			[helpstring('CS_ENABLE, CS_DISABLE or CS_DELETE_TRANSFORM')] DWORD dwAction;
			[helpstring('flags')] DWORD dwFlags;
			[helpstring('Size of desired target profile name')] DWORD cbName;
			[helpstring('Size of raw target profile data if attached')] DWORD cbData;
			[helpstring('Array size is cbName + cbData')] BYTE Data[];
		} EMRCOLORMATCHTOTARGET;
"

	super defineFields.
	self
		defineField: #dwAction
			type: UInt32Field new
			offset: 8;
		defineField: #dwFlags
			type: UInt32Field new
			offset: 12;
		defineField: #cbName
			type: UInt32Field new
			offset: 16;
		defineField: #cbData
			type: UInt32Field new
			offset: 20;
		defineField: #Data
			type: (ArrayField type: ExternalArray lengthField: #dataLength)
			offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#iType #nSize #dwAction #dwFlags #cbName #cbData #Data)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_COLORMATCHTOTARGETW}! !
!OS.EMRCOLORMATCHTOTARGET class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

