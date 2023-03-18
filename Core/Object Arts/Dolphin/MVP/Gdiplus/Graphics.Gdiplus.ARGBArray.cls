"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'Graphics.Gdiplus.ARGBArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.ARGBArray guid: (Core.GUID fromString: '{9f452cba-88f5-40e0-a63a-91d669071868}')!
Graphics.Gdiplus.ARGBArray comment: ''!
!Graphics.Gdiplus.ARGBArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer a <Color> representing the 32-bit ARGB value at the specified <integer> index in the receiver. No bounds checks are performed on the subscript."

	^Color fromArgbCode: (bytes uint32AtOffset: (anInteger - 1) * 4)!

uncheckedAt: indexInteger put: aColor
	bytes uint32AtOffset: (indexInteger - 1) * 4 put: aColor argbCode.
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

