"Filed out from Dolphin Smalltalk"!

OS.AbstractTEXTRANGE
	subclass: #'OS.FINDTEXTEX'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_FINDTEXTEX_Size' -> 16r14.
			'_OffsetOf_chrg' -> 16r0.
			'_OffsetOf_chrgText' -> 16rC.
			'_OffsetOf_lpstrText' -> 16r8
		}!
OS.FINDTEXTEX guid: (Core.GUID fromString: '{be0e52c5-c59b-4277-ac2a-cb775eac3904}')!
OS.FINDTEXTEX comment: '<FINDTEXTEX> is an <ExternalStructure> class to wrap the struct ''Win.FINDTEXTEX'' from type information in the ''Windows API (ANSI)'' library.

This structure is used in conjunction with the RichEdit control''s EM_FINDTEXTEX message, but is defined in the base as it is also used by Scintilla.

IDL definition follows:

typedef 
struct tagFINDTEXTEX {
	CHARRANGE chrg;
	long lpstrText;
	CHARRANGE chrgText;
} FINDTEXTEX;
'!
!OS.FINDTEXTEX categoriesForClass!Win-Structs! !
!OS.FINDTEXTEX methodsFor!

chrgText
	"Answer the <CHARRANGE> value of the receiver's 'chrgText' field."

	^CHARRANGE fromAddress: bytes yourAddress + _OffsetOf_chrgText!

lpstrText: anUtf16String
	"Set the receiver's 'lpstrText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrText put: anUtf16String yourAddress! !
!OS.FINDTEXTEX categoriesForMethods!
chrgText!**compiled accessors**!public! !
lpstrText:!**compiled accessors**!public! !
!

!OS.FINDTEXTEX class methodsFor!

byteSize
	^_FINDTEXTEX_Size!

defineFields
	"Define the fields of the FINDTEXTEX structure.
		FINDTEXTEX compileDefinition

		typedef 
		struct tagFINDTEXTEX {
			CHARRANGE chrg;
			LPSTR lpstrText;
			CHARRANGE chrgText;
		} FINDTEXTEX;"

	self
		defineField: #chrg type: (StructureField type: CHARRANGE) beUncompiled;
		defineField: #lpstrText type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #chrgText type: (StructureField type: CHARRANGE) beReadOnly!

getFieldNames
	^#(#chrg #lpstrText #chrgText)! !
!OS.FINDTEXTEX class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

