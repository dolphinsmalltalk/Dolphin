"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TextTileIcon
	instanceVariableNames: 'text font tilecolor'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!
TextTileIcon guid: (GUID fromString: '{a5c05489-c3fa-486a-9e1b-1660f9b3a55a}')!
TextTileIcon comment: 'An icon representation of one or more letters on a plain solid colour background. The icon has a default size (given by the class side #defaultExtent) is capable of being rendered at high quality into any size image list. '!
!TextTileIcon categoriesForClass!Unclassified! !
!TextTileIcon methodsFor!

= comperand 

	^((self species = comperand species and: [self text = comperand text]) 
		and: [self tilecolor = comperand tilecolor]) and: [self font = comperand font]!

addToImageList: aWinImageList mask: aColorOrNil 
	"Private - Add a pictorial representation of the receiver to aWinImageList scaled to the
	extent of the image list. We can be a bit more efficient than the super implementation
	by rendering directly at the imagelist requested size"

	^(self bitmapWithExtent: aWinImageList extent) addToImageList: aWinImageList mask: aColorOrNil!

asAlphaBitmap: aPoint 
	"Answer a 32-bpp bitmap (i.e. with Alpha channel) that contains the receiver's
	image rendered at the specified size."

	| bmp |
	bmp := DIBSection 
				width: aPoint x
				height: aPoint y
				depth: 32.
	"Use the services of an ImageList to get the correct sized icon automagically, and to
	provide an alpha channel even if the original icon had no more than a simple mask."
	(self class imageManager imageListWithExtent: aPoint) 
		draw: self imageIndex
		on: bmp canvas
		at: Point zero
		flags: CommCtrlConstants.ILD_PRESERVEALPHA.
	bmp freeDC.
	^bmp!

asBitmap
	| bm |
	bm := DIBSection 
				width: self extent x
				height: self extent y
				depth: 32.
	self bitmap drawOn: bm canvas.
	^bm!

asIcon
	"Answer the receiver converted to a normal Windows icon format. We do this using a temporary
	ImageManager but NOT the default IconImageManager. Since the receiver could be of arbitrary size this
	would result in large image list being rendered for all icons. "

	| imageList imageManager index |
	imageManager := ImageManager new.
	index := imageManager addImage: self.
	imageList := imageManager imageListWithExtent: self extent.
	^imageList getIcon: index style: 32!

asMenuBitmap
	"Answer a 32-bpp bitmap (i.e. with alpha channel) containing the receiver's image at system
	menu image extent. Note that the result will be a shared bitmap which is always the same
	instance for the same icon."

	^self class imageManager menuBitmapForIcon: self!

asParameter
	"Create an icon from the image list so we can answer the handle"

	^self asIcon detachHandle!

bitmap
	^self bitmapWithExtent: self class defaultExtent!

bitmapWithExtent: aPoint
	| bitmap |
	bitmap := GdiplusBitmap extent: aPoint.
	bitmap graphics doWithCanvas: 
			[:canvas |
			| max textExtent f tries |
			max := aPoint - 1.
			f := Font name: self font pixelSize: max y.
			tries := 5.
			
			[canvas font: f.
			textExtent := canvas textExtent: self text.
			textExtent x > max x and: [tries > 0]]
					whileTrue: 
						[tries := tries - 1.
						f := Font name: self font pixelSize: (max x * max y / textExtent x) truncated].
			canvas
				backcolor: self tilecolor;
				erase;
				forecolor: Color white;
				text: self text at: (aPoint - textExtent) // 2].
	^bitmap!

drawOn: aCanvas 
	^self bitmap drawOn: aCanvas!

drawOn: aCanvas at: aPoint 
	"Draw the receiver on aCanvas at position aPoint (no stretching)."

	self bitmap drawOn: aCanvas at: aPoint!

drawOn: aCanvas at: dstOrigin extent: dstExtent 
	"Draw the receiver on aCanvas at Point dstOrigin, and with size dstExtent. 
	The receiver is stretched to fit the destination rectangle."

	(self bitmapWithExtent: dstExtent)
		drawOn: aCanvas
		at: dstOrigin
		extent: dstExtent!

extent
	^self class defaultExtent!

font
	^font!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^self text hash + self tilecolor hash + self font hash!

hotspot
	^self extent / 2!

imageIndex
	^Icon imageManager indexOfImage: self!

imageManager
	"Private - Answer an image manager to use for storing icons"

	^IconImageManager current!

imageType
	^Win32Constants.IMAGE_ICON!

printOn: aStream 
	"Append the ASCII representation of the receiver to aStream."

	aStream
		print: self class;
		nextPutAll: ' text: ';
		print: self text;
		nextPutAll: ' font: ';
		print: self font;
		nextPutAll: ' color: '.
	self tilecolor storeOn: aStream.
!

setText: aString font: fontName color: aColor 
	text := aString.
	font := fontName.
	tilecolor := aColor!

text
	^text!

tilecolor
	^tilecolor! !
!TextTileIcon categoriesFor: #=!comparison!public! !
!TextTileIcon categoriesFor: #addToImageList:mask:!double dispatch!private! !
!TextTileIcon categoriesFor: #asAlphaBitmap:!converting!public! !
!TextTileIcon categoriesFor: #asBitmap!public! !
!TextTileIcon categoriesFor: #asIcon!public! !
!TextTileIcon categoriesFor: #asMenuBitmap!converting!public! !
!TextTileIcon categoriesFor: #asParameter!public! !
!TextTileIcon categoriesFor: #bitmap!private! !
!TextTileIcon categoriesFor: #bitmapWithExtent:!private! !
!TextTileIcon categoriesFor: #drawOn:!drawing-bitmaps!public! !
!TextTileIcon categoriesFor: #drawOn:at:!drawing-bitmaps!public! !
!TextTileIcon categoriesFor: #drawOn:at:extent:!drawing-bitmaps!public! !
!TextTileIcon categoriesFor: #extent!accessing!public! !
!TextTileIcon categoriesFor: #font!accessing!public! !
!TextTileIcon categoriesFor: #hash!comparison!public! !
!TextTileIcon categoriesFor: #hotspot!public! !
!TextTileIcon categoriesFor: #imageIndex!private! !
!TextTileIcon categoriesFor: #imageManager!image management!private! !
!TextTileIcon categoriesFor: #imageType!public! !
!TextTileIcon categoriesFor: #printOn:!printing!public! !
!TextTileIcon categoriesFor: #setText:font:color:!private! !
!TextTileIcon categoriesFor: #text!accessing!public! !
!TextTileIcon categoriesFor: #tilecolor!accessing!public! !

!TextTileIcon class methodsFor!

defaultExtent
	^128 @ 128!

icon
	^self 
		text: 'Tt'
		font: 'Arial'
		color: Color blue!

imageManager
	"Private - Answer an image manager to use for storing icons"

	^IconImageManager current!

new
	"Private - User #text:font:color:"

	^self shouldNotImplement!

text: aStringLabel font: fontName color: aColor 
	^super new
		setText: aStringLabel
			font: fontName
			color: aColor;
		yourself! !
!TextTileIcon class categoriesFor: #defaultExtent!constants!private! !
!TextTileIcon class categoriesFor: #icon!public! !
!TextTileIcon class categoriesFor: #imageManager!accessing!private! !
!TextTileIcon class categoriesFor: #new!instance creation!private! !
!TextTileIcon class categoriesFor: #text:font:color:!instance creation!public! !

