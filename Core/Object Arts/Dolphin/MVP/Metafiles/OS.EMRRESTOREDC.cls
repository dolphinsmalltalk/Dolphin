"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRRESTOREDC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMRRESTOREDC_Size' -> 16rC. '_OffsetOf_iRelative' -> 16r8 }!
OS.EMRRESTOREDC guid: (Core.GUID fromString: '{77f6595f-287e-4df2-be4c-dfd546be3718}')!
OS.EMRRESTOREDC comment: '<EMRRESTOREDC> is an <ExternalStructure> class to wrap the struct ''Win32.EMRRESTOREDC'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(77F6595F-287E-4DF2-BE4C-DFD546BE3718)]
struct tagEMRRESTOREDC {
	EMR EMR;
	[helpstring("Specifies a relative instance")] long iRelative;
} EMRRESTOREDC;
'!
!OS.EMRRESTOREDC categoriesForClass!Win32-Structs! !
!OS.EMRRESTOREDC methodsFor!

iRelative
	"Answer the <Integer> value of the receiver's 'iRelative' field."

	^bytes int32AtOffset: _OffsetOf_iRelative!

iRelative: anInteger
	"Set the receiver's 'iRelative' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iRelative put: anInteger! !
!OS.EMRRESTOREDC categoriesForMethods!
iRelative!**compiled accessors**!public! !
iRelative:!**compiled accessors**!public! !
!

!OS.EMRRESTOREDC class methodsFor!

byteSize
	^_EMRRESTOREDC_Size!

defineFields
	"Define the fields of the EMRRESTOREDC structure.

	EMRRESTOREDC  compileDefinition

		typedef [uuid(77F6595F-287E-4DF2-BE4C-DFD546BE3718)]
		struct tagEMRRESTOREDC {
			EMR EMR;
			[helpstring('Specifies a relative instance')] long iRelative;
		} EMRRESTOREDC;
"

	super defineFields.
	self
		defineField: #iRelative
		type: Int32Field new
		offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #iRelative)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_RESTOREDC}! !
!OS.EMRRESTOREDC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

