"Filed out from Dolphin Smalltalk"!

GdiplusDoubleBufferedView subclass: #SeeingTheObjectsInside
	instanceVariableNames: 'insideObjectsScale background cachedBackground sun stepProcess random dolphinIntensity dolphinInside splashDelay hintBubble startTime scale originalBitmapDips renderBlock'
	classVariableNames: 'DolphinBackColor DolphinInsideBaseColor DolphinInsideIntensityColor DolphinInsideIntensityPeriod DolphinInsideIntensityTime DolphinMaxInitialScale DolphinMinInitialScale FrameRate InsideObjectExpandingPeriod InsideObjectMaxScale InsideObjectMinScale MajorVersionColor TitleTextColor'
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: 'splashPlayTheGame'!

SeeingTheObjectsInside guid: (GUID fromString: '{66a4dee3-a72c-4a2f-a14f-bffd6813ceef}')!

SeeingTheObjectsInside addClassConstant: 'DolphinInsideIntensityPeriod' value: 1500.0!
SeeingTheObjectsInside addClassConstant: 'DolphinInsideIntensityTime' value: 16r1B58!
SeeingTheObjectsInside addClassConstant: 'DolphinMaxInitialScale' value: 0.4!
SeeingTheObjectsInside addClassConstant: 'DolphinMinInitialScale' value: 0.3!
SeeingTheObjectsInside addClassConstant: 'FrameRate' value: 16r19!
SeeingTheObjectsInside addClassConstant: 'InsideObjectExpandingPeriod' value: 4500.0!
SeeingTheObjectsInside addClassConstant: 'InsideObjectMaxScale' value: 0.9!
SeeingTheObjectsInside addClassConstant: 'InsideObjectMinScale' value: 0.07!

SeeingTheObjectsInside comment: '"Seeing the Objects Inside" is the Dolphin tag line. The implication is that the fine grained approach of Smalltalk helps you, as a developer, to find the objects (and  classes) in your problem domain more easily than you can in many other languages. The SeeingTheObjectsInside class is intended to be a fun way to represent this idea as a game that can be played as part of the Dolphin splash screen. Try to find the hidden Dolphin object inside the larger Dolphin outline. Once found, click on it to dismiss the splash.

If you are a very busy and important person who just doesn''t have time to play a game each time you start an image, it can be disabled from within user preferences. Go to User Preferences/Development System/splashPlayTheGame and set this to false. Save the image to persist the setting.

You can run a standalone version of the game outside of the splash by evaluating:

SeeingTheObjectsInside show

'!

!SeeingTheObjectsInside categoriesForClass!Unclassified! !

!SeeingTheObjectsInside methodsFor!

addInsideObject: anObjectInside minScale: minScale maxScale: maxScale
	"Private - Adds an object and finds a position for it"

	anObjectInside scale: minScale asPoint.

	"Check not touching at first"
	(anObjectInside testCollisionIn: backSurface) ifTrue: [^nil].
	
	[anObjectInside scale: anObjectInside scale * 1.2.
	(anObjectInside testCollisionIn: backSurface) or: [anObjectInside scale r > maxScale]]
			whileFalse.
	anObjectInside baseScale: anObjectInside scale.
	self model add: anObjectInside!

bigVersionNumberFont
	^Font name: 'Arial Narrow' pointSize: 206!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

	^originalBitmapDips!

dismiss
	self topShell close!

drawBigVersionNumberOn: aCanvas
	aCanvas
		forecolor: MajorVersionColor;
		font: self bigVersionNumberFont;
		text: SessionManager current productVersion asInteger displayString at: (376 @ 338 * scale) truncated!

drawInfoTextOn: aCanvas
	aCanvas
		forecolor: TitleTextColor;
		font: (Font name: 'Segoe UI' pointSize: 8);
		formatText: self getBlurb in: ((50 @ 632 extent: 320 + 80) scaledBy: scale) truncated!

drawTextOn: aGraphics atDpi: anInteger
	self registerTitleFont.
	aGraphics doWithCanvas: 
			[:canvas |
			canvas
				dpi: anInteger;
				backcolor: (background pixelAt: Point.Zero).
			self
				drawTitlesOn: canvas;
				drawBigVersionNumberOn: canvas;
				drawInfoTextOn: canvas]!

drawTitlesOn: aCanvas
	aCanvas
		forecolor: TitleTextColor;
		font: (self titleFontOfSize: 68);
		text: 'Smalltalk' at: (44 @ 502 * scale) truncated;
		font: (self titleFontOfSize: 88);
		text: 'Dolphin' at: (40 @ 372 * scale) truncated!

elapsedTime
	"Answer the elapsed time in ms since the start of the animation"

	^Delay millisecondClockValue - startTime!

endZoomIn
	"Private - Re-render the background with the final expanded form of the objects inside, but using higher quality (but substantially slower) interpolation so that the visuals are better quality.
	The dolphin inside is a special case, as this changes colour in time. The resulting bitmap is then converted to a cached bitmap for use in a simplified render block that just draws the dolphin inside onto a white background before dumping the cached bitmap over that, the space inside the dolphin that is not occuppied by objects inside being transparent as before."

	| graphics |
	insideObjectsScale := InsideObjectMaxScale.
	background free.
	background := GdiplusBitmap extent: backSurface extent.
	graphics := background graphics.
	graphics interpolationMode: InterpolationModeHighQualityBicubic.
	self model from: 2
		do: 
			[:each |
			each
				scale: each baseScale * InsideObjectMaxScale;
				drawOn: graphics;
				free].
	graphics
		resetTransform;
		drawCachedBitmap: cachedBackground at: Point.Zero;
		free.
	cachedBackground free.
	cachedBackground := GdiplusCachedBitmap bitmap: background graphics: self graphics.
	dolphinInside scale: dolphinInside baseScale * InsideObjectMaxScale.
	renderBlock := self zoomedInRenderBlock!

fillWith: aLookupTableOfObjectsInside
	| graphics pts aCollectionOfObjectsInside dolphins |
	dolphins := {
				aLookupTableOfObjectsInside removeKey: 'Dolphin1.png'.
				aLookupTableOfObjectsInside removeKey: 'Dolphin2.png'
			}.
	aCollectionOfObjectsInside := aLookupTableOfObjectsInside values.
	self model removeAll.

	"Render the Dolphin outline so we can fit out objects inside"
	self render.
	dolphinInside := self randomFrom: dolphins.
	dolphinInside rotation: (random next * 360) rounded.
	graphics := self graphics.
	graphics interpolationMode: InterpolationModeLowQuality.
	"Find a suitable position and scale for the dolphin inside"
	pts := self points.
	
	[dolphinInside position: (self randomFrom: pts).
	(self
		addInsideObject: dolphinInside
		minScale: DolphinMinInitialScale
		maxScale: DolphinMaxInitialScale) notNil
		and: [dolphinInside scale >= DolphinMinInitialScale]]
			whileFalse.
	dolphinInside drawOn: graphics.
	graphics resetTransform.
	"Now fill in the remaining objects inside"
	pts do: 
			[:pt |
			| object |
			object := (self randomFrom: aCollectionOfObjectsInside) copy.
			object
				position: pt;
				rotation: (random next * 180) truncated - 90.
			(self
				addInsideObject: object
				minScale: InsideObjectMinScale
				maxScale: InsideObjectMaxScale) ifNil: [object free] ifNotNil: [object drawOn: graphics]].
	graphics free.

	"Re-render to unzoomed"	
	insideObjectsScale := 1 / InsideObjectExpandingPeriod.
	dolphinInside color: DolphinInsideBaseColor.
	self render!

getBlurb
	| copyright stream |
	copyright := $. split: VMLibrary default versionInfo legalCopyright.
	stream := Utf16String writeStream.
	stream nextPutAll: copyright first.
	(copyright size > 1 and: [copyright second notEmpty])
		ifTrue: 
			[stream
				nextPutAll: ', ';
				nextPutAll: copyright second].
	stream
		nextPut: $.;
		cr;
		nextPutAll: 'Dolphin ';
		nextPutAll: SessionManager current versionString;
		nextPutAll: ' is Open Source under the MIT License.'.
	SessionManager current bootInfo
		ifNotNil: 
			[:bootInfo |
			stream
				cr;
				nextPutAll: 'Image boot info: ';
				nextPutAll: bootInfo].
	^stream contents!

hasHintBubble
	^hintBubble notNil and: [hintBubble tooltip notNil]!

initialize
	super initialize.
	self backcolor: DolphinBackColor.
	insideObjectsScale := 0.1.
	dolphinIntensity := 0.
	random := Random new.
	self prepareBackground.
	renderBlock := self zoomInRenderBlock!

initializeSurfacesFor: aPointExtent
	"Private - Initialize the front and back surfaces for a view size of aPointExtent"

	super initializeSurfacesFor: aPointExtent.
	cachedBackground := GdiplusCachedBitmap bitmap: background graphics: self graphics!

invalidate
	"Flag the current rendition as being invalid. A repaint will cause a
	render to occur"

	requiresRender := true.
	self invalidateRect: nil erase: false!

isActionPoint: aPoint
	^self class splashPlayTheGame
		ifTrue: [self isPointInDolphin: aPoint]
		ifFalse: [self rectangle containsPoint: aPoint]!

isPointInDolphin: aPoint
	"Answer true if aPoint is within the dolphin inside. Do this most easily by looking for pixel colours"

	^(self backSurface pixelAt: aPoint) = dolphinInside color!

loadTextureMap: mapName
	| texture map textureMap |
	texture := GdiplusBitmap fromFile: 'Resources\' , (File default: mapName extension: 'png')
				usingLocator: FileLocator installRelative.
	"Drawing the images individually from the texture goes a lot faster if we force Gdiplus to load the whole thing now."
	texture forceValidation.
	map := FileStream read: (FileLocator installRelative
						localFileSpecFor: 'Resources\' , (File default: mapName extension: 'txt'))
				text: true.
	textureMap := LookupTable new.
	[map atEnd] whileFalse: 
			[| elements image sourceExtent targetExtent |
			elements := $, split: map nextLine.
			sourceExtent := elements fourth trimBlanks asNumber @ elements fifth trimBlanks asNumber.
			targetExtent := (sourceExtent * scale) rounded.
			image := GdiplusBitmap extent: targetExtent.
			image graphics
				interpolationMode: InterpolationModeHighQualityBicubic;
				drawImage: texture
					at: Point.Zero
					extent: targetExtent
					from: elements second trimBlanks asNumber @ elements third trimBlanks asNumber
					extent: sourceExtent;
				free.
			textureMap at: elements first put: (ObjectInside fromImage: image)].
	texture free.
	^textureMap!

onDestroyed
	self stopStepProcess.
	sun free.
	sun := nil.
	dolphinInside free.
	dolphinInside := nil.
	cachedBackground free.
	cachedBackground := nil.
	background free.
	background := nil.
	^super onDestroyed!

onGetCursor: aSymbol
	"The named area of the window associated with the receiver has been hit.
	Answer the appropriate mouse cursor, or nil to accept the default."

	| wantHandCursor |
	wantHandCursor := self isActionPoint: self cursorPosition.
	^wantHandCursor ifTrue: [Cursor hand] ifFalse: [super onGetCursor: aSymbol]!

onLeftButtonPressed: aMouseEvent 
	self render.
	(self isActionPoint: aMouseEvent position) 
		ifTrue: 
			[Cursor reset.
			self dismiss]
		ifFalse: [self showHintBubble]!

onViewCreated
	"Private - The receiver has just been created."

	| textureMap |
	super onViewCreated.
	textureMap := self loadTextureMap: 'ObjectsInside'.
	sun := textureMap removeKey: 'SeeingTheObjects.png'.

	"The rotating sun should be inset half an inch from the top right corner"
	sun position: (background extent x @ 0 - ((sun extent + self dpi) / 2)) truncated abs.
	self fillWith: textureMap.
	"Defer starting the step process until the image has quiesced. Otherwise when starting an image with a lot of open windows, the splash will appear and render a zoomed out state, then jump ahead when all the old windows have been restored. We want it to zoom in smoothly, so need background cycles available to do that."
	[self startStepProcess] postToInputQueue.
	textureMap do: [:each | each free]!

pointResolution
	^##(25 @ 25) * scale!

points
	"Compute a set of point locations that are inside the dolphin"

	| argb hbmp gdip resolution height points |
	points := Array writeStream: 100.
	"Add some know good points"
	##({ 306 @ 156. 247 @ 266. 518 @ 394. 335 @ 52. 62 @ 307 })
		do: [:each | points nextPut: (each * scale) truncated].
	resolution := self pointResolution.
	height := background height.
	argb := ByteArray newFixed: 4.
	hbmp := background handle.
	gdip := GdiplusLibrary default.
	6 to: background width - 6
		by: resolution x
		do: 
			[:x |
			6 to: height - 6
				by: resolution y
				do: 
					[:y |
					| ptX ptY |
					ptX := (random next * 2 + x) rounded.
					ptY := (random next * 2 + y) rounded.
					gdip
						gdipBitmapGetPixel: hbmp
						x: ptX
						y: ptY
						color: argb.
					((argb sdwordAtOffset: 0) == 0 and: [random next > 0.2]) ifTrue: [points nextPut: ptX @ ptY]]].
	^points contents!

prepareBackground
	| dpi dolphinOutline extent graphics |
	background := GdiplusBitmap fromFile: 'Resources\Dolphin7Splash.png'
				usingLocator: FileLocator installRelative.
	"The bitmap has been saved at 72 dpi, but treat it as 96 to get 3/4 scale as otherwise the splash is too large"
	originalBitmapDips := background extent.
	"Splash screen should always be shown on the active monitor"
	dpi := DisplayMonitor active dpi.
	scale := dpi / 96.0.
	scale = 1
		ifFalse: 
			[| bitmap |
			extent := originalBitmapDips * scale.
			bitmap := GdiplusBitmap extent: extent.
			bitmap graphics
				interpolationMode: InterpolationModeHighQuality;
				drawImage: background
					at: Point.Zero
					extent: extent;
				free.
			background free.
			background := bitmap].
	dolphinOutline := GdiplusBitmap fromFile: 'Resources\DolphinOutline.png'
				usingLocator: FileLocator installRelative.
	extent := dolphinOutline extent.
	graphics := background graphics.
	self drawTextOn: graphics atDpi: dpi.
	graphics
		interpolationMode: InterpolationModeHighQuality;
		drawImage: dolphinOutline
			at: Point.Zero
			extent: (extent * scale) rounded
			from: Point.Zero
			extent: extent;
		free.
	dolphinOutline free!

randomFrom: aSequencedReadableCollection
	^aSequencedReadableCollection at: (random next * aSequencedReadableCollection size) truncated + 1!

registerTitleFont
	"Private - "

	GDILibrary default
		addFontResourceEx: (FileLocator installRelative localFileSpecFor: 'Resources\Mohave-Medium.ttf')
		fl: ##(FR_PRIVATE | FR_NOT_ENUM)
		res: 0!

render
	"Private - Render the background image"

	renderBlock on: Error
		do: 
			[:ex |
			self stopStepProcess.
			ex pass]!

showHintBubble
	hintBubble := MessageBubble new
				caption: 'Hint';
				maxWidth: 140;
				willFade: true;
				timeout: 5 seconds.
	hintBubble
		position: (self mapPointToScreen: sun position);
		notify: 'Find the dolphin inside and click to continue.'!

startStepProcess
	self stopStepProcess.
	startTime := Delay millisecondClockValue.
	stepProcess := 
			[
			[[self step] on: Error do: [:ex | ex toTrace].
			Processor sleep: 1000 // FrameRate.
			self isOpen]
					whileTrue]
					forkAt: Processor userBackgroundPriority!

step
	sun rotation: sun rotation - (1.3 * insideObjectsScale).
	dolphinIntensity > 0
		ifTrue: [dolphinInside color: (DolphinInsideIntensityColor intensity: dolphinIntensity)].
	self stepInsideObjectsScale.
	self stepDolphinInsideIntensity.
	self invalidate!

stepDolphinInsideIntensity
	"Increase the intensity of the dolphin inside so it acts as a visually obvious clue."

	dolphinIntensity := ((self elapsedTime - (InsideObjectExpandingPeriod + DolphinInsideIntensityTime))
				/ DolphinInsideIntensityPeriod min: 1)
				max: 0!

stepInsideObjectsScale
	"Increase the scale of the objects inside so they zoom in when the animation starts"

	insideObjectsScale < InsideObjectMaxScale
		ifTrue: 
			[insideObjectsScale := (self elapsedTime max: 1) / InsideObjectExpandingPeriod.
			insideObjectsScale >= InsideObjectMaxScale ifTrue: [self endZoomIn]]!

stopStepProcess
	stepProcess 
		ifNotNil: 
			[stepProcess terminate.
			stepProcess := nil]!

titleFontOfSize: anInteger
	^(Font name: 'Mohave Medium' pointSize: anInteger)
		quality: #proof;
		yourself!

unregisterTitleFont
	"Private - "

	GDILibrary default
		removeFontResource: (FileLocator installRelative localFileSpecFor: 'Resources\Mohave-Regular.ttf')!

zoomedInRenderBlock
	"Private - Answer the rendering logic for painting the splash onto the backsurface when the inside objects have finished expanding. At this point the cached bitmap has been updated to include the final high quality rendering of the inside objects excluding the dolphin and the rotating sun. Therefore all we need to do is draw the dolphin (which will change colour over time to emphasise its position), overlap the background and other objects, and finally draw the sun. This should take only a few milliseconds."

	^
	[| graphics |
	requiresRender := false.
	graphics := self graphics.
	graphics
		erase;
		interpolationMode: InterpolationModeHighQualityBicubic.
	dolphinInside drawOn: graphics.
	graphics
		resetTransform;
		interpolationMode: InterpolationModeDefault.
	graphics drawCachedBitmap: cachedBackground at: Point.Zero.
	sun drawOn: graphics.
	graphics free]!

zoomInRenderBlock
	"Private - Answer the rendering logic for painting the splash onto the backsurface while the inside objects are expanding. To make this fast (<10mS), we use a low-quality interpolation mode for the scaling. Since the edges are moving, this is less obvious. If we scale each of the inside objects with high quality interpolation then the rendering time will be more like 50mS, and we would not be able to sustain a frame rate > 20fps."

	^
	[| graphics |
	requiresRender := false.
	graphics := self graphics.
	graphics
		erase;
		interpolationMode: InterpolationModeLowQuality.
	self model do: 
			[:each |
			each
				scale: each baseScale * insideObjectsScale;
				drawOn: graphics].
	graphics
		resetTransform;
		drawCachedBitmap: cachedBackground at: Point.Zero.
	sun drawOn: graphics.
	graphics free]! !

!SeeingTheObjectsInside categoriesForMethods!
addInsideObject:minScale:maxScale:!private! !
bigVersionNumberFont!constants!private! !
defaultExtent!constants!geometry!private!realizing/unrealizing! !
dismiss!event handling!private! !
drawBigVersionNumberOn:!operations!private! !
drawInfoTextOn:!operations!private! !
drawTextOn:atDpi:!operations!private! !
drawTitlesOn:!operations!private! !
elapsedTime!operations!public! !
endZoomIn!operations!private! !
fillWith:!event handling!private! !
getBlurb!helpers!private! !
hasHintBubble!event handling!private!testing! !
initialize!initializing!private! !
initializeSurfacesFor:!initializing!private! !
invalidate!operations!public! !
isActionPoint:!event handling!private! !
isPointInDolphin:!event handling!private!testing! !
loadTextureMap:!accessing!private! !
onDestroyed!event handling!private! !
onGetCursor:!event handling!private! !
onLeftButtonPressed:!event handling!private! !
onViewCreated!event handling!private! !
pointResolution!constants!public! !
points!accessing!private! !
prepareBackground!initializing!private! !
randomFrom:!private! !
registerTitleFont!operations!private! !
render!operations!private! !
showHintBubble!private! !
startStepProcess!initializing!private! !
step!operations!public! !
stepDolphinInsideIntensity!operations!private! !
stepInsideObjectsScale!operations!private! !
stopStepProcess!initializing!private! !
titleFontOfSize:!operations!private! !
unregisterTitleFont!operations!private! !
zoomedInRenderBlock!operations!private! !
zoomInRenderBlock!operations!private! !
!

!SeeingTheObjectsInside class methodsFor!

canDisplay
	"Answer true if an instance of the receiver can be correctly displayed"

	"Displays of less than 800x600 resolution or with a palette cannot correctly display the Dolphin
	splash bitmap. Also Win95/NT can't do the alpha blending thing."

	| metrics |
	metrics := SystemMetrics current.
	^(metrics defaultColorDepth > 8 and: [View desktop extent >= (800 @ 600)])
		and: [metrics supportsAlphaBlending]!

initialize
	self addClassConstant: 'DolphinBackColor' value: Color white.
	self addClassConstant: 'DolphinInsideBaseColor' value: (Color brightness: 16r1 / 16rFF).
	self addClassConstant: 'DolphinInsideIntensityColor'
		value: (Color
				r: 16rC0
				g: 16r59
				b: 16rCF).
	self addClassConstant: 'MajorVersionColor'
		value: (Color
				r: 16rD7
				g: 16r6D
				b: 16r0A).
	self addClassConstant: 'TitleTextColor' value: Color white!

splashPlayTheGame
	^splashPlayTheGame ifNil: [splashPlayTheGame := false]!

splashPlayTheGame: aBoolean 
	splashPlayTheGame := aBoolean! !

!SeeingTheObjectsInside class categoriesForMethods!
canDisplay!accessing!public! !
initialize!class initialization!public! !
splashPlayTheGame!accessing!public! !
splashPlayTheGame:!accessing!public! !
!

