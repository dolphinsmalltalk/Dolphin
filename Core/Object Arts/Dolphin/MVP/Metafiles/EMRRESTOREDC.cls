"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRRESTOREDC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRRESTOREDC guid: (GUID fromString: '{77f6595f-287e-4df2-be4c-dfd546be3718}')!
EMRRESTOREDC comment: '<EMRRESTOREDC> is an <ExternalStructure> class to wrap the struct ''Win32.EMRRESTOREDC'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(77F6595F-287E-4DF2-BE4C-DFD546BE3718)]
struct tagEMRRESTOREDC {
	EMR EMR;
	[helpstring("Specifies a relative instance")] long iRelative;
} EMRRESTOREDC;
'!
!EMRRESTOREDC categoriesForClass!Win32-Structs! !
!EMRRESTOREDC methodsFor!

iRelative
	"Answer the receiver's iRelative field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iRelative)!

iRelative: anObject 
	"Set the receiver's iRelative field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iRelative) put: anObject! !
!EMRRESTOREDC categoriesFor: #iRelative!**compiled accessors**!public! !
!EMRRESTOREDC categoriesFor: #iRelative:!**compiled accessors**!public! !

!EMRRESTOREDC class methodsFor!

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
			type: SDWORDField new
			offset: 8.
	self byteSize: 12!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_RESTOREDC! !
!EMRRESTOREDC class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRRESTOREDC class categoriesFor: #iTypes!constants!public! !

