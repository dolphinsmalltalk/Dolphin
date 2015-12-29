"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbFisherTippettDistribution
	instanceVariableNames: 'alpha beta'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbFisherTippettDistribution guid: (GUID fromString: '{E5500277-7D2B-11D6-B6CC-00022D5019C8}')!
DhbFisherTippettDistribution comment: ''!
!DhbFisherTippettDistribution categoriesForClass!DHB Numerical! !
!DhbFisherTippettDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^0.577256649 * beta + alpha!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	alpha := alpha + ( aVector at: 1).
	beta := beta + ( aVector at: 2).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 14/4/99 "
	| arg |
	arg := ( aNumber - alpha) / beta.
	arg := arg < DhbFloatingPointMachine new largestExponentArgument negated
					ifTrue: [ ^0]
					ifFalse:[arg negated exp].
	^arg > DhbFloatingPointMachine new largestExponentArgument ifTrue: [ 1]
						ifFalse:[ arg negated exp]!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	aNumber2 > 0
		ifFalse: [ self error: 'Illegal distribution parameters'].
	alpha := aNumber1.
	beta := aNumber2.
	^self!

integralFrom: aNumber1 to: aNumber2
		"Private - Compute the integral of the receiver from aNumber1 to aNumber2.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 14/4/99 "
	^( DhbRombergIntegrator new: self from: aNumber1 to: aNumber2) evaluate!

integralUpTo: aNumber
		"Private - Compute the integral of the receiver from -infinity to aNumber.
		 aNumber must be below 0 (no checking!!).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 14/4/99 "
	^( DhbRombergIntegrator new:
			[ :x | x = 0 ifTrue: [ 0] ifFalse: [ ( self value: 1 / x) / x squared] ]
			from: 1 / aNumber to: 0) evaluate!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^2.4!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha with: beta!

random
		"Answer a random number distributed according to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/4/99 "
	| t |
	[ t := DhbMitchellMooreGenerator new floatValue ln negated.
	  t > 0] whileFalse: [].
	^t ln negated * beta + alpha!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^1.3!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Float pi * beta / ( 6 sqrt)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	| arg |
	arg := ( aNumber - alpha) / beta.
	arg := arg > DhbFloatingPointMachine new largestExponentArgument ifTrue: [ ^0]
						ifFalse:[arg negated exp + arg].
	^arg > DhbFloatingPointMachine new largestExponentArgument ifTrue: [ 0]
						ifFalse:[ arg negated exp / beta]!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| dp dy y|
	dp := self value: aNumber.
	y := ( aNumber - alpha) / beta.
	dy := ( y negated exp - 1).
	^Array with: dp
		   with: ( DhbVector with: dy * dp / beta negated
							 with: dp * ( y * dy + 1) / beta negated)! !
!DhbFisherTippettDistribution categoriesFor: #average!information!public! !
!DhbFisherTippettDistribution categoriesFor: #changeParametersBy:!information!public! !
!DhbFisherTippettDistribution categoriesFor: #distributionValue:!information!public! !
!DhbFisherTippettDistribution categoriesFor: #initialize:scale:!initialization!public! !
!DhbFisherTippettDistribution categoriesFor: #integralFrom:to:!information!public! !
!DhbFisherTippettDistribution categoriesFor: #integralUpTo:!information!public! !
!DhbFisherTippettDistribution categoriesFor: #kurtosis!information!public! !
!DhbFisherTippettDistribution categoriesFor: #parameters!information!public! !
!DhbFisherTippettDistribution categoriesFor: #random!information!public! !
!DhbFisherTippettDistribution categoriesFor: #skewness!information!public! !
!DhbFisherTippettDistribution categoriesFor: #standardDeviation!information!public! !
!DhbFisherTippettDistribution categoriesFor: #value:!information!public! !
!DhbFisherTippettDistribution categoriesFor: #valueAndGradient:!information!public! !

!DhbFisherTippettDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Fisher-Tippett distribution'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	| beta |
	beta := aHistogram standardDeviation.
	beta = 0 ifTrue: [^nil].
	beta := beta * (6 sqrt / Float pi).
	^self shape: aHistogram average - (0.5772156649 * beta) scale: beta!

new
	"Create a standard version of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^self shape: 0 scale: 1!

shape: aNumber1 scale: aNumber2 
	"Create an instance of the receiver with given shape and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 scale: aNumber2! !
!DhbFisherTippettDistribution class categoriesFor: #distributionName!information!public! !
!DhbFisherTippettDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbFisherTippettDistribution class categoriesFor: #new!creation!public! !
!DhbFisherTippettDistribution class categoriesFor: #shape:scale:!creation!public! !

