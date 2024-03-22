"Filed out from Dolphin Smalltalk"!

Graphics.InternalBitmap
	subclass: #'Graphics.InternalIcon'
	instanceVariableNames: 'tileColor'
	classVariableNames: ''
	imports: #(#{Graphics.Gdiplus private})
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.InternalIcon guid: (Core.GUID fromString: '{7446a3c1-e3ae-45b8-bca2-bbd493a5c7d3}')!

Graphics.InternalIcon comment: 'An InternalIcon is capable of holding its image bytes internally in the Smalltalk image. Thus it is no longer necessary to refer to external files outside the image to make use of Icon resources. This has several advantages, including the ability to version InternalIcon resources into STS as part of a Smalltalk method and the fact that fewer external files need to be distributed with an application.

USAGE:

(1) If you want to install a class side #icon method for one of your classes simply go to any workspace and evaluate:

MyClass createIconMethod.

This will prompt for a (usually PNG) file, and then create a MyClass class>>icon method for it. If you browse this method you''ll see it answers an instance of InternalIcon instantiated from a literal byte array. Note that InternalIcons automatically reformat any image to 48@48 pixels by default.

(2) If you want to add an InternalIcon to a toolbar, in the View Composer first create a ToolbarIconButton in your toolbar and locate the commandDescription/image aspect for this button. Then type and accept:

InternalIcon chooseFile

This will prompt you for a suitable image file (again PNG files work best) and will load the image bytes into a literal byte array from which the InternalIcon can be instantiated when required. 

'!

!Graphics.InternalIcon categoriesForClass!Kernel-Objects! !

!Graphics.InternalIcon methodsFor!

= comperand
	^super = comperand and: [tileColor = comperand tileColor]!

addToImageList: aWinImageList mask: aColorOrNil 
	^(tileColor isNil ifTrue: [gdiplusBitmap] ifFalse: [self tileBitmapWithExtent: aWinImageList extent]) 
		addToImageList: aWinImageList
		mask: aColorOrNil!

asAlphaBitmap: aPoint
	"Answer a 32-bpp RGBA DIBSection (i.e. with Alpha channel) that contains the receiver's image rendered at the specified size."

	^DIBSection initializer: (BitmapFromIconInitializer extent: aPoint icon: self)!

asImageKey
	"Answer the form of the receiver to use as an image key in an ImageManager. Normally this is just the receiver, but in some cases there may be a need to snapshot certain attributes used in rendering the image so that subsequent attempts to use the image from the image manager do not match an old rendering of the image that should have changed, e.g. because ThemeColors are used in displaying the image, and the theme has been updated."

	^tileColor
		ifNil: [self]
		ifNotNil: 
			[self shallowCopy
				tileColor: tileColor actualColor;
				yourself]!

asMenuBitmap
	Notification deprecated.	"Extent required depends on DPI of the view the menu"
	^self asSharedBitmap: SystemMetrics current menuImageExtent!

asParameter
	"Create an icon from the image list so we can answer the handle"

	^self asIcon detachHandle!

asSharedBitmap: aPoint
	"Answer a 32-bpp bitmap (i.e. with alpha channel) containing the receiver's image at the specified extenT. The result will be a shared bitmap which is always the same
	instance for the same icon."

	^self class imageManager bitmapForIcon: self extent: aPoint!

asSmallIcon
	^self asIcon asSmallIcon!

bitmap
	^tileColor isNil ifTrue: [gdiplusBitmap] ifFalse: [self tileBitmapWithExtent: gdiplusBitmap extent]!

drawOn: aCanvas at: dstOrigin extent: dstExtent
	tileColor
		ifNotNil: 
			[aCanvas fillRectangle: (dstOrigin extent: dstExtent) brush: (tileColor gdiplusBrush: dstExtent)].
	self gdiplusBitmap
		drawOn: aCanvas
		at: dstOrigin
		extent: dstExtent!

drawOnGraphics: aGraphics at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent unit: aUnit attributes: aImageAtt
	tileColor
		ifNotNil: 
			[aGraphics fillRectangle: (dstOrigin extent: dstExtent) brush: (tileColor gdiplusBrush: dstExtent)].
	^self gdiplusBitmap
		drawOnGraphics: aGraphics
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: srcExtent
		unit: aUnit
		attributes: aImageAtt!

hash
	^(super hash + tileColor hash) hashMultiply!

hotspot
	^self extent / 2!

imageIndex
	^Icon imageManager indexOfImage: self!

imageManager
	^Icon imageManager!

imageType
	^Win32Constants.IMAGE_ICON!

isRealized
	^self gdiplusBitmap isRealized!

tileBitmapWithExtent: extent
	| tileBitmap graphics |
	tileBitmap := Gdiplus.Bitmap extent: extent.
	graphics := tileBitmap graphics.
	graphics interpolationMode: InterpolationModeHighQualityBicubic.
	self
		drawOnGraphics: graphics
		at: Point zero
		extent: extent
		from: Point zero
		extent: self extent
		unit: nil
		attributes: nil.
	graphics free.
	^tileBitmap!

tileColor
	^tileColor!

tileColor: aColor 
	tileColor := aColor!

withExtent: aPoint
	^self asIcon withExtent: aPoint! !

!Graphics.InternalIcon categoriesForMethods!
=!comparing!public! !
addToImageList:mask:!double dispatch!public! !
asAlphaBitmap:!converting!public! !
asImageKey!converting!public! !
asMenuBitmap!converting!public! !
asParameter!converting!public! !
asSharedBitmap:!converting!public! !
asSmallIcon!converting!public! !
bitmap!accessing!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
drawOnGraphics:at:extent:from:extent:unit:attributes:!drawing-gdiplus!public! !
hash!comparing!public! !
hotspot!accessing!public! !
imageIndex!accessing!public! !
imageManager!public! !
imageType!constants!public! !
isRealized!public!testing! !
tileBitmapWithExtent:!accessing!helpers!private! !
tileColor!accessing!private! !
tileColor:!accessing!private! !
withExtent:!converting!public! !
!

Graphics.InternalIcon methodProtocol: #icon attributes: #() selectors: #(#asAlphaBitmap: #asParameter #asSharedBitmap: #asSmallIcon #drawOn: #drawOn:at: #drawOn:at:extent: #extent #imageIndex #isPersistent #isRealized #withExtent:)!

!Graphics.InternalIcon class methodsFor!

badgeTile: anIconBadge color: aColor 
	"Answer an instance of the receiver that is anIconBadge superimposed on a square tile of
	aColor."

	^self badgeTile: anIconBadge color: aColor extent: self defaultTileExtent!

badgeTile: anIconBadge color: aColor extent: extent 
	"Answer an instance of the receiver that is anIconBadge superimposed on a square tile of
	aColor."

	^(self fromGdiplusBitmap: anIconBadge bitmap)
		tileColor: aColor;
		yourself!

defaultExtent
	#highDpiTodo. "Should this be scaled?"
	^48 @ 48!

defaultTileExtent
	#highDpiTodo.	"Should this be scaled?"
	^128 @ 128!

filesTypes
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('PNG Files (*.png)' '*.png')!

fromFile: aFilename 
	^self fromFile: aFilename extent: self defaultExtent!

fromFile: aFilename extent: aPoint 
	| bitmap |
	bitmap := Gdiplus.Bitmap fromFile: aFilename.
	bitmap := (bitmap thumbnailWithExtent: aPoint asPoint) internalize.
	^self fromGdiplusBitmap: bitmap!

icon
	^Icon icon!

imageManager
	"Private - Answer an image manager to use for storing icons"

	^IconImageManager current!

new
	"Answer a new blank instance of the receiver with the default extent.
	Note that if the default extent is changed, this method should be regenerated
	by saving the printString of 'self withExtent: self defaultExtent'"

	^InternalIcon
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 0 31 73 68 65 84 104 67 237 193 1 1 0 0 0 130 32 255 175 110 72 64 0 0 0 0 0 0 0 0 192 137 26 36 48 0 1 192 219 208 191 0 0 0 0 73 69 78 68 174 66 96 130]!

newTile
	"Answer a new blank instance of the receiver with the default tile extent.
	Note that if the default extent is changed, this method should be regenerated
	by saving the printString of 'self withExtent: self defaultTileExtent'"

	^InternalIcon
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 128 0 0 0 128 8 6 0 0 0 195 62 97 203 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 0 87 73 68 65 84 120 94 237 193 49 1 0 0 0 194 160 245 79 109 12 31 32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 184 171 1 0 143 0 1 171 181 19 127 0 0 0 0 73 69 78 68 174 66 96 130]!

stbConvertFrom: anSTBClassFormat
	"Convert from version 0 Resource. Version 1 adds the 'tileColor' instance var"

	^
	[:data |
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance]!

stbVersion
	^1! !

!Graphics.InternalIcon class categoriesForMethods!
badgeTile:color:!instance creation!public! !
badgeTile:color:extent:!instance creation!public! !
defaultExtent!constants!private! !
defaultTileExtent!constants!private! !
filesTypes!constants!private! !
fromFile:!instance creation!public! !
fromFile:extent:!instance creation!public! !
icon!public! !
imageManager!accessing!private! !
new!instance creation!public! !
newTile!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

