"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.TEXTMETRICW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_tmAscent' -> 16r4.
		'_OffsetOf_tmAveCharWidth' -> 16r14.
		'_OffsetOf_tmBreakChar' -> 16r32.
		'_OffsetOf_tmCharSet' -> 16r38.
		'_OffsetOf_tmDefaultChar' -> 16r30.
		'_OffsetOf_tmDescent' -> 16r8.
		'_OffsetOf_tmDigitizedAspectX' -> 16r24.
		'_OffsetOf_tmDigitizedAspectY' -> 16r28.
		'_OffsetOf_tmExternalLeading' -> 16r10.
		'_OffsetOf_tmFirstChar' -> 16r2C.
		'_OffsetOf_tmHeight' -> 16r0.
		'_OffsetOf_tmInternalLeading' -> 16rC.
		'_OffsetOf_tmItalic' -> 16r34.
		'_OffsetOf_tmLastChar' -> 16r2E.
		'_OffsetOf_tmMaxCharWidth' -> 16r18.
		'_OffsetOf_tmOverhang' -> 16r20.
		'_OffsetOf_tmPitchAndFamily' -> 16r37.
		'_OffsetOf_tmStruckOut' -> 16r36.
		'_OffsetOf_tmUnderlined' -> 16r35.
		'_OffsetOf_tmWeight' -> 16r1C
	}!
OS.TEXTMETRICW guid: (Core.GUID fromString: '{ea0d6df4-3794-11d3-979e-0080c8d59432}')!
OS.TEXTMETRICW comment: '<TEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.TEXTMETRIC'' from type information in the ''Windows API (ANSI)'' library.

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
!OS.TEXTMETRICW categoriesForClass!Win32-Structs! !
!OS.TEXTMETRICW methodsFor!

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
!OS.TEXTMETRICW categoriesFor: #tmAscent!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmAveCharWidth!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmBreakChar!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmCharSet!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmDefaultChar!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmDescent!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmDigitizedAspectX!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmDigitizedAspectY!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmExternalLeading!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmFirstChar!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmHeight!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmInternalLeading!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmItalic!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmLastChar!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmMaxCharWidth!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmOverhang!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmPitchAndFamily!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmStruckOut!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmUnderlined!**compiled accessors**!public! !
!OS.TEXTMETRICW categoriesFor: #tmWeight!**compiled accessors**!public! !

!OS.TEXTMETRICW class methodsFor!

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
!OS.TEXTMETRICW class categoriesFor: #defineFields!public!template definition! !
!OS.TEXTMETRICW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.TEXTMETRICW class categoriesFor: #packing!constants!public! !

