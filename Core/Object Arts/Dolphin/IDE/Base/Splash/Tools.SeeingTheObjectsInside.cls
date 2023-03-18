"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.DoubleBufferedView
	subclass: #'Tools.SeeingTheObjectsInside'
	instanceVariableNames: 'background points sun stepProcess random insideObjectsScale dolphinIntensity objects dolphins dolphinInside hintBubble startTime info baseScale cachedBackground cachedOutline'
	classVariableNames: ''
	imports: #(#{Graphics private} #{Graphics.Gdiplus private})
	classInstanceVariableNames: 'splashPlayTheGame'
	classConstants: {}!
Tools.SeeingTheObjectsInside guid: (Core.GUID fromString: '{66a4dee3-a72c-4a2f-a14f-bffd6813ceef}')!
Tools.SeeingTheObjectsInside comment: '"Seeing the Objects Inside" is the Dolphin tag line. The implication is that the fine grained approach of Smalltalk helps you, as a developer, to find the objects (and  classes) in your problem domain more easily than you can in many other languages. The SeeingTheObjectsInside class is intended to be a fun way to represent this idea as a game that can be played as part of the Dolphin splash screen. Try to find the hidden Dolphin object inside the larger Dolphin outline. Once found, click on it to dismiss the splash.

If you are a very busy and important person who just doesn''t have time to play a game each time you start an image, it can be disabled from within user preferences. Go to User Preferences/Development System/splashPlayTheGame and set this to false. Save the image to persist the setting.

You can run a standalone version of the game outside of the splash by evaluating:

SeeingTheObjectsInside show

'!
!Tools.SeeingTheObjectsInside methodsFor!

addInsideObject: anObject minScale: minScale maxScale: maxScale
	"Private - Adds an object and finds a position for it"

	anObject scale: minScale asPoint.

	"Check not touching at first"
	(anObject testCollisionIn: self backSurface) ifTrue: [^nil].
	
	[anObject scale: anObject scale * 1.2.
	(anObject testCollisionIn: self backSurface) or: [anObject scale r > maxScale ]] 
			whileFalse.
	self model add: anObject.
!

background
	^background
		ifNil: 
			[background := self splashBitmap.
			self baseScale = 1
				ifFalse: 
					[background := Gdiplus.Bitmap fromImage: background
								centeredIn: (background extent * self baseScale) rounded].
			background]!

baseScale
	"Answer a scale that fits the receiver to the desktop"

	^baseScale
!

defaultExtent
	^self background extent!

dismiss
	self topShell close!

dolphinInsideBaseColor
	^Color 
		r: 1
		g: 1
		b: 1!

dolphinInsideIntensityColor
	^Color
		r: 192
		g: 89
		b: 207!

dolphinInsideIntensityPeriod
	^1500!

dolphinInsideIntensityTime
	^7000!

dolphinMaxScale
	^0.4!

dolphinMinScale
	^0.3!

dolphinOutline
	| dolphinOutline |
	dolphinOutline := Gdiplus.Bitmap fromFile: 'Resources\DolphinOutline.png'
				usingLocator: FileLocator installRelative.
	self baseStyle = 1
		ifFalse: [dolphinOutline := Gdiplus.Bitmap fromImage: dolphinOutline scaledBy: self baseScale].
	^dolphinOutline!

drawInfoTextOn: aGdiplusGraphics
	| fontCopyright brush |
	brush := Gdiplus.Brush color: Color white.
	fontCopyright := Gdiplus.Font name: 'Arial' pointSize: 9.
	aGdiplusGraphics
		textRenderingHint: TextRenderingHintAntiAlias;
		drawString: info
			font: fontCopyright
			at: (48 @ 630 * self baseScale) rounded
			format: StringFormat genericDefault
			brush: brush.
	fontCopyright free.
	brush free!

elapsedTime
	"Answer the elapsed time in ms since the start of the animation"

	^Delay millisecondClockValue - startTime!

fill
	| dolphinPt min max pts |
	self model removeAll.

	"Render the Dolphin outline so we can fit out objects inside"
	self render.
	dolphinInside := (self randomFrom: dolphins) copy.
	dolphinInside rotation: (random next * 360) rounded.

	"Find a suitable position and scale for the dolphin inside"
	min := self dolphinMinScale.
	max := self dolphinMaxScale.
	pts := self points.
	
	[dolphinPt := self randomFrom: pts.
	dolphinInside position: dolphinPt.
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
			object := (self randomFrom: objects) copy.
			object
				position: pt;
				rotation: (random next * 180) truncated - 90.
			self
				addInsideObject: object
				minScale: min
				maxScale: max.
			object drawOn: graphics].

	"Re-render to fill the Dolphin with objects of the correct scale"
	dolphinInside color: self dolphinInsideBaseColor.
	self render!

frameRate
	^25!

hasHintBubble
	^hintBubble notNil and: [hintBubble tooltip notNil]!

initialize
	| copyright scale |
	super initialize.
	self backcolor: Color white.
	insideObjectsScale := 0.1.
	dolphinIntensity := 0.
	self loadTextureMap: 'ObjectsInside'.
	random := Random new.
	copyright := $. split: VM versionInfo legalCopyright.
	info := Utf16String writeStream.
	info nextPutAll: copyright first.
	(copyright size > 1 and: [copyright second notEmpty])
		ifTrue: 
			[info
				nextPutAll: ', ';
				nextPutAll: copyright second].
	info
		nextPut: $.;
		cr;
		nextPutAll: SessionManager current versionString;
		nextPutAll: ' is Open Source under the MIT License.'.
	SessionManager current bootInfo
		ifNotNil: 
			[:bootInfo |
			info
				cr;
				nextPutAll: 'Image boot info: ';
				display: bootInfo].
	info := info contents.
	scale := View desktop extent * 0.75 / self originalBitmapExtent.
	baseScale := (scale x min: scale y) min: 1.
	self startStepProcess!

initializeSurfacesFor: aPointExtent
	"Private - Initialize the front and back surfaces for a view size of aPointExtent"

	super initializeSurfacesFor: aPointExtent.
	graphics := backSurface graphics.
	cachedBackground := CachedBitmap bitmap: self background graphics: graphics.
	cachedOutline := CachedBitmap bitmap: self dolphinOutline graphics: graphics!

insideObjectMaxScale
	^1!

insideObjectMinScale
	^0.07!

insideObjectScaleInPeriod
	^4500!

isActionPoint: aPoint
	^self class splashPlayTheGame
		ifTrue: [self isPointInDolphin: aPoint]
		ifFalse: [self rectangle containsPoint: aPoint]!

isPointInDolphin: aPoint
	"Answer true if aPoint is within the dolphin inside. Do this most easily by looking for pixel colours"

	| pixel |
	pixel := self backSurface pixelAt: aPoint.
	^pixel = dolphinInside color!

loadTextureMap: mapName
	| texture map textureMap |
	texture := Gdiplus.Bitmap fromFile: 'Resources\' , (File default: mapName extension: 'png')
				usingLocator: FileLocator installRelative.
	map := FileStream read: (FileLocator installRelative
						localFileSpecFor: 'Resources\' , (File default: mapName extension: 'txt'))
				text: true.
	textureMap := LookupTable new.
	baseScale := View desktop extent * 0.75 / self originalBitmapExtent.
	baseScale := (baseScale x min: baseScale y) min: 1.
	[map atEnd] whileFalse: 
			[| elements bm |
			elements := $, split: map nextLine.
			bm := Gdiplus.Bitmap fromImage: texture
						crop: (elements second trimBlanks asNumber @ elements third trimBlanks asNumber
								extent: elements fourth trimBlanks asNumber @ elements fifth trimBlanks asNumber).
			textureMap at: elements first put: (ObjectInside fromImage: bm scaledBy: baseScale)].
	sun := textureMap removeKey: 'SeeingTheObjects.png'.
	dolphins := {textureMap removeKey: 'Dolphin1.png'. textureMap removeKey: 'Dolphin2.png'}.
	objects := textureMap values.
	^textureMap!

onDestroyed
	self stopStepProcess.
	^super onDestroyed!

onGetCursor: aSymbol
	"The named area of the window associated with the receiver has been hit.
	Answer the appropriate mouse cursor, or nil to accept the default."

	| wantHandCursor |
	wantHandCursor := self isPointInDolphin: self cursorPosition.
	^wantHandCursor ifTrue: [Cursor hand] ifFalse: [super onGetCursor: aSymbol]!

onLeftButtonPressed: aMouseEvent
	self render.
	(self isActionPoint: aMouseEvent position) ifTrue: [self dismiss] ifFalse: [self showHintBubble]!

onViewCreated
	"Private - The receiver has just been created."

	super onViewCreated.
	self fill!

originalBitmapExtent
	^710 @ 710!

pointResolution
	^(25 @ 25) * self baseScale!

points
	"Compute a set of point locations that are inside the dolphin"

	^points
		ifNil: 
			[| mask |
			points := OrderedCollection new.
			"Add some know good points"
			points
				add: 306 @ 156;
				add: 247 @ 266;
				add: 518 @ 394;
				add: 335 @ 52;
				add: 62 @ 307.
			mask := self background.
			6 to: mask width - 6
				by: self pointResolution x
				do: 
					[:x |
					6 to: mask height - 6
						by: self pointResolution y
						do: 
							[:y |
							| pt |
							pt := ((random next * 2 + x) @ (random next * 2 + y)) rounded.
							((mask pixelAt: pt) alpha = 0 and: [random next > 0.2]) ifTrue: [points add: pt]]].
			points]!

randomFrom: anOrderedCollection
	| index |
	index := (random next * anOrderedCollection size) truncated + 1.
	^anOrderedCollection at: index!

render
	"Private - Render the background image"

	
	[| surface |
	surface := self graphics.
	surface clear: Color white.
	self model do: 
			[:each |
			| existingScale |
			existingScale := each scale.
			each scale: existingScale * insideObjectsScale.
			each drawOn: surface.
			each scale: existingScale].
	surface
		drawCachedBitmap: cachedBackground at: Point.Zero;
		drawCachedBitmap: cachedOutline at: Point.Zero.
	sun
		position: self sunPosition;
		drawOn: surface.
	self drawInfoTextOn: surface.
	super render]
			on: Error
			do: 
				[:ex |
				self stopStepProcess.
				ex pass]!

showHintBubble
	self hasHintBubble ifTrue: [^self].
	hintBubble := MessageBubble new
				caption: 'Hint';
				maxWidth: 140;
				timeout: 5 seconds.
	hintBubble
		position: (self mapPointToScreen: self sunPosition);
		notify: 'Find the dolphin inside and click to continue.'!

splashBitmap
	| bitmap rawBitmap extent imageAttr bitmapBackcolor systemBackcolor |
	rawBitmap := Gdiplus.Bitmap fromFile: 'Resources\DolphinSplash.png'
				usingLocator: FileLocator installRelative.
	extent := rawBitmap extent.
	bitmap := Gdiplus.Bitmap extent: extent.
	bitmapBackcolor := rawBitmap pixelAt: Point.Zero.
	systemBackcolor := SmalltalkSystemShell backcolor.
	imageAttr := bitmapBackcolor = systemBackcolor
				ifFalse: 
					[ImageAttributes new
						remapColor: bitmapBackcolor to: systemBackcolor;
						yourself].
	bitmap graphics
		drawImage: rawBitmap attributes: imageAttr;
		free.
	imageAttr free.
	^bitmap!

startStepProcess
	self stopStepProcess.
	startTime := Delay millisecondClockValue.
	stepProcess := 
			[
			[[self step] on: Error do: [:ex | ex toTrace].
			Processor sleep: 1000 // self frameRate.
			self isOpen] whileTrue]
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

sunPosition
	^(612 @ 98) * self baseScale! !
!Tools.SeeingTheObjectsInside categoriesForMethods!
addInsideObject:minScale:maxScale:!private! !
background!accessing!private! !
baseScale!constants!public! !
defaultExtent!accessing!private! !
dismiss!event handling!private! !
dolphinInsideBaseColor!constants!public! !
dolphinInsideIntensityColor!constants!public! !
dolphinInsideIntensityPeriod!constants!operations!public! !
dolphinInsideIntensityTime!constants!operations!public! !
dolphinMaxScale!public! !
dolphinMinScale!public! !
dolphinOutline!accessing!private! !
drawInfoTextOn:!operations!private! !
elapsedTime!operations!public! !
fill!event handling!private! !
frameRate!constants!public! !
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
originalBitmapExtent!constants!public! !
pointResolution!constants!public! !
points!accessing!private! !
randomFrom:!private! !
render!operations!private! !
showHintBubble!private! !
splashBitmap!helpers!private! !
startStepProcess!initializing!private! !
step!operations!public! !
stepDolphinInsideIntensity!operations!private! !
stepInsideObjectsScale!operations!private! !
stopStepProcess!initializing!private! !
sunPosition!constants!public! !
!

!Tools.SeeingTheObjectsInside class methodsFor!

canDisplay
	"Answer true if an instance of the receiver can be correctly displayed"

	"Displays of less than 800x600 resolution or with a palette cannot correctly display the Dolphin
	splash bitmap. Also Win95/NT can't do the alpha blending thing."

	| desktopCanvas |
	desktopCanvas := Canvas forDesktop.
	^desktopCanvas colorDepth > 8 and: [desktopCanvas extent >= (800 @ 600)]!

splashPlayTheGame
	^splashPlayTheGame ifNil: [splashPlayTheGame := false]!

splashPlayTheGame: aBoolean 
	splashPlayTheGame := aBoolean! !
!Tools.SeeingTheObjectsInside class categoriesForMethods!
canDisplay!accessing!public! !
splashPlayTheGame!public! !
splashPlayTheGame:!public! !
!

