"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCOLORMATCHTOTARGET
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbData _OffsetOf_cbName _OffsetOf_Data _OffsetOf_dwAction _OffsetOf_dwFlags'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCOLORMATCHTOTARGET guid: (GUID fromString: '{8408e62d-3e54-483c-8938-98e099d9d6a2}')!
EMRCOLORMATCHTOTARGET addClassConstant: '_OffsetOf_cbData' value: 16r14!
EMRCOLORMATCHTOTARGET addClassConstant: '_OffsetOf_cbName' value: 16r10!
EMRCOLORMATCHTOTARGET addClassConstant: '_OffsetOf_Data' value: 16r18!
EMRCOLORMATCHTOTARGET addClassConstant: '_OffsetOf_dwAction' value: 16r8!
EMRCOLORMATCHTOTARGET addClassConstant: '_OffsetOf_dwFlags' value: 16rC!
EMRCOLORMATCHTOTARGET comment: '<COLORMATCHTOTARGET> is an <ExternalStructure> class to wrap the struct ''Win32.COLORMATCHTOTARGET'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMRCOLORMATCHTOTARGET categoriesForClass!Win32-Structs! !
!EMRCOLORMATCHTOTARGET methodsFor!

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
	"Answer the number of bytes of data in the Data field."

	^self cbName + self cbData!

dwAction
	"Answer the <Integer> value of the receiver's 'dwAction' field."

	^bytes dwordAtOffset: _OffsetOf_dwAction!

dwAction: anInteger
	"Set the receiver's 'dwAction' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwAction put: anInteger!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger! !
!EMRCOLORMATCHTOTARGET categoriesFor: #cbData!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #cbData:!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #cbName!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #cbName:!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #Data!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #Data:!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #dataLength!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #dwAction!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #dwAction:!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #dwFlags!**compiled accessors**!public! !
!EMRCOLORMATCHTOTARGET categoriesFor: #dwFlags:!**compiled accessors**!public! !

!EMRCOLORMATCHTOTARGET class methodsFor!

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
			type: DWORDField new
			offset: 8;
		defineField: #dwFlags
			type: DWORDField new
			offset: 12;
		defineField: #cbName
			type: DWORDField new
			offset: 16;
		defineField: #cbData
			type: DWORDField new
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
!EMRCOLORMATCHTOTARGET class categoriesFor: #defineFields!public!template definition! !
!EMRCOLORMATCHTOTARGET class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRCOLORMATCHTOTARGET class categoriesFor: #iTypes!constants!public! !

