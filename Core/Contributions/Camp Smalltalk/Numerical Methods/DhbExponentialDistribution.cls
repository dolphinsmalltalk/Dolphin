"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbExponentialDistribution
	instanceVariableNames: 'beta'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbExponentialDistribution guid: (GUID fromString: '{E55002B3-7D2B-11D6-B6CC-00022D5019C8}')!
DhbExponentialDistribution comment: ''!
!DhbExponentialDistribution categoriesForClass!DHB Numerical! !
!DhbExponentialDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^beta!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	beta := beta + ( aVector at: 1).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^[1 - ( ( aNumber / beta negated) exp)]
			on: Error do: [ :signal | signal return: 0]!

initialize: aNumber
		"Private - Set the scale parameter of the receiver to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	aNumber > 0
		ifFalse: [ self error: 'Illegal distribution parameters'].
	beta := aNumber.
	^self!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^6!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: beta!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(1 - aNumber) ln negated * beta!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^DhbMitchellMooreGenerator new floatValue ln * beta negated!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^2!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^beta!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^[ ( aNumber / beta) negated exp / beta]
			on: Error do: [ :signal | signal return: 0]!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	| dp |
	dp := self value: aNumber.
	^Array with: dp
		   with: ( DhbVector with: ( aNumber / beta - 1) * dp / beta)! !
!DhbExponentialDistribution categoriesFor: #average!information!public! !
!DhbExponentialDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbExponentialDistribution categoriesFor: #distributionValue:!information!public! !
!DhbExponentialDistribution categoriesFor: #initialize:!initialization!public! !
!DhbExponentialDistribution categoriesFor: #kurtosis!information!public! !
!DhbExponentialDistribution categoriesFor: #parameters!information!public! !
!DhbExponentialDistribution categoriesFor: #privateInverseDistributionValue:!information!public! !
!DhbExponentialDistribution categoriesFor: #random!information!public! !
!DhbExponentialDistribution categoriesFor: #skewness!information!public! !
!DhbExponentialDistribution categoriesFor: #standardDeviation!information!public! !
!DhbExponentialDistribution categoriesFor: #value:!information!public! !
!DhbExponentialDistribution categoriesFor: #valueAndGradient:!information!public! !

!DhbExponentialDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Exponential distribution'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| mu |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	mu := aHistogram average.
	^mu > 0 ifTrue: [ self scale: aHistogram average]
			ifFalse:[ nil]!

new
		"Create a new instance of the receiver with scale parameter 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: 1!

scale: aNumber
		"Create a new instance of the receiver with given scale parameter.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber! !
!DhbExponentialDistribution class categoriesFor: #distributionName!information!public! !
!DhbExponentialDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbExponentialDistribution class categoriesFor: #new!creation!public! !
!DhbExponentialDistribution class categoriesFor: #scale:!creation!public! !

