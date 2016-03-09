"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #BITMAPINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BITMAPINFO guid: (GUID fromString: '{87B4C5CA-026E-11D3-9FD7-00A0CC3E4A32}')!
BITMAPINFO comment: 'BITMAPINFO is an <ExternalStructure> class to represent the Win32 structure of the same name.

The BITMAPINFO structure is used to describe device-independent bitmaps. See MSDN for further information.'!
!BITMAPINFO categoriesForClass!External-Data-Structured-Win32! !
!BITMAPINFO methodsFor!

bmiColors
	"Answer the receiver's bmiColors field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #bmiColors)
		length: self numQuads
		elementClass: RGBQUAD!

bmiColors: anObject 
	"Set the receiver's bmiColors field to the value of anObject."

	| size |
	size := anObject byteSize min: self numQuads * ##(RGBQUAD basicByteSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #bmiColors) + 1)
		to: ##(self offsetOf: #bmiColors) + size
		startingAt: 1!

bmiHeader
	"Answer the receiver's bmiHeader field as a Smalltalk object."

	^BITMAPINFOHEADER fromAddress: bytes yourAddress!

bmiHeader: anObject 
	"Set the receiver's bmiHeader field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: 1
		to: ##(BITMAPINFOHEADER basicByteSize)
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
			} BITMAPINFO;

	N.B. #bmiColors is really a variable length array of RGBQUADs and should be
	accessed with #colors, which answers a StructureArray of the correct length."

	self
		defineField: #bmiHeader type: (StructureField type: BITMAPINFOHEADER);
		defineField: #bmiColors type: (ConformantStructureArrayField type: RGBQUAD length: #numQuads)! !
!BITMAPINFO class categoriesFor: #colorDepth:!instance creation!public! !
!BITMAPINFO class categoriesFor: #defineFields!initializing!public! !

