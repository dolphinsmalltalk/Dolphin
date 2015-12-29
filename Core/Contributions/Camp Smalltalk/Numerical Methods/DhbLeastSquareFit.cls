"Filed out from Dolphin Smalltalk XP"!

DhbIterativeProcess subclass: #DhbLeastSquareFit
	instanceVariableNames: 'dataHolder errorMatrix chiSquare equations constants degreeOfFreedom'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLeastSquareFit guid: (GUID fromString: '{E55002A3-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLeastSquareFit comment: ''!
!DhbLeastSquareFit categoriesForClass!DHB Numerical! !
!DhbLeastSquareFit methodsFor!

accumulate: aWeightedPoint
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	| f g |
	f := result valueAndGradient: aWeightedPoint xValue.
	g := f last.
	f := f first.
	constants accumulate: g * ( ( aWeightedPoint yValue - f) * aWeightedPoint weight).
	1 to: g size do:
		[ :k |
		  ( equations at: k) accumulate: g * ( ( g at: k) * aWeightedPoint weight).
		].!

accumulateEquationSystem
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	dataHolder pointsAndErrorsDo: [ :each | self accumulate: each].!

chiSquare
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	chiSquare isNil
		ifTrue: [ self computeChiSquare].
	^chiSquare!

computeChanges
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	errorMatrix := DhbLUPDecomposition direct: equations.
	^errorMatrix solve: constants!

computeChiSquare
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	chiSquare := 0.
	degreeOfFreedom := self numberOfFreeParameters negated.
	dataHolder pointsAndErrorsDo:
		[ :each |
		  chiSquare := ( each chi2Contribution: result) + chiSquare.
		  degreeOfFreedom := degreeOfFreedom + 1.
		].!

computeEquationSystem
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	constants atAllPut: 0.
	equations do: [ :each | each atAllPut: 0].
	self accumulateEquationSystem.!

confidenceLevel
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/6/00 "
	^( DhbChiSquareDistribution degreeOfFreedom: self degreeOfFreedom) confidenceLevel: self chiSquare!

degreeOfFreedom
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	degreeOfFreedom isNil
		ifTrue: [ self computeChiSquare].
	^degreeOfFreedom!

errorMatrix
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 14/4/99 "
	^DhbSymmetricMatrix rows: errorMatrix inverseMatrixComponents!

evaluateIteration
		"Dummy method (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	| changes maxChange|
	self computeEquationSystem.
	changes := self computeChanges.
	result changeParametersBy: changes.
	maxChange := 0.
	result parameters with: changes do: 
		[ :r :d | maxChange := ( d / r) abs max: maxChange].
	^maxChange!

finalizeIterations
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "

	equations := nil.
	constants := nil.
	degreeOfFreedom := nil.
	chiSquare := nil!

fitType
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^'Least square fit'!

initialize: aDataHolder data: aParametricFunction
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	dataHolder := aDataHolder.
	result := aParametricFunction.
	^self!

initializeIterations
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	| n |
	n := self numberOfParameters.
	constants := (DhbVector new: n)
				atAllPut: 0;
				yourself.
	equations := (1 to: n) collect: 
					[:k | 
					(DhbVector new: n)
						atAllPut: 0;
						yourself]!

numberOfFreeParameters
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^self numberOfParameters!

numberOfParameters
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^result parameters size!

value: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/8/00 "
	^result value: aNumber!

valueAndError: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/8/00 "
	| valueGradient |
	valueGradient := result valueAndGradient: aNumber.
	^Array with: valueGradient first
		   with: ( valueGradient last * ( self errorMatrix * valueGradient last)) sqrt! !
!DhbLeastSquareFit categoriesFor: #accumulate:!operation!public! !
!DhbLeastSquareFit categoriesFor: #accumulateEquationSystem!operation!public! !
!DhbLeastSquareFit categoriesFor: #chiSquare!information!public! !
!DhbLeastSquareFit categoriesFor: #computeChanges!operation!public! !
!DhbLeastSquareFit categoriesFor: #computeChiSquare!information!public! !
!DhbLeastSquareFit categoriesFor: #computeEquationSystem!operation!public! !
!DhbLeastSquareFit categoriesFor: #confidenceLevel!information!public! !
!DhbLeastSquareFit categoriesFor: #degreeOfFreedom!information!public! !
!DhbLeastSquareFit categoriesFor: #errorMatrix!information!public! !
!DhbLeastSquareFit categoriesFor: #evaluateIteration!operation!public! !
!DhbLeastSquareFit categoriesFor: #finalizeIterations!operation!public! !
!DhbLeastSquareFit categoriesFor: #fitType!information!public! !
!DhbLeastSquareFit categoriesFor: #initialize:data:!initialization!public! !
!DhbLeastSquareFit categoriesFor: #initializeIterations!operation!public! !
!DhbLeastSquareFit categoriesFor: #numberOfFreeParameters!information!public! !
!DhbLeastSquareFit categoriesFor: #numberOfParameters!information!public! !
!DhbLeastSquareFit categoriesFor: #value:!information!public! !
!DhbLeastSquareFit categoriesFor: #valueAndError:!information!public! !

!DhbLeastSquareFit class methodsFor!

histogram: aHistogram distributionClass: aProbabilityDensityFunctionClass 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "

	^self points: aHistogram
		function: (DhbScaledProbabilityDensityFunction histogram: aHistogram
				distributionClass: aProbabilityDensityFunctionClass)!

points: aDataHolder function: aParametricFunction 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 11/3/99"

	^aParametricFunction isNil
		ifTrue: [nil]
		ifFalse: [super new initialize: aDataHolder data: aParametricFunction]! !
!DhbLeastSquareFit class categoriesFor: #histogram:distributionClass:!creation!public! !
!DhbLeastSquareFit class categoriesFor: #points:function:!creation!public! !

