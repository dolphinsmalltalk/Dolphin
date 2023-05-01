"Filed out from Dolphin Smalltalk"!

OS.LOGFONTW
	subclass: #'OS.ENUMLOGFONTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ENUMLOGFONTW_Size' -> 16r11C.
			'_OffsetOf_elfFullName' -> 16r5C.
			'_OffsetOf_elfStyle' -> 16rDC
		}!
OS.ENUMLOGFONTW guid: (Core.GUID fromString: '{f10411f6-c151-4390-af05-3702d4f98f12}')!
OS.ENUMLOGFONTW comment: '`ENUMLOGFONT` is an `External.Structure` class to wrap the struct ''Win32.ENUMLOGFONT'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(f10411f6-c151-4390-af05-3702d4f98f12)]
struct tagENUMLOGFONT {
	LOGFONTW elfLogFont;
	[readonly, helpstring("A unique name for the font. For example, ABCD Font Company TrueType Bold Italic Sans Serif."), string] unsigned short elfFullName[64];
	[readonly, helpstring("The style of the font. For example, Bold Italic."), string] unsigned short elfStyle[32];
} ENUMLOGFONT;
```
'!
!OS.ENUMLOGFONTW categoriesForClass!Win32-Structs! !
!OS.ENUMLOGFONTW methodsFor!

elfFullName
	"Answer the <Utf16String> value of the receiver's 'elfFullName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_elfFullName!

elfStyle
	"Answer the <Utf16String> value of the receiver's 'elfStyle' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_elfStyle! !
!OS.ENUMLOGFONTW categoriesForMethods!
elfFullName!**compiled accessors**!public! !
elfStyle!**compiled accessors**!public! !
!

!OS.ENUMLOGFONTW class methodsFor!

byteSize
	^_ENUMLOGFONTW_Size!

defineFields
	"Define the fields of the ENUMLOGFONT structure.

	ENUMLOGFONTW compileDefinition

		typedef [uuid(f10411f6-c151-4390-af05-3702d4f98f12)]
		struct tagENUMLOGFONT {
			LOGFONTW elfLogFont;
			[readonly, helpstring('A unique name for the font. For example, ABCD Font Company TrueType Bold Italic Sans Serif.'), string] unsigned short elfFullName[64];
			[readonly, helpstring('The style of the font. For example, Bold Italic.'), string] unsigned short elfStyle[32];
		} ENUMLOGFONT;
"

	super defineFields.
	self
		defineField: #elfFullName type: (StringField type: Utf16String length: 64) beReadOnly offset: 92;
		defineField: #elfStyle type: (StringField type: Utf16String length: 32) beReadOnly offset: 220.
	self byteSize: 284!

getFieldNames
	^#(#lfHeight #lfWidth #lfEscapement #lfOrientation #lfWeight #lfItalic #lfUnderline #lfStrikeOut #lfCharSet #lfOutPrecision #lfClipPrecision #lfQuality #lfPitchAndFamily #lfFaceName #elfFullName #elfStyle)! !
!OS.ENUMLOGFONTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

