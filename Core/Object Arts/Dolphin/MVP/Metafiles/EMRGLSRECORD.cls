"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRGLSRECORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRGLSRECORD guid: (GUID fromString: '{d78026c9-e670-487f-ac4b-de420ffcc257}')!
EMRGLSRECORD comment: '<EMRGLSRECORD> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGLSRECORD'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(D78026C9-E670-487F-AC4B-DE420FFCC257)]
struct tagEMRGLSRECORD {
	EMR EMR;
	[helpstring("Size of data in bytes")] DWORD cbData;
	BYTE* Data;
} EMRGLSRECORD;
'!
!EMRGLSRECORD categoriesForClass!Win32-Structs! !
!EMRGLSRECORD methodsFor!

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
!EMRGLSRECORD categoriesFor: #cbData!**compiled accessors**!public! !
!EMRGLSRECORD categoriesFor: #cbData:!**compiled accessors**!public! !
!EMRGLSRECORD categoriesFor: #Data!**compiled accessors**!public! !
!EMRGLSRECORD categoriesFor: #Data:!**compiled accessors**!public! !

!EMRGLSRECORD class methodsFor!

defineFields
	"Define the fields of the EMRGLSRECORD structure.

	EMRGLSRECORD  compileDefinition

		typedef [uuid(D78026C9-E670-487F-AC4B-DE420FFCC257)]
		struct tagEMRGLSRECORD {
			EMR EMR;
			[helpstring('Size of data in bytes')] DWORD cbData;
			[size_is(cbData)]BYTE Data[];
		} EMRGLSRECORD;
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

	^Array with: EMR_GLSRECORD! !
!EMRGLSRECORD class categoriesFor: #defineFields!initializing!public! !
!EMRGLSRECORD class categoriesFor: #iTypes!constants!public! !

