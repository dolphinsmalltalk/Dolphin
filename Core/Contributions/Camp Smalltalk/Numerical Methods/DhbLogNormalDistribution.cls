"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensityWithUnknownDistribution subclass: #DhbLogNormalDistribution
	instanceVariableNames: 'normalDistribution'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLogNormalDistribution guid: (GUID fromString: '{E550027D-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLogNormalDistribution comment: ''!
!DhbLogNormalDistribution categoriesForClass!DHB Numerical! !
!DhbLogNormalDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( normalDistribution variance*0.5 + normalDistribution average) exp!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	normalDistribution changeParametersBy: aVector.!

fourthCentralMoment
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 24/6/99 "
	| y x |
	y := normalDistribution average exp.
	x := normalDistribution variance exp.
	^( y squared squared) * ( x squared)
		* ( ( ( x squared * x - 4) * ( x squared) + 6) * x - 3)!

initialize: aNumber1 sigma: aNumber2
		"Private - Defines the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	normalDistribution := DhbNormalDistribution new: aNumber1 sigma: aNumber2.
	^self!

kurtosis
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| x |
	x := normalDistribution variance exp.
	^( ( x + 2) * x + 3) * ( x squared) - 6!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^normalDistribution parameters!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^normalDistribution random exp!

skewness
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| x |
	x := normalDistribution variance exp.
	^(x - 1) sqrt * (x + 2)!

thirdCentralMoment
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 24/6/99 "
	| y x |
	y := normalDistribution average exp.
	x := normalDistribution variance exp.
	^( y squared * y) * ( x raisedTo: (3/2))
		* ( ( x squared negated + 3) * x - 2)!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > 0
		ifTrue: [ ( normalDistribution value: aNumber ln) / aNumber]
		ifFalse:[ 0]!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( normalDistribution average * 2 + normalDistribution variance) exp * ( normalDistribution variance exp - 1)! !
!DhbLogNormalDistribution categoriesFor: #average!information!public! !
!DhbLogNormalDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbLogNormalDistribution categoriesFor: #fourthCentralMoment!information!public! !
!DhbLogNormalDistribution categoriesFor: #initialize:sigma:!initialization!public! !
!DhbLogNormalDistribution categoriesFor: #kurtosis!information!public! !
!DhbLogNormalDistribution categoriesFor: #parameters!information!public! !
!DhbLogNormalDistribution categoriesFor: #random!information!public! !
!DhbLogNormalDistribution categoriesFor: #skewness!information!public! !
!DhbLogNormalDistribution categoriesFor: #thirdCentralMoment!information!public! !
!DhbLogNormalDistribution categoriesFor: #value:!information!public! !
!DhbLogNormalDistribution categoriesFor: #variance!information!public! !

!DhbLogNormalDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Log normal distribution'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| average variance sigma2 |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	average := aHistogram average.
	average > 0
		ifFalse: [ ^nil].
	variance := aHistogram variance.
	sigma2 := ( variance / average squared + 1) ln.
	sigma2 > 0
		ifFalse: [ ^nil].
	^self new: ( average ln - (sigma2 * 0.5)) sigma: sigma2 sqrt!

new
		"Create a new instance of the receiver with mu=0 and sigma=1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self new: 0 sigma: 1!

new: aNumber1 sigma: aNumber2
		"Create a new instance of the receiver with given mu and sigma.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 sigma: aNumber2! !
!DhbLogNormalDistribution class categoriesFor: #distributionName!information!public! !
!DhbLogNormalDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbLogNormalDistribution class categoriesFor: #new!creation!public! !
!DhbLogNormalDistribution class categoriesFor: #new:sigma:!creation!public! !

