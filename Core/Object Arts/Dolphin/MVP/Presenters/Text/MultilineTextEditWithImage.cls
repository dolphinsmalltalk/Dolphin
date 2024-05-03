"Filed out from Dolphin Smalltalk"!

MultilineTextEdit subclass: #MultilineTextEditWithImage
	instanceVariableNames: 'backBitmap backMode backBrush'
	classVariableNames: 'BackModes'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MultilineTextEditWithImage guid: (GUID fromString: '{eb99e6ab-3d20-4f85-852b-b521da845584}')!

MultilineTextEditWithImage addClassConstant: 'BackModes' value: #(#tile #topLeft #topCenter #topRight #rightCenter #bottomRight #bottomCenter #bottomLeft #leftCenter #center #stretch)!

MultilineTextEditWithImage comment: 'MultilineTextEditWithImage is a specialised <MultilineTextEdit> that displays text transparently over a background bitmap. A common use case might be to display a watermark under the text. The bitmap can be tiled to fill the background, centred, or "docked" to one of the eight positions positions around the edges and in the corners of the client area. These modes are as follows:

	#tile		- tile the image at its natural size to fill the entire background
	#topLeft 		- draw the image at its natural size in the top left corner of the client area
	#topCenter 	- draw the image at its natural size horizontally centred along the top edge of the client area
	#topRight 	- draw the image at its natural size in the top right corner of the client area
	#rightCenter 	- draw the image at its natural size vertically centred along the right edge of client area
	#bottomRight 	- draw the image at its natural size in the bottom right corner of the client area
	#bottomCenter 	- draw the image at its natural size horizontally centred along the bottom edge of the client area
	#bottomLeft 	- draw the image at its natural size in the bottom left corner of the client area
	#leftCenter 	- draw the image at its natural size vertically centred along the left edge of client area
	#center 		- draw the image at its natural size at the centre of the client area
	#stretch		- stretch the image to fill the client area

The most useful of these modes are #tile, #stretch, and #bottomRight. The most efficient mode is #tile, since all other modes require the creation of a bitmap the size of the client area.

Implementing a background image in a Windows EDIT control is a superficially easy task that turns out to be rather tricky. We can get a background image into the control fairly easily by overriding #onColorRequired: (i.e. respond to WM_CTLCOLOREDIT), setting the canvas background mode to TRANSPARENT (so that any text output is painted over the existing background rather than obliterating it), and then returning a handle to a bitmap brush for the control to use to paint its own background. This appears to work, until one tries to edit existing text in the box. The deletion of text, or addition of new text, causes the control to selectively repaint affected areas, but it does this directly (not via the usual means of invalidating an area, and then performing an update in WM_PAINT), and furthermore it does not erase the background of affected areas but relies on the "optimisation" of allowing the GDI text output function to erase the background to the current background colour. Since GDI text output uses the background colour of the canvas, and not the background brush, it can only ouput solid colour blocks - hence the necessity of using TRANSPARENT. The net result is that the old text is left behind and new text drawn over the top of it, creating a total mess. Scrolling the window also results in the background becoming confused. However the control does send a notification when it has updated its display, so one can use this to invalidate and repaint the control on a freshly erased background. This creates a lot of flicker, though, if we let the control do its normal painting, so we have to use (what amounts to) a double-buffered redraw of the window contents by making use of the WM_PRINTCLIENT message, which requests that the control paint itself into an offscreen DC which we can then blt to the paint DC. To handle scrolling correctly we have to perform a similar repaint after the control has done its own scroll event handling.

Instance Variables:
	backBitmap		<Bitmap> used as the background image.
	backBrush		<Brush> constructed to draw the background image appropriately given the current background mode.
	backMode		<Symbol>ic name of the current background mode. #tile is the default, and the most efficient option.
	
Copyright (c) Object Arts Ltd 2004
'!

!MultilineTextEditWithImage categoriesForClass!MVP-Views! !

!MultilineTextEditWithImage methodsFor!

backBitmap
	backBitmap ifNil: [backBitmap := self defaultBackgroundImage].
	^backBitmap!

backBitmap: aBitmap 
	backBitmap := aBitmap!

backBrush
	backBrush isNil ifTrue: [backBrush := self createBackBrush].
	^backBrush!

backMode
	"Answer a <Symbol> naming the current background image mode, for example #tile."

	^backMode!

backMode: aSymbol 
	backMode == aSymbol ifTrue: [^self].
	(BackModes includes: aSymbol) 
		ifFalse: [self error: 'invalid background image mode: ' , aSymbol printString].
	self freeBackBrush.
	backMode := aSymbol.
	self repaintWindow!

createBackBrush
	"Private - Answer a textured <Brush> that can be used to paint the receiver's background
	image at the correct position and size depending on the receiver's background mode."

	| symbol rect pos bmp bmpRect canvas |
	backMode == #tile ifTrue: [^Brush bitmap: self backBitmap].
	backMode == #stretch
		ifTrue: 
			[bmp := Bitmap displayCompatibleWithExtent: self clientExtent.
			self backBitmap
				drawOn: bmp canvas
				at: 0 @ 0
				extent: bmp extent.
			bmp freeDC.
			^Brush bitmap: bmp].
	symbol := backMode.
	bmpRect := 0 @ 0 extent: self backBitmap extent.
	rect := self clientRectangle.
	pos := (rect perform: symbol) - (bmpRect perform: symbol).
	bmp := Bitmap displayCompatibleWithExtent: rect extent.
	canvas := bmp canvas.
	canvas
		backcolor: self actualBackcolor;
		erase.
	self backBitmap
		drawOn: canvas
		at: pos
		extent: bmpRect extent.
	bmp freeDC.
	^Brush bitmap: bmp!

defaultBackgroundImage
	"Private - Construct and answer a background bitmap to be used in new instances of the control until
	some other background bitmap is explicitly set. In this case we use the 48x48 application
	icon, toned down to a watermark."

	| blend percent icon extent bmp color |
	extent := 48 @ 48 * self dpi // USER_DEFAULT_SCREEN_DPI.
	percent := 25.
	color := self actualBackcolor.
	"First we need an image to use, in this case we choose the default application icon. N.B. If we
	draw the icon from an image list, then the correct sized icon is used automatically and we
	get the best results"
	icon := Bitmap displayCompatibleWithExtent: extent.
	(IconImageManager current imageListWithExtent: extent)
		draw: SessionManager current iconImageIndex
		on: (icon canvas
				backcolor: color;
				erase;
				yourself)
		at: 0 @ 0
		flags: 0.

	"Now we're going to layer the image onto a white Bitmap to create a watermark image"
	bmp := Bitmap displayCompatibleWithExtent: extent.
	bmp canvas
		backcolor: color;
		erase.
	blend := BLENDFUNCTION new.
	blend
		blendPercentage: percent;
		usePerPixelAlpha: false.
	icon
		alphaBlendOn: bmp canvas
		at: 0 @ 0
		extent: bmp extent
		from: 0 @ 0
		extent: icon extent
		blend: blend.
	icon free.
	bmp freeDC.
	^bmp!

enUpdate
	"Private - The receiver's text has been updated, and the change has been displayed."

	"Implementation Note: Since we ask configure the control's canvas to draw text
	transparently, it won't refresh the display correctly. Consequently we have to cause the
	entire client area to be repainted. This could cause a lot of flicker, but we double buffer
	the update to avoid that."

	super enUpdate.
	self repaintWindow!

freeBackBrush
	backBrush isNil ifTrue: [^self].
	backMode == #tile 
		ifFalse: 
			["This is a bit of a hack to free the dynamically created bitmaps we employ
			 when not using the basic tiling mode. If we don't do this, then when the
			 window is resized we can rapidly run out of bitmap resources."
			backBrush logBrush hatch free].
	backBrush free.
	backBrush := nil!

initialize
	"Private - Initialize the receiver"

	super initialize.
	backMode := #tile!

onColorRequired: aColorEvent 
	"Colour event handler for aColorEvent. We set up the canvas provided by the event
	with the appropriate foreground and background colours for the receiver. Windows
	WM_CTLCOLORXXX messages require that we answer the background brush handle."

	"Implementation Note: Creating the bitmap background brush on the fly in this event handler
	turns out to be a bad idea, since can be sent very many times. Therefore we cache the bitmap
	brush."

	| brush aCanvas |
	brush := self backBrush.
	aCanvas := aColorEvent canvas.
	aCanvas brush: brush.
	aCanvas backgroundMode: TRANSPARENT.
	^brush asParameter!

onEraseRequired: aColorEvent 
	"Handler for erase background event - allow the control to take care of this."

	"Implementation Note: Background is erased when we paint the control, so to avoid flicker do
	nothing and suppress control's own erase."

	^true!

onHScroll: aScrollEvent
	"Implementaion Note: We must repaint on scroll to maintain the background image correctly."

	aScrollEvent defaultWindowProcessing.
	self repaintWindow.
	^0!

onMouseWheeled: aMouseWheelEvent
	"Handler for a mouse wheel movement event. We must repaint the background image."

	| result |
	result := super onMouseWheeled: aMouseWheelEvent.
	self repaintWindow.
	^result!

onPaintRequired: aPaintEvent 
	"Handle a WM_PAINT event."

	"Implementation Note: This is effectively a double-buffered repaint of the complete client
	area. It therefore does a lot more repainting than may be necessary, but is flicker free."

	| bmp screenCanvas rect extent brush |
	screenCanvas := aPaintEvent canvas.
	extent := self clientExtent.
	bmp := Bitmap 
				compatible: screenCanvas
				width: extent x
				height: extent y.
	rect := 0 @ 0 extent: extent.
	"Erase the off-screen DC to the background texture - this is necessary to paint the margins of the control correctly."
	brush := self backBrush.
	bmp canvas fillRectangle: rect brush: brush.
	brush free.
	"Ask the control to paint itself onto the background dc"
	self 
		sendMessage: WM_PRINTCLIENT
		wParam: bmp canvas asParameter
		lParam: PRF_CLIENT.
	"Finally blit the background dc over the display dc"
	screenCanvas 
		bitBlt: bmp canvas
		rectangle: rect
		to: 0 @ 0
		rop: SRCCOPY.
	bmp free!

onVScroll: aScrollEvent
	"Implementaion Note: We must repaint on scroll to maintain the background image correctly."

	aScrollEvent defaultWindowProcessing.
	self repaintWindow.
	^0!

repaintWindow
	self invalidateRect: nil erase: false
	"Forced update not necessary"
	"self update"!

wmPaint: message wParam: wParam lParam: lParam 
	"Private - Override back to View implementation so we get a #onPaintRequired: message."

	self ensureLayoutValid.
	^self 
		basicPaint: message
		wParam: wParam
		lParam: lParam!

wmSize: message wParam: wParam lParam: lParam 
	"Private - Handler for a WM_SIZE (window resized) message."

	"Implementation Note: If not in #tile mode, then we need to regenerate the background brush
	to suit the new geometry."

	backMode == #tile ifFalse: [self freeBackBrush].
	^super 
		wmSize: message
		wParam: wParam
		lParam: lParam! !

!MultilineTextEditWithImage categoriesForMethods!
backBitmap!accessing!public! !
backBitmap:!accessing!public! !
backBrush!accessing!public! !
backMode!accessing!public! !
backMode:!accessing!public! !
createBackBrush!helpers!private! !
defaultBackgroundImage!helpers!private! !
enUpdate!event handling-win32!private! !
freeBackBrush!private!realizing/unrealizing! !
initialize!initializing!private! !
onColorRequired:!event handling!public! !
onEraseRequired:!event handling!public! !
onHScroll:!event handling!public! !
onMouseWheeled:!event handling!public! !
onPaintRequired:!event handling!public! !
onVScroll:!event handling!public! !
repaintWindow!helpers!private! !
wmPaint:wParam:lParam:!event handling-win32!private! !
wmSize:wParam:lParam:!event handling-win32!private! !
!

!MultilineTextEditWithImage class methodsFor!

example1
	"
	self example1
	"

	| t |
	t := self show.
	t parentView extent: 600 @ 400.
	t canVScroll: true.
	t text: Object comment.

	"Cycle through the different backmodes"
	
	[BackModes do: 
			[:each | 
			SessionManager inputState queueDeferredAction: [t backMode: each].
			Processor sleep: 3 seconds]] 
			fork!

initialize
	self addClassConstant: 'BackModes'
		value: #(#tile #topLeft #topCenter #topRight #rightCenter #bottomRight #bottomCenter #bottomLeft #leftCenter #center #stretch)! !

!MultilineTextEditWithImage class categoriesForMethods!
example1!examples!public! !
initialize!development!initializing!private! !
!

