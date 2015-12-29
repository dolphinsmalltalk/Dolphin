'From VisualWorks®, Release 3.0 of February 5, 1998 on June 10, 2002 at 3:26:13 pm'!



!Object methodsFor: 'testing'!

isNumber
	"Coerces numbers to true and everything else to false. Number 
	overrides with ^true"

	^false! !


!Rectangle methodsFor: 'dhb'!

positiveRectangle
		"(c) Copyrights Didier BESSET, 1998, all rights reserved
		 Initial code: 21/4/98 "
	^( origin min: corner) corner: ( origin max: corner)! !

Object subclass: #DhbMatrix
	instanceVariableNames: 'rows lupDecomposition '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbMatrix methodsFor: 'display'!

printOn: aStream
		"Append to the argument aStream, a sequence of characters that describes the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| first |
	first := true.
	rows do: 
		[ :each |
		  first ifTrue: [ first := false]
				 ifFalse:[ aStream cr].
		  each printOn: aStream.
		].! !

!DhbMatrix methodsFor: 'information'!

columnAt: anInteger
		"Answers the anInteger-th column of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows collect: [ :each | each at: anInteger]!

determinant
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	^self lupDecomposition determinant!

isSquare
		"Answers true if the number of rows is equal to the number of columns.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows size = rows last size!

isSymmetric
		"Answers false because the receiver is not a symmetric matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^false!

largestPowerOf2SmallerThan: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved
		 Initial code: 21/3/99 "
	| m m2|
	m := 2.
	[ m2 := m * 2.
	  m2 < anInteger] whileTrue:[ m := m2].
	^m!

lupDecomposition
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	lupDecomposition isNil
		ifTrue: [ lupDecomposition :=DhbLUPDecomposition equations: rows].
	^lupDecomposition!

numberOfColumns
		"Answer the number of rows of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows last size!

numberOfRows
		"Answer the number of rows of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows size!

rowAt: anInteger
		"Answers the anInteger-th row of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows at: anInteger!

rowAt: aRowIndex columnAt: aColumnIndex
		"Answers the aRowIndex-th, aColumnIndex-th entry in the receiver.
		 (c) Copyrights Joseph WHITESELL, 2001, all rights reserved.
		 Initial code: 08/17/2001 "
	^(rows at: aRowIndex) at: aColumnIndex!

rowAt: aRowIndex columnAt: aColumnIndex put: aValue
	
	^(rows at: aRowIndex) at: aColumnIndex put: aValue!

rows
	^rows!

transpose
		"Answer a new matrix, transpose of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self class rows: ( self columnsCollect: [ :each | each])! !

!DhbMatrix methodsFor: 'initialization'!

initialize: anInteger
		"Build empty components for a square matrix.
		  No check is made: components are assumed to be orgainized in rows.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	rows := ( 1 to: anInteger) asVector collect: [ :each | DhbVector new: anInteger].!

initializeRows: anArrayOrVector
		"Defines the components of the recevier.
		  No check is made: components are assumed to be orgainized in rows.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	rows := anArrayOrVector asVector collect: [ :each | each asVector].! !

!DhbMatrix methodsFor: 'iterators'!

columnsCollect: aBlock
		"Perform the collect: operation on the rows of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	^rows last collect: [ :each | n := n + 1. aBlock value: ( self columnAt: n)]!

columnsDo: aBlock
		"Perform the collect: operation on the rows of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	^rows last do: [ :each | n := n + 1. aBlock value: ( self columnAt: n)]!

rowsCollect: aBlock
		"Perform the collect: operation on the rows of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows collect: aBlock!

rowsDo: aBlock
		"Perform the collect: operation on the rows of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows do: aBlock! !

!DhbMatrix methodsFor: 'comparing'!

= aNumberOrMatrix 
	aNumberOrMatrix isNil ifTrue: [^false].
	aNumberOrMatrix isNumber ifTrue: [^(self numberOfRows = 1 and: [self numberOfColumns = 1])
			and: [(self rowAt: 1 columnAt: 1)
					= aNumberOrMatrix]].
	aNumberOrMatrix class = self class ifFalse: [^false].
	^self rows = aNumberOrMatrix rows!

hash
	^rows hash! !

!DhbMatrix methodsFor: 'operation'!

* aNumberOrMatrixOrVector
		"Answers the product of the receiver with the argument.
		 The argument can be a number, matrix or vector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aNumberOrMatrixOrVector productWithMatrix: self!

+ aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix addWithRegularMatrix: self!

- aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix subtractWithRegularMatrix: self!

inverse
	"Answer the inverse of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^self isSquare 
		ifTrue: [self lupInverse]
		ifFalse: [self squared inverse * self transpose]!

inversePureCRL
		"Answer the inverse of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/5/99 "
	^self squared inversePureCRL * self transpose!

lupInverse
	^self class rows: self lupDecomposition inverseMatrixComponents!

squared
		"Answers the product of the transpose of the receiver with the receiver (in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^DhbSymmetricMatrix rows: ( self columnsCollect: [ :col | self columnsCollect: [ :colT | col * colT]])!

strassenProductWithMatrix: aMatrix
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/5/99 "
	| matrixSplit selfSplit p1 p2 p3 p4 p5 p6 p7 |
	( self numberOfRows > 2 and: [ self numberOfColumns > 2])
		ifFalse:[ ^self class rows: ( aMatrix rowsCollect: [ :row | self columnsCollect: [ :col | row * col]])].
	selfSplit := self split.
	matrixSplit := aMatrix split.
	p1 := ( ( selfSplit at: 2) - ( selfSplit at: 4)) strassenProductWithMatrix: ( matrixSplit at: 1).
	p2 := ( selfSplit at: 4) strassenProductWithMatrix: ( ( matrixSplit at: 1) + ( matrixSplit at: 2)).
	p3 := ( selfSplit at: 1) strassenProductWithMatrix: ( ( matrixSplit at: 3) + ( matrixSplit at: 4)).
	p4 := ( ( selfSplit at: 3) - ( selfSplit at: 1)) strassenProductWithMatrix: ( matrixSplit at: 4).
	p5 := ( ( selfSplit at: 1) + ( selfSplit at: 4)) strassenProductWithMatrix: ( ( matrixSplit at: 1) + ( matrixSplit at: 4)).
	p6 := ( ( selfSplit at: 3) + ( selfSplit at: 4)) strassenProductWithMatrix: ( ( matrixSplit at: 2) - ( matrixSplit at: 4)).
	p7 := ( ( selfSplit at: 1) + ( selfSplit at: 2)) strassenProductWithMatrix: ( ( matrixSplit at: 1) - ( matrixSplit at: 3)).
	^self class join: ( Array
							with: ( p5 + p4 + p6 - p2)
							with: (p1 + p2)
							with: ( p3 + p4)
							with: ( p5 + p1 - p3 - p7)
							)! !

!DhbMatrix methodsFor: 'transformation'!

accumulate: aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	self rowsCollect: [ :each | n := n + 1. each accumulate: ( aMatrix rowAt: n)]!

accumulateNegated: aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	self rowsCollect: [ :each | n := n + 1. each accumulateNegated: ( aMatrix rowAt: n)]!

asSymmetricMatrix
		"Convert the receiver to a symmetric matrix (no check is made).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^DhbSymmetricMatrix rows: rows!

negate
		"Inverse the sign of all components of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	rows do: [ :each |each negate].!

scaleBy: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/11/00 "
	rows do: [ :each | each scaleBy: aNumber].!

split
		"Private - Answers an array of 4 matrices split from the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/5/99 "
	| n m n1 m1 |
	n := self numberOfRows.
	m := self numberOfColumns.
	n1 := self largestPowerOf2SmallerThan: n.
	m1 := self largestPowerOf2SmallerThan: m.
	^Array
		with: ( self class rows: ( ( 1 to: n1) asVector collect: [ :k | ( rows at: k) copyFrom: 1 to: m1]))
		with:( self class rows: ( ( 1 to: n1) asVector collect: [ :k | ( rows at: k) copyFrom: (m1 + 1) to: m]))
		with: ( self class rows: ( ( (n1 + 1) to: n) asVector collect: [ :k | ( rows at: k) copyFrom: 1 to: m1]))
		with:( self class rows: ( ( (n1 + 1) to: n) asVector collect: [ :k | ( rows at: k) copyFrom: (m1 + 1) to: m]))! !

!DhbMatrix methodsFor: 'double dispatching'!

addWithMatrix: aMatrix class: aMatrixClass
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	^aMatrixClass rows: ( self rowsCollect: [ :each | n := n + 1. each + ( aMatrix rowAt: n)])!

addWithRegularMatrix: aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix addWithMatrix: self class: aMatrix class!

addWithSymmetricMatrix: aMatrix
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/28/99 "
	^aMatrix addWithMatrix: self class: self class!

productFromDouble: aDouble 
	^self * aDouble!

productFromFixedPoint: aFixedPoint 
	^self * aFixedPoint!

productFromFraction: aFraction 
	^self * aFraction!

productFromInteger: anInteger 
	^self * anInteger!

productWithMatrix: aMatrix
		"Answers the product of aMatrix with the receiver (in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self productWithMatrixFinal: aMatrix!

productWithMatrixFinal: aMatrix
		"Answers the product of aMatrix with the receiver (in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self class rows: ( aMatrix rowsCollect: [ :row | self columnsCollect: [ :col | row * col]])!

productWithSymmetricMatrix: aSymmetricMatrix
		"Answers the product of the receiver with aSymmetricMatrix (in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self class rows: ( self rowsCollect: [ :row | aSymmetricMatrix columnsCollect: [ :col | row * col]])!

productWithTransposeMatrix: aMatrix
		"Answers the product of the receiver with the transpose of aMatrix(in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self class rows: ( self rowsCollect: [ :row | aMatrix rowsCollect: [ :col | row * col]])!

productWithVector: aVector
		"Answers the product of the receiver with aVector
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self columnsCollect: [ :each | each * aVector]!

subtractWithMatrix: aMatrix class: aMatrixClass
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	^aMatrixClass rows: ( self rowsCollect: [ :each | n := n + 1. each - ( aMatrix rowAt: n)])!

subtractWithRegularMatrix: aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix subtractWithMatrix: self class: aMatrix class!

subtractWithSymmetricMatrix: aMatrix
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/28/99 "
	^aMatrix subtractWithMatrix: self class: self class!

transposeProductWithMatrix: aMatrix
		"Answers the product of the transpose of the receiver with aMatrix (in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self class rows: ( self columnsCollect: [ :row | aMatrix columnsCollect: [ :col | row * col]])! !

DhbMatrix class
	instanceVariableNames: ''!



!DhbMatrix class methodsFor: 'information'!

lupCRLCriticalDimension
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	^40! !

!DhbMatrix class methodsFor: 'creation'!

join: anArrayOfMatrices
		"Inverse of the split operation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/5/99 "
	| rows n row rowSize n1 n2 |
	rows := OrderedCollection new.
	n1 := ( anArrayOfMatrices at: 1) numberOfColumns.
	n2 := n1 + 1.
	rowSize := n1 + ( anArrayOfMatrices at: 2) numberOfColumns.
	n := 0.
	( anArrayOfMatrices at: 1) rowsDo:
		[ :each |
		  n := n + 1.
		  row := DhbVector new: rowSize.
		  row replaceFrom: 1 to: n1 with: each startingAt: 1;
			  replaceFrom: n2 to: rowSize with: ( ( anArrayOfMatrices at: 2) rowAt: n) startingAt: 1.
		  rows add: row.
		].
	n := 0.
	( anArrayOfMatrices at: 3) rowsDo:
		[ :each |
		  n := n + 1.
		  row := DhbVector new: rowSize.
		  row replaceFrom: 1 to: n1 with: each startingAt: 1;
			  replaceFrom: n2 to: rowSize with: ( ( anArrayOfMatrices at: 4) rowAt: n) startingAt: 1.
		  rows add: row.
		].
	^self rows: rows!

new: anInteger
		"Create an empty square matrix of dimension anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self new initialize: anInteger!

rows: anArrayOrVector
		"Create a new matrix with given components.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self new initializeRows: anArrayOrVector! !

Object subclass: #DhbHistogram
	instanceVariableNames: 'minimum binWidth overflow underflow moments contents freeExtent cacheSize desiredNumberOfBins '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbHistogram methodsFor: 'information'!

average
		"Answer the average of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments average!

binIndex: aNumber
		"Answers the index of the bin corresponding to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^( ( aNumber - minimum) / binWidth) floor + 1!

binWidth
		"Answer the bin width for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifTrue: [ self flushCache].
	^binWidth!

chi2Against: aScaledDistribution
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/30/00 "
	| chi2 |
	chi2 := 0.
	self pointsAndErrorsDo:
		[ :each | chi2 := ( each chi2Contribution: aScaledDistribution) + chi2].
	^chi2!

chi2ConfidenceLevelAgainst: aScaledDistribution
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/30/00 "
	^( DhbChiSquareDistribution degreeOfFreedom: ( contents size - aScaledDistribution parameters size))
			confidenceLevel: ( self chi2Against: aScaledDistribution)!

collectIntegralPoints: aBlock
		"Collects the points needed to display the receiver as an integral.
		 Needed to use polymorphic behavior when plotting the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	| answer bin lastContents integral norm x |
	self isCached
		ifTrue: [ self flushCache].
	answer := OrderedCollection new: ( contents size * 2 + 1).
	bin := self minimum.
	answer add: ( aBlock value: bin @ 0).
	integral := self underflow.
	norm := self totalCount.
	contents do:
		[ :each |
		  integral := integral + each.
		  x := integral / norm.
		  answer add: ( aBlock value: bin @ x).
		  bin := bin + binWidth.
		  answer add: ( aBlock value: bin @ x).
		].
	answer add: ( aBlock value: bin @ 0).
	^answer asArray!

collectPoints: aBlock
		"Collects the points needed to display the receiver.
		 Needed to use polymorphic behavior when plotting the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	| answer bin lastContents |
	self isCached
		ifTrue: [ self flushCache].
	answer := OrderedCollection new: ( contents size * 2 + 1).
	bin := self minimum.
	answer add: ( aBlock value: bin @ 0).
	contents do:
		[ :each |
		  answer add: ( aBlock value: bin @ each).
		  bin := bin + binWidth.
		  answer add: ( aBlock value: bin @ each).
		].
	answer add: ( aBlock value: bin @ 0).
	^answer asArray!

count
		"Answer the count of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments count!

countAt: aNumber
		"Answer the count in the bin corresponding to aNumber or 0 if outside the limits.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	| n |
	n := self binIndex: aNumber.
	^( n between: 1 and: contents size)
			ifTrue: [ contents at: n]
			ifFalse:[ 0]!

countsBetween: aNumber1 and: aNumber2
		"Computes the events located between aNumber1 and aNumber2.
		 NOTE: This method assumes the two numbers are within the limits
			   of the receiver and that the receiver is not cached.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	| n1 n2 answer |
	n1 := self binIndex: aNumber1.
	n2 := self binIndex: aNumber2.
	answer := ( contents at: n1) * ( ( binWidth * n1 + minimum) - aNumber1) / binWidth.
	n2 > contents size
		ifTrue: [ n2 := contents size + 1]
		ifFalse:[ answer := answer + ( ( contents at: n2) * ( aNumber2 - ( binWidth * ( n2 - 1) + self maximum)) / binWidth)].
	( n1 + 1) to: ( n2 - 1) do: [ :n | answer := answer + ( contents at: n)].
	^answer!

countsUpTo: aNumber
		"Computes the events located up to aNumber.
		 NOTE: This method assumes aNumber is within the limits
					 of the receiver and that the receiver is not cached.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	| n answer |
	n := self binIndex: aNumber.
	n > contents size
		ifTrue: [ ^self count].
	answer := ( contents at: n) * ( aNumber - ( binWidth * ( n - 1) + self minimum)) / binWidth.
	1 to: ( n - 1) do: [ :m | answer := answer + ( contents at: m)].
	^answer + underflow!

errorOnAverage
		"Answer the error on the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments errorOnAverage!

inverseDistributionValue: aNumber
		"Private - Compute the value which corresponds to a integrated count of aNumber.
		 NOTE: aNumber is assumed to be between 0 and 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	| count x integral |
	count := self count * aNumber.
	x := self minimum.
	integral := 0.
	contents do:
		[ :each | | delta |
		  delta := count - integral.
		  each > delta
			ifTrue: [ ^self binWidth * delta / each + x].
		  integral := integral + each.
		  x := self binWidth + x.
		].
	^self maximum!

isCached
		"Private - Answer true if the content of the receiver is cached.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^binWidth isNil!

isEmpty
		"Always false. 
		 Needed to use polymorphic behavior when plotting the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^false!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments kurtosis!

lowBinLimitAt: anInteger
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^( anInteger - 1) * binWidth + minimum!

maximum
		"Answer the minimum for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifTrue: [ self flushCache].
	^contents size * binWidth + minimum!

maximumCount
		"Answer the maximum count of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	self isCached
		ifTrue: [ self flushCache].
	^contents inject: ( contents isEmpty ifTrue: [ 1] ifFalse:[ contents at: 1])
					into: [ :max :each | max max: each]!

minimum
		"Answer the minimum for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifTrue: [ self flushCache].
	^minimum!

overflow
		"Answer the overflow of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^overflow!

roundToScale: aNumber
	"Private - Adjust aNumber of the lowest upper scale"
	| orderOfMagnitude norm scales rValue |
	orderOfMagnitude := ( aNumber log: 10) floor.
	scales := self class scales.
	aNumber isInteger
		ifTrue: [ orderOfMagnitude < 1
						ifTrue: [ orderOfMagnitude := 1].
					  orderOfMagnitude = 1
						ifTrue: [ scales := self class integerScales].
					  orderOfMagnitude = 2
						ifTrue: [ scales := self class semiIntegerScales].
				    ].
	norm := 10 raisedToInteger: orderOfMagnitude.
	rValue := aNumber / norm.
	^( scales detect: [ :each | rValue <= each]) * norm!

skewness
		"Answer the skewness of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments skewness!

standardDeviation
		"Answer the standardDeviation of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments standardDeviation!

totalCount
		"Answer the count of the recevier, inclusing underflow and overflow
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments count + underflow + overflow!

underflow
		"Answer the underflow of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^underflow!

unnormalizedVariance
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	^moments unnormalizedVariance!

variance
		"Answer the variance of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments variance! !

!DhbHistogram methodsFor: 'initialization'!

freeExtent: aBoolean
		"Defines the range of the receiver to be freely adjustable.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	( underflow = 0 and: [ overflow = 0])
		ifFalse: [ self error: 'Histogram extent cannot be redefined'].
	freeExtent := aBoolean.!

initialize
		"Private - initializes the receiver with standard settings.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	freeExtent := false.
	cacheSize := self class defaultCacheSize.
	desiredNumberOfBins := self class defaultNumberOfBins.
	contents := OrderedCollection new: cacheSize.
	moments := DhbFixedStatisticalMoments new.
	overflow := 0.
	underflow := 0.
	^self!

setDesiredNumberOfBins: anInteger
		"Defines the desired number of bins. It may be adjusted to a few units later on.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	anInteger > 0
		ifFalse:[ self error: 'Desired number of bins must be positive'].
	desiredNumberOfBins := anInteger.!

setRangeFrom: aNumber1 to: aNumber2 bins: anInteger
		"Defines the range of the receiver by specifying the minimum, maximum and number of bins.
		 Values are adjusted to correspond to a reasonable value for the bin width and the limits.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifFalse: [ self error: 'Histogram limits cannot be redefined'].
	minimum := aNumber1.
	self setDesiredNumberOfBins: anInteger;
		   adjustDimensionUpTo: aNumber2.!

setWidth: aNumber1 from: aNumber2 bins: anInteger
		"Defines the range of the receiver by specifying the minimum, bin width and number of bins.
		 Values are adjusted to correspond to a reasonable value for the bin width and the limits.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifFalse: [ self error: 'Histogram limits cannot be redefined'].
	minimum := aNumber2.
	self setDesiredNumberOfBins: anInteger;
		   adjustDimensionUpTo: ( aNumber1 * anInteger + aNumber2).! !

!DhbHistogram methodsFor: 'iterators'!

pointsAndErrorsDo: aBlock
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	| x |
	x := self minimum - ( self binWidth / 2).
	contents do:
		[ :each |
		  x := x + self binWidth.
		  aBlock value: ( DhbWeightedPoint point: x count: each).
		].! !

!DhbHistogram methodsFor: 'testing'!

fConfidenceLevel: aStatisticalMomentsOrHistogram
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	^moments fConfidenceLevel: aStatisticalMomentsOrHistogram!

tConfidenceLevel: aStatisticalMomentsOrHistogram
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	^moments tConfidenceLevel: aStatisticalMomentsOrHistogram! !

!DhbHistogram methodsFor: 'transformation'!

accumulate: aNumber
		"Accumulate aNumber into the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| bin |
	self isCached
		ifTrue: [ ^self accumulateInCache: aNumber].
	bin := self binIndex: aNumber.
	( bin between: 1 and: contents size)
		ifTrue: [ contents at: bin put: ( contents at: bin) + 1.
					 moments accumulate: aNumber.
				   ]
		ifFalse:[ self processOverflows: bin for: aNumber].!

accumulateInCache: aNumber
		"Private - Accumulate aNumber inside a cache
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	contents add: aNumber.
	contents size > cacheSize
		ifTrue: [ self flushCache].!

adjustDimensionUpTo: aNumber
		"Private - Compute an adequate bin width and adjust the minimum and number of bins accordingly.
		 aNumber is the maximum value to accumulate. The minimum value has already been assigned.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	| maximum |
	binWidth := self roundToScale: ( aNumber - minimum) / desiredNumberOfBins.
	minimum := ( minimum / binWidth) floor * binWidth.
	maximum := ( aNumber / binWidth) ceiling * binWidth.
	contents := Array new: ( ( maximum - minimum) / binWidth) ceiling.
	contents atAllPut: 0.!

countOverflows: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	anInteger > 0
		ifTrue: [ overflow := overflow + 1]
		ifFalse:[ underflow := underflow + 1].!

flushCache
	"Private - 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 15/2/99"

	| maximum values |
	minimum isNil ifTrue: [minimum := contents isEmpty
					ifTrue: [0]
					ifFalse: [contents first]].
	maximum := minimum.
	contents do: [:each | each < minimum
			ifTrue: [minimum := each]
			ifFalse: [each > maximum ifTrue: [maximum := each]]].
	maximum = minimum ifTrue: [maximum := minimum + desiredNumberOfBins].
	values := contents.
	self adjustDimensionUpTo: maximum.
	values do: [:each | self accumulate: each]!

growContents: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	anInteger > 0
		ifTrue: [ self growPositiveContents: anInteger]
		ifFalse:[ self growNegativeContents: anInteger].!

growNegativeContents: anInteger 
	"Private - 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 15/2/99"

	| n newSize newContents |
	n := 1 - anInteger.
	newSize := contents size + n.
	newContents := Array new: newSize.
	newContents at: 1 put: 1.
	2 to: n do: [:i | newContents at: i put: 0].
	newContents
		replaceElementsFrom: n + 1
		to: newSize
		withArray: contents
		startingAt: 1.
	contents := newContents.
	minimum := anInteger - 1 * binWidth + minimum!

growPositiveContents: anInteger 
	"Private - 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 15/2/99"

	| n newContents |
	n := contents size.
	newContents := Array new: anInteger.
	newContents
		replaceElementsFrom: 1
		to: n
		withArray: contents
		startingAt: 1.
	n + 1 to: anInteger - 1 do: [:i | newContents at: i put: 0].
	newContents at: anInteger put: 1.
	contents := newContents!

processOverflows: anInteger for: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	freeExtent
		ifTrue: [ self growContents: anInteger.
					 moments accumulate: aNumber
				   ]
		ifFalse:[ self countOverflows: anInteger].! !

DhbHistogram class
	instanceVariableNames: ''!



!DhbHistogram class methodsFor: 'creation'!

new
		"Create a standard new instance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize! !

!DhbHistogram class methodsFor: 'information'!

defaultCacheSize
		"Private - Answer the default cache size.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^100!

defaultNumberOfBins
		"Private - Defines the default number of bins for instances of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^50!

integerScales
	"Private - Scales for strict integers"
	^#( 2 4 5 8 10)!

scales
	"Private - Scales for any number"
	^#( 1.25 2 2.5 4 5 7.5 8 10)!

semiIntegerScales
	"Private - Scales for large integers"
	^#( 2 2.5 4 5 7.5 8 10)! !

Object subclass: #DhbPolynomial
	instanceVariableNames: 'coefficients '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbPolynomial methodsFor: 'initialization'!

initialize: anArray
		"Private - Initialize the coefficients of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	coefficients := anArray.
	^self! !

!DhbPolynomial methodsFor: 'information'!

at: anInteger
		"Answers the coefficient of order anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^anInteger < coefficients size
		ifTrue: [ coefficients at: ( coefficients size - anInteger)]
		ifFalse:[ 0]!

coefficients
	"(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 21/5/99"

	^coefficients reverse!

degree
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^coefficients size - 1!

roots
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 20/4/99 "
	^self roots: DhbFloatingPointMachine new defaultNumericalPrecision!

roots: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 20/4/99 "
	| pol roots x rootFinder |
	rootFinder := DhbNewtonZeroFinder new.
	rootFinder desiredPrecision: aNumber.
	pol := self class coefficients: ( coefficients reverse collect: [ :each | each asFloat]).
	roots := OrderedCollection new: self degree.
	[ rootFinder setFunction: pol; setDerivative: pol derivative.
	  x := rootFinder evaluate.
	  rootFinder hasConverged
		] whileTrue: [ roots add: x. 
					   pol := pol deflatedAt: x. 
					   pol degree > 0
						 ifFalse: [ ^roots].
					 ].
	^roots!

value: aNumber
		"Answer the value of the polynomial for the specified variable value.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	^coefficients inject: 0 into: [ :sum :each | sum * aNumber + each]! !

!DhbPolynomial methodsFor: 'creation'!

deflatedAt: aNumber
		"Answers a new polynomial quotient of the receiver with polynomial (X-aNumber)
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 20/4/99 "
	| remainder next newCoefficients|
	remainder := 0.
	newCoefficients := coefficients collect:
						[ :each |
						  next := remainder. 
						  remainder := remainder * aNumber + each.
						  next].
	^self class coefficients: ( newCoefficients copyFrom: 2 to: newCoefficients size) reverse!

derivative
		"Answer a new polynomial, derivative of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	| n |
	n := coefficients size.
	^self class coefficients: ( ( coefficients collect: [ :each | n := n - 1. each * n]) reverse copyFrom: 2 to: coefficients size)!

integral
		"Answer a new polynomial, integral of the receiver with value 0 at x=0.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	^self integral: 0!

integral: aValue
		"Answer a new polynomial, integral of the receiver with given value at x=0.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	| n |
	n := coefficients size + 1.
	^self class coefficients: ( ( coefficients collect: [ :each | n := n - 1. each / n]) copyWith: aValue) reverse! !

!DhbPolynomial methodsFor: 'operation'!

* aNumberOrPolynomial
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^aNumberOrPolynomial timesPolynomial: self!

+ aNumberOrPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^aNumberOrPolynomial addPolynomial: self!

- aNumberOrPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^aNumberOrPolynomial subtractToPolynomial: self!

/ aNumberOrPolynomial
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^aNumberOrPolynomial dividingPolynomial: self! !

!DhbPolynomial methodsFor: 'comparing'!

= aNumberOrPolynomial 
	aNumberOrPolynomial isNil ifTrue: [^false].
	aNumberOrPolynomial isNumber ifTrue: [^coefficients size = 1 and: [coefficients first = aNumberOrPolynomial]].
	aNumberOrPolynomial class = self class ifFalse: [^false].
	^self coefficients = aNumberOrPolynomial coefficients!

hash
	^coefficients hash! !

!DhbPolynomial methodsFor: 'display'!

printOn: aStream 
	"Append to aStream a written representation of the receiver. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 4/1/99"

	| n firstNonZeroCoefficientPrinted |
	n := 0.
	firstNonZeroCoefficientPrinted := false.
	coefficients
		reverseDo: 
			[:each | 
			each = 0
				ifFalse: 
					[firstNonZeroCoefficientPrinted
						ifTrue: 
							[aStream space.
							each < 0 ifFalse: [aStream nextPut: $+].
							aStream space]
						ifFalse: [firstNonZeroCoefficientPrinted := true].
					(each = 1 and: [n > 0])
						ifFalse: [each printOn: aStream].
					n > 0
						ifTrue: 
							[aStream nextPutAll: ' X'.
							n > 1
								ifTrue: 
									[aStream nextPut: $^.
									n printOn: aStream]]].
			n := n + 1]! !

!DhbPolynomial methodsFor: 'double dispatching'!

addNumber: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	| newCoefficients |
	newCoefficients := coefficients reverse.
	newCoefficients at: 1 put: newCoefficients first + aNumber.
	^self class coefficients: newCoefficients!

addPolynomial: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^self class coefficients: ( ( 0 to: (self degree max: aPolynomial degree)) collect: [ :n | ( aPolynomial at: n) + ( self at: n)])!

differenceFromDouble: aDouble 
	^self subtractFrom: aDouble!

differenceFromFixedPoint: aFixedPoint 
	^self subtractFrom: aFixedPoint!

differenceFromFraction: aFraction 
	^self subtractFrom: aFraction!

differenceFromInteger: anInteger 
	^self subtractFrom: anInteger!

dividingPolynomial: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^( self dividingPolynomialWithRemainder: aPolynomial) first!

dividingPolynomialWithRemainder: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	| remainderCoefficients quotientCoefficients n m norm quotientDegree |
	n := self degree.
	m := aPolynomial degree.
	quotientDegree := m - n.
	quotientDegree < 0
		ifTrue: [ ^Array with: ( self class new: #(0)) with: aPolynomial].
	quotientCoefficients := Array new: quotientDegree + 1.
	remainderCoefficients := ( 0 to: m) collect: [ :k | aPolynomial at: k].
	norm := 1 / coefficients first.
	quotientDegree to: 0 by: -1
		do: [ :k | | x |
			  x := ( remainderCoefficients at: n + k + 1) * norm.
			  quotientCoefficients at: (quotientDegree + 1 - k) put: x.
			  (n + k - 1) to: k by: -1
				do: [ :j | 
				remainderCoefficients at: j + 1 put: 
							( ( remainderCoefficients at: j + 1) - ( x * (self at: j - k)))
				].
			].
	^Array with: ( self class coefficients: quotientCoefficients reverse)
		   with: ( self class coefficients: ( remainderCoefficients copyFrom: 1 to: n))!

productFromDouble: aDouble 
	^self * aDouble!

productFromFixedPoint: aFixedPoint 
	^self * aFixedPoint!

productFromFraction: aFraction 
	^self * aFraction!

productFromInteger: anInteger 
	^self * anInteger!

subtractFrom: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	| newCoefficients |
	newCoefficients := ( coefficients collect: [ :c | c negated]) reverse.
	newCoefficients at: 1 put: newCoefficients first + aNumber.
	^self class coefficients: newCoefficients!

subtractToPolynomial: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^self class coefficients: ( ( 0 to: (self degree max: aPolynomial degree)) collect: [ :n | ( aPolynomial at: n) - ( self at: n)])!

sumFromDouble: aDouble 
	^self + aDouble!

sumFromFixedPoint: aFixedPoint 
	^self + aFixedPoint!

sumFromFraction: aFraction 
	^self + aFraction!

sumFromInteger: anInteger 
	^self + anInteger!

timesNumber: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^self class coefficients: ( coefficients reverse collect: [ :each | each * aNumber])!

timesPolynomial: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	| productCoefficients degree|
	degree := aPolynomial degree + self degree.
	productCoefficients := ( degree to: 0 by: -1)
			collect:[ :n | | sum |
					  sum := 0.
					  0 to: (degree - n)
						do: [ :k | sum := (self at: k) * (aPolynomial at: ( degree - n - k)) + sum].
					  sum
					].
	^self class coefficients: productCoefficients! !

DhbPolynomial class
	instanceVariableNames: ''!



!DhbPolynomial class methodsFor: 'creation'!

coefficients: anArray
		" Creates a new instance with given coefficients
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	^self new initialize: anArray reverse! !


!UndefinedObject methodsFor: 'dhb'!

ifNil: aBlock ifNot: aValuedBlock
		"(c) Copyrights Didier BESSET, all rights reserved
		 Initial code: 1/7/98 "
	^aBlock value!

ifNotNil: aBlock 
	^self! !

Object subclass: #DhbLinearEquationSystem
	instanceVariableNames: 'rows solutions '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLinearEquationSystem methodsFor: 'display'!

printOn: aStream
		"Append to the argument aStream, a sequence of characters that describes the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| first delimitingString n k |
	n := rows size.
	first := true.
	rows do:
		[ :row |
		  first ifTrue: [ first := false]
				 ifFalse:[ aStream cr].
		  delimitingString := '('.
		  k := 0.
		  row do:
			[ :each |
				aStream nextPutAll: delimitingString.
				each printOn: aStream.
				k := k + 1.
				delimitingString := k < n ifTrue: [ ' '] ifFalse: [ ' : '].
			].
		  aStream nextPut: $).
		].! !

!DhbLinearEquationSystem methodsFor: 'information'!

largestPivotFrom: anInteger
		"Private - Answers the largest pivot element in column anInteger, from position anInteger upward.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| valueOfMaximum indexOfMaximum |
	valueOfMaximum := ( rows at: anInteger) at: anInteger.
	indexOfMaximum := anInteger.
	( anInteger + 2) to: rows size do:
		[ :n |
		  ( ( rows at: n) at: anInteger) > valueOfMaximum
				ifTrue: [ valueOfMaximum := ( rows at: n) at: anInteger.
							 indexOfMaximum := n.
						   ].
		].
	^indexOfMaximum!

solution
		"Answers the solution corresponding to the first constant array.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	^self solutionAt: 1!

solutionAt: anInteger
		"Answer the solution corresponding to the anInteger-th constant array.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	"solutions isNil
		ifTrue: [ [self solve] when: Error do: [ :signal |solutions := 0. signal return: nil.] ].
	solutions = 0
		ifTrue: [ ^nil].
	( solutions at: anInteger) isNil
		ifTrue: [ self backSubstitutionAt: anInteger].
	^solutions at: anInteger"

	solutions isNil
		ifTrue: [ [self solve] on: Error do: [ :signal |solutions := 0. signal return: nil.] ].
	solutions = 0
		ifTrue: [ ^nil].
	( solutions at: anInteger) isNil
		ifTrue: [ self backSubstitutionAt: anInteger].
	^solutions at: anInteger! !

!DhbLinearEquationSystem methodsFor: 'initialization'!

initialize: anArrayOfArrays constants: anArrayOfConstantArrays
		"Private - Initialize the receiver with system's matrix in anArrayOfArrays and several constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	rows := anArrayOfArrays collect: [ :each | n := n + 1. each, ( anArrayOfConstantArrays collect: [ :c | c at: n])].
	^self! !

!DhbLinearEquationSystem methodsFor: 'transformation'!

backSubstitutionAt: anInteger
		"Private - Perform the back-substitution step corresponding to the anInteger-th constant array.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| size answer accumulator |
	size := rows size.
	answer := Array new: size.
	size to: 1 by: -1 do:
		[ :n |
		  accumulator := (rows at: n) at: (anInteger + size).
		  ( n + 1) to: size
			do: [ :m | accumulator := accumulator - ( ( answer at: m) * ( ( rows at: n) at: m))].
		  answer at: n put: ( accumulator / ( ( rows at: n) at: n)).
		].
	solutions at: anInteger put: answer.!

pivotAt: anInteger
		"Private - Performs pivot operation with pivot element at anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| inversePivot rowPivotValue row pivotRow |
	pivotRow := rows at: anInteger.
	inversePivot := 1 / ( pivotRow at: anInteger).
	( anInteger + 1) to: rows size do:
		[ :n |
		  row := rows at: n.
		  rowPivotValue := ( row at: anInteger) * inversePivot.
		  anInteger to: row size do:
			[ :m |
			  row at: m put: ( ( row at: m) - (( pivotRow at: m) * rowPivotValue)).
			].
		].!

pivotStepAt: anInteger
		"Private - Performs an optimum pivot operation at anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	self swapRow: anInteger withRow: ( self largestPivotFrom: anInteger);
		   pivotAt: anInteger.!

solve
		"Private - Perform LU decomposition of the system.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	1 to: rows size do: [ :n | self pivotStepAt: n].
	solutions := Array new: ( (rows at: 1) size - rows size).!

swapRow: anInteger1 withRow: anInteger2
		"Private - Swap the rows indexed by the given integers.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| swappedRow |
	anInteger1 = anInteger2
		ifFalse:[ swappedRow := rows at: anInteger1.
					  rows at: anInteger1 put: ( rows at: anInteger2).
					  rows at: anInteger2 put: swappedRow.
					].! !

DhbLinearEquationSystem class
	instanceVariableNames: ''!



!DhbLinearEquationSystem class methodsFor: 'creation'!

equations: anArrayOfArrays constant: anArray 
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^self new initialize: anArrayOfArrays constants: (Array with: anArray)!

equations: anArrayOfArrays constants: anArrayOfConstantArrays 
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^self new initialize: anArrayOfArrays constants: anArrayOfConstantArrays! !

Object subclass: #DhbProjectedOneVariableFunction
	instanceVariableNames: 'index function argument '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbProjectedOneVariableFunction methodsFor: 'information'!

argumentWith: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^argument at: index put: aNumber; yourself!

index
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	index isNil
		ifTrue: [ index := 1].
	^index!

value: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^function value: ( self argumentWith: aNumber)! !

!DhbProjectedOneVariableFunction methodsFor: 'initialization'!

initialize: aFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	function := aFunction.
	^self!

setArgument: anArrayOrVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	argument := anArrayOrVector copy.!

setIndex: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	index := anInteger.! !

!DhbProjectedOneVariableFunction methodsFor: 'transformation'!

bumpIndex
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	index isNil
		ifTrue: [ index := 1]
		ifFalse:[ index := index + 1.
				  index > argument size
					ifTrue: [ index := 1].
				].! !

DhbProjectedOneVariableFunction class
	instanceVariableNames: ''!



!DhbProjectedOneVariableFunction class methodsFor: 'creation'!

function: aVectorFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^super new initialize: aVectorFunction! !

Object subclass: #DhbWeightedPoint
	instanceVariableNames: 'xValue yValue weight error '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbWeightedPoint methodsFor: 'accessing'!

error
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	error isNil
		ifTrue: [ error := 1 / weight sqrt].
	^error!

point
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^xValue @ yValue!

weight
	^weight!

xValue
	^xValue!

yValue
	^yValue! !

!DhbWeightedPoint methodsFor: 'information'!

chi2ComparisonContribution: aWeightedPoint
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^(aWeightedPoint yValue - yValue) squared / ( 1 / aWeightedPoint weight + ( 1 / weight))!

chi2Contribution: aFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^(yValue - ( aFunction value: xValue)) squared * weight! !

!DhbWeightedPoint methodsFor: 'initialization'!

initialize: aPoint error: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	error := aNumber.
	^self initialize: aPoint weight: 1 / aNumber squared!

initialize: aPoint weight: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	xValue := aPoint x.
	yValue := aPoint y.
	weight := aNumber.
	^self! !

DhbWeightedPoint class
	instanceVariableNames: ''!



!DhbWeightedPoint class methodsFor: 'creation'!

point: aPoint
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^self new initialize: aPoint weight: 1!

point: aNumber count: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^self point: aNumber @ anInteger
		weight: ( anInteger > 0 ifTrue: [ 1 / anInteger]
								ifFalse:[ 1])!

point: aPoint error: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^self new initialize: aPoint error: aNumber!

point: aPoint weight: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^self new initialize: aPoint weight: aNumber! !

Object subclass: #DhbStatisticalMoments
	instanceVariableNames: 'moments '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbStatisticalMoments methodsFor: 'creation'!

asWeightedPoint: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^DhbWeightedPoint point: aNumber @ self average error: self errorOnAverage! !

!DhbStatisticalMoments methodsFor: 'information'!

average
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	self count = 0 ifTrue: [^nil].
	^moments at: 2!

centralMoment: anInteger 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/6/99 "

	^moments at: anInteger + 1!

count
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/6/99 "

	^moments at: 1!

errorOnAverage
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 02-Jan-00 "
	^( self variance / self count) sqrt!

kurtosis
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	| n n1 n23 |
	n := self count.
	n < 4 ifTrue: [^nil].
	n23 := (n - 2) * (n - 3).
	n1 := n - 1.
	^((moments at: 5) * n squared * (n + 1) / (self variance squared * n1) 
		- (n1 squared * 3)) / n23!

skewness
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	| n v |
	n := self count.
	n < 3 ifTrue: [^nil].
	v := self variance.
	^(moments at: 4) * n squared / ((n - 1) * (n - 2) * (v sqrt * v))!

standardDeviation
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "
	^self variance sqrt!

unnormalizedVariance
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	^( self centralMoment: 2) * self count!

variance
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "
	| n |
	n := self count.
	n < 2
		ifTrue: [ ^nil].
	^self unnormalizedVariance / ( n - 1)! !

!DhbStatisticalMoments methodsFor: 'initialization'!

initialize: anInteger 
	"Private - ( anInteger - 1) is the degree of the highest accumulated central moment.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	moments := Array new: anInteger.
	self reset.
	^self! !

!DhbStatisticalMoments methodsFor: 'testing'!

fConfidenceLevel: aStatisticalMomentsOrHistogram 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	| fValue |
	fValue := self variance/ aStatisticalMomentsOrHistogram variance.
	^fValue < 1
		ifTrue: [ (DhbFisherSnedecorDistribution degreeOfFreedom: aStatisticalMomentsOrHistogram count
						degreeOfFreedom: self count) 
										confidenceLevel: fValue reciprocal]
		ifFalse:[ (DhbFisherSnedecorDistribution degreeOfFreedom: self count
						degreeOfFreedom: aStatisticalMomentsOrHistogram count) 
										confidenceLevel: fValue]!

tConfidenceLevel: aStatisticalMomentsOrHistogram
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	| sbar dof |
	dof := self count + aStatisticalMomentsOrHistogram count - 2.
	sbar := ( ( self unnormalizedVariance + aStatisticalMomentsOrHistogram unnormalizedVariance) / dof) sqrt.
	^( DhbStudentDistribution degreeOfFreedom: dof)
		confidenceLevel: ( self average - (aStatisticalMomentsOrHistogram average))
							/ ( ( 1 / self count + ( 1 / aStatisticalMomentsOrHistogram count)) sqrt * sbar)! !

!DhbStatisticalMoments methodsFor: 'transformation'!

accumulate: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	| correction n n1 oldSums pascal nTerm cTerm term |
	n := moments at: 1.
	n1 := n + 1.
	correction := ((moments at: 2) - aNumber) / n1.
	oldSums := moments copyFrom: 1 to: moments size.
	moments
		at: 1 put: n1;
		at: 2 put: (moments at: 2) - correction.
	pascal := Array new: moments size.
	pascal atAllPut: 0.
	pascal
		at: 1 put: 1;
		at: 2 put: 1.
	nTerm := -1.
	cTerm := correction.
	n1 := n / n1.
	n := n negated.
	3 to: moments size
		do: 
			[:k | 
			cTerm := cTerm * correction.
			nTerm := n * nTerm.
			term := cTerm * (1 + nTerm).
			k to: 3
				by: -1
				do: 
					[:l | 
					pascal at: l put: (pascal at: l - 1) + (pascal at: l).
					term := (pascal at: l) * (oldSums at: l) + term.
					oldSums at: l put: (oldSums at: l) * correction].
			pascal at: 2 put: (pascal at: 1) + (pascal at: 2).
			moments at: k put: term * n1]!

reset
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	moments atAllPut: 0! !

DhbStatisticalMoments class
	instanceVariableNames: ''!



!DhbStatisticalMoments class methodsFor: 'creation'!

new
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "
	^self new: 4!

new: anInteger
		"anInteger is the degree of the highest central moments
		 accumulated within the created instance.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "
	^super new initialize: anInteger + 1! !

Object subclass: #DhbProbabilityDistributionFunction
	instanceVariableNames: 'probabilityDensity '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbProbabilityDistributionFunction methodsFor: 'information'!

value: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^probabilityDensity distributionValue: aNumber! !

!DhbProbabilityDistributionFunction methodsFor: 'initialization'!

initialize: aProbabilityDensity
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	probabilityDensity := aProbabilityDensity.
	^self! !

DhbProbabilityDistributionFunction class
	instanceVariableNames: ''!



!DhbProbabilityDistributionFunction class methodsFor: 'creation'!

density: aProbabilityDensity
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^self new initialize: aProbabilityDensity! !

Object subclass: #DhbMahalanobisCenter
	instanceVariableNames: 'center inverseCovariance accumulator '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbMahalanobisCenter methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator count printOn: aStream.
	aStream nextPutAll: ': '.
	center printOn: aStream.! !

!DhbMahalanobisCenter methodsFor: 'information'!

count
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^accumulator count!

distanceTo: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	| delta |
	delta := aVector - center.
	^delta * inverseCovariance * delta! !

!DhbMahalanobisCenter methodsFor: 'initialization'!

center: aVector
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator := DhbCovarianceAccumulator new: aVector size.
	center := aVector.
	inverseCovariance := DhbSymmetricMatrix identity: aVector size.
	^self!

initialize: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator := DhbCovarianceAccumulator new: anInteger.
	^self! !

!DhbMahalanobisCenter methodsFor: 'transformation'!

accumulate: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator accumulate: aVector.!

computeParameters
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	center := accumulator average copy.
	inverseCovariance := accumulator covarianceMatrix inverse.!

reset
		"Leave center and inverse covariant matrix untouched
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator reset.! !

DhbMahalanobisCenter class
	instanceVariableNames: ''!



!DhbMahalanobisCenter class methodsFor: 'creation'!

new: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self new initialize: anInteger!

onVector: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self new center: aVector! !

Object subclass: #DhbVectorAccumulator
	instanceVariableNames: 'count average '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbVectorAccumulator methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	super printOn: aStream.
	aStream space.
	count printOn: aStream.
	aStream space.
	average printOn: aStream.! !

!DhbVectorAccumulator methodsFor: 'information'!

average
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^average!

count
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^count! !

!DhbVectorAccumulator methodsFor: 'initialization'!

initialize: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	average := DhbVector new: anInteger.
	self reset.
	^self! !

!DhbVectorAccumulator methodsFor: 'transformation'!

accumulate: aVectorOrArray
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	| delta |
	count := count + 1.
	delta := average - aVectorOrArray asVector scaleBy: 1 / count.
	average accumulateNegated: delta.
	^delta!

reset
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	count := 0.
	average atAllPut: 0.! !

DhbVectorAccumulator class
	instanceVariableNames: ''!



!DhbVectorAccumulator class methodsFor: 'creation'!

new: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self new initialize: anInteger! !

Object subclass: #DhbDecimalFloatingNumber
	instanceVariableNames: 'mantissa exponent '
	classVariableNames: 'Digits '
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbDecimalFloatingNumber methodsFor: 'information'!

value
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^mantissa / ( 10 raisedToInteger: exponent)! !

!DhbDecimalFloatingNumber methodsFor: 'operation'!

* aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new: ( self value * aNumber value)!

+ aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new: ( self value + aNumber value)!

- aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new: ( self value - aNumber value)!

/ aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new: ( self value / aNumber value)!

sqrt
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new:  self value sqrt! !

!DhbDecimalFloatingNumber methodsFor: 'transformation'!

normalize: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	exponent := (self class digits - (aNumber log: 10)) floor.
	mantissa := ( aNumber * ( 10 raisedToInteger: exponent)) truncated.
	^self! !

!DhbDecimalFloatingNumber methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	mantissa printOn: aStream.
	aStream nextPutAll: 'xE'.
	exponent negated printOn: aStream.! !

DhbDecimalFloatingNumber class
	instanceVariableNames: ''!



!DhbDecimalFloatingNumber class methodsFor: 'creation'!

new: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self new normalize: aNumber! !

!DhbDecimalFloatingNumber class methodsFor: 'information'!

defaultDigits
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^15!

digits
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	Digits isNil
		ifTrue: [ Digits := self defaultDigits].
	^Digits! !

!DhbDecimalFloatingNumber class methodsFor: 'transformation'!

defaultDigits: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	Digits := anInteger.!

resetDigits
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	Digits := nil.! !

Object subclass: #DhbMinimizingPoint
	instanceVariableNames: 'value position '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbMinimizingPoint methodsFor: 'display'!

printOn: aStream 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 05-Jan-00 "

	position printOn: aStream.
	aStream
		nextPut: $:;
		space.
	value printOn: aStream! !

!DhbMinimizingPoint methodsFor: 'information'!

betterThan: anOptimizingPoint
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	^value < anOptimizingPoint value!

position
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "

	^position!

value
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	^value! !

!DhbMinimizingPoint methodsFor: 'initialization'!

value: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	value := aNumber.!

vector: aVector 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "

	position := aVector! !

DhbMinimizingPoint class
	instanceVariableNames: ''!



!DhbMinimizingPoint class methodsFor: 'creation'!

new: aVector value: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	^self new vector: aVector; value: aNumber; yourself!

vector: aVector function: aFunction 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "

	^self new: aVector value: (aFunction value: aVector)! !

DhbMinimizingPoint subclass: #DhbMaximizingPoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbMaximizingPoint methodsFor: 'information'!

betterThan: anOptimizingPoint
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	^value > anOptimizingPoint value! !

DhbMaximizingPoint class
	instanceVariableNames: ''!


DhbMatrix subclass: #DhbSymmetricMatrix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbSymmetricMatrix methodsFor: 'information'!

isSquare
		"Answers true because a symmetric matrix is square.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^true!

isSymmetric
		"Answers true because the receiver is a symmetric matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^true! !

!DhbSymmetricMatrix methodsFor: 'initialization'!

clear
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/11/00 "
	rows do: [ :each | each atAllPut: 0].!

initializeIdentity: anInteger
		"Build components for an identity matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	rows := ( 1 to: anInteger) asVector collect: [ :n | (DhbVector new: anInteger) atAllPut: 0; at: n put: 1; yourself].! !

!DhbSymmetricMatrix methodsFor: 'operation'!

+ aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix addWithSymmetricMatrix: self!

- aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix subtractWithSymmetricMatrix: self!

addWithSymmetricMatrix: aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix addWithMatrix: self class: self class!

crlInverse
	| matrices b1 cb1ct cb1 |
	matrices := self split.
	b1 := (matrices at: 1) inverse.
	cb1 := (matrices at: 3) * b1.
	cb1ct := (cb1 productWithTransposeMatrix: (matrices at: 3)) 
				asSymmetricMatrix.
	matrices at: 3 put: (matrices at: 2) * cb1.
	matrices at: 2 put: ((matrices at: 2) accumulateNegated: cb1ct) inverse.
	matrices at: 1 put: ( b1 accumulate: (cb1 transposeProductWithMatrix: (matrices at: 3))).
	(matrices at: 3) negate.
	^self class join: matrices!

inverse
	"Answer the inverse of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^(rows size < self class lupCRLCriticalDimension or: [lupDecomposition notNil]) 
			ifTrue: [self lupInverse]
			ifFalse: [self crlInverse]!

inverse1By1
		"Private - Answer the inverse of the receiver when it is a 1x1 matrix (no check is made).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	^self class rows: ( DhbVector with: ( DhbVector with: ( 1/ ((rows at: 1) at: 1))))!

inverse2By2
		"Private - Answer the inverse of the receiver when it is a 2x2 matrix (no check is made).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	| line1 line2 |
	line1 := DhbVector with: ((rows at: 2) at: 2) with: ((rows at: 1) at: 2) negated.
	line2 := DhbVector with: ((rows at: 1) at: 2) negated with: ((rows at: 1) at: 1).
	^self class rows: ( DhbVector with: line1 with: line2) * (1 / (((rows at: 1) at: 1) * ((rows at: 2) at: 2) - ((rows at: 1) at: 2) squared))!

inversePureCRL
		"Answer the inverse of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| matrices b1 cb1 cb1ct |
	rows size = 1
		ifTrue: [ ^self inverse1By1].
	rows size = 2
		ifTrue: [ ^self inverse2By2].
	matrices := self split.
	b1 := ( matrices at: 1) inversePureCRL.
	cb1 := ( matrices at: 3) * b1.
	cb1ct := ( cb1 productWithTransposeMatrix: ( matrices at: 3)) asSymmetricMatrix.
	matrices at: 2 put: ( ( matrices at: 2) accumulateNegated: cb1ct) inversePureCRL.
	matrices at: 3 put: ( matrices at: 2) * cb1.
	matrices at: 1 put: ( b1 accumulate: ( cb1 transposeProductWithMatrix: ( matrices at: 3))).
	( matrices at: 3) negate.
	^self class join: matrices!

inversePureLUP
		"Answer the inverse of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	lupDecomposition := nil.
	^self class rows: lupDecomposition inverseMatrixComponents!

productWithMatrix: aMatrix
		"Answers the product of aMatrix with the receiver (in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix productWithSymmetricMatrix: self!

productWithSymmetricMatrix: aSymmetricMatrix
		"Answers the product of aMatrix with the receiver (in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aSymmetricMatrix productWithMatrixFinal: self!

subtractWithSymmetricMatrix: aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix subtractWithMatrix: self class: self class! !

!DhbSymmetricMatrix methodsFor: 'transformation'!

split
	"Private - 
	Answers an array of 3 matrices split from the receiver. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 11/2/99"

	| n |
	n := self largestPowerOf2SmallerThan: rows size.
	^Array
		with: (self class rows: ((1 to: n) asVector collect: [:k | (rows at: k)
						copyFrom: 1 to: n]))
		with: (self class rows: ((n + 1 to: rows size) asVector collect: [:k | (rows at: k)
						copyFrom: n + 1 to: rows size]))
		with: (self class superclass rows: ((n + 1 to: rows size) asVector collect: [:k | (rows at: k)
						copyFrom: 1 to: n]))! !

DhbSymmetricMatrix class
	instanceVariableNames: ''!



!DhbSymmetricMatrix class methodsFor: 'creation'!

identity: anInteger
		"Create an identity matrix of dimension anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self new initializeIdentity: anInteger!

join: anArrayOfMatrices
		"Inverse of the split operation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| rows n |
	rows := OrderedCollection new.
	n := 0.
	( anArrayOfMatrices at: 1) rowsDo:
		[ :each |
		  n := n + 1.
		  rows add: each, ( ( anArrayOfMatrices at: 3) columnAt: n).
		].
	n := 0.
	( anArrayOfMatrices at: 2) rowsDo:
		[ :each |
		  n := n + 1.
		  rows add: ( ( anArrayOfMatrices at: 3) rowAt: n), each.
		].
	^self rows: rows! !

!DhbSymmetricMatrix class methodsFor: 'information'!

lupCRLCriticalDimension
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	^36! !

Object subclass: #DhbPolynomialLeastSquareFit
	instanceVariableNames: 'pointCollection degreePlusOne '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbPolynomialLeastSquareFit methodsFor: 'information'!

evaluate
		"Perform the least square fit and answers the fitted polynomial.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	| system errorMatrix |
	system := self computeEquations.
	errorMatrix := ( system at: 1) inverse.
	^( DhbEstimatedPolynomial coefficients: errorMatrix * (system at: 2))
			errorMatrix: errorMatrix;
			yourself! !

!DhbPolynomialLeastSquareFit methodsFor: 'initialization'!

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

!DhbPolynomialLeastSquareFit methodsFor: 'transformation'!

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
	^Array with: ( DhbSymmetricMatrix rows: rows) with: vector! !

DhbPolynomialLeastSquareFit class
	instanceVariableNames: ''!



!DhbPolynomialLeastSquareFit class methodsFor: 'creation'!

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

Object subclass: #DhbSeriesTermServer
	instanceVariableNames: 'x lastTerm '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbSeriesTermServer methodsFor: 'initialization'!

setArgument: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	x := aNumber asFloat.! !

DhbSeriesTermServer class
	instanceVariableNames: ''!


DhbSeriesTermServer subclass: #DhbIncompleteGammaSeriesTermServer
	instanceVariableNames: 'alpha sum '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbIncompleteGammaSeriesTermServer methodsFor: 'information'!

initialTerm
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	lastTerm := 1 / alpha.
	sum := alpha.
	^lastTerm!

termAt: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	sum := sum + 1.
	lastTerm := lastTerm * x / sum.
	^lastTerm! !

!DhbIncompleteGammaSeriesTermServer methodsFor: 'initialization'!

setParameter: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	alpha := aNumber asFloat! !

DhbIncompleteGammaSeriesTermServer class
	instanceVariableNames: ''!


DhbSeriesTermServer subclass: #DhbIncompleteGammaFractionTermServer
	instanceVariableNames: 'alpha '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbIncompleteGammaFractionTermServer methodsFor: 'information'!

initialTerm
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	lastTerm := x - alpha + 1.
	^lastTerm!

termsAt: anInteger 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	lastTerm := lastTerm + 2.
	^Array with: (alpha - anInteger) * anInteger with: lastTerm! !

!DhbIncompleteGammaFractionTermServer methodsFor: 'initialization'!

setParameter: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	alpha := aNumber asFloat! !

DhbIncompleteGammaFractionTermServer class
	instanceVariableNames: ''!


Object subclass: #DhbProbabilityDensity
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbProbabilityDensity methodsFor: 'creation'!

distributionFunction
		" (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^DhbProbabilityDistributionFunction density: self! !

!DhbProbabilityDensity methodsFor: 'display'!

printOn: aStream 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 4/3/99"

	| params |
	aStream nextPutAll: self class distributionName.
	(params := self parameters) notNil
		ifTrue: 
			[| first |
			first := true.
			aStream nextPut: $(.
			params
				do: 
					[:each | 
					first
						ifTrue: [first := false]
						ifFalse: [aStream nextPut: $,].
					aStream space.
					each printOn: aStream].
			aStream nextPut: $)]! !

!DhbProbabilityDensity methodsFor: 'information'!

acceptanceBetween: aNumber1 and: aNumber2
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value larger than aNumber 1 and lower than or equal to aNumber2.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( self distributionValue: aNumber2) - ( self distributionValue: aNumber1)!

approximatedValueAndGradient: aNumber
		"Private - gradients an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 The gradient is computed by approximation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| delta parameters dp gradient n |
	parameters := self parameters.
	n := parameters size.
	dp := self value: aNumber.
	delta := Array new: n.
	delta atAllPut: 0.
	gradient := DhbVector new: n.
	1 to: n do:
		[ :k |
		  delta at: k put: ( parameters at: k) * 0.0001.
		  self changeParametersBy: delta.
		  gradient at: k put: ( ( ( self value: aNumber) - dp) / ( delta at: k)).
		  delta at: k put: ( delta at: k ) negated.
		  k > 1
			ifTrue: [ delta at: ( k - 1) put: 0].
		].
	self changeParametersBy: delta.
	^Array with: dp with: gradient!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	self subclassResponsibility.!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self subclassResponsibility!

inverseDistributionValue: aNumber
		"Answer the number whose distribution value is aNumber.
		 NOTE: Subclass MUST NOT overwrite this method.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( aNumber between: 0 and: 1)
			ifTrue: [ self privateInverseDistributionValue: aNumber]
			ifFalse:[ self error: 'Illegal argument for inverse distribution value']!

kurtosis
		"Answer the kurtosis of the receiver.
		 Undefined. Must be implemented by subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^nil!

parameters
	"Returns an Array containing the parameters of the distribution. 
	It is used to print out the distribution and for fitting. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 4/3/99"

	^self subclassResponsibility!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose distribution is aNumber.
		 NOTE: Subclass may overwrite this method for faster computation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbNewtonZeroFinder function: [ :x | ( self distributionValue: x) - aNumber] derivative: self)
		initialValue: self average / (1 - aNumber); evaluate!

random
		"Answer a random number distributed according to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self privateInverseDistributionValue: DhbMitchellMooreGenerator new floatValue!

skewness
		"Answer the skewness of the receiver.
		 Undefined. Must be implemented by subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^nil!

standardDeviation
		"Answer the standard deviation of the receiver.
		 NOTE: At least one of the methods variance or standardDeviation must be implemented by the subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self variance sqrt!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	self subclassResponsibility.!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^self approximatedValueAndGradient: aNumber!

variance
		"Answer the variance of the receiver.
		 NOTE: At least one of the methods variance or standardDeviation must be implemented by the subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self standardDeviation squared! !

!DhbProbabilityDensity methodsFor: 'transformation'!

changeParametersBy: aVector 
	self subclassResponsibility! !

DhbProbabilityDensity class
	instanceVariableNames: ''!



!DhbProbabilityDensity class methodsFor: 'creation'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 Default returns nil (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^nil! !

!DhbProbabilityDensity class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Unknown distribution'! !

DhbProbabilityDensity subclass: #DhbProbabilityDensityWithUnknownDistribution
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbProbabilityDensityWithUnknownDistribution methodsFor: 'information'!

acceptanceBetween: aNumber1 and: aNumber2
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value larger than aNumber 1 and lower than or equal to aNumber2.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbRombergIntegrator new: self from: aNumber1 to: aNumber2) evaluate!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 This general purpose routine uses numerical integration.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbRombergIntegrator new: self from: self lowestValue to: aNumber) evaluate!

lowestValue
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/18/00 "
	^0! !

DhbProbabilityDensityWithUnknownDistribution class
	instanceVariableNames: ''!


DhbProbabilityDensity subclass: #DhbLaplaceDistribution
	instanceVariableNames: 'mu beta '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLaplaceDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^mu!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^3!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: mu with: beta!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| r |
	r := DhbMitchellMooreGenerator new floatValue ln * beta negated.
	^DhbMitchellMooreGenerator new floatValue > 0.5
		ifTrue: [ mu + r]
		ifFalse:[ mu - r]!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^beta * ( 2 sqrt)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^( ( aNumber - mu) / beta) abs negated exp / ( 2 * beta)!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| dp |
	dp := self value: aNumber.
	^Array	with: dp
			with: ( DhbVector with: ( aNumber - mu) sign * dp / beta
							  with: ( ( ( aNumber - mu) abs / beta - 1) * dp / beta))! !

!DhbLaplaceDistribution methodsFor: 'initialization'!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > mu
		ifTrue: [ 1 - ( ( ( aNumber - mu) / beta) negated exp / 2)]
		ifFalse:[ ( ( ( aNumber - mu) / beta) exp / 2)]!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	mu := aNumber1.
	beta := aNumber2.
	^self! !

!DhbLaplaceDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	mu := mu + ( aVector at: 1).
	beta := beta + ( aVector at: 2).! !

DhbLaplaceDistribution class
	instanceVariableNames: ''!



!DhbLaplaceDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	^self shape: aHistogram average scale: (aHistogram variance / 2) sqrt!

new
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "

	^self shape: 0 scale: 1!

shape: aNumber1 scale: aNumber2 
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "

	^super new initialize: aNumber1 scale: aNumber2! !

!DhbLaplaceDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Laplace distribution'! !

DhbProbabilityDensity subclass: #DhbGammaDistribution
	instanceVariableNames: 'alpha beta norm randomCoefficients incompleteGammaFunction '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbGammaDistribution methodsFor: 'initialization'!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	norm := beta ln * alpha + alpha logGamma.!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	( aNumber1 > 0 and: [ aNumber2 > 0])
		ifFalse: [ self error: 'Illegal distribution parameters'].
	alpha := aNumber1.
	beta := aNumber2.
	self computeNorm.
	^self! !

!DhbGammaDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^alpha * beta!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self incompleteGammaFunction value: aNumber / beta!

incompleteGammaFunction
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	incompleteGammaFunction isNil 
		ifTrue: 
			[incompleteGammaFunction := DhbIncompleteGammaFunction shape: alpha].
	^incompleteGammaFunction!

initializeRandomCoefficientsForLargeAlpha
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	| a b q d |
	a := 1 / ( 2 * alpha - 1) sqrt.
	b := alpha - (4 ln).
	q := 1 / a + alpha.
	d := 4.5 ln + 1.
	^Array with: a with: b with: q with: d!

initializeRandomCoefficientsForSmallAlpha
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	| e |
	e := 1 exp.
	^( e + alpha) / e!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^6 / alpha!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha with: beta!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( alpha > 1 ifTrue: [ self randomForLargeAlpha]
						ifFalse:[ self randomForSmallAlpha]) * beta!

randomCoefficientsForLargeAlpha
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	randomCoefficients isNil
		ifTrue: [ randomCoefficients := self initializeRandomCoefficientsForLargeAlpha].
	^randomCoefficients!

randomCoefficientsForSmallAlpha
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	randomCoefficients isNil
		ifTrue: [ randomCoefficients := self initializeRandomCoefficientsForSmallAlpha].
	^randomCoefficients!

randomForLargeAlpha
		"Private - Generate a random number distributed according to the receiver
						when alpha > 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	[ true] whileTrue: [
	| u1 u2 c v y z w|
	u1 := DhbMitchellMooreGenerator new floatValue.
	u2 := DhbMitchellMooreGenerator new floatValue.
	c := self randomCoefficientsForLargeAlpha.
	v := ( u1 / ( 1 - u1)) ln * (c at: 1).
	y := v exp * alpha.
	z := u1 squared * u2.
	w := ( c at: 3) * v + ( c at: 2) - y.
	( c at: 4) + w >= ( 4.5 * z) ifTrue: [ ^y].
	z ln <= w ifTrue: [ ^y].
								].!

randomForSmallAlpha
		"Private - Generate a random number distributed according to the receiver
						when alpha < 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	[ true] whileTrue: [
	| p |
	p := DhbMitchellMooreGenerator new floatValue * self randomCoefficientsForSmallAlpha.
	p > 1
		ifTrue: [ | y |
					 y := ( ( self randomCoefficientsForSmallAlpha - p) / alpha) ln negated.
					 DhbMitchellMooreGenerator new floatValue <= ( y raisedTo: ( alpha - 1))
					 	ifTrue: [ ^y].
					]
		ifFalse: [ | y |
						y := p raisedTo: ( 1 / alpha).
					 DhbMitchellMooreGenerator new floatValue <= ( y negated exp)
					 	ifTrue: [ ^y].
					 ].
								].!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^2 / alpha sqrt!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > 0
		ifTrue: [ ( aNumber ln * (alpha - 1) - (aNumber / beta) - norm) exp]
		ifFalse:[ 0].!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^beta squared * alpha! !

!DhbGammaDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	alpha := alpha + ( aVector at: 1).
	beta := beta + ( aVector at: 2).
	self computeNorm.
	incompleteGammaFunction := nil.
	randomCoefficients := nil.! !

DhbGammaDistribution class
	instanceVariableNames: ''!



!DhbGammaDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| alpha beta |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	alpha := aHistogram average.
	beta := aHistogram variance / alpha.
	^[ self shape: alpha / beta scale: beta] on: Error do: [ :signal | signal return: nil]!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

shape: aNumber1 scale: aNumber2
		"Create an instance of the receiver with given shape and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 scale: aNumber2! !

!DhbGammaDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Gamma distribution'! !

DhbProbabilityDensity subclass: #DhbFisherTippettDistribution
	instanceVariableNames: 'alpha beta '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbFisherTippettDistribution methodsFor: 'initialization'!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	aNumber2 > 0
		ifFalse: [ self error: 'Illegal distribution parameters'].
	alpha := aNumber1.
	beta := aNumber2.
	^self! !

!DhbFisherTippettDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^0.577256649 * beta + alpha!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	alpha := alpha + ( aVector at: 1).
	beta := beta + ( aVector at: 2).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 14/4/99 "
	| arg |
	arg := ( aNumber - alpha) / beta.
	arg := arg < DhbFloatingPointMachine new largestExponentArgument negated
					ifTrue: [ ^0]
					ifFalse:[arg negated exp].
	^arg > DhbFloatingPointMachine new largestExponentArgument ifTrue: [ 1]
						ifFalse:[ arg negated exp]!

integralFrom: aNumber1 to: aNumber2
		"Private - Compute the integral of the receiver from aNumber1 to aNumber2.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 14/4/99 "
	^( DhbRombergIntegrator new: self from: aNumber1 to: aNumber2) evaluate!

integralUpTo: aNumber
		"Private - Compute the integral of the receiver from -infinity to aNumber.
		 aNumber must be below 0 (no checking!!).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 14/4/99 "
	^( DhbRombergIntegrator new:
			[ :x | x = 0 ifTrue: [ 0] ifFalse: [ ( self value: 1 / x) / x squared] ]
			from: 1 / aNumber to: 0) evaluate!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^2.4!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha with: beta!

random
		"Answer a random number distributed according to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/4/99 "
	| t |
	[ t := DhbMitchellMooreGenerator new floatValue ln negated.
	  t > 0] whileFalse: [].
	^t ln negated * beta + alpha!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^1.3!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Float pi * beta / ( 6 sqrt)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	| arg |
	arg := ( aNumber - alpha) / beta.
	arg := arg > DhbFloatingPointMachine new largestExponentArgument ifTrue: [ ^0]
						ifFalse:[arg negated exp + arg].
	^arg > DhbFloatingPointMachine new largestExponentArgument ifTrue: [ 0]
						ifFalse:[ arg negated exp / beta]!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| dp dy y|
	dp := self value: aNumber.
	y := ( aNumber - alpha) / beta.
	dy := ( y negated exp - 1).
	^Array with: dp
		   with: ( DhbVector with: dy * dp / beta negated
							 with: dp * ( y * dy + 1) / beta negated)! !

DhbFisherTippettDistribution class
	instanceVariableNames: ''!



!DhbFisherTippettDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	| beta |
	beta := aHistogram standardDeviation.
	beta = 0 ifTrue: [^nil].
	beta := beta * (6 sqrt / Float pi).
	^self shape: aHistogram average - (0.5772156649 * beta) scale: beta!

new
	"Create a standard version of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^self shape: 0 scale: 1!

shape: aNumber1 scale: aNumber2 
	"Create an instance of the receiver with given shape and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 scale: aNumber2! !

!DhbFisherTippettDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Fisher-Tippett distribution'! !

DhbProbabilityDensity subclass: #DhbStudentDistribution
	instanceVariableNames: 'degreeOfFreedom norm chiSquareDistribution incompleteBetaFunction '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbStudentDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^0!

chiSquareDistribution
		"Private - Answer the chi square distribution used to generate
		 random numbers for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	chiSquareDistribution isNil
		ifTrue: [ chiSquareDistribution := DhbChiSquareDistribution degreeOfFreedom: (degreeOfFreedom - 1)].
	^chiSquareDistribution!

confidenceLevel: aNumber
		"Answer the probability in percent of finding a value
		 distributed according to the receiver with an absolute value
		 larger than aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	^( 1 - ( self symmetricAcceptance: aNumber abs)) * 100!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	aNumber = 0
		ifTrue: [ ^1/2].
	^( aNumber > 0
		ifTrue: [ 2 - ( self symmetricAcceptance: aNumber abs)]
		ifFalse:[ self symmetricAcceptance: aNumber abs]) / 2!

incompleteBetaFunction
	"Private - Answers the incomplete beta function used to compute
		 the symmetric acceptance integral of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "

	incompleteBetaFunction isNil 
		ifTrue: 
			[incompleteBetaFunction := DhbIncompleteBetaFunction 
						shape: degreeOfFreedom / 2
						shape: 0.5].
	^incompleteBetaFunction!

kurtosis
		"Answer the kurtosis of the receiver.
		 Undefined if the degree of freedom is less than 5.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^degreeOfFreedom > 4 ifTrue: [ 6 / ( degreeOfFreedom - 4)]
						 ifFalse:[ nil]!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: degreeOfFreedom!

random
		"Answer a random number distributed according to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^DhbNormalDistribution random * ( ( (degreeOfFreedom - 1) / self chiSquareDistribution random ) sqrt)!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

symmetricAcceptance: aNumber
		"Private - Compute the acceptance of the receiver between -aNumber and aNumber
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	^ self incompleteBetaFunction value: ( degreeOfFreedom / ( aNumber squared + degreeOfFreedom))!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( norm - ( ( aNumber squared / degreeOfFreedom + 1) ln * ( ( degreeOfFreedom + 1) / 2))) exp!

variance
		"Answer the variance of the receiver.
		 Undefined if the degree of freedom is less than 3.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^degreeOfFreedom > 2 ifTrue: [ degreeOfFreedom / ( degreeOfFreedom - 2)]
						 ifFalse:[ nil]! !

!DhbStudentDistribution methodsFor: 'initialization'!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	norm := ( ( degreeOfFreedom / 2 logBeta: ( 1 / 2) ) + ( degreeOfFreedom ln / 2)) negated.!

initialize: anInteger
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	anInteger > 0
		ifFalse: [ self error: 'Degree of freedom must be positive'].
	degreeOfFreedom := anInteger.
	self computeNorm.
	^self! !

!DhbStudentDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	degreeOfFreedom := degreeOfFreedom + ( aVector at: 1).
	self computeNorm.! !

DhbStudentDistribution class
	instanceVariableNames: ''!



!DhbStudentDistribution class methodsFor: 'creation'!

asymptoticLimit
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/4/99 "
	^30!

degreeOfFreedom: anInteger 
	"Create a new instance of the receiver with anInteger degrees of freedom.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "

	^anInteger > self asymptoticLimit 
		ifTrue: [DhbNormalDistribution new]
		ifFalse: 
			[anInteger = 1 
				ifTrue: [DhbCauchyDistribution shape: 0 scale: 1]
				ifFalse: [super new initialize: anInteger]]!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	| dof var |
	var := aHistogram variance.
	var = 0
		ifTrue: [ ^nil].
	dof :=  ( 2 / (1 - (1 / aHistogram variance))) rounded max: 1.
	^dof > self asymptoticLimit ifTrue: [ nil]
								ifFalse:[ self degreeOfFreedom: dof]!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

test: aStatisticalMoment1 with: aStatisticalMoment2
		"Preform a consistency Student test (or t-test) on the averages of  two statistical moments ( or histograms).
		 Answers the probability of failing the test.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	| t |
	t := ( aStatisticalMoment1 average - aStatisticalMoment2 average) abs.
	^1 - ( ( self class degreeOfFreedom: (  aStatisticalMoment1 count + aStatisticalMoment2 count - 2)) acceptanceBetween: t negated and: t)! !

!DhbStudentDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Student distribution'! !

DhbProbabilityDensity subclass: #DhbTriangularDistribution
	instanceVariableNames: 'lowLimit highLimit peak '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbTriangularDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(lowLimit + peak + highLimit) / 3!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| norm |
	^( aNumber between: lowLimit and: highLimit)
		ifTrue: [ aNumber < peak
						ifTrue: [ norm := ( highLimit - lowLimit) * ( peak - lowLimit).
									 ( aNumber - lowLimit) squared / norm
									]
						ifFalse:[ aNumber > peak
										ifTrue: [ norm := ( highLimit - lowLimit) * ( highLimit - peak).
									  				 1 - ( ( highLimit - aNumber) squared / norm)
													]
										ifFalse:[ ( peak - lowLimit) / ( highLimit - lowLimit)]
									]
				   ]
		ifFalse:[ 0]!

inverseAcceptanceAfterPeak: aNumber
		"Private - Compute inverse acceptance function in the region after the peak.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^ highLimit - ( ( ( 1 - aNumber) * ( highLimit - lowLimit) * ( highLimit - peak)) sqrt)!

inverseAcceptanceBeforePeak: aNumber
		"Private - Compute inverse acceptance function in the region before the peak.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^ ( aNumber * ( highLimit - lowLimit) * ( peak - lowLimit)) sqrt + lowLimit!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^(-6/10)!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: lowLimit with: highLimit with: peak!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( peak - lowLimit) / ( highLimit - lowLimit) > aNumber
			ifTrue: [ self inverseAcceptanceBeforePeak: aNumber]
			ifFalse: [ self inverseAcceptanceAfterPeak: aNumber]!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^(((lowLimit squared * lowLimit + ( peak squared * peak) + ( highLimit squared * highLimit) ) / 135)
	-(((lowLimit squared * peak) + (lowLimit squared * highLimit) + (peak squared * lowLimit) + (peak squared * highLimit) + (highLimit squared * lowLimit) + (highLimit squared * peak))/90)
	+( 2 * lowLimit * peak * highLimit / 45)) / ( self standardDeviation raisedToInteger: 3)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| norm |
	^( aNumber between: lowLimit and: highLimit)
		ifTrue: [ aNumber < peak
						ifTrue: [ norm := ( highLimit - lowLimit) * ( peak - lowLimit).
									 2 * ( aNumber - lowLimit) / norm
									]
						ifFalse:[ aNumber > peak
										ifTrue: [ norm := ( highLimit - lowLimit) * ( highLimit - peak).
									  				 2 * ( highLimit - aNumber) / norm
													]
										ifFalse:[ 2 / ( highLimit - lowLimit)]
									]
				   ]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(lowLimit squared + peak squared + highLimit squared - ( lowLimit * peak) - ( lowLimit * highLimit) - ( peak * highLimit)) / 18! !

!DhbTriangularDistribution methodsFor: 'initialization'!

initialize: aNumber1 from: aNumber2 to: aNumber3
		"Private - Defines the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	( aNumber2 < aNumber3 and: [ aNumber1 between: aNumber2 and: aNumber3])
		ifFalse: [ self error: 'Illegal distribution parameters'].
	peak := aNumber1.
	lowLimit := aNumber2.
	highLimit := aNumber3.
	^self! !

!DhbTriangularDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	lowLimit := lowLimit + ( aVector at: 1).
	highLimit := highLimit + ( aVector at: 2).
	peak := peak + ( aVector at: 3).! !

DhbTriangularDistribution class
	instanceVariableNames: ''!



!DhbTriangularDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 Default returns nil (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| b c|
	b := aHistogram standardDeviation * 1.73205080756888 "12 sqrt / 2".
	b = 0
		ifTrue: [ ^nil].
	c := aHistogram average.
	^self new: c from: ( c - b) to: ( c + b).!

new
		"Create an instance of the receiver with peak at 1/2 and limits 0 and 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^self new: (1 / 2) from: 0 to: 1!

new: aNumber1 from: aNumber2 to: aNumber3
		"Create an instance of the receiver with peak at aNumber1 and limits aNumber2 and aNumber3.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 from: aNumber2 to: aNumber3! !

!DhbTriangularDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Triangular distribution'! !

Object subclass: #DhbScaledProbabilityDensityFunction
	instanceVariableNames: 'probabilityDensityFunction count binWidth '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbScaledProbabilityDensityFunction methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	super printOn: aStream.
	aStream nextPut: $[;
			nextPutAll: probabilityDensityFunction class distributionName;
			nextPut: $].! !

!DhbScaledProbabilityDensityFunction methodsFor: 'information'!

distributionFunction
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^probabilityDensityFunction distributionFunction!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	^probabilityDensityFunction parameters copyWith: count!

value: aNumber 
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	^(probabilityDensityFunction value: aNumber) * binWidth * count!

valueAndGradient: aNumber 
	"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "

	| g temp |
	g := probabilityDensityFunction valueAndGradient: aNumber.
	temp := binWidth * count.
	^Array with: g first * temp
		   with: ( (g last collect: [:each | each * temp]) copyWith: g first * binWidth)! !

!DhbScaledProbabilityDensityFunction methodsFor: 'initialization'!

initialize: aProbabilityDensityFunction binWidth: aNumber count: anInteger 
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	probabilityDensityFunction := aProbabilityDensityFunction.
	binWidth := aNumber.
	count := anInteger.
	^self! !

!DhbScaledProbabilityDensityFunction methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	count := count + aVector last.
	probabilityDensityFunction changeParametersBy: aVector.!

setCount: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	count := aNumber.! !

DhbScaledProbabilityDensityFunction class
	instanceVariableNames: ''!



!DhbScaledProbabilityDensityFunction class methodsFor: 'creation'!

histogram: aHistogram against: aProbabilityDensityFunction 
	"Create a new instance of the receiver with given probability density function and histogram.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	^self new 
		initialize: aProbabilityDensityFunction
		binWidth: aHistogram binWidth
		count: aHistogram totalCount!

histogram: aHistogram distributionClass: aProbabilityDensityFunctionClass 
	"Create a new instance of the receiver with given probability density function and histogram. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 3/3/99"

	| dp |
	^(dp := aProbabilityDensityFunctionClass fromHistogram: aHistogram) isNil
		ifTrue: [nil]
		ifFalse: [self histogram: aHistogram against: dp]! !

Object subclass: #DhbChromosomeManager
	instanceVariableNames: 'population populationSize rateOfMutation rateOfCrossover '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbChromosomeManager methodsFor: 'initialization'!

populationSize: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	populationSize := anInteger.!

rateOfCrossover: aNumber 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	(aNumber between: 0 and: 1) 
		ifFalse: [self error: 'Illegal rate of cross-over'].
	rateOfCrossover := aNumber!

rateOfMutation: aNumber 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	(aNumber between: 0 and: 1) 
		ifFalse: [self error: 'Illegal rate of mutation'].
	rateOfMutation := aNumber! !

!DhbChromosomeManager methodsFor: 'information'!

isFullyPopulated
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^population size >= populationSize!

population
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^population! !

!DhbChromosomeManager methodsFor: 'operation'!

clone: aChromosome
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^aChromosome copy!

crossover: aChromosome1 and: aChromosome2
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^self subclassResponsibility!

mutate: aChromosome
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^self subclassResponsibility!

process: aChromosome1 and: aChromosome2 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	| roll |
	roll := Number random.
	roll < rateOfCrossover 
		ifTrue: [population addAll: (self crossover: aChromosome1 and: aChromosome2)]
		ifFalse: 
			[roll < (rateOfCrossover + rateOfMutation) 
				ifTrue: 
					[population
						add: (self mutate: aChromosome1);
						add: (self mutate: aChromosome2)]
				ifFalse: 
					[population
						add: (self clone: aChromosome1);
						add: (self clone: aChromosome2)]]!

randomizePopulation
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	self reset.
	[self isFullyPopulated] 
		whileFalse: [population add: self randomChromosome]! !

!DhbChromosomeManager methodsFor: 'transformation'!

reset
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	population := OrderedCollection new: populationSize.! !

!DhbChromosomeManager methodsFor: 'creation'!

randomChromosome
	self subclassResponsibility! !

DhbChromosomeManager class
	instanceVariableNames: ''!



!DhbChromosomeManager class methodsFor: 'creation'!

new: anInteger mutation: aNumber1 crossover: aNumber2
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^self new populationSize: anInteger; rateOfMutation: aNumber1; rateOfCrossover: aNumber2; yourself! !

Object subclass: #DhbLUPDecomposition
	instanceVariableNames: 'rows permutation parity '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLUPDecomposition methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| first delimitingString n k |
	n := rows size.
	first := true.
	rows do:
		[ :row |
		  first ifTrue: [ first := false]
				 ifFalse:[ aStream cr].
		  delimitingString := '('.
		  row do:
			[ :each |
				aStream nextPutAll: delimitingString.
				each printOn: aStream.
				delimitingString := ' '.
			].
		  aStream nextPut: $).
		].! !

!DhbLUPDecomposition methodsFor: 'information'!

determinant
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	| n |
	permutation isNil
		ifTrue: [ self protectedDecomposition].
	permutation = 0
		ifTrue: [ ^0].	"Singular matrix has 0 determinant"
	n := 0.
	^rows inject: parity
		  into: [ :det :each | n := n + 1. ( each at: n) * det]!

inverseMatrixComponents
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| n inverseRows column |
	permutation isNil
		ifTrue: [ self protectedDecomposition].
	permutation = 0
		ifTrue: [ ^nil].	"Singular matrix has no inverse"
	n := rows size.
	inverseRows :=( 1 to: n) asVector collect: [ :j | DhbVector new: n].
	1 to: n do:
		[ :j |
		  column := self solve: ( ( Array new: rows size) atAllPut: 0; at: j put: 1; yourself).
		  1 to: n do: [ :i | ( inverseRows at: i) at: j put: ( column at: i)].
		].
	^inverseRows!

largestPivotFrom: anInteger
		"Private - Answers the largest pivot element in column anInteger, from position anInteger upward.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| valueOfMaximum indexOfMaximum value |
	valueOfMaximum := ( ( rows at: anInteger) at: anInteger) abs.
	indexOfMaximum := anInteger.
	( anInteger + 1) to: rows size do:
		[ :n |
		  value := ( ( rows at: n) at: anInteger) abs.
		  value > valueOfMaximum
				ifTrue: [ valueOfMaximum := value.
						  indexOfMaximum := n.
						].
		].
	^indexOfMaximum! !

!DhbLUPDecomposition methodsFor: 'initialization'!

initialize: anArrayOfArrays
		"Private - A copy of the original array is made.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	rows := anArrayOfArrays.
	parity := 1.
	^self! !

!DhbLUPDecomposition methodsFor: 'transformation'!

backwardSubstitution: anArray
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| n sum answer|
	n := rows size.
	answer := DhbVector new: n.
	n to: 1 by: -1 do:
		[ :i |
		  sum := anArray at: i.
		  ( i + 1) to: n do: [ :j | sum := sum - ( ( ( rows at: i) at: j) * ( answer at: j))].
		  answer at: i put: sum / ( ( rows at: i) at: i).
		].
	^answer!

decompose
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| n |
	n := rows size.
	permutation := (1 to: n) asArray.
	1 to: ( n - 1) do:
		[ :k |
		  self swapRow: k withRow: ( self largestPivotFrom: k);
			   pivotAt: k.
		].!

forwardSubstitution: anArray
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| n sum answer|
	answer := permutation collect: [ :each | anArray at: each].
	n := rows size.
	2 to: n do:
		[ :i |
		  sum := answer at: i.
		  1 to: ( i - 1) do: [ :j | sum := sum - ( ( ( rows at: i) at: j) * ( answer at: j))].
		  answer at: i put: sum.
		].
	^answer!

pivotAt: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| inversePivot size k |
	inversePivot := 1 / ( ( rows at: anInteger) at: anInteger).
	size := rows size.
	k := anInteger + 1.
	k to: size
		do: [ :i |
			  ( rows at: i) at: anInteger put: (( rows at: i) at: anInteger) * inversePivot.
			  k to: size
				do: [ :j |
					  ( rows at: i) at: j put: ( ( rows at: i) at: j) - ( (( rows at: i) at: anInteger) * (( rows at: anInteger) at: j)).
					]
			].!

protectedDecomposition
		"Private - If decomposition fails, set permutation to 0.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	[ self decompose] on: Error do: [ :signal | permutation := 0. signal return: nil].!

solve: anArrayOrVector
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	permutation isNil
		ifTrue: [ self protectedDecomposition].
	^permutation = 0
		ifTrue: [ nil]
		ifFalse:[ self backwardSubstitution: ( self forwardSubstitution: anArrayOrVector)]!

swapRow: anInteger1 withRow: anInteger2
		"Private - Swap the rows indexed by the given integers.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	anInteger1 = anInteger2
		ifFalse:[ | swappedRow |
				  swappedRow := rows at: anInteger1.
				  rows at: anInteger1 put: ( rows at: anInteger2).
				  rows at: anInteger2 put: swappedRow.
				  swappedRow := permutation at: anInteger1.
				  permutation at: anInteger1 put: ( permutation at: anInteger2).
				  permutation at: anInteger2 put: swappedRow.
				  parity := parity negated.
				].! !

DhbLUPDecomposition class
	instanceVariableNames: ''!



!DhbLUPDecomposition class methodsFor: 'creation'!

direct: anArrayOfArrays
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	^self new initialize: anArrayOfArrays.!

equations: anArrayOfArrays
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
		^self new initialize: ( anArrayOfArrays collect: [ :each | each copy]).! !

DhbProbabilityDensityWithUnknownDistribution subclass: #DhbLogNormalDistribution
	instanceVariableNames: 'normalDistribution '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLogNormalDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( normalDistribution variance*0.5 + normalDistribution average) exp!

fourthCentralMoment
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 24/6/99 "
	| y x |
	y := normalDistribution average exp.
	x := normalDistribution variance exp.
	^( y squared squared) * ( x squared)
		* ( ( ( x squared * x - 4) * ( x squared) + 6) * x - 3)!

kurtosis
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| x |
	x := normalDistribution variance exp.
	^( ( x + 2) * x + 3) * ( x squared) - 6!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^normalDistribution parameters!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^normalDistribution random exp!

skewness
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| x |
	x := normalDistribution variance exp.
	^(x - 1) sqrt * (x + 2)!

thirdCentralMoment
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 24/6/99 "
	| y x |
	y := normalDistribution average exp.
	x := normalDistribution variance exp.
	^( y squared * y) * ( x raisedTo: (3/2))
		* ( ( x squared negated + 3) * x - 2)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > 0
		ifTrue: [ ( normalDistribution value: aNumber ln) / aNumber]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( normalDistribution average * 2 + normalDistribution variance) exp * ( normalDistribution variance exp - 1)! !

!DhbLogNormalDistribution methodsFor: 'initialization'!

initialize: aNumber1 sigma: aNumber2
		"Private - Defines the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	normalDistribution := DhbNormalDistribution new: aNumber1 sigma: aNumber2.
	^self! !

!DhbLogNormalDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	normalDistribution changeParametersBy: aVector.! !

DhbLogNormalDistribution class
	instanceVariableNames: ''!



!DhbLogNormalDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| average variance sigma2 |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	average := aHistogram average.
	average > 0
		ifFalse: [ ^nil].
	variance := aHistogram variance.
	sigma2 := ( variance / average squared + 1) ln.
	sigma2 > 0
		ifFalse: [ ^nil].
	^self new: ( average ln - (sigma2 * 0.5)) sigma: sigma2 sqrt!

new
		"Create a new instance of the receiver with mu=0 and sigma=1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self new: 0 sigma: 1!

new: aNumber1 sigma: aNumber2
		"Create a new instance of the receiver with given mu and sigma.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 sigma: aNumber2! !

!DhbLogNormalDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Log normal distribution'! !

Object subclass: #DhbAbstractDataServer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbAbstractDataServer methodsFor: 'operation'!

close
		"Close the data stream (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "!

next
		"Answers the next element on the stream.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self subclassResponsibility!

open
		"Open the data stream (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self subclassResponsibility!

reset
		"Reset the position of the data stream to the beginning.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self subclassResponsibility! !

!DhbAbstractDataServer methodsFor: 'information'!

atEnd
		"Answers true if there is no more data element.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self subclassResponsibility! !

DhbAbstractDataServer class
	instanceVariableNames: ''!


DhbAbstractDataServer subclass: #DhbMemoryBasedDataServer
	instanceVariableNames: 'data position '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbMemoryBasedDataServer methodsFor: 'information'!

atEnd
		"Answers true if there is no more data element.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	^data size < position!

dimension
		"Answers the dimension of the vectors catered by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	^data first size! !

!DhbMemoryBasedDataServer methodsFor: 'initialization'!

data: anOrderedCollection
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	data := anOrderedCollection.
	self reset.! !

!DhbMemoryBasedDataServer methodsFor: 'operation'!

next
		"Answers the next element on the stream.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	| answer |
	answer := data at: position.
	position := position + 1.
	^answer!

open
		"Open the data stream (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self reset!

reset
		"Reset the position of the data stream to the beginning.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	position := 1.! !

DhbMemoryBasedDataServer class
	instanceVariableNames: ''!


Object subclass: #DhbIncompleteBetaFunction
	instanceVariableNames: 'alpha1 alpha2 fraction inverseFraction logNorm '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbIncompleteBetaFunction methodsFor: 'information'!

evaluateFraction: aNumber 
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	fraction isNil 
		ifTrue: 
			[fraction := DhbIncompleteBetaFractionTermServer new.
			fraction setParameter: alpha1 second: alpha2].
	fraction setArgument: aNumber.
	^(DhbContinuedFraction server: fraction)
		desiredPrecision: DhbFloatingPointMachine new defaultNumericalPrecision;
		evaluate!

evaluateInverseFraction: aNumber 
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	inverseFraction isNil 
		ifTrue: 
			[inverseFraction := DhbIncompleteBetaFractionTermServer new.
			inverseFraction setParameter: alpha2 second: alpha1].
	inverseFraction setArgument: (1 - aNumber).
	^(DhbContinuedFraction server: inverseFraction)
		desiredPrecision: DhbFloatingPointMachine new defaultNumericalPrecision;
		evaluate!

value: aNumber
		"Compute the value of the receiver for argument aNumber.
		 Note: aNumber must be between 0 and 1 (otherwise an exception will occur)
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	| norm |
	aNumber = 0
		ifTrue: [ ^0].
	aNumber = 1
		ifTrue: [ ^1].
	norm :=  ( aNumber ln * alpha1 + ( ( 1 - aNumber) ln * alpha2) + logNorm) exp.
	^( alpha1 + alpha2 + 2) * aNumber < ( alpha1 + 1)
		ifTrue: [ norm / ( ( self evaluateFraction: aNumber) * alpha1)]
		ifFalse:[ 1 - ( norm / ( ( self evaluateInverseFraction: aNumber) * alpha2))]! !

!DhbIncompleteBetaFunction methodsFor: 'initialization'!

initialize: aNumber1 shape: aNumber2 
	"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	alpha1 := aNumber1.
	alpha2 := aNumber2.
	logNorm := ( alpha1 + alpha2) logGamma - alpha1 logGamma - alpha2 logGamma.
	^self! !

DhbIncompleteBetaFunction class
	instanceVariableNames: ''!



!DhbIncompleteBetaFunction class methodsFor: 'creation'!

shape: aNumber1 shape: aNumber2 
	"Create an instance of the receiver with given shape parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 shape: aNumber2! !

DhbProbabilityDensity subclass: #DhbCauchyDistribution
	instanceVariableNames: 'mu beta '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbCauchyDistribution methodsFor: 'initialization'!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	mu := aNumber1.
	beta := aNumber2.
	^self! !

!DhbCauchyDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^mu!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 Assumes that the value of the receiver is 0 for x < 0.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(( aNumber - mu) / beta) arcTan / Float pi + (1 / 2)!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: mu with: beta!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^( ( aNumber - (1 / 2)) * Float pi) tan * beta + mu!

standardDeviation
		"The standard deviation of the receiver is not defined.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^nil!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^beta / ( Float pi * ( beta squared + ( aNumber - mu) squared))!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| dp denominator |
	dp := self value: aNumber.
	denominator := 1 / ( ( aNumber - mu) squared + beta squared).
	^Array with: dp
		   with: ( DhbVector with: 2 * dp * ( aNumber - mu) * denominator
							 with: dp * ( 1 / beta - ( 2 * beta * denominator)))!

variance
		"The variance of the receiver is not defined.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^nil! !

!DhbCauchyDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	mu := mu + ( aVector at: 1).
	beta := beta + ( aVector at: 2).! !

DhbCauchyDistribution class
	instanceVariableNames: ''!



!DhbCauchyDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	^self shape: aHistogram average
		scale: 4 * aHistogram variance 
				/ (Float pi * (aHistogram maximum squared + aHistogram minimum squared)) 
						sqrt!

new
	"Create an instance of the receiver with center 0 and scale 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^self shape: 0 scale: 1!

shape: aNumber1 scale: aNumber2 
	"Create an instance of the receiver with given center and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 scale: aNumber2! !

!DhbCauchyDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Cauchy distribution'! !

Object subclass: #DhbCluster
	instanceVariableNames: 'accumulator previousSampleSize '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbCluster methodsFor: 'initialization'!

centerOn: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	self subclassResponsibility!

initialize
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "

	previousSampleSize := 0.
	^self! !

!DhbCluster methodsFor: 'information'!

changes
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "

	^(self sampleSize - previousSampleSize) abs!

distanceTo: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self subclassResponsibility!

isInsignificantIn: aClusterFinder
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/17/00 "
	^self sampleSize <= aClusterFinder minimumClusterSize!

isUndefined
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self subclassResponsibility!

sampleSize
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^accumulator count! !

!DhbCluster methodsFor: 'transformation'!

accumulate: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator accumulate: aVector.!

collectAccumulatorResults
	self subclassResponsibility!

reset
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "

	previousSampleSize := self sampleSize.
	self collectAccumulatorResults.
	accumulator reset! !

DhbCluster class
	instanceVariableNames: ''!



!DhbCluster class methodsFor: 'creation'!

new
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^super new initialize! !

DhbCluster subclass: #DhbCovarianceCluster
	instanceVariableNames: 'center '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbCovarianceCluster methodsFor: 'initialization'!

centerOn: aVector 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved. 
	Initial code: 2/16/00"

	accumulator := aVector isNil
				ifTrue: [nil]
				ifFalse: [DhbMahalanobisCenter onVector: aVector]! !

!DhbCovarianceCluster methodsFor: 'information'!

isUndefined
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^accumulator isNil! !

!DhbCovarianceCluster methodsFor: 'transformation'!

collectAccumulatorResults
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator computeParameters.! !

!DhbCovarianceCluster methodsFor: 'display'!

distanceTo: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^accumulator distanceTo: aVector!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator printOn: aStream.! !

DhbCovarianceCluster class
	instanceVariableNames: ''!


DhbProbabilityDensity subclass: #DhbUniformDistribution
	instanceVariableNames: 'lowLimit highLimit '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbUniformDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( highLimit + lowLimit) / 2!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	aNumber < lowLimit
		ifTrue: [ ^0].
	^aNumber < highLimit
		ifTrue: [ (aNumber - lowLimit) / ( highLimit - lowLimit)]
		ifFalse:[ 1]!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^-12 / 10!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: lowLimit with: highLimit!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(highLimit - lowLimit) * aNumber + lowLimit!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( highLimit - lowLimit) / 3.46410161513775 "12 sqrt"!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( aNumber between: lowLimit and: highLimit)
		ifTrue: [ 1/( highLimit - lowLimit)]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( highLimit - lowLimit) squared / 12! !

!DhbUniformDistribution methodsFor: 'initialization'!

initialize: aNumber1 to: aNumber2
		"Private - Defines the limits of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	aNumber1 < aNumber2
		ifFalse: [ self error: 'Illegal distribution parameters'].
	lowLimit := aNumber1.
	highLimit := aNumber2.
	^self! !

!DhbUniformDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	lowLimit := lowLimit + ( aVector at: 1).
	highLimit := highLimit + ( aVector at: 2).! !

DhbUniformDistribution class
	instanceVariableNames: ''!



!DhbUniformDistribution class methodsFor: 'public'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Uniform distribution'!

from: aNumber1 to: aNumber2
		"Create a new instance of the receiver with given limits.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 to: aNumber2!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 Default returns nil (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| b c|
	b := aHistogram standardDeviation * 1.73205080756888 "12 sqrt / 2".
	b = 0
		ifTrue: [ ^nil].
	c := aHistogram average.
	^self from: ( c - b) to: ( c + b).!

new
		"Create a new instance of the receiver with limits 0 and 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self from: 0 to: 1! !

DhbPolynomial subclass: #DhbEstimatedPolynomial
	instanceVariableNames: 'errorMatrix '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbEstimatedPolynomial methodsFor: 'initialization'!

errorMatrix: aMatrix
		"Defines the error matrix of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	errorMatrix := aMatrix.! !

!DhbEstimatedPolynomial methodsFor: 'information'!

error: aNumber
		"Compute the error on the value of the receiver for argument aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	| errorVector term nextTerm |
	nextTerm := 1.
	errorVector := ( coefficients collect: [ :each | term := nextTerm. nextTerm := aNumber * nextTerm. term]) asVector.
	^( errorVector * errorMatrix * errorVector) sqrt!

errorMatrix
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/5/99 "
	^errorMatrix!

valueAndError: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 20/5/99 "
	^Array with: ( self value: aNumber) with: ( self error: aNumber)! !

DhbEstimatedPolynomial class
	instanceVariableNames: ''!


Object subclass: #DhbErfApproximation
	instanceVariableNames: 'constant series norm '
	classVariableNames: 'UniqueInstance '
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbErfApproximation methodsFor: 'initialization'!

initialize
		"Private - Initialize constants needed to evaluate the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/1/99 "
	constant := 0.2316419.
	norm := 1 / ( Float pi * 2) sqrt.
	series := DhbPolynomial coefficients: #( 0.31938153 -0.356563782 1.781477937 -1.821255978 1.330274429).! !

!DhbErfApproximation methodsFor: 'information'!

normal: aNumber
		"Computes the value of the Normal distribution for aNumber
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/1/99 "

	^[ ( aNumber squared * -0.5) exp * norm]
			on: Error do: [ :signal | signal return: 0]!

value: aNumber
		"Answer erf( aNumber) using an approximation from Abramovitz and Stegun, Handbook of Mathematical Functions.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/1/99 "
	| t |
	aNumber = 0
		ifTrue: [ ^0.5].
	aNumber > 0
		ifTrue: [ ^1- ( self value: aNumber negated)].
	aNumber < -20
		ifTrue: [ ^0].
	t := 1 / (1 - (constant * aNumber)).
	^( series value: t) * t * (self normal: aNumber)! !

DhbErfApproximation class
	instanceVariableNames: ''!



!DhbErfApproximation class methodsFor: 'creation'!

new
		"Answer a unique instance. Create it if it does not exist.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/1/99 "
	UniqueInstance isNil
		ifTrue: [ UniqueInstance := super new.
					 UniqueInstance initialize.
					].
	^UniqueInstance! !

DhbProjectedOneVariableFunction subclass: #DhbVectorProjectedFunction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbVectorProjectedFunction methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	self origin printOn: aStream.
	aStream nextPutAll: ' ('.
	self direction printOn: aStream.
	aStream nextPut: $).! !

!DhbVectorProjectedFunction methodsFor: 'information'!

argumentWith: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^aNumber * self direction + self origin!

direction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^index!

origin
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^argument! !

!DhbVectorProjectedFunction methodsFor: 'initialization'!

direction: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	index := aVector.!

origin: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	argument := aVector.! !

DhbVectorProjectedFunction class
	instanceVariableNames: ''!


DhbProbabilityDensity subclass: #DhbNormalDistribution
	instanceVariableNames: 'mu sigma nextRandom '
	classVariableNames: 'NextRandom '
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbNormalDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^mu!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^DhbErfApproximation new value: ( ( aNumber - mu) / sigma)!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: mu with: sigma!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self class random * sigma + mu!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^sigma!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbErfApproximation new normal: (aNumber - mu) / sigma) / sigma!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	| dp y |
	y := ( aNumber - mu) / sigma.
	dp := ( DhbErfApproximation new normal: y) / sigma.
	^Array with: dp
		   with: ( DhbVector with: dp * y / sigma
							 with: dp * ( y squared - 1) / sigma)! !

!DhbNormalDistribution methodsFor: 'initialization'!

initialize: aNumber1 sigma: aNumber2
		"Private - Defines the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	mu := aNumber1.
	sigma := aNumber2.
	^self! !

!DhbNormalDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	mu := mu + ( aVector at: 1).
	sigma := sigma + ( aVector at: 2).! !

DhbNormalDistribution class
	instanceVariableNames: ''!



!DhbNormalDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	^self new: aHistogram average sigma: aHistogram standardDeviation!

new
		"Create a new instance of the receiver with mu=0 and sigma=1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self new: 0 sigma: 1!

new: aNumber1 sigma: aNumber2
		"Create a new instance of the receiver with given mu and sigma.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 sigma: aNumber2! !

!DhbNormalDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Normal distribution'!

random
		"Answer a random number distributed according to a (0,1) normal distribution.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| v1 v2 w y |
	NextRandom isNil
		ifTrue: [ [ v1 := Number random * 2 - 1.
					v2 := Number random * 2 - 1.
					w := v1 squared + v2 squared.
					w > 1 ] whileTrue: [].
				  y := ( ( w ln * 2 negated) / w) sqrt.
				v1 := y * v1.
				NextRandom := y * v2.
				]
		ifFalse:[ v1 :=NextRandom.
				  NextRandom := nil.
				].
	^v1! !

DhbVectorAccumulator subclass: #DhbCovarianceAccumulator
	instanceVariableNames: 'covariance '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbCovarianceAccumulator methodsFor: 'initialization'!

initialize: anInteger
		"Private - Initialize the receiver to accumulate vectors of dimension anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	covariance := ( ( 1 to: anInteger) collect: [ :n | DhbVector new: n]) asVector.
	^super initialize: anInteger! !

!DhbCovarianceAccumulator methodsFor: 'information'!

covarianceMatrix
		"Answer a matrix containing the covariance of the accumulated data.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	| rows n |
	n := 0.
	rows := covariance collect:
				[ :row | n := n + 1. row, ( ( ( n + 1) to: covariance size) collect: [ :m | ( covariance at: m) at: n ])].
	^DhbSymmetricMatrix rows: rows! !

!DhbCovarianceAccumulator methodsFor: 'transformation'!

accumulate: anArray
		"Accumulate anArray into the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	| delta count1 r|
	count1 := count.
	delta := super accumulate: anArray.
	r := count1 / count.
	1 to: delta size
		do: [ :n |
			  1 to: n do:
				  [ :m |
					( covariance at: n) at: m put: ( count1 * ( delta at: n) * ( delta at: m) + ( r * ( ( covariance at: n) at: m))).
				  ].
			].!

reset
		"Set all accumulators to zero.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	super reset.
	covariance do: [ :each | each atAllPut: 0].! !

DhbCovarianceAccumulator class
	instanceVariableNames: ''!


Object subclass: #DhbIterativeProcess
	instanceVariableNames: 'precision desiredPrecision maximumIterations result iterations '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbIterativeProcess methodsFor: 'information'!

hasConverged
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 20/4/99 "
	^precision <= desiredPrecision!

iterations
		"Answers the number of iterations performed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^iterations!

limitedSmallValue: aNumber
		"Private - prevent aNumber from being smaller in absolute value than a small number.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	^aNumber abs < DhbFloatingPointMachine new smallNumber
			ifTrue: [ DhbFloatingPointMachine new smallNumber]
			ifFalse:[ aNumber]!

precision
		"Answer the attained precision for the result.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^precision!

precisionOf: aNumber1 relativeTo: aNumber2
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/5/99 "
	^aNumber2 > DhbFloatingPointMachine new defaultNumericalPrecision
		ifTrue: [ aNumber1 / aNumber2]
		ifFalse:[ aNumber1]!

result
		"Answer the result of the iterations (if any)
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^result! !

!DhbIterativeProcess methodsFor: 'initialization'!

desiredPrecision: aNumber
		"Defines the desired precision for the result.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	aNumber > 0
		ifFalse: [ ^self error: 'Illegal precision: ', aNumber printString].
	desiredPrecision := aNumber.!

initialize
		"Private - initialize the parameters of the receiver with default values.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	desiredPrecision := self class defaultPrecision.
	maximumIterations := self class defaultMaximumIterations.
	^self!

maximumIterations: anInteger
		"Defines the maximum number of iterations.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	( anInteger isInteger and: [ anInteger > 1])
		ifFalse: [ ^self error: 'Invalid maximum number of iteration: ', anInteger printString].
	maximumIterations := anInteger.! !

!DhbIterativeProcess methodsFor: 'operation'!

evaluate
	"Perform the iteration until either the desired precision is attained or the number of iterations exceeds the maximum.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	iterations := 0.
	self initializeIterations.
	
	[iterations := iterations + 1.
	precision := self evaluateIteration.
	self hasConverged or: [iterations >= maximumIterations]] 
			whileFalse: [].
	self finalizeIterations.
	^self result!

evaluateIteration
		"Dummy method (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^self subclassResponsibility!

finalizeIterations
	"Perform cleanup operation if needed (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "!

initializeIterations
	"Initialize the iterations (must be implemented by subclass when needed).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "! !

DhbIterativeProcess class
	instanceVariableNames: ''!



!DhbIterativeProcess class methodsFor: 'creation'!

new
		"Create an instance of the class.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^super new initialize! !

!DhbIterativeProcess class methodsFor: 'information'!

defaultMaximumIterations
		"Private - Answers the default maximum number of iterations for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^50!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^DhbFloatingPointMachine new defaultNumericalPrecision! !

DhbIterativeProcess subclass: #DhbFunctionalIterator
	instanceVariableNames: 'functionBlock relativePrecision '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbFunctionalIterator methodsFor: 'initialization'!

setFunction: aBlock
		"Defines the function for which zeroes will be found.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	( aBlock respondsTo: #value:)
		ifFalse:[ self error: 'Function block must implement the method value:'].
	functionBlock := aBlock.! !

!DhbFunctionalIterator methodsFor: 'information'!

relativePrecision: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/4/99 "
	^self precisionOf: aNumber relativeTo: result abs! !

!DhbFunctionalIterator methodsFor: 'operation'!

computeInitialValues
	self subclassResponsibility!

initializeIterations
	"If no initial value has been defined, take 0 as the starting point (for lack of anything better).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	functionBlock isNil ifTrue: [self error: 'No function supplied'].
	self computeInitialValues! !

DhbFunctionalIterator class
	instanceVariableNames: ''!



!DhbFunctionalIterator class methodsFor: 'creation'!

function: aBlock
		"Convenience method to create a instance with given function block.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^self new setFunction: aBlock; yourself! !

DhbFunctionalIterator subclass: #DhbBisectionZeroFinder
	instanceVariableNames: 'positiveX negativeX '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbBisectionZeroFinder methodsFor: 'initialization'!

setNegativeX: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	( functionBlock value: aNumber) < 0
		ifFalse:[ self error: 'Function is not negative at x = ', aNumber printString].
	negativeX := aNumber.!

setPositiveX: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	( functionBlock value: aNumber) > 0
		ifFalse:[ self error: 'Function is not positive at x = ', aNumber printString].
	positiveX := aNumber.! !

!DhbBisectionZeroFinder methodsFor: 'operation'!

computeInitialValues
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	positiveX isNil
		ifTrue: [ self error: 'No positive value supplied'].
	negativeX isNil
		ifTrue: [ self error: 'No negative value supplied'].!

evaluateIteration
		"Perform one step of bisection.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	result := ( positiveX + negativeX) * 0.5.
	( functionBlock value: result) > 0
		ifTrue: [ positiveX := result]
		ifFalse:[ negativeX := result].
	^self relativePrecision: ( positiveX - negativeX) abs!

findNegativeXFrom: aNumber1 range: aNumber2
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	| n |
	n := 0.
	[ negativeX := Number random * aNumber2 + aNumber1.
	  ( functionBlock value: negativeX) < 0
		] whileFalse: [ n := n + 0.1.
						n > maximumIterations
							ifTrue: [ self error: 'Unable to find a negative function value'].
					  ].!

findPositiveXFrom: aNumber1 range: aNumber2
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	| n |
	n := 0.
	[ positiveX := Number random * aNumber2 + aNumber1.
	  ( functionBlock value: positiveX) > 0
		] whileFalse: [ n := n + 1.
						n > maximumIterations
							ifTrue: [ self error: 'Unable to find a positive function value'].
					  ].! !

DhbBisectionZeroFinder class
	instanceVariableNames: ''!


DhbIterativeProcess subclass: #DhbLargestEigenValueFinder
	instanceVariableNames: 'matrix eigenvector transposeEigenvector '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLargestEigenValueFinder methodsFor: 'creation'!

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

!DhbLargestEigenValueFinder methodsFor: 'information'!

eigenvalue
	"Answer the eigen value found by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^result!

eigenvector
	"Answer the normalized eigen vector found by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^eigenvector * (1 / eigenvector norm)! !

!DhbLargestEigenValueFinder methodsFor: 'initialization'!

initialize: aMatrix
		"Defines the matrix for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	matrix := aMatrix.! !

!DhbLargestEigenValueFinder methodsFor: 'operation'!

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

initializeIterations
	"Initialize the iterations (subclasses must write their own method and call this one last).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	eigenvector := DhbVector new: matrix numberOfRows.
	eigenvector atAllPut: 1.0.
	transposeEigenvector := DhbVector new: eigenvector size.
	transposeEigenvector atAllPut: 1.0! !

DhbLargestEigenValueFinder class
	instanceVariableNames: ''!



!DhbLargestEigenValueFinder class methodsFor: 'creation'!

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

!DhbLargestEigenValueFinder class methodsFor: 'information'!

defaultMaximumIterations
		"Private - Answers the default maximum number of iterations for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^100! !

DhbFunctionalIterator subclass: #DhbFunctionOptimizer
	instanceVariableNames: 'optimizingPointClass bestPoints '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbFunctionOptimizer methodsFor: 'initialization'!

initialize
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	bestPoints := SortedCollection sortBlock: [ :a :b | a betterThan: b].
	^super initialize!

initializeAsMaximizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	optimizingPointClass := DhbMaximizingPoint.
	^self initialize!

initializeAsMinimizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	optimizingPointClass := DhbMinimizingPoint.
	^self!

initializeForOptimizer: aFunctionOptimizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	optimizingPointClass := aFunctionOptimizer pointClass.
	functionBlock := aFunctionOptimizer functionBlock.
	^self initialize!

initialValue: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	result := aVector copy.! !

!DhbFunctionOptimizer methodsFor: 'information'!

bestPoints
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^bestPoints!

functionBlock
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^functionBlock!

pointClass
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^optimizingPointClass! !

!DhbFunctionOptimizer methodsFor: 'operation'!

finalizeIterations
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	result := bestPoints first position.! !

!DhbFunctionOptimizer methodsFor: 'transformation'!

addPointAt: aNumber 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	bestPoints 
		add: (optimizingPointClass vector: aNumber function: functionBlock)! !

!DhbFunctionOptimizer methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	super printOn: aStream.
	bestPoints do: [ :each | aStream cr. each printOn: aStream].! !

DhbFunctionOptimizer class
	instanceVariableNames: ''!



!DhbFunctionOptimizer class methodsFor: 'creation'!

forOptimizer: aFunctionOptimizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^self new initializeForOptimizer: aFunctionOptimizer!

maximizingFunction: aFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^super new initializeAsMaximizer; setFunction: aFunction!

minimizingFunction: aFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^super new initializeAsMinimizer; setFunction: aFunction! !

!DhbFunctionOptimizer class methodsFor: 'information'!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^super defaultPrecision * 100! !

DhbFunctionOptimizer subclass: #DhbOneVariableFunctionOptimizer
	instanceVariableNames: ''
	classVariableNames: 'GoldenSection '
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbOneVariableFunctionOptimizer methodsFor: 'information'!

computePrecision
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^self precisionOf: ( ( bestPoints at: 2) position - ( bestPoints at: 3) position) abs
		   relativeTo: ( bestPoints at: 1) position abs!

hasBracketingPoints
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| x1 |
	x1 := ( bestPoints at: 1) position.
	^( ( bestPoints at: 2) position - x1) * (( bestPoints at: 3) position - x1) < 0!

indexOfOuterPoint
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| inferior superior x |
	inferior := false.
	superior := false.
	x := bestPoints first position.
	2 to: 4 do:
		[ :n |
		  ( bestPoints at: n) position < x
				ifTrue: [ inferior
							ifTrue: [ ^n].
						  inferior := true.
						]
				ifFalse:[ superior
							ifTrue: [ ^n].
						  superior := true.
						].
		].!

nextXValue
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| d3 d2 x1 |
	x1 := ( bestPoints at: 1) position.
	d2 := ( bestPoints at: 2) position - x1.
	d3 := ( bestPoints at: 3) position - x1.
	^( d3 abs > d2 abs ifTrue: [ d3]
					   ifFalse:[ d2]) * self class goldenSection + x1! !

!DhbOneVariableFunctionOptimizer methodsFor: 'operation'!

computeInitialValues
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	[ bestPoints size  > 3] whileTrue: [ bestPoints removeLast].
	bestPoints size = 3
		ifTrue: [ self hasBracketingPoints
					ifFalse:[ bestPoints removeLast].
				].
	bestPoints size < 3
		ifTrue: [ ( DhbOptimizingBracketFinder forOptimizer: self) evaluate].!

evaluateIteration
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	self addPointAt: self nextXValue.
	bestPoints removeAtIndex: self indexOfOuterPoint.
	^self computePrecision! !

!DhbOneVariableFunctionOptimizer methodsFor: 'transformation'!

reset
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	[ bestPoints isEmpty] whileFalse: [ bestPoints removeLast].! !

DhbOneVariableFunctionOptimizer class
	instanceVariableNames: ''!



!DhbOneVariableFunctionOptimizer class methodsFor: 'information'!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^DhbFloatingPointMachine new defaultNumericalPrecision * 10!

goldenSection
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	GoldenSection isNil ifTrue: [GoldenSection := (3 - 5 sqrt) / 2].
	^GoldenSection! !

DhbOneVariableFunctionOptimizer subclass: #DhbOptimizingBracketFinder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbOptimizingBracketFinder methodsFor: 'initialization'!

initializeForOptimizer: aFunctionOptimizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	super initializeForOptimizer: aFunctionOptimizer.
	bestPoints := aFunctionOptimizer bestPoints.
	^self!

setInitialPoints: aSortedCollection
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	bestPoints := aSortedCollection.! !

!DhbOptimizingBracketFinder methodsFor: 'operation'!

computeInitialValues
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	[bestPoints size < 2] whileTrue: [self addPointAt: Number random]!

evaluateIteration
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| x1 x2 |
	x1 := ( bestPoints at: 1) position.
	x2 := ( bestPoints at: 2) position.
	self addPointAt: ( x1 * 3 - ( x2 * 2)).
	precision := ( x2 - x1) * ( ( bestPoints at: 3) position - x1).
	self hasConverged
		ifFalse:[ bestPoints removeLast].
	^precision!

finalizeIterations
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	result := bestPoints.! !

DhbOptimizingBracketFinder class
	instanceVariableNames: ''!



!DhbOptimizingBracketFinder class methodsFor: 'creation'!

initialPoints: aSortedCollection function: aFunction
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^super new setInitialPoints: aSortedCollection; setFunction: aFunction! !

DhbFunctionOptimizer subclass: #DhbMultiVariableGeneralOptimizer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbMultiVariableGeneralOptimizer methodsFor: 'initialization'!

origin
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	^result!

origin: anArrayOrVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	result := anArrayOrVector.!

range
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	^self bestPoints!

range: anArrayOrVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	bestPoints := anArrayOrVector.! !

!DhbMultiVariableGeneralOptimizer methodsFor: 'operation'!

computeInitialValues
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	self range notNil
		ifTrue: [ self performGeneticOptimization].
	self performSimplexOptimization.!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	| optimizer |
	optimizer := DhbHillClimbingOptimizer forOptimizer: self.
	optimizer desiredPrecision: desiredPrecision;
			  maximumIterations: maximumIterations;
			  initialValue: result.
	result := optimizer evaluate.
	^optimizer precision!

finalizeIterations
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "!

performGeneticOptimization
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	| optimizer manager |
	optimizer := DhbGeneticOptimizer forOptimizer: self.
	manager := DhbVectorChromosomeManager new: 100 mutation: 0.1 crossover: 0.1.
	manager origin: self origin asVector; range: self range asVector.
	optimizer chromosomeManager: manager.
	result := optimizer evaluate.!

performSimplexOptimization
	"Private - 
	(c) Copyrights Didier BESSET, 2000, all rights reserved. 
	Initial code: 2/29/00"

	| optimizer |
	optimizer := DhbSimplexOptimizer forOptimizer: self.
	optimizer desiredPrecision: desiredPrecision sqrt; maximumIterations: maximumIterations; initialValue: result asVector.
	result := optimizer evaluate! !

DhbMultiVariableGeneralOptimizer class
	instanceVariableNames: ''!


DhbIterativeProcess subclass: #DhbInfiniteSeries
	instanceVariableNames: 'termServer '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbInfiniteSeries methodsFor: 'initialization'!

initialize: aTermServer
		"Private - Assigns the object responsible to compute each term.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	termServer := aTermServer.
	^self! !

!DhbInfiniteSeries methodsFor: 'operation'!

evaluateIteration
		"Perform one iteration.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	| delta |
	delta := termServer termAt: iterations.
	result := result + delta.
	^self precisionOf: delta abs relativeTo: result abs!

initializeIterations
	"Initialize the series.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	result := termServer initialTerm! !

DhbInfiniteSeries class
	instanceVariableNames: ''!



!DhbInfiniteSeries class methodsFor: 'creation'!

server: aTermServer
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	^self new initialize: aTermServer! !

DhbInfiniteSeries subclass: #DhbContinuedFraction
	instanceVariableNames: 'numerator denominator '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbContinuedFraction methodsFor: 'operation'!

evaluateIteration
		"Perform one iteration.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	| terms delta |
	terms := termServer termsAt: iterations.
	denominator := 1 / ( self limitedSmallValue: ( (terms at: 1) * denominator + (terms at: 2))).
	numerator := self limitedSmallValue: ( (terms at: 1) / numerator + (terms at: 2)).
	delta := numerator * denominator.
	result := result * delta.
	^( delta - 1) abs!

initializeIterations
	"Initialize the series.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	numerator := self limitedSmallValue: termServer initialTerm.
	denominator := 0.
	result := numerator! !

DhbContinuedFraction class
	instanceVariableNames: ''!


DhbFunctionOptimizer subclass: #DhbHillClimbingOptimizer
	instanceVariableNames: 'unidimensionalFinder '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbHillClimbingOptimizer methodsFor: 'initialization'!

computeInitialValues
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 05-Jan-00 "
	unidimensionalFinder := DhbOneVariableFunctionOptimizer forOptimizer: self.
	unidimensionalFinder desiredPrecision: desiredPrecision.
	bestPoints := ( 1 to: result size)
							collect: [ :n |
									   ( DhbVectorProjectedFunction function: functionBlock)
											direction: ( ( DhbVector new: result size)
															atAllPut: 0;
															at: n put: 1;
															yourself);
											yourself
									 ].! !

!DhbHillClimbingOptimizer methodsFor: 'operation'!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	| oldResult |
	precision := 1.0.
	bestPoints inject: result
				 into: [ :prev :each | ( self minimizeDirection: each from: prev)].
	self shiftDirections.
	self minimizeDirection: bestPoints last.
	oldResult := result.
	result := bestPoints last origin.
	precision := 0.0.
	result with: oldResult do:
		[ :x0 :x1 |
		  precision := ( self precisionOf: (x0 - x1) abs relativeTo: x0 abs) max: precision.
		].
	^precision!

finalizeIterations
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "!

minimizeDirection: aVectorFunction 
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^unidimensionalFinder
		reset;
		setFunction: aVectorFunction;
		addPointAt: 0;
		addPointAt: precision;
		addPointAt: precision negated;
		evaluate!

minimizeDirection: aVectorFunction from: aVector 
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	^aVectorFunction
		origin: aVector;
		argumentWith: ( self minimizeDirection: aVectorFunction)!

shiftDirections
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| position delta firstDirection |
	firstDirection := bestPoints first direction.
	bestPoints inject: nil
					into: [ :prev :each |
							position isNil
								ifTrue: [ position := each origin]
								ifFalse:[ prev direction: each direction].
							each
							].
	position := bestPoints last origin - position.
	delta := position norm.
	delta > desiredPrecision
		ifTrue: [ bestPoints last direction: (position scaleBy: (1 / delta))]
		ifFalse:[ bestPoints last direction: firstDirection].! !

DhbHillClimbingOptimizer class
	instanceVariableNames: ''!


DhbFunctionalIterator subclass: #DhbTrapezeIntegrator
	instanceVariableNames: 'from to sum step '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbTrapezeIntegrator methodsFor: 'initialization'!

from: aNumber1 to: aNumber2
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	from := aNumber1.
	to := aNumber2.!

initialize: aBlock from: aNumber1 to: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	functionBlock := aBlock.
	self from: aNumber1 to: aNumber2.
	^self! !

!DhbTrapezeIntegrator methodsFor: 'operation'!

computeInitialValues
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	step := to - from.
	sum := ( ( functionBlock value: from) + ( functionBlock value: to)) * step /2.
	result := sum.!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	| oldResult |
	oldResult := result.
	result := self higherOrderSum.
	^self relativePrecision: ( result - oldResult) abs! !

!DhbTrapezeIntegrator methodsFor: 'transformation'!

higherOrderSum
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	| x newSum |
	x := step / 2 + from.
	newSum := 0.
	[ x < to ]
		whileTrue: [ newSum := ( functionBlock value: x) + newSum.
					 x := x + step.
				   ].
	sum := ( step * newSum + sum) / 2.
	step := step / 2.
	^sum! !

DhbTrapezeIntegrator class
	instanceVariableNames: ''!



!DhbTrapezeIntegrator class methodsFor: 'creation'!

function: aBlock from: aNumber1 to: aNumber2
		"Create an new instance with given parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^super new initialize: aBlock from: aNumber1 to: aNumber2!

new
		"Private - Block the constructor method for this class.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^self error: 'Method new:from:to: must be used'! !

!DhbTrapezeIntegrator class methodsFor: 'information'!

defaultMaximumIterations
		"Private - Answers the default maximum number of iterations for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^13! !

DhbTrapezeIntegrator subclass: #DhbRombergIntegrator
	instanceVariableNames: 'order points interpolator '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbRombergIntegrator methodsFor: 'initialization'!

initialize
		"Private - initialize the parameters of the receiver with default values.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	order := self class defaultOrder.
	^super initialize!

order: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	anInteger < 2
		ifTrue: [ self error: 'Order for Romberg integration must be larger than 1'].
	order := anInteger.! !

!DhbRombergIntegrator methodsFor: 'operation'!

computeInitialValues
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	super computeInitialValues.
	points := OrderedCollection new: order.
	interpolator := DhbNevilleInterpolator points: points.
	points add: 1 @ sum.!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	| interpolation |
	points addLast: (points last x * 0.25) @ self higherOrderSum.
	points size < order
		ifTrue: [ ^1].
	interpolation := interpolator valueAndError: 0.
	points removeFirst.
	result := interpolation at: 1.
	^self relativePrecision: ( interpolation at: 2) abs! !

DhbRombergIntegrator class
	instanceVariableNames: ''!



!DhbRombergIntegrator class methodsFor: 'information'!

defaultOrder
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	^5! !

DhbTrapezeIntegrator subclass: #DhbSimpsonIntegrator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbSimpsonIntegrator methodsFor: 'operation'!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/4/99 "
	| oldResult oldSum |
	iterations < 2
		ifTrue: [ self higherOrderSum.
				  ^1
				].
	oldResult := result.
	oldSum := sum.
	result := (self higherOrderSum * 4 - oldSum) / 3.
	^self relativePrecision: ( result - oldResult) abs! !

DhbSimpsonIntegrator class
	instanceVariableNames: ''!


DhbProbabilityDensity subclass: #DhbBetaDistribution
	instanceVariableNames: 'alpha1 alpha2 gamma1 gamma2 logNorm incompleteBetaFunction '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbBetaDistribution methodsFor: 'initialization'!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	logNorm := (alpha1 + alpha2) logGamma - alpha1 logGamma - alpha2 logGamma.!

initialize: aNumber1 shape: aNumber2 
	"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	(aNumber1 > 0 and: [aNumber2 > 0]) 
		ifFalse: [self error: 'Illegal distribution parameters'].
	alpha1 := aNumber1.
	alpha2 := aNumber2.
	self computeNorm.
	^self! !

!DhbBetaDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^alpha1 / ( alpha1 + alpha2)!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	incompleteBetaFunction isNil
		ifTrue: [ incompleteBetaFunction := DhbIncompleteBetaFunction shape: alpha1 shape: alpha2].
	^incompleteBetaFunction value: aNumber!

firstGammaDistribution
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	gamma1 isNil
		ifTrue: [ gamma1 := DhbGammaDistribution shape: alpha1 scale: 1].
	 ^gamma1!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^3 * ( alpha1 + alpha2 + 1) * ( (alpha1 + alpha2) squared * 2 + ( ( alpha1 + alpha2 - 6) * alpha1 * alpha2)
			/ ( ( alpha1 + alpha2 + 2) * ( alpha1 + alpha2 + 3) * alpha1 * alpha2)) - 3!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha1 with: alpha2!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| r |
	r := self firstGammaDistribution random.
	^r / ( self secondGammaDistribution random + r)!

secondGammaDistribution
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	gamma2 isNil
		ifTrue: [ gamma2 := DhbGammaDistribution shape: alpha2 scale: 1].
	 ^gamma2!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^( alpha1 + alpha2 + 1) sqrt * 2 * ( alpha2 - alpha1) / ( ( alpha1 * alpha2) sqrt * ( alpha1 + alpha2 + 2))!

value: aNumber 
	"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^(aNumber > 0 and: [ aNumber < 1]) 
		ifTrue: 
			[( ( aNumber ln * (alpha1 - 1) ) + ( ( 1 - aNumber) ln * ( alpha2 - 1)) + logNorm) exp]
		ifFalse: [0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^alpha1 * alpha2 / ( ( alpha1 + alpha2) squared * ( alpha1 + alpha2 + 1))! !

!DhbBetaDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	alpha1 := alpha1 + ( aVector at: 1).
	alpha2 := alpha2 + ( aVector at: 2).
	self computeNorm.
	gamma1 := nil.
	gamma2 := nil.
	incompleteBetaFunction := nil.! !

DhbBetaDistribution class
	instanceVariableNames: ''!



!DhbBetaDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the 
	given histogram using best guesses. This method can be used to 
	find the initial values for a fit. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 12/3/99"

	| average variance a b |
	(aHistogram minimum < 0 or: [aHistogram maximum > 1])
		ifTrue: [^nil].
	average := aHistogram average.
	variance := aHistogram variance.
	a := 1 - average / variance - 1 * average.
	a > 0 ifFalse: [^nil].
	b := 1 / average - 1 * a.
	b > 0 ifFalse: [^nil].
	^self shape: a shape: b!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

shape: aNumber1 shape: aNumber2 
	"Create an instance of the receiver with given shape parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 shape: aNumber2! !

!DhbBetaDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Beta distribution'! !

Object subclass: #DhbIncompleteGammaFunction
	instanceVariableNames: 'alpha alphaLogGamma series fraction '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbIncompleteGammaFunction methodsFor: 'information'!

evaluateFraction: aNumber 
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	fraction isNil 
		ifTrue: 
			[fraction := DhbIncompleteGammaFractionTermServer new.
			fraction setParameter: alpha].
	fraction setArgument: aNumber.
	^(DhbContinuedFraction server: fraction)
		desiredPrecision: DhbFloatingPointMachine new defaultNumericalPrecision;
		evaluate!

evaluateSeries: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	series isNil
		ifTrue: [ series := DhbIncompleteGammaSeriesTermServer new.
				  series setParameter: alpha.
				].
	series setArgument: aNumber.
	^(DhbInfiniteSeries server: series)
		desiredPrecision: DhbFloatingPointMachine new defaultNumericalPrecision;
		evaluate!

value: aNumber
		"Compute the value of the receiver for argument aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	| x norm |
	aNumber = 0
		ifTrue: [ ^0].
	x := aNumber asFloat.
	norm := [ ( x ln * alpha - x - alphaLogGamma) exp] on: Error do: [ :signal | signal return: nil].
	norm isNil
		ifTrue: [ ^1].
	^x - 1 < alpha
		ifTrue: [ ( self evaluateSeries: x) * norm]
		ifFalse:[ 1 - ( norm / ( self evaluateFraction: x))]! !

!DhbIncompleteGammaFunction methodsFor: 'initialization'!

initialize: aNumber
		"Private - Defines the parameter alpha of the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	alpha := aNumber asFloat.
	alphaLogGamma := alpha logGamma.
	^self! !

DhbIncompleteGammaFunction class
	instanceVariableNames: ''!



!DhbIncompleteGammaFunction class methodsFor: 'creation'!

shape: aNumber
		"Defines a new instance of the receiver with paramater aNumber
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	^super new initialize: aNumber! !

Object subclass: #DhbLinearRegression
	instanceVariableNames: 'sum1 sumX sumY sumXX sumYY sumXY slope intercept correlationCoefficient '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLinearRegression methodsFor: 'information'!

asEstimatedPolynomial
		"Answer the resulting linear dependence found by the receiver in the form of a polynomial
		 with embedded error matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^( DhbEstimatedPolynomial coefficients: self coefficients)
			errorMatrix: self errorMatrix;
			yourself!

asPolynomial
		"Answer the resulting linear dependence found by the receiver in the form of a polynomial.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	^DhbPolynomial coefficients: self coefficients!

coefficients
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^Array with: self intercept with: self slope!

correlationCoefficient
		"Answers the correlation coefficient of the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	correlationCoefficient isNil
		ifTrue: [ self computeResults].
	^correlationCoefficient!

errorMatrix
	"Answer the resulting linear dependence found by the receiver in the form of a polynomial
		 with embedded error matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "

	| c1 cx cxx |
	c1 := 1.0 / (sumXX * sum1 - sumX squared).
	cx := sumX negated * c1.
	cxx := sumXX * c1.
	c1 := sum1 * c1.
	^DhbSymmetricMatrix rows: (Array with: (Array with: cxx with: cx)
				with: (Array with: cx with: c1))!

errorOnIntercept
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/5/99 "

	^(sumXX / (sumXX * sum1 - sumX squared)) sqrt!

errorOnSlope
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/5/99 "

	^(sum1 / (sumXX * sum1 - sumX squared)) sqrt!

intercept
		"Answers the intercept of the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	intercept isNil
		ifTrue: [ self computeResults].
	^intercept!

slope
		"Answers the slope of the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	slope isNil
		ifTrue: [ self computeResults].
	^slope!

value: aNumber
		"Answer the value interpolated at aNumber by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	^aNumber * self slope + self intercept! !

!DhbLinearRegression methodsFor: 'transformation'!

add: aPoint
		"Accumulate aPoint into of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	self add: aPoint weight: 1.!

add: aPoint weight: aNumber 
	"Accumulate aPoint into of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "

	sum1 := sum1 + aNumber.
	sumX := sumX + (aPoint x * aNumber).
	sumY := sumY + (aPoint y * aNumber).
	sumXX := sumXX + (aPoint x squared * aNumber).
	sumYY := sumYY + (aPoint y squared * aNumber).
	sumXY := sumXY + (aPoint x * aPoint y * aNumber).
	self resetResults!

computeResults
	"Private - Compute the results of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "

	| xNorm xyNorm |
	xNorm := sumXX * sum1 - (sumX * sumX).
	xyNorm := sumXY * sum1 - (sumX * sumY).
	slope := xyNorm / xNorm.
	intercept := (sumXX * sumY - (sumXY * sumX)) / xNorm.
	correlationCoefficient := xyNorm 
				/ (xNorm * (sumYY * sum1 - (sumY * sumY))) sqrt!

remove: aPoint 
	"Remove aPoint which was accumulated into of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "

	sum1 := sum1 - 1.
	sumX := sumX - aPoint x.
	sumY := sumY - aPoint y.
	sumXX := sumXX - aPoint x squared.
	sumYY := sumYY - aPoint y squared.
	sumXY := sumXY - (aPoint x * aPoint y).
	self resetResults!

reset
	"Set all accumulators of the receiver to zero and reset its results.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "

	sum1 := 0.
	sumX := 0.
	sumY := 0.
	sumXX := 0.
	sumYY := 0.
	sumXY := 0.
	self resetResults!

resetResults
		"Private - Reset the results of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	slope := nil.
	intercept := nil.
	correlationCoefficient := nil.! !

DhbLinearRegression class
	instanceVariableNames: ''!



!DhbLinearRegression class methodsFor: 'creation'!

new
		"Create a new instance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	^( super new) reset; yourself! !

DhbSeriesTermServer subclass: #DhbIncompleteBetaFractionTermServer
	instanceVariableNames: 'alpha1 alpha2 '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbIncompleteBetaFractionTermServer methodsFor: 'information'!

initialTerm
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	^1!

termsAt: anInteger 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	| n n2 |
	n := anInteger // 2.
	n2 := 2 * n.
	^Array with: ( n2 < anInteger 
		ifTrue: 
			[x negated * (alpha1 + n) * (alpha1 + alpha2 + n) 
				/ ((alpha1 + n2) * (alpha1 + 1 + n2))]
		ifFalse: [x * n * (alpha2 - n) / ((alpha1 + n2) * (alpha1 - 1 + n2))])
			with: 1! !

!DhbIncompleteBetaFractionTermServer methodsFor: 'initialization'!

setParameter: aNumber1 second: aNumber2 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	alpha1 := aNumber1.
	alpha2 := aNumber2! !

DhbIncompleteBetaFractionTermServer class
	instanceVariableNames: ''!


Object subclass: #PointSeries
	instanceVariableNames: 'points '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!PointSeries methodsFor: 'public methods'!

add: anObject
	"Add a point to the receiver"
	self primitiveAdd: anObject.
	self changed: self changedSymbol.
	^anObject!

at: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^points at: anInteger!

changedSymbol
	"Answers the symbol of the event sent when the points of the receiver change"
	^#pointsChanged!

collectPoints: aBlock
	^points collect: aBlock!

do: aBlock
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	self pointsDo: aBlock.!

firstPoint
	"Answers the first point stored in the receiver"
	^self at: 1!

initialize
	"Create the point collection"
	points := SortedCollection sortBlock: self sortBlock.
	^self!

isEmpty
		"
		 (c) Copyrights Didier BESSET, 1998, all rights reserved.
		 Initial code: 28/9/98 "
	^points isEmpty!

notEmpty
	^points notEmpty!

pointCollection
		" Answer the collection of points.
		 (c) Copyrights Didier BESSET, 1998, all rights reserved.
		 Initial code: 28/9/98 "
	^self collectPoints: [ :each | each]!

pointsDo: aBlock
	points do: aBlock.!

remove: anObject
	"Add a point to the receiver"
	self primitiveRemove: anObject.
	self changed: self changedSymbol.
	^anObject!

size
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^points size!

sort
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	points := ( points asSortedCollection: self sortBlock) asOrderedCollection.! !

!PointSeries methodsFor: 'privateMethods'!

primitiveAdd: aPoint
	"Private - Add a point to the receiver"
	points add: aPoint.!

primitiveRemove: aPoint
	"Private - Removes a point from the receiver"
	points remove: aPoint.!

sortBlock
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	^[ :a :b | a x < b x]! !

PointSeries class
	instanceVariableNames: ''!



!PointSeries class methodsFor: 'creation'!

new
	"Create a new instance and initialize it"
	^super new initialize! !

DhbCluster subclass: #DhbEuclideanCluster
	instanceVariableNames: 'center '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbEuclideanCluster methodsFor: 'initialization'!

centerOn: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	center := aVector.
	accumulator := DhbVectorAccumulator new: aVector size.!

isUndefined
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^center isNil! !

!DhbEuclideanCluster methodsFor: 'information'!

distanceTo: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^( aVector - center) norm! !

!DhbEuclideanCluster methodsFor: 'transformation'!

collectAccumulatorResults
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	center := accumulator average copy.! !

!DhbEuclideanCluster methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator count printOn: aStream.
	aStream nextPutAll: ': '.
	center printOn: aStream.! !

DhbEuclideanCluster class
	instanceVariableNames: ''!



!Number methodsFor: 'testing'!

isNumber
	"Coerces numbers to true and everything else to false."

	^true! !

!Number methodsFor: 'converting'!

asLimitedPrecisionReal
	"Convert the receiver to an instance of
	some subclass of LimitedPrecisionReal.
	This method defines what the default is."

	^self asFloat! !

!Number methodsFor: 'information'!

beta: aNumber
		"Computes the beta function of the receiver and aNumber
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	^( self logBeta: aNumber) exp!

equalsTo: aNumber
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	^self relativelyEqualsTo: aNumber upTo: DhbFloatingPointMachine new defaultNumericalPrecision!

errorFunction
		"Answer the error function for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^DhbErfApproximation new value: self!

gamma
	"Compute the Gamma function for the receiver. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 11/2/99"

	^self > 1
		ifTrue: [^DhbLanczosFormula new gamma: self]
		ifFalse: [self < 0
				ifTrue: [Float pi / ((Float pi * self) sin * (1 - self) gamma)]
				ifFalse: [(DhbLanczosFormula new gamma: self + 1)
						/ self]]!

logBeta: aNumber
		"Computes the logarithm of the beta function of the receiver and aNumber
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	^self logGamma + aNumber logGamma - ( self + aNumber) logGamma!

logGamma
		"Computes the log of the Gamma function (for positive numbers only)
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	^self > 1
		ifTrue: [ DhbLanczosFormula new logGamma: self]
		ifFalse:[ self > 0
						ifTrue: [ ( DhbLanczosFormula new logGamma: ( self + 1) ) - self ln ]
						ifFalse: [ ^self error: 'Argument for the log gamma function must be positive']
					]!

random
		"Answers a random number distributed between 0 and the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^self class random * self!

relativelyEqualsTo: aNumber upTo: aSmallNumber
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	| norm |
	norm := self abs max: aNumber abs.
	^norm <= DhbFloatingPointMachine new defaultNumericalPrecision
		or: [ (self - aNumber) abs < ( aSmallNumber * norm)]! !

!Number methodsFor: 'operation'!

addPolynomial: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^aPolynomial addNumber: self!

dividingPolynomial: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^aPolynomial timesNumber: (1 / self)!

productWithMatrix: aMatrix
		"Answer a new matrix, product of aMatrix with the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix class rows: ( aMatrix rowsCollect: [ :each | each * self])!

productWithVector: aVector
		"Answers a new vector product of the receiver with aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aVector collect: [ :each | each * self]!

subtractToPolynomial: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^aPolynomial addNumber: self negated!

timesPolynomial: aPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^aPolynomial timesNumber: self! !


!Number class methodsFor: 'information'!

random
		"Answers a random number between 0 and the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^DhbMitchellMooreGenerator new floatValue! !


!Collection methodsFor: 'converting'!

asVector
	"Convert the receiver to a vector. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 11/2/99"

	| aVector index |
	aVector := DhbVector new: self size.
	index := 0.
	self do: [:each | aVector at: (index := index + 1) put: each].
	^aVector! !


!String methodsFor: 'dhb'!

asInteger
		"(c) Copyrights Didier BESSET, all rights reserved
		 Initial code: 1/6/98 "
	^self inject: 0
			into: [ :ans :each | (ans * 10) + each digitValue]!

beginsWith: aString
		"(c) Copyrights Didier BESSET, all rights reserved
		 Initial code: 1/6/98 "
	| size |
	size := aString size.
	^self size >= size and: [ (self copyFrom: 1 to: size) = aString]! !

Object subclass: #DhbCongruentialRandomNumberGenerator
	instanceVariableNames: 'constant modulus multiplicator seed '
	classVariableNames: 'UniqueInstance '
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbCongruentialRandomNumberGenerator methodsFor: 'initialization'!

initialize
		"Private - Initializes the constants of the receiver with D. Knuth's constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	self initialize: 2718281829.0 multiplicator: 3141592653.0 modulus: 4294967296.0.!

initialize: aNumber1 multiplicator: aNumber2 modulus: aNumber3
		"Private - Initializes the constants needed by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	constant := aNumber1.
	modulus := aNumber2.
	multiplicator := aNumber3.
	self setSeed: 1.! !

!DhbCongruentialRandomNumberGenerator methodsFor: 'information'!

floatValue
		"Answer the next pseudo-random value between 0 and 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self value asFloat / modulus!

integerValue: anInteger
		"Answer a random integer between 0 and the anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( self value  \\ ( anInteger * 1000)) // 1000!

value
		"Answer the next pseudo-random value.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	seed := ( seed * multiplicator + constant) \\ modulus.
	^seed! !

!DhbCongruentialRandomNumberGenerator methodsFor: 'transformation'!

setSeed: aNumber
		"Set the seed of the receiver to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	seed := aNumber.! !

DhbCongruentialRandomNumberGenerator class
	instanceVariableNames: ''!



!DhbCongruentialRandomNumberGenerator class methodsFor: 'creation'!

constant: aNumber1 multiplicator: aNumber2 modulus: aNumber3 
	"Create a new instance of the receiver with given constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new 
		initialize: aNumber1
		multiplicator: aNumber2
		modulus: aNumber3!

new
		"Create a new instance of the receiver with D. Knuth's constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	UniqueInstance isNil
		ifTrue: [ UniqueInstance := super new initialize.
					 UniqueInstance setSeed: 1.
				   ].
	^UniqueInstance!

seed: aNumber
		"Create a new instance of the receiver with given seed
		  using D. Knuth's constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( super new) initialize; setSeed: aNumber; yourself! !

DhbProbabilityDensity subclass: #DhbFisherSnedecorDistribution
	instanceVariableNames: 'dof1 dof2 norm chiSquareDistribution1 chiSquareDistribution2 incompleteBetaFunction '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbFisherSnedecorDistribution methodsFor: 'initialization'!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	norm := ( dof1 ln * ( dof1 / 2) ) + ( dof2 ln * ( dof2 / 2) )
						- ( ( dof1 / 2) logBeta: ( dof2 / 2) ).!

initialize: anInteger1 and: anInteger2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	dof1 := anInteger1.
	dof2 := anInteger2.
	self computeNorm.
	^self! !

!DhbFisherSnedecorDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 Undefined if dof2 is smaller than 3.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^dof2 > 2
		ifTrue: [ dof2 / ( dof2 - 2)]
		ifFalse:[ nil]!

confidenceLevel: aNumber
		"Answer the probability in percent of finding a value
		 distributed according to the receiver outside of the
		 interval [ 1/aNumber, aNumber].
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	aNumber < 0
		ifTrue: [ self error: 'Confidence level argument must be positive'].
	^( 1- ( self acceptanceBetween: aNumber reciprocal and: aNumber)) * 100!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	^1 - ( self incompleteBetaFunction value: ( dof2 / ( aNumber * dof1 + dof2)))!

incompleteBetaFunction
	"Private - Answers the incomplete beta function used to compute
		 the symmetric acceptance integral of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "

	incompleteBetaFunction isNil 
		ifTrue: 
			[incompleteBetaFunction := DhbIncompleteBetaFunction shape: dof2 / 2
						shape: dof1 / 2].
	^incompleteBetaFunction!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: dof1 with: dof2!

random
		"Answer a random number distributed according to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	chiSquareDistribution1 isNil
		ifTrue: [ chiSquareDistribution1 := DhbChiSquareDistribution degreeOfFreedom: dof1.
				  chiSquareDistribution2 := DhbChiSquareDistribution degreeOfFreedom: dof2.
				].
	^chiSquareDistribution1 random * dof2 / ( chiSquareDistribution2 random * dof1)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > 0
		ifTrue: [ ( norm + ( aNumber ln * ( dof1 / 2 - 1) ) - ( (aNumber * dof1 + dof2) ln * ( ( dof1 + dof2) / 2))) exp]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 Undefined if dof2 is smaller than 5.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^dof2 > 4 ifTrue: [ dof2 squared * 2 * ( dof1 + dof2 - 2) / ( ( dof2 - 2) squared * dof1 * ( dof2 - 4))]
				   ifFalse:[ nil]! !

!DhbFisherSnedecorDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	dof1 := ( dof1 + ( aVector at: 1)) max: 1.
	dof2 := ( dof2 + ( aVector at: 2)) max: 1.
	self computeNorm.
	chiSquareDistribution1 := nil.
	chiSquareDistribution2 := nil.
	incompleteBetaFunction := nil.! !

DhbFisherSnedecorDistribution class
	instanceVariableNames: ''!



!DhbFisherSnedecorDistribution class methodsFor: 'creation'!

degreeOfFreedom: anInteger1 degreeOfFreedom: anInteger2 
	"Create a new instance of the receiver with given degrees of freedom.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "

	^super new initialize: anInteger1 and: anInteger2!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "

	| n1 n2 a |
	aHistogram minimum < 0 ifTrue: [^nil].
	n2 := (2 / (1 - (1 / aHistogram average))) rounded.
	n2 > 0 ifFalse: [^nil].
	a := (n2 - 2) * (n2 - 4) * aHistogram variance / (n2 squared * 2).
	n1 := (0.7 * (n2 - 2) / (1 - a)) rounded.
	^n1 > 0 
		ifTrue: [self degreeOfFreedom: n1 degreeOfFreedom: n2]
		ifFalse: [nil]!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

test: aStatisticalMoment1 with: aStatisticalMoment2 
	"Perform a consistency Fisher test (or F-test) on the variances of two statistical moments ( or histograms).
		 Answer the probability of passing the test.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "

	^(self class degreeOfFreedom: aStatisticalMoment1 count
		degreeOfFreedom: aStatisticalMoment2 count) 
			distributionValue: aStatisticalMoment1 variance 
					/ aStatisticalMoment2 variance! !

!DhbFisherSnedecorDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Fisher-Snedecor distribution'! !

DhbIterativeProcess subclass: #DhbJacobiTransformation
	instanceVariableNames: 'lowerRows transform '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbJacobiTransformation methodsFor: 'display'!

printOn: aStream
		"Append to the argument aStream, a sequence of characters that describes the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| first |
	first := true.
	lowerRows do: 
		[ :each |
		  first ifTrue: [ first := false]
				 ifFalse:[ aStream cr].
		  each printOn: aStream.
		].! !

!DhbJacobiTransformation methodsFor: 'information'!

largestOffDiagonalIndices
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| n m abs |
	n := 2.
	m := 1.
	precision := ( ( lowerRows at: n) at: m) abs.
	1 to: lowerRows size do:
		[ :i |
		  1 to: ( i - 1) do:
			[ :j |
			  abs := ( ( lowerRows at: i) at: j) abs.
			  abs > precision
				ifTrue: [ n := i.
						  m := j.
						  precision := abs.
						]. 
			].
		].
	^Array with: m with: n!

transform
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	^DhbMatrix rows: transform! !

!DhbJacobiTransformation methodsFor: 'initialization'!

initialize: aSymmetricMatrix
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| n m |
	n := aSymmetricMatrix numberOfRows.
	lowerRows := Array new: n.
	transform := Array new: n.
	1 to: n do:
		[ :k |
		  lowerRows at: k put: ( ( aSymmetricMatrix rowAt: k) copyFrom: 1 to: k).
		  transform at: k put: ( ( Array new: n) atAllPut: 0; at: k put: 1; yourself).
		].
	^self! !

!DhbJacobiTransformation methodsFor: 'operation'!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| indices |
	indices := self largestOffDiagonalIndices.
	self transformAt: ( indices at: 1) and: ( indices at: 2).
	^precision!

finalizeIterations
	"Transfer the eigenValues into a vector and set this as the result.
		 eigen values and transform matrix are sorted using a bubble sort.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "

	| n |
	n := 0.
	result := lowerRows collect: 
					[:each | 
					n := n + 1.
					each at: n].
	self sortEigenValues! !

!DhbJacobiTransformation methodsFor: 'transformation'!

exchangeAt: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| temp n |
	n := anInteger + 1.
	temp := result at: n.
	result at: n put: ( result at: anInteger).
	result at: anInteger put: temp.
	transform do:
		[ :each |
		  temp := each at: n.
		  each at: n put: ( each at: anInteger).
		  each at: anInteger put: temp.
		].!

sortEigenValues
		"Private - Use a bubble sort.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| n bound m |
	n := lowerRows size.
	bound := n.
	[ bound = 0 ]
		whileFalse: [ m := 0.
					  1 to: bound - 1 do:
						[ :j |
						  ( result at: j) abs > ( result at: j + 1) abs
							ifFalse:[ self exchangeAt: j.
									  m := j.
									].
						].
					  bound := m.
					].!

transformAt: anInteger1 and: anInteger2
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| d t s c tau apq app aqq arp arq |
	apq := ( lowerRows at: anInteger2) at: anInteger1.
	apq = 0
		ifTrue: [ ^nil].
	app := ( lowerRows at: anInteger1) at: anInteger1.
	aqq := ( lowerRows at: anInteger2) at: anInteger2.
	d := aqq - app.
	arp := d * 0.5 / apq.
	t := arp > 0 ifTrue: [ 1 / ( ( arp squared + 1) sqrt + arp)]
				 ifFalse:[ 1 / ( arp - ( arp squared + 1) sqrt)].
	c := 1 / ( t squared + 1) sqrt.
	s := t * c.
	tau := s / ( 1 + c).
	1 to: ( anInteger1 - 1)
		do: [ :r |
			  arp := ( lowerRows at: anInteger1) at: r.
			  arq := ( lowerRows at: anInteger2) at: r.
			  ( lowerRows at: anInteger1) at: r put: ( arp - ( s * (tau * arp + arq))).
			  ( lowerRows at: anInteger2) at: r put: ( arq + ( s * (arp - (tau * arq)))).
			].
	( anInteger1 + 1) to: ( anInteger2 - 1)
		do: [ :r |
			  arp := ( lowerRows at: r) at: anInteger1.
			  arq := ( lowerRows at: anInteger2) at: r.
			  ( lowerRows at: r) at: anInteger1 put: ( arp - ( s * (tau * arp + arq))).
			  ( lowerRows at: anInteger2) at: r put: ( arq + ( s * (arp - (tau * arq)))).
			].
	( anInteger2 + 1) to: lowerRows size
		do: [ :r |
			  arp := ( lowerRows at: r) at: anInteger1.
			  arq := ( lowerRows at: r) at: anInteger2.
			  ( lowerRows at: r) at: anInteger1 put: ( arp - ( s * (tau * arp + arq))).
			  ( lowerRows at: r) at: anInteger2 put: ( arq + ( s * (arp - (tau * arq)))).
			].
	1 to: lowerRows size
		do: [ :r |
			  arp := ( transform at: r) at: anInteger1.
			  arq := ( transform at: r) at: anInteger2.
			  ( transform at: r) at: anInteger1 put: ( arp - ( s * (tau * arp + arq))).
			  ( transform at: r) at: anInteger2 put: ( arq + ( s * (arp - (tau * arq)))).
			].
	( lowerRows at: anInteger1) at: anInteger1 put: ( app - (t * apq)).
	( lowerRows at: anInteger2) at: anInteger2 put: ( aqq + (t * apq)).
	( lowerRows at: anInteger2) at: anInteger1 put: 0.! !

DhbJacobiTransformation class
	instanceVariableNames: ''!



!DhbJacobiTransformation class methodsFor: 'creation'!

matrix: aSymmetricMatrix
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	^super new initialize: aSymmetricMatrix!

new
		"Prevent using this message to create instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	^self error: 'Illegal creation message for this class'! !

DhbProbabilityDensity subclass: #DhbWeibullDistribution
	instanceVariableNames: 'alpha beta norm '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbWeibullDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(1 / alpha) gamma * beta / alpha!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 Assumes that the value of the receiver is 0 for x < 0.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > 0
		ifTrue: [ 1 - ( ( ( aNumber / beta) raisedTo: alpha) negated exp)]
		ifFalse:[ 0]!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha with: beta!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( ( aNumber / beta) raisedTo: alpha) negated exp * ( aNumber raisedTo: ( alpha - 1)) * norm!

variance
		"Answer the variance of the receiver.
		 NOTE: At least one of the methods variance or standardDeviation must be implemented by the subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( beta squared / alpha) * ( (2 / alpha) gamma * 2 - ( (1 / alpha ) gamma squared / alpha))! !

!DhbWeibullDistribution methodsFor: 'initialization'!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	norm := alpha/ ( beta raisedTo: alpha).!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	( aNumber1 > 0 and: [ aNumber2 > 0])
		ifFalse: [ self error: 'Illegal distribution parameters'].
	alpha := aNumber1.
	beta := aNumber2.
	self computeNorm.
	^self!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( (1 - aNumber) ln negated raisedTo: ( 1 / alpha)) * beta! !

!DhbWeibullDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	alpha := alpha + ( aVector at: 1).
	beta := beta + ( aVector at: 2).
	self computeNorm.! !

DhbWeibullDistribution class
	instanceVariableNames: ''!



!DhbWeibullDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| average xMin xMax accMin accMax |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	average := aHistogram average.
	xMin := ( aHistogram minimum + average) / 2.
	accMin := ( aHistogram countsUpTo: xMin) / aHistogram totalCount.
	xMax := ( aHistogram maximum + average) / 2.
	accMax := ( aHistogram countsUpTo: xMax) / aHistogram totalCount.
	^[self solve: xMin acc: accMin upper: xMax acc: accMax]
			on: Error do: [ :signal | signal return: nil]!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

shape: aNumber1 scale: aNumber2 
	"Create an instance of the receiver with given shape and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 scale: aNumber2!

solve: lowX acc: lowAcc upper: highX acc: highAcc 
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "

	| lowLnAcc highLnAcc deltaLnAcc lowLnX highLnX |
	lowLnAcc := (1 - lowAcc) ln negated ln.
	highLnAcc := (1 - highAcc) ln negated ln.
	deltaLnAcc := highLnAcc - lowLnAcc.
	lowLnX := lowX ln.
	highLnX := highX ln.
	^self shape: deltaLnAcc / (highLnX - lowLnX)
		scale: ((highLnAcc * lowLnX - (lowLnAcc * highLnX)) / deltaLnAcc) exp! !

!DhbWeibullDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Weibull distribution'! !

DhbChromosomeManager subclass: #DhbVectorChromosomeManager
	instanceVariableNames: 'origin range '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbVectorChromosomeManager methodsFor: 'creation'!

randomChromosome
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^( ( 1 to: origin size) collect: [ :n | self randomComponent: n]) asVector! !

!DhbVectorChromosomeManager methodsFor: 'initialization'!

origin: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	origin := aVector.!

range: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	range := aVector.! !

!DhbVectorChromosomeManager methodsFor: 'operation'!

crossover: aChromosome1 and: aChromosome2
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| index new1 new2|
	index := ( aChromosome1 size - 1) random + 2.
	new1 := self clone: aChromosome1.
	new1 replaceFrom: index to: new1 size with: aChromosome2 startingAt: index.
	new2 := self clone: aChromosome2.
	new2 replaceFrom: index to: new2 size with: aChromosome1 startingAt: index.
	^Array with: new1 with: new2!

mutate: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| index |
	index := aVector size random + 1.
	^( aVector copy)
			at: index put: ( self randomComponent: index);
			yourself! !

!DhbVectorChromosomeManager methodsFor: 'information'!

randomComponent: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^( range at: anInteger) asFloat random + ( origin at: anInteger)! !

DhbVectorChromosomeManager class
	instanceVariableNames: ''!


DhbIterativeProcess subclass: #DhbLeastSquareFit
	instanceVariableNames: 'dataHolder errorMatrix chiSquare equations constants degreeOfFreedom '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLeastSquareFit methodsFor: 'information'!

chiSquare
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	chiSquare isNil
		ifTrue: [ self computeChiSquare].
	^chiSquare!

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

fitType
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^'Least square fit'!

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

!DhbLeastSquareFit methodsFor: 'initialization'!

initialize: aDataHolder data: aParametricFunction
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	dataHolder := aDataHolder.
	result := aParametricFunction.
	^self! !

!DhbLeastSquareFit methodsFor: 'operation'!

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

computeChanges
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	errorMatrix := DhbLUPDecomposition direct: equations.
	^errorMatrix solve: constants!

computeEquationSystem
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	constants atAllPut: 0.
	equations do: [ :each | each atAllPut: 0].
	self accumulateEquationSystem.!

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
						yourself]! !

DhbLeastSquareFit class
	instanceVariableNames: ''!



!DhbLeastSquareFit class methodsFor: 'creation'!

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

DhbLeastSquareFit subclass: #DhbMaximumLikekihoodHistogramFit
	instanceVariableNames: 'count countVariance '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbMaximumLikekihoodHistogramFit methodsFor: 'information'!

fitType
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^'Maximum likelihood fit'!

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

!DhbMaximumLikekihoodHistogramFit methodsFor: 'operation'!

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

initializeIterations
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "

	result setCount: 1.
	count := dataHolder totalCount.
	super initializeIterations! !

DhbMaximumLikekihoodHistogramFit class
	instanceVariableNames: ''!


DhbIterativeProcess subclass: #DhbClusterFinder
	instanceVariableNames: 'dataServer dataSetSize minimumRelativeClusterSize '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbClusterFinder methodsFor: 'initialization'!

dataServer: aClusterDataServer
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/18/00 "
	dataServer := aClusterDataServer.!

minimumRelativeClusterSize: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	minimumRelativeClusterSize := aNumber max: 0.! !

!DhbClusterFinder methodsFor: 'information'!

clusters: aCollectionOfClusters
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/18/00 "
	result := aCollectionOfClusters.!

indexOfNearestCluster: aVector
		"Private - Answers the index of the cluster nearest to aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	| distance index |
	index := 1.
	distance := ( result at: 1) distanceTo: aVector.
	2 to: result size do:
		[ :n | | x |
		  x := ( result at: n) distanceTo: aVector.
		  x < distance
			ifTrue: [ distance := x.
					  index := n.
					].
		].
	^index!

initialize: anInteger server: aClusterDataServer type: aClusterClass
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self dataServer: aClusterDataServer.
	self clusters: ( (1 to: anInteger) collect: [ :n | aClusterClass new]).
	minimumRelativeClusterSize := 0.
	^self!

minimumClusterSize
	^(minimumRelativeClusterSize * dataSetSize) rounded! !

!DhbClusterFinder methodsFor: 'operation'!

evaluateIteration
		"Perform an accumulation of the data from the server.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	dataServer reset.
	dataSetSize := 0.
	[ dataServer atEnd]
		whileFalse:[ self accumulate: dataServer next.
					 dataSetSize := dataSetSize + 1.
					].
	^self collectChangesAndResetClusters!

finalizeIterations
	"Close the data server.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "

	dataServer close!

initializeIterations
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "

	dataServer open.
	result 
		do: [:each | each isUndefined ifTrue: [each centerOn: dataServer next]]! !

!DhbClusterFinder methodsFor: 'transformation'!

accumulate: aVector
		"Private - Accumulate aVector into the nearest cluster.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	( result at: ( self indexOfNearestCluster: aVector)) accumulate: aVector.!

collectChangesAndResetClusters
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "

	| hasEmptyClusters changes |
	changes := 0.
	hasEmptyClusters := false.
	result do: 
			[:each | 
			changes := each changes + changes.
			( each isInsignificantIn: self)
				ifTrue: 
					[each centerOn: nil.
					hasEmptyClusters := true]
				ifFalse: [each reset].
			].
	hasEmptyClusters 
		ifTrue: [result := result reject: [:each | each isUndefined]].
	^changes / 2! !

!DhbClusterFinder methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	aStream nextPutAll: 'Iterations: '.
	iterations printOn: aStream.
	result do: [ :each | aStream cr. each printOn: aStream].! !

DhbClusterFinder class
	instanceVariableNames: ''!



!DhbClusterFinder class methodsFor: 'creation'!

new: anInteger server: aClusterDataServer type: aClusterClass
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	^super new initialize: anInteger server: aClusterDataServer type: aClusterClass! !


!Integer methodsFor: 'information'!

gamma
		"Compute the Gamma function for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	self > 0
		ifFalse:[ ^self error: 'Attempt to compute the Gamma function of a non-positive integer'].
	^( self - 1) factorial!

random
		"Answer a random integer between 0 and the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^DhbMitchellMooreGenerator new integerValue: self! !

DhbFunctionOptimizer subclass: #DhbGeneticOptimizer
	instanceVariableNames: 'chromosomeManager '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbGeneticOptimizer methodsFor: 'information'!

computePrecision
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^1!

randomIndex: aNumberArray
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| x n |
	x := Number random.
	n := 1.
	aNumberArray do: 
		[ :each |
		  x < each
			ifTrue: [ ^n].
		  n := n + 1.
		].
	^aNumberArray size	"Never reached unless an error occurs"!

randomScale
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| norm fBest fWorst answer|
	fBest := bestPoints first value.
	fWorst := bestPoints last value.
	norm := 1 / ( fBest - fWorst).
	answer := bestPoints collect: [ :each | (each value - fWorst) * norm].
	norm := 1 / ( answer inject: 0 into: [ :sum :each | each + sum]).
	fBest := 0.
	^answer collect: [ :each | fBest := each * norm + fBest. fBest]! !

!DhbGeneticOptimizer methodsFor: 'initialization'!

chromosomeManager: aChromosomeManager
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	chromosomeManager := aChromosomeManager.
	^self! !

!DhbGeneticOptimizer methodsFor: 'operation'!

collectPoints
	"Private - 
	(c) Copyrights Didier BESSET, 2000, all rights reserved. 
	Initial code: 23-Feb-00"

	| bestPoint |
	bestPoints isEmpty not ifTrue: [bestPoint := bestPoints removeFirst].
	bestPoints removeAll: bestPoints asArray.
	chromosomeManager population do: [:each | self addPointAt: each].
	bestPoint notNil ifTrue: [bestPoints add: bestPoint].
	result := bestPoints first position!

evaluateIteration
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| randomScale |
	randomScale := self randomScale.
	chromosomeManager reset.
	[ chromosomeManager isFullyPopulated]
		whileFalse: [ self processRandomParents: randomScale].
	self collectPoints.
	^self computePrecision!

initializeIterations
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	chromosomeManager randomizePopulation.
	self collectPoints!

processRandomParents: aNumberArray
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	chromosomeManager process: ( bestPoints at: ( self randomIndex: aNumberArray)) position
						and:  ( bestPoints at: ( self randomIndex: aNumberArray)) position.! !

DhbGeneticOptimizer class
	instanceVariableNames: ''!



!DhbGeneticOptimizer class methodsFor: 'information'!

defaultMaximumIterations
		"Private - Answers the default maximum number of iterations for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^500!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^0! !

DhbStatisticalMoments subclass: #DhbFastStatisticalMoments
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbFastStatisticalMoments methodsFor: 'information'!

average
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	self count = 0 ifTrue: [^nil].
	^(moments at: 2) / self count!

kurtosis
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| var x1 x2 x3 x4 kFact kConst n m4 xSquared |
	n := self count.
	n < 4 ifTrue: [^nil].
	var := self variance.
	var = 0 ifTrue: [^nil].
	x1 := (moments at: 2) / n.
	x2 := (moments at: 3) / n.
	x3 := (moments at: 4) / n.
	x4 := (moments at: 5) / n.
	xSquared := x1 squared.
	m4 := x4 - (4 * x1 * x3) + (6 * x2 * xSquared) - (xSquared squared * 3).
	kFact := n * (n + 1) / (n - 1) / (n - 2) / (n - 3).
	kConst := 3 * (n - 1) * (n - 1) / (n - 2) / (n - 3).
	^kFact * (m4 * n / var squared) - kConst!

skewness
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| x1 x2 x3 n stdev |
	n := self count.
	n < 3 ifTrue: [^nil].
	stdev := self standardDeviation.
	stdev = 0 ifTrue: [^nil].
	x1 := (moments at: 2) / n.
	x2 := (moments at: 3) / n.
	x3 := (moments at: 4) / n.
	^(x3 - (3 * x1 * x2) + (2 * x1 * x1 * x1)) * n * n 
		/ (stdev squared * stdev * (n - 1) * (n - 2))!

unnormalizedVariance
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "

	^(moments at: 3) - ((moments at: 2) squared * self count)!

variance
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| n |
	n := self count.
	n < 2 ifTrue: [^nil].
	^((moments at: 3) - ((moments at: 2) squared / n)) / (n - 1)! !

!DhbFastStatisticalMoments methodsFor: 'transformation'!

accumulate: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| var |
	var := 1.
	1 to: moments size
		do: 
			[:n | 
			moments at: n put: (moments at: n) + var.
			var := var * aNumber]! !

DhbFastStatisticalMoments class
	instanceVariableNames: ''!


DhbFunctionOptimizer subclass: #DhbSimplexOptimizer
	instanceVariableNames: 'worstVector '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbSimplexOptimizer methodsFor: 'display'!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	super printOn: aStream.
	aStream cr. 
	worstVector printOn: aStream.! !

!DhbSimplexOptimizer methodsFor: 'initialization'!

computeInitialValues
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	bestPoints 
		add: (optimizingPointClass vector: result function: functionBlock).
	self buildInitialSimplex.
	worstVector := bestPoints removeLast position! !

!DhbSimplexOptimizer methodsFor: 'operation'!

buildInitialSimplex
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	| projectedFunction finder partialResult |
	projectedFunction := DhbProjectedOneVariableFunction 
				function: functionBlock.
	finder := DhbOneVariableFunctionOptimizer forOptimizer: self.
	finder setFunction: projectedFunction.
	[bestPoints size < (result size + 1)] whileTrue: 
			[projectedFunction
				setArgument: result;
				bumpIndex.
			partialResult := finder
						reset;
						evaluate.
			bestPoints add: (optimizingPointClass 
						vector: (projectedFunction argumentWith: partialResult)
						function: functionBlock)]!

computePrecision
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/16/00 "
	| functionValues bestFunctionValue |
	functionValues := bestPoints collect: [ :each | each value].
	bestFunctionValue := functionValues removeFirst.
	^functionValues inject: 0
					into: [ :max :each | ( self precisionOf: ( each - bestFunctionValue) abs relativeTo: bestFunctionValue abs) max: max]!

contract
	"Private - Contract the Simplex around the best Vector.
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/16/00 "

	| bestVector oldVectors |
	bestVector := bestPoints first position.
	oldVectors := OrderedCollection with: worstVector.
	[bestPoints size > 1] whileTrue: [oldVectors add: bestPoints removeLast position].
	oldVectors do: [:each | self contract: each around: bestVector].
	worstVector := bestPoints removeLast position.
	^self computePrecision!

contract: aVector around: bestVector 
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/16/00 "

	bestPoints 
		add: (optimizingPointClass vector: bestVector * 0.5 + (aVector * 0.5)
				function: functionBlock)!

evaluateIteration
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	| centerOfGravity newPoint nextPoint |
	centerOfGravity := (bestPoints inject: ((worstVector copy)
						atAllPut: 0;
						yourself)
				into: [:sum :each | each position + sum]) * (1 / bestPoints size).
	newPoint := optimizingPointClass vector: 2 * centerOfGravity - worstVector
				function: functionBlock.
	(newPoint betterThan: bestPoints first) 
		ifTrue: 
			[nextPoint := optimizingPointClass 
						vector: newPoint position * 2 - centerOfGravity
						function: functionBlock.
			(nextPoint betterThan: newPoint) ifTrue: [newPoint := nextPoint]]
		ifFalse: 
			[newPoint := optimizingPointClass 
						vector: centerOfGravity * 0.666667 + (worstVector * 0.333333)
						function: functionBlock.
			(newPoint betterThan: bestPoints first) ifFalse: [^self contract]].
	worstVector := bestPoints removeLast position.
	bestPoints add: newPoint.
	result := bestPoints first position.
	^self computePrecision! !

DhbSimplexOptimizer class
	instanceVariableNames: ''!



!DhbSimplexOptimizer class methodsFor: 'information'!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^DhbFloatingPointMachine new defaultNumericalPrecision * 1000! !

DhbProbabilityDensity subclass: #DhbHistogrammedDistribution
	instanceVariableNames: 'histogram '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbHistogrammedDistribution methodsFor: 'information'!

acceptanceBetween: aNumber1 and: aNumber2
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value larger than aNumber 1 and lower than or equal to aNumber2.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( histogram countsBetween: ( aNumber1 max: histogram minimum)
						and: ( aNumber2 min: histogram maximum) ) / histogram totalCount!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^histogram average!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber < histogram minimum
		ifTrue: [ 0]
		ifFalse:[ aNumber < histogram maximum
							ifTrue: [ ( histogram countsUpTo: aNumber) / histogram totalCount]
							ifFalse:[ 1]
					]!

kurtosis
		"Answer the kurtosis of the receiver.
		 Undefined. Must be implemented by subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^histogram kurtosis!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose distribution is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^histogram inverseDistributionValue: aNumber!

skewness
		"Answer the skewness of the receiver.
		 Undefined. Must be implemented by subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^histogram skewness!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^histogram standardDeviation!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^( aNumber >= histogram minimum and: [ aNumber < histogram maximum])
		ifTrue: [ ( histogram countAt: aNumber) / ( histogram totalCount * histogram binWidth)]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^histogram variance! !

!DhbHistogrammedDistribution methodsFor: 'initialization'!

initialize: aHistogram
		"Private - Defines the histogram of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	aHistogram count = 0
		ifTrue: [ self error: 'Cannot define probability density on an empty histogram'].
	histogram := aHistogram.
	^self! !

DhbHistogrammedDistribution class
	instanceVariableNames: ''!



!DhbHistogrammedDistribution class methodsFor: 'creation'!

histogram: aHistogram
		"Create a new instance of the receiver corresponding to a histogram.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^super new initialize: aHistogram!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'! !

!DhbHistogrammedDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Experimental distribution'! !

DhbFunctionalIterator subclass: #DhbNewtonZeroFinder
	instanceVariableNames: 'derivativeBlock '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbNewtonZeroFinder methodsFor: 'initialization'!

initialValue: aNumber
		"Define the initial value for the iterations.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	result := aNumber.!

setDerivative: aBlock 
	"Defines the derivative of the function for which zeroes will be found. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 7/1/99"

	| x |
	(aBlock respondsTo: #value:)
		ifFalse: [self error: 'Derivative block must implement the method value:'].
	x := result isNil
				ifTrue: [Number random]
				ifFalse: [result + Number random].
	((aBlock value: x)
		relativelyEqualsTo: (self defaultDerivativeBlock value: x)
		upTo: 1.0e-4)
		ifFalse: [self error: 'Supplied derivative is not correct'].
	derivativeBlock := aBlock!

setFunction: aBlock
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	super setFunction: aBlock.
	derivativeBlock := nil.! !

!DhbNewtonZeroFinder methodsFor: 'operation'!

computeInitialValues
		"Private - If no derivative has been defined, take an ad-hoc definition.
		 If no initial value has been defined, take 0 as the starting point (for lack of anything better).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	| n |
	result isNil
		ifTrue: [ result := 0].
	derivativeBlock isNil
		ifTrue: [ derivativeBlock := self defaultDerivativeBlock].
	n := 0.
	[ (derivativeBlock value: result) equalsTo: 0]
		whileTrue: [ n := n + 1.
					 n > maximumIterations
						ifTrue: [ self error: 'Function''s derivative seems to be zero everywhere'].
					 result := Number random + result].!

evaluateIteration
		"Compute one step of Newton's zero finding method. Answers the estimated precision.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	| delta |
	delta := ( functionBlock value: result) / ( derivativeBlock value: result).
	result := result - delta.
	^self relativePrecision: delta abs! !

!DhbNewtonZeroFinder methodsFor: 'information'!

defaultDerivativeBlock
		"Private - Answers a block computing the function's derivative by approximation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^[ :x | 5000 * ( ( functionBlock value: (x + 0.0001)) - ( functionBlock value: (x - 0.0001)))]! !

DhbNewtonZeroFinder class
	instanceVariableNames: ''!



!DhbNewtonZeroFinder class methodsFor: 'creation'!

function: aBlock1 derivative: aBlock2
		"Convenience method to create a instance with given function block.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^(self new) setFunction: aBlock1; setDerivative: aBlock2; yourself! !

Object subclass: #DhbLagrangeInterpolator
	instanceVariableNames: 'pointCollection '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLagrangeInterpolator methodsFor: 'information'!

defaultSamplePoints
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	^OrderedCollection new!

size
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 3/12/00 "
	^pointCollection size!

value: aNumber
		"Compute the value of the Lagrange interpolation polynomial on the receiver's points at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| norm dx products answer size |
	norm := 1.
	size := pointCollection size.
	products := Array new: size.
	products atAllPut: 1.
	1 to: size
		do: [ :n |
			  dx := aNumber - ( self xPointAt: n).
			  dx = 0
				ifTrue: [ ^( self yPointAt: n)].
			  norm := norm * dx.
			  1 to: size
				do: [ :m |
					  m = n
						ifFalse:[ products at: m put: ( (( self xPointAt: m) - ( self xPointAt: n)) * ( products at: m))].
					].
			].
	answer := 0.
	1 to: size do:
		[ :n | answer := ( self yPointAt: n) / ( ( products at: n) * ( aNumber - ( self xPointAt: n))) + answer].
	^norm * answer!

xPointAt: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^( pointCollection at: anInteger) x!

yPointAt: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^( pointCollection at: anInteger) y! !

!DhbLagrangeInterpolator methodsFor: 'initialization'!

initialize
		"Private - Create an empty point collection for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self initialize: self defaultSamplePoints!

initialize: aCollectionOfPoints
		"Private - Defines the collection of points for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	pointCollection := aCollectionOfPoints.
	^self! !

!DhbLagrangeInterpolator methodsFor: 'transformation'!

add: aPoint
		"Add a point to the collection of points.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^pointCollection add: aPoint! !

DhbLagrangeInterpolator class
	instanceVariableNames: ''!



!DhbLagrangeInterpolator class methodsFor: 'creation'!

new
		"Create a new instance of the receiver without points. Points must be added with add:
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^super new initialize!

points: aCollectionOfPoints
		"Create a new instance of the receiver with given points.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self new initialize: aCollectionOfPoints! !

DhbLagrangeInterpolator subclass: #DhbNewtonInterpolator
	instanceVariableNames: 'coefficients '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbNewtonInterpolator methodsFor: 'information'!

computeCoefficients
		"Private - Computes the coefficients for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| size k1 kn|
	size := pointCollection size.
	coefficients := ( 1 to: size) collect: [ :n | self yPointAt: n].
	1 to: (size - 1)
		do: [ :n |
			  size to: ( n + 1)  by: -1
				do: [ :k |
					  k1 := k - 1.
					  kn := k - n.
					  coefficients at: k put: ( (( coefficients at: k) - ( coefficients at: k1)) 
											/ ((self xPointAt: k) - (self xPointAt: kn))).
					].
			].!

value: aNumber
		"Compute the value of the Lagrange interpolation polynomial on the receiver's points at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| answer size |
	coefficients isNil
		ifTrue: [ self computeCoefficients].
	size := coefficients size.
	answer := coefficients at: size.
	(size - 1) to: 1 by: -1
		do: [ :n | answer := answer * ( aNumber - (self xPointAt:  n)) + ( coefficients at: n)].
	^answer! !

!DhbNewtonInterpolator methodsFor: 'transformation'!

add: aPoint
		"Add a point to the collection of points.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	self resetCoefficients.
	^super add: aPoint!

resetCoefficients
		"Private - Reset the coefficients of the receiver to force a new computation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	coefficients := nil.! !

DhbNewtonInterpolator class
	instanceVariableNames: ''!


DhbNewtonInterpolator subclass: #DhbSplineInterpolator
	instanceVariableNames: 'startPointDerivative endPointDerivative '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbSplineInterpolator methodsFor: 'information'!

defaultSamplePoints
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	^SortedCollection sortBlock: [ :a :b | a x < b x]!

resetEndPointDerivatives
		"Set the end point derivatives to undefined.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	self setEndPointDerivatives: ( Array new: 2).!

setEndPointDerivatives: anArray
		"Defines the end point derivatives.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	startPointDerivative := anArray at: 1.
	endPointDerivative := anArray at: 2.
	self resetCoefficients.!

startPointDerivative: aNumber
		"Defines the end point derivatives.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	startPointDerivative := aNumber.
	self resetCoefficients.!

value: aNumber 
	"Computes the value of a cubic spline interpolation over the points of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "

	| n1 n2 n step a b |
	coefficients isNil ifTrue: [self computeSecondDerivatives].
	n2 := pointCollection size.
	n1 := 1.
	[n2 - n1 > 1] whileTrue: 
			[n := (n1 + n2) // 2.
			(self xPointAt:  n) > aNumber ifTrue: [n2 := n] ifFalse: [n1 := n]].
	step := (self xPointAt: n2) - (self xPointAt: n1).
	a := ((self xPointAt: n2) - aNumber) / step.
	b := (aNumber - (self xPointAt: n1)) / step.
	^a * (self yPointAt: n1) + (b * (self yPointAt: n2)) 
		+ ((a * (a squared - 1) * (coefficients at: n1) 
				+ (b * (b squared - 1) * (coefficients at: n2))) * step squared 
				/ 6)! !

!DhbSplineInterpolator methodsFor: 'initialization'!

endPointDerivative: aNumber
		"Defines the end point derivatives.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	endPointDerivative := aNumber.
	self resetCoefficients.! !

!DhbSplineInterpolator methodsFor: 'transformation'!

computeSecondDerivatives
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "

	| size u w s dx inv2dx |
	size := pointCollection size.
	coefficients := Array new: size.
	u := Array new: size - 1.
	startPointDerivative isNil 
		ifTrue: 
			[coefficients at: 1 put: 0.
			u at: 1 put: 0]
		ifFalse: 
			[coefficients at: 1 put: -1 / 2.
			s := 1 / (( self xPointAt: 2) x - ( self xPointAt: 1) x).
			u at: 1
				put: 3 * s 
						* (s * (( self yPointAt: size) - ( self yPointAt: size - 1)) 
								- startPointDerivative)].
	2 to: size - 1
		do: 
			[:n | 
			dx := (self xPointAt: n) - (self xPointAt: ( n - 1)).
			inv2dx := 1 / (( self xPointAt: n + 1) - (self xPointAt: n - 1)).
			s := dx * inv2dx.
			w := 1 / (s * (coefficients at: n - 1) + 2).
			coefficients at: n put: (s - 1) * w.
			u at: n
				put: (((( self yPointAt: n + 1) - ( self yPointAt: n)) 
						/ (( self xPointAt: n + 1) - ( self xPointAt: n)) 
							- ((( self yPointAt: n) - ( self yPointAt: n - 1)) / dx)) * 6 
						* inv2dx - ((u at: n - 1) * s)) 
						* w].
	endPointDerivative isNil 
		ifTrue: [coefficients at: size put: 0]
		ifFalse: 
			[w := 1 / 2.
			s := 1 / ((self xPointAt:  size) - (self xPointAt: ( size - 1))).
			u at: 1
				put: 3 * s * (endPointDerivative 
								- (s * (self yPointAt: size) - (self yPointAt: size - 1))).
			coefficients at: size
				put: s - (w * (u at: size - 1) / ((coefficients at: size - 1) * w + 1))].
	size - 1 to: 1
		by: -1
		do: 
			[:n | 
			coefficients at: n
				put: (coefficients at: n) * (coefficients at: n + 1) + (u at: n)]! !

DhbSplineInterpolator class
	instanceVariableNames: ''!


DhbLagrangeInterpolator subclass: #DhbNevilleInterpolator
	instanceVariableNames: 'leftErrors rightErrors '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbNevilleInterpolator methodsFor: 'information'!

computeDifference: aNumber at: anInteger1 order: anInteger2
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 28/5/99 "
	| leftDist rightDist ratio |
	leftDist := ( self xPointAt: anInteger1) - aNumber.
	rightDist := (  self xPointAt: ( anInteger1 + anInteger2)) - aNumber.
	ratio := ( ( leftErrors at: ( anInteger1 + 1)) - ( rightErrors at: anInteger1)) / ( leftDist - rightDist).
	leftErrors at: anInteger1 put: ratio * leftDist.
	rightErrors at: anInteger1 put: ratio * rightDist.!

defaultSamplePoints
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	^SortedCollection sortBlock: [ :a :b | a x < b x]!

initializeDifferences: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 28/5/99 "
	| size nearestIndex dist minDist |
	size := pointCollection size.
	leftErrors size = size
		ifFalse:[ leftErrors := Array new: size.
				  rightErrors := Array new: size.
				].
	minDist := ( ( self xPointAt: 1) - aNumber) abs.
	nearestIndex := 1.
	leftErrors at: 1 put: ( self yPointAt: 1).
	rightErrors at: 1 put: leftErrors first.
	2 to: size do:
		[ :n |
		  dist := ( ( self xPointAt: n) - aNumber) abs.
		  dist < minDist
			ifTrue: [ dist = 0
						ifTrue: [ ^n negated].
					  nearestIndex := n.
					  minDist := dist.
					].
		 leftErrors at: n put: ( self yPointAt: n).
		 rightErrors at: n put: ( leftErrors at: n).
		].
	^nearestIndex!

value: aNumber
		"Compute the value of the Lagrange interpolation polynomial on the receiver's points at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	^(self valueAndError: aNumber) first!

valueAndError: aNumber
		"Compute and return the interpolated value of the interpolation Lagranage polynomial
		 and its estimated error.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	| size nearestIndex answer error |
	nearestIndex := self initializeDifferences: aNumber.
	nearestIndex < 0
		ifTrue: [ ^Array with: ( self yPointAt: nearestIndex negated) with: 0].
	answer := leftErrors at: nearestIndex.
	nearestIndex := nearestIndex - 1.
	size := pointCollection size.
	1 to: ( size - 1) do:
		[ :m |
		  1 to: ( size - m) do:
			[ :n | self computeDifference: aNumber at: n order: m].
		  size - m > ( 2 * nearestIndex)
				ifTrue: [ error := leftErrors at: ( nearestIndex + 1) ]
				ifFalse:[ error := rightErrors at: ( nearestIndex).
							  nearestIndex := nearestIndex - 1.
							].
		  answer := answer + error.
		].
	^Array with: answer with: error abs! !

DhbNevilleInterpolator class
	instanceVariableNames: ''!


DhbNevilleInterpolator subclass: #DhbBulirschStoerInterpolator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbBulirschStoerInterpolator methodsFor: 'information'!

computeDifference: aNumber at: anInteger1 order: anInteger2
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 28/5/99 "
	| diff ratio |
	ratio := ( ( self xPointAt: anInteger1) - aNumber) * ( rightErrors at: anInteger1)
							/ ( (  self xPointAt: ( anInteger1 + anInteger2)) - aNumber).
	diff := ( ( leftErrors at: ( anInteger1 + 1)) - ( rightErrors at: anInteger1))
							/ ( ratio - ( leftErrors at: ( anInteger1 + 1))).
	rightErrors at: anInteger1 put: ( leftErrors at: ( anInteger1 + 1)) * diff.	
	leftErrors at: anInteger1 put: ratio * diff.! !

DhbBulirschStoerInterpolator class
	instanceVariableNames: ''!


Object subclass: #DhbFloatingPointMachine
	instanceVariableNames: 'defaultNumericalPrecision radix machinePrecision negativeMachinePrecision smallestNumber largestNumber smallNumber largestExponentArgument '
	classVariableNames: 'UniqueInstance '
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbFloatingPointMachine methodsFor: 'information'!

computeLargestNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/6/99 "
	| one floatingRadix fullMantissaNumber |

	one := 1.0.
	floatingRadix := self radix asFloat.
	fullMantissaNumber := one - ( floatingRadix * self negativeMachinePrecision).
	largestNumber := fullMantissaNumber.
	[ [ fullMantissaNumber := fullMantissaNumber * floatingRadix.
	    largestNumber := fullMantissaNumber.
		true] whileTrue: [ ].
		] on: Error do: [ :signal | signal return: nil].!

computeMachinePrecision
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	| one zero inverseRadix tmp |
	one := 1.0.
	zero := 0.0.
	inverseRadix := one / self radix asFloat.
	machinePrecision := one.
	[ tmp := one + machinePrecision.
	  tmp - one = zero]
		whileFalse:[  machinePrecision := machinePrecision * inverseRadix].!

computeNegativeMachinePrecision
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	| one zero floatingRadix inverseRadix tmp |
	one := 1.0.
	zero := 0.0.
	floatingRadix := self radix asFloat.
	inverseRadix := one / floatingRadix.
	negativeMachinePrecision := one.
	[ tmp := one - negativeMachinePrecision.
	  tmp - one = zero]
		whileFalse:[ negativeMachinePrecision := negativeMachinePrecision * inverseRadix].!

computeRadix
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	| one zero a b tmp1 tmp2|
	one := 1.0.
	zero := 0.0.
	a := one.
	[ a := a + a.
	  tmp1 := a + one.
	  tmp2 := tmp1 - a.
	  tmp2 - one = zero] whileTrue:[].
	b := one.
	[ b := b + b.
	  tmp1 := a + b.
	  radix := ( tmp1 - a) truncated.
	  radix = 0 ] whileTrue: [].!

computeSmallestNumber
	"Private - 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 11/6/99"

	| one floatingRadix inverseRadix fullMantissaNumber |
	one := 1 asFloat.
	floatingRadix := self radix asFloat.
	inverseRadix := one / floatingRadix.
	fullMantissaNumber := one - (floatingRadix * self negativeMachinePrecision).
	smallestNumber := fullMantissaNumber.
	[[fullMantissaNumber := fullMantissaNumber * inverseRadix.
	fullMantissaNumber = 0.0 ifTrue: [Error raise].
	smallestNumber := fullMantissaNumber.
	true]
		whileTrue: []]
		on: Error do: [:signal | signal return: nil]!

defaultNumericalPrecision
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	defaultNumericalPrecision isNil
		ifTrue: [ defaultNumericalPrecision := self machinePrecision sqrt].
	^defaultNumericalPrecision!

largestExponentArgument
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/18/00 "
	largestExponentArgument isNil
		ifTrue: [ largestExponentArgument := self largestNumber ln].
	^largestExponentArgument!

largestNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/5/99 "
	largestNumber isNil
		ifTrue: [ self computeLargestNumber].
	^largestNumber!

machinePrecision
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	machinePrecision isNil
		ifTrue: [ self computeMachinePrecision].
	^machinePrecision!

negativeMachinePrecision
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	negativeMachinePrecision isNil
		ifTrue: [ self computeNegativeMachinePrecision].
	^negativeMachinePrecision!

radix
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	radix isNil
		ifTrue: [ self computeRadix].
	^radix!

smallestNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/5/99 "
	smallestNumber isNil
		ifTrue: [ self computeSmallestNumber].
	^smallestNumber!

smallNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/5/99 "
	smallNumber isNil
		ifTrue: [ smallNumber := self smallestNumber sqrt].
	^smallNumber! !

!DhbFloatingPointMachine methodsFor: 'display'!

showParameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/6/99 "
	Transcript cr; cr;
			nextPutAll: 'Floating-point machine parameters'; cr;
			nextPutAll: '---------------------------------';cr;
			nextPutAll: 'Radix: '.
	self radix printOn: Transcript.
	Transcript cr; nextPutAll: 'Machine precision: '.
	self machinePrecision printOn: Transcript.
	Transcript cr; nextPutAll: 'Negative machine precision: '.
	self negativeMachinePrecision printOn: Transcript.
	Transcript cr; nextPutAll: 'Smallest number: '.
	self smallestNumber printOn: Transcript.
	Transcript cr; nextPutAll: 'Largest number: '.
	self largestNumber printOn: Transcript.! !

DhbFloatingPointMachine class
	instanceVariableNames: ''!



!DhbFloatingPointMachine class methodsFor: 'creation'!

new
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	UniqueInstance = nil
		ifTrue: [ UniqueInstance := super new].
	^UniqueInstance!

reset
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	UniqueInstance := nil.! !

DhbGammaDistribution subclass: #DhbChiSquareDistribution
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbChiSquareDistribution methodsFor: 'information'!

confidenceLevel: aNumber
		"Answer the probability in percent of finding a chi square value
		 distributed according to the receiver larger than aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	^( 1 - ( self distributionValue: aNumber)) *100!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha * 2! !

!DhbChiSquareDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 13/4/99 "
	super changeParametersBy: (Array with: aVector first / 2 with: 0).! !

DhbChiSquareDistribution class
	instanceVariableNames: ''!



!DhbChiSquareDistribution class methodsFor: 'creation'!

degreeOfFreedom: anInteger
		"Create a new instance of the receiver with given degree of freedom.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^anInteger > 40
		ifTrue: [ DhbAsymptoticChiSquareDistribution degreeOfFreedom: anInteger]
		ifFalse:[ super shape: anInteger / 2 scale: 2]!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| dof |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	dof := aHistogram average rounded.
	^dof > 0 ifTrue: [ self degreeOfFreedom: aHistogram average rounded]
			 ifFalse:[ nil]!

shape: aNumber1 scale: aNumber2
		"Create an instance of the receiver with given shape and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'! !

!DhbChiSquareDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Chi square distribution'! !


!Point methodsFor: 'dhb'!

extentFromBottomLeft: aPoint
		"(c) Copyrights Didier BESSET, 1998, all rights reserved
		 Initial code: 21/4/98 "
	^Rectangle origin: ( self - ( 0 @ ( aPoint isInteger ifTrue: [ aPoint]
														 ifFalse:[ aPoint y])))
			   extent: aPoint!

extentFromBottomRight: aPoint
		"(c) Copyrights Didier BESSET, 1998, all rights reserved
		 Initial code: 21/4/98 "
	^Rectangle origin: ( self - aPoint) extent: aPoint!

extentFromCenter: aPoint
		"(c) Copyrights Didier BESSET, 1998, all rights reserved
		 Initial code: 21/4/98 "
	^Rectangle origin: ( self - ( aPoint // 2)) extent: aPoint!

extentFromTopLeft: aPoint
		"(c) Copyrights Didier BESSET, 1998, all rights reserved
		 Initial code: 21/4/98 "
	^Rectangle origin: self extent: aPoint!

extentFromTopRight: aPoint
		"(c) Copyrights Didier BESSET, 1998, all rights reserved
		 Initial code: 21/4/98 "
	^Rectangle origin: ( self - ( ( aPoint isInteger ifTrue: [ aPoint]
													 ifFalse:[ aPoint x]) @ 0))
			   extent: aPoint! !

DhbIterativeProcess subclass: #DhbIncompleteBetaFunctionFraction
	instanceVariableNames: 'x q1 q2 q3 numerator denominator alpha1 alpha2 '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbIncompleteBetaFunctionFraction methodsFor: 'initialization'!

initialize: aNumber1 shape: aNumber2 
	"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	alpha1 := aNumber1.
	alpha2 := aNumber2.
	q1 := alpha1 + alpha2.
	q2 := alpha1 + 1.
	q3 := alpha1 - 1.
	^self!

setArgument: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	x := aNumber.! !

!DhbIncompleteBetaFunctionFraction methodsFor: 'operation'!

evaluateIteration
	"Compute and add the next term of the fraction.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	| m m2 temp |
	m := iterations + 1.
	m2 := m * 2.
	temp := m * (alpha2 - m) * x 
				/ ((q3 + m2) * (alpha1 + m2)).
	denominator := self limitedSmallValue: ( denominator * temp + 1).
	numerator := self limitedSmallValue: ( temp / numerator + 1).
	denominator := 1 / denominator.
	result := result * numerator * denominator.
	temp := (alpha1 + m) negated * (q1 + m) * x 
				/ ((q2 + m2) * (alpha1 + m2)).
	denominator := self limitedSmallValue: ( denominator * temp + 1).
	numerator := self limitedSmallValue: ( temp / numerator + 1).
	denominator := 1 / denominator.
	temp := numerator * denominator.
	result := result * temp.
	^(temp - 1) abs!

initializeIterations
	"Initialize the iterations (subclasses must write their own method and call this one last).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	numerator := 1.
	denominator := 1 / (self limitedSmallValue: 1 - (q1 * x / q2)).
	result := denominator! !

DhbIncompleteBetaFunctionFraction class
	instanceVariableNames: ''!



!DhbIncompleteBetaFunctionFraction class methodsFor: 'creation'!

shape: aNumber1 shape: aNumber2 
	"Create an instance of the receiver with given shape parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 shape: aNumber2! !

DhbProbabilityDensity subclass: #DhbExponentialDistribution
	instanceVariableNames: 'beta '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbExponentialDistribution methodsFor: 'initialization'!

initialize: aNumber
		"Private - Set the scale parameter of the receiver to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	aNumber > 0
		ifFalse: [ self error: 'Illegal distribution parameters'].
	beta := aNumber.
	^self! !

!DhbExponentialDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^beta!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^[1 - ( ( aNumber / beta negated) exp)]
			on: Error do: [ :signal | signal return: 0]!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^6!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: beta!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(1 - aNumber) ln negated * beta!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^DhbMitchellMooreGenerator new floatValue ln * beta negated!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^2!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^beta!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^[ ( aNumber / beta) negated exp / beta]
			on: Error do: [ :signal | signal return: 0]!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	| dp |
	dp := self value: aNumber.
	^Array with: dp
		   with: ( DhbVector with: ( aNumber / beta - 1) * dp / beta)! !

!DhbExponentialDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	beta := beta + ( aVector at: 1).! !

DhbExponentialDistribution class
	instanceVariableNames: ''!



!DhbExponentialDistribution class methodsFor: 'creation'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| mu |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	mu := aHistogram average.
	^mu > 0 ifTrue: [ self scale: aHistogram average]
			ifFalse:[ nil]!

new
		"Create a new instance of the receiver with scale parameter 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: 1!

scale: aNumber
		"Create a new instance of the receiver with given scale parameter.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber! !

!DhbExponentialDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Exponential distribution'! !

DhbProbabilityDensity subclass: #DhbAsymptoticChiSquareDistribution
	instanceVariableNames: 'degreeOfFreedom reducedDOF normalDistribution '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbAsymptoticChiSquareDistribution methodsFor: 'initialization'!

initialize: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	degreeOfFreedom := anInteger.
	reducedDOF := ( degreeOfFreedom * 2 - 1) sqrt.
	^self! !

!DhbAsymptoticChiSquareDistribution methodsFor: 'information'!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^degreeOfFreedom!

confidenceLevel: aNumber
		"Answer the probability in percent of finding a chi square value
		 distributed according to the receiver larger than aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	^( 1 - ( self distributionValue: aNumber)) *100!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	| x |
	^aNumber > 0
		ifTrue: [ x := (aNumber * 2) sqrt.
				  ( DhbErfApproximation new value: (x - reducedDOF))
				]
		ifFalse:[ 0]!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^12 / degreeOfFreedom!

parameters
		"Returns an Array containing the parameters of the distribution.
		 It is used to print out the distribution and for fitting.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: degreeOfFreedom!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbNormalDistribution random + reducedDOF) squared / 2!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^( 2 / degreeOfFreedom) sqrt * 2!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	| x |
	^aNumber > 0
		ifTrue: [ x := (aNumber * 2) sqrt.
				  ( DhbErfApproximation new normal: (x - reducedDOF)) / x
				]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^degreeOfFreedom * 2! !

!DhbAsymptoticChiSquareDistribution methodsFor: 'transformation'!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	normalDistribution changeParametersBy: aVector.! !

DhbAsymptoticChiSquareDistribution class
	instanceVariableNames: ''!



!DhbAsymptoticChiSquareDistribution class methodsFor: 'creation'!

degreeOfFreedom: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^super new initialize: anInteger!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^self error: 'Illegal creation message for this class'! !

!DhbAsymptoticChiSquareDistribution class methodsFor: 'information'!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^'Chi square distribution'! !

Object subclass: #DhbLanczosFormula
	instanceVariableNames: 'coefficients sqrt2Pi '
	classVariableNames: 'UniqueInstance '
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbLanczosFormula methodsFor: 'information'!

gamma: aNumber
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	^( self leadingFactor: aNumber) exp * ( self series: aNumber) * sqrt2Pi / aNumber!

leadingFactor: aNumber
		"Private - Answers the log of the leading factor in Lanczos' formula.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	| temp |
	temp := aNumber + 5.5.
	^( temp ln * ( aNumber + 0.5) - temp)!

logGamma: aNumber
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	^( self leadingFactor: aNumber) + ( ( self series: aNumber) * sqrt2Pi / aNumber) ln!

series: aNumber
		"Private - Answer the value of the series of Lanczos' formula.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	| term |
	term := aNumber.
	^coefficients inject: 1.000000000190015
						into: [ :sum :each | term := term + 1. each / term + sum]! !

!DhbLanczosFormula methodsFor: 'initialization'!

initialize
		"Private - Initialize the coefficients of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	sqrt2Pi := ( Float pi * 2) sqrt.
	coefficients := #( 76.18009172947146 -86.50532032941677 24.01409824083091 -1.231739572450155 0.1208650973866179e-2 -0.5395239384953e-5).
	^self! !

DhbLanczosFormula class
	instanceVariableNames: ''!



!DhbLanczosFormula class methodsFor: 'creation'!

new
		"Answer a unique instance. Create it if it does not exist.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	UniqueInstance isNil
		ifTrue: [ UniqueInstance := super new.
					 UniqueInstance initialize.
					].
	^UniqueInstance! !

DhbStatisticalMoments subclass: #DhbFixedStatisticalMoments
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbFixedStatisticalMoments methodsFor: 'transformation'!

accumulate: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| correction n n1 c2 c3 |
	n := moments at: 1.
	n1 := n + 1.
	correction := ((moments at: 2) - aNumber) / n1.
	c2 := correction squared.
	c3 := c2 * correction.
	moments
		at: 5
			put: ((moments at: 5) + ((moments at: 4) * correction * 4) 
					+ ((moments at: 3) * c2 * 6) + (c2 squared * (n squared * n + 1))) 
					* n / n1;
		at: 4
			put: ((moments at: 4) + ((moments at: 3) * correction * 3) 
					+ (c3 * (1 - n squared))) * n 
					/ n1;
		at: 3 put: ((moments at: 3) + (c2 * (1 + n))) * n / n1;
		at: 2 put: (moments at: 2) - correction;
		at: 1 put: n1! !

DhbFixedStatisticalMoments class
	instanceVariableNames: ''!



!DhbFixedStatisticalMoments class methodsFor: 'creation'!

new
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "
	^super new: 4!

new: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "
	^self error: 'Illegal creation message for this class'! !

Object subclass: #DhbMitchellMooreGenerator
	instanceVariableNames: 'randoms lowIndex highIndex '
	classVariableNames: 'UniqueInstance '
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbMitchellMooreGenerator methodsFor: 'information'!

floatValue
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "

	| x |
	x := (randoms at: lowIndex) + (randoms at: highIndex).
	x < 1.0 ifFalse: [x := x - 1.0].
	randoms at: highIndex put: x.
	highIndex := highIndex + 1.
	highIndex > randoms size ifTrue: [highIndex := 1].
	lowIndex := lowIndex + 1.
	lowIndex > randoms size ifTrue: [lowIndex := 1].
	^x!

integerValue: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "
	^( self floatValue * anInteger) truncated! !

!DhbMitchellMooreGenerator methodsFor: 'initialization'!

initialize: anArray lowIndex: anInteger
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "

	randoms := anArray.
	lowIndex := anInteger.
	highIndex := randoms size.
	^self! !

DhbMitchellMooreGenerator class
	instanceVariableNames: ''!



!DhbMitchellMooreGenerator class methodsFor: 'creation'!

constants: anArray lowIndex: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "
	^super new initialize: anArray lowIndex: anInteger!

default
	"Private- 
	 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "

	| congruentialGenerator |
	congruentialGenerator := DhbCongruentialRandomNumberGenerator new.
	^self generateSeeds: congruentialGenerator!

generateSeeds: congruentialGenerator
	"Private- "
	^self constants: ((1 to: 55) collect: [:n | congruentialGenerator floatValue])
		lowIndex: 24!

new
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "
	UniqueInstance isNil
		ifTrue: [ UniqueInstance := self default].
	^UniqueInstance!

reset: anInteger
	"Reset the unique instance used for the default series"
	UniqueInstance := self seed: anInteger.!

seed: anInteger
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/18/00 "

	| congruentialGenerator |
	congruentialGenerator := DhbCongruentialRandomNumberGenerator seed: anInteger.
	^self generateSeeds: congruentialGenerator! !

Array variableSubclass: #DhbVector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DHB Numerical'!



!DhbVector methodsFor: 'creation'!

normalized
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30-Dec-99 "
	^(1 / self norm) * self! !

!DhbVector methodsFor: 'information'!

asVector
		"Answer self since the receiver is a vector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self!

dimension
		"Answer the dimension of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self size!

norm
		"Answer the norm of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^(self * self) sqrt!

scalarProduct: aVector
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/5/99 "
	| product n |
	n := 0.
	product := self collect: [ :each | n := n + 1. (aVector at: n) * each].
	n := product size.
	[ n > 1]
		whileTrue:[ | i j|
					i := 1.
					j := n.
					[ i < j]
						whileTrue: [ product at: i put: ( product at: i) + ( product at: j).
									 j := j - 1.
									 i := i + 1.
								   ].
					n := i min: j.
				  ].
	^product at: 1! !

!DhbVector methodsFor: 'operation'!

* aNumberOrMatrixOrVector
		"Answers the product of the receiver with the argument.
		 The argument can be a number, matrix or vector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aNumberOrMatrixOrVector productWithVector: self!

+ aVector
		"Answers the sum of the receiver with aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| answer n |
	answer := self class new: self size.
	n := 0.
	self with: aVector do:
		[ :a :b | 
		  n := n + 1. 
		  answer at: n put: ( a + b).
		].
	^answer!

- aVector
		"Answers the difference of the receiver with aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| answer n |
	answer := self class new: self size.
	n := 0.
	self with: aVector do:
		[ :a :b | 
		  n := n + 1. 
		  answer at: n put: ( a - b).
		].
	^answer!

productFromDouble: aDouble 
	^self * aDouble!

productFromFixedPoint: aFixedPoint 
	^self * aFixedPoint!

productFromFloat: aFloat 
	^self * aFloat!

productFromFraction: aFraction 
	^self * aFraction!

productFromInteger: anInteger 
	^self * anInteger!

productWithMatrix: aMatrix
		"Answers the product of aMatrix with the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix rowsCollect: [ :each | each * self]!

productWithVector: aVector
		"Answers the scalar product of aVector with the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	^self inject: 0
			into: [ :sum :each | n := n + 1. (aVector at: n) * each + sum]!

tensorProduct: aVector
		"Answers the tensor product of the receiver with aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	self dimension = aVector dimension
		ifFalse:[ ^self error: 'Vector dimensions mismatch to build tensor product'].
	^DhbSymmetricMatrix rows: ( self collect: [ :a | aVector collect: [ :b | a * b]])! !

!DhbVector methodsFor: 'transformation'!

accumulate: aVectorOrAnArray
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	1 to: self size do: [ :n | self at: n put: ( ( self at: n) + ( aVectorOrAnArray at: n))].!

accumulateNegated: aVectorOrAnArray
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	1 to: self size do: [ :n | self at: n put: ( ( self at: n) - ( aVectorOrAnArray at: n))].!

negate
		"Inverse the sign of all components of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	1 to: self size do: [ :n | self at: n put: (self at: n) negated].!

scaleBy: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	1 to: self size do: [ :n | self at: n put: ( ( self at: n) * aNumber)].! !

DhbVector class
	instanceVariableNames: ''!



