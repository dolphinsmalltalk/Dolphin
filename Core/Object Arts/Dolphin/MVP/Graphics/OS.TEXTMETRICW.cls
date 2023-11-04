"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.TEXTMETRICW'
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
			'_OffsetOf_tmWeight' -> 16r1C.
			'_TEXTMETRICW_Size' -> 16r3C
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

	^bytes int32AtOffset: _OffsetOf_tmAscent!

tmAveCharWidth
	"Answer the <Integer> value of the receiver's 'tmAveCharWidth' field."

	^bytes int32AtOffset: _OffsetOf_tmAveCharWidth!

tmBreakChar
	"Answer the <Character> value of the receiver's 'tmBreakChar' field."

	^Character utf16Value: (bytes uint16AtOffset: _OffsetOf_tmBreakChar)!

tmCharSet
	"Answer the <Integer> value of the receiver's 'tmCharSet' field."

	^bytes uint8AtOffset: _OffsetOf_tmCharSet!

tmDefaultChar
	"Answer the <Character> value of the receiver's 'tmDefaultChar' field."

	^Character utf16Value: (bytes uint16AtOffset: _OffsetOf_tmDefaultChar)!

tmDescent
	"Answer the <Integer> value of the receiver's 'tmDescent' field."

	^bytes int32AtOffset: _OffsetOf_tmDescent!

tmDigitizedAspectX
	"Answer the <Integer> value of the receiver's 'tmDigitizedAspectX' field."

	^bytes int32AtOffset: _OffsetOf_tmDigitizedAspectX!

tmDigitizedAspectY
	"Answer the <Integer> value of the receiver's 'tmDigitizedAspectY' field."

	^bytes int32AtOffset: _OffsetOf_tmDigitizedAspectY!

tmExternalLeading
	"Answer the <Integer> value of the receiver's 'tmExternalLeading' field."

	^bytes int32AtOffset: _OffsetOf_tmExternalLeading!

tmFirstChar
	"Answer the <Character> value of the receiver's 'tmFirstChar' field."

	^Character utf16Value: (bytes uint16AtOffset: _OffsetOf_tmFirstChar)!

tmHeight
	"Answer the <Integer> value of the receiver's 'tmHeight' field."

	^bytes int32AtOffset: _OffsetOf_tmHeight!

tmInternalLeading
	"Answer the <Integer> value of the receiver's 'tmInternalLeading' field."

	^bytes int32AtOffset: _OffsetOf_tmInternalLeading!

tmItalic
	"Answer the <Integer> value of the receiver's 'tmItalic' field."

	^bytes uint8AtOffset: _OffsetOf_tmItalic!

tmLastChar
	"Answer the <Character> value of the receiver's 'tmLastChar' field."

	^Character utf16Value: (bytes uint16AtOffset: _OffsetOf_tmLastChar)!

tmMaxCharWidth
	"Answer the <Integer> value of the receiver's 'tmMaxCharWidth' field."

	^bytes int32AtOffset: _OffsetOf_tmMaxCharWidth!

tmOverhang
	"Answer the <Integer> value of the receiver's 'tmOverhang' field."

	^bytes int32AtOffset: _OffsetOf_tmOverhang!

tmPitchAndFamily
	"Answer the <Integer> value of the receiver's 'tmPitchAndFamily' field."

	^bytes uint8AtOffset: _OffsetOf_tmPitchAndFamily!

tmStruckOut
	"Answer the <Integer> value of the receiver's 'tmStruckOut' field."

	^bytes uint8AtOffset: _OffsetOf_tmStruckOut!

tmUnderlined
	"Answer the <Integer> value of the receiver's 'tmUnderlined' field."

	^bytes uint8AtOffset: _OffsetOf_tmUnderlined!

tmWeight
	"Answer the <Integer> value of the receiver's 'tmWeight' field."

	^bytes int32AtOffset: _OffsetOf_tmWeight! !
!OS.TEXTMETRICW categoriesForMethods!
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

!OS.TEXTMETRICW class methodsFor!

byteSize
	^_TEXTMETRICW_Size!

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
		defineField: #tmHeight type: Int32Field readOnly;
		defineField: #tmAscent type: Int32Field readOnly;
		defineField: #tmDescent type: Int32Field readOnly;
		defineField: #tmInternalLeading type: Int32Field readOnly;
		defineField: #tmExternalLeading type: Int32Field readOnly;
		defineField: #tmAveCharWidth type: Int32Field readOnly;
		defineField: #tmMaxCharWidth type: Int32Field readOnly;
		defineField: #tmWeight type: Int32Field readOnly;
		defineField: #tmOverhang type: Int32Field readOnly;
		defineField: #tmDigitizedAspectX type: Int32Field readOnly;
		defineField: #tmDigitizedAspectY type: Int32Field readOnly;
		defineField: #tmFirstChar type: WCHARField readOnly;
		defineField: #tmLastChar type: WCHARField readOnly;
		defineField: #tmDefaultChar type: WCHARField readOnly;
		defineField: #tmBreakChar type: WCHARField readOnly;
		defineField: #tmItalic type: UInt8Field readOnly;
		defineField: #tmUnderlined type: UInt8Field readOnly;
		defineField: #tmStruckOut type: UInt8Field readOnly;
		defineField: #tmPitchAndFamily type: UInt8Field readOnly;
		defineField: #tmCharSet type: UInt8Field readOnly!

getFieldNames
	^#(#tmHeight #tmAscent #tmDescent #tmInternalLeading #tmExternalLeading #tmAveCharWidth #tmMaxCharWidth #tmWeight #tmOverhang #tmDigitizedAspectX #tmDigitizedAspectY #tmFirstChar #tmLastChar #tmDefaultChar #tmBreakChar #tmItalic #tmUnderlined #tmStruckOut #tmPitchAndFamily #tmCharSet)!

packing
	"Uses non-standard packing"

	^4! !
!OS.TEXTMETRICW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

