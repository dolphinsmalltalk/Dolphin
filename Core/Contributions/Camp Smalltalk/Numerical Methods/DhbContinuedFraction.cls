"Filed out from Dolphin Smalltalk XP"!

DhbInfiniteSeries subclass: #DhbContinuedFraction
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbContinuedFraction guid: (GUID fromString: '{E5500293-7D2B-11D6-B6CC-00022D5019C8}')!
DhbContinuedFraction comment: ''!
!DhbContinuedFraction categoriesForClass!DHB Numerical! !
!DhbContinuedFraction methodsFor!

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
!DhbContinuedFraction categoriesFor: #evaluateIteration!operation!public! !
!DhbContinuedFraction categoriesFor: #initializeIterations!operation!public! !

