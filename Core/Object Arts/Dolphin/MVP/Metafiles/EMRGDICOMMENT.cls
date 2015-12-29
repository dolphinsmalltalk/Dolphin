"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRGDICOMMENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRGDICOMMENT guid: (GUID fromString: '{5B2C2616-4205-49F8-86DC-FA73C7092F5B}')!
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
	"Answer the receiver's cbData field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbData)!

cbData: anObject 
	"Set the receiver's cbData field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbData) put: anObject!

Data
	"Answer the receiver's Data field as a Smalltalk object."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #Data) length: self cbData!

Data: anObject 
	"Set the receiver's Data field to the value of anObject."

	| size |
	size := anObject byteSize min: self cbData * ##(ExternalArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Data) + 1)
		to: ##(self offsetOf: #Data) + size
		startingAt: 1! !
!EMRGDICOMMENT categoriesFor: #cbData!**compiled accessors**!public! !
!EMRGDICOMMENT categoriesFor: #cbData:!**compiled accessors**!public! !
!EMRGDICOMMENT categoriesFor: #Data!**compiled accessors**!public! !
!EMRGDICOMMENT categoriesFor: #Data:!**compiled accessors**!public! !

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
			type: (ConformantArrayField type: ExternalArray length: #cbData)
			offset: 12.
	self byteSize: 16!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_GDICOMMENT! !
!EMRGDICOMMENT class categoriesFor: #defineFields!initializing!public! !
!EMRGDICOMMENT class categoriesFor: #iTypes!constants!public! !

