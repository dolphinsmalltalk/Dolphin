"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TextTileIcon
	instanceVariableNames: 'text font tilecolor'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!
TextTileIcon guid: (GUID fromString: '{A5C05489-C3FA-486A-9E1B-1660F9B3A55A}')!
TextTileIcon comment: ''!
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

bitmap
	^self bitmapWithExtent: self class defaultExtent!

bitmapWithExtent: extent
	| bitmap |
	bitmap := GdiplusBitmap extent: extent.
	bitmap graphics doWithCanvas: 
			[:canvas | 
			| textExtent |
			canvas font: (Font name: self font pixelSize: extent y).
			textExtent := canvas textExtent: self text.
			canvas
				backcolor: self tilecolor;
				erase;
				forecolor: Color white;
				text: self text at: (extent - textExtent) // 2].
	^bitmap!

drawOn: aCanvas 
	^self bitmap drawOn: aCanvas!

drawOn: aCanvas at: aPoint 
	"Draw the receiver on aCanvas at position aPoint (no stretching)."

	self bitmap drawOn: aCanvas at: aPoint!

drawOn: aCanvas at: dstOrigin extent: dstExtent 
	"Draw the receiver on aCanvas at Point dstOrigin, and with size dstExtent. 
	The receiver is stretched to fit the destination rectangle."

	self bitmap 
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
!TextTileIcon categoriesFor: #asBitmap!public! !
!TextTileIcon categoriesFor: #asIcon!public! !
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
!TextTileIcon class categoriesFor: #new!instance creation!private! !
!TextTileIcon class categoriesFor: #text:font:color:!instance creation!public! !

