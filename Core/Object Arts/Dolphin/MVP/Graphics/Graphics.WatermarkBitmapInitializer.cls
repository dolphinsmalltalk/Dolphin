"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer subclass: #'Graphics.WatermarkBitmapInitializer'
	instanceVariableNames: 'image alphaPercent backcolor'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.WatermarkBitmapInitializer guid: (Core.GUID fromString: '{58853b8d-ed91-47d3-a98e-ac2003604043}')!
Graphics.WatermarkBitmapInitializer comment: ''!
!Graphics.WatermarkBitmapInitializer methodsFor!

createImage: aBitmap extent: aPoint
	| extent combined mask rect watermark hasAlpha watermarkDc maskDc |
	extent := image extent.
	"Create the watermark image by fading the source bitmap"
	watermark := aBitmap class displayCompatibleWithExtent: extent.
	watermarkDc := watermark canvas.
	watermarkDc
		backcolor: backcolor;
		erase.
	hasAlpha := image hasAlpha.
	watermarkDc
		alphaBlendBitmap: image
		at: Point.Zero
		extent: extent
		from: Point.Zero
		extent: extent
		blend: (BLENDFUNCTION newBuffer
				blendPercentage: alphaPercent;
				usePerPixelAlpha: hasAlpha;
				yourself).
	hasAlpha
		ifTrue: 
			[image free.
			^watermark detachHandle].
	"If no alpha channel, we must do our own masking, so create a monochrome AND mask bitmap"
	mask := Bitmap
				width: extent x
				height: extent y
				depth: 1.
	rect := Point.Zero extent: extent.
	maskDc := mask canvas.
	maskDc
		backcolor: (image canvas pixelAt: Point.Zero);
		bitBlt: image canvas
			rectangle: rect
			to: Point.Zero
			rop: SRCCOPY.
	image free.
	"Mask out the transparent areas of the image (i.e. those in the transparent colour)"
	watermarkDc
		backcolor: Color black;
		forecolor: Color white;
		bitBlt: maskDc
			rectangle: rect
			to: Point.Zero
			rop: SRCAND.

	"Now use the mask to paint the background colour in the transparent areas, and then combine the background and image"
	combined := aBitmap class displayCompatibleWithExtent: extent.
	combined canvas
		backcolor: backcolor;
		bitBlt: maskDc
			rectangle: rect
			to: Point.Zero
			rop: MERGECOPY;
		bitBlt: watermarkDc
			rectangle: rect
			to: Point.Zero
			rop: SRCPAINT.
	mask free.
	watermark free.
	^combined detachHandle!

image: anImage alphaPercent: anInteger backcolor: aColor
	image := anImage.
	alphaPercent := anInteger.
	backcolor := aColor.
	^self!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the <Image> it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^image isPersistent!

printImage: aBitmap on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		nextPut: $(;
		print: image;
		nextPut: $);
		nextPutAll: ' createWatermarkAlphaPercent: ';
		print: alphaPercent;
		nextPutAll: ' backcolor: ';
		print: backcolor! !
!Graphics.WatermarkBitmapInitializer categoriesForMethods!
createImage:extent:!private!realizing/unrealizing! !
image:alphaPercent:backcolor:!initializing!private! !
isPersistent!public!testing! !
printImage:on:!printing!private! !
!

!Graphics.WatermarkBitmapInitializer class methodsFor!

image: anImage alphaPercent: anInteger backcolor: aColor
	<primitive: 157>
	^self new
		image: anImage
		alphaPercent: anInteger
		backcolor: aColor! !
!Graphics.WatermarkBitmapInitializer class categoriesForMethods!
image:alphaPercent:backcolor:!instance creation!public! !
!

