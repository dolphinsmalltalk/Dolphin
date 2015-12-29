"Filed out from Dolphin Smalltalk XP"!

DhbMatrix subclass: #DhbSymmetricMatrix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbSymmetricMatrix guid: (GUID fromString: '{E550026E-7D2B-11D6-B6CC-00022D5019C8}')!
DhbSymmetricMatrix comment: ''!
!DhbSymmetricMatrix categoriesForClass!DHB Numerical! !
!DhbSymmetricMatrix methodsFor!

- aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix subtractWithSymmetricMatrix: self!

+ aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix addWithSymmetricMatrix: self!

addWithSymmetricMatrix: aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix addWithMatrix: self class: self class!

clear
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/11/00 "
	rows do: [ :each | each atAllPut: 0].!

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

initializeIdentity: anInteger
		"Build components for an identity matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	rows := ( 1 to: anInteger) asVector collect: [ :n | (DhbVector new: anInteger) atAllPut: 0; at: n put: 1; yourself].!

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

isSquare
		"Answers true because a symmetric matrix is square.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^true!

isSymmetric
		"Answers true because the receiver is a symmetric matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^true!

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
						copyFrom: 1 to: n]))!

subtractWithSymmetricMatrix: aMatrix
		"Answers the sum of the receiver with aMatrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^aMatrix subtractWithMatrix: self class: self class! !
!DhbSymmetricMatrix categoriesFor: #-!operation!public! !
!DhbSymmetricMatrix categoriesFor: #+!operation!public! !
!DhbSymmetricMatrix categoriesFor: #addWithSymmetricMatrix:!operation!public! !
!DhbSymmetricMatrix categoriesFor: #clear!initialization!public! !
!DhbSymmetricMatrix categoriesFor: #crlInverse!operation!public! !
!DhbSymmetricMatrix categoriesFor: #initializeIdentity:!initialization!public! !
!DhbSymmetricMatrix categoriesFor: #inverse!operation!public! !
!DhbSymmetricMatrix categoriesFor: #inverse1By1!operation!public! !
!DhbSymmetricMatrix categoriesFor: #inverse2By2!operation!public! !
!DhbSymmetricMatrix categoriesFor: #inversePureCRL!operation!public! !
!DhbSymmetricMatrix categoriesFor: #inversePureLUP!operation!public! !
!DhbSymmetricMatrix categoriesFor: #isSquare!information!public! !
!DhbSymmetricMatrix categoriesFor: #isSymmetric!information!public! !
!DhbSymmetricMatrix categoriesFor: #productWithMatrix:!operation!public! !
!DhbSymmetricMatrix categoriesFor: #productWithSymmetricMatrix:!operation!public! !
!DhbSymmetricMatrix categoriesFor: #split!public!transformation! !
!DhbSymmetricMatrix categoriesFor: #subtractWithSymmetricMatrix:!operation!public! !

!DhbSymmetricMatrix class methodsFor!

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
	^self rows: rows!

lupCRLCriticalDimension
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	^36! !
!DhbSymmetricMatrix class categoriesFor: #identity:!creation!public! !
!DhbSymmetricMatrix class categoriesFor: #join:!creation!public! !
!DhbSymmetricMatrix class categoriesFor: #lupCRLCriticalDimension!information!public! !

