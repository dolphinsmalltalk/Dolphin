"Filed out from Dolphin Smalltalk"!

GdiplusDoubleBufferedView subclass: #SeeingTheObjectsInside
	instanceVariableNames: 'insideObjectsScale background cachedBackground sun stepProcess random dolphinIntensity dolphinInside splashDelay hintBubble startTime scale originalBitmapDips'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: 'splashPlayTheGame difficultyLevel'!

SeeingTheObjectsInside guid: (GUID fromString: '{66a4dee3-a72c-4a2f-a14f-bffd6813ceef}')!

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

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

	^originalBitmapDips!

dismiss
	self topShell close!

dolphinInsideBaseColor
	^##(Color 
		r: 1
		g: 1
		b: 1)!

dolphinInsideIntensityColor
	^##(Color 
		r: 215
		g: 109
		b: 10)!

dolphinInsideIntensityPeriod
	^1500.0!

dolphinInsideIntensityTime
	^7000!

dolphinMaxScale
	^0.4!

dolphinMinScale
	^0.3!

drawBigVersionNumberOn: aCanvas
	aCanvas
		forecolor: (Color
					red: 215
					green: 109
					blue: 10);
		font: ((Font name: 'Arial Narrow' pointSize: 206)
					weight: 600;
					yourself);
		text: '7' at: (376 @ 338 * scale) truncated!

drawInfoTextOn: aCanvas
	aCanvas
		forecolor: self textColor;
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
		forecolor: self textColor;
		font: (self titleFontOfSize: 68);
		text: 'Smalltalk' at: (44 @ 502 * scale) truncated;
		font: (self titleFontOfSize: 88);
		text: 'Dolphin' at: (40 @ 372 * scale) truncated!

elapsedTime
	"Answer the elapsed time in ms since the start of the animation"

	^Delay millisecondClockValue - startTime!

fillWith: aLookupTableOfObjectsInside
	| graphics min max pts aCollectionOfObjectsInside dolphins |
	dolphins := {aLookupTableOfObjectsInside removeKey: 'Dolphin1.png'.
				aLookupTableOfObjectsInside removeKey: 'Dolphin2.png'}.
	aCollectionOfObjectsInside := aLookupTableOfObjectsInside values.
	self model removeAll.

	"Render the Dolphin outline so we can fit out objects inside"
	self render.
	dolphinInside := (self randomFrom: dolphins).
	dolphinInside rotation: (random next * 360) rounded.
	graphics := self graphics.
	graphics interpolationMode: InterpolationModeHighQualityBicubic.
	"Find a suitable position and scale for the dolphin inside"
	min := self dolphinMinScale.
	max := self dolphinMaxScale.
	pts := self points.
	
	[dolphinInside position: (self randomFrom: pts).
	(self
		addInsideObject: dolphinInside
		minScale: min
		maxScale: max) notNil
		and: [dolphinInside scale >= min]]
			whileFalse.
	dolphinInside drawOn: graphics.
	"Now fill in the remaining objects inside"
	min := self insideObjectMinScale.
	max := self insideObjectMaxScale.
	pts do: 
			[:pt |
			| object |
			object := (self randomFrom: aCollectionOfObjectsInside) copy.
			object
				position: pt;
				rotation: (random next * 180) truncated - 90.
			(self
				addInsideObject: object
				minScale: min
				maxScale: max) ifNil: [object free] ifNotNil: [object drawOn: graphics]].
	graphics free.

	"Re-render to fill the Dolphin with objects of the correct scale"
	dolphinInside color: self dolphinInsideBaseColor.
	self render!

frameRate
	^25!

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
	self backcolor: Color white.
	insideObjectsScale := 0.1.
	dolphinIntensity := 0.
	random := Random new.
	self prepareBackground!

initializeSurfacesFor: aPointExtent
	"Private - Initialize the front and back surfaces for a view size of aPointExtent"

	super initializeSurfacesFor: aPointExtent.
	cachedBackground := GdiplusCachedBitmap bitmap: background graphics: self graphics!

insideObjectMaxScale
	^1!

insideObjectMinScale
	^0.07!

insideObjectScaleInPeriod
	^4500.0!

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
	map := FileStream read: (FileLocator installRelative
						localFileSpecFor: 'Resources\' , (File default: mapName extension: 'txt'))
				text: true.
	textureMap := LookupTable new.
	[map atEnd] whileFalse: 
			[| elements image |
			elements := $, split: map nextLine.
			image := GdiplusBitmap fromImage: texture
						crop: (elements second trimBlanks asNumber @ elements third trimBlanks asNumber
								extent: elements fourth trimBlanks asNumber @ elements fifth trimBlanks asNumber).
			scale = 1
				ifFalse: 
					[| scaled |
					scaled := GdiplusBitmap fromImage: image scaledBy: scale.
					image free.
					image := scaled].
			textureMap at: elements first put: (ObjectInside fromImage: image)].
	texture free.
	^textureMap!

onDestroyed
	self stopStepProcess.
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
	self startStepProcess.
	self fillWith: textureMap.
	textureMap do: [:each | each free]!

pointResolution
	^##(25 @ 25) * scale!

points
	"Compute a set of point locations that are inside the dolphin"

	| resolution points height |
	points := Array writeStream: 100.
	"Add some know good points"
	points
		nextPut: 306 @ 156;
		nextPut: 247 @ 266;
		nextPut: 518 @ 394;
		nextPut: 335 @ 52;
		nextPut: 62 @ 307.
	resolution := self pointResolution.
	height := background height.
	6 to: background width - 6
		by: resolution x
		do: 
			[:x |
			6 to: height - 6
				by: resolution y
				do: 
					[:y |
					| pt |
					pt := ((random next * 2 + x) @ (random next * 2 + y)) rounded.
					((background pixelAt: pt) alpha == 0 and: [random next > 0.2]) ifTrue: [points nextPut: pt]]].
	^points contents!

prepareBackground
	| bitmapDpi graphics dpi dolphinOutline |
	background := GdiplusBitmap fromFile: 'Resources\Dolphin7Splash.png'
				usingLocator: FileLocator installRelative.
	"The bitmap has been saved at 72 dpi, but treat it as 96 to get 3/4 scale as otherwise the splash is too large"
	bitmapDpi := 96.0.	"background resolution x"
	originalBitmapDips := background extent * USER_DEFAULT_SCREEN_DPI // bitmapDpi.
	"Splash screen should always be shown on the active monitor"
	dpi := DisplayMonitor active dpi.
	scale := dpi / bitmapDpi.
	background := self rescaleBitmap: background.
	graphics := background graphics.
	self drawTextOn: graphics atDpi: dpi.
	dolphinOutline := self rescaleBitmap: (GdiplusBitmap fromFile: 'Resources\DolphinOutline.png'
						usingLocator: FileLocator installRelative).
	graphics
		drawImage: dolphinOutline
		at: Point zero
		extent: dolphinOutline extent.
	dolphinOutline free.
	graphics free!

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

	
	[| graphics |
	graphics := self graphics.
	graphics
		erase;
		interpolationMode: InterpolationModeHighQualityBicubic.
	self model do: 
			[:each |
			each
				scale: each baseScale * insideObjectsScale;
				drawOn: graphics].
	graphics drawCachedBitmap: cachedBackground at: Point.Zero.
	sun drawOn: graphics.
	super render.
	graphics free]
			on: Error
			do: 
				[:ex |
				self stopStepProcess.
				ex pass]!

rescaleBitmap: aGdiplusBitmap
	| scaled |
	scale = 1 ifTrue: [^aGdiplusBitmap].
	scaled := GdiplusBitmap fromImage: aGdiplusBitmap scaledBy: scale.
	aGdiplusBitmap free.
	^scaled!

showHintBubble
	self hasHintBubble ifTrue: [^self].
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
			Processor sleep: 1000 // self frameRate] repeat]
					forkAt: Processor userBackgroundPriority!

step
	sun rotation: sun rotation - (1.3 * insideObjectsScale).
	dolphinIntensity > 0
		ifTrue: [dolphinInside color: (self dolphinInsideIntensityColor intensity: dolphinIntensity)].
	self stepInsideObjectsScale.
	self stepDolphinInsideIntensity.
	self invalidate!

stepDolphinInsideIntensity
	"Increase the intensity of the dolphin inside so it acts as a visual clue for the blind"

	dolphinIntensity := ((self elapsedTime 
				- (self insideObjectScaleInPeriod + self dolphinInsideIntensityTime)) 
					/ self dolphinInsideIntensityPeriod min: 1) 
				max: 0!

stepInsideObjectsScale
	"Increase the scale of the objects inside so they zoom in when the animation starts"

	insideObjectsScale := self elapsedTime / self insideObjectScaleInPeriod min: 0.9!

stopStepProcess
	stepProcess 
		ifNotNil: 
			[stepProcess terminate.
			stepProcess := nil]!

textColor
	^Color white!

titleFontOfSize: anInteger
	^(Font name: 'Mohave Medium' pointSize: anInteger)
		quality: #proof;
		yourself!

unregisterTitleFont
	"Private - "

	GDILibrary default
		removeFontResource: (FileLocator installRelative localFileSpecFor: 'Resources\Mohave-Regular.ttf')! !

!SeeingTheObjectsInside categoriesForMethods!
addInsideObject:minScale:maxScale:!private! !
defaultExtent!constants!geometry!private!realizing/unrealizing! !
dismiss!event handling!private! !
dolphinInsideBaseColor!constants!public! !
dolphinInsideIntensityColor!constants!public! !
dolphinInsideIntensityPeriod!constants!operations!public! !
dolphinInsideIntensityTime!constants!operations!public! !
dolphinMaxScale!public! !
dolphinMinScale!public! !
drawBigVersionNumberOn:!operations!private! !
drawInfoTextOn:!operations!private! !
drawTextOn:atDpi:!operations!private! !
drawTitlesOn:!operations!private! !
elapsedTime!operations!public! !
fillWith:!event handling!private! !
frameRate!constants!public! !
getBlurb!helpers!private! !
hasHintBubble!event handling!private!testing! !
initialize!initializing!private! !
initializeSurfacesFor:!initializing!private! !
insideObjectMaxScale!constants!public! !
insideObjectMinScale!constants!public! !
insideObjectScaleInPeriod!constants!operations!public! !
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
rescaleBitmap:!initializing!private! !
showHintBubble!private! !
startStepProcess!initializing!private! !
step!operations!public! !
stepDolphinInsideIntensity!operations!private! !
stepInsideObjectsScale!operations!private! !
stopStepProcess!initializing!private! !
textColor!constants!private! !
titleFontOfSize:!operations!private! !
unregisterTitleFont!operations!private! !
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

splashPlayTheGame
	^splashPlayTheGame ifNil: [splashPlayTheGame := false]!

splashPlayTheGame: aBoolean 
	splashPlayTheGame := aBoolean! !

!SeeingTheObjectsInside class categoriesForMethods!
canDisplay!accessing!public! !
splashPlayTheGame!public! !
splashPlayTheGame:!public! !
!

