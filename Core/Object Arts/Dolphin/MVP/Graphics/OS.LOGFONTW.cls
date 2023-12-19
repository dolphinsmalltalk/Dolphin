"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.LOGFONTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_LOGFONTW_Size' -> 16r5C.
			'_OffsetOf_lfCharSet' -> 16r17.
			'_OffsetOf_lfClipPrecision' -> 16r19.
			'_OffsetOf_lfEscapement' -> 16r8.
			'_OffsetOf_lfFaceName' -> 16r1C.
			'_OffsetOf_lfHeight' -> 16r0.
			'_OffsetOf_lfItalic' -> 16r14.
			'_OffsetOf_lfOrientation' -> 16rC.
			'_OffsetOf_lfOutPrecision' -> 16r18.
			'_OffsetOf_lfPitchAndFamily' -> 16r1B.
			'_OffsetOf_lfQuality' -> 16r1A.
			'_OffsetOf_lfStrikeOut' -> 16r16.
			'_OffsetOf_lfUnderline' -> 16r15.
			'_OffsetOf_lfWeight' -> 16r10.
			'_OffsetOf_lfWidth' -> 16r4
		}!
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

faceName
	"Answer the receiver's lfFaceName field as a UTF-8 encoded string."
	
	^self lfFaceName asUtf8String!

faceName: aString
	"Set the receiver's lfFaceName field."
	
	self lfFaceName: aString asUtf16String!

isFixedWidth
	^(self lfPitchAndFamily bitAnd: 16r3) == 1!

lfCharSet
	"Answer the <Integer> value of the receiver's 'lfCharSet' field."

	^bytes uint8AtOffset: _OffsetOf_lfCharSet!

lfCharSet: anInteger
	"Set the receiver's 'lfCharSet' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_lfCharSet put: anInteger!

lfEscapement
	"Answer the <Integer> value of the receiver's 'lfEscapement' field."

	^bytes int32AtOffset: _OffsetOf_lfEscapement!

lfEscapement: anInteger
	"Set the receiver's 'lfEscapement' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_lfEscapement put: anInteger!

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
	bytes uint16AtOffset: _OffsetOf_lfFaceName + size put: 0!

lfHeight
	"Answer the <Integer> value of the receiver's 'lfHeight' field."

	^bytes int32AtOffset: _OffsetOf_lfHeight!

lfHeight: anInteger
	"Set the receiver's 'lfHeight' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_lfHeight put: anInteger!

lfItalic
	"Answer the <Integer> value of the receiver's 'lfItalic' field."

	^bytes uint8AtOffset: _OffsetOf_lfItalic!

lfItalic: anInteger
	"Set the receiver's 'lfItalic' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_lfItalic put: anInteger!

lfPitchAndFamily
	"Answer the <Integer> value of the receiver's 'lfPitchAndFamily' field."

	^bytes uint8AtOffset: _OffsetOf_lfPitchAndFamily!

lfPitchAndFamily: anInteger
	"Set the receiver's 'lfPitchAndFamily' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_lfPitchAndFamily put: anInteger!

lfQuality
	"Answer the <Integer> value of the receiver's 'lfQuality' field."

	^bytes uint8AtOffset: _OffsetOf_lfQuality!

lfQuality: anInteger
	"Set the receiver's 'lfQuality' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_lfQuality put: anInteger!

lfStrikeOut
	"Answer the <Integer> value of the receiver's 'lfStrikeOut' field."

	^bytes uint8AtOffset: _OffsetOf_lfStrikeOut!

lfStrikeOut: anInteger
	"Set the receiver's 'lfStrikeOut' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_lfStrikeOut put: anInteger!

lfUnderline
	"Answer the <Integer> value of the receiver's 'lfUnderline' field."

	^bytes uint8AtOffset: _OffsetOf_lfUnderline!

lfUnderline: anInteger
	"Set the receiver's 'lfUnderline' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_lfUnderline put: anInteger!

lfWeight
	"Answer the <Integer> value of the receiver's 'lfWeight' field."

	^bytes int32AtOffset: _OffsetOf_lfWeight!

lfWeight: anInteger
	"Set the receiver's 'lfWeight' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_lfWeight put: anInteger!

lfWidth
	"Answer the <Integer> value of the receiver's 'lfWidth' field."

	^bytes int32AtOffset: _OffsetOf_lfWidth!

lfWidth: anInteger
	"Set the receiver's 'lfWidth' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_lfWidth put: anInteger! !
!OS.LOGFONTW categoriesForMethods!
faceName!accessing!public! !
faceName:!accessing!public! !
isFixedWidth!public! !
lfCharSet!**compiled accessors**!public! !
lfCharSet:!**compiled accessors**!public! !
lfEscapement!**compiled accessors**!public! !
lfEscapement:!**compiled accessors**!public! !
lfFaceName!**compiled accessors**!public! !
lfFaceName:!**compiled accessors**!public! !
lfHeight!**compiled accessors**!public! !
lfHeight:!**compiled accessors**!public! !
lfItalic!**compiled accessors**!public! !
lfItalic:!**compiled accessors**!public! !
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

!OS.LOGFONTW class methodsFor!

byteSize
	^_LOGFONTW_Size!

defineFields
	"Define the Win32 LOGFONTW structure.
		LOGFONTW compileDefinition.
	"

	self
		defineField: #lfHeight type: Int32Field new;
		defineField: #lfWidth type: Int32Field new;
		defineField: #lfEscapement type: Int32Field new;
		defineField: #lfOrientation type: Int32Field new beUncompiled;
		defineField: #lfWeight type: Int32Field new;
		defineField: #lfItalic type: UInt8Field new;
		defineField: #lfUnderline type: UInt8Field new;
		defineField: #lfStrikeOut type: UInt8Field new;
		defineField: #lfCharSet type: UInt8Field new;
		defineField: #lfOutPrecision type: UInt8Field new beUncompiled;
		defineField: #lfClipPrecision type: UInt8Field new beUncompiled;
		defineField: #lfQuality type: UInt8Field new;
		defineField: #lfPitchAndFamily type: UInt8Field new;
		defineField: #lfFaceName type: (StringField type: Utf16String length: OS.Win32Constants.LF_FACESIZE)!

getFieldNames
	^#(#lfHeight #lfWidth #lfEscapement #lfOrientation #lfWeight #lfItalic #lfUnderline #lfStrikeOut #lfCharSet #lfOutPrecision #lfClipPrecision #lfQuality #lfPitchAndFamily #lfFaceName)! !
!OS.LOGFONTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!constants!private! !
!

