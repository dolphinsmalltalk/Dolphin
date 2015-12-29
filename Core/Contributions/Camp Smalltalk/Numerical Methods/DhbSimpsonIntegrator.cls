"Filed out from Dolphin Smalltalk XP"!

DhbTrapezeIntegrator subclass: #DhbSimpsonIntegrator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbSimpsonIntegrator guid: (GUID fromString: '{E5500297-7D2B-11D6-B6CC-00022D5019C8}')!
DhbSimpsonIntegrator comment: ''!
!DhbSimpsonIntegrator categoriesForClass!DHB Numerical! !
!DhbSimpsonIntegrator methodsFor!

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
!DhbSimpsonIntegrator categoriesFor: #evaluateIteration!operation!public! !

