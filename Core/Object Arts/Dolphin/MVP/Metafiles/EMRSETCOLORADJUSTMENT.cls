"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRSETCOLORADJUSTMENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETCOLORADJUSTMENT guid: (GUID fromString: '{BC512904-3AF5-4A18-A28B-BF413DE2CF50}')!
EMRSETCOLORADJUSTMENT comment: '<EMRSETCOLORADJUSTMENT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETCOLORADJUSTMENT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BC512904-3AF5-4A18-A28B-BF413DE2CF50)]
struct tagEMRSETCOLORADJUSTMENT {
	EMR EMR;
	COLORADJUSTMENT COLORADJUSTMENT;
} EMRSETCOLORADJUSTMENT;
'!
!EMRSETCOLORADJUSTMENT categoriesForClass!Win32-Structs! !
!EMRSETCOLORADJUSTMENT methodsFor!

COLORADJUSTMENT
	"Answer the receiver's COLORADJUSTMENT field as a Smalltalk object."

	^COLORADJUSTMENT fromAddress: bytes yourAddress + ##(self offsetOf: #COLORADJUSTMENT)!

COLORADJUSTMENT: anObject 
	"Set the receiver's COLORADJUSTMENT field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #COLORADJUSTMENT) + 1)
		to: ##((self offsetOf: #COLORADJUSTMENT) + COLORADJUSTMENT basicByteSize)
		startingAt: 1! !
!EMRSETCOLORADJUSTMENT categoriesFor: #COLORADJUSTMENT!**compiled accessors**!public! !
!EMRSETCOLORADJUSTMENT categoriesFor: #COLORADJUSTMENT:!**compiled accessors**!public! !

!EMRSETCOLORADJUSTMENT class methodsFor!

defineFields
	"Define the fields of the EMRSETCOLORADJUSTMENT structure.

	EMRSETCOLORADJUSTMENT  compileDefinition

		typedef [uuid(BC512904-3AF5-4A18-A28B-BF413DE2CF50)]
		struct tagEMRSETCOLORADJUSTMENT {
			EMR EMR;
			COLORADJUSTMENT COLORADJUSTMENT;
		} EMRSETCOLORADJUSTMENT;
"

	super defineFields.
	self
		defineField: #COLORADJUSTMENT
			type: (StructureField type: COLORADJUSTMENT)
			offset: 8.
	self byteSize: 32!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SETCOLORADJUSTMENT! !
!EMRSETCOLORADJUSTMENT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRSETCOLORADJUSTMENT class categoriesFor: #iTypes!constants!public! !

