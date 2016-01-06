"Filed out from Dolphin Smalltalk 7"!

InternalBitmap subclass: #InternalIcon
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InternalIcon guid: (GUID fromString: '{7446A3C1-E3AE-45B8-BCA2-BBD493A5C7D3}')!
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

hotspot
	^self extent / 2!

imageIndex
	^Icon imageManager indexOfImage: self!

imageType
	^Win32Constants.IMAGE_ICON! !
!InternalIcon categoriesFor: #asAlphaBitmap:!converting!public! !
!InternalIcon categoriesFor: #asMenuBitmap!converting!public! !
!InternalIcon categoriesFor: #asParameter!public! !
!InternalIcon categoriesFor: #hotspot!public! !
!InternalIcon categoriesFor: #imageIndex!public! !
!InternalIcon categoriesFor: #imageType!public! !

!InternalIcon class methodsFor!

defaultExtent
	^48 @ 48!

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

textTile: aStringLabel color: aColor 
	"Answer an instance of the receiver that is a aStringLabel in white superimposed on a square tile of aColor."

	^self 
		textTile: aStringLabel
		color: aColor
		extent: self defaultExtent!

textTile: aStringLabel color: aColor extent: extent 
	"Answer an instance of the receiver that is a aStringLabel in white superimposed on a square tile of aColor."

	| font |
	font := Font name: 'Arial' pixelSize: extent y - 2.
	^self 
		textTile: aStringLabel
		font: font
		color: aColor
		extent: extent!

textTile: aStringLabel font: aFont color: aColor extent: extent 
	"Answer an instance of the receiver that is a aStringLabel in white  written in aFont and 
	superimposed on a square tile of aColor."

	| bitmap |
	bitmap := GdiplusBitmap extent: extent asPoint.
	bitmap graphics doWithCanvas: 
			[:canvas | 
			| textExtent |
			canvas font: aFont .
			textExtent := canvas textExtent: aStringLabel .
			canvas
				backcolor: aColor ;
				erase;
				forecolor: Color white;
				text: aStringLabel at: (extent asPoint - textExtent) // 2].
	^self fromGdiplusBitmap: bitmap! !
!InternalIcon class categoriesFor: #defaultExtent!private! !
!InternalIcon class categoriesFor: #filesType!constants!private! !
!InternalIcon class categoriesFor: #fromFile:!instance creation!public! !
!InternalIcon class categoriesFor: #fromFile:extent:!instance creation!public! !
!InternalIcon class categoriesFor: #imageManager!accessing!private! !
!InternalIcon class categoriesFor: #new!instance creation!public! !
!InternalIcon class categoriesFor: #textTile:color:!instance creation!public! !
!InternalIcon class categoriesFor: #textTile:color:extent:!instance creation!public! !
!InternalIcon class categoriesFor: #textTile:font:color:extent:!instance creation!public! !

