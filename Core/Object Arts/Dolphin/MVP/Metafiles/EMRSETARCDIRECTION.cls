"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETARCDIRECTION
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iArcDirection'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETARCDIRECTION guid: (GUID fromString: '{41d545c1-ed58-46f1-9b90-34ef56bd4213}')!
EMRSETARCDIRECTION addClassConstant: '_OffsetOf_iArcDirection' value: 16r8!
EMRSETARCDIRECTION comment: '<EMRSETARCDIRECTION> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETARCDIRECTION'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(41D545C1-ED58-46F1-9B90-34EF56BD4213)]
struct tagEMRSETARCDIRECTION {
	EMR EMR;
	[helpstring("Specifies the arc direction in the advanced graphics mode.")] DWORD iArcDirection;
} EMRSETARCDIRECTION;
'!
!EMRSETARCDIRECTION categoriesForClass!Win32-Structs! !
!EMRSETARCDIRECTION methodsFor!

iArcDirection
	"Answer the <Integer> value of the receiver's 'iArcDirection' field."

	^bytes dwordAtOffset: _OffsetOf_iArcDirection!

iArcDirection: anInteger
	"Set the receiver's 'iArcDirection' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iArcDirection put: anInteger! !
!EMRSETARCDIRECTION categoriesFor: #iArcDirection!**compiled accessors**!public! !
!EMRSETARCDIRECTION categoriesFor: #iArcDirection:!**compiled accessors**!public! !

!EMRSETARCDIRECTION class methodsFor!

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
			type: DWORDField new
			offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #iArcDirection)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETARCDIRECTION}! !
!EMRSETARCDIRECTION class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSETARCDIRECTION class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETARCDIRECTION class categoriesFor: #iTypes!constants!public! !

