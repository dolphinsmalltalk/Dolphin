"Filed out from Dolphin Smalltalk"!

Image subclass: #Icon
	instanceVariableNames: ''
	classVariableNames: 'Blank DefaultApplication Error Information Question Warning WinLogo'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Icon guid: (GUID fromString: '{87b4c63e-026e-11d3-9fd7-00a0cc3e4a32}')!
Icon comment: 'Icon is the class of <Image>s that represent Windows'' icons (essentially a pair of bitmaps, one of which is a mask used to draw the other bitmap transparently).

Class Variables:
	Question			<Icon>. Standard system questionmark icon.
	WinLogo			<Icon>. Standard windows logo icon.
	Blank				<Icon>. A blank icon.
	DefaultApplication	<Icon>. Standard windows "application" icon.
	Information			<Icon>. Standard system information icon, as used in informational message boxes.
	Error				<Icon>. Standard system error icon, as used in error message boxes.
	Warning			<Icon>. Standard system warning icon, as used in warning message boxes.

'!
!Icon categoriesForClass!Graphics-Tools! !
!Icon methodsFor!

addToImageList: aWinImageList mask: aColorOrNil 
	"Private - Add a pictorial representation of the receiver to the <WinImageList>
	argument, using the <Color> argument as the mask colour (although in this
	case the specified mask colour is ignored as the Icon has its own mask)."

	^self valueWithHandle: [:hIcon | aWinImageList addIcon: hIcon] forExtent: aWinImageList extent!

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
	#todo. "If we could determine that the icon is 32-bit (with alpha) then we could just draw
	       it directly with DrawIconEx, which would save rendering all the icons into an image
	       list at the desired extent."
	(self imageManager imageListWithExtent: aPoint) 
		draw: self imageIndex
		on: bmp canvas
		at: Point.Zero
		flags: CommCtrlConstants.ILD_PRESERVEALPHA.
	bmp freeDC.
	^bmp!

asCursor
	^Cursor fromOwnedHandle: self detachHandle!

asIcon
	^self!

asMenuBitmap
	"Answer a 32-bpp bitmap (i.e. with alpha channel) containing the receiver's image at system
	menu image extent. Note that the result will be a shared bitmap which is always the same
	instance for the same icon."

	^self imageManager menuBitmapForIcon: self!

basicFree
	"Private - Free the receiver's Icon resource handle.
	Ignore any error return."

	UserLibrary default destroyIcon: handle!

createHandle
	"Private - Answer an external handle to the image represented by the receiver.
	If the icon is not found, then use the handle of a default icon. 
	We could allow a walkback to occur but this could interfere with the system 
	browsers so we silently display a dummy icon in place of the dud."

	| aHandle |
	^(aHandle := super createHandle) notNil
		ifTrue: [aHandle]
		ifFalse: [ "Use Question icon if not realizable"
			self class question handle]!

drawDisabledOn: aCanvas at: aPoint extent: sizePoint
	"Draw a disabled/grayed representation of the receiver on aCanvas at aPoint with extent sizePoint."

	^UserLibrary default 
		drawState: aCanvas asParameter
		hbr: nil
		lpOutputFunc: nil
		lData: self asParameter asInteger
		wData: 0
		x: aPoint x
		y: aPoint y
		cx: sizePoint x
		cy: sizePoint y
		fuFlags: ##(DST_ICON| DSS_DISABLED)!

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
	"Copies the receiver to aCanvas at position aPoint with size sizePoint
	with frame anInteger and background aBrush. Answer whether the frame
	could be drawn. Note that the frame number is ignored if the receiver is not
	an animated icon/cursor."

	^self valueWithHandle: 
			[:hIcon |
			UserLibrary default
				drawIconEx: aCanvas asParameter
				xLeft: aPoint x
				yTop: aPoint y
				hIcon: hIcon
				cxWidth: sizePoint x
				cyHeight: sizePoint y
				istepIfAniCur: anInteger
				hbrFlickerFreeDraw: aBrush asParameter
				diFlags: flagsInteger]
		forExtent: sizePoint!

drawOn: aCanvas at: aPoint frame: anInteger background: aBrush
	"Copies the receiver to aCanvas at position aPoint with frame anInteger and 
	background aBrush."

	^self
		drawOn: aCanvas 
		at: aPoint 
		extent: Point zero
		frame: anInteger 
		background: aBrush 
		flags: ##(DI_DEFAULTSIZE|DI_NORMAL)!

extent
	"Answers the dimensions of the receiver in pixels.
	This is determined from the extent of the foreground bitmap, which
	is accessed via GetIconInfo(). Note that we explicitly free
	the ICONINFO in order to release the bmp's."

	| info extent |
	self isRealized ifFalse: [
		"We always do the default load at 32x32. Other sizes are loaded on request."
		^self class largeExtent].
	info := self getIconInfo.
	extent := info extent.
	info free.
	^extent!

getIconInfo
	"Private - Answer an ICONINFO structure populated with info. about the receiver.
	N.B. This is quite an expensive operation, as it involves the creation of foreground
	and mask bitmaps for the icon."

	| info |
	info := ICONINFO new.
	(UserLibrary default getIconInfo: self asParameter piconinfo: info)
		ifFalse: [UserLibrary default systemError].
	^info
	!

hotspot
	"Answer a Point specifying the receiver's hot spot (only really relevant for cursors)."

	| info |
	info := self getIconInfo.
	^info
		free; 	"Free up the bitmaps which we don't need"
		xHotspot @ info yHotspot!

icon
	^self!

imageIndex
	"Answer the image index of the receiver in our ImageManager of all icons."

	^self imageManager indexOfImage: self.
!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^IMAGE_ICON!

includesFrame: frameNumber
	"Answer whether the receiver contains a frame of frameNumber.
	Sadly we need to attempt to draw the specified frame to determine whether it
	exists (unless we can find another way - suggestions please!!)
	Note that the answer will always be true, regardless of the frame number, if
	the receiver is not an animated cursor."

	| hDC includes screenDC |
	screenDC := UserLibrary default getDC: nil.
	hDC := GDILibrary default createCompatibleDC: screenDC.
	includes := self drawOn: hDC at: Point zero frame: frameNumber background: nil.
	GDILibrary default deleteDC: hDC.
	UserLibrary default releaseDC: nil hDC: screenDC.
	^includes!

load: anObject fromInstance: hModule extent: aPoint
	"Private - Loads the icon from the module with the requested size and returns its handle. The handle must be released by calling UserLibrary>>#destroyIcon:. If size is not standard size, this function prefers to scale down a larger image instead of scaling up a smaller image. Note that this function requires Windows Vista or later. If the icon could not be loaded, the answer will be nil."

	^SystemMetrics current hasIconScaleDown
		ifTrue: 
			[| hIcon |
			hIcon := ExternalHandle new.
			(CommCtrlLibrary default
				loadIconWithScaleDown: hModule
				pszName: anObject asResourceId
				cx: aPoint x
				cy: aPoint y
				phico: hIcon) >= 0
				ifTrue: [hIcon]]
		ifFalse: 
			[hModule == 0
				ifTrue: [UserLibrary default loadIcon: 0 lpIconName: anObject]
				ifFalse: 
					[UserLibrary default
						loadImage: hModule
						lpszName: anObject asResourceId
						uType: self imageType
						cxDesired: aPoint x
						cyDesired: aPoint y
						fuLoad: LR_SHARED]]!

loadFlags
	^##(LR_SHARED|LR_DEFAULTSIZE)!

loadFromInstance: hModule
	"Private - Attempts to load the receiver as a resource from an instance. Answers the loaded handle or nil if the load failed. "

	^SystemMetrics current hasIconScaleDown
		ifTrue: 
			[| hIcon |
			hIcon := ExternalHandle new.
			(CommCtrlLibrary default
				loadIconMetric: hModule asParameter
				pszName: identifier asResourceId
				lims: LIM_LARGE
				phico: hIcon) >= 0
				ifTrue: [hIcon]]
		ifFalse: 
			["I would have expected the User32 loadImage function to be capable of this but it does not appear to work properly for instance 0; the system. Hence, try the old way. "
			UserLibrary default loadIcon: hModule asParameter lpIconName: identifier asResourceId]!

valueWithHandle: operation forExtent: aPoint
	"Private - Evaluate the <monadicValuable>, operation, with a handle for the receiver's icon at the best possible rendering for the specified extent. On Vista and later platforms the icon will be scaled down from the next largest icon if the requested size is not available, which generally yields a better result than scaling up."

	| hModule ident |
	handle = self class question handle
		ifTrue: 
			["If the icon failed to load, the standard question icon will have been substituted"
			hModule := 0.
			ident := self class question identifier]
		ifFalse: 
			[ident := self identifier.
			hModule := instanceHandle asParameter].
	instanceHandle isNil
		ifTrue: 
			[(self loadFromFile: self fileSpec extent: aPoint)
				ifNotNil: 
					[:hIcon |
					| answer |
					answer := operation value: hIcon.
					UserLibrary default destroyIcon: hIcon.
					^answer]]
		ifFalse: 
			[(self
				load: ident
				fromInstance: hModule
				extent: aPoint)
					ifNotNil: 
						[:hIcon |
						| answer |
						answer := operation value: hIcon.
						UserLibrary default destroyIcon: hIcon.
						^answer]].
	^operation value: self asParameter! !
!Icon categoriesForMethods!
addToImageList:mask:!double dispatch!private! !
asAlphaBitmap:!converting!public! !
asCursor!public! !
asIcon!public! !
asMenuBitmap!converting!public! !
basicFree!private!realizing/unrealizing! !
createHandle!private!realizing/unrealizing! !
drawDisabledOn:at:extent:!drawing-bitmaps!public! !
drawOn:at:!drawing-bitmaps!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
drawOn:at:extent:frame:background:!drawing-bitmaps!public! !
drawOn:at:extent:frame:background:flags:!drawing-bitmaps!public! !
drawOn:at:frame:background:!drawing-bitmaps!public! !
extent!accessing!public! !
getIconInfo!helpers!private! !
hotspot!accessing!public! !
icon!constants!public! !
imageIndex!accessing!public! !
imageType!constants!private! !
includesFrame:!public!searching! !
load:fromInstance:extent:!private!realizing/unrealizing! !
loadFlags!private!realizing/unrealizing! !
loadFromInstance:!private!realizing/unrealizing! !
valueWithHandle:forExtent:!helpers!private!wine fix! !
!

!Icon class methodsFor!

asterisk
	"Answer a new instance of the Asterisk icon (used in informative messages)"

	^self information!

blank
	Blank isNil ifTrue: [Blank := self fromId: 'Blank.ico'].
	^Blank!

clear
	"Clean up the image manager for all icons. We start with no image representation
	for our icons, they are added lazily as they are accessed usng #imageIndex."

	self imageManager purge!

defaultApplication
	"Answer a new instance of the default application icon"

	DefaultApplication isNil ifTrue: [DefaultApplication := self fromSystemId: IDI_APPLICATION].
	^DefaultApplication
!

defaultExtent
	"Answer a Point that gives the dimensions of a standard size icon."

	^self largeExtent
!

error
	"Answer a new instance of the default system 'error' icon (used in serious warning messages)"

	^Error ifNil: [Error := self fromSystemId: IDI_ERROR]!

exclamation
	"Answer a new instance of the Exclamation mark icon (used in warning messages)"

	^self warning!

extraLargeExtent
	^256 @ 256!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Icon Files (*.ico)' '*.ico')!

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

information
	"Answer a new instance of the default system 'information' icon (used in informative messages)"

	^Information ifNil: [Information := self fromSystemId: IDI_INFORMATION]!

largeExtent
	"Answer a <Point> that gives the dimensions of a standard size icon."

	^SystemMetrics current largeIconExtent!

null
	^NullIcon current!

onPreStripImage
	"Private - The image is about to be stripped. Nil out the cached converter to (potentially)
	allow RichTextEdit to be stripped."

	self uninitialize!

onStartup2
	"Private - Perform system startup processing for all subclasses."

	self clear!

question
	"Answer a new instance of the Question mark icon (used in prompting messages)"

	"N.B. It is imperative that this always loads, as it is used to provide the handle for any icon that fails to load!!"

	^Question ifNil: [Question := self fromSystemId: IDI_QUESTION]!

smallExtent
	"Answer a <Point> that gives the dimensions of a small size icon."

	^SystemMetrics current smallIconExtent!

tileExtent
	"Answer a Point that gives the dimensions of a tile size icon."

	#todo. "Is there a system metric for this?"

	^48 @ 48!

uninitialize
	"Uninitialize the class variables of the receiver."

	Blank := Error := Warning := Information := Question := WinLogo := DefaultApplication := nil!

warning
	"Answer a new instance of the default system 'warning' icon (used in warning messages)"

	^Warning ifNil: [Warning := self fromSystemId: IDI_WARNING]!

window
	"Answer a new instance of the default Windows icon"

	WinLogo isNil ifTrue: [WinLogo := self fromSystemId: IDI_WINLOGO].
	^WinLogo! !
!Icon class categoriesForMethods!
asterisk!instance creation!public! !
blank!instance creation!public! !
clear!initializing!public! !
defaultApplication!instance creation!public! !
defaultExtent!constants!public! !
error!instance creation!public! !
exclamation!instance creation!public! !
extraLargeExtent!constants!public! !
filesType!constants!private! !
hand!instance creation!public! !
icon!constants!public! !
imageManager!accessing!public! !
information!instance creation!public! !
largeExtent!constants!public! !
null!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
onStartup2!event handling!private! !
question!instance creation!public! !
smallExtent!constants!public! !
tileExtent!constants!public! !
uninitialize!class hierarchy-removing!private! !
warning!instance creation!public! !
window!instance creation!public! !
!

