"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbWeibullDistribution
	instanceVariableNames: 'alpha beta norm'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbWeibullDistribution guid: (GUID fromString: '{E55002A1-7D2B-11D6-B6CC-00022D5019C8}')!
DhbWeibullDistribution comment: ''!
!DhbWeibullDistribution categoriesForClass!DHB Numerical! !
!DhbWeibullDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^(1 / alpha) gamma * beta / alpha!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	alpha := alpha + ( aVector at: 1).
	beta := beta + ( aVector at: 2).
	self computeNorm.!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	norm := alpha/ ( beta raisedTo: alpha).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 Assumes that the value of the receiver is 0 for x < 0.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > 0
		ifTrue: [ 1 - ( ( ( aNumber / beta) raisedTo: alpha) negated exp)]
		ifFalse:[ 0]!

initialize: aNumber1 scale: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	( aNumber1 > 0 and: [ aNumber2 > 0])
		ifFalse: [ self error: 'Illegal distribution parameters'].
	alpha := aNumber1.
	beta := aNumber2.
	self computeNorm.
	^self!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha with: beta!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose acceptance is aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( (1 - aNumber) ln negated raisedTo: ( 1 / alpha)) * beta!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( ( aNumber / beta) raisedTo: alpha) negated exp * ( aNumber raisedTo: ( alpha - 1)) * norm!

variance
		"Answer the variance of the receiver.
		 NOTE: At least one of the methods variance or standardDeviation must be implemented by the subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( beta squared / alpha) * ( (2 / alpha) gamma * 2 - ( (1 / alpha ) gamma squared / alpha))! !
!DhbWeibullDistribution categoriesFor: #average!information!public! !
!DhbWeibullDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbWeibullDistribution categoriesFor: #computeNorm!initialization!public! !
!DhbWeibullDistribution categoriesFor: #distributionValue:!information!public! !
!DhbWeibullDistribution categoriesFor: #initialize:scale:!initialization!public! !
!DhbWeibullDistribution categoriesFor: #parameters!information!public! !
!DhbWeibullDistribution categoriesFor: #privateInverseDistributionValue:!initialization!public! !
!DhbWeibullDistribution categoriesFor: #value:!information!public! !
!DhbWeibullDistribution categoriesFor: #variance!information!public! !

!DhbWeibullDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Weibull distribution'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| average xMin xMax accMin accMax |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	average := aHistogram average.
	xMin := ( aHistogram minimum + average) / 2.
	accMin := ( aHistogram countsUpTo: xMin) / aHistogram totalCount.
	xMax := ( aHistogram maximum + average) / 2.
	accMax := ( aHistogram countsUpTo: xMax) / aHistogram totalCount.
	^[self solve: xMin acc: accMin upper: xMax acc: accMax]
			on: Error do: [ :signal | signal return: nil]!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

shape: aNumber1 scale: aNumber2 
	"Create an instance of the receiver with given shape and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new initialize: aNumber1 scale: aNumber2!

solve: lowX acc: lowAcc upper: highX acc: highAcc 
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "

	| lowLnAcc highLnAcc deltaLnAcc lowLnX highLnX |
	lowLnAcc := (1 - lowAcc) ln negated ln.
	highLnAcc := (1 - highAcc) ln negated ln.
	deltaLnAcc := highLnAcc - lowLnAcc.
	lowLnX := lowX ln.
	highLnX := highX ln.
	^self shape: deltaLnAcc / (highLnX - lowLnX)
		scale: ((highLnAcc * lowLnX - (lowLnAcc * highLnX)) / deltaLnAcc) exp! !
!DhbWeibullDistribution class categoriesFor: #distributionName!information!public! !
!DhbWeibullDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbWeibullDistribution class categoriesFor: #new!creation!public! !
!DhbWeibullDistribution class categoriesFor: #shape:scale:!creation!public! !
!DhbWeibullDistribution class categoriesFor: #solve:acc:upper:acc:!creation!public! !

