"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMREXCLUDECLIPRECT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMREXCLUDECLIPRECT guid: (GUID fromString: '{8747d7ee-6f40-4b1b-a573-4097e175337d}')!
EMREXCLUDECLIPRECT comment: '<EMREXCLUDECLIPRECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXCLUDECLIPRECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(8747D7EE-6F40-4B1B-A573-4097E175337D)]
struct tagEMREXCLUDECLIPRECT {
	EMR EMR;
	RECTL rclClip;
} EMREXCLUDECLIPRECT;
'!
!EMREXCLUDECLIPRECT categoriesForClass!Win32-Structs! !
!EMREXCLUDECLIPRECT methodsFor!

rclClip
	"Answer the receiver's rclClip field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclClip)!

rclClip: anObject 
	"Set the receiver's rclClip field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclClip) + 1)
		to: ##((self offsetOf: #rclClip) + RECT basicByteSize)
		startingAt: 1! !
!EMREXCLUDECLIPRECT categoriesFor: #rclClip!**compiled accessors**!public! !
!EMREXCLUDECLIPRECT categoriesFor: #rclClip:!**compiled accessors**!public! !

!EMREXCLUDECLIPRECT class methodsFor!

defineFields
	"Define the fields of the EMREXCLUDECLIPRECT structure.

	EMREXCLUDECLIPRECT  compileDefinition

		typedef [uuid(8747D7EE-6F40-4B1B-A573-4097E175337D)]
		struct tagEMREXCLUDECLIPRECT {
			EMR EMR;
			RECTL rclClip;
		} EMREXCLUDECLIPRECT;
"

	super defineFields.
	self
		defineField: #rclClip type: (StructureField type: RECT) offset: 8.
	self byteSize: 24!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_EXCLUDECLIPRECT with: EMR_INTERSECTCLIPRECT! !
!EMREXCLUDECLIPRECT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMREXCLUDECLIPRECT class categoriesFor: #iTypes!constants!public! !

