"Filed out from Dolphin Smalltalk"!

OS.AbstractTEXTRANGE subclass: #'UI.Scintilla.TextRangeFull'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_chrg' -> 16r0.
		'_OffsetOf_lpstrText' -> 16r8.
		'_TextRangeFull_Size' -> 16rC
	}!
UI.Scintilla.TextRangeFull guid: (Core.GUID fromString: '{80bf6d59-182f-4d0c-97b2-4cd275856536}')!
UI.Scintilla.TextRangeFull comment: ''!
!UI.Scintilla.TextRangeFull methodsFor!

lpstrText: anUtf8String
	"Set the receiver's 'lpstrText' field to the value of the argument, anUtf8String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrText put: anUtf8String yourAddress! !
!UI.Scintilla.TextRangeFull categoriesForMethods!
lpstrText:!**compiled accessors**!public! !
!

!UI.Scintilla.TextRangeFull class methodsFor!

byteSize
	^_TextRangeFull_Size!

defineFields
	"Define the fields of the Scintilla TextRangeFull structure.
		TextRangeFull compileDefinition
	
	struct Sci_TextRangeFull {
		struct Sci_CharacterRangeFull chrg;
		char *lpstrText;
	};

	Note that because we use this for byte strings and byte arrays with Scintilla, and UTF-16 strings for RichEdit, the lpstrText field is defined as a generic pointer.
	"

	self
		defineField: #chrg type: (StructureField type: CharacterRangeFull) beUncompiled;
		defineField: #lpstrText type: (PointerField type: Utf8String) beWriteOnly! !
!UI.Scintilla.TextRangeFull class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

