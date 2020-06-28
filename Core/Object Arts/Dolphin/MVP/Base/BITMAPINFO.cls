"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #BITMAPINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bmiColors' -> 16r28.
		'_OffsetOf_bmiHeader' -> 16r0
	}!
BITMAPINFO guid: (GUID fromString: '{87b4c5ca-026e-11d3-9fd7-00a0cc3e4a32}')!
BITMAPINFO comment: 'BITMAPINFO is an <ExternalStructure> class to represent the Win32 structure of the same name.

The BITMAPINFO structure is used to describe device-independent bitmaps. See MSDN for further information.'!
!BITMAPINFO categoriesForClass!External-Data-Structured-Win32! !
!BITMAPINFO methodsFor!

bmiColors
	"Answer the <StructureArray> value of the receiver's 'bmiColors' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_bmiColors
		length: self numQuads
		elementClass: RGBQUAD!

bmiColors: aStructureArrayOfRGBQUAD
	"Set the receiver's 'bmiColors' field to the value of the argument, aStructureArrayOfRGBQUAD"

	| size |
	size := aStructureArrayOfRGBQUAD byteSize.
	aStructureArrayOfRGBQUAD
		replaceBytesOf: bytes
		from: ##(_OffsetOf_bmiColors + 1)
		to: _OffsetOf_bmiColors + size
		startingAt: 1!

bmiHeader
	"Answer the <BITMAPINFOHEADER> value of the receiver's 'bmiHeader' field."

	^BITMAPINFOHEADER fromAddress: bytes yourAddress!

bmiHeader: aBITMAPINFOHEADER
	"Set the receiver's 'bmiHeader' field to the value of the argument, aBITMAPINFOHEADER"

	aBITMAPINFOHEADER
		replaceBytesOf: bytes
		from: ##(_OffsetOf_bmiHeader + 1)
		to: ##(_OffsetOf_bmiHeader + BITMAPINFOHEADER basicByteSize)
		startingAt: 1!

byteSize
	"Answer the size in bytes of this structure, which in this case is variable depending
	on the size of the colour table (if any)."

	"Implementation Note: The static size reported by the superclass implementation
	includes one RGBQUAD."

	^super byteSize + ((self numQuads - 1) * ##(RGBQUAD basicByteSize))!

colors
	"Answer a <StructureArray> of <RGBQUAD>, representing the receiver's colour table."

	^self bmiColors!

initialize: anInteger 
	super initialize: anInteger.
	self bmiHeader dwSize: BITMAPINFOHEADER byteSize!

numQuads
	"Private - Answer the number of <RGBQUAD>s in the receiver's colour table."

	^self bmiHeader numQuads! !
!BITMAPINFO categoriesFor: #bmiColors!**compiled accessors**!public! !
!BITMAPINFO categoriesFor: #bmiColors:!**compiled accessors**!public! !
!BITMAPINFO categoriesFor: #bmiHeader!**compiled accessors**!public! !
!BITMAPINFO categoriesFor: #bmiHeader:!**compiled accessors**!public! !
!BITMAPINFO categoriesFor: #byteSize!accessing!public! !
!BITMAPINFO categoriesFor: #colors!accessing!public! !
!BITMAPINFO categoriesFor: #initialize:!initializing!private! !
!BITMAPINFO categoriesFor: #numQuads!accessing!private! !

!BITMAPINFO class methodsFor!

colorDepth: colorDepth
	"Answer a new instance of the receiver capable of representing information about an RGB
	bitmap (that is a bitmap with biCompression = BI_RGB) with the specified colour depth (e.g.
	8, 16, 24 or 32 bpp)."

	| quads |
	quads := colorDepth < 16 ifTrue: [2 raisedToInteger: colorDepth] ifFalse: [0].
	^self new: self byteSize + ((quads - 1) * RGBQUAD byteSize)!

defineFields
	"Define the Win32 BITMAPINFO structure
		BITMAPINFO compileDefinition

		typedef struct tagBITMAPINFO { // bmi  
			BITMAPINFOHEADER bmiHeader;
			RGBQUAD          bmiColors[1];
			} BITMAPINFO;"

	self
		defineField: #bmiHeader type: (StructureField type: BITMAPINFOHEADER);
		defineField: #bmiColors
			type: (StructureArrayField type: RGBQUAD
					arrayLength: (ConformantArrayFieldLength lengthField: #numQuads))!

getFieldNames
	^#(#bmiHeader #bmiColors)! !
!BITMAPINFO class categoriesFor: #colorDepth:!instance creation!public! !
!BITMAPINFO class categoriesFor: #defineFields!public!template definition! !
!BITMAPINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

