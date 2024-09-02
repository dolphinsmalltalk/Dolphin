"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #TEXTMETRICW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_tmAscent _OffsetOf_tmAveCharWidth _OffsetOf_tmBreakChar _OffsetOf_tmCharSet _OffsetOf_tmDefaultChar _OffsetOf_tmDescent _OffsetOf_tmDigitizedAspectX _OffsetOf_tmDigitizedAspectY _OffsetOf_tmExternalLeading _OffsetOf_tmFirstChar _OffsetOf_tmHeight _OffsetOf_tmInternalLeading _OffsetOf_tmItalic _OffsetOf_tmLastChar _OffsetOf_tmMaxCharWidth _OffsetOf_tmOverhang _OffsetOf_tmPitchAndFamily _OffsetOf_tmStruckOut _OffsetOf_tmUnderlined _OffsetOf_tmWeight'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TEXTMETRICW guid: (GUID fromString: '{ea0d6df4-3794-11d3-979e-0080c8d59432}')!

TEXTMETRICW addClassConstant: '_OffsetOf_tmAscent' value: 16r4!
TEXTMETRICW addClassConstant: '_OffsetOf_tmAveCharWidth' value: 16r14!
TEXTMETRICW addClassConstant: '_OffsetOf_tmBreakChar' value: 16r32!
TEXTMETRICW addClassConstant: '_OffsetOf_tmCharSet' value: 16r38!
TEXTMETRICW addClassConstant: '_OffsetOf_tmDefaultChar' value: 16r30!
TEXTMETRICW addClassConstant: '_OffsetOf_tmDescent' value: 16r8!
TEXTMETRICW addClassConstant: '_OffsetOf_tmDigitizedAspectX' value: 16r24!
TEXTMETRICW addClassConstant: '_OffsetOf_tmDigitizedAspectY' value: 16r28!
TEXTMETRICW addClassConstant: '_OffsetOf_tmExternalLeading' value: 16r10!
TEXTMETRICW addClassConstant: '_OffsetOf_tmFirstChar' value: 16r2C!
TEXTMETRICW addClassConstant: '_OffsetOf_tmHeight' value: 16r0!
TEXTMETRICW addClassConstant: '_OffsetOf_tmInternalLeading' value: 16rC!
TEXTMETRICW addClassConstant: '_OffsetOf_tmItalic' value: 16r34!
TEXTMETRICW addClassConstant: '_OffsetOf_tmLastChar' value: 16r2E!
TEXTMETRICW addClassConstant: '_OffsetOf_tmMaxCharWidth' value: 16r18!
TEXTMETRICW addClassConstant: '_OffsetOf_tmOverhang' value: 16r20!
TEXTMETRICW addClassConstant: '_OffsetOf_tmPitchAndFamily' value: 16r37!
TEXTMETRICW addClassConstant: '_OffsetOf_tmStruckOut' value: 16r36!
TEXTMETRICW addClassConstant: '_OffsetOf_tmUnderlined' value: 16r35!
TEXTMETRICW addClassConstant: '_OffsetOf_tmWeight' value: 16r1C!

TEXTMETRICW comment: '<TEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.TEXTMETRIC'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagTEXTMETRIC {
	long tmHeight;
	long tmAscent;
	long tmDescent;
	long tmInternalLeading;
	long tmExternalLeading;
	long tmAveCharWidth;
	long tmMaxCharWidth;
	long tmWeight;
	long tmOverhang;
	long tmDigitizedAspectX;
	long tmDigitizedAspectY;
	BYTE tmFirstChar;
	BYTE tmLastChar;
	BYTE tmDefaultChar;
	BYTE tmBreakChar;
	BYTE tmItalic;
	BYTE tmUnderlined;
	BYTE tmStruckOut;
	BYTE tmPitchAndFamily;
	BYTE tmCharSet;
} TEXTMETRIC;
'!

!TEXTMETRICW categoriesForClass!Win32-Structs! !

!TEXTMETRICW methodsFor!

emHeight
	^(bytes sdwordAtOffset: _OffsetOf_tmHeight) - (bytes sdwordAtOffset: _OffsetOf_tmInternalLeading)!

tmAscent
	"Answer the <Integer> value of the receiver's 'tmAscent' field."

	^bytes sdwordAtOffset: _OffsetOf_tmAscent!

tmAveCharWidth
	"Answer the <Integer> value of the receiver's 'tmAveCharWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_tmAveCharWidth!

tmBreakChar
	"Answer the <Character> value of the receiver's 'tmBreakChar' field."

	^Character utf16Value: (bytes wordAtOffset: _OffsetOf_tmBreakChar)!

tmCharSet
	"Answer the <Integer> value of the receiver's 'tmCharSet' field."

	^bytes byteAtOffset: _OffsetOf_tmCharSet!

tmDefaultChar
	"Answer the <Character> value of the receiver's 'tmDefaultChar' field."

	^Character utf16Value: (bytes wordAtOffset: _OffsetOf_tmDefaultChar)!

tmDescent
	"Answer the <Integer> value of the receiver's 'tmDescent' field."

	^bytes sdwordAtOffset: _OffsetOf_tmDescent!

tmDigitizedAspectX
	"Answer the <Integer> value of the receiver's 'tmDigitizedAspectX' field."

	^bytes sdwordAtOffset: _OffsetOf_tmDigitizedAspectX!

tmDigitizedAspectY
	"Answer the <Integer> value of the receiver's 'tmDigitizedAspectY' field."

	^bytes sdwordAtOffset: _OffsetOf_tmDigitizedAspectY!

tmExternalLeading
	"Answer the <Integer> value of the receiver's 'tmExternalLeading' field."

	^bytes sdwordAtOffset: _OffsetOf_tmExternalLeading!

tmFirstChar
	"Answer the <Character> value of the receiver's 'tmFirstChar' field."

	^Character utf16Value: (bytes wordAtOffset: _OffsetOf_tmFirstChar)!

tmHeight
	"Answer the <Integer> value of the receiver's 'tmHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_tmHeight!

tmInternalLeading
	"Answer the <Integer> value of the receiver's 'tmInternalLeading' field."

	^bytes sdwordAtOffset: _OffsetOf_tmInternalLeading!

tmItalic
	"Answer the <Integer> value of the receiver's 'tmItalic' field."

	^bytes byteAtOffset: _OffsetOf_tmItalic!

tmLastChar
	"Answer the <Character> value of the receiver's 'tmLastChar' field."

	^Character utf16Value: (bytes wordAtOffset: _OffsetOf_tmLastChar)!

tmMaxCharWidth
	"Answer the <Integer> value of the receiver's 'tmMaxCharWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_tmMaxCharWidth!

tmOverhang
	"Answer the <Integer> value of the receiver's 'tmOverhang' field."

	^bytes sdwordAtOffset: _OffsetOf_tmOverhang!

tmPitchAndFamily
	"Answer the <Integer> value of the receiver's 'tmPitchAndFamily' field."

	^bytes byteAtOffset: _OffsetOf_tmPitchAndFamily!

tmStruckOut
	"Answer the <Integer> value of the receiver's 'tmStruckOut' field."

	^bytes byteAtOffset: _OffsetOf_tmStruckOut!

tmUnderlined
	"Answer the <Integer> value of the receiver's 'tmUnderlined' field."

	^bytes byteAtOffset: _OffsetOf_tmUnderlined!

tmWeight
	"Answer the <Integer> value of the receiver's 'tmWeight' field."

	^bytes sdwordAtOffset: _OffsetOf_tmWeight! !

!TEXTMETRICW categoriesForMethods!
emHeight!accessing!public! !
tmAscent!**compiled accessors**!public! !
tmAveCharWidth!**compiled accessors**!public! !
tmBreakChar!**compiled accessors**!public! !
tmCharSet!**compiled accessors**!public! !
tmDefaultChar!**compiled accessors**!public! !
tmDescent!**compiled accessors**!public! !
tmDigitizedAspectX!**compiled accessors**!public! !
tmDigitizedAspectY!**compiled accessors**!public! !
tmExternalLeading!**compiled accessors**!public! !
tmFirstChar!**compiled accessors**!public! !
tmHeight!**compiled accessors**!public! !
tmInternalLeading!**compiled accessors**!public! !
tmItalic!**compiled accessors**!public! !
tmLastChar!**compiled accessors**!public! !
tmMaxCharWidth!**compiled accessors**!public! !
tmOverhang!**compiled accessors**!public! !
tmPitchAndFamily!**compiled accessors**!public! !
tmStruckOut!**compiled accessors**!public! !
tmUnderlined!**compiled accessors**!public! !
tmWeight!**compiled accessors**!public! !
!

!TEXTMETRICW class methodsFor!

defineFields
	"Define the fields of the TEXTMETRICW structure.
		self compileDefinition
	
		typedef 
		struct tagTEXTMETRIC {
			long tmHeight;
			long tmAscent;
			long tmDescent;
			long tmInternalLeading;
			long tmExternalLeading;
			long tmAveCharWidth;
			long tmMaxCharWidth;
			long tmWeight;
			long tmOverhang;
			long tmDigitizedAspectX;
			long tmDigitizedAspectY;
			WCHAR tmFirstChar;
			WCHAR tmLastChar;
			WCHAR tmDefaultChar;
			WCHAR tmBreakChar;
			BYTE tmItalic;
			BYTE tmUnderlined;
			BYTE tmStruckOut;
			BYTE tmPitchAndFamily;
			BYTE tmCharSet;
		} TEXTMETRICW;
"

	self
		defineField: #tmHeight type: SDWORDField readOnly;
		defineField: #tmAscent type: SDWORDField readOnly;
		defineField: #tmDescent type: SDWORDField readOnly;
		defineField: #tmInternalLeading type: SDWORDField readOnly;
		defineField: #tmExternalLeading type: SDWORDField readOnly;
		defineField: #tmAveCharWidth type: SDWORDField readOnly;
		defineField: #tmMaxCharWidth type: SDWORDField readOnly;
		defineField: #tmWeight type: SDWORDField readOnly;
		defineField: #tmOverhang type: SDWORDField readOnly;
		defineField: #tmDigitizedAspectX type: SDWORDField readOnly;
		defineField: #tmDigitizedAspectY type: SDWORDField readOnly;
		defineField: #tmFirstChar type: WCHARField readOnly;
		defineField: #tmLastChar type: WCHARField readOnly;
		defineField: #tmDefaultChar type: WCHARField readOnly;
		defineField: #tmBreakChar type: WCHARField readOnly;
		defineField: #tmItalic type: BYTEField readOnly;
		defineField: #tmUnderlined type: BYTEField readOnly;
		defineField: #tmStruckOut type: BYTEField readOnly;
		defineField: #tmPitchAndFamily type: BYTEField readOnly;
		defineField: #tmCharSet type: BYTEField readOnly!

getFieldNames
	^#(#tmHeight #tmAscent #tmDescent #tmInternalLeading #tmExternalLeading #tmAveCharWidth #tmMaxCharWidth #tmWeight #tmOverhang #tmDigitizedAspectX #tmDigitizedAspectY #tmFirstChar #tmLastChar #tmDefaultChar #tmBreakChar #tmItalic #tmUnderlined #tmStruckOut #tmPitchAndFamily #tmCharSet)!

packing
	"Uses non-standard packing"

	^4! !

!TEXTMETRICW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

