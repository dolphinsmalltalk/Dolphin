"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbMatrix
	instanceVariableNames: 'rows lupDecomposition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbMatrix guid: (GUID fromString: '{E5500261-7D2B-11D6-B6CC-00022D5019C8}')!
DhbMatrix comment: ''!
!DhbMatrix categoriesForClass!DHB Numerical! !
!DhbMatrix methodsFor!

- aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix subtractWithRegularMatrix: self!

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

= aNumberOrMatrix 
	aNumberOrMatrix isNil ifTrue: [^false].
	aNumberOrMatrix isNumber ifTrue: [^(self numberOfRows = 1 and: [self numberOfColumns = 1])
			and: [(self rowAt: 1 columnAt: 1)
					= aNumberOrMatrix]].
	aNumberOrMatrix class = self class ifFalse: [^false].
	^self rows = aNumberOrMatrix rows!

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

asSymmetricMatrix
		"Convert the receiver to a symmetric matrix (no check is made).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^DhbSymmetricMatrix rows: rows!

columnAt: anInteger
		"Answers the anInteger-th column of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows collect: [ :each | each at: anInteger]!

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

determinant
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	^self lupDecomposition determinant!

hash
	^rows hash!

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
	rows := anArrayOrVector asVector collect: [ :each | each asVector].!

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

lupInverse
	^self class rows: self lupDecomposition inverseMatrixComponents!

negate
		"Inverse the sign of all components of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	rows do: [ :each |each negate].!

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
		].!

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

rowsCollect: aBlock
		"Perform the collect: operation on the rows of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows collect: aBlock!

rowsDo: aBlock
		"Perform the collect: operation on the rows of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^rows do: aBlock!

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
		with:( self class rows: ( ( (n1 + 1) to: n) asVector collect: [ :k | ( rows at: k) copyFrom: (m1 + 1) to: m]))!

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
							)!

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

transpose
		"Answer a new matrix, transpose of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self class rows: ( self columnsCollect: [ :each | each])!

transposeProductWithMatrix: aMatrix
		"Answers the product of the transpose of the receiver with aMatrix (in this order).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self class rows: ( self columnsCollect: [ :row | aMatrix columnsCollect: [ :col | row * col]])! !
!DhbMatrix categoriesFor: #-!operation!public! !
!DhbMatrix categoriesFor: #*!operation!public! !
!DhbMatrix categoriesFor: #+!operation!public! !
!DhbMatrix categoriesFor: #=!comparing!public! !
!DhbMatrix categoriesFor: #accumulate:!public!transformation! !
!DhbMatrix categoriesFor: #accumulateNegated:!public!transformation! !
!DhbMatrix categoriesFor: #addWithMatrix:class:!double dispatching!public! !
!DhbMatrix categoriesFor: #addWithRegularMatrix:!double dispatching!public! !
!DhbMatrix categoriesFor: #addWithSymmetricMatrix:!double dispatching!public! !
!DhbMatrix categoriesFor: #asSymmetricMatrix!public!transformation! !
!DhbMatrix categoriesFor: #columnAt:!information!public! !
!DhbMatrix categoriesFor: #columnsCollect:!iterators!public! !
!DhbMatrix categoriesFor: #columnsDo:!iterators!public! !
!DhbMatrix categoriesFor: #determinant!information!public! !
!DhbMatrix categoriesFor: #hash!comparing!public! !
!DhbMatrix categoriesFor: #initialize:!initialization!public! !
!DhbMatrix categoriesFor: #initializeRows:!initialization!public! !
!DhbMatrix categoriesFor: #inverse!operation!public! !
!DhbMatrix categoriesFor: #inversePureCRL!operation!public! !
!DhbMatrix categoriesFor: #isSquare!information!public! !
!DhbMatrix categoriesFor: #isSymmetric!information!public! !
!DhbMatrix categoriesFor: #largestPowerOf2SmallerThan:!information!public! !
!DhbMatrix categoriesFor: #lupDecomposition!information!public! !
!DhbMatrix categoriesFor: #lupInverse!operation!public! !
!DhbMatrix categoriesFor: #negate!public!transformation! !
!DhbMatrix categoriesFor: #numberOfColumns!information!public! !
!DhbMatrix categoriesFor: #numberOfRows!information!public! !
!DhbMatrix categoriesFor: #printOn:!display!public! !
!DhbMatrix categoriesFor: #productFromDouble:!double dispatching!public! !
!DhbMatrix categoriesFor: #productFromFixedPoint:!double dispatching!public! !
!DhbMatrix categoriesFor: #productFromFraction:!double dispatching!public! !
!DhbMatrix categoriesFor: #productFromInteger:!double dispatching!public! !
!DhbMatrix categoriesFor: #productWithMatrix:!double dispatching!public! !
!DhbMatrix categoriesFor: #productWithMatrixFinal:!double dispatching!public! !
!DhbMatrix categoriesFor: #productWithSymmetricMatrix:!double dispatching!public! !
!DhbMatrix categoriesFor: #productWithTransposeMatrix:!double dispatching!public! !
!DhbMatrix categoriesFor: #productWithVector:!double dispatching!public! !
!DhbMatrix categoriesFor: #rowAt:!information!public! !
!DhbMatrix categoriesFor: #rowAt:columnAt:!information!public! !
!DhbMatrix categoriesFor: #rowAt:columnAt:put:!information!public! !
!DhbMatrix categoriesFor: #rows!information!public! !
!DhbMatrix categoriesFor: #rowsCollect:!iterators!public! !
!DhbMatrix categoriesFor: #rowsDo:!iterators!public! !
!DhbMatrix categoriesFor: #scaleBy:!public!transformation! !
!DhbMatrix categoriesFor: #split!public!transformation! !
!DhbMatrix categoriesFor: #squared!operation!public! !
!DhbMatrix categoriesFor: #strassenProductWithMatrix:!operation!public! !
!DhbMatrix categoriesFor: #subtractWithMatrix:class:!double dispatching!public! !
!DhbMatrix categoriesFor: #subtractWithRegularMatrix:!double dispatching!public! !
!DhbMatrix categoriesFor: #subtractWithSymmetricMatrix:!double dispatching!public! !
!DhbMatrix categoriesFor: #transpose!information!public! !
!DhbMatrix categoriesFor: #transposeProductWithMatrix:!double dispatching!public! !

!DhbMatrix class methodsFor!

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

lupCRLCriticalDimension
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	^40!

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
!DhbMatrix class categoriesFor: #join:!creation!public! !
!DhbMatrix class categoriesFor: #lupCRLCriticalDimension!information!public! !
!DhbMatrix class categoriesFor: #new:!creation!public! !
!DhbMatrix class categoriesFor: #rows:!creation!public! !

