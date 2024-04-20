"Filed out from Dolphin Smalltalk"!

GdiplusBrush subclass: #GdiplusLinearGradientBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusLinearGradientBrush guid: (GUID fromString: '{0ea671c7-823f-4367-89b3-c28e45a365ea}')!

GdiplusLinearGradientBrush comment: 'GdiplusLinearGradientBrush paints a color gradient in which the color changes evenly from the starting boundary line of an instance to its ending boundary line. Boundary lines are two parallel straight lines. The color gradient is perpendicular to the boundary lines, changing gradually across the stroke from starting to ending boundary lines. The color gradient has one color at the starting boundary line and another color at the ending boundary line.'!

!GdiplusLinearGradientBrush categoriesForClass!Unclassified! !

!GdiplusLinearGradientBrush methodsFor!

blendCount
	"Private - Answer the number of blend factors currently set for the receiver."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetLineBlendCount: self asParameter count: count) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetLineBlendCount failed' with: status].
	^count asInteger!

blendFactors
	"Answer a two-element array that holds two arrays that contain the receiver's blend factors 
	and their corresponding blend positions."

	| status count factorsArray positionsArray |
	count := self blendCount.
	factorsArray := FLOATArray new length: count.
	positionsArray := FLOATArray new length: count.
	status := GdiplusLibrary default 
				gdipGetLineBlend: self asParameter
				blend: factorsArray
				positions: positionsArray
				count: count.
	status = Ok ifFalse: [GdiplusError signal: 'GdipGetBlend failed' with: status].
	^Array with: factorsArray asArray with: positionsArray asArray!

blendFactors: factorsArray positions: positionsArray 
	"Set the receiver's blend factors and blend positions to create a custom blend."

	| status |
	self assert: [factorsArray size = positionsArray size].
	self assert: [positionsArray size >= 2].
	self assert: [factorsArray allSatisfy: [:each | each between: 0 and: 1]].
	self assert: [positionsArray first = 0 and: [positionsArray last = 1]].
	status := GdiplusLibrary default 
				gdipSetLineBlend: self asParameter
				blend: (FLOATArray withAll: factorsArray)
				positions: (FLOATArray withAll: positionsArray)
				count: positionsArray size.
	status = Ok ifFalse: [GdiplusError signal: 'GdipSetLineBlend failed' with: status]!

bounds
	| rect status |
	rect := GpRect newBuffer.
	(status := GdiplusLibrary default gdipGetLineRectI: self asParameter rect: rect) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetLineRectI: failed' with: status].
	^rect asRectangle!

colors
	^{self startingColor. self endingColor}!

endingColor
	^initializer color2!

isGammaCorrected
	"Answer whether gamma correction is applied to the receiver when rendering."

	| status result |
	result := SDWORD new.
	(status := GdiplusLibrary default gdipGetLineGammaCorrection: self asParameter
				useGammaCorrection: result) = Ok 
		ifFalse: [GdiplusError signal: 'GdipgetLineGammaCorrection failed' with: status].
	^result ~= 0!

isGammaCorrected: aBoolean 
	"Set whether gamma correction is applied to the receiver when rendering."

	| status |
	(status := GdiplusLibrary default gdipSetLineGammaCorrection: self asParameter
				useGammaCorrection: aBoolean asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetLineGammaCorrection failed' with: status]!

startingColor
	^initializer color1!

startingColor: startColor endingColor: endColor
	"Set the receiver's starting and ending colors."

	| status |
	(status := GdiplusLibrary default
				gdipSetLineColors: self asParameter
				color1: startColor argbCode
				color2: endColor argbCode) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetLineColors failed' with: status]!

wrapMode
	"Answer a number that indicates if and how painting is done outside the receiver's boundary path."

	^initializer wrapMode! !

!GdiplusLinearGradientBrush categoriesForMethods!
blendCount!accessing!private! !
blendFactors!accessing!public! !
blendFactors:positions:!accessing!public! !
bounds!accessing!public! !
colors!accessing!public! !
endingColor!accessing!public! !
isGammaCorrected!accessing!public! !
isGammaCorrected:!accessing!public! !
startingColor!accessing!public! !
startingColor:endingColor:!accessing!public! !
wrapMode!accessing!public! !
!

!GdiplusLinearGradientBrush class methodsFor!

point1: point1 point2: point2 color1: color1 color2: color2
	"Answer a LinearGradientBrush using a set of boundary points and boundary colors."

	^self fromInitializer: (GdiplusLinearGradientBrushFromPointsInitializer 
				point1: point1
				point2: point2
				color1: color1
				color2: color2)!

rect: rect color1: color1 color2: color2 mode: aLinearGradientMode
	"Answer a LinearGradientBrush using a set of boundary points and boundary colors."

	^self fromInitializer: (GdiplusLinearGradientBrushFromRectInitializer 
				rect: rect
				color1: color1
				color2: color2
				mode: aLinearGradientMode)! !

!GdiplusLinearGradientBrush class categoriesForMethods!
point1:point2:color1:color2:!instance creation!public! !
rect:color1:color2:mode:!instance creation!public! !
!

