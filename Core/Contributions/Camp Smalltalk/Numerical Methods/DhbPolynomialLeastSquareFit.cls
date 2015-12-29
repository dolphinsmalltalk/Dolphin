"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbPolynomialLeastSquareFit
	instanceVariableNames: 'pointCollection degreePlusOne'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbPolynomialLeastSquareFit guid: (GUID fromString: '{E550026F-7D2B-11D6-B6CC-00022D5019C8}')!
DhbPolynomialLeastSquareFit comment: ''!
!DhbPolynomialLeastSquareFit categoriesForClass!DHB Numerical! !
!DhbPolynomialLeastSquareFit methodsFor!

accumulate: aWeightedPoint into: aVectorOfVectors and: aVector
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	| t p powers |
	p := 1.0.
	powers := aVector collect: [ :each | t := p. p := p * aWeightedPoint xValue. t].
	aVector accumulate: powers * ( aWeightedPoint yValue * aWeightedPoint weight).
	1 to: aVector size do:
		[ :k |
		  ( aVectorOfVectors at: k) accumulate: powers * ( ( powers at: k) * aWeightedPoint weight).
		].!

add: aWeightedPoint
		"Add a point to the collection of points.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^pointCollection add: aWeightedPoint!

computeEquations
		"Private - Answer a pair Matrix/Vector defining the system of equations
		 to solve the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	| rows vector |
	vector := ( DhbVector new: degreePlusOne) atAllPut: 0 ; yourself.
	rows := ( 1 to: degreePlusOne) collect: [ :k | ( DhbVector new: degreePlusOne) atAllPut: 0 ; yourself].
	pointCollection do:
		[ :each | self accumulate: each into: rows and: vector].
	^Array with: ( DhbSymmetricMatrix rows: rows) with: vector!

evaluate
		"Perform the least square fit and answers the fitted polynomial.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	| system errorMatrix |
	system := self computeEquations.
	errorMatrix := ( system at: 1) inverse.
	^( DhbEstimatedPolynomial coefficients: errorMatrix * (system at: 2))
			errorMatrix: errorMatrix;
			yourself!

initialize: anInteger
		"Private - Create an empty point collection for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^self initialize: anInteger on: OrderedCollection new!

initialize: anInteger on: aCollectionOfPoints
		"Private - Defines the collection of points for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	pointCollection := aCollectionOfPoints.
	degreePlusOne := anInteger + 1.
	^self! !
!DhbPolynomialLeastSquareFit categoriesFor: #accumulate:into:and:!public!transformation! !
!DhbPolynomialLeastSquareFit categoriesFor: #add:!public!transformation! !
!DhbPolynomialLeastSquareFit categoriesFor: #computeEquations!public!transformation! !
!DhbPolynomialLeastSquareFit categoriesFor: #evaluate!information!public! !
!DhbPolynomialLeastSquareFit categoriesFor: #initialize:!initialization!public! !
!DhbPolynomialLeastSquareFit categoriesFor: #initialize:on:!initialization!public! !

!DhbPolynomialLeastSquareFit class methodsFor!

new: anInteger
		"Create a new instance of the receiver with given degree.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^super new initialize: anInteger!

new: anInteger on: aCollectionOfPoints
		"Create a new instance of the receiver with given degree and points.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^super new initialize: anInteger on: aCollectionOfPoints! !
!DhbPolynomialLeastSquareFit class categoriesFor: #new:!creation!public! !
!DhbPolynomialLeastSquareFit class categoriesFor: #new:on:!creation!public! !

