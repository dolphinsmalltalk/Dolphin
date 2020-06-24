"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETCOLORADJUSTMENT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_COLORADJUSTMENT'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETCOLORADJUSTMENT guid: (GUID fromString: '{bc512904-3af5-4a18-a28b-bf413de2cf50}')!
EMRSETCOLORADJUSTMENT addClassConstant: '_OffsetOf_COLORADJUSTMENT' value: 16r8!
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
	"Answer the <COLORADJUSTMENT> value of the receiver's 'COLORADJUSTMENT' field."

	^COLORADJUSTMENT fromAddress: bytes yourAddress + _OffsetOf_COLORADJUSTMENT!

COLORADJUSTMENT: aCOLORADJUSTMENT
	"Set the receiver's 'COLORADJUSTMENT' field to the value of the argument, aCOLORADJUSTMENT"

	aCOLORADJUSTMENT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_COLORADJUSTMENT + 1)
		to: ##(_OffsetOf_COLORADJUSTMENT + COLORADJUSTMENT basicByteSize)
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

getFieldNames
	^#(#iType #nSize #COLORADJUSTMENT)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETCOLORADJUSTMENT}! !
!EMRSETCOLORADJUSTMENT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSETCOLORADJUSTMENT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETCOLORADJUSTMENT class categoriesFor: #iTypes!constants!public! !

