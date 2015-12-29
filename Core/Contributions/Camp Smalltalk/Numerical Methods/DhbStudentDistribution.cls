"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbStudentDistribution
	instanceVariableNames: 'degreeOfFreedom norm chiSquareDistribution incompleteBetaFunction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbStudentDistribution guid: (GUID fromString: '{E5500278-7D2B-11D6-B6CC-00022D5019C8}')!
DhbStudentDistribution comment: ''!
!DhbStudentDistribution categoriesForClass!DHB Numerical! !
!DhbStudentDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^0!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	degreeOfFreedom := degreeOfFreedom + ( aVector at: 1).
	self computeNorm.!

chiSquareDistribution
		"Private - Answer the chi square distribution used to generate
		 random numbers for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	chiSquareDistribution isNil
		ifTrue: [ chiSquareDistribution := DhbChiSquareDistribution degreeOfFreedom: (degreeOfFreedom - 1)].
	^chiSquareDistribution!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	norm := ( ( degreeOfFreedom / 2 logBeta: ( 1 / 2) ) + ( degreeOfFreedom ln / 2)) negated.!

confidenceLevel: aNumber
		"Answer the probability in percent of finding a value
		 distributed according to the receiver with an absolute value
		 larger than aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	^( 1 - ( self symmetricAcceptance: aNumber abs)) * 100!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	aNumber = 0
		ifTrue: [ ^1/2].
	^( aNumber > 0
		ifTrue: [ 2 - ( self symmetricAcceptance: aNumber abs)]
		ifFalse:[ self symmetricAcceptance: aNumber abs]) / 2!

incompleteBetaFunction
	"Private - Answers the incomplete beta function used to compute
		 the symmetric acceptance integral of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "

	incompleteBetaFunction isNil 
		ifTrue: 
			[incompleteBetaFunction := DhbIncompleteBetaFunction 
						shape: degreeOfFreedom / 2
						shape: 0.5].
	^incompleteBetaFunction!

initialize: anInteger
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	anInteger > 0
		ifFalse: [ self error: 'Degree of freedom must be positive'].
	degreeOfFreedom := anInteger.
	self computeNorm.
	^self!

kurtosis
		"Answer the kurtosis of the receiver.
		 Undefined if the degree of freedom is less than 5.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^degreeOfFreedom > 4 ifTrue: [ 6 / ( degreeOfFreedom - 4)]
						 ifFalse:[ nil]!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: degreeOfFreedom!

random
		"Answer a random number distributed according to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^DhbNormalDistribution random * ( ( (degreeOfFreedom - 1) / self chiSquareDistribution random ) sqrt)!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

symmetricAcceptance: aNumber
		"Private - Compute the acceptance of the receiver between -aNumber and aNumber
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/3/99 "
	^ self incompleteBetaFunction value: ( degreeOfFreedom / ( aNumber squared + degreeOfFreedom))!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( norm - ( ( aNumber squared / degreeOfFreedom + 1) ln * ( ( degreeOfFreedom + 1) / 2))) exp!

variance
		"Answer the variance of the receiver.
		 Undefined if the degree of freedom is less than 3.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^degreeOfFreedom > 2 ifTrue: [ degreeOfFreedom / ( degreeOfFreedom - 2)]
						 ifFalse:[ nil]! !
!DhbStudentDistribution categoriesFor: #average!information!public! !
!DhbStudentDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbStudentDistribution categoriesFor: #chiSquareDistribution!information!public! !
!DhbStudentDistribution categoriesFor: #computeNorm!initialization!public! !
!DhbStudentDistribution categoriesFor: #confidenceLevel:!information!public! !
!DhbStudentDistribution categoriesFor: #distributionValue:!information!public! !
!DhbStudentDistribution categoriesFor: #incompleteBetaFunction!information!public! !
!DhbStudentDistribution categoriesFor: #initialize:!initialization!public! !
!DhbStudentDistribution categoriesFor: #kurtosis!information!public! !
!DhbStudentDistribution categoriesFor: #parameters!information!public! !
!DhbStudentDistribution categoriesFor: #random!information!public! !
!DhbStudentDistribution categoriesFor: #skewness!information!public! !
!DhbStudentDistribution categoriesFor: #symmetricAcceptance:!information!public! !
!DhbStudentDistribution categoriesFor: #value:!information!public! !
!DhbStudentDistribution categoriesFor: #variance!information!public! !

!DhbStudentDistribution class methodsFor!

asymptoticLimit
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/4/99 "
	^30!

degreeOfFreedom: anInteger 
	"Create a new instance of the receiver with anInteger degrees of freedom.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "

	^anInteger > self asymptoticLimit 
		ifTrue: [DhbNormalDistribution new]
		ifFalse: 
			[anInteger = 1 
				ifTrue: [DhbCauchyDistribution shape: 0 scale: 1]
				ifFalse: [super new initialize: anInteger]]!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Student distribution'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	| dof var |
	var := aHistogram variance.
	var = 0
		ifTrue: [ ^nil].
	dof :=  ( 2 / (1 - (1 / aHistogram variance))) rounded max: 1.
	^dof > self asymptoticLimit ifTrue: [ nil]
								ifFalse:[ self degreeOfFreedom: dof]!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

test: aStatisticalMoment1 with: aStatisticalMoment2
		"Preform a consistency Student test (or t-test) on the averages of  two statistical moments ( or histograms).
		 Answers the probability of failing the test.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	| t |
	t := ( aStatisticalMoment1 average - aStatisticalMoment2 average) abs.
	^1 - ( ( self class degreeOfFreedom: (  aStatisticalMoment1 count + aStatisticalMoment2 count - 2)) acceptanceBetween: t negated and: t)! !
!DhbStudentDistribution class categoriesFor: #asymptoticLimit!creation!public! !
!DhbStudentDistribution class categoriesFor: #degreeOfFreedom:!creation!public! !
!DhbStudentDistribution class categoriesFor: #distributionName!information!public! !
!DhbStudentDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbStudentDistribution class categoriesFor: #new!creation!public! !
!DhbStudentDistribution class categoriesFor: #test:with:!creation!public! !

