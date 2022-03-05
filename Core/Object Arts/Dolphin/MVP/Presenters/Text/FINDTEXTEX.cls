"Filed out from Dolphin Smalltalk"!

TEXTRANGE subclass: #FINDTEXTEX
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_chrgText'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FINDTEXTEX guid: (GUID fromString: '{be0e52c5-c59b-4277-ac2a-cb775eac3904}')!
FINDTEXTEX addClassConstant: '_OffsetOf_chrgText' value: 16rC!
FINDTEXTEX comment: '<FINDTEXTEX> is an <ExternalStructure> class to wrap the struct ''Win.FINDTEXTEX'' from type information in the ''Windows API (ANSI)'' library.

This structure is used in conjunction with the RichEdit control''s EM_FINDTEXTEX message, but is defined in the base as it is also used by Scintilla.

IDL definition follows:

typedef 
struct tagFINDTEXTEX {
	CHARRANGE chrg;
	long lpstrText;
	CHARRANGE chrgText;
} FINDTEXTEX;
'!
!FINDTEXTEX categoriesForClass!Win-Structs! !
!FINDTEXTEX methodsFor!

chrgText
	"Answer the <CHARRANGE> value of the receiver's 'chrgText' field."

	^CHARRANGE fromAddress: bytes yourAddress + _OffsetOf_chrgText! !
!FINDTEXTEX categoriesForMethods!
chrgText!**compiled accessors**!public! !
!

!FINDTEXTEX class methodsFor!

defineFields
	"Define the fields of the FINDTEXTEX structure.
		FINDTEXTEX compileDefinition

		typedef 
		struct tagFINDTEXTEX {
			CHARRANGE chrg;
			LPSTR lpstrText;
			CHARRANGE chrgText;
		} FINDTEXTEX;"

	super defineFields.
	self defineField: #chrgText type: (StructureField type: CHARRANGE) beReadOnly!

getFieldNames
	^#(#chrg #lpstrText #chrgText)! !
!FINDTEXTEX class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

