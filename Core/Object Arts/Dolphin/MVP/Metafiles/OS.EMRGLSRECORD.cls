"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRGLSRECORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cbData' -> 16r8.
		'_OffsetOf_Data' -> 16rC
	}!
OS.EMRGLSRECORD guid: (Core.GUID fromString: '{d78026c9-e670-487f-ac4b-de420ffcc257}')!
OS.EMRGLSRECORD comment: '<EMRGLSRECORD> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGLSRECORD'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRGLSRECORD categoriesForClass!Win32-Structs! !
!OS.EMRGLSRECORD methodsFor!

cbData
	"Answer the <Integer> value of the receiver's 'cbData' field."

	^bytes dwordAtOffset: _OffsetOf_cbData!

cbData: anInteger
	"Set the receiver's 'cbData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbData put: anInteger!

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
	self cbData: anExternalArray size! !
!OS.EMRGLSRECORD categoriesFor: #cbData!**compiled accessors**!public! !
!OS.EMRGLSRECORD categoriesFor: #cbData:!**compiled accessors**!public! !
!OS.EMRGLSRECORD categoriesFor: #Data!**compiled accessors**!public! !
!OS.EMRGLSRECORD categoriesFor: #Data:!**compiled accessors**!public! !

!OS.EMRGLSRECORD class methodsFor!

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
			type: (ArrayField type: ExternalArray lengthField: #cbData)
			offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#iType #nSize #cbData #Data)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_GLSRECORD}! !
!OS.EMRGLSRECORD class categoriesFor: #defineFields!public!template definition! !
!OS.EMRGLSRECORD class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRGLSRECORD class categoriesFor: #iTypes!constants!public! !

