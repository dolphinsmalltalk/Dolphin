"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbNormalDistribution
	instanceVariableNames: 'mu sigma nextRandom'
	classVariableNames: 'NextRandom'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbNormalDistribution guid: (GUID fromString: '{E5500288-7D2B-11D6-B6CC-00022D5019C8}')!
DhbNormalDistribution comment: ''!
!DhbNormalDistribution categoriesForClass!DHB Numerical! !
!DhbNormalDistribution methodsFor!

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
	sigma := sigma + ( aVector at: 2).!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^DhbErfApproximation new value: ( ( aNumber - mu) / sigma)!

initialize: aNumber1 sigma: aNumber2
		"Private - Defines the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	mu := aNumber1.
	sigma := aNumber2.
	^self!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: mu with: sigma!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self class random * sigma + mu!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^0!

standardDeviation
		"Answer the standard deviation of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^sigma!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbErfApproximation new normal: (aNumber - mu) / sigma) / sigma!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	| dp y |
	y := ( aNumber - mu) / sigma.
	dp := ( DhbErfApproximation new normal: y) / sigma.
	^Array with: dp
		   with: ( DhbVector with: dp * y / sigma
							 with: dp * ( y squared - 1) / sigma)! !
!DhbNormalDistribution categoriesFor: #average!information!public! !
!DhbNormalDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbNormalDistribution categoriesFor: #distributionValue:!information!public! !
!DhbNormalDistribution categoriesFor: #initialize:sigma:!initialization!public! !
!DhbNormalDistribution categoriesFor: #kurtosis!information!public! !
!DhbNormalDistribution categoriesFor: #parameters!information!public! !
!DhbNormalDistribution categoriesFor: #random!information!public! !
!DhbNormalDistribution categoriesFor: #skewness!information!public! !
!DhbNormalDistribution categoriesFor: #standardDeviation!information!public! !
!DhbNormalDistribution categoriesFor: #value:!information!public! !
!DhbNormalDistribution categoriesFor: #valueAndGradient:!information!public! !

!DhbNormalDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Normal distribution'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	^self new: aHistogram average sigma: aHistogram standardDeviation!

new
		"Create a new instance of the receiver with mu=0 and sigma=1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self new: 0 sigma: 1!

new: aNumber1 sigma: aNumber2
		"Create a new instance of the receiver with given mu and sigma.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 sigma: aNumber2!

random
		"Answer a random number distributed according to a (0,1) normal distribution.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| v1 v2 w y |
	NextRandom isNil
		ifTrue: [ [ v1 := Number random * 2 - 1.
					v2 := Number random * 2 - 1.
					w := v1 squared + v2 squared.
					w > 1 ] whileTrue: [].
				  y := ( ( w ln * 2 negated) / w) sqrt.
				v1 := y * v1.
				NextRandom := y * v2.
				]
		ifFalse:[ v1 :=NextRandom.
				  NextRandom := nil.
				].
	^v1! !
!DhbNormalDistribution class categoriesFor: #distributionName!information!public! !
!DhbNormalDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbNormalDistribution class categoriesFor: #new!creation!public! !
!DhbNormalDistribution class categoriesFor: #new:sigma:!creation!public! !
!DhbNormalDistribution class categoriesFor: #random!information!public! !

