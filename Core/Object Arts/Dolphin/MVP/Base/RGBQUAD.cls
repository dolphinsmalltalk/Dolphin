"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #RGBQUAD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RGBQUAD guid: (GUID fromString: '{87b4c60d-026e-11d3-9fd7-00a0cc3e4a32}')!
RGBQUAD comment: '<RGBQUAD> is an <ExternalStructure> class to wrap the struct ''Win.RGBQUAD'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagRGBQUAD {
	BYTE rgbBlue;
	BYTE rgbGreen;
	BYTE rgbRed;
	BYTE rgbReserved;
} RGBQUAD;
'!
!RGBQUAD categoriesForClass!External-Data-Structured-Win32! !
!RGBQUAD methodsFor!

asColor
	"Answer the <Color> equivalent of the receiver."

	^Color fromInteger: (bytes dwordAtOffset: 0)!

rgbBlue
	"Answer the receiver's rgbBlue field as a Smalltalk object."

	^bytes byteAtOffset: 0!

rgbBlue: anObject 
	"Set the receiver's rgbBlue field to the value of anObject."

	bytes byteAtOffset: 0 put: anObject!

rgbGreen
	"Answer the receiver's rgbGreen field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #rgbGreen)!

rgbGreen: anObject 
	"Set the receiver's rgbGreen field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #rgbGreen) put: anObject!

rgbRed
	"Answer the receiver's rgbRed field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #rgbRed)!

rgbRed: anObject 
	"Set the receiver's rgbRed field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #rgbRed) put: anObject! !
!RGBQUAD categoriesFor: #asColor!converting!public! !
!RGBQUAD categoriesFor: #rgbBlue!**compiled accessors**!public! !
!RGBQUAD categoriesFor: #rgbBlue:!**compiled accessors**!public! !
!RGBQUAD categoriesFor: #rgbGreen!**compiled accessors**!public! !
!RGBQUAD categoriesFor: #rgbGreen:!**compiled accessors**!public! !
!RGBQUAD categoriesFor: #rgbRed!**compiled accessors**!public! !
!RGBQUAD categoriesFor: #rgbRed:!**compiled accessors**!public! !

!RGBQUAD class methodsFor!

defineFields
	"Define the fields of the RGBQUAD structure.
		RGBQUAD compileDefinition
	
		typedef 
		struct tagRGBQUAD {
			BYTE rgbBlue;
			BYTE rgbGreen;
			BYTE rgbRed;
			BYTE rgbReserved;
		} RGBQUAD;
"

	self
		defineField: #rgbBlue type: BYTEField new;
		defineField: #rgbGreen type: BYTEField new;
		defineField: #rgbRed type: BYTEField new;
		defineField: #rgbReserved type: BYTEField filler!

fromColor: aColor 
	"Answer a new instance of the receiver equivalent to the <Color> argument."

	| rgb |
	rgb := aColor asRGB.
	^(self new)
		rgbRed: rgb red;
		rgbGreen: rgb green;
		rgbBlue: rgb blue;
		yourself! !
!RGBQUAD class categoriesFor: #defineFields!initializing!public! !
!RGBQUAD class categoriesFor: #fromColor:!instance creation!public! !

