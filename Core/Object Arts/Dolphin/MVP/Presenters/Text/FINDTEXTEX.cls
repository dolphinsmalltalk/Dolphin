"Filed out from Dolphin Smalltalk X6.1"!

TEXTRANGE subclass: #FINDTEXTEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FINDTEXTEX guid: (GUID fromString: '{BE0E52C5-C59B-4277-AC2A-CB775EAC3904}')!
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
	"Answer the receiver's chrgText field as a Smalltalk object."

	^CHARRANGE fromAddress: bytes yourAddress + ##(self offsetOf: #chrgText)! !
!FINDTEXTEX categoriesFor: #chrgText!**compiled accessors**!public! !

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
	self defineField: #chrgText type: (StructureField type: CHARRANGE) beReadOnly! !
!FINDTEXTEX class categoriesFor: #defineFields!initializing!public! !

