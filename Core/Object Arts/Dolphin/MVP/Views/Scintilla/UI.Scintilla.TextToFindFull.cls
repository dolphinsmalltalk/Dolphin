"Filed out from Dolphin Smalltalk"!

OS.AbstractTEXTRANGE
	subclass: #'UI.Scintilla.TextToFindFull'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_chrg' -> 16r0.
			'_OffsetOf_chrgText' -> 16rC.
			'_OffsetOf_lpstrText' -> 16r8.
			'_TextToFindFull_Size' -> 16r14
		}!
UI.Scintilla.TextToFindFull guid: (Core.GUID fromString: '{3841939b-c533-4fff-a6e2-744631df1de9}')!
UI.Scintilla.TextToFindFull comment: ''!
!UI.Scintilla.TextToFindFull methodsFor!

chrgText
	"Answer the <CharacterRangeFull> value of the receiver's 'chrgText' field."

	^CharacterRangeFull fromAddress: bytes yourAddress + _OffsetOf_chrgText!

lpstrText: anUtf8String
	"Set the receiver's 'lpstrText' field to the value of the argument, anUtf8String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrText put: anUtf8String yourAddress! !
!UI.Scintilla.TextToFindFull categoriesForMethods!
chrgText!**compiled accessors**!public! !
lpstrText:!**compiled accessors**!public! !
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

	self
		defineField: #chrg type: (StructureField type: CharacterRangeFull) beUncompiled;
		defineField: #lpstrText type: (PointerField type: Utf8String) beWriteOnly;
		defineField: #chrgText type: (StructureField type: CharacterRangeFull) beReadOnly!

getFieldNames
	^#(#chrg #lpstrText #chrgText)! !
!UI.Scintilla.TextToFindFull class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

