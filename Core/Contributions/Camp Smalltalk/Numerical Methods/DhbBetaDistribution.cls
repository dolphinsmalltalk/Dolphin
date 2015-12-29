"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbBetaDistribution
	instanceVariableNames: 'alpha1 alpha2 gamma1 gamma2 logNorm incompleteBetaFunction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbBetaDistribution guid: (GUID fromString: '{E5500298-7D2B-11D6-B6CC-00022D5019C8}')!
DhbBetaDistribution comment: ''!
!DhbBetaDistribution categoriesForClass!DHB Numerical! !
!DhbBetaDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^alpha1 / ( alpha1 + alpha2)!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	alpha1 := alpha1 + ( aVector at: 1).
	alpha2 := alpha2 + ( aVector at: 2).
	self computeNorm.
	gamma1 := nil.
	gamma2 := nil.
	incompleteBetaFunction := nil.!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	logNorm := (alpha1 + alpha2) logGamma - alpha1 logGamma - alpha2 logGamma.!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	incompleteBetaFunction isNil
		ifTrue: [ incompleteBetaFunction := DhbIncompleteBetaFunction shape: alpha1 shape: alpha2].
	^incompleteBetaFunction value: aNumber!

firstGammaDistribution
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	gamma1 isNil
		ifTrue: [ gamma1 := DhbGammaDistribution shape: alpha1 scale: 1].
	 ^gamma1!

initialize: aNumber1 shape: aNumber2 
	"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	(aNumber1 > 0 and: [aNumber2 > 0]) 
		ifFalse: [self error: 'Illegal distribution parameters'].
	alpha1 := aNumber1.
	alpha2 := aNumber2.
	self computeNorm.
	^self!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^3 * ( alpha1 + alpha2 + 1) * ( (alpha1 + alpha2) squared * 2 + ( ( alpha1 + alpha2 - 6) * alpha1 * alpha2)
			/ ( ( alpha1 + alpha2 + 2) * ( alpha1 + alpha2 + 3) * alpha1 * alpha2)) - 3!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha1 with: alpha2!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| r |
	r := self firstGammaDistribution random.
	^r / ( self secondGammaDistribution random + r)!

secondGammaDistribution
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	gamma2 isNil
		ifTrue: [ gamma2 := DhbGammaDistribution shape: alpha2 scale: 1].
	 ^gamma2!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^( alpha1 + alpha2 + 1) sqrt * 2 * ( alpha2 - alpha1) / ( ( alpha1 * alpha2) sqrt * ( alpha1 + alpha2 + 2))!

value: aNumber 
	"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^(aNumber > 0 and: [ aNumber < 1]) 
		ifTrue: 
			[( ( aNumber ln * (alpha1 - 1) ) + ( ( 1 - aNumber) ln * ( alpha2 - 1)) + logNorm) exp]
		ifFalse: [0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^alpha1 * alpha2 / ( ( alpha1 + alpha2) squared * ( alpha1 + alpha2 + 1))! !
!DhbBetaDistribution categoriesFor: #average!information!public! !
!DhbBetaDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbBetaDistribution categoriesFor: #computeNorm!initialization!public! !
!DhbBetaDistribution categoriesFor: #distributionValue:!information!public! !
!DhbBetaDistribution categoriesFor: #firstGammaDistribution!information!public! !
!DhbBetaDistribution categoriesFor: #initialize:shape:!initialization!public! !
!DhbBetaDistribution categoriesFor: #kurtosis!information!public! !
!DhbBetaDistribution categoriesFor: #parameters!information!public! !
!DhbBetaDistribution categoriesFor: #random!information!public! !
!DhbBetaDistribution categoriesFor: #secondGammaDistribution!information!public! !
!DhbBetaDistribution categoriesFor: #skewness!information!public! !
!DhbBetaDistribution categoriesFor: #value:!information!public! !
!DhbBetaDistribution categoriesFor: #variance!information!public! !

!DhbBetaDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Beta distribution'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the 
	given histogram using best guesses. This method can be used to 
	find the initial values for a fit. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 12/3/99"

	| average variance a b |
	(aHistogram minimum < 0 or: [aHistogram maximum > 1])
		ifTrue: [^nil].
	average := aHistogram average.
	variance := aHistogram variance.
	a := 1 - average / variance - 1 * average.
	a > 0 ifFalse: [^nil].
	b := 1 / average - 1 * a.
	b > 0 ifFalse: [^nil].
	^self shape: a shape: b!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

shape: aNumber1 shape: aNumber2 
	"Create an instance of the receiver with given shape parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 shape: aNumber2! !
!DhbBetaDistribution class categoriesFor: #distributionName!information!public! !
!DhbBetaDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbBetaDistribution class categoriesFor: #new!creation!public! !
!DhbBetaDistribution class categoriesFor: #shape:shape:!creation!public! !

