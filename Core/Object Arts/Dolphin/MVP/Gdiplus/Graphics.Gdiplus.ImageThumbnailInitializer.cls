"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.ImageInitializer
	subclass: #'Graphics.Gdiplus.ImageThumbnailInitializer'
	instanceVariableNames: 'image extent'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.ImageThumbnailInitializer guid: (Core.GUID fromString: '{21b29424-81ce-40c7-9524-d9e4377b6a66}')!
Graphics.Gdiplus.ImageThumbnailInitializer comment: ''!
!Graphics.Gdiplus.ImageThumbnailInitializer methodsFor!

= anObject
	^self == anObject
		or: [self species = anObject species and: [extent = anObject extent and: [image = anObject image]]]!

basicCreateHandle
	| gpImage |
	gpImage := Handle new.
	Gdip
		gdipGetImageThumbnail: image asParameter
		thumbWidth: extent x
		thumbHeight: extent y
		thumbImage: gpImage
		pfnCallback: nil
		callbackData: nil.
	^gpImage!

extent
	^extent!

hash
	^((self species hash + image hash) hashMultiply + extent hash) hashMultiply!

image
	^image!

image: anImage extent: aPoint
	image := anImage.
	extent := aPoint!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^image isSelfEvaluating!

printImage: aGdiplusImage on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Graphics.Gdiplus.Image> initialized by the receiver."

	aWriteStream
		nextPut: $(;
		print: image;
		space;
		nextPutAll: #thumbnailWithExtent:;
		space;
		print: extent;
		nextPut: $)! !
!Graphics.Gdiplus.ImageThumbnailInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
extent!accessing!public! !
hash!comparing!public! !
image!accessing!public! !
image:extent:!initializing!private! !
isSelfEvaluating!public!testing! !
printImage:on:!printing!private! !
!

!Graphics.Gdiplus.ImageThumbnailInitializer class methodsFor!

image: anImage extent: aPoint
	^self new image: anImage extent: aPoint! !
!Graphics.Gdiplus.ImageThumbnailInitializer class categoriesForMethods!
image:extent:!instance creation!public! !
!

