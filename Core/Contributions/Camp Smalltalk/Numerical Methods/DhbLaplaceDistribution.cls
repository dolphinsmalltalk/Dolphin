"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbLaplaceDistribution
	instanceVariableNames: 'mu beta'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLaplaceDistribution guid: (GUID fromString: '{E5500275-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLaplaceDistribution comment: ''!
!DhbLaplaceDistribution categoriesForClass!DHB Numerical! !
!DhbLaplaceDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^mu!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	mu := mu + ( aVector at: 1).
	beta := beta + ( aVector at: 2).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > mu
		ifTrue: [ 1 - ( ( ( aNumber - mu) / beta) negated exp / 2)]
		ifFalse:[ ( ( ( aNumber - mu) / beta) exp / 2)]!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	mu := aNumber1.
	beta := aNumber2.
	^self!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^3!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: mu with: beta!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| r |
	r := DhbMitchellMooreGenerator new floatValue ln * beta negated.
	^DhbMitchellMooreGenerator new floatValue > 0.5
		ifTrue: [ mu + r]
		ifFalse:[ mu - r]!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^beta * ( 2 sqrt)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^( ( aNumber - mu) / beta) abs negated exp / ( 2 * beta)!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| dp |
	dp := self value: aNumber.
	^Array	with: dp
			with: ( DhbVector with: ( aNumber - mu) sign * dp / beta
							  with: ( ( ( aNumber - mu) abs / beta - 1) * dp / beta))! !
!DhbLaplaceDistribution categoriesFor: #average!information!public! !
!DhbLaplaceDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbLaplaceDistribution categoriesFor: #distributionValue:!initialization!public! !
!DhbLaplaceDistribution categoriesFor: #initialize:scale:!initialization!public! !
!DhbLaplaceDistribution categoriesFor: #kurtosis!information!public! !
!DhbLaplaceDistribution categoriesFor: #parameters!information!public! !
!DhbLaplaceDistribution categoriesFor: #random!information!public! !
!DhbLaplaceDistribution categoriesFor: #skewness!information!public! !
!DhbLaplaceDistribution categoriesFor: #standardDeviation!information!public! !
!DhbLaplaceDistribution categoriesFor: #value:!information!public! !
!DhbLaplaceDistribution categoriesFor: #valueAndGradient:!information!public! !

!DhbLaplaceDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Laplace distribution'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	^self shape: aHistogram average scale: (aHistogram variance / 2) sqrt!

new
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "

	^self shape: 0 scale: 1!

shape: aNumber1 scale: aNumber2 
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "

	^super new initialize: aNumber1 scale: aNumber2! !
!DhbLaplaceDistribution class categoriesFor: #distributionName!information!public! !
!DhbLaplaceDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbLaplaceDistribution class categoriesFor: #new!creation!public! !
!DhbLaplaceDistribution class categoriesFor: #shape:scale:!creation!public! !

