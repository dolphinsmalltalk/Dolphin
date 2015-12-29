"Filed out from Dolphin Smalltalk XP"!

DhbProbabilityDensity subclass: #DhbProbabilityDensityWithUnknownDistribution
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbProbabilityDensityWithUnknownDistribution guid: (GUID fromString: '{E5500274-7D2B-11D6-B6CC-00022D5019C8}')!
DhbProbabilityDensityWithUnknownDistribution comment: ''!
!DhbProbabilityDensityWithUnknownDistribution categoriesForClass!DHB Numerical! !
!DhbProbabilityDensityWithUnknownDistribution methodsFor!

acceptanceBetween: aNumber1 and: aNumber2
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value larger than aNumber 1 and lower than or equal to aNumber2.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbRombergIntegrator new: self from: aNumber1 to: aNumber2) evaluate!

distributionValue: aNumber
		"Answers the probability of observing a random variable distributed according to
		 the receiver with a value lower than or equal to aNumber.
		 This general purpose routine uses numerical integration.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( DhbRombergIntegrator new: self from: self lowestValue to: aNumber) evaluate!

lowestValue
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/18/00 "
	^0! !
!DhbProbabilityDensityWithUnknownDistribution categoriesFor: #acceptanceBetween:and:!information!public! !
!DhbProbabilityDensityWithUnknownDistribution categoriesFor: #distributionValue:!information!public! !
!DhbProbabilityDensityWithUnknownDistribution categoriesFor: #lowestValue!information!public! !

