"Filed out from Dolphin Smalltalk"!

Graphics.Image
	subclass: #'OS.COM.Picture'
	instanceVariableNames: 'picture extent hmExtent'
	classVariableNames: ''
	imports: #(#{Graphics})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Picture guid: (OS.COM.CLSID fromString: '{0be35204-8f91-11ce-9de3-00aa004bb851}')!

OS.COM.Picture comment: '`OS.COM.Picture` is an `Image` class which wraps the standard OLE picture object.

`Picture` is capable of representing a wide range of image types, including icons, bitmaps, metafiles, and also JPEGs and GIFs. It won''t load PNG''s, however.
The main functionality that `Picture` offers that is not readily available elsewhere is the ability to save images to files, although this has the limitation that it can only save the bitmaps as BMPs, icons as ICOs, and metafiles as EMF. There are much richer capabilities in Gdiplus, so this class is retained for backwards compatibility only.

Example:
```
	pic := OS.COM.Picture fromFile: ''Resources/DolphinSureCert.jpg'' usingLocator: FileLocator installRelative.
	UI.ImagePresenter showOn: pic.
```'!

!OS.COM.Picture categoriesForClass!Graphics-Tools! !

!OS.COM.Picture methodsFor!

addToImageList: anImageList mask: aColorOrNil
	"Private - Add a pictorial representation of the receiver to aWinImageList."

	| type |
	type := self picture type.
	type == IPicture.PICTYPE_ICON
		ifTrue: [anImageList addIcon: self]
		ifFalse: 
			[| bmp |
			bmp := type == IPicture.PICTYPE_BITMAP ifTrue: [self] ifFalse: [self asDIBSection].
			anImageList addBitmap: bmp mask: aColorOrNil]!

asBitmap
	^self asDIBSection!

asDIBSection
	| bitmap |
	bitmap := DIBSection extent: self extent.
	self drawOn: bitmap canvas.
	bitmap freeDC.
	^bitmap!

basicFree
	"Private - Free any external resources referenced by the receiver.
	Implementation Note: We don't supersend because we don't want
	to delete the GDI handle ourselves, leaving that to the OLE picture
	object when it is released."

	picture free!

createHandle
	"Private - Answer an external handle to the image represented by the receiver.
	Implementation Note: Take this opportunity to cache a few details about the
	picture."

	| hPic |
	picture := super createHandle.
	^picture
		ifNil: 
			["By setting a non-zero extent we avoid client code getting division by zero when scaling"
			hmExtent := extent := 1 @ 1.
			0]
		ifNotNil: 
			[| dpi |
			hmExtent := picture extent.
			dpi := SystemMetrics current dpi.
			extent := (dpi * hmExtent x // 2540) @ (dpi * hmExtent y // 2540)].
			picture handle]!

drawDisabledOn: aCanvas at: aPoint extent: sizePoint
	"Draw a disabled/grayed representation of the receiver on aCanvas at aPoint with extent sizePoint."

	self shouldNotImplement!

drawOn: aCanvas at: aPoint extent: sizePoint
	"Draw the receiver on aCanvas at aPoint with size sizePoint."

	| pi hmHeight hPalette oldPalette answer |
	pi := self picture.
	extent isZero ifTrue: [^false].
	hmHeight := hmExtent y.
	hPalette := pi hPal.
	hPalette notNull ifTrue: [oldPalette := aCanvas palette: hPalette].
	answer := pi
				Render: aCanvas asParameter
				x: aPoint x
				y: aPoint y
				cx: sizePoint x
				cy: sizePoint y
				xSrc: 0
				ySrc: hmHeight - 1
				cxSrc: hmExtent x
				cySrc: hmHeight negated
				prcWBounds: nil.
	hPalette notNull
		ifTrue: 
			["Tidy up palette manipulation"
			aCanvas selectPalette: oldPalette].
	^answer == 0!

extent
	"Answers the dimensions of the receiver in pixels"

	self picture.	"Ensure details available"
	^extent!

imageType
	"Private - Answer the Win32 image type for the receiver, if possible."

	^##(LookupTable new
			at: IPicture.PICTYPE_BITMAP put: IMAGE_BITMAP;
			at: IPicture.PICTYPE_ICON put: IMAGE_ICON;
			shrink) at: self picture type!

loadFromFile: pathString extent: aPoint flags: anInteger
	| ipicture |
	ipicture := [IPicture fromFile: pathString] on: HRESULTError
				do: 
					[:ex |
					Notification signal: ('Failed to load OLE Picture from file <1p>: <2s>' expandMacrosWith: pathString
								with: ex messageText).
					nil].
	ipicture isNull
		ifTrue: 
			["Create a stand-in image"
			ipicture := IPicture
						fromIcon: (Icon default withExtent: (aPoint isZero ifTrue: [256 @ 256] ifFalse: [aPoint]))].
	^ipicture!

loadResource: aString fromModule: aResourceLibrary extent: aPoint flags: anInteger 
	^nil!

picture
	"Private - Answer the <IPicture> wrapped by the receiver."

	picture isNull ifTrue: [handle := nil. self realize].
	^picture!

picture: anIPicture
	"Private - Sets the <IPicture> wrapped by the receiver."

	picture := anIPicture
!

resolution
	"Answer an <Point> specifying the horizontal and vertical DPI of the receiver."

	^##(72 @ 72)!

saveAsFile: pathString
	"Save this picture to a file at the specified path, and existing file at that path is
	overwritten."

	| istream |
	istream := IStream write: pathString.
	self picture saveAsFile: istream fSaveMemCopy: true.
	istream free.
! !

!OS.COM.Picture categoriesForMethods!
addToImageList:mask:!double dispatch!private! !
asBitmap!public! !
asDIBSection!converting!public! !
basicFree!private!realizing/unrealizing! !
createHandle!private!realizing/unrealizing! !
drawDisabledOn:at:extent:!drawing-bitmaps!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
extent!accessing!public! !
imageType!constants!private!testing! !
loadFromFile:extent:flags:!private!realizing/unrealizing! !
loadResource:fromModule:extent:flags:!public! !
picture!accessing!private! !
picture:!accessing!private! !
resolution!accessing!public! !
saveAsFile:!file operations!public! !
!

!OS.COM.Picture class methodsFor!

fileTypes
	^#(#('BMP (*.bmp;*.dib;*.rle)' '*.bmp;*.dib;*.rle') #('JPEG (*.jpg;*.jpeg;*.jpe;*.jfif)' '*.jpg;*.jpeg;*.jpe;*.jfif') #('GIF (*.gif)' '*.gif') #('EMF (*.emf)' '*.emf') #('WMF (*.wmf)' '*.wmf') #('ICO (*.ico)' '*.ico') #('All Images' ';*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.jpe;*.jfif;*.gif;*.emf;*.wmf;*.ico') #('All Files (*.*)' '*.*'))!

fromIPicture: anIPicture 
	^(super new)
		picture: anIPicture;
		createHandle;
		yourself!

imageType
	^self shouldNotImplement
! !

!OS.COM.Picture class categoriesForMethods!
fileTypes!instance creation!private! !
fromIPicture:!public! !
imageType!private! !
!

