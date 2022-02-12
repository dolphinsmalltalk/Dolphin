"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.Region'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Region guid: (Core.GUID fromString: '{148916f7-d5f7-4aea-a739-3e4ba82692ac}')!
Graphics.Gdiplus.Region comment: 'An instance of GdiplusRegion describes an area of the display surface. The area can be any shape, i.e., the boundary of the area can be a combination of curved and straight lines. Regions can also be created from the interiors of rectangles, paths, or a combination of these. Regions are used in clipping and hit-testing operations.'!
!Graphics.Gdiplus.Region categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Region methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	Gdip gdipDeleteRegion: handle!

bounds: graphics
	| rect |
	rect := RECTL newBuffer.
	Gdip
		gdipGetRegionBoundsI: self asParameter
		graphics: graphics asParameter
		rect: rect.
	^rect asRectangle!

clone
	"Answer a copy of the receiver."

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCloneRegion: self asParameter cloneRegion: gpHandle.
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

combinePath: aPath mode: aCombineModeConstant
	Gdip
		gdipCombineRegionPath: self asParameter
		path: aPath asParameter
		combineMode: aCombineModeConstant!

combineRectangle: aRectangle mode: aCombineModeConstant
	Gdip
		gdipCombineRegionRectI: self asParameter
		rect: aRectangle asParameter
		combineMode: aCombineModeConstant!

combineRegion: aRegion mode: aCombineModeConstant
	Gdip
		gdipCombineRegionRegion: self asParameter
		region2: aRegion asParameter
		combineMode: aCombineModeConstant!

complementPath: aPath
	self combinePath: aPath mode: CombineModeComplement!

complementRegion: aRegion
	self combineRegion: aRegion mode: CombineModeComplement!

intersectRegion: aRegion
	self combineRegion: aRegion mode: CombineModeIntersect!

isVisible: aPoint
	"Answer whether aPoint is inside the receiver."

	^self isVisible: aPoint graphics: nil!

isVisible: aPoint graphics: aGraphics
	"Answer whether aPoint is inside the receiver, where aGraphics contains the world and page
	transformations required to calculate the device coordinates of the receiver and aPoint."

	| result |
	result := ByteArray newFixed: 4.
	Gdip
		gdipIsVisibleRegionPointI: self asParameter
		x: aPoint x
		y: aPoint y
		graphics: aGraphics asParameter
		result: result.
	^(result sdwordAtOffset: 0) ~= 0!

makeEmpty
	"Update the receiver to an empty region, i.e., so that it occupies no space on the display device."

	Gdip gdipSetEmpty: self asParameter!

makeInfinite
	"Update the receiver to an infinite region, i.e., so that it occupies all the space on the display device."

	Gdip gdipSetInfinite: self asParameter!

unionRegion: aRegion
	self combineRegion: aRegion mode: CombineModeUnion!

xorRegion: aRegion
	"Update the receiver to the nonintersecting portions of itself and aRegion."

	self combineRegion: aRegion mode: CombineModeXor! !
!Graphics.Gdiplus.Region categoriesForMethods!
basicFree!private!realizing/unrealizing! !
bounds:!accessing!public! !
clone!copying!public! !
combinePath:mode:!operations!public! !
combineRectangle:mode:!operations!public! !
combineRegion:mode:!operations!public! !
complementPath:!helpers!public! !
complementRegion:!helpers!public! !
intersectRegion:!helpers!public! !
isVisible:!public!testing! !
isVisible:graphics:!public!testing! !
makeEmpty!operations!public! !
makeInfinite!operations!public! !
unionRegion:!helpers!public! !
xorRegion:!helpers!public! !
!

!Graphics.Gdiplus.Region class methodsFor!

exampleClippingSimple
	"Private - Why is the region twice the width of the rectangle?
	LAS: Good question - seems to be some sort of scaling going on relative to Point zero.

		self exampleClippingSimple showExample
	"

	| bitmap graphics brush rect1 region1 |
	bitmap := Bitmap extent: 350 @ 350.
	graphics := bitmap graphics.
	brush := SolidBrush color: Color blue.
	rect1 := 100 @ 50 extent: 50 @ 150.
	region1 := Region fromRectangle: rect1.
	region1 handle.
	graphics
		fillRegion: region1 brush: brush;
		drawRectangle: rect1 pen: Pen black.
	^bitmap!

exampleClippingSimple2
	"Private - If a transform is applied, then it looks right.  Not sure why.

		self exampleClippingSimple2 showExample
	"

	| bitmap brush rect1 region1 |
	bitmap := Bitmap extent: 350 @ 350.
	brush := SolidBrush color: Color blue.
	rect1 := 0 @ 0 extent: 50 @ 150.
	region1 := Region fromRectangle: rect1.
	bitmap graphics
		translateTransform: 100 @ 50 order: nil;
		fillRegion: region1 brush: brush;
		drawRectangle: (Point zero extent: rect1 extent) pen: Pen black.
	^bitmap!

exampleGdipRClipWithRegion
	"MSDN:   GDI+ >  Using GDI+ >  Using Regions > Clipping with a Region

		self exampleGdipRClipWithRegion showExample
	"

	| bitmap graphics path region pen fontFamily font brush |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	path := Path new.
	path addPolygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}.
	region := Region fromPath: path.
	pen := Pen black.
	graphics drawPath: path pen: pen.
	graphics clipRegion: region combineMode: nil.
	fontFamily := FontFamily fromName: 'Arial'.
	font := Font
				fontFamily: fontFamily
				emSize: 36
				style: FontStyleBold
				unit: UnitPixel.
	brush := SolidBrush red.
	graphics
		drawString: 'A Clipping Region'
		font: font
		at: 15 @ 15
		format: nil
		brush: brush.
	graphics
		drawString: 'A Clipping Region'
		font: font
		at: 15 @ 68
		format: nil
		brush: brush.
	^bitmap!

exampleGdipRHitTesting
	"NB:  This example still does not work right.  Quite a puzzle.
	MSDN:  GDI+ >  Using GDI+ >  Using Regions > Hit Testing with a Region

		self exampleGdipRHitTesting
	"

	| bitmap graphics brush rect1 rect2 region1 region2 presenter onLeftButtonPressed |
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	brush := SolidBrush green.
	rect1 := 50 @ 0 extent: 50 @ 150.
	rect2 := 0 @ 50 extent: 150 @ 50.
	region1 := Region fromRectangle: rect1.
	region2 := Region fromRectangle: rect2.
	region1 unionRegion: region2.
	graphics fillRegion: region1 brush: brush.
	"Show in blue what region1's area should be."
	graphics fillRectangle: rect1 brush: SolidBrush blue.
	graphics fillRectangle: rect2 brush: SolidBrush blue.
	(presenter := UI.ImagePresenter show: 'Basic image' on: bitmap) view viewMode: #normal.
	onLeftButtonPressed := 
			[:aMouseEvent |
			(region1 isVisible: aMouseEvent x @ aMouseEvent y graphics: graphics)
				ifTrue: [brush color: Color green]
				ifFalse: [brush color: Color red].
			graphics fillRegion: region1 brush: brush.
			presenter view invalidate].
	presenter propertyAt: #clickHandler put: onLeftButtonPressed.
	presenter
		when: #leftButtonPressed:
		send: #value:
		to: onLeftButtonPressed!

fromPath: aPath
	^self fromInitializer: (RegionFromPathInitializer fromPath: aPath)!

fromRectangle: aRectangle
	^self fromInitializer: (RegionFromRectangleInitializer fromRectangle: aRectangle)!

new
	"Answer an instance of the receiver that is infinite."

	^self fromInitializer: RegionInitializer default! !
!Graphics.Gdiplus.Region class categoriesForMethods!
exampleClippingSimple!examples!private! !
exampleClippingSimple2!examples!private! !
exampleGdipRClipWithRegion!examples!public!sunit! !
exampleGdipRHitTesting!examples!public! !
fromPath:!instance creation!public! !
fromRectangle:!instance creation!public! !
new!instance creation!public! !
!

