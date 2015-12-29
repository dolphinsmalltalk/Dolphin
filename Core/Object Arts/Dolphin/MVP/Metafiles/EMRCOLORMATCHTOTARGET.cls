"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRCOLORMATCHTOTARGET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCOLORMATCHTOTARGET guid: (GUID fromString: '{8408E62D-3E54-483C-8938-98E099D9D6A2}')!
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
	"Answer the receiver's cbData field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbData)!

cbData: anObject 
	"Set the receiver's cbData field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbData) put: anObject!

cbName
	"Answer the receiver's cbName field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbName)!

cbName: anObject 
	"Set the receiver's cbName field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbName) put: anObject!

Data
	"Answer the receiver's Data field as a Smalltalk object."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #Data) length: self dataLength!

Data: anObject 
	"Set the receiver's Data field to the value of anObject."

	| size |
	size := anObject byteSize min: self dataLength * ##(ExternalArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Data) + 1)
		to: ##(self offsetOf: #Data) + size
		startingAt: 1!

dataLength
	"Answer the number of bytes of data in the Data field."

	^self cbName + self cbData!

dwAction
	"Answer the receiver's dwAction field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwAction)!

dwAction: anObject 
	"Set the receiver's dwAction field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwAction) put: anObject!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject! !
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
			type: (ConformantArrayField type: ExternalArray length: #dataLength)
			offset: 24.
	self byteSize: 28!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_COLORMATCHTOTARGETW! !
!EMRCOLORMATCHTOTARGET class categoriesFor: #defineFields!initializing!public! !
!EMRCOLORMATCHTOTARGET class categoriesFor: #iTypes!constants!public! !

