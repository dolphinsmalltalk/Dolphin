"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRFILLPATH'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMRFILLPATH_Size' -> 16r18. '_OffsetOf_rclBounds' -> 16r8 }!

OS.EMRFILLPATH guid: (Core.GUID fromString: '{2fe2f5ac-b812-4a5e-88b9-1b90a426c138}')!

OS.EMRFILLPATH comment: '<EMRFILLPATH> is an <ExternalStructure> class to wrap the struct ''Win32.EMRFILLPATH'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2FE2F5AC-B812-4A5E-88B9-1B90A426C138)]
struct tagEMRFILLPATH {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
} EMRFILLPATH;
'!

!OS.EMRFILLPATH categoriesForClass!Win32-Structs! !

!OS.EMRFILLPATH methodsFor!

rclBounds
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECTL
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL._RECTL_Size)
		startingAt: 1! !

!OS.EMRFILLPATH categoriesForMethods!
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

!OS.EMRFILLPATH class methodsFor!

byteSize
	^_EMRFILLPATH_Size!

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
		type: (StructureField type: RECTL)
		offset: 8.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #rclBounds)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_FILLPATH. EMR_STROKEANDFILLPATH. EMR_STROKEPATH}! !

!OS.EMRFILLPATH class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

