"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.DisplayCompatibleBitmapInitializer'
	instanceVariableNames: 'extent'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.DisplayCompatibleBitmapInitializer guid: (Core.GUID fromString: '{e8abc724-cdba-4047-a3d4-d44430d1a05f}')!
Graphics.DisplayCompatibleBitmapInitializer comment: ''!
!Graphics.DisplayCompatibleBitmapInitializer methodsFor!

createImage: anImage extent: aPoint
	| hBitmap dc |
	dc := User32 getDC: nil.
	hBitmap := Gdi32
				createCompatibleBitmap: dc
				nWidth: aPoint x
				nHeight: aPoint y.
	User32 releaseDC: dc.
	^hBitmap!

extent
	^extent!

extent: aPoint
	extent := aPoint.
	^self!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the <Image> it describes exactly as it was across Smalltalk image save/restore."

	^false!

printImage: aBitmap on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		print: aBitmap class;
		nextPutAll: ' displayCompatibleWithExtent: ';
		print: extent! !
!Graphics.DisplayCompatibleBitmapInitializer categoriesForMethods!
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
extent:!accessing!public! !
isPersistent!public!testing! !
printImage:on:!printing!private! !
!

!Graphics.DisplayCompatibleBitmapInitializer class methodsFor!

extent: aPoint
	<primitive: 157>
	^self new
		extent: aPoint;
		yourself! !
!Graphics.DisplayCompatibleBitmapInitializer class categoriesForMethods!
extent:!instance creation!public! !
!

