"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRARC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRARC guid: (GUID fromString: '{A4D8ACFF-7C86-450E-AB37-011F1B1A9754}')!
EMRARC comment: '<EMRARC> is an <ExternalStructure> class to wrap the struct ''Win32.EMRARC'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A4D8ACFF-7C86-450E-AB37-011F1B1A9754)]
struct tagEMRARC {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounding rectangle")] RECTL rclBox;
	POINTL ptlStart;
	POINTL ptlEnd;
} EMRARC;
'!
!EMRARC categoriesForClass!Win32-Structs! !
!EMRARC methodsFor!

ptlEnd
	"Answer the receiver's ptlEnd field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptlEnd)!

ptlEnd: anObject 
	"Set the receiver's ptlEnd field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ptlEnd) + 1)
		to: ##((self offsetOf: #ptlEnd) + POINTL basicByteSize)
		startingAt: 1!

ptlStart
	"Answer the receiver's ptlStart field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptlStart)!

ptlStart: anObject 
	"Set the receiver's ptlStart field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ptlStart) + 1)
		to: ##((self offsetOf: #ptlStart) + POINTL basicByteSize)
		startingAt: 1!

rclBox
	"Answer the receiver's rclBox field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBox)!

rclBox: anObject 
	"Set the receiver's rclBox field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBox) + 1)
		to: ##((self offsetOf: #rclBox) + RECT basicByteSize)
		startingAt: 1! !
!EMRARC categoriesFor: #ptlEnd!**compiled accessors**!public! !
!EMRARC categoriesFor: #ptlEnd:!**compiled accessors**!public! !
!EMRARC categoriesFor: #ptlStart!**compiled accessors**!public! !
!EMRARC categoriesFor: #ptlStart:!**compiled accessors**!public! !
!EMRARC categoriesFor: #rclBox!**compiled accessors**!public! !
!EMRARC categoriesFor: #rclBox:!**compiled accessors**!public! !

!EMRARC class methodsFor!

defineFields
	"Define the fields of the EMRARC structure.

	EMRARC  compileDefinition

		typedef [uuid(A4D8ACFF-7C86-450E-AB37-011F1B1A9754)]
		struct tagEMRARC {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounding rectangle')] RECTL rclBox;
			POINTL ptlStart;
			POINTL ptlEnd;
		} EMRARC;
"

	super defineFields.
	self
		defineField: #rclBox type: (StructureField type: RECT) offset: 8;
		defineField: #ptlStart type: (StructureField type: POINTL) offset: 24;
		defineField: #ptlEnd type: (StructureField type: POINTL) offset: 32.
	self byteSize: 40!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array 
		with: EMR_ARC
		with: EMR_ARCTO
		with: EMR_CHORD
		with: EMR_PIE! !
!EMRARC class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRARC class categoriesFor: #iTypes!constants!public! !

