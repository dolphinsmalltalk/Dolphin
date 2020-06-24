"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRFILLPATH
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_rclBounds'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRFILLPATH guid: (GUID fromString: '{2fe2f5ac-b812-4a5e-88b9-1b90a426c138}')!
EMRFILLPATH addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
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
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
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

getFieldNames
	^#(#iType #nSize #rclBounds)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_FILLPATH. EMR_STROKEANDFILLPATH. EMR_STROKEPATH}! !
!EMRFILLPATH class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRFILLPATH class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRFILLPATH class categoriesFor: #iTypes!constants!public! !

