"Filed out from Dolphin Smalltalk X6"!

Array variableSubclass: #DhbVector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbVector guid: (GUID fromString: '{E55002B8-7D2B-11D6-B6CC-00022D5019C8}')!
DhbVector comment: ''!
!DhbVector categoriesForClass!DHB Numerical! !
!DhbVector methodsFor!

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

accumulate: aVectorOrAnArray
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	1 to: self size do: [ :n | self at: n put: ( ( self at: n) + ( aVectorOrAnArray at: n))].!

accumulateNegated: aVectorOrAnArray
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	1 to: self size do: [ :n | self at: n put: ( ( self at: n) - ( aVectorOrAnArray at: n))].!

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

multiplyByDouble: aDouble 
"DHB"
	^self * aDouble!

multiplyByFixedPoint: aFixedPoint 
	"DHB"
	^self * aFixedPoint!

multiplyByFloat: aFloat 
	"DHB"
	^self * aFloat!

multiplyByFraction: aFraction 
	"DHB"
	^self * aFraction!

multiplyByInteger: anInteger 
	"DHB"
	^self * anInteger!

negate
		"Inverse the sign of all components of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	1 to: self size do: [ :n | self at: n put: (self at: n) negated].!

norm
		"Answer the norm of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^(self * self) sqrt!

normalized
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30-Dec-99 "
	^(1 / self norm) * self!

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
	^product at: 1!

scaleBy: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	1 to: self size do: [ :n | self at: n put: ( ( self at: n) * aNumber)].!

tensorProduct: aVector
		"Answers the tensor product of the receiver with aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	self dimension = aVector dimension
		ifFalse:[ ^self error: 'Vector dimensions mismatch to build tensor product'].
	^DhbSymmetricMatrix rows: ( self collect: [ :a | aVector collect: [ :b | a * b]])! !
!DhbVector categoriesFor: #-!operation!public! !
!DhbVector categoriesFor: #*!operation!public! !
!DhbVector categoriesFor: #+!operation!public! !
!DhbVector categoriesFor: #accumulate:!public!transformation! !
!DhbVector categoriesFor: #accumulateNegated:!public!transformation! !
!DhbVector categoriesFor: #asVector!information!public! !
!DhbVector categoriesFor: #dimension!information!public! !
!DhbVector categoriesFor: #multiplyByDouble:!operation!public! !
!DhbVector categoriesFor: #multiplyByFixedPoint:!operation!public! !
!DhbVector categoriesFor: #multiplyByFloat:!operation!public! !
!DhbVector categoriesFor: #multiplyByFraction:!operation!public! !
!DhbVector categoriesFor: #multiplyByInteger:!operation!public! !
!DhbVector categoriesFor: #negate!public!transformation! !
!DhbVector categoriesFor: #norm!information!public! !
!DhbVector categoriesFor: #normalized!creation!public! !
!DhbVector categoriesFor: #productFromDouble:!operation!public! !
!DhbVector categoriesFor: #productFromFixedPoint:!operation!public! !
!DhbVector categoriesFor: #productFromFloat:!operation!public! !
!DhbVector categoriesFor: #productFromFraction:!operation!public! !
!DhbVector categoriesFor: #productFromInteger:!operation!public! !
!DhbVector categoriesFor: #productWithMatrix:!operation!public! !
!DhbVector categoriesFor: #productWithVector:!operation!public! !
!DhbVector categoriesFor: #scalarProduct:!information!public! !
!DhbVector categoriesFor: #scaleBy:!public!transformation! !
!DhbVector categoriesFor: #tensorProduct:!operation!public! !

