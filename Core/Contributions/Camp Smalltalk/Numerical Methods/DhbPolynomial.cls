"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbPolynomial
	instanceVariableNames: 'coefficients'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbPolynomial guid: (GUID fromString: '{E5500263-7D2B-11D6-B6CC-00022D5019C8}')!
DhbPolynomial comment: ''!
!DhbPolynomial categoriesForClass!DHB Numerical! !
!DhbPolynomial methodsFor!

- aNumberOrPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^aNumberOrPolynomial subtractToPolynomial: self!

* aNumberOrPolynomial
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^aNumberOrPolynomial timesPolynomial: self!

/ aNumberOrPolynomial
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^aNumberOrPolynomial dividingPolynomial: self!

+ aNumberOrPolynomial
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^aNumberOrPolynomial addPolynomial: self!

= aNumberOrPolynomial 
	aNumberOrPolynomial isNil ifTrue: [^false].
	aNumberOrPolynomial isNumber ifTrue: [^coefficients size = 1 and: [coefficients first = aNumberOrPolynomial]].
	aNumberOrPolynomial class = self class ifFalse: [^false].
	^self coefficients = aNumberOrPolynomial coefficients!

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

addToInteger: anInteger 
	"DHB"
	^self + anInteger!

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

degree
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/4/99 "
	^coefficients size - 1!

derivative
		"Answer a new polynomial, derivative of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	| n |
	n := coefficients size.
	^self class coefficients: ( ( coefficients collect: [ :each | n := n - 1. each * n]) reverse copyFrom: 2 to: coefficients size)!

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

hash
	^coefficients hash!

initialize: anArray
		"Private - Initialize the coefficients of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	coefficients := anArray.
	^self!

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
	^self class coefficients: ( ( coefficients collect: [ :each | n := n - 1. each / n]) copyWith: aValue) reverse!

multiplyByInteger: anInteger 
	"DHB"
	^self * anInteger!

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
			n := n + 1]!

productFromDouble: aDouble 
	^self * aDouble!

productFromFixedPoint: aFixedPoint 
	^self * aFixedPoint!

productFromFraction: aFraction 
	^self * aFraction!

productFromInteger: anInteger 
	^self * anInteger!

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

subtractFrom: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	| newCoefficients |
	newCoefficients := ( coefficients collect: [ :c | c negated]) reverse.
	newCoefficients at: 1 put: newCoefficients first + aNumber.
	^self class coefficients: newCoefficients!

subtractFromDouble: aDouble 
	"DHB"
	^self subtractFrom: aDouble!

subtractFromFixedPoint: aFixedPoint 
	"DHB"
	^self subtractFrom: aFixedPoint!

subtractFromFraction: aFraction 
	"DHB"
	^self subtractFrom: aFraction!

subtractFromInteger: anInteger 
	"DHB"
	^self subtractFrom: anInteger!

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
	^self class coefficients: productCoefficients!

value: aNumber
		"Answer the value of the polynomial for the specified variable value.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	^coefficients inject: 0 into: [ :sum :each | sum * aNumber + each]! !
!DhbPolynomial categoriesFor: #-!operation!public! !
!DhbPolynomial categoriesFor: #*!operation!public! !
!DhbPolynomial categoriesFor: #/!operation!public! !
!DhbPolynomial categoriesFor: #+!operation!public! !
!DhbPolynomial categoriesFor: #=!comparing!public! !
!DhbPolynomial categoriesFor: #addNumber:!double dispatching!public! !
!DhbPolynomial categoriesFor: #addPolynomial:!double dispatching!public! !
!DhbPolynomial categoriesFor: #addToInteger:!double dispatching!public! !
!DhbPolynomial categoriesFor: #at:!information!public! !
!DhbPolynomial categoriesFor: #coefficients!information!public! !
!DhbPolynomial categoriesFor: #deflatedAt:!creation!public! !
!DhbPolynomial categoriesFor: #degree!information!public! !
!DhbPolynomial categoriesFor: #derivative!creation!public! !
!DhbPolynomial categoriesFor: #differenceFromDouble:!double dispatching!public! !
!DhbPolynomial categoriesFor: #differenceFromFixedPoint:!double dispatching!public! !
!DhbPolynomial categoriesFor: #differenceFromFraction:!double dispatching!public! !
!DhbPolynomial categoriesFor: #differenceFromInteger:!double dispatching!public! !
!DhbPolynomial categoriesFor: #dividingPolynomial:!double dispatching!public! !
!DhbPolynomial categoriesFor: #dividingPolynomialWithRemainder:!double dispatching!public! !
!DhbPolynomial categoriesFor: #hash!comparing!public! !
!DhbPolynomial categoriesFor: #initialize:!initialization!public! !
!DhbPolynomial categoriesFor: #integral!creation!public! !
!DhbPolynomial categoriesFor: #integral:!creation!public! !
!DhbPolynomial categoriesFor: #multiplyByInteger:!double dispatching!public! !
!DhbPolynomial categoriesFor: #printOn:!display!public! !
!DhbPolynomial categoriesFor: #productFromDouble:!double dispatching!public! !
!DhbPolynomial categoriesFor: #productFromFixedPoint:!double dispatching!public! !
!DhbPolynomial categoriesFor: #productFromFraction:!double dispatching!public! !
!DhbPolynomial categoriesFor: #productFromInteger:!double dispatching!public! !
!DhbPolynomial categoriesFor: #roots!information!public! !
!DhbPolynomial categoriesFor: #roots:!information!public! !
!DhbPolynomial categoriesFor: #subtractFrom:!double dispatching!public! !
!DhbPolynomial categoriesFor: #subtractFromDouble:!double dispatching!public! !
!DhbPolynomial categoriesFor: #subtractFromFixedPoint:!double dispatching!public! !
!DhbPolynomial categoriesFor: #subtractFromFraction:!double dispatching!public! !
!DhbPolynomial categoriesFor: #subtractFromInteger:!double dispatching!public! !
!DhbPolynomial categoriesFor: #subtractToPolynomial:!double dispatching!public! !
!DhbPolynomial categoriesFor: #sumFromDouble:!double dispatching!public! !
!DhbPolynomial categoriesFor: #sumFromFixedPoint:!double dispatching!public! !
!DhbPolynomial categoriesFor: #sumFromFraction:!double dispatching!public! !
!DhbPolynomial categoriesFor: #sumFromInteger:!double dispatching!public! !
!DhbPolynomial categoriesFor: #timesNumber:!double dispatching!public! !
!DhbPolynomial categoriesFor: #timesPolynomial:!double dispatching!public! !
!DhbPolynomial categoriesFor: #value:!information!public! !

!DhbPolynomial class methodsFor!

coefficients: anArray
		" Creates a new instance with given coefficients
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	^self new initialize: anArray reverse! !
!DhbPolynomial class categoriesFor: #coefficients:!creation!public! !

