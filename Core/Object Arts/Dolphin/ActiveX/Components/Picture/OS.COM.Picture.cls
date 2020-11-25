"Filed out from Dolphin Smalltalk 7"!

Image subclass: #OLEPicture
	instanceVariableNames: 'picture extent hmExtent'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
OLEPicture guid: (CLSID fromString: '{0be35204-8f91-11ce-9de3-00aa004bb851}')!
OLEPicture comment: 'OLEPicture is an <Image> class which wraps the standard OLE picture object.

OLEPicture is capable of representing a wide range of image types, including icons, bitmaps, metafiles, and also JPEGs and GIFs.

Example:

	pic := (OLEPicture fromFile: ''Resources/DolphinSureCert.jpg'' usingLocator: FileLocator installRelative).
	ImagePresenter showOn: pic.
'!
!OLEPicture categoriesForClass!Graphics-Tools! !
!OLEPicture methodsFor!

= anObject 
	"Answer whether the receiver and anObject are equivalent.
	Two Images loaded by identifier are equal if they are of the same species, and have the same id and 
	instance handles."

	^self == anObject or: 
			[self species == anObject species and: 
					[self identifier isNil 
						ifTrue: [picture = anObject picture]
						ifFalse: 
							[self identifier = anObject identifier 
								and: [self instanceHandle = anObject instanceHandle]]]]!

addToImageList: aWinImageList mask: aColorOrNil
	"Private - Add a pictorial representation of the receiver to aWinImageList.
	This will work if the receiver is of bitmap or icon types, if not an error will
	be raised by the #imageType method."

	^self imageType == IMAGE_BITMAP 
		ifTrue: [aWinImageList addBitmap: self mask: aColorOrNil]
		ifFalse: [aWinImageList addIcon: self]!

asBitmap
	^self asDIBSection!

asDIBSection
	| bitmap |
	bitmap := DIBSection width: self extent x height: self extent y.
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
	hPic := super createHandle.
	hPic isNull 
		ifTrue: 
			["By setting a non-zero extent we avoid client code getting division by zero when scaling"

			hmExtent := extent := 1 @ 1]
		ifFalse: 
			[| dc |
			self assert: [picture notNull].
			hmExtent := picture extent.
			dc := Canvas forDesktop.
			extent := dc hiMetricToPels: hmExtent.
			dc free].
	^hPic!

drawOn: aCanvas at: aPoint extent: sizePoint
	"Draw the receiver on aCanvas at aPoint with size sizePoint."

	| pi hmHeight hPalette oldPalette answer |
	pi := self picture.
	extent isZero ifTrue: [^false].
	hmHeight := hmExtent y.

	hPalette := pi hPal.
	hPalette notNull ifTrue: [ oldPalette := aCanvas palette: hPalette ].

	answer := pi
		Render: aCanvas asParameter
		x: aPoint x
		y: aPoint y
		cx: sizePoint x
		cy: sizePoint y
		xSrc:	0
		ySrc:	hmHeight - 1
		cxSrc: hmExtent x
		cySrc: hmHeight negated
		prcWBounds: nil.

	hPalette notNull ifTrue: [
		"Tidy up palette manipulation"
		aCanvas selectPalette: oldPalette ].

	^answer==0!

extent
	"Answers the dimensions of the receiver in pixels"

	self picture.	"Ensure details available"
	^extent!

imageType
	"Private - Answer the Win32 image type for the receiver, if possible."

	^##(LookupTable new
			at: 1 put: IMAGE_BITMAP;
			at: 3 put: IMAGE_ICON;
			shrink) at: self picture type!

isPersistent
	"Private - Answer true if the receiver holds sufficient information such that
	it can recreate itself when the image is saved and restored."

	^identifier notNil!

loadFromFile: pathString extent: anObject
	"Private - Attempts to load the receiver from a disk file/url. If the image
	could not be loaded (e.g. the file was not found) then a picture 
	wrapping the standard question mark icon is created. Answers the GDI
	handle of the picture."

	identifier isNil
		ifFalse: 
			[[self picture: (IPicture fromFile: pathString)] on: HRESULTError
				do: 
					[:ex |
					Notification signal: ('Failed to load OLE Picture from file <1p>: <2s>' expandMacrosWith: pathString
								with: ex messageText)]].
	picture isNull
		ifTrue: 
			["Create a stand-in image"
			self picture: (IPicture fromIcon: Icon question)].
	^picture handle!

picture
	"Private - Answer the <IPicture> wrapped by the receiver."

	picture isNull ifTrue: [handle := nil. self realize].
	^picture!

picture: anIPicture
	"Private - Sets the <IPicture> wrapped by the receiver."

	picture := anIPicture
!

saveAsFile: pathString 
	"Save this picture to a file at the specified path, and existing file at that path is
	overwritten."

	| fstream istream |
	fstream := FileStream write: pathString text: false.
	istream := fstream queryInterface: IStream.
	self picture saveAsFile: istream fSaveMemCopy: true.
	istream free.
	fstream close! !
!OLEPicture categoriesFor: #=!comparing!public! !
!OLEPicture categoriesFor: #addToImageList:mask:!double dispatch!private! !
!OLEPicture categoriesFor: #asBitmap!public! !
!OLEPicture categoriesFor: #asDIBSection!converting!public! !
!OLEPicture categoriesFor: #basicFree!private!realizing/unrealizing! !
!OLEPicture categoriesFor: #createHandle!private!realizing/unrealizing! !
!OLEPicture categoriesFor: #drawOn:at:extent:!drawing-bitmaps!public! !
!OLEPicture categoriesFor: #extent!accessing!public! !
!OLEPicture categoriesFor: #imageType!constants!private!testing! !
!OLEPicture categoriesFor: #isPersistent!private!testing! !
!OLEPicture categoriesFor: #loadFromFile:extent:!private!realizing/unrealizing! !
!OLEPicture categoriesFor: #picture!accessing!private! !
!OLEPicture categoriesFor: #picture:!accessing!private! !
!OLEPicture categoriesFor: #saveAsFile:!file operations!public! !

!OLEPicture class methodsFor!

fromIPicture: anIPicture 
	^(super new)
		picture: anIPicture;
		createHandle;
		yourself! !
!OLEPicture class categoriesFor: #fromIPicture:!public! !

