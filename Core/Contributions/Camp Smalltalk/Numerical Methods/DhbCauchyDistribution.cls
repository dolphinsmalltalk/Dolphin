"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbCauchyDistribution
	instanceVariableNames: 'mu beta'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbCauchyDistribution guid: (GUID fromString: '{E5500281-7D2B-11D6-B6CC-00022D5019C8}')!
DhbCauchyDistribution comment: ''!
!DhbCauchyDistribution categoriesForClass!DHB Numerical! !
!DhbCauchyDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^mu!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	mu := mu + ( aVector at: 1).
	beta := beta + ( aVector at: 2).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 Assumes that the value of the receiver is 0 for x < 0.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(( aNumber - mu) / beta) arcTan / Float pi + (1 / 2)!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	mu := aNumber1.
	beta := aNumber2.
	^self!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: mu with: beta!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^( ( aNumber - (1 / 2)) * Float pi) tan * beta + mu!

standardDeviation
		"The standard deviation of the receiver is not defined.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^nil!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^beta / ( Float pi * ( beta squared + ( aNumber - mu) squared))!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| dp denominator |
	dp := self value: aNumber.
	denominator := 1 / ( ( aNumber - mu) squared + beta squared).
	^Array with: dp
		   with: ( DhbVector with: 2 * dp * ( aNumber - mu) * denominator
							 with: dp * ( 1 / beta - ( 2 * beta * denominator)))!

variance
		"The variance of the receiver is not defined.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^nil! !
!DhbCauchyDistribution categoriesFor: #average!information!public! !
!DhbCauchyDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbCauchyDistribution categoriesFor: #distributionValue:!information!public! !
!DhbCauchyDistribution categoriesFor: #initialize:scale:!initialization!public! !
!DhbCauchyDistribution categoriesFor: #parameters!information!public! !
!DhbCauchyDistribution categoriesFor: #privateInverseDistributionValue:!information!public! !
!DhbCauchyDistribution categoriesFor: #standardDeviation!information!public! !
!DhbCauchyDistribution categoriesFor: #value:!information!public! !
!DhbCauchyDistribution categoriesFor: #valueAndGradient:!information!public! !
!DhbCauchyDistribution categoriesFor: #variance!information!public! !

!DhbCauchyDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Cauchy distribution'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	^self shape: aHistogram average
		scale: 4 * aHistogram variance 
				/ (Float pi * (aHistogram maximum squared + aHistogram minimum squared)) 
						sqrt!

new
	"Create an instance of the receiver with center 0 and scale 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^self shape: 0 scale: 1!

shape: aNumber1 scale: aNumber2 
	"Create an instance of the receiver with given center and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 scale: aNumber2! !
!DhbCauchyDistribution class categoriesFor: #distributionName!information!public! !
!DhbCauchyDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbCauchyDistribution class categoriesFor: #new!creation!public! !
!DhbCauchyDistribution class categoriesFor: #shape:scale:!creation!public! !

