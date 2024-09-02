"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #LOGFONTW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lfCharSet _OffsetOf_lfClipPrecision _OffsetOf_lfEscapement _OffsetOf_lfFaceName _OffsetOf_lfHeight _OffsetOf_lfItalic _OffsetOf_lfOrientation _OffsetOf_lfOutPrecision _OffsetOf_lfPitchAndFamily _OffsetOf_lfQuality _OffsetOf_lfStrikeOut _OffsetOf_lfUnderline _OffsetOf_lfWeight _OffsetOf_lfWidth ANTIALIASED_QUALITY CLEARTYPE_NATURAL_QUALITY CLEARTYPE_QUALITY DEFAULT_PITCH DEFAULT_QUALITY DRAFT_QUALITY FIXED_PITCH NONANTIALIASED_QUALITY OUT_CHARACTER_PRECIS OUT_DEFAULT_PRECIS OUT_DEVICE_PRECIS OUT_OUTLINE_PRECIS OUT_PS_ONLY_PRECIS OUT_RASTER_PRECIS OUT_SCREEN_OUTLINE_PRECIS OUT_STRING_PRECIS OUT_STROKE_PRECIS OUT_TT_ONLY_PRECIS OUT_TT_PRECIS PROOF_QUALITY VARIABLE_PITCH'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LOGFONTW guid: (GUID fromString: '{37140088-772d-4f72-aac2-27311f7805d8}')!

LOGFONTW addClassConstant: '_OffsetOf_lfCharSet' value: 16r17!
LOGFONTW addClassConstant: '_OffsetOf_lfClipPrecision' value: 16r19!
LOGFONTW addClassConstant: '_OffsetOf_lfEscapement' value: 16r8!
LOGFONTW addClassConstant: '_OffsetOf_lfFaceName' value: 16r1C!
LOGFONTW addClassConstant: '_OffsetOf_lfHeight' value: 16r0!
LOGFONTW addClassConstant: '_OffsetOf_lfItalic' value: 16r14!
LOGFONTW addClassConstant: '_OffsetOf_lfOrientation' value: 16rC!
LOGFONTW addClassConstant: '_OffsetOf_lfOutPrecision' value: 16r18!
LOGFONTW addClassConstant: '_OffsetOf_lfPitchAndFamily' value: 16r1B!
LOGFONTW addClassConstant: '_OffsetOf_lfQuality' value: 16r1A!
LOGFONTW addClassConstant: '_OffsetOf_lfStrikeOut' value: 16r16!
LOGFONTW addClassConstant: '_OffsetOf_lfUnderline' value: 16r15!
LOGFONTW addClassConstant: '_OffsetOf_lfWeight' value: 16r10!
LOGFONTW addClassConstant: '_OffsetOf_lfWidth' value: 16r4!
LOGFONTW addClassConstant: 'ANTIALIASED_QUALITY' value: 16r4!
LOGFONTW addClassConstant: 'CLEARTYPE_NATURAL_QUALITY' value: 16r6!
LOGFONTW addClassConstant: 'CLEARTYPE_QUALITY' value: 16r5!
LOGFONTW addClassConstant: 'DEFAULT_PITCH' value: 16r0!
LOGFONTW addClassConstant: 'DEFAULT_QUALITY' value: 16r0!
LOGFONTW addClassConstant: 'DRAFT_QUALITY' value: 16r1!
LOGFONTW addClassConstant: 'FIXED_PITCH' value: 16r1!
LOGFONTW addClassConstant: 'NONANTIALIASED_QUALITY' value: 16r3!
LOGFONTW addClassConstant: 'OUT_CHARACTER_PRECIS' value: 16r2!
LOGFONTW addClassConstant: 'OUT_DEFAULT_PRECIS' value: 16r0!
LOGFONTW addClassConstant: 'OUT_DEVICE_PRECIS' value: 16r5!
LOGFONTW addClassConstant: 'OUT_OUTLINE_PRECIS' value: 16r8!
LOGFONTW addClassConstant: 'OUT_PS_ONLY_PRECIS' value: 16rA!
LOGFONTW addClassConstant: 'OUT_RASTER_PRECIS' value: 16r6!
LOGFONTW addClassConstant: 'OUT_SCREEN_OUTLINE_PRECIS' value: 16r9!
LOGFONTW addClassConstant: 'OUT_STRING_PRECIS' value: 16r1!
LOGFONTW addClassConstant: 'OUT_STROKE_PRECIS' value: 16r3!
LOGFONTW addClassConstant: 'OUT_TT_ONLY_PRECIS' value: 16r7!
LOGFONTW addClassConstant: 'OUT_TT_PRECIS' value: 16r4!
LOGFONTW addClassConstant: 'PROOF_QUALITY' value: 16r2!
LOGFONTW addClassConstant: 'VARIABLE_PITCH' value: 16r2!

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

equalExcludingSize: aLOGFONTW
	^self lfFaceName = aLOGFONTW lfFaceName and: 
			[(CRTLibrary default
				memcmp: bytes yourAddress + _OffsetOf_lfEscapement
				buf2: aLOGFONTW bytes yourAddress + _OffsetOf_lfEscapement
				count: ##(_OffsetOf_lfFaceName - _OffsetOf_lfEscapement)) == 0]!

faceName
	"Answer the receiver's lfFaceName field as a UTF-8 encoded string, having trimmed any extra
	nulls."
	
	^self lfFaceName asUtf8String!

faceName: aString
	"Set the receiver's lfFaceName field."
	
	self lfFaceName: aString asUtf16String!

getData: hFont
	GDILibrary default
		getObjectW: hFont
		cbBuffer: self byteSize
		lpvObject: self!

isFixedWidth
	^(self lfPitchAndFamily bitAnd: 16r3) == 1!

isRasterFont
	"The lfOutPrecision can be used to identify a raster font. See [LOGFONTW](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw). Raster fonts as they are essentially pre-rendered bitmaps at certain sizes so they don't scale well to arbitrary point sizes."

	^self lfOutPrecision == OUT_STRING_PRECIS!

lfCharSet
	"Answer the <Integer> value of the receiver's 'lfCharSet' field."

	^bytes byteAtOffset: _OffsetOf_lfCharSet!

lfCharSet: anInteger
	"Set the receiver's 'lfCharSet' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfCharSet put: anInteger!

lfClipPrecision
	"Answer the <Integer> value of the receiver's 'lfClipPrecision' field."

	^bytes byteAtOffset: _OffsetOf_lfClipPrecision!

lfClipPrecision: anInteger
	"Set the receiver's 'lfClipPrecision' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfClipPrecision put: anInteger!

lfEscapement
	"Answer the <Integer> value of the receiver's 'lfEscapement' field."

	^bytes sdwordAtOffset: _OffsetOf_lfEscapement!

lfEscapement: anInteger
	"Set the receiver's 'lfEscapement' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lfEscapement put: anInteger!

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
	bytes wordAtOffset: _OffsetOf_lfFaceName + size put: 0!

lfHeight
	"Answer the <Integer> value of the receiver's 'lfHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_lfHeight!

lfHeight: anInteger
	"Set the receiver's 'lfHeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lfHeight put: anInteger!

lfItalic
	"Answer the <Integer> value of the receiver's 'lfItalic' field."

	^bytes byteAtOffset: _OffsetOf_lfItalic!

lfItalic: anInteger
	"Set the receiver's 'lfItalic' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfItalic put: anInteger!

lfOutPrecision
	"Answer the <Integer> value of the receiver's 'lfOutPrecision' field."

	^bytes byteAtOffset: _OffsetOf_lfOutPrecision!

lfOutPrecision: anInteger
	"Set the receiver's 'lfOutPrecision' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfOutPrecision put: anInteger!

lfPitchAndFamily
	"Answer the <Integer> value of the receiver's 'lfPitchAndFamily' field."

	^bytes byteAtOffset: _OffsetOf_lfPitchAndFamily!

lfPitchAndFamily: anInteger
	"Set the receiver's 'lfPitchAndFamily' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfPitchAndFamily put: anInteger!

lfQuality
	"Answer the <Integer> value of the receiver's 'lfQuality' field."

	^bytes byteAtOffset: _OffsetOf_lfQuality!

lfQuality: anInteger
	"Set the receiver's 'lfQuality' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfQuality put: anInteger!

lfStrikeOut
	"Answer the <Integer> value of the receiver's 'lfStrikeOut' field."

	^bytes byteAtOffset: _OffsetOf_lfStrikeOut!

lfStrikeOut: anInteger
	"Set the receiver's 'lfStrikeOut' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfStrikeOut put: anInteger!

lfUnderline
	"Answer the <Integer> value of the receiver's 'lfUnderline' field."

	^bytes byteAtOffset: _OffsetOf_lfUnderline!

lfUnderline: anInteger
	"Set the receiver's 'lfUnderline' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfUnderline put: anInteger!

lfWeight
	"Answer the <Integer> value of the receiver's 'lfWeight' field."

	^bytes sdwordAtOffset: _OffsetOf_lfWeight!

lfWeight: anInteger
	"Set the receiver's 'lfWeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lfWeight put: anInteger!

lfWidth
	"Answer the <Integer> value of the receiver's 'lfWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_lfWidth!

lfWidth: anInteger
	"Set the receiver's 'lfWidth' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lfWidth put: anInteger! !

!LOGFONTW categoriesForMethods!
equalExcludingSize:!comparing!public! !
faceName!accessing!public! !
faceName:!accessing!public! !
getData:!helpers!private! !
isFixedWidth!public! !
isRasterFont!public!testing! !
lfCharSet!**compiled accessors**!public! !
lfCharSet:!**compiled accessors**!public! !
lfClipPrecision!**compiled accessors**!public! !
lfClipPrecision:!**compiled accessors**!public! !
lfEscapement!**compiled accessors**!public! !
lfEscapement:!**compiled accessors**!public! !
lfFaceName!**compiled accessors**!public! !
lfFaceName:!**compiled accessors**!public! !
lfHeight!**compiled accessors**!public! !
lfHeight:!**compiled accessors**!public! !
lfItalic!**compiled accessors**!public! !
lfItalic:!**compiled accessors**!public! !
lfOutPrecision!**compiled accessors**!public! !
lfOutPrecision:!**compiled accessors**!public! !
lfPitchAndFamily!**compiled accessors**!public! !
lfPitchAndFamily:!**compiled accessors**!public! !
lfQuality!**compiled accessors**!public! !
lfQuality:!**compiled accessors**!public! !
lfStrikeOut!**compiled accessors**!public! !
lfStrikeOut:!**compiled accessors**!public! !
lfUnderline!**compiled accessors**!public! !
lfUnderline:!**compiled accessors**!public! !
lfWeight!**compiled accessors**!public! !
lfWeight:!**compiled accessors**!public! !
lfWidth!**compiled accessors**!public! !
lfWidth:!**compiled accessors**!public! !
!

!LOGFONTW class methodsFor!

defineFields
	"Define the Win32 LOGFONTW structure.
		LOGFONTW compileDefinition.
	"

	self
		defineField: #lfHeight type: SDWORDField new;
		defineField: #lfWidth type: SDWORDField new;
		defineField: #lfEscapement type: SDWORDField new;
		defineField: #lfOrientation type: SDWORDField new beUncompiled;
		defineField: #lfWeight type: SDWORDField new;
		defineField: #lfItalic type: BYTEField new;
		defineField: #lfUnderline type: BYTEField new;
		defineField: #lfStrikeOut type: BYTEField new;
		defineField: #lfCharSet type: BYTEField new;
		defineField: #lfOutPrecision type: BYTEField new;
		defineField: #lfClipPrecision type: BYTEField new;
		defineField: #lfQuality type: BYTEField new;
		defineField: #lfPitchAndFamily type: BYTEField new;
		defineField: #lfFaceName type: (StringField type: Utf16String length: LF_FACESIZE)!

getFieldNames
	^#(#lfHeight #lfWidth #lfEscapement #lfOrientation #lfWeight #lfItalic #lfUnderline #lfStrikeOut #lfCharSet #lfOutPrecision #lfClipPrecision #lfQuality #lfPitchAndFamily #lfFaceName)! !

!LOGFONTW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!constants!private! !
!

