"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRFILLPATH
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRFILLPATH guid: (GUID fromString: '{2FE2F5AC-B812-4A5E-88B9-1B90A426C138}')!
EMRFILLPATH comment: '<EMRFILLPATH> is an <ExternalStructure> class to wrap the struct ''Win32.EMRFILLPATH'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2FE2F5AC-B812-4A5E-88B9-1B90A426C138)]
struct tagEMRFILLPATH {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
} EMRFILLPATH;
'!
!EMRFILLPATH categoriesForClass!Win32-Structs! !
!EMRFILLPATH methodsFor!

rclBounds
	"Answer the receiver's rclBounds field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: anObject 
	"Set the receiver's rclBounds field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1! !
!EMRFILLPATH categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRFILLPATH categoriesFor: #rclBounds:!**compiled accessors**!public! !

!EMRFILLPATH class methodsFor!

defineFields
	"Define the fields of the EMRFILLPATH structure.

	EMRFILLPATH  compileDefinition

		typedef [uuid(2FE2F5AC-B812-4A5E-88B9-1B90A426C138)]
		struct tagEMRFILLPATH {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
		} EMRFILLPATH;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8.
	self byteSize: 24!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array 
		with: EMR_FILLPATH
		with: EMR_STROKEANDFILLPATH
		with: EMR_STROKEPATH! !
!EMRFILLPATH class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRFILLPATH class categoriesFor: #iTypes!constants!public! !

