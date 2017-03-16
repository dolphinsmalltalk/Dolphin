"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRROUNDRECT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRROUNDRECT guid: (GUID fromString: '{31c4124d-eff4-4b42-adfd-7ed8d589eade}')!
EMRROUNDRECT comment: '<EMRROUNDRECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRROUNDRECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(31C4124D-EFF4-4B42-ADFD-7ED8D589EADE)]
struct tagEMRROUNDRECT {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounding rectangle")] RECTL rclBox;
	SIZEL szlCorner;
} EMRROUNDRECT;
'!
!EMRROUNDRECT categoriesForClass!Win32-Structs! !
!EMRROUNDRECT methodsFor!

rclBox
	"Answer the receiver's rclBox field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBox)!

rclBox: anObject 
	"Set the receiver's rclBox field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBox) + 1)
		to: ##((self offsetOf: #rclBox) + RECT basicByteSize)
		startingAt: 1!

szlCorner
	"Answer the receiver's szlCorner field as a Smalltalk object."

	^SIZE fromAddress: bytes yourAddress + ##(self offsetOf: #szlCorner)!

szlCorner: anObject 
	"Set the receiver's szlCorner field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szlCorner) + 1)
		to: ##((self offsetOf: #szlCorner) + SIZE basicByteSize)
		startingAt: 1! !
!EMRROUNDRECT categoriesFor: #rclBox!**compiled accessors**!public! !
!EMRROUNDRECT categoriesFor: #rclBox:!**compiled accessors**!public! !
!EMRROUNDRECT categoriesFor: #szlCorner!**compiled accessors**!public! !
!EMRROUNDRECT categoriesFor: #szlCorner:!**compiled accessors**!public! !

!EMRROUNDRECT class methodsFor!

defineFields
	"Define the fields of the EMRROUNDRECT structure.

	EMRROUNDRECT  compileDefinition

		typedef [uuid(31C4124D-EFF4-4B42-ADFD-7ED8D589EADE)]
		struct tagEMRROUNDRECT {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounding rectangle')] RECTL rclBox;
			SIZEL szlCorner;
		} EMRROUNDRECT;
"

	super defineFields.
	self
		defineField: #rclBox
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #szlCorner
			type: (StructureField type: SIZE)
			offset: 24.
	self byteSize: 32!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_ROUNDRECT! !
!EMRROUNDRECT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRROUNDRECT class categoriesFor: #iTypes!constants!public! !

