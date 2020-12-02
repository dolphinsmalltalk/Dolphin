"Filed out from Dolphin Smalltalk 7"!

AbstractLOGFONT subclass: #LOGFONTW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_lfFaceName' -> 16r1C
	}!
LOGFONTW guid: (GUID fromString: '{37140088-772d-4f72-aac2-27311f7805d8}')!
LOGFONTW comment: '<LOGFONTW> is an <ExternalStructure> class to wrap the struct ''Win32.LOGFONTW'' from type information in the ''Win32 API'' library.

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
!LOGFONTW categoriesForClass!Win32-Structs! !
!LOGFONTW methodsFor!

createFont
	^GDILibrary default createFontIndirectW: self!

faceName
	"Answer the receiver's lfFaceName field as a UTF-8 encoded string, having trimmed any extra
	nulls."
	
	^self lfFaceName asUtf8String trimNulls!

faceName: aString
	"Set the receiver's lfFaceName field."
	
	self lfFaceName: aString asUtf16String!

getData: hFont
	GDILibrary default
		getObjectW: hFont
		cbBuffer: self byteSize
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
	bytes wordAtOffset: _OffsetOf_lfFaceName + size put: 0! !
!LOGFONTW categoriesFor: #createFont!private!realizing/unrealizing! !
!LOGFONTW categoriesFor: #faceName!accessing!public! !
!LOGFONTW categoriesFor: #faceName:!accessing!public! !
!LOGFONTW categoriesFor: #getData:!helpers!private! !
!LOGFONTW categoriesFor: #lfFaceName!**compiled accessors**!public! !
!LOGFONTW categoriesFor: #lfFaceName:!**compiled accessors**!public! !

!LOGFONTW class methodsFor!

defineFields
	"Define the Win32 LOGFONTW structure.
		LOGFONTW compileDefinition.
	"

	super defineFields.
	self defineField: #lfFaceName type: (StringField type: Utf16String length: LF_FACESIZE)! !
!LOGFONTW class categoriesFor: #defineFields!public!template definition! !

