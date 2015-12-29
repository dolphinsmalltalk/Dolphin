"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRINVERTRGN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRINVERTRGN guid: (GUID fromString: '{A68394EF-A64A-4B77-B81A-36B71800D05F}')!
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
	"Answer the receiver's cbRgnData field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbRgnData)!

cbRgnData: anObject 
	"Set the receiver's cbRgnData field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbRgnData) put: anObject!

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
!EMRINVERTRGN categoriesFor: #cbRgnData!**compiled accessors**!public! !
!EMRINVERTRGN categoriesFor: #cbRgnData:!**compiled accessors**!public! !
!EMRINVERTRGN categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRINVERTRGN categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRINVERTRGN categoriesFor: #RGNDATA!**compiled accessors**!public! !
!EMRINVERTRGN categoriesFor: #RGNDATA:!**compiled accessors**!public! !

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
			type: (ConformantArrayField type: ExternalArray length: #cbRgnData)
			offset: 28!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_INVERTRGN with: EMR_PAINTRGN! !
!EMRINVERTRGN class categoriesFor: #defineFields!initializing!public! !
!EMRINVERTRGN class categoriesFor: #iTypes!constants!public! !

