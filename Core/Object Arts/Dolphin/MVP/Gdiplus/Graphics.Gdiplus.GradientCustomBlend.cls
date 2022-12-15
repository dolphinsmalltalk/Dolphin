"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GradientBlend subclass: #'Graphics.Gdiplus.GradientCustomBlend'
	instanceVariableNames: 'factors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GradientCustomBlend guid: (Core.GUID fromString: '{4dc11c0d-abd4-4e11-bc41-6c52a302311f}')!
Graphics.Gdiplus.GradientCustomBlend comment: ''!
!Graphics.Gdiplus.GradientCustomBlend methodsFor!

= aGpAttribute
	^self == aGpAttribute or: [super = aGpAttribute and: [factors = aGpAttribute factors]]!

applyToGpObject: aGdiplusObject initializer: aGradientBrushInitializer
	"If an InvalidParameter error occurs, check these invariants

	self assert: [factors allSatisfy: [:each | each between: 0 and: 1]].
	self assert: [positions size > 0].
	self assert: [positions first = 0 and: [positions size < 2 or: [positions last = 1]]].
	"

	aGradientBrushInitializer
		gdipSetBlend: aGdiplusObject asParameter
		blend: factors
		positions: positions!

factors
	^factors!

factors: aSequenceOfFactors
	factors := FLOATArray marshal: aSequenceOfFactors.
	^self!

hash
	"Answer the <integer> hash value for the receiver."

	^(super hash + factors hash) hashMultiply!

isCustom
	^true!

isDefault
	"If there is only one factor and position, then the position must be zero (any other value is ignored)"

	^factors size == 1 and: [factors first = 1.0]!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		nextPut: $(;
		print: self class;
		nextPutAll: ' factors: #';
		display: factors;
		nextPutAll: ' positions: #';
		display: positions;
		nextPut: $)! !
!Graphics.Gdiplus.GradientCustomBlend categoriesForMethods!
=!comparing!public! !
applyToGpObject:initializer:!operations!private! !
factors!accessing!public! !
factors:!initializing!private! !
hash!comparing!public! !
isCustom!public!testing! !
isDefault!public!testing! !
printOn:!printing!public! !
!

!Graphics.Gdiplus.GradientCustomBlend class methodsFor!

factors: aSequenceOfFactors positions: aSequenceOfPositions
	^self new
		factors: aSequenceOfFactors;
		positions: aSequenceOfPositions! !
!Graphics.Gdiplus.GradientCustomBlend class categoriesForMethods!
factors:positions:!instance creation!public! !
!

