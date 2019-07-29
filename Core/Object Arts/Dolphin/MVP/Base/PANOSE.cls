"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #PANOSE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_bArmStyle _OffsetOf_bContrast _OffsetOf_bFamilyType _OffsetOf_bLetterform _OffsetOf_bMidline _OffsetOf_bProportion _OffsetOf_bSerifStyle _OffsetOf_bStrokeVariation _OffsetOf_bWeight _OffsetOf_bXHeight'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PANOSE guid: (GUID fromString: '{ab0b82a7-5304-49c0-9937-e7474bc1a82f}')!
PANOSE addClassConstant: '_OffsetOf_bArmStyle' value: 16r6!
PANOSE addClassConstant: '_OffsetOf_bContrast' value: 16r4!
PANOSE addClassConstant: '_OffsetOf_bFamilyType' value: 16r0!
PANOSE addClassConstant: '_OffsetOf_bLetterform' value: 16r7!
PANOSE addClassConstant: '_OffsetOf_bMidline' value: 16r8!
PANOSE addClassConstant: '_OffsetOf_bProportion' value: 16r3!
PANOSE addClassConstant: '_OffsetOf_bSerifStyle' value: 16r1!
PANOSE addClassConstant: '_OffsetOf_bStrokeVariation' value: 16r5!
PANOSE addClassConstant: '_OffsetOf_bWeight' value: 16r2!
PANOSE addClassConstant: '_OffsetOf_bXHeight' value: 16r9!
PANOSE comment: '<PANOSE> is an <ExternalStructure> class to wrap the struct ''Win.PANOSE'' from type information in the ''Windows API (ANSI)'' library.
'!
!PANOSE categoriesForClass!Win-Structs! !
!PANOSE methodsFor!

bArmStyle
	"Answer the <Integer> value of the receiver's 'bArmStyle' field."

	^bytes byteAtOffset: _OffsetOf_bArmStyle!

bContrast
	"Answer the <Integer> value of the receiver's 'bContrast' field."

	^bytes byteAtOffset: _OffsetOf_bContrast!

bFamilyType
	"Answer the <Integer> value of the receiver's 'bFamilyType' field."

	^bytes byteAtOffset: _OffsetOf_bFamilyType!

bLetterform
	"Answer the <Integer> value of the receiver's 'bLetterform' field."

	^bytes byteAtOffset: _OffsetOf_bLetterform!

bMidline
	"Answer the <Integer> value of the receiver's 'bMidline' field."

	^bytes byteAtOffset: _OffsetOf_bMidline!

bProportion
	"Answer the <Integer> value of the receiver's 'bProportion' field."

	^bytes byteAtOffset: _OffsetOf_bProportion!

bSerifStyle
	"Answer the <Integer> value of the receiver's 'bSerifStyle' field."

	^bytes byteAtOffset: _OffsetOf_bSerifStyle!

bStrokeVariation
	"Answer the <Integer> value of the receiver's 'bStrokeVariation' field."

	^bytes byteAtOffset: _OffsetOf_bStrokeVariation!

bWeight
	"Answer the <Integer> value of the receiver's 'bWeight' field."

	^bytes byteAtOffset: _OffsetOf_bWeight!

bXHeight
	"Answer the <Integer> value of the receiver's 'bXHeight' field."

	^bytes byteAtOffset: _OffsetOf_bXHeight! !
!PANOSE categoriesFor: #bArmStyle!**compiled accessors**!public! !
!PANOSE categoriesFor: #bContrast!**compiled accessors**!public! !
!PANOSE categoriesFor: #bFamilyType!**compiled accessors**!public! !
!PANOSE categoriesFor: #bLetterform!**compiled accessors**!public! !
!PANOSE categoriesFor: #bMidline!**compiled accessors**!public! !
!PANOSE categoriesFor: #bProportion!**compiled accessors**!public! !
!PANOSE categoriesFor: #bSerifStyle!**compiled accessors**!public! !
!PANOSE categoriesFor: #bStrokeVariation!**compiled accessors**!public! !
!PANOSE categoriesFor: #bWeight!**compiled accessors**!public! !
!PANOSE categoriesFor: #bXHeight!**compiled accessors**!public! !

!PANOSE class methodsFor!

defineFields
	"Define the fields of the PANOSE structure.
		PANOSE compileDefinition
	
		typedef 
		struct tagPANOSE {
			BYTE bFamilyType;
			BYTE bSerifStyle;
			BYTE bWeight;
			BYTE bProportion;
			BYTE bContrast;
			BYTE bStrokeVariation;
			BYTE bArmStyle;
			BYTE bLetterform;
			BYTE bMidline;
			BYTE bXHeight;
		} PANOSE;
"

	self
		defineField: #bFamilyType type: BYTEField readOnly;
		defineField: #bSerifStyle type: BYTEField readOnly;
		defineField: #bWeight type: BYTEField readOnly;
		defineField: #bProportion type: BYTEField readOnly;
		defineField: #bContrast type: BYTEField readOnly;
		defineField: #bStrokeVariation type: BYTEField readOnly;
		defineField: #bArmStyle type: BYTEField readOnly;
		defineField: #bLetterform type: BYTEField readOnly;
		defineField: #bMidline type: BYTEField readOnly;
		defineField: #bXHeight type: BYTEField readOnly!

getFieldNames
	^#(#bFamilyType #bSerifStyle #bWeight #bProportion #bContrast #bStrokeVariation #bArmStyle #bLetterform #bMidline #bXHeight)! !
!PANOSE class categoriesFor: #defineFields!public!template definition! !
!PANOSE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

