"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRFRAMERGN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRFRAMERGN_Size' -> 16r2C.
			'_OffsetOf_cbRgnData' -> 16r18.
			'_OffsetOf_ihBrush' -> 16r1C.
			'_OffsetOf_rclBounds' -> 16r8.
			'_OffsetOf_RGNDATA' -> 16r28.
			'_OffsetOf_szlStroke' -> 16r20
		}!

OS.EMRFRAMERGN guid: (Core.GUID fromString: '{490fda83-42a6-4848-8a5e-d866c05155e5}')!

OS.EMRFRAMERGN comment: '<EMRFRAMERGN> is an <ExternalStructure> class to wrap the struct ''Win32.EMRFRAMERGN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(490FDA83-42A6-4848-8A5E-D866C05155E5)]
struct tagEMRFRAMERGN {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Size of region data in bytes")] DWORD cbRgnData;
	[helpstring("Brush handle index")] DWORD ihBrush;
	SIZEL szlStroke;
	BYTE* RGNDATA;
} EMRFRAMERGN;
'!

!OS.EMRFRAMERGN categoriesForClass!Win32-Structs! !

!OS.EMRFRAMERGN methodsFor!

cbRgnData
	"Answer the <Integer> value of the receiver's 'cbRgnData' field."

	^bytes uint32AtOffset: _OffsetOf_cbRgnData!

cbRgnData: anInteger
	"Set the receiver's 'cbRgnData' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbRgnData put: anInteger!

ihBrush
	"Answer the <Integer> value of the receiver's 'ihBrush' field."

	^bytes uint32AtOffset: _OffsetOf_ihBrush!

ihBrush: anInteger
	"Set the receiver's 'ihBrush' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ihBrush put: anInteger!

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
	self cbRgnData: anExternalArray size!

szlStroke
	"Answer the <SIZEL> value of the receiver's 'szlStroke' field."

	^SIZEL fromAddress: bytes yourAddress + _OffsetOf_szlStroke!

szlStroke: aSIZEL
	"Set the receiver's 'szlStroke' field to the value of the argument, aSIZEL"

	aSIZEL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlStroke + 1)
		to: ##(_OffsetOf_szlStroke + SIZEL._SIZEL_Size)
		startingAt: 1! !

!OS.EMRFRAMERGN categoriesForMethods!
cbRgnData!**compiled accessors**!public! !
cbRgnData:!**compiled accessors**!public! !
ihBrush!**compiled accessors**!public! !
ihBrush:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
RGNDATA!**compiled accessors**!public! !
RGNDATA:!**compiled accessors**!public! !
szlStroke!**compiled accessors**!public! !
szlStroke:!**compiled accessors**!public! !
!

!OS.EMRFRAMERGN class methodsFor!

byteSize
	^_EMRFRAMERGN_Size!

defineFields
	"Define the fields of the EMRFRAMERGN structure.

	EMRFRAMERGN  compileDefinition

		typedef [uuid(490FDA83-42A6-4848-8A5E-D866C05155E5)]
		struct tagEMRFRAMERGN {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Size of region data in bytes')] DWORD cbRgnData;
			[helpstring('Brush handle index')] DWORD ihBrush;
			SIZEL szlStroke;
			BYTE RGNDATA[];
		} EMRFRAMERGN;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #cbRgnData
			type: UInt32Field new
			offset: 24;
		defineField: #ihBrush
			type: UInt32Field new
			offset: 28;
		defineField: #szlStroke
			type: (StructureField type: SIZEL)
			offset: 32;
		defineField: #RGNDATA
			type: (ArrayField type: ExternalArray lengthField: #cbRgnData)
			offset: 40!

getFieldNames
	^#(#iType #nSize #rclBounds #cbRgnData #ihBrush #szlStroke #RGNDATA)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_FRAMERGN}! !

!OS.EMRFRAMERGN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

