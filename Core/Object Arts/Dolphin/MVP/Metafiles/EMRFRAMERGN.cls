"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRFRAMERGN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRFRAMERGN guid: (GUID fromString: '{490fda83-42a6-4848-8a5e-d866c05155e5}')!
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
		startingAt: 1!

szlStroke
	"Answer the receiver's szlStroke field as a Smalltalk object."

	^SIZE fromAddress: bytes yourAddress + ##(self offsetOf: #szlStroke)!

szlStroke: anObject 
	"Set the receiver's szlStroke field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szlStroke) + 1)
		to: ##((self offsetOf: #szlStroke) + SIZE basicByteSize)
		startingAt: 1! !
!EMRFRAMERGN categoriesFor: #cbRgnData!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #cbRgnData:!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #ihBrush!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #ihBrush:!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #RGNDATA!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #RGNDATA:!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #szlStroke!**compiled accessors**!public! !
!EMRFRAMERGN categoriesFor: #szlStroke:!**compiled accessors**!public! !

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
			type: (ConformantArrayField type: ExternalArray length: #cbRgnData)
			offset: 40!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_FRAMERGN! !
!EMRFRAMERGN class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRFRAMERGN class categoriesFor: #iTypes!constants!public! !

