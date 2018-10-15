"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETICMPROFILE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETICMPROFILE guid: (GUID fromString: '{f0dd9705-d88e-4c84-a38c-d8afd0882dc4}')!
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
	^self cbName + self cbData!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject! !
!EMRSETICMPROFILE categoriesFor: #cbData!**compiled accessors**!public! !
!EMRSETICMPROFILE categoriesFor: #cbData:!**compiled accessors**!public! !
!EMRSETICMPROFILE categoriesFor: #cbName!**compiled accessors**!public! !
!EMRSETICMPROFILE categoriesFor: #cbName:!**compiled accessors**!public! !
!EMRSETICMPROFILE categoriesFor: #Data!**compiled accessors**!public! !
!EMRSETICMPROFILE categoriesFor: #Data:!**compiled accessors**!public! !
!EMRSETICMPROFILE categoriesFor: #dataLength!accessing!public! !
!EMRSETICMPROFILE categoriesFor: #dwFlags!**compiled accessors**!public! !
!EMRSETICMPROFILE categoriesFor: #dwFlags:!**compiled accessors**!public! !

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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SETICMPROFILEA with: EMR_SETICMPROFILEW! !
!EMRSETICMPROFILE class categoriesFor: #defineFields!initializing!public! !
!EMRSETICMPROFILE class categoriesFor: #iTypes!constants!public! !

