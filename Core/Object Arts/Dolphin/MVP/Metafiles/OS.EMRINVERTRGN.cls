"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRINVERTRGN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRINVERTRGN_Size' -> 16r20.
			'_OffsetOf_cbRgnData' -> 16r18.
			'_OffsetOf_rclBounds' -> 16r8.
			'_OffsetOf_RGNDATA' -> 16r1C
		}!

OS.EMRINVERTRGN guid: (Core.GUID fromString: '{a68394ef-a64a-4b77-b81a-36b71800d05f}')!

OS.EMRINVERTRGN comment: '<EMRINVERTRGN> is an <ExternalStructure> class to wrap the struct ''Win32.EMRINVERTRGN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!OS.EMRINVERTRGN categoriesForClass!Win32-Structs! !

!OS.EMRINVERTRGN methodsFor!

cbRgnData
	"Answer the <Integer> value of the receiver's 'cbRgnData' field."

	^bytes uint32AtOffset: _OffsetOf_cbRgnData!

cbRgnData: anInteger
	"Set the receiver's 'cbRgnData' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbRgnData put: anInteger!

rclBounds
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECTL
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL._RECTL_Size)
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

!OS.EMRINVERTRGN categoriesForMethods!
cbRgnData!**compiled accessors**!public! !
cbRgnData:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
RGNDATA!**compiled accessors**!public! !
RGNDATA:!**compiled accessors**!public! !
!

!OS.EMRINVERTRGN class methodsFor!

byteSize
	^_EMRINVERTRGN_Size!

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
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #cbRgnData
			type: UInt32Field new
			offset: 24;
		defineField: #RGNDATA
			type: (ArrayField type: ExternalArray lengthField: #cbRgnData)
			offset: 28!

getFieldNames
	^#(#iType #nSize #rclBounds #cbRgnData #RGNDATA)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_INVERTRGN. EMR_PAINTRGN}! !

!OS.EMRINVERTRGN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

