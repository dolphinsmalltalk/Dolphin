"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.IconFromBitmapInitializer'
	instanceVariableNames: 'bitmap transparentColor'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.IconFromBitmapInitializer guid: (Core.GUID fromString: '{cbd63799-b451-40d7-bd4e-a64a38e1860c}')!

Graphics.IconFromBitmapInitializer comment: ''!

!Graphics.IconFromBitmapInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent. Two Images loaded by identifier are equal if they are of the same species, and have the same id and are from the same resource modules."

	^self == anObject or: 
			[self species == anObject species
				and: [bitmap = anObject bitmap and: [transparentColor = anObject transparentColor]]]!

bitmap
	^bitmap!

bitmap: aBitmap
	bitmap := aBitmap.
	^self!

createImage: anIcon extent: aPoint
	| mask hIcon ext |
	"Note that we ignore the extent - the icon is always created at the full extent of the Bitmap. Any resizing will have to be done when the icon is drawn, and of course the results will be variable depending on how large the bitmap was initially relative to the target size, and whether the target is smaller or larger. Typically results are better when scaling down rather than up."
	ext := bitmap extent.
	mask := Bitmap extent: ext depth: 1.
	bitmap hasAlpha
		ifFalse: 
			[| bitmapDc |
			bitmapDc := bitmap canvas.
			"We create the mask using off a particular colour so that colour will be transparent in the resulting icon. If no specific colour has been specified, then the colour of the first pixel is used (i.e. following the same convention as the Window LoadImage API with LR_LOADTRANSPARENT flag)"
			bitmapDc backcolor: (transparentColor ifNil: [bitmapDc pixelAt: Point.Zero]).
			mask canvas
				bitBlt: bitmapDc
				rectangle: (Point.Zero extent: ext)
				to: Point.Zero
				rop: SRCCOPY.
			mask freeDC].
	bitmap freeDC.
	hIcon := User32 createIconIndirect: (ICONINFO newBuffer
						beUnfinalizable;
						fIcon: true;
						hbmColor: bitmap handle;
						hbmMask: mask handle;
						yourself).
	mask free.
	^hIcon!

extent
	"Answer the specified extent for images to be loaded/created by the receiver. If no extent is specified (e.g. in order to use some default), answer nil."

	^bitmap extent!

hash
	"Answer the <integer> hash value for the receiver."

	^bitmap hash!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the <Image> it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^bitmap isPersistent!

printImage: aBitmap on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		nextPut: $(;
		print: bitmap;
		nextPut: $);
		nextPutAll: ' asIcon'!

transparentColor
	"Answer the <Color> to use to identify transparent pixels of non-alpha bitmaps, or nil if none specified."

	^transparentColor!

transparentColor: aColor
	transparentColor := aColor! !

!Graphics.IconFromBitmapInitializer categoriesForMethods!
=!comparing!public! !
bitmap!accessing!public! !
bitmap:!initializing!private! !
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
hash!comparing!public! !
isPersistent!public!testing! !
printImage:on:!printing!private! !
transparentColor!public! !
transparentColor:!accessing!public! !
!

!Graphics.IconFromBitmapInitializer class methodsFor!

bitmap: aBitmap
	<primitive: 157>
	^self new
		bitmap: aBitmap;
		yourself! !

!Graphics.IconFromBitmapInitializer class categoriesForMethods!
bitmap:!instance creation!public! !
!

