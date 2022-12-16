"Filed out from Dolphin Smalltalk"!

OS.AbstractTEXTRANGE subclass: #'OS.TEXTRANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_chrg' -> 16r0.
		'_OffsetOf_lpstrText' -> 16r8.
		'_TEXTRANGE_Size' -> 16rC
	}!
OS.TEXTRANGE guid: (Core.GUID fromString: '{87b4c615-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.TEXTRANGE comment: 'TEXTRANGE is the class of <ExternalStructure> which represents the Windows TEXTRANGE and TEXTRANGEW structures.

Most of the ExternalStructures in Dolphin are now for wide character APIs only, and indeed TEXTRANGE is used with wide strings for the <RichTextEdit> control. However, it is also used with Scintilla, which only supports byte string encodings (including UTF-8). Scintilla also uses the structure to retrieve styling bytes, which aren''t characters at all.

An example use of TEXTRANGE is with the EM_GETTEXTRANGE message to specify the range of text to retrieve from a Rich Edit control and to provide a buffer to copy the text into.

Instance Variables:
	text		<AnsiString|Utf8String|Utf16String|ByteArray>. Buffer whose address is stored into structure (to prevent premature GC).'!
!OS.TEXTRANGE categoriesForClass!Win-Structs! !
!OS.TEXTRANGE methodsFor!

lpstrText: anUtf16String
	"Set the receiver's 'lpstrText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrText put: anUtf16String yourAddress! !
!OS.TEXTRANGE categoriesForMethods!
lpstrText:!**compiled accessors**!public! !
!

!OS.TEXTRANGE class methodsFor!

byteSize
	^_TEXTRANGE_Size!

defineFields
	"Define the fields of the TEXTRANGE structure.
		TEXTRANGE compileDefinition
	
		typedef 
		struct tagTEXTRANGE {
			CHARRANGE chrg;
			LPTSTR lpstrText;
		} TEXTRANGE;
	"

	self
		defineField: #chrg type: (StructureField type: CHARRANGE) beUncompiled;
		defineField: #lpstrText type: (PointerField type: Utf16String) beWriteOnly! !
!OS.TEXTRANGE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

