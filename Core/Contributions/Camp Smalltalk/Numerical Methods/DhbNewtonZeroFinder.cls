"Filed out from Dolphin Smalltalk XP"!

DhbFunctionalIterator subclass: #DhbNewtonZeroFinder
	instanceVariableNames: 'derivativeBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbNewtonZeroFinder guid: (GUID fromString: '{E55002AA-7D2B-11D6-B6CC-00022D5019C8}')!
DhbNewtonZeroFinder comment: ''!
!DhbNewtonZeroFinder categoriesForClass!DHB Numerical! !
!DhbNewtonZeroFinder methodsFor!

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

defaultDerivativeBlock
		"Private - Answers a block computing the function's derivative by approximation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^[ :x | 5000 * ( ( functionBlock value: (x + 0.0001)) - ( functionBlock value: (x - 0.0001)))]!

evaluateIteration
		"Compute one step of Newton's zero finding method. Answers the estimated precision.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	| delta |
	delta := ( functionBlock value: result) / ( derivativeBlock value: result).
	result := result - delta.
	^self relativePrecision: delta abs!

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
!DhbNewtonZeroFinder categoriesFor: #computeInitialValues!operation!public! !
!DhbNewtonZeroFinder categoriesFor: #defaultDerivativeBlock!information!public! !
!DhbNewtonZeroFinder categoriesFor: #evaluateIteration!operation!public! !
!DhbNewtonZeroFinder categoriesFor: #initialValue:!initialization!public! !
!DhbNewtonZeroFinder categoriesFor: #setDerivative:!initialization!public! !
!DhbNewtonZeroFinder categoriesFor: #setFunction:!initialization!public! !

!DhbNewtonZeroFinder class methodsFor!

function: aBlock1 derivative: aBlock2
		"Convenience method to create a instance with given function block.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^(self new) setFunction: aBlock1; setDerivative: aBlock2; yourself! !
!DhbNewtonZeroFinder class categoriesFor: #function:derivative:!creation!public! !

