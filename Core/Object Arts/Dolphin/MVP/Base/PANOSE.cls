"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #PANOSE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PANOSE guid: (GUID fromString: '{AB0B82A7-5304-49C0-9937-E7474BC1A82F}')!
PANOSE comment: '<PANOSE> is an <ExternalStructure> class to wrap the struct ''Win.PANOSE'' from type information in the ''Windows API (ANSI)'' library.
'!
!PANOSE categoriesForClass!Win-Structs! !
!PANOSE methodsFor!

bArmStyle
	"Answer the receiver's bArmStyle field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bArmStyle)!

bContrast
	"Answer the receiver's bContrast field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bContrast)!

bFamilyType
	"Answer the receiver's bFamilyType field as a Smalltalk object."

	^bytes byteAtOffset: 0!

bLetterform
	"Answer the receiver's bLetterform field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bLetterform)!

bMidline
	"Answer the receiver's bMidline field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bMidline)!

bProportion
	"Answer the receiver's bProportion field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bProportion)!

bSerifStyle
	"Answer the receiver's bSerifStyle field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bSerifStyle)!

bStrokeVariation
	"Answer the receiver's bStrokeVariation field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bStrokeVariation)!

bWeight
	"Answer the receiver's bWeight field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bWeight)!

bXHeight
	"Answer the receiver's bXHeight field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bXHeight)! !
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
		defineField: #bXHeight type: BYTEField readOnly! !
!PANOSE class categoriesFor: #defineFields!initializing!public! !

