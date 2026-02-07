"Filed out from Dolphin Smalltalk"!

External.UInt32Array
	subclass: #'Graphics.Gdiplus.ARGBArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.ARGBArray guid: (Core.GUID fromString: '{9f452cba-88f5-40e0-a63a-91d669071868}')!

Graphics.Gdiplus.ARGBArray comment: '`ARGArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 32-bit `ARGB` values.'!

!Graphics.Gdiplus.ARGBArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer a <Color> representing the 32-bit ARGB value at the specified <integer> index in the receiver. No bounds checks are performed on the subscript."

	^Color fromArgbCode: (self basicUncheckedAt: anInteger)!

uncheckedAt: indexInteger put: aColor
	self basicUncheckedAt: indexInteger put: aColor argbCode.
	^aColor! !

!Graphics.Gdiplus.ARGBArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!Graphics.Gdiplus.ARGBArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^ARGBBytes! !

!Graphics.Gdiplus.ARGBArray class categoriesForMethods!
elementClass!constants!public! !
!

