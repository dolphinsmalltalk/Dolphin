"Filed out from Dolphin Smalltalk XP"!

DhbLeastSquareFit subclass: #DhbMaximumLikekihoodHistogramFit
	instanceVariableNames: 'count countVariance'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbMaximumLikekihoodHistogramFit guid: (GUID fromString: '{E55002A4-7D2B-11D6-B6CC-00022D5019C8}')!
DhbMaximumLikekihoodHistogramFit comment: ''!
!DhbMaximumLikekihoodHistogramFit categoriesForClass!DHB Numerical! !
!DhbMaximumLikekihoodHistogramFit methodsFor!

accumulate: aWeightedPoint
		"Private - 
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| f g temp inverseProbability|
	f := result valueAndGradient: aWeightedPoint xValue.
	g := f last copyFrom: 1 to: ( f last size - 1).
	f := f first.
	f = 0 ifTrue: [ ^nil].
	inverseProbability := 1 / f.
	temp := aWeightedPoint yValue * inverseProbability.
	constants accumulate: g * temp.
	temp := temp * inverseProbability.
	1 to: g size do:
		[ :k |
		  ( equations at: k) accumulate: g * ( ( g at: k) * temp).
		].!

computeChanges
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^super computeChanges copyWith: 0!

computeNormalization
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "

	| numerator denominator temp |
	numerator := 0.
	denominator := 0.
	dataHolder pointsAndErrorsDo: 
			[:each | 
			temp := result value: each xValue.
			temp = 0 
				ifFalse: 
					[numerator := numerator + (each yValue squared / temp).
					denominator := denominator + temp]].
	count := ( numerator / denominator) sqrt.
	countVariance := numerator / ( 4 * count).!

finalizeIterations
	"Compute the normalization factor.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "

	self computeNormalization.
	result setCount: count.
	super finalizeIterations!

fitType
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^'Maximum likelihood fit'!

initializeIterations
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "

	result setCount: 1.
	count := dataHolder totalCount.
	super initializeIterations!

normalization
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/12/00 "
	^count!

normalizationError
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/12/00 "
	^countVariance sqrt!

numberOfFreeParameters
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^super numberOfParameters!

numberOfParameters
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^super numberOfParameters - 1!

valueAndError: aNumber 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/8/00 "

	| valueGradient gradient gVar |
	valueGradient := result valueAndGradient: aNumber.
	gradient := valueGradient last copyFrom: 1 to: valueGradient last size - 1.
	gVar := gradient * (self errorMatrix * gradient) / count.
	^Array with: valueGradient first
		with: ((valueGradient first / count) squared * countVariance + gVar) sqrt! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #accumulate:!operation!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #computeChanges!operation!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #computeNormalization!operation!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #finalizeIterations!operation!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #fitType!information!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #initializeIterations!operation!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #normalization!information!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #normalizationError!information!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #numberOfFreeParameters!information!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #numberOfParameters!information!public! !
!DhbMaximumLikekihoodHistogramFit categoriesFor: #valueAndError:!information!public! !

