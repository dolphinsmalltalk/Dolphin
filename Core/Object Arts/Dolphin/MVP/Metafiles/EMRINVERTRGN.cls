"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRINVERTRGN
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbRgnData _OffsetOf_rclBounds _OffsetOf_RGNDATA'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRINVERTRGN guid: (GUID fromString: '{a68394ef-a64a-4b77-b81a-36b71800d05f}')!
EMRINVERTRGN addClassConstant: '_OffsetOf_cbRgnData' value: 16r18!
EMRINVERTRGN addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
EMRINVERTRGN addClassConstant: '_OffsetOf_RGNDATA' value: 16r1C!
EMRINVERTRGN comment: '<EMRINVERTRGN> is an <ExternalStructure> class to wrap the struct ''Win32.EMRINVERTRGN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A68394EF-A64A-4B77-B81A-36B71800D05F)]
struct tagEMRINVERTRGN {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Size of region data in bytes")] DWORD cbRgnData;
	BYTE* RGNDATA;
} EMRINVERTRGN;
'!
!EMRINVERTRGN categoriesForClass!Win32-Structs! !
!EMRINVERTRGN methodsFor!

cbRgnData
	"Answer the <Integer> value of the receiver's 'cbRgnData' field."

	^bytes dwordAtOffset: _OffsetOf_cbRgnData!

cbRgnData: anInteger
	"Set the receiver's 'cbRgnData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbRgnData put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
		startingAt: 1!

RGNDATA
	"Answer the <ExternalArray> value of the receiver's 'RGNDATA' field."

	^ExternalArray fromAddress: bytes yourAddress + _OffsetOf_RGNDATA length: self cbRgnData!

RGNDATA: anExternalArray
	"Set the receiver's 'RGNDATA' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize.
	anExternalArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_RGNDATA + 1)
		to: _OffsetOf_RGNDATA + size
		startingAt: 1.
	self cbRgnData: anExternalArray size! !
!EMRINVERTRGN categoriesForMethods!
cbRgnData!**compiled accessors**!public! !
cbRgnData:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
RGNDATA!**compiled accessors**!public! !
RGNDATA:!**compiled accessors**!public! !
!

!EMRINVERTRGN class methodsFor!

defineFields
	"Define the fields of the EMRINVERTRGN structure.

	EMRINVERTRGN  compileDefinition

		typedef [uuid(A68394EF-A64A-4B77-B81A-36B71800D05F)]
		struct tagEMRINVERTRGN {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Size of region data in bytes')] DWORD cbRgnData;
			[size_is(cbRgnData)]BYTE RGNDATA[];
		} EMRINVERTRGN;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #cbRgnData
			type: DWORDField new
			offset: 24;
		defineField: #RGNDATA
			type: (ArrayField type: ExternalArray lengthField: #cbRgnData)
			offset: 28!

getFieldNames
	^#(#iType #nSize #rclBounds #cbRgnData #RGNDATA)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_INVERTRGN with: EMR_PAINTRGN! !
!EMRINVERTRGN class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

