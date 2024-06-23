"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.TransformableBrushTest
	subclass: #'Graphics.Gdiplus.Tests.GradientBrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.GradientBrushTest guid: (Core.GUID fromString: '{4c04f76d-ccb5-4687-b714-f7ed3ec51464}')!

Graphics.Gdiplus.Tests.GradientBrushTest isNonInstantiable: true!

Graphics.Gdiplus.Tests.GradientBrushTest comment: ''!

!Graphics.Gdiplus.Tests.GradientBrushTest methodsFor!

testClone
	self newCanonicalModel.
	model
		blendBellShape: 0.2 scale: 0.7;
		isGammaCorrected: true;
		rotate: 45.
	super testClone!

testCustomBlend
	| factors positions blend |
	self newCanonicalModel.
	self assert: model blendFactorsCount equals: 1.
	blend := model blend.
	self assert: blend isCustom.
	self assert: blend isDefault.
	factors := #(0 0.3 0.9 1).
	positions := #(0 1.0e-001 0.5 1).
	model blendFactors: factors positions: positions.
	self assert: model blendFactorsCount equals: factors size.
	blend := model blend.
	self assert: blend isCustom.
	self assert: (blend factors closeTo: factors).
	self assert: (blend positions closeTo: positions)!

testIsGammaCorrected
	| recreated |
	self newCanonicalModel.
	model isGammaCorrected: true.
	self assert: model isGammaCorrected.
	recreated := self assertPersistedValid.
	self assert: recreated isGammaCorrected.
	model isGammaCorrected: false.
	self deny: model isGammaCorrected!

testPresetBlend
	| colors positions blend |
	self newCanonicalModel.
	self assert: model blendFactorsCount equals: 1.
	blend := model blend.
	self assert: blend isCustom.
	self assert: blend isDefault.
	colors := {Color red. Color green. Color blue. Color magenta}.
	positions := #(0 1.0e-001 0.5 1).
	model blendColors: colors positions: positions.
	blend := model blend.
	self deny: blend isDefault.
	self deny: blend isCustom.
	self assert: blend colors equals: colors.
	self assert: (blend positions closeTo: positions)!

testWrapMode
	self newCanonicalModel.
	self validWrapModes do: 
			[:each |
			model wrapMode: each.
			self assert: model wrapMode equals: each]!

validWrapModes
	^{WrapModeTile. WrapModeTileFlipX. WrapModeTileFlipY. WrapModeTileFlipXY. WrapModeClamp} ! !

!Graphics.Gdiplus.Tests.GradientBrushTest categoriesForMethods!
testClone!public!unit tests! !
testCustomBlend!public!unit tests! !
testIsGammaCorrected!public!unit tests! !
testPresetBlend!public!unit tests! !
testWrapMode!public!unit tests! !
validWrapModes!constants!private! !
!

