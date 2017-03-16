"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TEXTMETRIC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TEXTMETRIC guid: (GUID fromString: '{ea0d6df4-3794-11d3-979e-0080c8d59432}')!
TEXTMETRIC comment: '<TEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.TEXTMETRIC'' from type information in the ''Windows API (ANSI)'' library.

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
!TEXTMETRIC categoriesForClass!Win32-Structs! !
!TEXTMETRIC methodsFor!

tmAscent
	"Answer the receiver's tmAscent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmAscent)!

tmAveCharWidth
	"Answer the receiver's tmAveCharWidth field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmAveCharWidth)!

tmBreakChar
	"Answer the receiver's tmBreakChar field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmBreakChar)!

tmCharSet
	"Answer the receiver's tmCharSet field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmCharSet)!

tmDefaultChar
	"Answer the receiver's tmDefaultChar field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmDefaultChar)!

tmDescent
	"Answer the receiver's tmDescent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmDescent)!

tmDigitizedAspectX
	"Answer the receiver's tmDigitizedAspectX field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmDigitizedAspectX)!

tmDigitizedAspectY
	"Answer the receiver's tmDigitizedAspectY field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmDigitizedAspectY)!

tmExternalLeading
	"Answer the receiver's tmExternalLeading field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmExternalLeading)!

tmFirstChar
	"Answer the receiver's tmFirstChar field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmFirstChar)!

tmHeight
	"Answer the receiver's tmHeight field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

tmInternalLeading
	"Answer the receiver's tmInternalLeading field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmInternalLeading)!

tmItalic
	"Answer the receiver's tmItalic field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmItalic)!

tmLastChar
	"Answer the receiver's tmLastChar field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmLastChar)!

tmMaxCharWidth
	"Answer the receiver's tmMaxCharWidth field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmMaxCharWidth)!

tmOverhang
	"Answer the receiver's tmOverhang field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmOverhang)!

tmPitchAndFamily
	"Answer the receiver's tmPitchAndFamily field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmPitchAndFamily)!

tmStruckOut
	"Answer the receiver's tmStruckOut field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmStruckOut)!

tmUnderlined
	"Answer the receiver's tmUnderlined field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #tmUnderlined)!

tmWeight
	"Answer the receiver's tmWeight field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #tmWeight)! !
!TEXTMETRIC categoriesFor: #tmAscent!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmAveCharWidth!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmBreakChar!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmCharSet!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmDefaultChar!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmDescent!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmDigitizedAspectX!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmDigitizedAspectY!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmExternalLeading!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmFirstChar!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmHeight!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmInternalLeading!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmItalic!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmLastChar!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmMaxCharWidth!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmOverhang!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmPitchAndFamily!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmStruckOut!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmUnderlined!**compiled accessors**!public! !
!TEXTMETRIC categoriesFor: #tmWeight!**compiled accessors**!public! !

!TEXTMETRIC class methodsFor!

defineFields
	"Define the fields of the TEXTMETRIC structure.
		TEXTMETRIC compileDefinition
	
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
		defineField: #tmFirstChar type: BYTEField readOnly;
		defineField: #tmLastChar type: BYTEField readOnly;
		defineField: #tmDefaultChar type: BYTEField readOnly;
		defineField: #tmBreakChar type: BYTEField readOnly;
		defineField: #tmItalic type: BYTEField readOnly;
		defineField: #tmUnderlined type: BYTEField readOnly;
		defineField: #tmStruckOut type: BYTEField readOnly;
		defineField: #tmPitchAndFamily type: BYTEField readOnly;
		defineField: #tmCharSet type: BYTEField readOnly!

packing
	"Uses non-standard packing"

	^4! !
!TEXTMETRIC class categoriesFor: #defineFields!initializing!public! !
!TEXTMETRIC class categoriesFor: #packing!constants!public! !

