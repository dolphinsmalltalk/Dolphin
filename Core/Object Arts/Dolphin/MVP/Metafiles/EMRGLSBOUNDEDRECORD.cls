"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRGLSBOUNDEDRECORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRGLSBOUNDEDRECORD guid: (GUID fromString: '{0814602c-a45e-4098-9b9b-833717f75760}')!
EMRGLSBOUNDEDRECORD comment: '<EMRGLSBOUNDEDRECORD> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGLSBOUNDEDRECORD'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(0814602C-A45E-4098-9B9B-833717F75760)]
struct tagEMRGLSBOUNDEDRECORD {
	EMR EMR;
	[helpstring("Bounds in recording coordinates")] RECTL rclBounds;
	[helpstring("Size of data in bytes")] DWORD cbData;
	BYTE* Data;
} EMRGLSBOUNDEDRECORD;
'!
!EMRGLSBOUNDEDRECORD categoriesForClass!Win32-Structs! !
!EMRGLSBOUNDEDRECORD methodsFor!

cbData
	"Answer the <Integer> value of the receiver's 'cbData' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cbData)!

cbData: anInteger
	"Set the receiver's 'cbData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbData) put: anInteger!

Data
	"Answer the <ExternalArray> value of the receiver's 'Data' field."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #Data) length: self cbData!

Data: anExternalArray
	"Set the receiver's 'Data' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize.
	anExternalArray
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Data) + 1)
		to: ##(self offsetOf: #Data) + size
		startingAt: 1.
	self cbData: anExternalArray size!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1! !
!EMRGLSBOUNDEDRECORD categoriesFor: #cbData!**compiled accessors**!public! !
!EMRGLSBOUNDEDRECORD categoriesFor: #cbData:!**compiled accessors**!public! !
!EMRGLSBOUNDEDRECORD categoriesFor: #Data!**compiled accessors**!public! !
!EMRGLSBOUNDEDRECORD categoriesFor: #Data:!**compiled accessors**!public! !
!EMRGLSBOUNDEDRECORD categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRGLSBOUNDEDRECORD categoriesFor: #rclBounds:!**compiled accessors**!public! !

!EMRGLSBOUNDEDRECORD class methodsFor!

defineFields
	"Define the fields of the EMRGLSBOUNDEDRECORD structure.

	EMRGLSBOUNDEDRECORD  compileDefinition

		typedef [uuid(0814602C-A45E-4098-9B9B-833717F75760)]
		struct tagEMRGLSBOUNDEDRECORD {
			EMR EMR;
			[helpstring('Bounds in recording coordinates')] RECTL rclBounds;
			[helpstring('Size of data in bytes')] DWORD cbData;
			BYTE* Data;
		} EMRGLSBOUNDEDRECORD;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #cbData
			type: DWORDField new
			offset: 24;
		defineField: #Data
			type: (ArrayField type: ExternalArray lengthField: #cbData)
			offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#iType #nSize #rclBounds #cbData #Data)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_GLSBOUNDEDRECORD! !
!EMRGLSBOUNDEDRECORD class categoriesFor: #defineFields!initializing!public! !
!EMRGLSBOUNDEDRECORD class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRGLSBOUNDEDRECORD class categoriesFor: #iTypes!constants!public! !

