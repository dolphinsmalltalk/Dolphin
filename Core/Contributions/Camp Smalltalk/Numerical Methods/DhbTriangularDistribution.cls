"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbTriangularDistribution
	instanceVariableNames: 'lowLimit highLimit peak'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbTriangularDistribution guid: (GUID fromString: '{E5500279-7D2B-11D6-B6CC-00022D5019C8}')!
DhbTriangularDistribution comment: ''!
!DhbTriangularDistribution categoriesForClass!DHB Numerical! !
!DhbTriangularDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(lowLimit + peak + highLimit) / 3!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	lowLimit := lowLimit + ( aVector at: 1).
	highLimit := highLimit + ( aVector at: 2).
	peak := peak + ( aVector at: 3).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| norm |
	^( aNumber between: lowLimit and: highLimit)
		ifTrue: [ aNumber < peak
						ifTrue: [ norm := ( highLimit - lowLimit) * ( peak - lowLimit).
									 ( aNumber - lowLimit) squared / norm
									]
						ifFalse:[ aNumber > peak
										ifTrue: [ norm := ( highLimit - lowLimit) * ( highLimit - peak).
									  				 1 - ( ( highLimit - aNumber) squared / norm)
													]
										ifFalse:[ ( peak - lowLimit) / ( highLimit - lowLimit)]
									]
				   ]
		ifFalse:[ 0]!

initialize: aNumber1 from: aNumber2 to: aNumber3
		"Private - Defines the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	( aNumber2 < aNumber3 and: [ aNumber1 between: aNumber2 and: aNumber3])
		ifFalse: [ self error: 'Illegal distribution parameters'].
	peak := aNumber1.
	lowLimit := aNumber2.
	highLimit := aNumber3.
	^self!

inverseAcceptanceAfterPeak: aNumber
		"Private - Compute inverse acceptance function in the region after the peak.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^ highLimit - ( ( ( 1 - aNumber) * ( highLimit - lowLimit) * ( highLimit - peak)) sqrt)!

inverseAcceptanceBeforePeak: aNumber
		"Private - Compute inverse acceptance function in the region before the peak.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^ ( aNumber * ( highLimit - lowLimit) * ( peak - lowLimit)) sqrt + lowLimit!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^(-6/10)!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: lowLimit with: highLimit with: peak!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( peak - lowLimit) / ( highLimit - lowLimit) > aNumber
			ifTrue: [ self inverseAcceptanceBeforePeak: aNumber]
			ifFalse: [ self inverseAcceptanceAfterPeak: aNumber]!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^(((lowLimit squared * lowLimit + ( peak squared * peak) + ( highLimit squared * highLimit) ) / 135)
	-(((lowLimit squared * peak) + (lowLimit squared * highLimit) + (peak squared * lowLimit) + (peak squared * highLimit) + (highLimit squared * lowLimit) + (highLimit squared * peak))/90)
	+( 2 * lowLimit * peak * highLimit / 45)) / ( self standardDeviation raisedToInteger: 3)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| norm |
	^( aNumber between: lowLimit and: highLimit)
		ifTrue: [ aNumber < peak
						ifTrue: [ norm := ( highLimit - lowLimit) * ( peak - lowLimit).
									 2 * ( aNumber - lowLimit) / norm
									]
						ifFalse:[ aNumber > peak
										ifTrue: [ norm := ( highLimit - lowLimit) * ( highLimit - peak).
									  				 2 * ( highLimit - aNumber) / norm
													]
										ifFalse:[ 2 / ( highLimit - lowLimit)]
									]
				   ]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(lowLimit squared + peak squared + highLimit squared - ( lowLimit * peak) - ( lowLimit * highLimit) - ( peak * highLimit)) / 18! !
!DhbTriangularDistribution categoriesFor: #average!information!public! !
!DhbTriangularDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbTriangularDistribution categoriesFor: #distributionValue:!information!public! !
!DhbTriangularDistribution categoriesFor: #initialize:from:to:!initialization!public! !
!DhbTriangularDistribution categoriesFor: #inverseAcceptanceAfterPeak:!information!public! !
!DhbTriangularDistribution categoriesFor: #inverseAcceptanceBeforePeak:!information!public! !
!DhbTriangularDistribution categoriesFor: #kurtosis!information!public! !
!DhbTriangularDistribution categoriesFor: #parameters!information!public! !
!DhbTriangularDistribution categoriesFor: #privateInverseDistributionValue:!information!public! !
!DhbTriangularDistribution categoriesFor: #skewness!information!public! !
!DhbTriangularDistribution categoriesFor: #value:!information!public! !
!DhbTriangularDistribution categoriesFor: #variance!information!public! !

!DhbTriangularDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Triangular distribution'!

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
	^self new: c from: ( c - b) to: ( c + b).!

new
		"Create an instance of the receiver with peak at 1/2 and limits 0 and 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^self new: (1 / 2) from: 0 to: 1!

new: aNumber1 from: aNumber2 to: aNumber3
		"Create an instance of the receiver with peak at aNumber1 and limits aNumber2 and aNumber3.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 from: aNumber2 to: aNumber3! !
!DhbTriangularDistribution class categoriesFor: #distributionName!information!public! !
!DhbTriangularDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbTriangularDistribution class categoriesFor: #new!creation!public! !
!DhbTriangularDistribution class categoriesFor: #new:from:to:!creation!public! !

