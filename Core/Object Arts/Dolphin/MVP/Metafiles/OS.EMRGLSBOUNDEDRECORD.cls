"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRGLSBOUNDEDRECORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRGLSBOUNDEDRECORD_Size' -> 16r20.
		'_OffsetOf_cbData' -> 16r18.
		'_OffsetOf_Data' -> 16r1C.
		'_OffsetOf_rclBounds' -> 16r8
	}!
OS.EMRGLSBOUNDEDRECORD guid: (Core.GUID fromString: '{0814602c-a45e-4098-9b9b-833717f75760}')!
OS.EMRGLSBOUNDEDRECORD comment: '<EMRGLSBOUNDEDRECORD> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGLSBOUNDEDRECORD'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRGLSBOUNDEDRECORD categoriesForClass!Win32-Structs! !
!OS.EMRGLSBOUNDEDRECORD methodsFor!

cbData
	"Answer the <Integer> value of the receiver's 'cbData' field."

	^bytes uint32AtOffset: _OffsetOf_cbData!

cbData: anInteger
	"Set the receiver's 'cbData' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbData put: anInteger!

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
	self cbData: anExternalArray size!

rclBounds
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECTL
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL._RECTL_Size)
		startingAt: 1! !
!OS.EMRGLSBOUNDEDRECORD categoriesForMethods!
cbData!**compiled accessors**!public! !
cbData:!**compiled accessors**!public! !
Data!**compiled accessors**!public! !
Data:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

!OS.EMRGLSBOUNDEDRECORD class methodsFor!

byteSize
	^_EMRGLSBOUNDEDRECORD_Size!

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
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #cbData
			type: UInt32Field new
			offset: 24;
		defineField: #Data
			type: (ArrayField type: ExternalArray lengthField: #cbData)
			offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#iType #nSize #rclBounds #cbData #Data)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_GLSBOUNDEDRECORD}! !
!OS.EMRGLSBOUNDEDRECORD class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

