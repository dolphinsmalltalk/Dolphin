"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.RGBQUAD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_rgbBlue' -> 16r0.
		'_OffsetOf_rgbGreen' -> 16r1.
		'_OffsetOf_rgbRed' -> 16r2.
		'_OffsetOf_rgbReserved' -> 16r3
	}!
OS.RGBQUAD guid: (Core.GUID fromString: '{87b4c60d-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.RGBQUAD comment: '<RGBQUAD> is an <ExternalStructure> class to wrap the struct ''Win.RGBQUAD'' from type information in the ''Windows API (ANSI)'' library.

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
!OS.RGBQUAD categoriesForClass!External-Data-Structured-Win32! !
!OS.RGBQUAD methodsFor!

asColor
	"Answer the <Color> equivalent of the receiver."

	^Graphics.Color fromRgbCode: (bytes dwordAtOffset: 0)!

rgbBlue
	"Answer the <Integer> value of the receiver's 'rgbBlue' field."

	^bytes byteAtOffset: _OffsetOf_rgbBlue!

rgbBlue: anInteger
	"Set the receiver's 'rgbBlue' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_rgbBlue put: anInteger!

rgbGreen
	"Answer the <Integer> value of the receiver's 'rgbGreen' field."

	^bytes byteAtOffset: _OffsetOf_rgbGreen!

rgbGreen: anInteger
	"Set the receiver's 'rgbGreen' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_rgbGreen put: anInteger!

rgbRed
	"Answer the <Integer> value of the receiver's 'rgbRed' field."

	^bytes byteAtOffset: _OffsetOf_rgbRed!

rgbRed: anInteger
	"Set the receiver's 'rgbRed' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_rgbRed put: anInteger! !
!OS.RGBQUAD categoriesFor: #asColor!converting!public! !
!OS.RGBQUAD categoriesFor: #rgbBlue!**compiled accessors**!public! !
!OS.RGBQUAD categoriesFor: #rgbBlue:!**compiled accessors**!public! !
!OS.RGBQUAD categoriesFor: #rgbGreen!**compiled accessors**!public! !
!OS.RGBQUAD categoriesFor: #rgbGreen:!**compiled accessors**!public! !
!OS.RGBQUAD categoriesFor: #rgbRed!**compiled accessors**!public! !
!OS.RGBQUAD categoriesFor: #rgbRed:!**compiled accessors**!public! !

!OS.RGBQUAD class methodsFor!

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

	^self new bytes
		dwordAtOffset: 0 put: aColor rgbCode;
		yourself!

getFieldNames
	^#(#rgbBlue #rgbGreen #rgbRed)! !
!OS.RGBQUAD class categoriesFor: #defineFields!public!template definition! !
!OS.RGBQUAD class categoriesFor: #fromColor:!instance creation!public! !
!OS.RGBQUAD class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

