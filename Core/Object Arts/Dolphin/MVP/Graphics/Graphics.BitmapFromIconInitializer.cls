"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.BitmapFromIconInitializer'
	instanceVariableNames: 'extent icon'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.BitmapFromIconInitializer guid: (Core.GUID fromString: '{cbd63799-b451-40d7-bd4e-a64a38e1860c}')!
Graphics.BitmapFromIconInitializer comment: ''!
!Graphics.BitmapFromIconInitializer methodsFor!

createImage: aBitmap extent: aPoint
	"Answer the handle of a 32-bpp RGBA bitmap (i.e. with Alpha channel) of the same native type as that expected by<Bitmap> argument, which represents the best rendering of the receiver's <icon> at the extent specified by the <Point>, aPoint."

	| bmp |
	bmp := aBitmap class extent: aPoint depth: 32.
	"Use the services of an ImageList to get the correct sized icon automagically, and to
	provide an alpha channel even if the original icon had no more than a simple mask."
	(icon imageManager imageListWithExtent: aPoint)
		draw: icon imageIndex
		on: bmp hdc
		at: Point.Zero
		flags: ImageList.ILD_PRESERVEALPHA.
	^bmp detachHandle!

extent
	^extent!

extent: aPoint icon: anIcon
	icon := anIcon.
	extent := aPoint.
	^self!

icon
	^icon!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the <Image> it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^icon isPersistent!

printImage: aBitmap on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		nextPut: $(;
		print: icon;
		nextPut: $);
		nextPutAll: ' asAlphaBitmap: ';
		print: extent! !
!Graphics.BitmapFromIconInitializer categoriesForMethods!
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
extent:icon:!initializing!private! !
icon!accessing!public! !
isPersistent!public!testing! !
printImage:on:!printing!private! !
!

!Graphics.BitmapFromIconInitializer class methodsFor!

extent: aPoint icon: anIcon
	<primitive: 157>
	^self new
		extent: aPoint icon: anIcon;
		yourself! !
!Graphics.BitmapFromIconInitializer class categoriesForMethods!
extent:icon:!instance creation!public! !
!

