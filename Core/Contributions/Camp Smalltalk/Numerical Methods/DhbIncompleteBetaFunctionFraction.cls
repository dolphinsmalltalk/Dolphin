"Filed out from Dolphin Smalltalk XP"!

DhbIterativeProcess subclass: #DhbIncompleteBetaFunctionFraction
	instanceVariableNames: 'x q1 q2 q3 numerator denominator alpha1 alpha2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbIncompleteBetaFunctionFraction guid: (GUID fromString: '{E55002B2-7D2B-11D6-B6CC-00022D5019C8}')!
DhbIncompleteBetaFunctionFraction comment: ''!
!DhbIncompleteBetaFunctionFraction categoriesForClass!DHB Numerical! !
!DhbIncompleteBetaFunctionFraction methodsFor!

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

initializeIterations
	"Initialize the iterations (subclasses must write their own method and call this one last).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	numerator := 1.
	denominator := 1 / (self limitedSmallValue: 1 - (q1 * x / q2)).
	result := denominator!

setArgument: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	x := aNumber.! !
!DhbIncompleteBetaFunctionFraction categoriesFor: #evaluateIteration!operation!public! !
!DhbIncompleteBetaFunctionFraction categoriesFor: #initialize:shape:!initialization!public! !
!DhbIncompleteBetaFunctionFraction categoriesFor: #initializeIterations!operation!public! !
!DhbIncompleteBetaFunctionFraction categoriesFor: #setArgument:!initialization!public! !

!DhbIncompleteBetaFunctionFraction class methodsFor!

shape: aNumber1 shape: aNumber2 
	"Create an instance of the receiver with given shape parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 shape: aNumber2! !
!DhbIncompleteBetaFunctionFraction class categoriesFor: #shape:shape:!creation!public! !

