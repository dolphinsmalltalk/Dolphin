"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.Image'
	instanceVariableNames: 'initializer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Image guid: (Core.GUID fromString: '{87b4c635-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.Image isNonInstantiable: true!

Graphics.Image comment: 'Image is the class of <GraphicsTools>s that represent pictures which can be drawn onto the display (or other device).

Instance Variables:
	fileLocator		<fileLocator> used to complete the relative path held as the ''identifier'' when loading the image.
	identifier		<String> identifying the file from which the image was or should be loaded, or the resource identifier.
	instanceHandle	<ExternalLibrary> (usually <ExternalResourceLibrary) represent the module from which the image was loaded.

'!

!Graphics.Image categoriesForClass!Graphics-Tools! !

!Graphics.Image methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent.
	Two Images loaded by identifier are equal if they are of the same species, and either have equal initializers, or equal handles."

	^self == anObject or: [self species == anObject species and: [initializer = anObject initializer]]!

addToImageList: aWinImageList mask: aColorOrNil
	"Add a pictorial representation of the receiver to aWinImageList"

	^self subclassResponsibility!

asSharedCopy
	"For compatibility with bitmaps."

	^self!

basicFree
	"Private - Free up external resources held by the receiver. Ignore any errors which might arise."

	self class freeHandle: handle!

copy
	^(super copy)
		ownedHandle: self copyHandle;
		yourself!

copyHandle
	"Private - Answer an external handle to the image which is a copy of that represented by the receiver."

	^User32
		copyImage: self handle
		uType: self imageType
		cxDesired: 0
		cyDesired: 0
		fuFlags: 0!

createHandle
	"Private - Answer an external handle to the image represented by the receiver."

	^initializer createImage: self!

drawDisabledOn: aCanvas at: aPoint extent: sizePoint
	"Draw a disabled/grayed representation of the receiver on aCanvas at aPoint with extent sizePoint."

	^self subclassResponsibility

!

drawOn: aCanvas
	"Draw the receiver to aCanvas at position aPoint (no stretching).
	Answer whether the operation succeeded."

	^self drawOn: aCanvas at: Point.Zero!

drawOn: aCanvas at: aPoint
	"Draw the receiver to aCanvas at position aPoint (no stretching).
	Answer whether the operation succeeded."

	^self drawOn: aCanvas at: aPoint extent: self extent!

drawOn: aCanvas at: aPoint extent: sizePoint
	"Draw the receiver on aCanvas at aPoint with size sizePoint."

	^self subclassResponsibility

!

extent
	"Answers the dimensions of the receiver in pixels"

	^self subclassResponsibility!

fileLocator
	^initializer fileLocator!

freeDC
	"Free the receiver's cached memory DC, if any."

	!

hash
	"Answer the hash of the identifier. Although #= is implemented to compare
	both identifer and instanceHandles we don't need to take account of the latter
	here since it is only necessary that equal objects have the same hash value not
	vice versa."

	^initializer hash!

hotspot
	"Answer a Point specifying the receiver's hot spot (only really relevant for cursors)."

	^0@0
!

identifier
	^initializer identifier!

imageManager
	"Answer an image manager to use for storing images"

	^self class imageManager!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^self class imageType!

initializer
	^initializer!

initializer: anImageInitializer
	initializer := anImageInitializer!

isPersistent
	"Private - Answer true if the receiver holds sufficient information such that it can recreate itself when the image is saved and restored. This is generally true for images if they have an identifier."

	^initializer isPersistent!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^initializer isSelfEvaluatingImage: self!

isShared
	"Private - Answer true if the receiver is in the shared cache.
	Shared images must be copied if they will be modified in any way."

	^false!

isTransparent
	"Answer whether the receiver will be, or was, loaded as a 'transparent' bitmap (that is with the LR_LOADTRANSPARENT flag)."

	^initializer isLoadTransparent!

isTransparent: aBoolean
	"Set whether the receiver will be loaded as a 'transparent' bitmap (that is with the LR_LOADTRANSPARENT flag). If the bitmap is already realized then this has no effect."

	initializer isLoadTransparent: aBoolean!

loadFromFile: aString extent: aPoint flags: anInteger
	^User32
		loadImage: 0
		lpszName: aString
		uType: self imageType
		cxDesired: aPoint x
		cyDesired: aPoint y
		fuLoad: ((aPoint = Point.Zero
				ifTrue: [##(LR_DEFAULTSIZE bitOr: LR_LOADFROMFILE)]
				ifFalse: [LR_LOADFROMFILE]) bitOr: anInteger)!

loadResource: identifierObject fromModule: moduleObject extent: aPoint flags: anInteger
	^User32
		loadImage: moduleObject asParameter
		lpszName: identifierObject asResourceId
		uType: self imageType
		cxDesired: aPoint x
		cyDesired: aPoint y
		fuLoad: (aPoint = Point.Zero ifTrue: [anInteger bitOr: LR_DEFAULTSIZE] ifFalse: [anInteger])!

printOn: aStream
	initializer printImage: self on: aStream!

resolution
	"Answer an <Point> specifying the horizontal and vertical DPI of the receiver."

	^##(USER_DEFAULT_SCREEN_DPI @ USER_DEFAULT_SCREEN_DPI)!

setInitializer: anImageInitializer
	self initialize.
	initializer := anImageInitializer.
	^self! !

!Graphics.Image categoriesForMethods!
=!comparing!public! !
addToImageList:mask:!public!testing! !
asSharedCopy!converting!public! !
basicFree!private!realizing/unrealizing! !
copy!copying!public! !
copyHandle!private!realizing/unrealizing! !
createHandle!private!realizing/unrealizing! !
drawDisabledOn:at:extent:!drawing-bitmaps!public! !
drawOn:!drawing-bitmaps!public! !
drawOn:at:!drawing-bitmaps!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
extent!accessing!public! !
fileLocator!accessing!public! !
freeDC!public!realizing/unrealizing! !
hash!comparing!public! !
hotspot!accessing!public! !
identifier!accessing!public! !
imageManager!accessing!public! !
imageType!constants!private!testing! !
initializer!public! !
initializer:!initializing!public! !
isPersistent!private!testing! !
isSelfEvaluating!public!testing! !
isShared!private!testing! !
isTransparent!accessing!public! !
isTransparent:!accessing!public! !
loadFromFile:extent:flags:!private!realizing/unrealizing! !
loadResource:fromModule:extent:flags:!private!realizing/unrealizing! !
printOn:!printing!public! !
resolution!accessing!public! !
setInitializer:!private! !
!

Graphics.Image methodProtocol: #image attributes: #(#readOnly) selectors: #(#addToImageList:mask: #drawOn: #drawOn:at: #drawOn:at:extent: #extent #freeDC #isPersistent)!

!Graphics.Image class methodsFor!

defaultCreationExtent
	"Private - Answer the size to request as the default extent to request when creating an image of this type."

	^Point.Zero!

defaultExtent
	^Point.Zero
!

defaultHandle
	^0
!

defaultLoadFlags
	^LR_COLOR!

filesType
	^nil!

freeHandle: anExternalHandle
	Gdi32 deleteObject: anExternalHandle!

fromFile: aFilename
	"Answer an instance loaded from the file aFilename.
	Note that aFilename will be converted to an installation relative path. If you want 
	to access an image at an absolute path, you should set it up using #fromFile:usingLocator:
	in conjuction with an AbsoluteFileLocator. e.g:

		ImagePresenter show: 'Basic image' on: 
			(Bitmap
				fromFile: 'Resources\Beach ball.bmp'
				usingLocator: FileLocator installRelative)
	"

	^self fromFile: aFilename usingLocator: FileLocator default!

fromFile: aString usingLocator: aFileLocator
	"Answer an instance loaded from the file aString by using aFileLocator."

	| relativeFilename |
	relativeFilename := (aFileLocator isNil or: [File isRelativePath: aString])
				ifTrue: [aString]
				ifFalse: [aFileLocator relativePathTo: aString].
	^self initializer: (self newFileInitializer: relativeFilename locator: aFileLocator)!

fromHandle: aHandle
	^(self initializer: (ImageFromHandleInitializer handle: aHandle))
		ownsHandle: false;
		handle: aHandle;
		yourself!

fromId: anIntegerOrStringId
	"Answer a new instance with a resource Id of anIntegerOrStringId."

	^self fromId: anIntegerOrStringId in: SessionManager.Current defaultResourceLibrary!

fromId: anIntegerOrStringId in: anInstanceHandle
	"Answer a new instance with a resourceID of anIntegerOrStringId from the application instance anInstanceHandle"

	^self initializer: (self newResourceInitializer: anIntegerOrStringId module: anInstanceHandle)!

fromId: anIntegerOrStringId in: anInstanceHandle extent: aPoint
	"Answer a new instance with a resourceID of anIntegerOrStringId from the application instance anInstanceHandle, to be loaded at the extent, aPoint."

	| instance |
	instance := self
				fromId: anIntegerOrStringId
				in: anInstanceHandle.
	instance initializer extent: aPoint.
	^instance!

fromOwnedHandle: aHandle
	^self initializer: (ImageFromHandleInitializer handle: aHandle)!

fromSystemId: anIntegerId
	"Answer a new instance of the Windows pre-defined icon specified by anIntegerID."

	^self fromId: anIntegerId in: 0.
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

imageManager
	"Answer an image manager to use for storing images"

	^ImageManager new!

imageType
	^self subclassResponsibility
!

initializer: anImageInitializer
	^self basicNew setInitializer: anImageInitializer!

newFileInitializer: aString locator: aFileLocator
	^ImageFromFileInitializer
		filename: aString
		fileLocator: aFileLocator
		flags: self defaultLoadFlags!

newInitializerFromStbVersion3: anArray
	^(anArray at: 5)
		ifNil: [self newFileInitializer: (anArray at: 4) locator: (anArray at: 3)]
		ifNotNil: 
			[:instanceHandle |
			instanceHandle == 0
				ifTrue: [self newSystemInitializer: (anArray at: 4)]
				ifFalse: [self newResourceInitializer: (anArray at: 4) module: instanceHandle]]!

newResourceInitializer: anIntegerOrStringId module: anInstanceHandle
	^(anIntegerOrStringId isString
		ifTrue: [ImageFromStringResourceInitializer]
		ifFalse: [ImageFromResourceInitializer])
			identifier: anIntegerOrStringId
			module: anInstanceHandle
			flags: (self defaultLoadFlags bitOr: LR_SHARED)!

newSystemInitializer: anInteger
	^self newResourceInitializer: anInteger module: 0!

stbConvertFrom: anSTBClassFormat
	| version |
	version := anSTBClassFormat version.
	version == 3 ifTrue: [^[:data | (self stbConvertFromVersion3: data) becomeA: self]].
	version == 2 ifTrue: [^[:data | (self stbConvertFromVersion2: data) becomeA: self]].
	version == 1 ifTrue: [^[:data | (self stbConvertFromVersion1: data) becomeA: self]].
	version == 0 ifTrue: [^[:data | (self stbConvertFromVersion0: data) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersion0: anArray
	"Private - Only relevant for Bitmaps"

	^self stbConvertFromVersion1: anArray!

stbConvertFromVersion1: anArray
	"Private - Only relevant for Bitmaps"

	^self stbConvertFromVersion2: anArray!

stbConvertFromVersion2: anArray
	"Private - Version 3 added locator (FileLocator) instance variable."

	| count |
	count := anArray size + 1.
	^self stbConvertFromVersion3: ((Array new: count)
				replaceFrom: 1
					to: 2
					with: anArray
					startingAt: 1;
				at: 3 put: FileLocator default;
				replaceFrom: 4
					to: count
					with: anArray
					startingAt: 3;
				yourself)!

stbConvertFromVersion3: anArray
	"Private - Version 4 replaces the identifier, fileLocator and instanceHandle instance variables with initializer."

	| count |
	count := anArray size - 2.
	^(Array new: count)
		replaceFrom: 1
			to: 2
			with: anArray
			startingAt: 1;
		at: 3 put: (self newInitializerFromStbVersion3: anArray);
		replaceFrom: 4
			to: count
			with: anArray
			startingAt: 6;
		yourself!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^4! !

!Graphics.Image class categoriesForMethods!
defaultCreationExtent!constants!private! !
defaultExtent!private! !
defaultHandle!private! !
defaultLoadFlags!constants!private! !
filesType!constants!private! !
freeHandle:!private!realizing/unrealizing! !
fromFile:!instance creation!public! !
fromFile:usingLocator:!instance creation!public! !
fromHandle:!instance creation!public! !
fromId:!instance creation!public! !
fromId:in:!public! !
fromId:in:extent:!public! !
fromOwnedHandle:!instance creation!public! !
fromSystemId:!instance creation!public! !
icon!constants!public! !
imageManager!accessing!public! !
imageType!private! !
initializer:!public! !
newFileInitializer:locator:!helpers!private! !
newInitializerFromStbVersion3:!binary filing!private! !
newResourceInitializer:module:!helpers!private! !
newSystemInitializer:!helpers!private! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion0:!binary filing!private! !
stbConvertFromVersion1:!binary filing!private! !
stbConvertFromVersion2:!binary filing!private! !
stbConvertFromVersion3:!binary filing!private! !
stbVersion!binary filing!public! !
!

