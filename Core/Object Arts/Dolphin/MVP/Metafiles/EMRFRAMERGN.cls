"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRFRAMERGN
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbRgnData _OffsetOf_ihBrush _OffsetOf_rclBounds _OffsetOf_RGNDATA _OffsetOf_szlStroke'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRFRAMERGN guid: (GUID fromString: '{490fda83-42a6-4848-8a5e-d866c05155e5}')!
EMRFRAMERGN addClassConstant: '_OffsetOf_cbRgnData' value: 16r18!
EMRFRAMERGN addClassConstant: '_OffsetOf_ihBrush' value: 16r1C!
EMRFRAMERGN addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
EMRFRAMERGN addClassConstant: '_OffsetOf_RGNDATA' value: 16r28!
EMRFRAMERGN addClassConstant: '_OffsetOf_szlStroke' value: 16r20!
EMRFRAMERGN comment: '<EMRFRAMERGN> is an <ExternalStructure> class to wrap the struct ''Win32.EMRFRAMERGN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMRFRAMERGN categoriesForClass!Win32-Structs! !
!EMRFRAMERGN methodsFor!

cbRgnData
	"Answer the <Integer> value of the receiver's 'cbRgnData' field."

	^bytes dwordAtOffset: _OffsetOf_cbRgnData!

cbRgnData: anInteger
	"Set the receiver's 'cbRgnData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbRgnData put: anInteger!

ihBrush
	"Answer the <Integer> value of the receiver's 'ihBrush' field."

	^bytes dwordAtOffset: _OffsetOf_ihBrush!

ihBrush: anInteger
	"Set the receiver's 'ihBrush' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihBrush put: anInteger!

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
	self cbRgnData: anExternalArray size!

szlStroke
	"Answer the <SIZE> value of the receiver's 'szlStroke' field."

	^SIZE fromAddress: bytes yourAddress + _OffsetOf_szlStroke!

szlStroke: aSIZE
	"Set the receiver's 'szlStroke' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlStroke + 1)
		to: ##(_OffsetOf_szlStroke + SIZE basicByteSize)
		startingAt: 1! !
!EMRFRAMERGN categoriesForMethods!
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

!EMRFRAMERGN class methodsFor!

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
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #cbRgnData
			type: DWORDField new
			offset: 24;
		defineField: #ihBrush
			type: DWORDField new
			offset: 28;
		defineField: #szlStroke
			type: (StructureField type: SIZE)
			offset: 32;
		defineField: #RGNDATA
			type: (ArrayField type: ExternalArray lengthField: #cbRgnData)
			offset: 40!

getFieldNames
	^#(#iType #nSize #rclBounds #cbRgnData #ihBrush #szlStroke #RGNDATA)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_FRAMERGN! !
!EMRFRAMERGN class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

