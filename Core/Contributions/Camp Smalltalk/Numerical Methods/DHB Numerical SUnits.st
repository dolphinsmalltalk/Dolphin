TestCase subclass: #DhbNumericalMethodsTestCase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical SUnits'!


!DhbNumericalMethodsTestCase methodsFor: 'data mining'!

testClusterCovariance

	| dataServer clusters finder |

	dataServer := DhbMemoryBasedDataServer new.
	dataServer data: ( self generatedPoints: 1000).
	finder := DhbClusterFinder new: 5 server: dataServer type: DhbCovarianceCluster.
	finder minimumRelativeClusterSize: 0.1.
	clusters := finder evaluate.
	self should: [ clusters size = 3].!

testClusterEuclidean

	| dataServer clusters finder |
	dataServer := DhbMemoryBasedDataServer new.
	dataServer data: ( self generatedPoints: 1000).
	finder := DhbClusterFinder new: 5 server: dataServer type: DhbEuclideanCluster.
	finder minimumRelativeClusterSize: 0.15.
	clusters := finder evaluate.
	self should: [ clusters size = 3].!

testCovarianceAccumulation
	"Code example 12.2"
	| accumulator average covarianceMatrix |
	accumulator := DhbCovarianceAccumulator new: 3.
	#( 
			(1 2 3)
			( 2 3 4)
			( 1 3 2)
			( 4 3 1)
			( 1 3 1)
			( 1 4 2)
			( 3 1 2)
			( 3 4 2)
		)
	do: [ :x | accumulator accumulate: x asVector].
	average := accumulator average.
	self should: [ ( average at: 1) equalsTo: 2.0].
	self should: [ ( average at: 2) equalsTo: 2.875].
	self should: [ ( average at: 3) equalsTo: 2.125].
	covarianceMatrix := accumulator covarianceMatrix.
	self should: [ ((covarianceMatrix rowAt: 1) at: 1) equalsTo: 1.25].
	self should: [ ((covarianceMatrix rowAt: 1) at: 2) equalsTo: -0.125].
	self should: [ ((covarianceMatrix rowAt: 2) at: 1) equalsTo: -0.125].
	self should: [ ((covarianceMatrix rowAt: 1) at: 3) equalsTo: -0.25].
	self should: [ ((covarianceMatrix rowAt: 3) at: 1) equalsTo: -0.25].
	self should: [ ((covarianceMatrix rowAt: 2) at: 2) equalsTo: 0.859375].
	self should: [ ((covarianceMatrix rowAt: 2) at: 3) equalsTo: -0.109375].
	self should: [ ((covarianceMatrix rowAt: 3) at: 2) equalsTo: -0.109375].
	self should: [ ((covarianceMatrix rowAt: 3) at: 3) equalsTo: 0.859375].!

testMahalanobisCenter
	"Code example 12.5"
	| center distance|
	center := DhbMahalanobisCenter new: 3.
	#( 
			(1 2 3)
			( 2 3 4)
			( 1 3 2)
			( 4 3 1)
			( 1 3 1)
			( 1 4 2)
			( 3 1 2)
			( 3 4 2)
		)
	do: [ :x | center accumulate: x asVector].
	center computeParameters.
	distance := center distanceTo: #(1 2 3) asVector.
	self should: [ distance equalsTo: 2.26602282704126].! !

!DhbNumericalMethodsTestCase methodsFor: 'estimation'!

testFTest

	| accC accMM confidenceLevel|
	accC := DhbStatisticalMoments new.
	#( 5.56 5.89 4.66 5.69 5.34 4.79 4.80 7.86 3.64 5.70 )
		do: [ :x | accC accumulate: x].
	accMM := DhbStatisticalMoments new.
	#( 7.48 6.75 3.77 5.71 7.25 4.73 6.23 5.60 5.94 4.58 )
		do: [ :x | accMM accumulate: x].
	confidenceLevel := accC fConfidenceLevel: accMM.
	self should: [ (accC average - 5.393) abs < 0.000000001].
	self should: [ (accC standardDeviation - 1.0990809292) abs < 0.000000001].
	self should: [ (accMM average - 5.804) abs < 0.000000001].
	self should: [ (accMM standardDeviation - 1.19415428) abs < 0.000000001].
	self should: [ (confidenceLevel - 79.8147614536) abs < 0.000000001].!

testInterpolationNewton

	| interpolator |
	interpolator := DhbNewtonInterpolator new.
	1 to: 45 by: 2 do:
		[ :x | interpolator add: x @ (x degreesToRadians sin)].
	self should: [ ((interpolator value: 8) - (8 degreesToRadians sin)) abs < 1.0e-14].!

testLeastSquare
	"Code example 10.9"
	"Note: the seemingly large error on the fit results is due to the binning of the histogram."
	| count shape scale genDistr hist fit fittedDistr parameters |
	count := 10000.
	shape := 0.
	scale := 1.
	hist := DhbHistogram new.
	hist freeExtent: true.
	genDistr := DhbFisherTippettDistribution shape: shape scale: scale.
	count timesRepeat: [ hist accumulate: genDistr random].
	fit := DhbLeastSquareFit histogram: hist distributionClass: DhbFisherTippettDistribution.
	fittedDistr := fit evaluate.
	parameters := fittedDistr parameters.
	self should: [ ((parameters at: 1) - shape) abs < 0.1].
	self should: [ ((parameters at: 2) - scale) abs < 0.1].
	self should: [ ((parameters at: 3) - count) abs < 100].!

testLeastSquarePolynomial
	"Code example 10.5"
	| fit estimation |
	fit := DhbPolynomialLeastSquareFit new: 3.
	fit
		add: (DhbWeightedPoint point: 1 @ 2.0);
		add: (DhbWeightedPoint point: 2 @ 21.0);
		add: (DhbWeightedPoint point: 3 @ 72.0);
		add: (DhbWeightedPoint point: 4 @ 173.0);
		add: (DhbWeightedPoint point: 5 @ 342.0);
		add: (DhbWeightedPoint point: 6 @ 597.0);
		add: (DhbWeightedPoint point: 7 @ 956.0);
		add: (DhbWeightedPoint point: 8 @ 1437.0);
		add: (DhbWeightedPoint point: 9 @ 2058.0);
		add: (DhbWeightedPoint point: 10 @ 2837.0).
	estimation := fit evaluate.
	self should: [ ((estimation value: 4.5)- 247.875) abs < 0.000000001].
	self should: [ ((estimation error: 4.5) -  5.215298e-1) abs < 0.00001].
	self should: [ ((estimation value: 7.15)- 1019.932625) abs < (estimation error: 7.15)].!

testLinearRegression
	"Code example 10.5"
	| linReg estimation |
	linReg := DhbLinearRegression new.
	linReg
		add: 1 @ 0.72;
		add: 2 @ 3.25;
		add: 3 @ 5.75;
		add: 4 @ 8.21;
		add: 5 @ 10.71;
		add: 6 @ 13.38;
		add: 7 @ 15.82;
		add: 8 @ 18.39;
		add: 9 @ 20.72;
		add: 10 @ 23.38.
	self should: [ (linReg slope - 2.514727272727) abs < 0.000000000001].
	self should: [ (linReg intercept + 1.798) abs < 0.000000000001].
	self should: [ (linReg correlationCoefficient - 0.999966922113) abs < 0.000000000001].
	estimation := linReg asEstimatedPolynomial.
	self should: [ ((estimation value: 4.5)- 9.5182727272727) abs < 0.000000000001].
	self should: [ ((estimation value: 7.15)-  16.1823) abs < 0.000000000001].!

testMaximumLikelihood
	"Code example 10.11"
	"Note: the seemingly large error on the fit results is due to the binning of the histogram."
	| count shape scale genDistr hist fit fittedDistr parameters |
	count := 10000.
	shape := 0.
	scale := 1.
	hist := DhbHistogram new.
	hist freeExtent: true.
	genDistr := DhbFisherTippettDistribution shape: shape scale: scale.
	count timesRepeat: [ hist accumulate: genDistr random].
	fit := DhbMaximumLikekihoodHistogramFit histogram: hist distributionClass: DhbFisherTippettDistribution.
	fittedDistr := fit evaluate.
	parameters := fittedDistr parameters.
	self should: [ ((parameters at: 1) - shape) abs < 0.1].
	self should: [ ((parameters at: 2) - scale) abs < 0.1].
	self should: [ ((parameters at: 3) - count) abs < 100].!

testTTest

	| accC accMM confidenceLevel|
	accC := DhbStatisticalMoments new.
	#( 5.56 5.89 4.66 5.69 5.34 4.79 4.80 7.86 3.64 5.70 )
		do: [ :x | accC accumulate: x].
	accMM := DhbStatisticalMoments new.
	#( 7.48 6.75 3.77 5.71 7.25 4.73 6.23 5.60 5.94 4.58 )
		do: [ :x | accMM accumulate: x].
	confidenceLevel := accC tConfidenceLevel: accMM.
	self should: [ (accC average - 5.393) abs < 0.000000001].
	self should: [ (accC standardDeviation - 1.0990809292) abs < 0.000000001].
	self should: [ (accMM average - 5.804) abs < 0.000000001].
	self should: [ (accMM standardDeviation - 1.19415428) abs < 0.000000001].
	self should: [ (confidenceLevel - 56.6320739989) abs < 0.000000001].! !

!DhbNumericalMethodsTestCase methodsFor: 'function evaluation'!

testBeta
	"Code example 2.14"
	| value |

	value := 2.5 gamma * 5.5 gamma / 8 gamma.
	self should: [ ((2.5 beta: 5.5)  - value) abs < 1.0e-14].!

testBetaLog
	"Code example 2.15"
	| value |
	value := ( 2.5 gamma * 5.5 gamma / 8 gamma) ln.
	self should: [ ((2.5 logBeta: 5.5)  - value) abs < 1.0e-13].!

testErrorFunctionCentile
	"Code example 2.5"
	| weight average stDev centile |
	weight := 2.85.
	average := 3.39.
	stDev := 0.44.
	centile := (( weight - average) / stDev) errorFunction * 100.
	self should: [ ( centile - 10.986012) abs < 0.000001].!

testGamma
	"Code example 2.10"
	| value |
	value := Float pi sqrt * 3 / 4.
	self should: [ (2.5 gamma  - value) abs < 1.0e-14].!

testGammaLog
	"Code example 2.11"
	| value |
	value := 2.5 gamma ln.
	self should: [ (2.5 logGamma  - value) abs < 1.0e-13].!

testGammaLow

	| value |
	value := Float pi sqrt / 2.
	self should: [ ((3/2) gamma  - value) abs < 1.0e-14].!

testGammaNegative

	| value |
	value := Float pi / ( 1.5 gamma * (Float pi / -2) sin).
	self should: [ ((-1/2) gamma  - value) abs < 1.0e-14].!

testInterpolationBulirschStoer

	| interpolator |
	interpolator := DhbBulirschStoerInterpolator new.
	1 to: 45 by: 2 do:
		[ :x | interpolator add: x @ (x degreesToRadians sin)].
	self should: [ ((interpolator value: 8) - (8 degreesToRadians sin)) abs < 1.0e-14].!

testInterpolationLagrange
	"Code example 3.2"
	| interpolator |
	interpolator := DhbLagrangeInterpolator new.
	1 to: 45 by: 2 do:
		[ :x | interpolator add: x @ (x degreesToRadians sin)].
	self should: [ ((interpolator value: 8) - (8 degreesToRadians sin)) abs < 1.0e-14].!

testInterpolationLagrangeLinear
	"Code example 3.1"
	| interpolator |
	interpolator := DhbLagrangeInterpolator points: (Array with: 1 @ 2 with: 3 @ 1 ).
	self should: [ ((interpolator value: 2.2) - 1.4) abs < 1.0e-14].!

testInterpolationNeville

	| interpolator |

	interpolator := DhbNevilleInterpolator new.
	1 to: 45 by: 2 do:
		[ :x | interpolator add: x @ (x degreesToRadians sin)].
	self should: [ ((interpolator value: 8) - (8 degreesToRadians sin)) abs < 1.0e-14].!

testInterpolationNevilleLinear
	"Code example 3.1"
	| interpolator |
	interpolator := DhbNevilleInterpolator points: (Array with: 1 @ 2 with: 3 @ 1 ).
	self should: [ ((interpolator value: 2.2) - 1.4) abs < 1.0e-14].!

testInterpolationNewtonLinear
	"Code example 3.1"
	| interpolator |
	interpolator := DhbNewtonInterpolator points: (Array with: 1 @ 2 with: 3 @ 1 ).
	self should: [ ((interpolator value: 2.2) - 1.4) abs < 1.0e-14].!

testInterpolationSpline

	| interpolator |
	interpolator := DhbSplineInterpolator new.
	1 to: 45 by: 2 do:
		[ :x | interpolator add: x @ (x degreesToRadians sin)].
	self should: [ ((interpolator value: 8) - (8 degreesToRadians sin)) abs < 1.0e-7].!

testInterpolationSplineLinear
	"Code example 3.1"
	| interpolator |
	interpolator := DhbSplineInterpolator points: (Array with: 1 @ 2 with: 3 @ 1 ).
	self should: [ ((interpolator value: 2.2) - 1.4) abs < 1.0e-14].!

testPolynomialAddition

	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(2 -3 1)) + ( DhbPolynomial coefficients: #(-3 7 2 1)).
	self should: [ (polynomial at: 0) = -1].
	self should: [ (polynomial at: 1) = 4].
	self should: [ (polynomial at: 2) = 3].
	self should: [ (polynomial at: 3) = 1].
	self should: [ (polynomial at: 4) = 0].!

testPolynomialDerivative
	"Code example 2.3"
	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(-3 7 2 1)) derivative.
	self should: [ (polynomial at: 0) = 7].
	self should: [ (polynomial at: 1) = 4].
	self should: [ (polynomial at: 2) = 3].
	self should: [ (polynomial at: 3) = 0].
	self should: [ (polynomial at: 4) = 0].!

testPolynomialDivision

	| pol1 pol2 polynomial |
	pol1 := DhbPolynomial coefficients: #(2 -3 1).
	pol2 := DhbPolynomial coefficients: #(-6 23 -20 3 -1 1).
	polynomial := pol2 / pol1.
	self should: [ (polynomial at: 0) = -3].
	self should: [ (polynomial at: 1) = 7].
	self should: [ (polynomial at: 2) = 2].
	self should: [ (polynomial at: 3) = 1].
	self should: [ (polynomial at: 4) = 0].
	self should: [ (polynomial at: 5) = 0].
	self should: [ (polynomial at: 6) = 0].!

testPolynomialEvaluation
	"Code example 2.2"
	| polynomial |
	polynomial := DhbPolynomial coefficients: #(2 -3 1).
	self should: [0 = (polynomial value: 1)].!

testPolynomialIntegral
	"Code example 2.3"
	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(-3 7 2 1)) integral.
	self should: [ (polynomial at: 0) = 0].
	self should: [ (polynomial at: 1) = -3].
	self should: [ (polynomial at: 2) = (7/2)].
	self should: [ (polynomial at: 3) = (2/3)].
	self should: [ (polynomial at: 4) = (1/4)].
	self should: [ (polynomial at: 5) = 0].!

testPolynomialIntegralWithConstant
	"Code example 2.3"
	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(-3 7 2 1)) integral: 5.
	self should: [ (polynomial at: 0) = 5].
	self should: [ (polynomial at: 1) = -3].
	self should: [ (polynomial at: 2) = (7/2)].
	self should: [ (polynomial at: 3) = (2/3)].
	self should: [ (polynomial at: 4) = (1/4)].
	self should: [ (polynomial at: 5) = 0].!

testPolynomialMultiplication
	"Code example 2.3"
	| pol1 pol2 polynomial |
	pol1 := DhbPolynomial coefficients: #(2 -3 1).
	pol2 := DhbPolynomial coefficients: #(-3 7 2 1).
	polynomial := pol1 * pol2.
	self should: [ (polynomial at: 0) = -6].
	self should: [ (polynomial at: 1) = 23].
	self should: [ (polynomial at: 2) = -20].
	self should: [ (polynomial at: 3) = 3].
	self should: [ (polynomial at: 4) = -1].
	self should: [ (polynomial at: 5) = 1].
	self should: [ (polynomial at: 6) = 0].!

testPolynomialNumberAddition

	| polynomial |
	polynomial := 2 + ( DhbPolynomial coefficients: #(2 -3 1)).
	self should: [ (polynomial at: 0) = 4].
	self should: [ (polynomial at: 1) = -3].
	self should: [ (polynomial at: 2) = 1].
	self should: [ (polynomial at: 3) = 0].!

testPolynomialNumberAdditionInverse

	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(2 -3 1)) + 2.
	self should: [ (polynomial at: 0) = 4].
	self should: [ (polynomial at: 1) = -3].
	self should: [ (polynomial at: 2) = 1].
	self should: [ (polynomial at: 3) = 0].!

testPolynomialNumberDivision

	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(2 -3 1)) / 2.
	self should: [ (polynomial at: 0) = 1].
	self should: [ (polynomial at: 1) = (-3 / 2)].
	self should: [ (polynomial at: 2) = (1/2)].
	self should: [ (polynomial at: 3) = 0].!

testPolynomialNumberMultiplication

	| polynomial |
	polynomial := 2 * ( DhbPolynomial coefficients: #(2 -3 1)).
	self should: [ (polynomial at: 0) = 4].
	self should: [ (polynomial at: 1) = -6].
	self should: [ (polynomial at: 2) = 2].
	self should: [ (polynomial at: 3) = 0].!

testPolynomialNumberMultiplicationInverse

	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(2 -3 1)) * 2.
	self should: [ (polynomial at: 0) = 4].
	self should: [ (polynomial at: 1) = -6].
	self should: [ (polynomial at: 2) = 2].
	self should: [ (polynomial at: 3) = 0].!

testPolynomialNumberSubtraction

	| polynomial |
	polynomial := 2 - ( DhbPolynomial coefficients: #(2 -3 1)).
	self should: [ (polynomial at: 0) = 0].
	self should: [ (polynomial at: 1) = 3].
	self should: [ (polynomial at: 2) = -1].
	self should: [ (polynomial at: 3) = 0].!

testPolynomialNumberSubtractionInverse

	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(2 -3 1)) - 2.
	self should: [ (polynomial at: 0) = 0].
	self should: [ (polynomial at: 1) = -3].
	self should: [ (polynomial at: 2) = 1].
	self should: [ (polynomial at: 3) = 0].!

testPolynomialSubtraction

	| polynomial |
	polynomial := ( DhbPolynomial coefficients: #(2 -3 1)) - ( DhbPolynomial coefficients: #(-3 7 2 1)).
	self should: [ (polynomial at: 0) = 5].
	self should: [ (polynomial at: 1) = -10].
	self should: [ (polynomial at: 2) = -1].
	self should: [ (polynomial at: 3) = -1].
	self should: [ (polynomial at: 4) = 0].! !

!DhbNumericalMethodsTestCase methodsFor: 'iterative algorithms'!

testBissection
	"Code Example 5.1"
	| zeroFinder result |
	zeroFinder := DhbBisectionZeroFinder function: [ :x | x errorFunction - 0.9].
	zeroFinder setPositiveX: 10.0; setNegativeX: 0.0.
	result := zeroFinder evaluate.
	self should: [ zeroFinder hasConverged].
	self should: [ (result -1.28155193291605) abs < 1.0e-14]!

testIncompleteBetaFunction

	| function |
	function := DhbIncompleteBetaFunction shape: 2 shape: 5.
	self should: [ ( (function value: 0.8) - 0.9984) abs < 0.00001].!

testIncompleteGammaFunction

	| function |
	function := DhbIncompleteGammaFunction shape: 2.
	self should: [ ( (function value: 2) - 0.59399414981) abs < 0.00000000001].!

testIntegrationRomberg

	| integrator ln2 ln3|
	integrator := DhbRombergIntegrator function: [ :x | 1.0 / x] from: 1 to: 2.
	ln2 := integrator evaluate.
	integrator from: 1 to: 3.
	ln3 := integrator evaluate.
	self should: [ ( 2.0 ln - ln2) abs < ( 2 * integrator precision)].
	self should: [ ( 3.0 ln - ln3) abs < ( 2 * integrator precision)].!

testIntegrationSimpson

	| integrator ln2 ln3|
	integrator := DhbSimpsonIntegrator function: [ :x | 1.0 / x] from: 1 to: 2.
	ln2 := integrator evaluate.
	integrator from: 1 to: 3.
	ln3 := integrator evaluate.
	self should: [ ( 2.0 ln - ln2) abs < integrator precision].
	self should: [ ( 3.0 ln - ln3) abs < integrator precision].!

testIntegrationTrapeze
	"Code Example 6.1"
	| integrator ln2 ln3|
	integrator := DhbTrapezeIntegrator function: [ :x | 1.0 / x] from: 1 to: 2.
	ln2 := integrator evaluate.
	integrator from: 1 to: 3.
	ln3 := integrator evaluate.
	self should: [ ( 2.0 ln - ln2) abs < integrator precision].
	self should: [ ( 3.0 ln - ln3) abs < integrator precision].!

testNewtonZeroFinder
	"Code Example 5.3"
	| zeroFinder result |
	zeroFinder := DhbNewtonZeroFinder function: [ :x | x errorFunction - 0.9].
	zeroFinder initialValue: 1.0.
	result := zeroFinder evaluate.
	self should: [ zeroFinder hasConverged].
	self should: [ (result -1.28155193867885) abs < zeroFinder precision]!

testPolynomialRoots
	"Code Example 5.5"
	| polynomial roots |
	polynomial := DhbPolynomial coefficients: #( -10 -13 -2 1).
	roots := polynomial roots asSortedCollection asArray.
	self should: [ roots size = 3].
	self should: [ ( (roots at: 1) + 2) abs < DhbFloatingPointMachine new defaultNumericalPrecision].
	self should: [ ( (roots at: 2) + 1) abs < DhbFloatingPointMachine new defaultNumericalPrecision].
	self should: [ ( (roots at: 3) - 5) abs < DhbFloatingPointMachine new defaultNumericalPrecision].! !

!DhbNumericalMethodsTestCase methodsFor: 'linear algebra'!

testDeterminant

	| m |
	m := DhbMatrix rows: #( (3 2 4) (2 -5 -1) ( 1 -2 2)).
	self should: [ m determinant = -42].!

testEigenvalues
	"Code Example 8.15"
	| m charPol roots eigenvalues finder |
	m := DhbMatrix rows: #( ( 3 -2 0) (-2 7 1) (0 1 5)).
	charPol := DhbPolynomial coefficients: #(82 -66 15 -1).
	roots := charPol roots asSortedCollection asArray reverse.
	finder := DhbJacobiTransformation matrix: m.
	finder desiredPrecision: 1.0e-09.
	eigenvalues := finder evaluate.
	self should: [ eigenvalues size = 3].
	self should: [ ((roots at: 1) - (eigenvalues at: 1)) abs < 1.0e-09].
	self should: [ ((roots at: 2) - (eigenvalues at: 2)) abs < 1.0e-09].
	self should: [ ((roots at: 3) - (eigenvalues at: 3)) abs < 1.0e-09].!

testEigenvaluesLargest
	"Code Example 8.13"
	| m charPol roots eigenvalue finder |
	m := DhbMatrix rows: #( ( 3 -2 0) (-2 7 1) (0 1 5)).
	charPol := DhbPolynomial coefficients: #(82 -66 15 -1).
	roots := charPol roots asSortedCollection asArray reverse.
	finder := DhbLargestEigenValueFinder matrix: m.
	finder desiredPrecision: 1.0e-08.
	eigenvalue := finder evaluate.
	self should: [ ((roots at: 1) - eigenvalue) abs < 1.0e-08].
	finder := finder nextLargestEigenValueFinder.
	eigenvalue := finder evaluate.
	self should: [ ((roots at: 2) - eigenvalue) abs < 1.0e-08].!

testLinearEquations
	"Code Example 8.6"
	| s sol1 sol2 |
	s := DhbLinearEquationSystem equations:
							#( (3 2 4) (2 -5 -1) ( 1 -2 2))
				constants: #( (16 6 10)
									  (7 10 9)).
	sol1 := s solutionAt: 1.
	sol2 := s solutionAt: 2.
	self should: [ sol1 size = 3].
	self should: [ (sol1 at: 1) = 2].
	self should: [ (sol1 at: 2) = -1].
	self should: [ (sol1 at: 3) = 3].
	self should: [ sol2 size = 3].
	self should: [ (sol2 at: 1) = 1].
	self should: [ (sol2 at: 2) = -2].
	self should: [ (sol2 at: 3) = 2].!

testLinearEquationsSingle

	| s sol |
	s := DhbLinearEquationSystem equations:
							#( (1 2 0) (3 5 4) (5 6 3)) constant: #(0.1 12.5 10.3).
	sol := s solution.
	self should: [ sol size = 3].
	self should: [ (sol at: 1) equalsTo: 0.5].
	self should: [ (sol at: 2) equalsTo: -0.2].
	self should: [ (sol at: 3) equalsTo:  3.0].!

testLinearEquationsSingular

	| s sol |
	s := DhbLinearEquationSystem equations:
							#( (1 2 0) (10 12 6) (5 6 3)) constant: #(0.1 12.5 10.3).
	sol := s solution.
	self should: [ sol isNil].!

testLUPDecomposition
	"Code Example 8.10"
	| s sol1 sol2 |
	s := DhbLUPDecomposition equations:
							#( (3 2 4) (2 -5 -1) ( 1 -2 2)).
	sol1 := s solve: #(16 6 10).
	sol2 := s solve: #(7 10 9).
	self should: [ sol1 size = 3].
	self should: [ (sol1 at: 1) = 2].
	self should: [ (sol1 at: 2) = -1].
	self should: [ (sol1 at: 3) = 3].
	self should: [ sol2 size = 3].
	self should: [ (sol2 at: 1) = 1].
	self should: [ (sol2 at: 2) = -2].
	self should: [ (sol2 at: 3) = 2].!

testMatrixInversionSmall

	| m c |
	m := DhbMatrix rows: #( (3 2 4) (2 -5 -1) ( 1 -2 2)).
	c := m inverse * m.
	self should: [ c numberOfRows = 3].
	self should: [ c numberOfColumns = 3].
	self should: [ ((c rowAt: 1) at: 1) = 1].
	self should: [ ((c rowAt: 1) at: 2) = 0].
	self should: [ ((c rowAt: 1) at: 3) = 0].
	self should: [ ((c rowAt: 2) at: 1) = 0].
	self should: [ ((c rowAt: 2) at: 2) = 1].
	self should: [ ((c rowAt: 2) at: 3) = 0].
	self should: [ ((c rowAt: 3) at: 1) = 0].
	self should: [ ((c rowAt: 3) at: 2) = 0].
	self should: [ ((c rowAt: 3) at: 3) = 1].!

testMatrixOperation
	"Code Example 8.1"
	| a b c |
	a := DhbMatrix rows: #( ( 1 0 1) (-1 -2 3)).
	b := DhbMatrix rows: #( ( 1 2 3) (-2 1 7) (5 6 7)).
	c := a * b.
	self should: [ c numberOfRows = 2].
	self should: [ c numberOfColumns = 3].
	self should: [ ((c rowAt: 1) at: 1) = 6].
	self should: [ ((c rowAt: 1) at: 2) = 8].
	self should: [ ((c rowAt: 1) at: 3) = 10].
	self should: [ ((c rowAt: 2) at: 1) = 18].
	self should: [ ((c rowAt: 2) at: 2) = 14].
	self should: [ ((c rowAt: 2) at: 3) = 4].!

testVectorMatrixOperation
	"Code Example 8.1"
	| a u v |
	a := DhbMatrix rows: #( ( 1 0 1) (-1 -2 3)).
	u := #(1 2 3) asVector.
	v := a * u.
	self should: [ v size = 2].
	self should: [ (v at: 1) = 4].
	self should: [ (v at: 2) = 4].!

testVectorOperation
	"Code Example 8.1"
	| u v w |
	u := #(1 2 3) asVector.
	v := #(3 4 5) asVector.
	w := 4 * u + (3 * v).
	self should: [ w size = 3].
	self should: [ (w at: 1) = 13].
	self should: [ (w at: 2) = 20].
	self should: [ (w at: 3) = 27].!

testVectorOperationInverse

	| u v w |
	u := #(1 2 3) asVector.
	v := #(3 4 5) asVector.
	w := v * 4 - (3 * u).
	self should: [ w size = 3].
	self should: [ (w at: 1) = 9].
	self should: [ (w at: 2) = 10].
	self should: [ (w at: 3) = 11].!

testVectorProduct
	"Code Example 8.1"
	| u v |
	u := #(1 2 3) asVector.
	v := #(3 4 5) asVector.
	self should: [ u * v = 26].!

testVectorTransposeMatrixOperation
	"Code Example 8.1"
	| c v w |
	c := DhbMatrix rows: #( ( 6 8 10) (18 14 4)).
	v := #(4 4) asVector.
	w := c transpose * v.
	self should: [ w size = 3].
	self should: [ (w at: 1) = 96].
	self should: [ (w at: 2) = 88].
	self should: [ (w at: 3) = 56].! !

!DhbNumericalMethodsTestCase methodsFor: 'optimization'!

testOptimize
	"General optimizer to test genetic algorithm"
	| fBlock finder result |
	fBlock := [ :x | |r| r := x * x. r = 0 ifTrue: [ 1] ifFalse: [ r sqrt sin / r] ].
	finder := DhbMultiVariableGeneralOptimizer maximizingFunction: fBlock.
	finder desiredPrecision: 1.0e-6.
	finder origin: #( 0.5 1.0 0.5) asVector; range: #(2 2 2) asVector.
	result := finder evaluate.
	self should: [ finder precision < 1.0e-6].
	self should: [ (result at: 1) abs < 1.0e-6].
	self should: [ (result at: 2) abs < 1.0e-6].
	self should: [ (result at: 3) abs < 1.0e-6].!

testOptimizeOneDimension
	"Code example 11.1"
	| distr finder maximum |
	distr := DhbGammaDistribution shape: 2 scale: 5.
	finder := DhbOneVariableFunctionOptimizer maximizingFunction: distr.
	finder desiredPrecision: 1.0e-6.
	maximum := finder evaluate.
	self should: [ ( maximum - 5) abs < 1.0e-6].
	self should: [ finder precision < 1.0e-6].!

testOptimizePowell
	"Code example 11.3"
	| fBlock hillClimber educatedGuess result |
	fBlock := [ :x | (x * x) negated exp].
	educatedGuess := #( 0.5 1.0 0.5) asVector.
	hillClimber := DhbHillClimbingOptimizer maximizingFunction: fBlock.
	hillClimber initialValue: educatedGuess.
	hillClimber desiredPrecision: 1.0e-6.
	result := hillClimber evaluate.
	self should: [ hillClimber precision < 1.0e-6].
	self should: [ (result at: 1) abs < 1.0e-6].
	self should: [ (result at: 2) abs < 1.0e-6].
	self should: [ (result at: 3) abs < 1.0e-6].!

testOptimizeSimplex
	"Code example 11.5"
	| fBlock simplex educatedGuess result |
	fBlock := [ :x | (x * x) negated exp].
	educatedGuess := #( 0.5 1.0 0.5) asVector.
	simplex := DhbSimplexOptimizer maximizingFunction: fBlock.
	simplex initialValue: educatedGuess.
	simplex desiredPrecision: 1.0e-6.
	result := simplex evaluate.
	self should: [ simplex precision < 1.0e-6].
	self should: [ (result at: 1) abs < 1.0e-6].
	self should: [ (result at: 2) abs < 1.0e-6].
	self should: [ (result at: 3) abs < 1.0e-6].! !

!DhbNumericalMethodsTestCase methodsFor: 'statistics'!

testGammaDistribution
	| dist |
	dist := DhbGammaDistribution shape: 3.4 scale: 1.7.
	self should: [ (dist average - (3.4 * 1.7)) abs < 0.000000001].
	self should: [ (dist standardDeviation - (3.4 sqrt *1.7)) abs < 0.000000001].
	self should: [ ((dist value: 4.5) - 0.1446067652) abs < 0.000000001].
	self should: [ ((dist distributionValue: 4.5) - 0.3982869736) abs < 0.000000001].!

testHistogram
	| histogram |
	histogram := DhbHistogram new.
	histogram setRangeFrom: 0.0 to: 48.0 bins: 8.
	#( 36 13 27 16 33 24 4 20 15 23 37 23 31 15 47 22  6 15 41 22  14 14  31 42 3 42 22 8  37 41 )
		do: [ :x | histogram accumulate: x].
	histogram accumulate: -1; accumulate: 55; accumulate: 56.
	self should: [ histogram count = 30].
	self should: [ histogram underflow = 1].
	self should: [ histogram overflow = 2].
	self should: [ ( histogram countAt: 1) = 3].
	self should: [ ( histogram countAt: 8.5) = 4].
	self should: [ ( histogram countAt: 16) = 8].
	self should: [ ( histogram countAt: 23.5) = 4].
	self should: [ ( histogram countAt: 31) = 6].
	self should: [ ( histogram countAt: 38.5) = 4].
	self should: [ ( histogram countAt: 46) = 1].
	self should: [ (histogram average - 24.1333333333) abs < 0.000000001].
	self should: [ (histogram standardDeviation - 12.461619237603) abs < 0.000000001].
	self should: [ (histogram skewness - 0.116659884676) abs < 0.000000001].
	self should: [ (histogram kurtosis + 1.004665562311) abs < 0.000000001].!

testNormalDistribution
	| dist |
	dist := DhbNormalDistribution new: 3.4 sigma: 1.7.
	self should: [ (dist average - 3.4) abs < 0.000000001].
	self should: [ (dist standardDeviation - 1.7) abs < 0.000000001].
	self should: [ ((dist value: 4.5) - 0.1903464693) abs < 0.000000001].
	self should: [ ((dist distributionValue: 4.5) - 0.7412031298) abs < 0.000000001].!

testStatisticalMoments
	"comment"
	| accumulator |
	accumulator := DhbStatisticalMoments new.
	#( 36 13 27 16 33 24 4 20 15 23 37 23 31 15 47 22  6 15 41 22  14 14  31 42 3 42 22 8  37 41 )
		do: [ :x | accumulator accumulate: x].
	self should: [ (accumulator average - 24.1333333333) abs < 0.000000001].
	self should: [ (accumulator standardDeviation - 12.461619237603) abs < 0.000000001].
	self should: [(accumulator skewness - 0.116659884676) abs < 0.000000001].
	self should: [ (accumulator kurtosis + 1.004665562311) abs < 0.000000001].!

testStatisticalMomentsFast

	| accumulator |
	accumulator := DhbFastStatisticalMoments new.
	#( 36 13 27 16 33 24 4 20 15 23 37 23 31 15 47 22  6 15 41 22  14 14  31 42 3 42 22 8  37 41 )
		do: [ :x | accumulator accumulate: x].
	self should: [ (accumulator average - 24.1333333333) abs < 0.000000001].
	self should: [ (accumulator standardDeviation - 12.461619237603) abs < 0.000000001].
	self should: [ (accumulator skewness - 0.116659884676) abs < 0.000000001].
	self should: [ (accumulator kurtosis + 1.004665562311) abs < 0.000000001].!

testStatisticalMomentsFixed

	| accumulator |
	accumulator := DhbFixedStatisticalMoments new.
	#( 36 13 27 16 33 24 4 20 15 23 37 23 31 15 47 22  6 15 41 22  14 14  31 42 3 42 22 8  37 41 )
		do: [ :x | accumulator accumulate: x].
	self should: [ (accumulator average - 24.1333333333) abs < 0.000000001].
	self should: [ (accumulator standardDeviation - 12.461619237603) abs < 0.000000001].
	self should: [ (accumulator skewness - 0.116659884676) abs < 0.000000001].
	self should: [ (accumulator kurtosis + 1.004665562311) abs < 0.000000001].! !

!DhbNumericalMethodsTestCase methodsFor: 'privateMethods'!

accumulateAround: aVector size: aNumber into: aCollection
	"Private - Generate a random point around the given center and insert it into the collection.
					aNumber is the sigma for the distance to the center"
	| r phi psi localVector |

	r := ( DhbNormalDistribution new: 0 sigma: aNumber) random.
	phi := Float pi random.
	psi := Float pi random.
	localVector := DhbVector new: 3.
	localVector at: 1 put: ( phi sin * psi sin * r );
					   at: 2 put: ( phi cos * psi sin * r );
					   at: 3 put: ( psi cos * r ).
	aCollection add: (localVector + aVector).!

generatedPoints: anInteger
	"Private - Generate random points into aCollection. 3 clusters are used"
	| centers results |
	centers := Array new: 3.
	centers at: 1 put: #( 200 200  200) asVector;
				 at: 2 put: #(-200 200  200) asVector;
				 at: 3 put: #( 200 200 -200) asVector.
	results := OrderedCollection new.
	anInteger timesRepeat: [ self accumulateAround: ( centers at: (3 random + 1)) size: 1 into: results].
	^results!

setUp
	"Reset the seed of the random numbers (to get consistent results)"
	DhbMitchellMooreGenerator reset: 0! !

