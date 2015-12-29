"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbProbabilityDistributionFunction
	instanceVariableNames: 'probabilityDensity'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbProbabilityDistributionFunction guid: (GUID fromString: '{E5500268-7D2B-11D6-B6CC-00022D5019C8}')!
DhbProbabilityDistributionFunction comment: ''!
!DhbProbabilityDistributionFunction categoriesForClass!DHB Numerical! !
!DhbProbabilityDistributionFunction methodsFor!

initialize: aProbabilityDensity
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	probabilityDensity := aProbabilityDensity.
	^self!

value: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^probabilityDensity distributionValue: aNumber! !
!DhbProbabilityDistributionFunction categoriesFor: #initialize:!initialization!public! !
!DhbProbabilityDistributionFunction categoriesFor: #value:!information!public! !

!DhbProbabilityDistributionFunction class methodsFor!

density: aProbabilityDensity
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^self new initialize: aProbabilityDensity! !
!DhbProbabilityDistributionFunction class categoriesFor: #density:!creation!public! !

