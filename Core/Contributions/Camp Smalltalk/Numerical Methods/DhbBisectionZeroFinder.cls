"Filed out from Dolphin Smalltalk XP"!

DhbFunctionalIterator subclass: #DhbBisectionZeroFinder
	instanceVariableNames: 'positiveX negativeX'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbBisectionZeroFinder guid: (GUID fromString: '{E550028C-7D2B-11D6-B6CC-00022D5019C8}')!
DhbBisectionZeroFinder comment: ''!
!DhbBisectionZeroFinder categoriesForClass!DHB Numerical! !
!DhbBisectionZeroFinder methodsFor!

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
					  ].!

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
!DhbBisectionZeroFinder categoriesFor: #computeInitialValues!operation!public! !
!DhbBisectionZeroFinder categoriesFor: #evaluateIteration!operation!public! !
!DhbBisectionZeroFinder categoriesFor: #findNegativeXFrom:range:!operation!public! !
!DhbBisectionZeroFinder categoriesFor: #findPositiveXFrom:range:!operation!public! !
!DhbBisectionZeroFinder categoriesFor: #setNegativeX:!initialization!public! !
!DhbBisectionZeroFinder categoriesFor: #setPositiveX:!initialization!public! !

