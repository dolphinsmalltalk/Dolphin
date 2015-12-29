"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbGammaDistribution
	instanceVariableNames: 'alpha beta norm randomCoefficients incompleteGammaFunction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbGammaDistribution guid: (GUID fromString: '{E5500276-7D2B-11D6-B6CC-00022D5019C8}')!
DhbGammaDistribution comment: ''!
!DhbGammaDistribution categoriesForClass!DHB Numerical! !
!DhbGammaDistribution methodsFor!

average
		"Answer the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^alpha * beta!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	alpha := alpha + ( aVector at: 1).
	beta := beta + ( aVector at: 2).
	self computeNorm.
	incompleteGammaFunction := nil.
	randomCoefficients := nil.!

computeNorm
		"Private - Compute the norm of the receiver because its parameters have changed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	norm := beta ln * alpha + alpha logGamma.!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self incompleteGammaFunction value: aNumber / beta!

incompleteGammaFunction
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	incompleteGammaFunction isNil 
		ifTrue: 
			[incompleteGammaFunction := DhbIncompleteGammaFunction shape: alpha].
	^incompleteGammaFunction!

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

initializeRandomCoefficientsForLargeAlpha
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	| a b q d |
	a := 1 / ( 2 * alpha - 1) sqrt.
	b := alpha - (4 ln).
	q := 1 / a + alpha.
	d := 4.5 ln + 1.
	^Array with: a with: b with: q with: d!

initializeRandomCoefficientsForSmallAlpha
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	| e |
	e := 1 exp.
	^( e + alpha) / e!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^6 / alpha!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha with: beta!

random
		"Answer a random number distributed accroding to the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( alpha > 1 ifTrue: [ self randomForLargeAlpha]
						ifFalse:[ self randomForSmallAlpha]) * beta!

randomCoefficientsForLargeAlpha
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	randomCoefficients isNil
		ifTrue: [ randomCoefficients := self initializeRandomCoefficientsForLargeAlpha].
	^randomCoefficients!

randomCoefficientsForSmallAlpha
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	randomCoefficients isNil
		ifTrue: [ randomCoefficients := self initializeRandomCoefficientsForSmallAlpha].
	^randomCoefficients!

randomForLargeAlpha
		"Private - Generate a random number distributed according to the receiver
						when alpha > 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	[ true] whileTrue: [
	| u1 u2 c v y z w|
	u1 := DhbMitchellMooreGenerator new floatValue.
	u2 := DhbMitchellMooreGenerator new floatValue.
	c := self randomCoefficientsForLargeAlpha.
	v := ( u1 / ( 1 - u1)) ln * (c at: 1).
	y := v exp * alpha.
	z := u1 squared * u2.
	w := ( c at: 3) * v + ( c at: 2) - y.
	( c at: 4) + w >= ( 4.5 * z) ifTrue: [ ^y].
	z ln <= w ifTrue: [ ^y].
								].!

randomForSmallAlpha
		"Private - Generate a random number distributed according to the receiver
						when alpha < 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	[ true] whileTrue: [
	| p |
	p := DhbMitchellMooreGenerator new floatValue * self randomCoefficientsForSmallAlpha.
	p > 1
		ifTrue: [ | y |
					 y := ( ( self randomCoefficientsForSmallAlpha - p) / alpha) ln negated.
					 DhbMitchellMooreGenerator new floatValue <= ( y raisedTo: ( alpha - 1))
					 	ifTrue: [ ^y].
					]
		ifFalse: [ | y |
						y := p raisedTo: ( 1 / alpha).
					 DhbMitchellMooreGenerator new floatValue <= ( y negated exp)
					 	ifTrue: [ ^y].
					 ].
								].!

skewness
		"Answer the skewness of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^2 / alpha sqrt!

value: aNumber
		"Answers the probability that a random variable distributed according to the receiver
		 gives a value between aNumber and aNumber + espilon (infinitesimal interval).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^aNumber > 0
		ifTrue: [ ( aNumber ln * (alpha - 1) - (aNumber / beta) - norm) exp]
		ifFalse:[ 0].!

variance
		"Answer the variance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^beta squared * alpha! !
!DhbGammaDistribution categoriesFor: #average!information!public! !
!DhbGammaDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbGammaDistribution categoriesFor: #computeNorm!initialization!public! !
!DhbGammaDistribution categoriesFor: #distributionValue:!information!public! !
!DhbGammaDistribution categoriesFor: #incompleteGammaFunction!information!public! !
!DhbGammaDistribution categoriesFor: #initialize:scale:!initialization!public! !
!DhbGammaDistribution categoriesFor: #initializeRandomCoefficientsForLargeAlpha!information!public! !
!DhbGammaDistribution categoriesFor: #initializeRandomCoefficientsForSmallAlpha!information!public! !
!DhbGammaDistribution categoriesFor: #kurtosis!information!public! !
!DhbGammaDistribution categoriesFor: #parameters!information!public! !
!DhbGammaDistribution categoriesFor: #random!information!public! !
!DhbGammaDistribution categoriesFor: #randomCoefficientsForLargeAlpha!information!public! !
!DhbGammaDistribution categoriesFor: #randomCoefficientsForSmallAlpha!information!public! !
!DhbGammaDistribution categoriesFor: #randomForLargeAlpha!information!public! !
!DhbGammaDistribution categoriesFor: #randomForSmallAlpha!information!public! !
!DhbGammaDistribution categoriesFor: #skewness!information!public! !
!DhbGammaDistribution categoriesFor: #value:!information!public! !
!DhbGammaDistribution categoriesFor: #variance!information!public! !

!DhbGammaDistribution class methodsFor!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Gamma distribution'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| alpha beta |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	alpha := aHistogram average.
	beta := aHistogram variance / alpha.
	^[ self shape: alpha / beta scale: beta] on: Error do: [ :signal | signal return: nil]!

new
		"Prevent using this message to create instances
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'!

shape: aNumber1 scale: aNumber2
		"Create an instance of the receiver with given shape and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize: aNumber1 scale: aNumber2! !
!DhbGammaDistribution class categoriesFor: #distributionName!information!public! !
!DhbGammaDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbGammaDistribution class categoriesFor: #new!creation!public! !
!DhbGammaDistribution class categoriesFor: #shape:scale:!creation!public! !

