"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GradientBlend subclass: #'Graphics.Gdiplus.GradientPresetBlend'
	instanceVariableNames: 'colors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GradientPresetBlend guid: (Core.GUID fromString: '{ddc4b63a-7d70-44b1-8917-7a24089d61bf}')!
Graphics.Gdiplus.GradientPresetBlend comment: ''!
!Graphics.Gdiplus.GradientPresetBlend methodsFor!

= aGpAttribute
	^self == aGpAttribute or: [super = aGpAttribute and: [colors = aGpAttribute colors]]!

applyToGpObject: aGdiplusObject initializer: anObject
	"If you get a InvalidParameter error code here, check these invariants
		self assert: [positions size >= 2].
		self assert: [positions first = 0 and: [positions last = 1]].
	"

	anObject
		gdipSetPresetBlend: aGdiplusObject asParameter
		blend: colors
		positions: positions!

colors
	^colors!

colors: aSequenceOfColors
	colors := ARGBArray marshal: aSequenceOfColors.
	^self!

hash
	"Answer the <integer> hash value for the receiver."

	^(super hash + colors hash) hashMultiply!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		nextPut: $(;
		print: self class;
		nextPutAll: ' colors: ';
		print: colors asArray;
		nextPutAll: ' positions: #';
		display: positions;
		nextPut: $)! !
!Graphics.Gdiplus.GradientPresetBlend categoriesForMethods!
=!comparing!public! !
applyToGpObject:initializer:!operations!private! !
colors!accessing!public! !
colors:!initializing!private! !
hash!comparing!public! !
printOn:!printing!public! !
!

!Graphics.Gdiplus.GradientPresetBlend class methodsFor!

colors: aSequenceOfColors positions: aSequencedOfPositions
	^self new
		colors: aSequenceOfColors;
		positions: aSequencedOfPositions! !
!Graphics.Gdiplus.GradientPresetBlend class categoriesForMethods!
colors:positions:!instance creation!public! !
!

