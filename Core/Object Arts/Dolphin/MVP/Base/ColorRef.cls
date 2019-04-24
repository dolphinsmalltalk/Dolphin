"Filed out from Dolphin Smalltalk 7"!

Color subclass: #ColorRef
	instanceVariableNames: 'code'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ColorRef guid: (GUID fromString: '{ed5fcdeb-52e8-4a5c-9eb7-38bf3a3aa575}')!
ColorRef isAbstract: true!
ColorRef comment: '`ColorRef` is the abstract class of palette independent (absolute) color values used with most Win32 APIs.

## Instance Variables:
  `code`		`<integer>`; a Windows `COLORREF` value. e.g. an `RGB` value.

'!
!ColorRef categoriesForClass!Unclassified! !
!ColorRef methodsFor!

= aColorRef
	"Answer true if the argument and the reciever are equal (i.e. they are represent the
	same colour value)."

	^self species == aColorRef species and: [code = aColorRef code]!

asColorRef
	"Answer the receiver as a ColorRef (an RGB value or one of the standard pseudo-colour constants)"

	^self!

asIndexedColor
	"Answer the receiver as the nearest <IndexedColour> using the default palette."

	^self asIndexedColorUsingPalette: self defaultPalette
!

asIndexedColorUsingPalette: hPalette
	"Answer the receiver as the nearest <IndexedColour> using hPalette"

	^self asRGB asIndexedColorUsingPalette: hPalette!

asInteger
	^code!

asParameter
	"Answer the receiver such that it can be used for an API call."

	^code!

asRGB
	"Answer the <RGB> colour equivalent to the receiver."

	^self errorNotARealColor!

code
	"Private - Answer the value of the receiver's ''code'' instance variable."

	^code!

errorNotARealColor
	"Private - Raise an error to the effect that the receiver does not represent a real colour
	value, and cannot therefore be converted to another type of <Color>."

	^self error: 'Cannot convert to another type of Color'!

hash
	"Answer the <integer> hash value for the receiver."

	^code!

printOn: aStream
	"Put an ASCII representation of receiver onto aStream."

	aStream
		nextPut: $(;
		display: self class;
		space;
		display: #fromInteger:;
		space;
		print: code;
		nextPut: $)!

setCode: anInteger
	"Private - Set the <integer> value of the ColorRef (i.e. that value passed to API calls
	to represent the color)."

	code := anInteger! !
!ColorRef categoriesFor: #=!comparing!public! !
!ColorRef categoriesFor: #asColorRef!converting!public! !
!ColorRef categoriesFor: #asIndexedColor!converting!public! !
!ColorRef categoriesFor: #asIndexedColorUsingPalette:!converting!public! !
!ColorRef categoriesFor: #asInteger!converting!public! !
!ColorRef categoriesFor: #asParameter!converting!public! !
!ColorRef categoriesFor: #asRGB!converting!public! !
!ColorRef categoriesFor: #code!accessing!private! !
!ColorRef categoriesFor: #errorNotARealColor!exceptions!private! !
!ColorRef categoriesFor: #hash!comparing!public! !
!ColorRef categoriesFor: #printOn:!development!printing!public! !
!ColorRef categoriesFor: #setCode:!accessing!private! !

!ColorRef class methodsFor!

defaultColorRepresentation
	"Private - Answer a unique colour that we can use to represent (Color default). This is used in the ColorDialog to allow users to
	explicitly choose the default colour from a swatch"

	^Color 
		r: 200
		g: 200
		b: 201!

fromInteger: anInteger
	"Private - Answer an instance with the specified colorref code value."

	^CLR_NONE = anInteger
		ifTrue: [None]
		ifFalse: [CLR_DEFAULT = anInteger ifTrue: [Default] ifFalse: [RGB fromInteger: anInteger]]!

stbReadFrom: anSTBInFiler format: anSTBClassConversion
	"Read a sub-instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using a proxy"

	| answer ref |
	anSTBInFiler version < 3
		ifTrue: 
			["Skip over the object size that older STB versions used to write for everything"
			anSTBInFiler stream skip: 4].
	"Make a placeholder for the Color"
	ref := anSTBInFiler register: nil.
	answer := self fromInteger: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer! !
!ColorRef class categoriesFor: #defaultColorRepresentation!constants!private! !
!ColorRef class categoriesFor: #fromInteger:!instance creation!private! !
!ColorRef class categoriesFor: #stbReadFrom:format:!binary filing!public! !

