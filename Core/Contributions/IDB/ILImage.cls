"Filed out from Dolphin Smalltalk"!

Object subclass: #ILImage
	instanceVariableNames: 'extent colorsUsed colorsUsedCount image bitmapCache hotSpot'
	classVariableNames: 'TransparentRGB'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

ILImage guid: (GUID fromString: '{5402d9a6-19ee-41a2-8586-d104cd17118c}')!

ILImage comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILImage categoriesForClass!IDB Goodies! !

!ILImage methodsFor!

bitmapCache
	"Answer s bitmap with the colors from the receiver drawn onto it. As this is
	expensive we cache this - it will only change during editing"

	| canvas |
	bitmapCache notNil ifTrue: [^bitmapCache].

	"Make it compatible with the desktop as we don't care about the colors it actually displays"
	bitmapCache := Bitmap displayCompatibleWithExtent: self extent.
	canvas := bitmapCache canvas.

	"If the image contains a reference to a transparent point we insert the current transparent
	color (usually set to match the background) otherwise the actual color"
	self pixelPoints do: 
			[:each |
			canvas pixelAt: each - 1
				put: ((self isTransparentAt: each)
						ifTrue: 
							["need 0 based for the bitmap"
							self class transparentRGB]
						ifFalse: [self getRGBAt: each])].
	^bitmapCache!

clearBitmapCache
	bitmapCache := nil!

colorsUsed
	"Answer a Bag containing the colorsUsed and the count for each, ignoring those 
	with a count of 0 and the transparent color"

	| bag |
	bag := Bag new.
	colorsUsedCount keysAndValuesDo: 
			[:index :count | 
			index = self transparentColorIndex | count isZero 
				ifFalse: [bag add: (self rgbFor: index) withOccurrences: count]].
	^bag!

countColorsUsed
	"Answer the number of colours used in this image
		Always include black and white (index 1 and 2) even if the aren't used
		Always exclude transparent (index 3) even if it is used"

	^2 + ((colorsUsedCount copyFrom: 4) inject: 0 into: [:sum :each | sum + each sign])!

defaultColor
	^Color darkGray!

drawBitmapOn: aCanvas at: aPoint
	aCanvas 
		drawBitmap: self bitmapCache
		at: aPoint
		extent: extent
		from: Point zero
		extent: extent
		rop: SRCCOPY!

editingImage
	"Answer an ILEditingImage which is a copy of the receiver suitable for editing"

	^(ILEditingImage extent: extent colors: (image collect: [:each | self rgbFor: each]))
		hotSpot: self hotSpot;
		yourself!

extent
	^extent!

getRGBAt: aPoint
	"Answers the RGB value at aPoint in the image"

	^self rgbFor: (self imageAt: aPoint)!

height
	^extent y!

hotSpot
	^hotSpot!

hotSpot: aPointOrNil
	hotSpot := aPointOrNil!

imageAt: aPoint
	"Answers the index of the color at aPoint in the image"

	^image at: (self offsetFor: aPoint)!

imageAt: aPoint put: anInteger
	"Puts a color indexat aPoint in the image"

	^image at: (self offsetFor: aPoint) put: anInteger!

imageDescription
	^(String writeStream)
		space;
		print: self width;
		nextPut: $x;
		print: self height;
		nextPutAll: '   Col:';
		print: self countColorsUsed;
		nextPutAll: '   HS:';
		display: hotSpot;
		contents!

indexFor: anRGB
	"Answers the index used for anRGB, creating a new one if needed"

	| index |
	(index := colorsUsed indexOf: anRGB) isZero ifFalse: [^index].
	self assert: [colorsUsed size < 255].
	colorsUsed add: anRGB.
	colorsUsedCount add: 0.
	^colorsUsed size	"= the index of the anRGB"!

isTransparentAt: aPoint
	"Answers true if the pixel at aPoint representes the fixed transparent color"

	^(self imageAt: aPoint) = self transparentColorIndex!

offsetFor: aPoint
	"Answers the offset into the image array for aPoint"

	^(aPoint y - 1) * self width + aPoint x!

pixelCount
	^self width * self height!

pixelPoints
	^self pixelPoints: (Point one corner: extent)!

pixelPoints: aRectangle
	| pixels |
	pixels := OrderedCollection new: aRectangle width * aRectangle height.
	aRectangle left to: aRectangle right
		do: [:across | aRectangle top to: aRectangle bottom do: [:down | pixels add: across @ down]].
	^pixels!

putRGB: anRGB at: aPoint
	"Puts the RGB value at aPoint in the image. Update the collection
	used to maintain the running count of colors used"

	| oldIndex newIndex |
	oldIndex := self imageAt: aPoint.
	newIndex := self indexFor: anRGB.
	oldIndex = newIndex 
		ifFalse: 
			[colorsUsedCount at: oldIndex put: (colorsUsedCount at: oldIndex) - 1.
			colorsUsedCount at: newIndex put: (colorsUsedCount at: newIndex) + 1.
			self imageAt: aPoint put: (self indexFor: anRGB).
			self trigger: #imageDescriptionChanged]!

rectangle
	^Point one corner: extent!

rgbFor: anInteger
	"Answers the RGB represented by anInteger"

	^colorsUsed at: anInteger!

setExtent: aPoint
	extent := aPoint.

	"Each image must always containg the following three colors and they
	must be placed in the colorsUsed collection in this order"
	colorsUsed := OrderedCollection 
				with: Color black
				with: Color white
				with: Color dolphinYellow
				with: self defaultColor.

	"We are also going to add this very shortly, so include it here"

	"We keep a running count of the number of times each color is used - see below for last"
	colorsUsedCount := OrderedCollection 
				with: 0
				with: 0
				with: 0
				with: self pixelCount.

	"Create the table and populate it with each pixel set to the defaultColor. Use the index of 
	the color in the above table rather than the color itself"
	image := (Array new: self pixelCount) atAllPut: (colorsUsed indexOf: self defaultColor)!

setExtent: aPoint colors: anArray
	"Initialize the receiver and then add the RGB values form anArray. We have to convert from
	RGB values in the anArray to colours that we know are in our colour table, but we
	can get Windows to do this for us by using a bitmap"

	| converter canvas |
	self setExtent: aPoint.
	converter := DeviceIndependentBitmap 
				width: self width
				height: self height
				depth: 8.	"Will use out standard 8 bit colour table"
	converter setMap3DColors: false.
	canvas := converter canvas.
	self pixelPoints do: 
			[:each | 
			| color |
			color := anArray at: (each y - 1) * self width + each x.
			color = self transparentColor 
				ifFalse: 
					[canvas pixelAt: each - 1 put: color.
					color := canvas pixelAt: each - 1].
			self putRGB: color at: each]!

transparentColor
	^colorsUsed at: self transparentColorIndex!

transparentColorIndex
	"Answers the index of the fixed color used to represent transparency in the image
	Always in position 3 of the collection set in #setExtent"

	^3!

width
	^extent x! !

!ILImage categoriesForMethods!
bitmapCache!accessing!public! !
clearBitmapCache!helpers!public! !
colorsUsed!helpers!public! !
countColorsUsed!helpers!public! !
defaultColor!constants!public! !
drawBitmapOn:at:!operations!public! !
editingImage!converting!public! !
extent!accessing!public! !
getRGBAt:!accessing!public! !
height!accessing!public! !
hotSpot!accessing!public! !
hotSpot:!accessing!public! !
imageAt:!accessing!public! !
imageAt:put:!accessing!public! !
imageDescription!displaying!public! !
indexFor:!accessing!public! !
isTransparentAt:!public!testing! !
offsetFor:!helpers!public! !
pixelCount!initializing!public! !
pixelPoints!helpers!public! !
pixelPoints:!helpers!public! !
putRGB:at:!accessing!public! !
rectangle!helpers!public! !
rgbFor:!accessing!public! !
setExtent:!initializing!public! !
setExtent:colors:!initializing!public! !
transparentColor!accessing!public! !
transparentColorIndex!constants!public! !
width!accessing!public! !
!

!ILImage class methodsFor!

defaultTransparentRGB
	^Color white!

extent: aPoint
	^self new setExtent: aPoint!

extent: aPoint colors: anArray
	"Creates a new instance and initializes it with the RGB values in anArray"

	^self new setExtent: aPoint colors: anArray!

transparentRGB
	"Answer the RGB used to represent transparency on the current display.
	Dynamically changed to match the current background color"

	TransparentRGB isNil ifTrue: [TransparentRGB := self defaultTransparentRGB].
	^TransparentRGB!

transparentRGB: anRGB
	"Set the RGB used to represent transparency on the current display.
	Dynamically changed to match the current background color"

	TransparentRGB := anRGB! !

!ILImage class categoriesForMethods!
defaultTransparentRGB!constants!public! !
extent:!instance creation!public! !
extent:colors:!instance creation!public! !
transparentRGB!accessing!public! !
transparentRGB:!accessing!public! !
!

