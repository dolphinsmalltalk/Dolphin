"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Graphics.InternalBitmap'
	instanceVariableNames: 'gdiplusBitmap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.InternalBitmap guid: (Core.GUID fromString: '{b9454399-94c0-4572-bc54-802ff110731f}')!
Graphics.InternalBitmap comment: 'An InternalBitmap is capable of holding its image bytes internally in the Smalltalk image. Thus it is no longer necessary to refer to external files outside the image to make use of bitmap resources. This has several advantages, including the ability to version InternalBitmap resources into STS as part of a Smalltalk method and the fact that fewer external files need to be distributed with an application. 

A word of caution, however. InternalBitmaps will display their full byte array initializers if you use #displayString or #printString. If you choose to load a huge bitmap into one of these objects (which is not a good idea anyway) this could cause problems if you "Display It" in a workspace. It is for this reason that InternalIcons forcibly reformat any supplied image to a default size of 48@48 pixels. Thus, InternalIcons should never be too large to "Display It". Indeed, this is the only difference between InternalIcons and InternalBitmaps; the latter are not resized on load and so can be arbitrarily large.

InternalBitmaps can now be used for toolbar images, but the source image will need an alpha channel to work correctly as the mapping of standard colors to theme colors is not supported. It is recommended that 32bpp PNGs are used as these support an alpha channel and are compressed.
'!
!Graphics.InternalBitmap categoriesForClass!Kernel-Objects! !
!Graphics.InternalBitmap methodsFor!

= comperand 
	"Gdiplus images comapre equal if their initializers are equal. This allows GdiplusImages to be added to ImageManagers"

	^self species = comperand species 
		and: [self gdiplusBitmap initializer = comperand gdiplusBitmap initializer]!

addToImageList: aWinImageList mask: aColorOrNil 
	"Private - Add a pictorial representation of the receiver to aWinImageList scaled to the
	extent of the image list. We assume that the receiver contains transparency information so
	the mask color is ignored"

	^self bitmap addToImageList: aWinImageList mask: aColorOrNil!

asBitmap
	| bitmap |
	bitmap := DIBSection 
				width: self extent x
				height: self extent y
				depth: 32.
	self drawOn: bitmap canvas.
	bitmap freeDC.
	^bitmap!

asByteArray
	"Ideally, we don't want to duplicate pixel byte arrays unnecessarily. Hence the ugly type
	test here. If the receiver has been created from a AbstractImageFromBytesInitializer then we
	can just answer the original bytes"

	(gdiplusBitmap initializer isKindOf: Gdiplus.AbstractImageFromBytesInitializer) 
		ifTrue: [^gdiplusBitmap initializer bytes].

	"Otherwise ask GDI+ to yield the PNG bytes for the image"
	^gdiplusBitmap asByteArray: 'image/png'!

asIcon
	"Answer the receiver converted to a normal Windows icon format. We do this using a temporary
	ImageManager but NOT the default IconImageManager. Since the receiver could be of arbitrary size this
	would result in large image list being rendered for all icons. "

	| imageList imageManager index |
	imageManager := ImageManager new.
	index := imageManager addImage: self.
	imageList := imageManager imageListWithExtent: self extent.
	^imageList getIcon: index style: 32!

asSharedCopy
	"For compatibility with bitmaps."

	^Bitmap sharedCopyOf: self!

bitmap
	^gdiplusBitmap!

bounds
	"Answer the boundary rectangle of the receiver"

	^self gdiplusBitmap bounds!

doDrawWithCanvas: aMonadicBlock 
	self graphics doWithCanvas: aMonadicBlock.
	self internalize!

drawOn: aCanvas 
	^self drawOn: aCanvas at: Point zero!

drawOn: aCanvas at: aPoint 
	"Draw the receiver on aCanvas at position aPoint (no stretching)."

	self 
		drawOn: aCanvas
		at: aPoint
		extent: self extent!

drawOn: aCanvas at: dstOrigin extent: dstExtent 
	"Draw the receiver on aCanvas at Point dstOrigin, and with size dstExtent. 
	The receiver is stretched to fit the destination rectangle."

	self bitmap 
		drawOn: aCanvas
		at: dstOrigin
		extent: dstExtent!

drawOnGraphics: aGraphics at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent unit: aUnit attributes: aImageAtt 
	^self bitmap 
		drawOnGraphics: aGraphics
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: srcExtent
		unit: aUnit
		attributes: aImageAtt!

extent
	^self gdiplusBitmap extent!

fullIdentifier
	"For compatibility with bitmaps."

	^self!

gdiplusBitmap 
	^gdiplusBitmap!

graphics
	^self gdiplusBitmap graphics!

handle
	^self gdiplusBitmap handle!

hash
	^self gdiplusBitmap initializer hash!

imageType
	^Win32Constants.IMAGE_BITMAP!

internalize
	"Should be performed after termination of any operation that draws into the receiver"

	gdiplusBitmap := gdiplusBitmap internalize!

isShared: aBoolean
	"For compatibility with bitmaps"

	!

printOn: aStream
	"Append the ASCII representation of the receiver to aStream."

	aStream
		print: self class;
		space;
		nextPutAll: #fromBytes:;
		space.
	self asByteArray printOn: (LimitedWriteStream
				over: aStream
				limit: 100000
				limitBlock: 
					[:s |
					aStream nextPutAll: ' ...etc... ]'.
					^self])!

setBitmap: aGdiplusBitmap 
	gdiplusBitmap := aGdiplusBitmap! !
!Graphics.InternalBitmap categoriesForMethods!
=!comparing!public! !
addToImageList:mask:!double dispatch!private! !
asBitmap!public! !
asByteArray!converting!public! !
asIcon!public! !
asSharedCopy!converting!public! !
bitmap!accessing!public! !
bounds!accessing!public! !
doDrawWithCanvas:!drawing-bitmaps!public! !
drawOn:!drawing-bitmaps!public! !
drawOn:at:!drawing-bitmaps!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
drawOnGraphics:at:extent:from:extent:unit:attributes:!drawing-gdiplus!public! !
extent!accessing!public! !
fullIdentifier!public! !
gdiplusBitmap!initializing!private! !
graphics!accessing!drawing-gdiplus!public! !
handle!public! !
hash!comparing!public! !
imageType!public! !
internalize!public! !
isShared:!public! !
printOn:!printing!public! !
setBitmap:!initializing!private! !
!

!Graphics.InternalBitmap class methodsFor!

chooseFile
	| filename |
	filename := UI.FileOpenDialog showModal.
	((File splitExtensionFrom: filename) equalsIgnoreCase: 'ico') 
		ifTrue: 
			[#todo.	"Anyone care to fix this?"
			UI.MessageBox 
				warning: 'Can''t currently internalize ICO files. 

Why not use: 
  http://www.converticon.com
to convert to PNG format first?'.
			filename := nil].
	filename ifNil: [self error: 'No file selected'].
	^self fromFile: filename!

fromBytes: aByteArray 
	^self fromGdiplusBitmap: (Gdiplus.Bitmap fromByteArray: aByteArray)!

fromFile: aFilename 
	^self fromGdiplusBitmap: (Gdiplus.Bitmap fromFile: aFilename) internalize!

fromGdiplusBitmap: gdipBitmap 
	^(super new)
		setBitmap: gdipBitmap;
		yourself!

icon
	^Gdiplus.Bitmap icon!

imageManager
	"Private - Answer an image manager to use for storing images"

	^ImageManager new!

new
	"Private - User #withExtent:"

	self shouldNotImplement!

withExtent: aPointExtent 
	^self fromGdiplusBitmap: (Gdiplus.Bitmap extent: aPointExtent) internalize! !
!Graphics.InternalBitmap class categoriesForMethods!
chooseFile!public! !
fromBytes:!instance creation!public! !
fromFile:!instance creation!public! !
fromGdiplusBitmap:!instance creation!public! !
icon!public! !
imageManager!accessing!private! !
new!private! !
withExtent:!instance creation!public! !
!

