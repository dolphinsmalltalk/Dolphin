"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.TransformableBrushInitializer subclass: #'Graphics.Gdiplus.GradientBrushInitializer'
	instanceVariableNames: 'isGammaCorrected blend'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GradientBrushInitializer guid: (Core.GUID fromString: '{2dfa061f-d6ec-4e72-8107-e321f348e352}')!
Graphics.Gdiplus.GradientBrushInitializer isNonInstantiable: true!
Graphics.Gdiplus.GradientBrushInitializer comment: ''!
!Graphics.Gdiplus.GradientBrushInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^super = anObject
		and: [self isGammaCorrected = anObject isGammaCorrected and: [blend = anObject blend]]!

applyAdditionalAttributes: aHandle
	super applyAdditionalAttributes: aHandle.
	isGammaCorrected ifNotNil: [self gdipSetGammaCorrection: aHandle value: isGammaCorrected].
	blend ifNotNil: [blend applyToGpObject: aHandle initializer: self]!

blend
	^blend!

blend: aGradientBlend
	blend := (aGradientBlend isNil or: [aGradientBlend isDefault]) ifFalse: [aGradientBlend].
	^aGradientBlend!

blend: aHandle set: aGradientBlend
	aGradientBlend applyToGpObject: aHandle initializer: self.
	self blend: aGradientBlend!

blendCountGet: aHandle
	| count |
	count := UInt32Bytes new.
	self gdipGetBlend: aHandle count: count.
	^count asSignedInteger!

blendGet: aHandle
	| count |
	count := self presetBlendCountGet: aHandle.
	^count == 0
		ifTrue: [self customBlendGet: aHandle]
		ifFalse: [self presetBlendGet: aHandle count: count]!

blendLinear: aHandle focus: focusReal scale: scaleReal
	self
		gdipLinearBlend: aHandle
		focus: focusReal
		scale: scaleReal.
	self blend: (self blendGet: aHandle)!

blendSigma: aHandle focus: focusReal scale: scaleReal
	self
		gdipSetSigmaBlend: aHandle
		focus: focusReal
		scale: scaleReal.
	self blend: (self blendGet: aHandle)!

customBlendGet: aHandle
	| positions factors count |
	count := self blendCountGet: aHandle.
	factors := FLOATArray new: count.
	positions := FLOATArray new: count.
	self
		gdipGetBlend: aHandle
		blend: factors
		positions: positions.
	^GradientCustomBlend factors: factors positions: positions!

gammaCorrection: aHandle set: aBoolean
	isGammaCorrected := aBoolean == true.
	self gdipSetGammaCorrection: aHandle value: aBoolean!

gdipGetBlend: aHandle blend: factors positions: positions
	self subclassResponsibility!

gdipGetBlend: aHandle count: aUInt32Bytes
	self subclassResponsibility!

gdipGetPresetBlend: aHandle blend: colors positions: positions
	self subclassResponsibility!

gdipGetPresetBlend: aHandle count: aUInt32Bytes 
	self subclassResponsibility!

gdipLinearBlend: aHandle focus: focusReal scale: scaleReal
	self subclassResponsibility!

gdipSetBlend: aHandle blend: factors positions: positions
	self subclassResponsibility!

gdipSetGammaCorrection: aHandle value: aBoolean
	self subclassResponsibility!

gdipSetPresetBlend: aHandle blend: colors positions: positions
	self subclassResponsibility!

gdipSetSigmaBlend: aHandle focus: focusReal scale: scaleReal
	self subclassResponsibility!

getBlend: aHandle
	^blend ifNil: [self blend: (self blendGet: aHandle)]!

getRectangle: aHandle
	^self subclassResponsibility!

hash
	"Answer the <integer> hash value for the receiver."

	^((super hash + self isGammaCorrected hash) hashMultiply + blend hash) hashMultiply!

isGammaCorrected
	^isGammaCorrected == true!

presetBlendCountGet: aHandle
	| count |
	count := UInt32Bytes new.
	self gdipGetPresetBlend: aHandle count: count.
	^count asSignedInteger!

presetBlendGet: aHandle count: count
	| positions colors |
	colors := ARGBArray new: count.
	positions := FLOATArray new: count.
	self
		gdipGetPresetBlend: aHandle
		blend: colors
		positions: positions.
	^GradientPresetBlend colors: colors positions: positions! !
!Graphics.Gdiplus.GradientBrushInitializer categoriesForMethods!
=!comparing!public! !
applyAdditionalAttributes:!private!realizing/unrealizing! !
blend!accessing!private! !
blend:!initializing!private! !
blend:set:!attributes!private! !
blendCountGet:!attributes!private! !
blendGet:!attributes!private! !
blendLinear:focus:scale:!operations!private! !
blendSigma:focus:scale:!operations!private! !
customBlendGet:!helpers!private! !
gammaCorrection:set:!attributes!private! !
gdipGetBlend:blend:positions:!helpers!private! !
gdipGetBlend:count:!attributes!private! !
gdipGetPresetBlend:blend:positions:!attributes!private! !
gdipGetPresetBlend:count:!attributes!private! !
gdipLinearBlend:focus:scale:!operations!private! !
gdipSetBlend:blend:positions:!attributes!private! !
gdipSetGammaCorrection:value:!attributes!private! !
gdipSetPresetBlend:blend:positions:!attributes!private! !
gdipSetSigmaBlend:focus:scale:!operations!private! !
getBlend:!attributes!private! !
getRectangle:!attributes!private! !
hash!comparing!public! !
isGammaCorrected!public!testing! !
presetBlendCountGet:!attributes!private! !
presetBlendGet:count:!attributes!private! !
!

