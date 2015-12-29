"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbAsymptoticChiSquareDistribution
	instanceVariableNames: 'degreeOfFreedom reducedDOF normalDistribution'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbAsymptoticChiSquareDistribution guid: (GUID fromString: '{E55002B4-7D2B-11D6-B6CC-00022D5019C8}')!
DhbAsymptoticChiSquareDistribution comment: ''!
!DhbAsymptoticChiSquareDistribution categoriesForClass!DHB Numerical! !
!DhbAsymptoticChiSquareDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^degreeOfFreedom!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	normalDistribution changeParametersBy: aVector.!

confidenceLevel: aNumber
		"Answer the probability in percent of finding a chi square value
		 distributed according to the receiver larger than aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	^( 1 - ( self distributionValue: aNumber)) *100!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	| x |
	^aNumber > 0
		ifTrue: [ x := (aNumber * 2) sqrt.
				  ( DhbErfApproximation new value: (x - reducedDOF))
				]
		ifFalse:[ 0]!

initialize: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	degreeOfFreedom := anInteger.
	reducedDOF := ( degreeOfFreedom * 2 - 1) sqrt.
	^self!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^12 / degreeOfFreedom!

parameters
		"Returns an Array containing the parameters of the distribution.
		 It is used to print out the distribution and for fitting.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: degreeOfFreedom!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbNormalDistribution random + reducedDOF) squared / 2!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^( 2 / degreeOfFreedom) sqrt * 2!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	| x |
	^aNumber > 0
		ifTrue: [ x := (aNumber * 2) sqrt.
				  ( DhbErfApproximation new normal: (x - reducedDOF)) / x
				]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^degreeOfFreedom * 2! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #average!information!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #confidenceLevel:!information!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #distributionValue:!information!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #initialize:!initialization!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #kurtosis!information!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #parameters!information!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #random!information!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #skewness!information!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #value:!information!public! !
!DhbAsymptoticChiSquareDistribution categoriesFor: #variance!information!public! !

!DhbAsymptoticChiSquareDistribution class methodsFor!

degreeOfFreedom: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^super new initialize: anInteger!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^'Chi square distribution'!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/3/99 "
	^self error: 'Illegal creation message for this class'! !
!DhbAsymptoticChiSquareDistribution class categoriesFor: #degreeOfFreedom:!creation!public! !
!DhbAsymptoticChiSquareDistribution class categoriesFor: #distributionName!information!public! !
!DhbAsymptoticChiSquareDistribution class categoriesFor: #new!creation!public! !

