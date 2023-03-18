"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSETARCDIRECTION'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMRSETARCDIRECTION_Size' -> 16rC. '_OffsetOf_iArcDirection' -> 16r8 }!
OS.EMRSETARCDIRECTION guid: (Core.GUID fromString: '{41d545c1-ed58-46f1-9b90-34ef56bd4213}')!
OS.EMRSETARCDIRECTION comment: '<EMRSETARCDIRECTION> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETARCDIRECTION'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(41D545C1-ED58-46F1-9B90-34EF56BD4213)]
struct tagEMRSETARCDIRECTION {
	EMR EMR;
	[helpstring("Specifies the arc direction in the advanced graphics mode.")] DWORD iArcDirection;
} EMRSETARCDIRECTION;
'!
!OS.EMRSETARCDIRECTION categoriesForClass!Win32-Structs! !
!OS.EMRSETARCDIRECTION methodsFor!

iArcDirection
	"Answer the <Integer> value of the receiver's 'iArcDirection' field."

	^bytes uint32AtOffset: _OffsetOf_iArcDirection!

iArcDirection: anInteger
	"Set the receiver's 'iArcDirection' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iArcDirection put: anInteger! !
!OS.EMRSETARCDIRECTION categoriesForMethods!
iArcDirection!**compiled accessors**!public! !
iArcDirection:!**compiled accessors**!public! !
!

!OS.EMRSETARCDIRECTION class methodsFor!

byteSize
	^_EMRSETARCDIRECTION_Size!

defineFields
	"Define the fields of the EMRSETARCDIRECTION structure.

	EMRSETARCDIRECTION  compileDefinition

		typedef [uuid(41D545C1-ED58-46F1-9B90-34EF56BD4213)]
		struct tagEMRSETARCDIRECTION {
			EMR EMR;
			[helpstring('Specifies the arc direction in the advanced graphics mode.')] DWORD iArcDirection;
		} EMRSETARCDIRECTION;
"

	super defineFields.
	self
		defineField: #iArcDirection
		type: UInt32Field new
		offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #iArcDirection)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETARCDIRECTION}! !
!OS.EMRSETARCDIRECTION class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

