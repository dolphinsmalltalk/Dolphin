"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbIncompleteBetaFunction
	instanceVariableNames: 'alpha1 alpha2 fraction inverseFraction logNorm'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbIncompleteBetaFunction guid: (GUID fromString: '{E5500280-7D2B-11D6-B6CC-00022D5019C8}')!
DhbIncompleteBetaFunction comment: ''!
!DhbIncompleteBetaFunction categoriesForClass!DHB Numerical! !
!DhbIncompleteBetaFunction methodsFor!

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

initialize: aNumber1 shape: aNumber2 
	"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	alpha1 := aNumber1.
	alpha2 := aNumber2.
	logNorm := ( alpha1 + alpha2) logGamma - alpha1 logGamma - alpha2 logGamma.
	^self!

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
!DhbIncompleteBetaFunction categoriesFor: #evaluateFraction:!information!public! !
!DhbIncompleteBetaFunction categoriesFor: #evaluateInverseFraction:!information!public! !
!DhbIncompleteBetaFunction categoriesFor: #initialize:shape:!initialization!public! !
!DhbIncompleteBetaFunction categoriesFor: #value:!information!public! !

!DhbIncompleteBetaFunction class methodsFor!

shape: aNumber1 shape: aNumber2 
	"Create an instance of the receiver with given shape parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 shape: aNumber2! !
!DhbIncompleteBetaFunction class categoriesFor: #shape:shape:!creation!public! !

