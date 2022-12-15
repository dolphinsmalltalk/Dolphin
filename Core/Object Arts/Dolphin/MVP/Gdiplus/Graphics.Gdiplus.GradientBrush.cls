"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.TransformableBrush subclass: #'Graphics.Gdiplus.GradientBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GradientBrush guid: (Core.GUID fromString: '{c78eff10-fc9d-4e62-958e-26094c5f4d38}')!
Graphics.Gdiplus.GradientBrush isNonInstantiable: true!
Graphics.Gdiplus.GradientBrush comment: ''!
!Graphics.Gdiplus.GradientBrush methodsFor!

blend
	^initializer getBlend: self handle!

blend: aPathGradientBlend
	initializer blend: self handle set: aPathGradientBlend!

blendBellShape: focusReal
	self blendBellShape: focusReal scale: 1!

blendBellShape: focusReal scale: scaleReal
	initializer
		blendSigma: self handle
		focus: focusReal
		scale: scaleReal!

blendColors: colorsArray positions: positionsArray
	"Set the preset colors and the blend positions of this path gradient brush.  colorsArray
	specifies the interpolation colors for the gradient. Each color in colorsArray 
	corresponds to a blend position in positionsArray.  Each blend position is a number from
	 0 through 1, where 0 indicates the boundary of the gradient and 1 indicates the center point. 
	A blend position between 0 and 1 specifies the set of all points that are a certain fraction of 
	the distance from the boundary to the center point. For example, a blend position of 0.7 
	specifies the set of all points that are 70 percent of the way from the boundary to the center point."

	self assert: [colorsArray size = positionsArray size].
	self blend: (GradientPresetBlend colors: colorsArray positions: positionsArray)!

blendColorsCount
	"Answer the <Integer> number of preset colors currently set for the receiver."

	^initializer presetBlendCountGet: self handle!

blendFactors: factorsArray positions: positionsArray
	self blend: (GradientCustomBlend factors: factorsArray positions: positionsArray)!

blendFactorsCount
	"Answer the <Integer> number of blend factors currently set for the receiver."

	^initializer blendCountGet: self handle!

blendTriangularShape: focusReal
	self blendTriangularShape: focusReal scale: 1!

blendTriangularShape: focusReal scale: scaleReal
	initializer
		blendLinear: self handle
		focus: focusReal
		scale: scaleReal!

bounds
	"Answer a bounding <Rectangle> for the receiver."

	^initializer getRectangle: self handle!

isGammaCorrected
	"Answer whether gamma correction is applied to the receiver when rendering."

	^initializer isGammaCorrected!

isGammaCorrected: aBoolean
	"Set whether gamma correction is applied to the receiver when rendering."

	initializer gammaCorrection: self handle set: aBoolean! !
!Graphics.Gdiplus.GradientBrush categoriesForMethods!
blend!attributes!public! !
blend:!attributes!public! !
blendBellShape:!operations!public! !
blendBellShape:scale:!operations!public! !
blendColors:positions:!accessing!operations!public! !
blendColorsCount!accessing!public! !
blendFactors:positions:!accessing!public! !
blendFactorsCount!accessing!public! !
blendTriangularShape:!operations!public! !
blendTriangularShape:scale:!accessing!public! !
bounds!accessing!public! !
isGammaCorrected!accessing!public! !
isGammaCorrected:!accessing!public! !
!

