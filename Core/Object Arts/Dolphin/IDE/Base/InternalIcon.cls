"Filed out from Dolphin Smalltalk 7"!

InternalBitmap subclass: #InternalIcon
	instanceVariableNames: 'tileColor'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!
InternalIcon guid: (GUID fromString: '{7446a3c1-e3ae-45b8-bca2-bbd493a5c7d3}')!
InternalIcon comment: 'An InternalIcon is capable of holding it''s image bytes internally in the Smalltalk image. Thus it is no longer necessary to refer to external files outside the image to make use of Icon resources. This has several advantages, including the ability to version InternalIcon resources into STS as part of a Smalltalk method and the fact that fewer external files need to be distributed with an application.

USAGE:

(1) If you want to install a class side #icon method for one of your classes simply go to any workspace and evaluate:

MyClass createIconMethod.

This will prompt for a (usually PNG) file, and then create a MyClass class>>icon method for it. If you browse this method you''ll see answers an instance of InternalIcon instantiated from a literal byte array. Note that InternalIcons automatically reformat any image to 48@48 pixels by default.

(2) If you want to add an InternalIcon to a toolbar, in the View Composer first create a ToolbarIconButton in your toolbar and locate the commandDescription/image aspect for this button. Then type and accept:

InternalIcon chooseFile

This will prompt you for a suitable image file (again PNG files work best) and will load the image bytes into a literal byte array from which the InternalIcon can be instantiated when required. 

'!
!InternalIcon categoriesForClass!Kernel-Objects! !
!InternalIcon methodsFor!

= comperand 
	^super = comperand and: [self tileColor = comperand tileColor]!

addToImageList: aWinImageList mask: aColorOrNil 
	^(tileColor isNil ifTrue: [gdiplusBitmap] ifFalse: [self tileBitmapWithExtent: aWinImageList extent]) 
		addToImageList: aWinImageList
		mask: aColorOrNil!

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

asMenuBitmap
	"Answer a 32-bpp bitmap (i.e. with alpha channel) containing the receiver's image at system
	menu image extent. Note that the result will be a shared bitmap which is always the same
	instance for the same icon."

	^self class imageManager menuBitmapForIcon: self!

asParameter
	"Create an icon from the image list so we can answer the handle"

	^self asIcon detachHandle!

bitmap
	^tileColor isNil ifTrue: [gdiplusBitmap] ifFalse: [self tileBitmapWithExtent: gdiplusBitmap extent]!

drawOn: aCanvas at: dstOrigin extent: dstExtent 
	tileColor ifNotNil: [aCanvas fillRectangle: (dstOrigin extent: dstExtent) color: tileColor].
	self gdiplusBitmap 
		drawOn: aCanvas
		at: dstOrigin
		extent: dstExtent!

drawOnGraphics: aGraphics at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent unit: aUnit attributes: aImageAtt 
	tileColor 
		ifNotNil: 
			[aGraphics fillRectangle: (dstOrigin extent: dstExtent)
				brush: (GdiplusSolidBrush color: tileColor asARGB)].
	^self gdiplusBitmap 
		drawOnGraphics: aGraphics
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: srcExtent
		unit: aUnit
		attributes: aImageAtt!

hash
	^super hash + tileColor hash!

hotspot
	^self extent / 2!

imageIndex
	^Icon imageManager indexOfImage: self!

imageType
	^Win32Constants.IMAGE_ICON!

tileBitmapWithExtent: extent 
	| tileBitmap graphics |
	tileBitmap := GdiplusBitmap extent: extent.
	graphics := tileBitmap graphics.
	
	[graphics interpolationMode: InterpolationModeHighQualityBicubic.
	self 
		drawOnGraphics: graphics
		at: Point zero
		extent: extent
		from: Point zero
		extent: self extent
		unit: nil
		attributes: nil] 
			ensure: [graphics free].
	^tileBitmap!

tileColor
	^tileColor!

tileColor: aColor 
	tileColor := aColor! !
!InternalIcon categoriesFor: #=!comparing!comparison!public! !
!InternalIcon categoriesFor: #addToImageList:mask:!double dispatch!private! !
!InternalIcon categoriesFor: #asAlphaBitmap:!converting!public! !
!InternalIcon categoriesFor: #asMenuBitmap!converting!public! !
!InternalIcon categoriesFor: #asParameter!public! !
!InternalIcon categoriesFor: #bitmap!accessing!public! !
!InternalIcon categoriesFor: #drawOn:at:extent:!drawing-bitmaps!public! !
!InternalIcon categoriesFor: #drawOnGraphics:at:extent:from:extent:unit:attributes:!drawing-gdiplus!public! !
!InternalIcon categoriesFor: #hash!comparing!comparison!public! !
!InternalIcon categoriesFor: #hotspot!public! !
!InternalIcon categoriesFor: #imageIndex!public! !
!InternalIcon categoriesFor: #imageType!public! !
!InternalIcon categoriesFor: #tileBitmapWithExtent:!accessing!helpers!private! !
!InternalIcon categoriesFor: #tileColor!accessing!private! !
!InternalIcon categoriesFor: #tileColor:!accessing!private! !

!InternalIcon class methodsFor!

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
	^48 @ 48!

defaultTileExtent
	^128 @ 128!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('PNG Files (*.png)' '*.png')!

fromFile: aFilename 
	^self fromFile: aFilename extent: self defaultExtent!

fromFile: aFilename extent: aPoint 
	| bitmap |
	bitmap := GdiplusBitmap fromFile: aFilename.
	bitmap := (bitmap thumbnailWithExtent: aPoint asPoint) internalize.
	^self fromGdiplusBitmap: bitmap!

imageManager
	"Private - Answer an image manager to use for storing icons"

	^IconImageManager current!

new
	^self withExtent: self defaultExtent!

stbConvert: anArray fromVersion: anInteger 
	"Private - Convert from earlier version view by updating and answering the array of instance
	variables, instVarArray. "

	| instVars |
	instVars := anArray.
	anInteger < 1 ifTrue: [instVars := self stbConvertFromVersion0: instVars].
	^instVars!

stbConvertFrom: anSTBClassFormat 
	"Private - Convert from previous version resource. 
	Version Changes:
		1: Added 'tileColor' instance variable to InternalIcon (#346, 349)."

	^
	[:data | 
	| answer instVars |
	instVars := self stbConvert: data fromVersion: anSTBClassFormat version.
	answer := self basicNew.
	1 to: instVars size do: [:i | answer instVarAt: i put: (instVars at: i)].
	answer]!

stbConvertFromVersion0: anArray 
	"Private - Perform an STB conversion from a version 0 <InternalIcon> to version 1.
	i.e. insert 'tileColor' instance variable (which should always be nil in an STB stream)."

	^(Array new: anArray size + 1)
		replaceFrom: 2
			to: anArray size + 1
			with: anArray
			startingAt: 1;
		yourself!

stbVersion

	^1! !
!InternalIcon class categoriesFor: #badgeTile:color:!public! !
!InternalIcon class categoriesFor: #badgeTile:color:extent:!public! !
!InternalIcon class categoriesFor: #defaultExtent!private! !
!InternalIcon class categoriesFor: #defaultTileExtent!private! !
!InternalIcon class categoriesFor: #filesType!constants!private! !
!InternalIcon class categoriesFor: #fromFile:!instance creation!public! !
!InternalIcon class categoriesFor: #fromFile:extent:!instance creation!public! !
!InternalIcon class categoriesFor: #imageManager!accessing!private! !
!InternalIcon class categoriesFor: #new!instance creation!public! !
!InternalIcon class categoriesFor: #stbConvert:fromVersion:!binary filing!private! !
!InternalIcon class categoriesFor: #stbConvertFrom:!binary filing!private! !
!InternalIcon class categoriesFor: #stbConvertFromVersion0:!binary filing!private! !
!InternalIcon class categoriesFor: #stbVersion!binary filing!private! !

