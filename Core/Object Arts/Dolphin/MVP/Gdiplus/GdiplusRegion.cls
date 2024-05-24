"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusRegion
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusRegion guid: (GUID fromString: '{148916f7-d5f7-4aea-a739-3e4ba82692ac}')!

GdiplusRegion comment: 'An instance of GdiplusRegion describes an area of the display surface. The area can be any shape, i.e., the boundary of the area can be a combination of curved and straight lines. Regions can also be created from the interiors of rectangles, paths, or a combination of these. Regions are used in clipping and hit-testing operations.'!

!GdiplusRegion categoriesForClass!Unclassified! !

!GdiplusRegion methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteRegion: handle!

bounds: graphics
	| rect |
	rect := GpRect newBuffer.
	GdiplusLibrary default
		gdipGetRegionBoundsI: self asParameter
		graphics: graphics asParameter
		rect: rect.
	^rect asRectangle!

clone
	"Answer a copy of the receiver."

	| gpHandle |
	gpHandle := ExternalHandle new.
	GdiplusLibrary default gdipCloneRegion: self asParameter cloneRegion: gpHandle.
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

combinePath: aPath mode: aCombineModeConstant
	GdiplusLibrary default
		gdipCombineRegionPath: self asParameter
		path: aPath asParameter
		combineMode: aCombineModeConstant!

combineRectangle: aRectangle mode: aCombineModeConstant
	GdiplusLibrary default
		gdipCombineRegionRectI: self asParameter
		rect: (GpRect marshal: aRectangle)
		combineMode: aCombineModeConstant!

combineRegion: aRegion mode: aCombineModeConstant
	GdiplusLibrary default
		gdipCombineRegionRegion: self asParameter
		region2: aRegion asParameter
		combineMode: aCombineModeConstant!

complementPath: aPath
	self combinePath: aPath mode: CombineModeComplement!

complementRegion: aRegion
	self combineRegion: aRegion mode: CombineModeComplement!

intersectRegion: aRegion
	self combineRegion: aRegion mode: CombineModeIntersect!

isEmpty
	^self isEmpty: nil!

isEmpty: aGdiplusGraphics
	| result graphics |
	result := ByteArray newFixed: 4.
	graphics := aGdiplusGraphics ifNil: [GdiplusGraphics fromCanvas: View desktop canvas].
	GdiplusLibrary default
		gdipIsEmptyRegion: self asParameter
		graphics: graphics asParameter
		result: result.
	^(result sdwordAtOffset: 0) ~~ 0!

isVisible: aPoint
	"Answer whether aPoint is inside the receiver."

	^self isVisible: aPoint graphics: nil!

isVisible: aPoint graphics: aGraphics
	"Answer whether aPoint is inside the receiver, where aGraphics contains the world and page
	transformations required to calculate the device coordinates of the receiver and aPoint."

	| result |
	result := SDWORD new.
	GdiplusLibrary default
		gdipIsVisibleRegionPointI: self asParameter
		x: aPoint x
		y: aPoint y
		graphics: aGraphics asParameter
		result: result.
	^result ~= 0!

makeEmpty
	"Update the receiver to an empty region, i.e., so that it occupies no space on the display device."

	GdiplusLibrary default gdipSetEmpty: self asParameter!

makeInfinite
	"Update the receiver to an infinite region, i.e., so that it occupies all the space on the display device."

	GdiplusLibrary default gdipSetInfinite: self asParameter!

unionRegion: aRegion
	self combineRegion: aRegion mode: CombineModeUnion!

xorRegion: aRegion
	"Update the receiver to the nonintersecting portions of itself and aRegion."

	self combineRegion: aRegion mode: CombineModeXor! !

!GdiplusRegion categoriesForMethods!
basicFree!private!realizing/unrealizing! !
bounds:!accessing!public! !
clone!copying!public! !
combinePath:mode:!operations!public! !
combineRectangle:mode:!operations!public! !
combineRegion:mode:!operations!public! !
complementPath:!helpers!public! !
complementRegion:!helpers!public! !
intersectRegion:!helpers!public! !
isEmpty!public!testing! !
isEmpty:!public!testing! !
isVisible:!public!testing! !
isVisible:graphics:!public!testing! !
makeEmpty!operations!public! !
makeInfinite!operations!public! !
unionRegion:!helpers!public! !
xorRegion:!helpers!public! !
!

!GdiplusRegion class methodsFor!

fromPath: aPath
	^self fromInitializer: (GdiplusRegionFromPathInitializer fromPath: aPath)!

fromRectangle: aRectangle
	^self fromInitializer: (GdiplusRegionFromRectangleInitializer fromRectangle: aRectangle)!

new
	"Answer an instance of the receiver that is infinite."

	^self fromInitializer: GdiplusRegionInitializer default! !

!GdiplusRegion class categoriesForMethods!
fromPath:!instance creation!public! !
fromRectangle:!instance creation!public! !
new!instance creation!public! !
!

