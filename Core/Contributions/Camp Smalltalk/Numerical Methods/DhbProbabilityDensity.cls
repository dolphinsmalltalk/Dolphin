"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbProbabilityDensity
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbProbabilityDensity guid: (GUID fromString: '{E5500273-7D2B-11D6-B6CC-00022D5019C8}')!
DhbProbabilityDensity comment: ''!
!DhbProbabilityDensity categoriesForClass!DHB Numerical! !
!DhbProbabilityDensity methodsFor!

acceptanceBetween: aNumber1 and: aNumber2
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value larger than aNumber 1 and lower than or equal to aNumber2.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( self distributionValue: aNumber2) - ( self distributionValue: aNumber1)!

approximatedValueAndGradient: aNumber
		"Private - gradients an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 The gradient is computed by approximation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	| delta parameters dp gradient n |
	parameters := self parameters.
	n := parameters size.
	dp := self value: aNumber.
	delta := Array new: n.
	delta atAllPut: 0.
	gradient := DhbVector new: n.
	1 to: n do:
		[ :k |
		  delta at: k put: ( parameters at: k) * 0.0001.
		  self changeParametersBy: delta.
		  gradient at: k put: ( ( ( self value: aNumber) - dp) / ( delta at: k)).
		  delta at: k put: ( delta at: k ) negated.
		  k > 1
			ifTrue: [ delta at: ( k - 1) put: 0].
		].
	self changeParametersBy: delta.
	^Array with: dp with: gradient!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	self subclassResponsibility.!

changeParametersBy: aVector 
	self subclassResponsibility!

distributionFunction
		" (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^DhbProbabilityDistributionFunction density: self!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self subclassResponsibility!

inverseDistributionValue: aNumber
		"Answer the number whose distribution value is aNumber.
		 NOTE: Subclass MUST NOT overwrite this method.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( aNumber between: 0 and: 1)
			ifTrue: [ self privateInverseDistributionValue: aNumber]
			ifFalse:[ self error: 'Illegal argument for inverse distribution value']!

kurtosis
		"Answer the kurtosis of the receiver.
		 Undefined. Must be implemented by subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^nil!

parameters
	"Returns an Array containing the parameters of the distribution. 
	It is used to print out the distribution and for fitting. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 4/3/99"

	^self subclassResponsibility!

printOn: aStream 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 4/3/99"

	| params |
	aStream nextPutAll: self class distributionName.
	(params := self parameters) notNil
		ifTrue: 
			[| first |
			first := true.
			aStream nextPut: $(.
			params
				do: 
					[:each | 
					first
						ifTrue: [first := false]
						ifFalse: [aStream nextPut: $,].
					aStream space.
					each printOn: aStream].
			aStream nextPut: $)]!

privateInverseDistributionValue: aNumber
		"Private - Answer the number whose distribution is aNumber.
		 NOTE: Subclass may overwrite this method for faster computation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbNewtonZeroFinder function: [ :x | ( self distributionValue: x) - aNumber] derivative: self)
		initialValue: self average / (1 - aNumber); evaluate!

random
		"Answer a random number distributed according to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self privateInverseDistributionValue: DhbMitchellMooreGenerator new floatValue!

skewness
		"Answer the skewness of the receiver.
		 Undefined. Must be implemented by subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^nil!

standardDeviation
		"Answer the standard deviation of the receiver.
		 NOTE: At least one of the methods variance or standardDeviation must be implemented by the subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self variance sqrt!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	self subclassResponsibility.!

valueAndGradient: aNumber
		"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^self approximatedValueAndGradient: aNumber!

variance
		"Answer the variance of the receiver.
		 NOTE: At least one of the methods variance or standardDeviation must be implemented by the subclass.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self standardDeviation squared! !
!DhbProbabilityDensity categoriesFor: #acceptanceBetween:and:!information!public! !
!DhbProbabilityDensity categoriesFor: #approximatedValueAndGradient:!information!public! !
!DhbProbabilityDensity categoriesFor: #average!information!public! !
!DhbProbabilityDensity categoriesFor: #changeParametersBy:!public!transformation! !
!DhbProbabilityDensity categoriesFor: #distributionFunction!creation!public! !
!DhbProbabilityDensity categoriesFor: #distributionValue:!information!public! !
!DhbProbabilityDensity categoriesFor: #inverseDistributionValue:!information!public! !
!DhbProbabilityDensity categoriesFor: #kurtosis!information!public! !
!DhbProbabilityDensity categoriesFor: #parameters!information!public! !
!DhbProbabilityDensity categoriesFor: #printOn:!display!public! !
!DhbProbabilityDensity categoriesFor: #privateInverseDistributionValue:!information!public! !
!DhbProbabilityDensity categoriesFor: #random!information!public! !
!DhbProbabilityDensity categoriesFor: #skewness!information!public! !
!DhbProbabilityDensity categoriesFor: #standardDeviation!information!public! !
!DhbProbabilityDensity categoriesFor: #value:!information!public! !
!DhbProbabilityDensity categoriesFor: #valueAndGradient:!information!public! !
!DhbProbabilityDensity categoriesFor: #variance!information!public! !

!DhbProbabilityDensity class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Unknown distribution'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 Default returns nil (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	^nil! !
!DhbProbabilityDensity class categoriesFor: #distributionName!information!public! !
!DhbProbabilityDensity class categoriesFor: #fromHistogram:!creation!public! !

