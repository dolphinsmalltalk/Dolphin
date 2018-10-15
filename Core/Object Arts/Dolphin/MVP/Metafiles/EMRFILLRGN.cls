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
	"Answer the receiver's cbRgnData field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbRgnData)!

cbRgnData: anObject 
	"Set the receiver's cbRgnData field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbRgnData) put: anObject!

ihBrush
	"Answer the receiver's ihBrush field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihBrush)!

ihBrush: anObject 
	"Set the receiver's ihBrush field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihBrush) put: anObject!

rclBounds
	"Answer the receiver's rclBounds field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: anObject 
	"Set the receiver's rclBounds field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1!

RGNDATA
	"Answer the receiver's RGNDATA field as a Smalltalk object."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #RGNDATA) length: self cbRgnData!

RGNDATA: anObject 
	"Set the receiver's RGNDATA field to the value of anObject."

	| size |
	size := anObject byteSize min: self cbRgnData * ##(ExternalArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #RGNDATA) + 1)
		to: ##(self offsetOf: #RGNDATA) + size
		startingAt: 1! !
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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_FILLRGN! !
!EMRFILLRGN class categoriesFor: #defineFields!initializing!public! !
!EMRFILLRGN class categoriesFor: #iTypes!constants!public! !

