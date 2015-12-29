"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbUniformDistribution
	instanceVariableNames: 'lowLimit highLimit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbUniformDistribution guid: (GUID fromString: '{E5500284-7D2B-11D6-B6CC-00022D5019C8}')!
DhbUniformDistribution comment: ''!
!DhbUniformDistribution categoriesForClass!DHB Numerical! !
!DhbUniformDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( highLimit + lowLimit) / 2!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	lowLimit := lowLimit + ( aVector at: 1).
	highLimit := highLimit + ( aVector at: 2).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	aNumber < lowLimit
		ifTrue: [ ^0].
	^aNumber < highLimit
		ifTrue: [ (aNumber - lowLimit) / ( highLimit - lowLimit)]
		ifFalse:[ 1]!

initialize: aNumber1 to: aNumber2
		"Private - Defines the limits of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	aNumber1 < aNumber2
		ifFalse: [ self error: 'Illegal distribution parameters'].
	lowLimit := aNumber1.
	highLimit := aNumber2.
	^self!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^-12 / 10!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: lowLimit with: highLimit!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(highLimit - lowLimit) * aNumber + lowLimit!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( highLimit - lowLimit) / 3.46410161513775 "12 sqrt"!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( aNumber between: lowLimit and: highLimit)
		ifTrue: [ 1/( highLimit - lowLimit)]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( highLimit - lowLimit) squared / 12! !
!DhbUniformDistribution categoriesFor: #average!information!public! !
!DhbUniformDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbUniformDistribution categoriesFor: #distributionValue:!information!public! !
!DhbUniformDistribution categoriesFor: #initialize:to:!initialization!public! !
!DhbUniformDistribution categoriesFor: #kurtosis!information!public! !
!DhbUniformDistribution categoriesFor: #parameters!information!public! !
!DhbUniformDistribution categoriesFor: #privateInverseDistributionValue:!information!public! !
!DhbUniformDistribution categoriesFor: #skewness!information!public! !
!DhbUniformDistribution categoriesFor: #standardDeviation!information!public! !
!DhbUniformDistribution categoriesFor: #value:!information!public! !
!DhbUniformDistribution categoriesFor: #variance!information!public! !

!DhbUniformDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Uniform distribution'!

from: aNumber1 to: aNumber2
		"Create a new instance of the receiver with given limits.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 to: aNumber2!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 Default returns nil (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| b c|
	b := aHistogram standardDeviation * 1.73205080756888 "12 sqrt / 2".
	b = 0
		ifTrue: [ ^nil].
	c := aHistogram average.
	^self from: ( c - b) to: ( c + b).!

new
		"Create a new instance of the receiver with limits 0 and 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self from: 0 to: 1! !
!DhbUniformDistribution class categoriesFor: #distributionName!public! !
!DhbUniformDistribution class categoriesFor: #from:to:!public! !
!DhbUniformDistribution class categoriesFor: #fromHistogram:!public! !
!DhbUniformDistribution class categoriesFor: #new!public! !

