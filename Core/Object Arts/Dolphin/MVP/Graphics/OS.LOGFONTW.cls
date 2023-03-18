"Filed out from Dolphin Smalltalk"!

OS.AbstractLOGFONT
	subclass: #'OS.LOGFONTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_LOGFONTW_Size' -> 16r5C. '_OffsetOf_lfFaceName' -> 16r1C }!
OS.LOGFONTW guid: (Core.GUID fromString: '{37140088-772d-4f72-aac2-27311f7805d8}')!
OS.LOGFONTW comment: '<LOGFONTW> is an <ExternalStructure> class to wrap the struct ''Win32.LOGFONTW'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The LOGFONTW structure defines the attributes of a font. "

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(37140088-772d-4f72-aac2-27311f7805d8), helpstring("The LOGFONTW structure defines the attributes of a font. ")]
struct tagLOGFONTW {
	long lfHeight;
	long lfWidth;
	long lfEscapement;
	long lfOrientation;
	long lfWeight;
	BYTE lfItalic;
	BYTE lfUnderline;
	BYTE lfStrikeOut;
	BYTE lfCharSet;
	BYTE lfOutPrecision;
	BYTE lfClipPrecision;
	BYTE lfQuality;
	BYTE lfPitchAndFamily;
	unsigned short lfFaceName[32];
} LOGFONTW;
'!
!OS.LOGFONTW categoriesForClass!Win32-Structs! !
!OS.LOGFONTW methodsFor!

createFont
	^Gdi32 createFontIndirectW: self!

faceName
	"Answer the receiver's lfFaceName field as a UTF-8 encoded string."
	
	^self lfFaceName asUtf8String!

faceName: aString
	"Set the receiver's lfFaceName field."
	
	self lfFaceName: aString asUtf16String!

getData: hFont
	Gdi32
		getObjectW: hFont
		cbBuffer: _LOGFONTW_Size
		lpvObject: self!

lfFaceName
	"Answer the <Utf16String> value of the receiver's 'lfFaceName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_lfFaceName!

lfFaceName: anUtf16String
	"Set the receiver's 'lfFaceName' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(31 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lfFaceName + 1)
		to: _OffsetOf_lfFaceName + size
		startingAt: 1.
	bytes uint16AtOffset: _OffsetOf_lfFaceName + size put: 0! !
!OS.LOGFONTW categoriesForMethods!
createFont!private!realizing/unrealizing! !
faceName!accessing!public! !
faceName:!accessing!public! !
getData:!helpers!private! !
lfFaceName!**compiled accessors**!public! !
lfFaceName:!**compiled accessors**!public! !
!

!OS.LOGFONTW class methodsFor!

byteSize
	^_LOGFONTW_Size!

defineFields
	"Define the Win32 LOGFONTW structure.
		LOGFONTW compileDefinition.
	"

	super defineFields.
	self defineField: #lfFaceName type: (StringField type: Utf16String length: LF_FACESIZE)! !
!OS.LOGFONTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

