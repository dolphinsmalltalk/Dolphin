"Filed out from Dolphin Smalltalk"!

Graphics.AbstractBitmapFromBlankInitializer
	subclass: #'Graphics.BitmapFromBlankInitializer'
	instanceVariableNames: 'planes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.BitmapFromBlankInitializer guid: (Core.GUID fromString: '{648adf74-5ff3-466d-af73-9cd905f08616}')!

Graphics.BitmapFromBlankInitializer comment: ''!

!Graphics.BitmapFromBlankInitializer methodsFor!

bytes
	^nil!

createImage: anImage extent: aPoint
	^Gdi32
		createBitmap: aPoint x
		nHeight: aPoint y
		cPlanes: planes
		cBitsPerPel: depth
		lpvBits: self bytes!

planes: anObject
	planes := anObject!

printImage: aBitmap on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	super printImage: aBitmap on: aWriteStream.
	planes ~~ 1
		ifTrue: 
			[aWriteStream
				nextPutAll: ' planes: ';
				print: planes]! !

!Graphics.BitmapFromBlankInitializer categoriesForMethods!
bytes!accessing!public! !
createImage:extent:!private!realizing/unrealizing! !
planes:!initializing!private! !
printImage:on:!printing!private! !
!

!Graphics.BitmapFromBlankInitializer class methodsFor!

extent: aPoint depth: bppInteger
	^self
		extent: aPoint
		depth: bppInteger
		planes: 1!

extent: aPoint depth: bppInteger planes: planesInteger
	<primitive: 157>
	^self new
		extent: aPoint;
		depth: bppInteger;
		planes: planesInteger;
		yourself! !

!Graphics.BitmapFromBlankInitializer class categoriesForMethods!
extent:depth:!instance creation!public! !
extent:depth:planes:!instance creation!public! !
!

