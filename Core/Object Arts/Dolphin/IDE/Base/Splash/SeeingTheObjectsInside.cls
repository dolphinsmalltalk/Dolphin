"Filed out from Dolphin Smalltalk 7"!

GdiplusDoubleBufferedView subclass: #SeeingTheObjectsInside
	instanceVariableNames: 'background dolphinOutline points sun stepProcess random insideObjectsScale dolphinIntensity textureMap objects dolphins dolphinInside splashDelay hintBubble startTime'
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

addInsideObject: anObject minScale: minScale maxScale: maxScale
	"Private - Adds an object and finds a position for it"

	anObject scale: minScale asPoint.

	"Check not touching at first"
	(anObject testCollisionIn: self backSurface) ifTrue: [^nil].
	
	[anObject scale: anObject scale * 1.2.
	(anObject testCollisionIn: self backSurface) or: [anObject scale r > maxScale ]] 
			whileFalse.
	self model add: anObject.
	anObject drawOn: self graphics!

background
	^background 
		ifNil: 
			[background := GdiplusBitmap fromFile: 'Resources\Dolphin7Splash.png'
						usingLocator: FileLocator installRelative.
			self baseStyle = 1 
				ifFalse: 
					[background := GdiplusBitmap fromImage: background
								centeredIn: (background extent * self baseScale) rounded]]!

baseScale
	"Answer a scale that fits the receiver to the desktop"

	| scale |
	scale := View desktop extent * 0.75 / self originalBitmapExtent.
	^(scale x min: scale y) min: 1!

defaultExtent
	^self background extent!

dismiss
	self topShell close!

dolphinInside
	^dolphinInside!

dolphinInsideBaseColor
	^ARGB 
		red: 1
		green: 1
		blue: 1!

dolphinInsideIntensityColor
	^ARGB 
		red: 215
		green: 109
		blue: 10!

dolphinInsideIntensityPeriod
	^1500!

dolphinInsideIntensityTime
	^7000!

dolphinMaxScale
	^0.4!

dolphinMinScale
	^0.3!

dolphinOutline
	^dolphinOutline 
		ifNil: 
			[dolphinOutline := GdiplusBitmap fromFile: 'Resources\DolphinOutline.png'
						usingLocator: FileLocator installRelative.
			self baseStyle = 1 
				ifFalse: [dolphinOutline := GdiplusBitmap fromImage: dolphinOutline scaledBy: self baseScale]]!

dolphins
	^dolphins!

drawInfoTextOn: graphics 
	| version copyright fontCopyright brush infoString |
	version := VMLibrary default versionInfo.
	copyright := version legalCopyright copyReplaceAll: '. ' with: String lineDelimiter.
	brush := GdiplusSolidBrush color: ARGB white.
	fontCopyright := GdiplusFont 
				name: 'Arial'
				emSize: 9
				style: nil
				unit: UnitPoint.
	infoString := copyright lines first , ', ' , copyright lines second , '.' , String lineDelimiter 
				, 'Dolphin ' , SessionManager current versionString 
				, ' is Open Source under the MIT License.'.
	SessionManager current bootInfo 
		ifNotNil: [:bootInfo | infoString := infoString , String lineDelimiter , 'Image boot info: ' , bootInfo].
	graphics
		textRenderingHint: TextRenderingHintAntiAlias;
		drawString: infoString
			font: fontCopyright
			at: (48 @ 630 * self baseScale) rounded
			format: GdiplusStringFormat near
			brush: brush!

elapsedTime
	"Answer the elapsed time in ms since the start of the animation"

	^TimeStamp current asMilliseconds - startTime asMilliseconds!

fill
	| dolphinPt |
	self model removeAll.

	"Render the Dolphin outline so we can fit out objects inside"
	self render.
	dolphinInside := (self randomFrom: self dolphins) copy.
	dolphinInside rotation: (self random next * 360) rounded.

	"Find a suitable position and scale for the dolphin inside"
	
	[dolphinPt := self randomFrom: self points.
	dolphinInside position: dolphinPt.
	(self 
		addInsideObject: dolphinInside
		minScale: self dolphinMinScale
		maxScale: self dolphinMaxScale) notNil 
		and: [dolphinInside scale >= self dolphinMinScale]] 
			whileFalse.

	"Now fill in the remaining objects inside"
	self points do: 
			[:pt | 
			| object |
			object := (self randomFrom: self objects) copy.
			object position: pt.
			object rotation: (self random next * 180) truncated - 90.
			self 
				addInsideObject: object
				minScale: self insideObjectMinScale
				maxScale: self insideObjectMaxScale].

	"Re-render to fill the Dolphin with objects of the correct scale"
	dolphinInside color: self dolphinInsideBaseColor.
	self render!

frameRate
	^25!

hasHintBubble
	^hintBubble notNil and: [hintBubble tooltip notNil]!

initialize
	super initialize.
	self backcolor: RGB white.
	insideObjectsScale := 0.1.
	dolphinIntensity := 0.
	self loadTextureMap: 'ObjectsInside'.
	self startStepProcess!

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
	^pixel = self dolphinInside color asARGB!

loadTextureMap: mapName 
	| textureFileName mapFileName texture map |
	textureFileName := 'Resources\' , (File default: mapName extension: 'png').
	texture := GdiplusBitmap fromFile: textureFileName usingLocator: FileLocator installRelative.
	mapFileName := 'Resources\' , (File default: mapName extension: 'txt').
	map := FileStream read: (FileLocator installRelative localFileSpecFor: mapFileName) text: true.
	textureMap := LookupTable new.
	(map contents subStrings: Character lf) do: 
			[:each | 
			| elements pos ext bm |
			elements := each subStrings: $,.
			pos := elements second trimBlanks asNumber @ elements third trimBlanks asNumber.
			ext := elements fourth trimBlanks asNumber @ elements fifth trimBlanks asNumber.
			bm := GdiplusBitmap fromImage: texture crop: (pos extent: ext).
			textureMap at: elements first put: (ObjectInside fromImage: bm scaledBy: self baseScale)].
	sun := textureMap removeKey: 'SeeingTheObjects.png'.
	dolphins := OrderedCollection new.
	dolphins
		add: (textureMap removeKey: 'Dolphin1.png');
		add: (textureMap removeKey: 'Dolphin2.png').
	objects := textureMap values.
	^textureMap!

objects
	^objects!

onDestroyed
	self stopStepProcess.
	^super onDestroyed!

onLeftButtonPressed: aMouseEvent 
	self render.
	self class splashPlayTheGame ifFalse: [^self dismiss].
	(self isActionPoint: aMouseEvent position) 
		ifTrue: 
			[Cursor reset.
			self dismiss]
		ifFalse: [self showHintBubble]!

onMouseMoved: aMouseEvent 
	| wantHandCursor |
	wantHandCursor := self isActionPoint: aMouseEvent position.
	^wantHandCursor 
		ifTrue: 
			[Cursor hand makeCurrent.
			nil]
		ifFalse: [super onMouseMoved: aMouseEvent]!

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
			[| extent mask |
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
							pt := ((self random next * 2 + x) @ (self random next * 2 + y)) rounded.
							((mask pixelAt: pt) alpha = 0 and: [self random next > 0.2]) ifTrue: [points add: pt]]].
			points]!

random
	^random ifNil: [random := Random new] !

randomFrom: anOrderedCollection 
	| index |
	index := (self random next * anOrderedCollection size) truncated + 1.
	^anOrderedCollection at: index!

render
	"Private - Render the background image"

	
	[| graphics |
	graphics := self graphics.
	graphics clear: ARGB white.
	self model do: 
			[:each |
			| existingScale |
			existingScale := each scale.
			each scale: existingScale * insideObjectsScale.
			each drawOn: graphics.
			each scale: existingScale].
	graphics
		drawImage: self background
		at: Point zero
		extent: self background extent.
	graphics
		drawImage: self dolphinOutline
		at: Point zero
		extent: self dolphinOutline extent.
	self sun
		ifNotNil: 
			[:sun |
			sun
				position: self sunPosition;
				drawOn: graphics].
	self drawInfoTextOn: graphics.
	super render]
			on: Error
			do: 
				[:ex |
				self stopStepProcess.
				ex pass]!

showHintBubble
	self hasHintBubble ifTrue: [^self].
	hintBubble := (MessageBubble new)
				caption: 'Hint';
				maxWidth: 140;
				willFade: true;
				timeout: 5000.
	hintBubble
		position: (self mapPoint: self sunPosition to: View desktop);
		notify: 'Find the dolphin inside and click to continue.'!

startStepProcess
	self stopStepProcess.
	startTime := TimeStamp current.
	stepProcess := 
			[
			[[self step] on: Error do: [:ex | ex toTrace].
			Processor sleep: 1000 // self frameRate] repeat]
					forkAt: Processor userBackgroundPriority!

step
	self sun rotation: self sun rotation - (1.3 * insideObjectsScale).
	dolphinIntensity > 0 ifTrue: [
		self dolphinInside color: (self dolphinInsideIntensityColor intensity: dolphinIntensity)].
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

stepProcess
	^stepProcess!

stopStepProcess
	stepProcess 
		ifNotNil: 
			[stepProcess terminate.
			stepProcess := nil]!

sun
	^sun!

sunPosition
	^(612 @ 98) * self baseScale!

textureMap
	^textureMap
! !
!SeeingTheObjectsInside categoriesFor: #addInsideObject:minScale:maxScale:!private! !
!SeeingTheObjectsInside categoriesFor: #background!accessing!private! !
!SeeingTheObjectsInside categoriesFor: #baseScale!constants!public! !
!SeeingTheObjectsInside categoriesFor: #defaultExtent!accessing!private! !
!SeeingTheObjectsInside categoriesFor: #dismiss!event handling!private! !
!SeeingTheObjectsInside categoriesFor: #dolphinInside!accessing!public! !
!SeeingTheObjectsInside categoriesFor: #dolphinInsideBaseColor!constants!public! !
!SeeingTheObjectsInside categoriesFor: #dolphinInsideIntensityColor!constants!public! !
!SeeingTheObjectsInside categoriesFor: #dolphinInsideIntensityPeriod!constants!operations!public! !
!SeeingTheObjectsInside categoriesFor: #dolphinInsideIntensityTime!constants!operations!public! !
!SeeingTheObjectsInside categoriesFor: #dolphinMaxScale!public! !
!SeeingTheObjectsInside categoriesFor: #dolphinMinScale!public! !
!SeeingTheObjectsInside categoriesFor: #dolphinOutline!accessing!private! !
!SeeingTheObjectsInside categoriesFor: #dolphins!accessing!private! !
!SeeingTheObjectsInside categoriesFor: #drawInfoTextOn:!operations!private! !
!SeeingTheObjectsInside categoriesFor: #elapsedTime!operations!public! !
!SeeingTheObjectsInside categoriesFor: #fill!event handling!private! !
!SeeingTheObjectsInside categoriesFor: #frameRate!constants!public! !
!SeeingTheObjectsInside categoriesFor: #hasHintBubble!event handling!private!testing! !
!SeeingTheObjectsInside categoriesFor: #initialize!initializing!private! !
!SeeingTheObjectsInside categoriesFor: #insideObjectMaxScale!constants!public! !
!SeeingTheObjectsInside categoriesFor: #insideObjectMinScale!constants!public! !
!SeeingTheObjectsInside categoriesFor: #insideObjectScaleInPeriod!constants!operations!public! !
!SeeingTheObjectsInside categoriesFor: #isActionPoint:!event handling!private! !
!SeeingTheObjectsInside categoriesFor: #isPointInDolphin:!event handling!private!testing! !
!SeeingTheObjectsInside categoriesFor: #loadTextureMap:!accessing!private! !
!SeeingTheObjectsInside categoriesFor: #objects!accessing!private! !
!SeeingTheObjectsInside categoriesFor: #onDestroyed!event handling!private! !
!SeeingTheObjectsInside categoriesFor: #onLeftButtonPressed:!event handling!private! !
!SeeingTheObjectsInside categoriesFor: #onMouseMoved:!event handling!private! !
!SeeingTheObjectsInside categoriesFor: #onViewCreated!event handling!private! !
!SeeingTheObjectsInside categoriesFor: #originalBitmapExtent!constants!public! !
!SeeingTheObjectsInside categoriesFor: #pointResolution!constants!public! !
!SeeingTheObjectsInside categoriesFor: #points!accessing!private! !
!SeeingTheObjectsInside categoriesFor: #random!operations!private! !
!SeeingTheObjectsInside categoriesFor: #randomFrom:!private! !
!SeeingTheObjectsInside categoriesFor: #render!operations!private! !
!SeeingTheObjectsInside categoriesFor: #showHintBubble!private! !
!SeeingTheObjectsInside categoriesFor: #startStepProcess!initializing!private! !
!SeeingTheObjectsInside categoriesFor: #step!operations!public! !
!SeeingTheObjectsInside categoriesFor: #stepDolphinInsideIntensity!operations!private! !
!SeeingTheObjectsInside categoriesFor: #stepInsideObjectsScale!operations!private! !
!SeeingTheObjectsInside categoriesFor: #stepProcess!accessing!private! !
!SeeingTheObjectsInside categoriesFor: #stopStepProcess!initializing!private! !
!SeeingTheObjectsInside categoriesFor: #sun!private! !
!SeeingTheObjectsInside categoriesFor: #sunPosition!constants!public! !
!SeeingTheObjectsInside categoriesFor: #textureMap!accessing!private! !

!SeeingTheObjectsInside class methodsFor!

canDisplay
	"Answer true if an instance of the receiver can be correctly displayed"

	"Displays of less than 800x600 resolution or with a palette cannot correctly display the Dolphin
	splash bitmap. Also Win95/NT can't do the alpha blending thing."

	| desktopCanvas |
	desktopCanvas := Canvas forDesktop.
	^(desktopCanvas colorDepth > 8 and: [desktopCanvas extent >= (800 @ 600)]) 
		and: [SystemMetrics current supportsAlphaBlending]!

splashPlayTheGame
	^splashPlayTheGame ifNil: [splashPlayTheGame := true]!

splashPlayTheGame: aBoolean 
	splashPlayTheGame := aBoolean! !
!SeeingTheObjectsInside class categoriesFor: #canDisplay!accessing!public! !
!SeeingTheObjectsInside class categoriesFor: #splashPlayTheGame!public! !
!SeeingTheObjectsInside class categoriesFor: #splashPlayTheGame:!public! !

