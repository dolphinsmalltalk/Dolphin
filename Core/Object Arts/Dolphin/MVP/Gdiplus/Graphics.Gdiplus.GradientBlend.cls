"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Attribute
	subclass: #'Graphics.Gdiplus.GradientBlend'
	instanceVariableNames: 'positions'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GradientBlend guid: (Core.GUID fromString: '{c54920c7-dc72-4bb3-8d64-aa1c64336295}')!
Graphics.Gdiplus.GradientBlend isNonInstantiable: true!
Graphics.Gdiplus.GradientBlend comment: ''!
!Graphics.Gdiplus.GradientBlend methodsFor!

= aGpAttribute
	^self species == aGpAttribute species and: [positions = aGpAttribute positions]!

hash
	"Answer the <integer> hash value for the receiver."

	^(self species hash + positions hash) hashMultiply!

isCustom
	^false!

isSelfEvaluating
	^true!

positions
	^positions!

positions: aSequencedOfPositions
	positions := FLOATArray marshal: aSequencedOfPositions.
	^self! !
!Graphics.Gdiplus.GradientBlend categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isCustom!public!testing! !
isSelfEvaluating!public!testing! !
positions!accessing!private! !
positions:!initializing!private! !
!

