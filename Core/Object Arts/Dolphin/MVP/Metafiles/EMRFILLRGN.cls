"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRFILLRGN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRFILLRGN guid: (GUID fromString: '{5840d53d-c10c-442c-be9f-cfada623813e}')!
EMRFILLRGN comment: '<EMRFILLRGN> is an <ExternalStructure> class to wrap the struct ''Win32.EMRFILLRGN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(5840D53D-C10C-442C-BE9F-CFADA623813E)]
struct tagEMRFILLRGN {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Size of region data in bytes")] DWORD cbRgnData;
	[helpstring("Brush handle index")] DWORD ihBrush;
	BYTE* RGNDATA;
} EMRFILLRGN;
'!
!EMRFILLRGN categoriesForClass!Win32-Structs! !
!EMRFILLRGN methodsFor!

cbRgnData
	"Answer the <Integer> value of the receiver's 'cbRgnData' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cbRgnData)!

cbRgnData: anInteger
	"Set the receiver's 'cbRgnData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cbRgnData) put: anInteger!

ihBrush
	"Answer the <Integer> value of the receiver's 'ihBrush' field."

	^bytes dwordAtOffset: ##(self offsetOf: #ihBrush)!

ihBrush: anInteger
	"Set the receiver's 'ihBrush' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #ihBrush) put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1!

RGNDATA
	"Answer the <ExternalArray> value of the receiver's 'RGNDATA' field."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #RGNDATA) length: self cbRgnData!

RGNDATA: anExternalArray
	"Set the receiver's 'RGNDATA' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize.
	anExternalArray
		replaceBytesOf: bytes
		from: ##((self offsetOf: #RGNDATA) + 1)
		to: ##(self offsetOf: #RGNDATA) + size
		startingAt: 1.
	self cbRgnData: anExternalArray size! !
!EMRFILLRGN categoriesFor: #cbRgnData!**compiled accessors**!public! !
!EMRFILLRGN categoriesFor: #cbRgnData:!**compiled accessors**!public! !
!EMRFILLRGN categoriesFor: #ihBrush!**compiled accessors**!public! !
!EMRFILLRGN categoriesFor: #ihBrush:!**compiled accessors**!public! !
!EMRFILLRGN categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRFILLRGN categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRFILLRGN categoriesFor: #RGNDATA!**compiled accessors**!public! !
!EMRFILLRGN categoriesFor: #RGNDATA:!**compiled accessors**!public! !

!EMRFILLRGN class methodsFor!

defineFields
	"Define the fields of the EMRFILLRGN structure.

	EMRFILLRGN  compileDefinition

		typedef [uuid(5840D53D-C10C-442C-BE9F-CFADA623813E)]
		struct tagEMRFILLRGN {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Size of region data in bytes')] DWORD cbRgnData;
			[helpstring('Brush handle index')] DWORD ihBrush;
			BYTE RGNDATA[];
		} EMRFILLRGN;
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
		defineField: #RGNDATA
			type: (ArrayField type: ExternalArray lengthField: #cbRgnData)
			offset: 32!

getFieldNames
	^#(#iType #nSize #rclBounds #cbRgnData #ihBrush #RGNDATA)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_FILLRGN! !
!EMRFILLRGN class categoriesFor: #defineFields!initializing!public! !
!EMRFILLRGN class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRFILLRGN class categoriesFor: #iTypes!constants!public! !

