"Filed out from Dolphin Smalltalk"!

UI.Scintilla.TextRangeFull
	subclass: #'UI.Scintilla.TextToFindFull'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_chrgText' -> 16rC. '_TextToFindFull_Size' -> 16r14 }!

UI.Scintilla.TextToFindFull guid: (Core.GUID fromString: '{3841939b-c533-4fff-a6e2-744631df1de9}')!

UI.Scintilla.TextToFindFull comment: ''!

!UI.Scintilla.TextToFindFull methodsFor!

chrgText
	"Answer the <CharacterRangeFull> value of the receiver's 'chrgText' field."

	^CharacterRangeFull fromAddress: bytes yourAddress + _OffsetOf_chrgText! !

!UI.Scintilla.TextToFindFull categoriesForMethods!
chrgText!**compiled accessors**!public! !
!

!UI.Scintilla.TextToFindFull class methodsFor!

byteSize
	^_TextToFindFull_Size!

defineFields
	"Define the fields of the Scintilla TextToFindFull structure.
		TextToFindFull compileDefinition

	struct Sci_TextToFindFull {
		struct Sci_CharacterRangeFull chrg;
		const char *lpstrText;
		struct Sci_CharacterRangeFull chrgText;
	};"

	super defineFields.
	self
		defineField: #chrgText type: (StructureField type: CharacterRangeFull) beReadOnly!

getFieldNames
	^#(#chrg #lpstrText #chrgText)! !

!UI.Scintilla.TextToFindFull class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

