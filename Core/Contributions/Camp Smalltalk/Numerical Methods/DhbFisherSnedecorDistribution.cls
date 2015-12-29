"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbFisherSnedecorDistribution
	instanceVariableNames: 'dof1 dof2 norm chiSquareDistribution1 chiSquareDistribution2 incompleteBetaFunction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbFisherSnedecorDistribution guid: (GUID fromString: '{E550029F-7D2B-11D6-B6CC-00022D5019C8}')!
DhbFisherSnedecorDistribution comment: ''!
!DhbFisherSnedecorDistribution categoriesForClass!DHB Numerical! !
!DhbFisherSnedecorDistribution methodsFor!

average
		"Answer the average of the receiver.
		 Undefined if dof2 is smaller than 3.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^dof2 > 2
		ifTrue: [ dof2 / ( dof2 - 2)]
		ifFalse:[ nil]!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	dof1 := ( dof1 + ( aVector at: 1)) max: 1.
	dof2 := ( dof2 + ( aVector at: 2)) max: 1.
	self computeNorm.
	chiSquareDistribution1 := nil.
	chiSquareDistribution2 := nil.
	incompleteBetaFunction := nil.!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	norm := ( dof1 ln * ( dof1 / 2) ) + ( dof2 ln * ( dof2 / 2) )
						- ( ( dof1 / 2) logBeta: ( dof2 / 2) ).!

confidenceLevel: aNumber
		"Answer the probability in percent of finding a value
		 distributed according to the receiver outside of the
		 interval [ 1/aNumber, aNumber].
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	aNumber < 0
		ifTrue: [ self error: 'Confidence level argument must be positive'].
	^( 1- ( self acceptanceBetween: aNumber reciprocal and: aNumber)) * 100!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	^1 - ( self incompleteBetaFunction value: ( dof2 / ( aNumber * dof1 + dof2)))!

incompleteBetaFunction
	"Private - Answers the incomplete beta function used to compute
		 the symmetric acceptance integral of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "

	incompleteBetaFunction isNil 
		ifTrue: 
			[incompleteBetaFunction := DhbIncompleteBetaFunction shape: dof2 / 2
						shape: dof1 / 2].
	^incompleteBetaFunction!

initialize: anInteger1 and: anInteger2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	dof1 := anInteger1.
	dof2 := anInteger2.
	self computeNorm.
	^self!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: dof1 with: dof2!

random
		"Answer a random number distributed according to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	chiSquareDistribution1 isNil
		ifTrue: [ chiSquareDistribution1 := DhbChiSquareDistribution degreeOfFreedom: dof1.
				  chiSquareDistribution2 := DhbChiSquareDistribution degreeOfFreedom: dof2.
				].
	^chiSquareDistribution1 random * dof2 / ( chiSquareDistribution2 random * dof1)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > 0
		ifTrue: [ ( norm + ( aNumber ln * ( dof1 / 2 - 1) ) - ( (aNumber * dof1 + dof2) ln * ( ( dof1 + dof2) / 2))) exp]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 Undefined if dof2 is smaller than 5.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^dof2 > 4 ifTrue: [ dof2 squared * 2 * ( dof1 + dof2 - 2) / ( ( dof2 - 2) squared * dof1 * ( dof2 - 4))]
				   ifFalse:[ nil]! !
!DhbFisherSnedecorDistribution categoriesFor: #average!information!public! !
!DhbFisherSnedecorDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbFisherSnedecorDistribution categoriesFor: #computeNorm!initialization!public! !
!DhbFisherSnedecorDistribution categoriesFor: #confidenceLevel:!information!public! !
!DhbFisherSnedecorDistribution categoriesFor: #distributionValue:!information!public! !
!DhbFisherSnedecorDistribution categoriesFor: #incompleteBetaFunction!information!public! !
!DhbFisherSnedecorDistribution categoriesFor: #initialize:and:!initialization!public! !
!DhbFisherSnedecorDistribution categoriesFor: #parameters!information!public! !
!DhbFisherSnedecorDistribution categoriesFor: #random!information!public! !
!DhbFisherSnedecorDistribution categoriesFor: #value:!information!public! !
!DhbFisherSnedecorDistribution categoriesFor: #variance!information!public! !

!DhbFisherSnedecorDistribution class methodsFor!

degreeOfFreedom: anInteger1 degreeOfFreedom: anInteger2 
	"Create a new instance of the receiver with given degrees of freedom.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "

	^super new initialize: anInteger1 and: anInteger2!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Fisher-Snedecor distribution'!

fromHistogram: aHistogram 
	"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "

	| n1 n2 a |
	aHistogram minimum < 0 ifTrue: [^nil].
	n2 := (2 / (1 - (1 / aHistogram average))) rounded.
	n2 > 0 ifFalse: [^nil].
	a := (n2 - 2) * (n2 - 4) * aHistogram variance / (n2 squared * 2).
	n1 := (0.7 * (n2 - 2) / (1 - a)) rounded.
	^n1 > 0 
		ifTrue: [self degreeOfFreedom: n1 degreeOfFreedom: n2]
		ifFalse: [nil]!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

test: aStatisticalMoment1 with: aStatisticalMoment2 
	"Perform a consistency Fisher test (or F-test) on the variances of two statistical moments ( or histograms).
		 Answer the probability of passing the test.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "

	^(self class degreeOfFreedom: aStatisticalMoment1 count
		degreeOfFreedom: aStatisticalMoment2 count) 
			distributionValue: aStatisticalMoment1 variance 
					/ aStatisticalMoment2 variance! !
!DhbFisherSnedecorDistribution class categoriesFor: #degreeOfFreedom:degreeOfFreedom:!creation!public! !
!DhbFisherSnedecorDistribution class categoriesFor: #distributionName!information!public! !
!DhbFisherSnedecorDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbFisherSnedecorDistribution class categoriesFor: #new!creation!public! !
!DhbFisherSnedecorDistribution class categoriesFor: #test:with:!creation!public! !

