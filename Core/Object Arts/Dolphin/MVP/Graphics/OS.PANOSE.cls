﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.PANOSE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_bArmStyle' -> 16r6.
			'_OffsetOf_bContrast' -> 16r4.
			'_OffsetOf_bFamilyType' -> 16r0.
			'_OffsetOf_bLetterform' -> 16r7.
			'_OffsetOf_bMidline' -> 16r8.
			'_OffsetOf_bProportion' -> 16r3.
			'_OffsetOf_bSerifStyle' -> 16r1.
			'_OffsetOf_bStrokeVariation' -> 16r5.
			'_OffsetOf_bWeight' -> 16r2.
			'_OffsetOf_bXHeight' -> 16r9.
			'_PANOSE_Size' -> 16rA
		}!

OS.PANOSE guid: (Core.GUID fromString: '{fd0c19a2-34cf-4a99-a522-d4fd0cc0f003}')!

OS.PANOSE comment: ''!

!OS.PANOSE methodsFor!

bArmStyle
	"Answer the <Integer> value of the receiver's 'bArmStyle' field."

	^bytes uint8AtOffset: _OffsetOf_bArmStyle!

bContrast
	"Answer the <Integer> value of the receiver's 'bContrast' field."

	^bytes uint8AtOffset: _OffsetOf_bContrast!

bFamilyType
	"Answer the <Integer> value of the receiver's 'bFamilyType' field."

	^bytes uint8AtOffset: _OffsetOf_bFamilyType!

bLetterform
	"Answer the <Integer> value of the receiver's 'bLetterform' field."

	^bytes uint8AtOffset: _OffsetOf_bLetterform!

bMidline
	"Answer the <Integer> value of the receiver's 'bMidline' field."

	^bytes uint8AtOffset: _OffsetOf_bMidline!

bProportion
	"Answer the <Integer> value of the receiver's 'bProportion' field."

	^bytes uint8AtOffset: _OffsetOf_bProportion!

bSerifStyle
	"Answer the <Integer> value of the receiver's 'bSerifStyle' field."

	^bytes uint8AtOffset: _OffsetOf_bSerifStyle!

bStrokeVariation
	"Answer the <Integer> value of the receiver's 'bStrokeVariation' field."

	^bytes uint8AtOffset: _OffsetOf_bStrokeVariation!

bWeight
	"Answer the <Integer> value of the receiver's 'bWeight' field."

	^bytes uint8AtOffset: _OffsetOf_bWeight!

bXHeight
	"Answer the <Integer> value of the receiver's 'bXHeight' field."

	^bytes uint8AtOffset: _OffsetOf_bXHeight! !

!OS.PANOSE categoriesForMethods!
bArmStyle!**compiled accessors**!public! !
bContrast!**compiled accessors**!public! !
bFamilyType!**compiled accessors**!public! !
bLetterform!**compiled accessors**!public! !
bMidline!**compiled accessors**!public! !
bProportion!**compiled accessors**!public! !
bSerifStyle!**compiled accessors**!public! !
bStrokeVariation!**compiled accessors**!public! !
bWeight!**compiled accessors**!public! !
bXHeight!**compiled accessors**!public! !
!

!OS.PANOSE class methodsFor!

byteSize
	^_PANOSE_Size!

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
		defineField: #bFamilyType type: UInt8Field readOnly;
		defineField: #bSerifStyle type: UInt8Field readOnly;
		defineField: #bWeight type: UInt8Field readOnly;
		defineField: #bProportion type: UInt8Field readOnly;
		defineField: #bContrast type: UInt8Field readOnly;
		defineField: #bStrokeVariation type: UInt8Field readOnly;
		defineField: #bArmStyle type: UInt8Field readOnly;
		defineField: #bLetterform type: UInt8Field readOnly;
		defineField: #bMidline type: UInt8Field readOnly;
		defineField: #bXHeight type: UInt8Field readOnly!

getFieldNames
	^#(#bFamilyType #bSerifStyle #bWeight #bProportion #bContrast #bStrokeVariation #bArmStyle #bLetterform #bMidline #bXHeight)! !

!OS.PANOSE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

