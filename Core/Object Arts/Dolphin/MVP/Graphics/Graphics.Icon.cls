"Filed out from Dolphin Smalltalk"!

Graphics.Image
	subclass: #'Graphics.Icon'
	instanceVariableNames: ''
	classVariableNames: 'Blank DefaultApplication Error HasScaleDown Information Question Warning WinLogo'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'LargestStandardSize' -> (16r100 @ 16r100).
			'StandardSizeMap' -> {
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r10 @ 16r10.
						16r14 @ 16r14.
						16r14 @ 16r14.
						16r14 @ 16r14.
						16r14 @ 16r14.
						16r18 @ 16r18.
						16r18 @ 16r18.
						16r18 @ 16r18.
						16r18 @ 16r18.
						16r18 @ 16r18.
						16r18 @ 16r18.
						16r18 @ 16r18.
						16r18 @ 16r18.
						16r20 @ 16r20.
						16r20 @ 16r20.
						16r20 @ 16r20.
						16r20 @ 16r20.
						16r20 @ 16r20.
						16r20 @ 16r20.
						16r20 @ 16r20.
						16r20 @ 16r20.
						16r28 @ 16r28.
						16r28 @ 16r28.
						16r28 @ 16r28.
						16r28 @ 16r28.
						16r28 @ 16r28.
						16r28 @ 16r28.
						16r28 @ 16r28.
						16r28 @ 16r28.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r30 @ 16r30.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r40 @ 16r40.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r60 @ 16r60.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80.
						16r80 @ 16r80
					}
		}!

Graphics.Icon guid: (Core.GUID fromString: '{87b4c63e-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.Icon comment: 'Icon is the class of <Image>s that represent Windows'' icons (essentially a pair of bitmaps, one of which is a mask used to draw the other bitmap transparently).

Class Variables:
	Question			<Icon>. Standard system questionmark icon.
	WinLogo			<Icon>. Standard windows logo icon.
	Blank				<Icon>. A blank icon.
	DefaultApplication	<Icon>. Standard windows "application" icon.
	Information			<Icon>. Standard system information icon, as used in informational message boxes.
	Error				<Icon>. Standard system error icon, as used in error message boxes.
	Warning			<Icon>. Standard system warning icon, as used in warning message boxes.

'!

!Graphics.Icon categoriesForClass!Graphics-Tools! !

!Graphics.Icon methodsFor!

addToImageList: aWinImageList mask: aColorOrNil
	"Private - Add a pictorial representation of the receiver to the <WinImageList>
	argument, using the <Color> argument as the mask colour (although in this
	case the specified mask colour is ignored as the Icon has its own mask)."

	^self
		valueWithHandle: [:hIcon | aWinImageList addIcon: hIcon]
		extent: aWinImageList extent!

asAlphaBitmap: aPoint
	"Answer a 32-bpp RGBA DIBSection (i.e. with Alpha channel) that contains the receiver's image rendered at the specified size."

	^DIBSection initializer: (BitmapFromIconInitializer extent: aPoint icon: self)!

asCursor
	"Icon's can be used as Cursors. The only real difference is that cursors have a specific hotspot other than the top left corner."

	^self!

asIcon
	^self!

asSharedBitmap: aPoint
	"Answer a 32-bpp bitmap (i.e. with alpha channel) containing the receiver's image at the specified extenT. The result will be a shared bitmap which is always the same
	instance for the same icon."

	^self imageManager bitmapForIcon: self extent: aPoint!

createHandle
	"Private - Answer an external handle to the image represented by the receiver.
	If the icon is not found, then use the handle of a default icon. 
	We could allow a walkback to occur but this could interfere with the system 
	browsers so we silently display a dummy icon in place of the dud."

	^super createHandle
		ifNil: 
			["Use Question icon if not realizable"
			self class defaultHandle]!

drawDisabledOn: aCanvas at: aPoint extent: sizePoint
	"Draw a disabled/grayed representation of the receiver on aCanvas at aPoint with extent sizePoint."

	^User32
		drawState: aCanvas asParameter
		hbr: nil
		lpOutputFunc: nil
		lData: self asParameter asInteger
		wData: 0
		x: aPoint x
		y: aPoint y
		cx: sizePoint x
		cy: sizePoint y
		fuFlags: ##(DST_ICON | DSS_DISABLED)!

drawOn: aCanvas at: aPoint
	"Copies the receiver to aCanvas at position aPoint."

	^self 
		drawOn: aCanvas
		at: aPoint
		frame: 1
		background: nil!

drawOn: aCanvas at: aPoint extent: sizePoint
	"Copies the receiver to aCanvas at position aPoint with size sizePoint."

	^self
		drawOn: aCanvas 
		at: aPoint 
		extent: sizePoint 
		frame: 1 
		background: nil!

drawOn: aCanvas at: aPoint extent: sizePoint frame: anInteger background: aBrush
	"Copies the receiver to aCanvas at position aPoint with size sizePoint
	with frame anInteger and background aBrush."

	^self 
		drawOn: aCanvas 
		at: aPoint 
		extent: sizePoint 
		frame: anInteger 
		background: aBrush 
		flags: DI_NORMAL!

drawOn: aCanvas at: aPoint extent: sizePoint frame: anInteger background: aBrush flags: flagsInteger
	"Copies the receiver to aCanvas at position aPoint with size sizePoint with frame anInteger and background aBrush. Answer whether the frame could be drawn. 
	Note that the frame number is ignored if the receiver is not an animated icon/cursor."

	^sizePoint strictlyPositive and: 
			[self valueWithHandle: 
					[:hIcon |
					User32
						drawIconEx: aCanvas asParameter
						xLeft: aPoint x
						yTop: aPoint y
						hIcon: hIcon
						cxWidth: sizePoint x
						cyHeight: sizePoint y
						istepIfAniCur: anInteger
						hbrFlickerFreeDraw: aBrush asParameter
						diFlags: flagsInteger]
				extent: sizePoint]!

drawOn: aCanvas at: aPoint frame: anInteger background: aBrush
	"Copies the receiver to aCanvas at position aPoint with frame anInteger and 
	background aBrush."

	^self
		drawOn: aCanvas
		at: aPoint
		extent: Point.Zero
		frame: anInteger
		background: aBrush
		flags: ##(DI_DEFAULTSIZE | DI_NORMAL)!

extent
	"Answers the dimensions of the receiver in pixels. If the receiver has an explicit extent specified, then this is that extent.
	If the receiver does not have a specified extent:
		- If the receiver is realized, the extent of the foreground bitmap accessed via GetIconInfo; otherwise
		- the standard system large icon extent (32x32)"

	^initializer extent
		ifNil: 
			[handle notNull
				ifTrue: 
					[| extent info |
					info := self getIconInfo.
					extent := info extent.
					"free the ICONINFO in order to release the bmp's."
					info free.
					extent]
				ifFalse: [self class defaultExtent]]!

fileLocator
	^self shouldNotImplement!

getIconInfo
	"Private - Answer an ICONINFO structure populated with info. about the receiver.
	N.B. This is quite an expensive operation, as it involves the creation of foreground
	and mask bitmaps for the icon."

	| info |
	info := ICONINFO new.
	(User32 getIconInfo: self asParameter piconinfo: info) ifFalse: [User32 systemError].
	^info!

hotspot
	"Answer a Point specifying the receiver's hot spot (only really relevant for cursors)."

	| info answer |
	info := self getIconInfo.
	answer := info hotspot.
	info free.
	^answer!

icon
	^self!

identifier: id
	"Set the identifier of the receiver. This can be a string or an integer."

	self shouldNotImplement!

imageIndex
	"Answer the image index of the receiver in our ImageManager of all icons."

	^self imageManager indexOfImage: self.
!

includesFrame: frameNumber
	"Answer whether the receiver contains a frame of frameNumber.
	Sadly we need to attempt to draw the specified frame to determine whether it
	exists (unless we can find another way - suggestions please!!)
	Note that the answer will always be true, regardless of the frame number, if
	the receiver is not an animated cursor."

	| hDC includes screenDC |
	screenDC := User32 getDC: nil.
	hDC := Gdi32 createCompatibleDC: screenDC.
	includes := self
				drawOn: hDC
				at: Point.Zero
				frame: frameNumber
				background: nil.
	Gdi32 deleteDC: hDC.
	User32 releaseDC: nil hDC: screenDC.
	^includes!

loadFromSystem: anInteger extent: aPoint
	^(HasScaleDown and: [aPoint ~= Point.Zero])
		ifTrue: 
			[| hIcon |
			hIcon := External.Handle new.
			(ComCtl32
				loadIconWithScaleDown: 0
				pszName: anInteger
				cx: aPoint x
				cy: aPoint y
				phico: hIcon) >= 0
				ifTrue: [hIcon]]
		ifFalse: 
			["Oddly, LoadImageW does not load system icons when passed a null HINSTANCE and an integer resource id, as might be expected, rather it treats that as a request to load one of the OEM images, so we must use LoadIcon."
			User32 loadIcon: 0 lpIconName: anInteger]!

loadResource: identifierObject fromModule: moduleObject extent: aPoint flags: anInteger
	^(HasScaleDown and: [aPoint ~= Point.Zero])
		ifTrue: 
			[| hIcon |
			hIcon := Handle new.
			(ComCtl32
				loadIconWithScaleDown: moduleObject asParameter
				pszName: identifierObject asResourceId
				cx: aPoint x
				cy: aPoint y
				phico: hIcon) >= 0
				ifTrue: [hIcon]]
		ifFalse: 
			[super
				loadResource: identifierObject
				fromModule: moduleObject
				extent: aPoint
				flags: anInteger]!

makeCurrent
	"Make the receiver become the current global cursor."

	Cursor current: self!

setCursor
	"Private - Set the receiver as the current Windows cursor. Answers the handle of the old
	cursor."

	^User32 setCursor: self asParameter!

showWhile: aBlock
	"Maintain the receiver as the current cursor while aBlock is executed, answering the result of the block.
	The actual cursor which was current is restored (rather than the one we think is Current)."

	| previous actual |
	previous := Cursor.Current.
	Cursor.Current := self.
	actual := self setCursor.
	^aBlock ensure: 
			[Cursor.Current := previous.
			User32 setCursor: actual]!

valueWithHandle: operation extent: aPoint
	"Private - Evaluate the <monadicValuable>, operation, with a handle for the receiver's icon at the best possible rendering for the specified extent.The icon will be scaled down from the next largest icon if the requested size is not available, which generally yields a better result than scaling up."

	^initializer
		image: self
		valueWithHandle: operation
		extent: aPoint!

withExtent: aPoint
	"Answer an <Icon> that has the specified preferred extent. This is the extent that will be requested when the icon is loaded, which can be useful when passing an icon to a Windows API as an HICON. In this case the API will generally expect the icon to be the correct size, and hence when drawn if the icon is too large or too small it will get scaled down or up (respectively) and not look as good as it might if the correct size were supplied."

	^initializer extent = aPoint
		ifTrue: [self]
		ifFalse: [self class initializer: (initializer copy extent: aPoint)]! !

!Graphics.Icon categoriesForMethods!
addToImageList:mask:!double dispatch!private! !
asAlphaBitmap:!converting!public! !
asCursor!converting!public! !
asIcon!public! !
asSharedBitmap:!converting!public! !
createHandle!private!realizing/unrealizing! !
drawDisabledOn:at:extent:!drawing-bitmaps!public! !
drawOn:at:!drawing-bitmaps!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
drawOn:at:extent:frame:background:!drawing-bitmaps!public! !
drawOn:at:extent:frame:background:flags:!drawing-bitmaps!public! !
drawOn:at:frame:background:!drawing-bitmaps!public! !
extent!accessing!public! !
fileLocator!accessing!public! !
getIconInfo!helpers!private! !
hotspot!accessing!public! !
icon!constants!public! !
identifier:!accessing!public! !
imageIndex!accessing!public! !
includesFrame:!public!searching! !
loadFromSystem:extent:!private!realizing/unrealizing! !
loadResource:fromModule:extent:flags:!private!realizing/unrealizing! !
makeCurrent!operations!public! !
setCursor!operations!private! !
showWhile:!operations!public! !
valueWithHandle:extent:!private! !
withExtent:!converting!public! !
!

Graphics.Icon methodProtocol: #icon attributes: #(#readOnly) selectors: #(#asAlphaBitmap: #asParameter #asSharedBitmap: #drawOn: #drawOn:at: #drawOn:at:extent: #extent #imageIndex #isPersistent #isRealized #withExtent:)!

!Graphics.Icon class methodsFor!

asterisk
	"Answer a new instance of the Asterisk icon (used in informative messages)"

	^self information!

blank
	Blank isNil ifTrue: [Blank := self fromId: 'Blank.ico'].
	^Blank!

cacheSystemMetrics
	| metrics |
	metrics := SystemMetrics current.
	HasScaleDown := metrics hasIconScaleDown!

clear
	"Clean up the image manager for all icons. We start with no image representation
	for our icons, they are added lazily as they are accessed usng #imageIndex."

	self imageManager purge!

clearCached
	self
		resetSystemInstances;
		cacheSystemMetrics!

default
	^self question!

defaultApplication
	"Answer a new instance of the default application icon"

	DefaultApplication isNil ifTrue: [DefaultApplication := self fromSystemId: IDI_APPLICATION].
	^DefaultApplication
!

defaultExtent
	"Answer a Point that gives the dimensions of a standard size icon at the current system DPI."

	^SystemMetrics current largeIconExtent!

defaultHandle
	^self question handle
!

error
	"Answer a new instance of the default system 'error' icon (used in serious warning messages)"

	^Error ifNil: [Error := self fromSystemId: IDI_ERROR]!

exclamation
	"Answer a new instance of the Exclamation mark icon (used in warning messages)"

	^self warning!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Icon Files (*.ico)' '*.ico')!

freeHandle: anExternalHandle
	User32 destroyIcon: anExternalHandle!

fromBitmap: aBitmap 
	^self initializer: (IconFromBitmapInitializer bitmap: aBitmap)!

fromSystemId: anIntegerId
	"Answer a new instance of the Windows pre-defined icon specified by anIntegerID."

	^self initializer: (self newSystemInitializer: anIntegerId)!

fromSystemId: anIntegerId extent: aPoint
	"Answer a new instance of the Windows pre-defined icon specified by anIntegerID."

	^self initializer: (IconFromSystemInitializer extent: aPoint identifier: anIntegerId)!

hand
	"Answer a new instance of the Hand-shaped icon (used in serious warning messages)"

	^self error
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

imageManager
	"Answer the image manager to use for storing icons"

	^IconImageManager current!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^IMAGE_ICON!

information
	"Answer a new instance of the default system 'information' icon (used in informative messages)"

	^Information ifNil: [Information := self fromSystemId: IDI_INFORMATION]!

initialize
	"
		self initialize
	"

	| standardSizes mapStream sizeStream next current |
	standardSizes := #(16 20 24 32 40 48 64 96 128 256) collect: [:each | (each @ each) isImmutable: true; yourself ].
	self addClassConstant: 'LargestStandardSize' value: standardSizes last.
	mapStream := Array writeStream.
	sizeStream := standardSizes readStream.
	current := sizeStream next.
	mapStream next: 15 put: standardSizes first.
	[sizeStream atEnd] whileFalse: [
		next := sizeStream next.
		mapStream next: next y - current y put: current.
		current := next].
	self addClassConstant: 'StandardSizeMap' value: mapStream contents!

newSystemInitializer: anInteger
	^IconFromSystemInitializer identifier: anInteger!

null
	^NullIcon current!

onPreStripImage
	"Private - The image is about to be stripped. Nil out the cached converter to (potentially)
	allow RichTextEdit to be stripped."

	self uninitialize!

onSettingChanged: anArray
	anArray first = 'WindowsThemeElement' ifFalse: [^self].
	self clearCached!

onStartup2
	"Private - Perform system startup processing for all subclasses."

	self clear.
	self clearCached!

question
	"Answer a new instance of the Question mark icon (used in prompting messages)"

	"N.B. It is imperative that this always loads, as it is used to provide the handle for any icon that fails to load!!"

	^Question ifNil: [Question := self fromSystemId: IDI_QUESTION]!

resetSystemInstances
	DefaultApplication := Error := Information := Question := Warning := WinLogo := nil!

shield
	"Answer a new instance of the default system 'shield' icon (used in security warning messages)"

	^self fromSystemId: IDI_SHIELD!

standardSizeFor: aPoint
	"Answer the best standard icon size for the size specified by the <Point> argument. This will be the nearest size that is <= the requested size, except if the requested size is out of range in which case it will be clamped."

	^(StandardSizeMap lookup: aPoint y)
		ifNil: [aPoint >= LargestStandardSize ifTrue: [LargestStandardSize] ifFalse: [Point.Zero]]!

systemNames
	^##(LookupTable withAll: {IDI_APPLICATION -> #defaultApplication.
				IDI_ERROR -> #error.
				IDI_INFORMATION -> #information.
				IDI_QUESTION -> #question.
				IDI_WARNING -> #warning.
				IDI_WINLOGO -> #window})!

uninitialize
	"Uninitialize the class variables of the receiver."

	Blank := nil.
	self resetSystemInstances!

warning
	"Answer a new instance of the default system 'warning' icon (used in warning messages)"

	^Warning ifNil: [Warning := self fromSystemId: IDI_WARNING]!

window
	"Answer a new instance of the default Windows icon"

	WinLogo isNil ifTrue: [WinLogo := self fromSystemId: IDI_WINLOGO].
	^WinLogo! !

!Graphics.Icon class categoriesForMethods!
asterisk!instance creation!public! !
blank!instance creation!public! !
cacheSystemMetrics!helpers!private! !
clear!initializing!public! !
clearCached!event handling-win32!private! !
default!public!realizing/unrealizing! !
defaultApplication!instance creation!public! !
defaultExtent!constants!public! !
defaultHandle!private! !
error!instance creation!public! !
exclamation!instance creation!public! !
filesType!constants!private! !
freeHandle:!private!realizing/unrealizing! !
fromBitmap:!instance creation!public! !
fromSystemId:!instance creation!public! !
fromSystemId:extent:!instance creation!public! !
hand!instance creation!public! !
icon!constants!public! !
imageManager!accessing!public! !
imageType!constants!private! !
information!instance creation!public! !
initialize!class initialization!public! !
newSystemInitializer:!helpers!private! !
null!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
onSettingChanged:!event handling-win32!private! !
onStartup2!event handling!private! !
question!instance creation!public! !
resetSystemInstances!helpers!private! !
shield!instance creation!public! !
standardSizeFor:!enquiries!public! !
systemNames!accessing!public! !
uninitialize!class hierarchy-removing!private! !
warning!instance creation!public! !
window!instance creation!public! !
!

