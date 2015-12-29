"Filed out from Dolphin Smalltalk XP"!

DhbIterativeProcess subclass: #DhbLargestEigenValueFinder
	instanceVariableNames: 'matrix eigenvector transposeEigenvector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLargestEigenValueFinder guid: (GUID fromString: '{E550028D-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLargestEigenValueFinder comment: ''!
!DhbLargestEigenValueFinder categoriesForClass!DHB Numerical! !
!DhbLargestEigenValueFinder methodsFor!

eigenvalue
	"Answer the eigen value found by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^result!

eigenvector
	"Answer the normalized eigen vector found by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^eigenvector * (1 / eigenvector norm)!

evaluateIteration
	"Iterate the product of the matrix of the eigen vector and the transpose.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	| oldEigenvalue |
	oldEigenvalue := result.
	transposeEigenvector := transposeEigenvector * matrix.
	transposeEigenvector := transposeEigenvector 
				* (1 / (transposeEigenvector at: 1)).
	eigenvector := matrix * eigenvector.
	result := eigenvector at: 1.
	eigenvector := eigenvector * (1 / result).
	^oldEigenvalue isNil 
		ifTrue: [2 * desiredPrecision]
		ifFalse: [(result - oldEigenvalue) abs]!

initialize: aMatrix
		"Defines the matrix for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	matrix := aMatrix.!

initializeIterations
	"Initialize the iterations (subclasses must write their own method and call this one last).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	eigenvector := DhbVector new: matrix numberOfRows.
	eigenvector atAllPut: 1.0.
	transposeEigenvector := DhbVector new: eigenvector size.
	transposeEigenvector atAllPut: 1.0!

nextLargestEigenValueFinder
	"Return an eigen value finder for the same eigen values of the receiver except the one found.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	| norm |
	norm := 1 / (eigenvector * transposeEigenvector).
	^self class 
		matrix: matrix * ((DhbSymmetricMatrix identity: eigenvector size) 
						- (eigenvector * norm tensorProduct: transposeEigenvector))
		precision: desiredPrecision! !
!DhbLargestEigenValueFinder categoriesFor: #eigenvalue!information!public! !
!DhbLargestEigenValueFinder categoriesFor: #eigenvector!information!public! !
!DhbLargestEigenValueFinder categoriesFor: #evaluateIteration!operation!public! !
!DhbLargestEigenValueFinder categoriesFor: #initialize:!initialization!public! !
!DhbLargestEigenValueFinder categoriesFor: #initializeIterations!operation!public! !
!DhbLargestEigenValueFinder categoriesFor: #nextLargestEigenValueFinder!creation!public! !

!DhbLargestEigenValueFinder class methodsFor!

defaultMaximumIterations
		"Private - Answers the default maximum number of iterations for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^100!

matrix: aMatrix
		"Create a new instance of the receiver for a given matrix and default precision.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^( self new) initialize: aMatrix; yourself!

matrix: aMatrix precision: aNumber
		"Create a new instance of the receiver for a given matrix and desired precision.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^( self new) initialize: aMatrix; desiredPrecision: aNumber; yourself! !
!DhbLargestEigenValueFinder class categoriesFor: #defaultMaximumIterations!information!public! !
!DhbLargestEigenValueFinder class categoriesFor: #matrix:!creation!public! !
!DhbLargestEigenValueFinder class categoriesFor: #matrix:precision:!creation!public! !

