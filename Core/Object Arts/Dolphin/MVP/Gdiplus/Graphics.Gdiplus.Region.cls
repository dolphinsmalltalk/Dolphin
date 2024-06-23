"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase
	subclass: #'Graphics.Gdiplus.Region'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Region guid: (Core.GUID fromString: '{148916f7-d5f7-4aea-a739-3e4ba82692ac}')!

Graphics.Gdiplus.Region comment: 'An instance of GdiplusRegion describes an area of the display surface. The area can be any shape, i.e., the boundary of the area can be a combination of curved and straight lines. Regions can also be created from the interiors of rectangles, paths, or a combination of these. Regions are used in clipping and hit-testing operations.'!

!Graphics.Gdiplus.Region methodsFor!

_clipGpGraphics: aGpGraphics mode: anInteger
	aGpGraphics clipRegion: self combineMode: anInteger!

_combineGpRegion: aGdiplusRegion mode: aCombineModeConstant
	^aGdiplusRegion combineRegion: self mode: aCombineModeConstant!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	"Note that we don't use #isEqualRegion: here, because that will consider regions constructed differently but that represent the same area to be equivalent. Whilst that would be useful behaviour, there is no obvious way to implement a #hash function that is consistent with that."

	self == anObject ifTrue: [^true].
	^self class == anObject class and: [self data = anObject data]!

bounds: aGdiplusGraphics
	| rect |
	rect := Rect newBuffer.
	Gdip
		gdipGetRegionBoundsI: self asParameter
		graphics: aGdiplusGraphics asParameter
		rect: rect.
	^rect asRectangle!

clone
	"Answer a copy of the receiver."

	^super clone
		initializer: initializer copy;
		yourself!

combinePath: aPath mode: aCombineModeConstant
	"Private - Warning: Updates in place"

	Gdip
		gdipCombineRegionPath: self asParameter
		path: aPath asParameter
		combineMode: aCombineModeConstant.
	initializer := nil!

combineRectangle: aRectangle mode: aCombineModeConstant
	"Private - Warning: Updates in place"

	Gdip
		gdipCombineRegionRectI: self asParameter
		rect: (Rect marshal: aRectangle)
		combineMode: aCombineModeConstant.
	initializer := nil!

combineRegion: aRegion mode: aCombineModeConstant
	"Private - Warning: Updates in place"

	Gdip
		gdipCombineRegionRegion: self asParameter
		region2: aRegion asParameter
		combineMode: aCombineModeConstant.
	initializer := nil!

complement: aGdiplusRegionOrRectangleOrGraphicsPath
	"Answer a new <Region> representing the area of the argument which does not overlap with the receiver's area (i.e. this not subtracting the argument from the receiver, rather the other way around, which might not be quite what you were expecting)."

	^aGdiplusRegionOrRectangleOrGraphicsPath _combineGpRegion: self clone mode: CombineModeComplement!

containsPoint: aPoint
	"Answer whether the <Point> argument is contained by the receiver."

	^self containsPoint: aPoint graphics: nil!

containsPoint: aPoint graphics: aGraphics
	"Answer whether <Point> first argument is inside the receiver, where the <Graphics> second argument contains the world and page transformations required to calculate the device coordinates of the receiver and the Point."

	| result |
	result := UInt32Bytes new.
	Gdip
		gdipIsVisibleRegionPointI: self asParameter
		x: aPoint x
		y: aPoint y
		graphics: aGraphics asParameter
		result: result.
	^result asBoolean!

data
	"Answer the binary data for this Region. Can be used to reconstruct a copy."

	^self initializer getRegionData: self!

exclude: aGdiplusRegionOrRectangleOrGraphicsPath
	"Answers a new <Region> representing the area of the receiver which is not also covered by the argument."

	^aGdiplusRegionOrRectangleOrGraphicsPath _combineGpRegion: self clone mode: CombineModeExclude!

hash
	^self initializer hashGet: self!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^RegionFromDataInitializer!

intersection: aGdiplusRegionOrRectangleOrGraphicsPath
	"Answer a new <Region> representing the area in which the receiver and argument overlap."

	^aGdiplusRegionOrRectangleOrGraphicsPath _combineGpRegion: self clone mode: CombineModeIntersect!

isEmpty
	"Answer whether the region is empty."

	^self isEmpty: nil!

isEmpty: aGdiplusGraphics
	"Answer whether the region is empty for the specified <Griplus.Graphics>"

	^self initializer isEmptyRegion: self onGraphics: aGdiplusGraphics!

isEqualRegion: aGdiplusRegion
	^self isEqualRegion: aGdiplusRegion ofGraphics: GdiplusGraphics desktop!

isEqualRegion: aGdiplusRegion ofGraphics: aGdiplusGraphics
	| bool |
	bool := UInt32Bytes new.
	Gdip
		gdipIsEqualRegion: self handle
		region2: aGdiplusRegion asParameter
		graphics: aGdiplusGraphics asParameter
		result: bool.
	^bool asBoolean!

isInfinite
	"Answer whether the region is effectively infinite."

	^self isInfinite: nil!

isInfinite: aGdiplusGraphics
	"Answer whether the region is effectively infinite for the specified <Griplus.Graphics>"

	^self initializer isInfiniteRegion: self onGraphics: aGdiplusGraphics!

makeEmpty
	"Update the receiver to an empty region, i.e., so that it occupies no space on the display device."

	Gdip gdipSetEmpty: self handle.
	initializer := RegionInitializer empty!

makeInfinite
	"Update the receiver to an infinite region, i.e., so that it occupies all the space on the display device."

	Gdip gdipSetInfinite: self handle.
	initializer := RegionInitializer infinite!

union: aGdiplusRegionOrRectangleOrGraphicsPath
	"Answer a new <Region> representing the combined areas of the receiver and the argument."

	^aGdiplusRegionOrRectangleOrGraphicsPath _combineGpRegion: self clone mode: CombineModeUnion!

xor: aGdiplusRegionOrRectangleOrGraphicsPath
	"Answers a new <Region> representing the area of the receiver which is covered by the receiver or the argument but not both."

	^aGdiplusRegionOrRectangleOrGraphicsPath _combineGpRegion: self clone mode: CombineModeXor! !

!Graphics.Gdiplus.Region categoriesForMethods!
_clipGpGraphics:mode:!double dispatch!private! !
_combineGpRegion:mode:!combining!double dispatch!private! !
=!comparing!public! !
bounds:!accessing!public! !
clone!copying!public! !
combinePath:mode:!combining!private! !
combineRectangle:mode:!combining!private! !
combineRegion:mode:!combining!private! !
complement:!combining!public! !
containsPoint:!public!testing! !
containsPoint:graphics:!public!testing! !
data!accessing!public! !
exclude:!combining!public! !
hash!comparing!public! !
initializerClass!constants!private!realizing/unrealizing! !
intersection:!combining!public! !
isEmpty!public!testing! !
isEmpty:!public!testing! !
isEqualRegion:!comparing!public! !
isEqualRegion:ofGraphics:!comparing!public! !
isInfinite!public!testing! !
isInfinite:!public!testing! !
makeEmpty!operations!public! !
makeInfinite!operations!public! !
union:!combining!public! !
xor:!combining!public! !
!

!Graphics.Gdiplus.Region class methodsFor!

empty
	^self fromInitializer: RegionInitializer empty!

fromPath: aPath
	^self fromInitializer: (RegionFromPathInitializer fromPath: aPath)!

fromRectangle: aRectangle
	^self fromInitializer: (RegionFromRectangleInitializer fromRectangle: aRectangle)!

infinite
	^self new!

new
	"Answer an instance of the receiver that is infinite."

	^self fromInitializer: RegionInitializer infinite! !

!Graphics.Gdiplus.Region class categoriesForMethods!
empty!instance creation!public! !
fromPath:!instance creation!public! !
fromRectangle:!instance creation!public! !
infinite!instance creation!public! !
new!instance creation!public! !
!

