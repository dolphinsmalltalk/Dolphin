"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbHistogrammedDistribution
	instanceVariableNames: 'histogram'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbHistogrammedDistribution guid: (GUID fromString: '{E55002A9-7D2B-11D6-B6CC-00022D5019C8}')!
DhbHistogrammedDistribution comment: ''!
!DhbHistogrammedDistribution categoriesForClass!DHB Numerical! !
!DhbHistogrammedDistribution methodsFor!

acceptanceBetween: aNumber1 and: aNumber2
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value larger than aNumber 1 and lower than or equal to aNumber2.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( histogram countsBetween: ( aNumber1 max: histogram minimum)
						and: ( aNumber2 min: histogram maximum) ) / histogram totalCount!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^histogram average!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber < histogram minimum
		ifTrue: [ 0]
		ifFalse:[ aNumber < histogram maximum
							ifTrue: [ ( histogram countsUpTo: aNumber) / histogram totalCount]
							ifFalse:[ 1]
					]!

initialize: aHistogram
		"Private - Defines the histogram of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	aHistogram count = 0
		ifTrue: [ self error: 'Cannot define probability density on an empty histogram'].
	histogram := aHistogram.
	^self!

kurtosis
		"Answer the kurtosis of the receiver.
		 Undefined. Must be implemented by subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^histogram kurtosis!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose distribution is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^histogram inverseDistributionValue: aNumber!

skewness
		"Answer the skewness of the receiver.
		 Undefined. Must be implemented by subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^histogram skewness!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^histogram standardDeviation!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^( aNumber >= histogram minimum and: [ aNumber < histogram maximum])
		ifTrue: [ ( histogram countAt: aNumber) / ( histogram totalCount * histogram binWidth)]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^histogram variance! !
!DhbHistogrammedDistribution categoriesFor: #acceptanceBetween:and:!information!public! !
!DhbHistogrammedDistribution categoriesFor: #average!information!public! !
!DhbHistogrammedDistribution categoriesFor: #distributionValue:!information!public! !
!DhbHistogrammedDistribution categoriesFor: #initialize:!initialization!public! !
!DhbHistogrammedDistribution categoriesFor: #kurtosis!information!public! !
!DhbHistogrammedDistribution categoriesFor: #privateInverseDistributionValue:!information!public! !
!DhbHistogrammedDistribution categoriesFor: #skewness!information!public! !
!DhbHistogrammedDistribution categoriesFor: #standardDeviation!information!public! !
!DhbHistogrammedDistribution categoriesFor: #value:!information!public! !
!DhbHistogrammedDistribution categoriesFor: #variance!information!public! !

!DhbHistogrammedDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Experimental distribution'!

histogram: aHistogram
		"Create a new instance of the receiver corresponding to a histogram.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^super new initialize: aHistogram!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'! !
!DhbHistogrammedDistribution class categoriesFor: #distributionName!information!public! !
!DhbHistogrammedDistribution class categoriesFor: #histogram:!creation!public! !
!DhbHistogrammedDistribution class categoriesFor: #new!creation!public! !

