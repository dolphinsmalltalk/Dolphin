"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMREXCLUDECLIPRECT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_rclClip' -> 16r8
	}!
OS.EMREXCLUDECLIPRECT guid: (Core.GUID fromString: '{8747d7ee-6f40-4b1b-a573-4097e175337d}')!
OS.EMREXCLUDECLIPRECT comment: '<EMREXCLUDECLIPRECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXCLUDECLIPRECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(8747D7EE-6F40-4B1B-A573-4097E175337D)]
struct tagEMREXCLUDECLIPRECT {
	EMR EMR;
	RECTL rclClip;
} EMREXCLUDECLIPRECT;
'!
!OS.EMREXCLUDECLIPRECT categoriesForClass!Win32-Structs! !
!OS.EMREXCLUDECLIPRECT methodsFor!

rclClip
	"Answer the <RECTL> value of the receiver's 'rclClip' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclClip!

rclClip: aRECT
	"Set the receiver's 'rclClip' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclClip + 1)
		to: ##(_OffsetOf_rclClip + RECTL basicByteSize)
		startingAt: 1! !
!OS.EMREXCLUDECLIPRECT categoriesFor: #rclClip!**compiled accessors**!public! !
!OS.EMREXCLUDECLIPRECT categoriesFor: #rclClip:!**compiled accessors**!public! !

!OS.EMREXCLUDECLIPRECT class methodsFor!

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
		defineField: #rclClip
		type: (StructureField type: RECTL)
		offset: 8.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #rclClip)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EXCLUDECLIPRECT. EMR_INTERSECTCLIPRECT}! !
!OS.EMREXCLUDECLIPRECT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMREXCLUDECLIPRECT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMREXCLUDECLIPRECT class categoriesFor: #iTypes!constants!public! !

