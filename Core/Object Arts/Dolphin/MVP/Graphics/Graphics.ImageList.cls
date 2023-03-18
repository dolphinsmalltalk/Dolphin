"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.ImageList'
	instanceVariableNames: 'extent initialSize growBy createFlags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ILC_COLOR' -> 16r0.
			'ILC_COLOR16' -> 16r10.
			'ILC_COLOR32' -> 16r20.
			'ILC_COLOR4' -> 16r4.
			'ILC_COLOR8' -> 16r8.
			'ILC_COLORDB' -> 16rFE.
			'ILC_HIGHQUALITYSCALE' -> 16r20000.
			'ILC_MASK' -> 16r1.
			'ILC_ORIGINALSIZE' -> 16r10000.
			'ILC_PALETTE' -> 16r800.
			'ILD_ASYNC' -> 16r8000.
			'ILD_BLEND' -> 16rF00.
			'ILD_BLEND25' -> 16r2.
			'ILD_BLEND50' -> 16r4.
			'ILD_DPISCALE' -> 16r4000.
			'ILD_FOCUS' -> 16r4.
			'ILD_IMAGE' -> 16r20.
			'ILD_MASK' -> 16r10.
			'ILD_NORMAL' -> 16r0.
			'ILD_OVERLAYMASK' -> 16rF00.
			'ILD_PRESERVEALPHA' -> 16r1000.
			'ILD_ROP' -> 16r40.
			'ILD_SCALE' -> 16r2000.
			'ILD_SELECTED' -> 16r4.
			'ILD_TRANSPARENT' -> 16r1
		}!
Graphics.ImageList guid: (Core.GUID fromString: '{87b4c639-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.ImageList comment: 'WinImageList encapsulates a Windows "image list", which itself can be characterised as a strip of images addressable by integer index.

Instance Variables:
	extent			<Point>. Size of the images in the list.
	initialSize		<integer>. Initial capacity of the image list.
	growBy			<integer>. Growth quantum.
	createFlags		<integer>. Variious flagss specified when the list was created.

'!
!Graphics.ImageList categoriesForClass!Graphics-Tools! !
!Graphics.ImageList methodsFor!

addBitmap: aBitmap
	"Append the <Bitmap> argument to the list of images held by the receiver
	answering the zero-based <integer> index at which it was added."

	^self addBitmap: aBitmap mask: nil!

addBitmap: aBitmap mask: aColorOrNil
	"Append the <Bitmap> argument to the list of images held by the receiver answering the
	zero-based <integer> index at which it was added. The argument, aColor, specifies the mask
	colour to be used; pixels in the bitmap of the specified colour are converted to black, and
	the corresponding pixel is set in the mask bitmap. This allows the bitmap to be drawn
	transparently from the image list to a canvas. Note, however, that this will only work for
	bitmaps with a colour depth <= 8bpp, which does significantly reduce the usefulness of this
	feature. If the return value is -1, then the bitmap could not be added for some reason (e.g.
	it could not be realized and hence has a null handle). This is not treated as an error, as
	the effect should only be cosmetic."

	"Implementation Note: The image list will modify the bitmap in-place if the ILC_MASK flag is
	set (poor isn't it) and hence we must make sure we pass it it's own private copy of the
	bitmap if masking is enabled."

	| bmp hImgList |
	hImgList := self asParameter.
	bmp := self hasMask ifTrue: [aBitmap copy] ifFalse: [aBitmap].
	"#305 - We must make sure the bitmap is not selected into a DC, or the result will be a blank image in the list
	 	this won't damage the Bitmap in any way, because the canvas can be lazily recreated."
	bmp freeDC.
	^ComCtl32
		imageList_AddMasked: hImgList
		hbmImage: bmp asParameter
		crMask: (aColorOrNil isNil ifTrue: [CLR_NONE] ifFalse: [aColorOrNil asCOLORREF])!

addIcon: anIcon
	"Append an icon to the receiver and return the zero-based <integer> index at which it was added. 
	Answer -1 if the icon could not be added for some reason (we don't throw an error as this is probably 
	only a cosmetic problem)."

	^ComCtl32
		imageList_ReplaceIcon: self asParameter
		i: -1
		hicon: anIcon asParameter!

addImage: anImage
	"Answer the index at which anImage is added to the receiver or -1 if an error occurs."

	^anImage addToImageList: self mask: nil!

addTransparentBitmap: aBitmap
	"Append the <Bitmap> argument to the list of images held by the receiver
	answering the zero-based <integer> index at which it was added. The colour
	value of the first pixel in the image is used to compute the mask."

	^self addBitmap: aBitmap
		mask: (self hasMask ifTrue: [aBitmap canvas pixelAt: 0 @ 0])!

backcolor
	"Answer the receiver's current background colour as a Colour.
	If the answer is nil then there is no background color set."

	| colorref |
	colorref := ComCtl32 imageList_GetBkColor: handle.
	^colorref = CLR_NONE ifFalse: [Color fromCOLORREF: colorref]!

backcolor: aColor
	"Set the receiver's background color to the <Color>, aColor.
	Answers the previous background <Color>, or nil if there was none."

	| colorref |
	colorref := ComCtl32 imageList_SetBkColor: self asParameter
				clrBk: (aColor isNil ifTrue: [CLR_NONE] ifFalse: [aColor asCOLORREF]).
	^colorref = CLR_NONE ifFalse: [Color fromCOLORREF: colorref]!

basicFree
	"Private - Free external resources held by the receiver"

	ComCtl32 imageList_Destroy: handle!

beginDragImage: anInteger hotSpotX: x hotSpotY: y
	"Start a drag process using the image at the offset anInteger in the receiver."

	^ComCtl32
		imageList_BeginDrag: handle
		iTrack: anInteger
		dxHotspot: x
		dyHotspot: y!

copy
	^(super copy)
		ownedHandle: self copyHandle;
		yourself!

copyHandle
	"Private - Answer an external handle to the image which is a copy of that represented by the receiver."

	^ComCtl32 imageList_Duplicate: self handle!

createHandle
	"Private - Create and answer an external resource handle associated with the receiver.
	This may be installed as the handle of the receiver if called from #basicRealize or it
	may be used by third parties who require a duplicate handle"

	^ComCtl32
		imageList_Create: extent x
		cy: extent y
		flags: createFlags
		cInitial: initialSize
		cGrow: growBy!

depth
	"Answer the color depth (number of bits per pixel) of the receiver. This can be 0, for the
	default (whatever that may be), or ILC_COLORDB for a device-dependent image list."

	^createFlags bitAnd: ILC_COLORDB!

dragEnter: aView at: aPoint
	"The drag for which the receiver is supplying images has entered the specified
	<View> at the specified point."

	^ComCtl32
		imageList_DragEnter: aView asParameter
		x: aPoint x
		y: aPoint y!

dragLeave: aView
	"The drag for which the receiver is supplying images has exited the specified
	<View>."

	^ComCtl32 imageList_DragLeave: aView asParameter!

dragMoveTo: aPoint
	"Move the drag image to (x, y)."

	^ComCtl32 imageList_DragMove: aPoint x y: aPoint y!

dragShow: aBoolean
	"Show/hide the drag image as a 'fake' cursor."

	^ComCtl32 imageList_DragShowNolock: aBoolean!

draw: anInteger on: aCanvas at: aPoint 
	^self 
		draw: anInteger
		on: aCanvas
		at: aPoint
		flags: 0!

draw: imageIndexInteger on: aCanvas at: aPoint backcolor: backColor forecolor: foreColor flags: flagsInteger
	"Draw the image at one-based <integer> index, imageIndexInteger, in the receiver onto the
	<Canvas>, aCanvas, at the <Point> position, aPoint, using the foreground and background
	<Color>s foreColor and backColor respectively, with <integer> style flags, flagsInteger."

	^ComCtl32
		imageList_DrawEx: self asParameter
		i: imageIndexInteger - 1
		hdcDst: aCanvas asParameter
		x: aPoint x
		y: aPoint y
		dx: 0
		dy: 0
		rgbBk: (backColor isNil ifTrue: [CLR_NONE] ifFalse: [backColor asCOLORREF])
		rgbFg: (foreColor isNil ifTrue: [CLR_DEFAULT] ifFalse: [foreColor asCOLORREF])
		fStyle: flagsInteger!

draw: imageIndexInteger on: aCanvas at: aPoint flags: flagsInteger
	"Draw the image at <integer> index, imageIndex, in the receiver onto the <Canvas>,
	target, at the <Point>, position, with <integer> style mask, flags."

	^ComCtl32
		imageList_Draw: self asParameter
		i: imageIndexInteger - 1
		hdcDst: aCanvas asParameter
		x: aPoint x
		y: aPoint y
		fStyle: flagsInteger!

endDrag
	"End the image drag operation."

	^ComCtl32 imageList_EndDrag!

extent
	"Answer a <Point>, the x any y coordinates of which specify the width and height (respectively)
	of the bitmaps held by the receiver."

	^extent
		ifNil: 
			[| cx cy |
			cx := Int32 new.
			cy := Int32 new.
			ComCtl32
				imageList_GetIconSize: self handle
				cx: cx
				cy: cy.
			extent := cx asInteger @ cy asInteger]!

getIcon: anIntegerIndex style: anIntegerStyle
	"Answer an instance of Icon generated from the image at anIntegerIndex."

	^Icon fromOwnedHandle: (ComCtl32
				imageList_GetIcon: handle
				i: anIntegerIndex - 1
				flags: anIntegerStyle)!

getImageCount
	"Answer the number of images held by the receiver."

	^ComCtl32 imageList_GetImageCount: handle!

hasMask
	^createFlags allMask: ILC_MASK!

initialize
	"Initialize the receiver's instance variables."

	super initialize.
	extent := 16 @ 16.
	initialSize := 0.
	growBy := 16.
	createFlags := ILC_HIGHQUALITYSCALE!

isPersistent
	"Private - Answer true if the receiver holds sufficient information such that
	it can recreate itself when the image is saved and restored. This is also
	an indication as to whether the receiver can be filed out/in using the STB
	mechanism. Generally this ability corresponds to a useful implementation
	of #basicRealize"

	^false!

setDragCursorImage: anInteger hotSpotX: x hotSpotY: y
	"Start a drag process using the image at the offset anInteger in the receiver."

	^ComCtl32
		imageList_SetDragCursorImage: handle
		iDrag: anInteger
		dxHotspot: x
		dyHotspot: y!

setExtent: aPoint depth: bppInteger initialSize: sizeInteger growBy: growByInteger masked: aBoolean
	"Private - Initialize the receiver's instance variables."

	aPoint strictlyPositive ifFalse: [^self error: 'Image list extent must be at least 1@1'].
	extent := aPoint.
	initialSize := sizeInteger.
	growBy := growByInteger.
	createFlags := (aBoolean
				ifTrue: [##(ILC_HIGHQUALITYSCALE | ILC_MASK)]
				ifFalse: [ILC_HIGHQUALITYSCALE]) bitOr: bppInteger! !
!Graphics.ImageList categoriesForMethods!
addBitmap:!adding!public! !
addBitmap:mask:!adding!public! !
addIcon:!adding!public! !
addImage:!adding!public! !
addTransparentBitmap:!adding!public! !
backcolor!accessing!public! !
backcolor:!accessing!public! !
basicFree!private!realizing/unrealizing! !
beginDragImage:hotSpotX:hotSpotY:!modes!public! !
copy!copying!public! !
copyHandle!private!realizing/unrealizing! !
createHandle!private!realizing/unrealizing! !
depth!accessing!public! !
dragEnter:at:!drag & drop!public! !
dragLeave:!drag & drop!public! !
dragMoveTo:!drag & drop!public! !
dragShow:!drag & drop!public! !
draw:on:at:!drawing!public! !
draw:on:at:backcolor:forecolor:flags:!drawing-bitmaps!public! !
draw:on:at:flags:!drawing-bitmaps!public! !
endDrag!drag & drop!public! !
extent!accessing!public! !
getIcon:style:!accessing!public! !
getImageCount!accessing!public! !
hasMask!private!testing! !
initialize!initializing!public! !
isPersistent!private!testing! !
setDragCursorImage:hotSpotX:hotSpotY:!modes!public! !
setExtent:depth:initialSize:growBy:masked:!accessing!private! !
!

!Graphics.ImageList class methodsFor!

defaultColorDepth
	"Answer the default color depth based on that of the current screen driver."

	^SystemMetrics current defaultColorDepth!

defaultGrowthGranularity
	"Answers the amount by which an instance of the receiver will grow
	itself when adding images beyond its existing size."

	^32!

defaultImageFlags
	"Answer the default image flags setting for an instance of the receiver.
	Suggest a color depth based on that of the current screen driver.
	Implementation Note: Use the raw GDI calls to avoid creating a dependency
	on the Canvas class."

	^SystemMetrics current defaultColorDepth!

defaultInitialSize
	"Answers the default initial size of new image lists."

	^1!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

newExtent: aPoint
	"Answer a new instance to hold images with the given extent
	and no mask. All other parameters required to create
	an image list are defaulted."

	^self newExtent: aPoint masked: false!

newExtent: aPoint depth: bppInteger initialSize: sizeInteger growBy: growthInteger masked: aBoolean
	"Answer a new instance with the given parameters."

	^(self new)
		setExtent: aPoint
			depth: bppInteger
			initialSize: sizeInteger
			growBy: growthInteger
			masked: aBoolean;
		yourself!

newExtent: aPoint depth: anInteger masked: aBoolean 
	"Answer a new instance with the given parameters."

	^self 
		newExtent: aPoint
		depth: anInteger
		initialSize: self defaultInitialSize
		growBy: self defaultGrowthGranularity
		masked: aBoolean!

newExtent: aPoint initialSize: anInteger masked: aBoolean
	"Answer a new instance with the given parameters."

	^self 
		newExtent: aPoint
		depth: self defaultColorDepth
		initialSize: anInteger
		growBy: self defaultGrowthGranularity
		masked: aBoolean!

newExtent: aPoint masked: aBoolean
	"Answer a new instance with the given parameters."

	^self 
		newExtent: aPoint
		initialSize: self defaultInitialSize
		masked: aBoolean! !
!Graphics.ImageList class categoriesForMethods!
defaultColorDepth!constants!public! !
defaultGrowthGranularity!constants!public! !
defaultImageFlags!constants!public! !
defaultInitialSize!constants!public! !
icon!constants!public! !
newExtent:!instance creation!public! !
newExtent:depth:initialSize:growBy:masked:!instance creation!public! !
newExtent:depth:masked:!instance creation!public! !
newExtent:initialSize:masked:!instance creation!public! !
newExtent:masked:!instance creation!public! !
!

