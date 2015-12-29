"Filed out from Dolphin Smalltalk XP"!

DhbGammaDistribution subclass: #DhbChiSquareDistribution
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbChiSquareDistribution guid: (GUID fromString: '{E55002B1-7D2B-11D6-B6CC-00022D5019C8}')!
DhbChiSquareDistribution comment: ''!
!DhbChiSquareDistribution categoriesForClass!DHB Numerical! !
!DhbChiSquareDistribution methodsFor!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 13/4/99 "
	super changeParametersBy: (Array with: aVector first / 2 with: 0).!

confidenceLevel: aNumber
		"Answer the probability in percent of finding a chi square value
		 distributed according to the receiver larger than aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	^( 1 - ( self distributionValue: aNumber)) *100!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^Array with: alpha * 2! !
!DhbChiSquareDistribution categoriesFor: #changeParametersBy:!public!transformation! !
!DhbChiSquareDistribution categoriesFor: #confidenceLevel:!information!public! !
!DhbChiSquareDistribution categoriesFor: #parameters!information!public! !

!DhbChiSquareDistribution class methodsFor!

degreeOfFreedom: anInteger
		"Create a new instance of the receiver with given degree of freedom.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^anInteger > 40
		ifTrue: [ DhbAsymptoticChiSquareDistribution degreeOfFreedom: anInteger]
		ifFalse:[ super shape: anInteger / 2 scale: 2]!

distributionName
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^'Chi square distribution'!

fromHistogram: aHistogram
		"Create an instance of the receiver with parameters estimated from the
		  given histogram using best guesses. This method can be used to
		  find the initial values for a fit.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "
	| dof |
	aHistogram minimum < 0
		ifTrue: [ ^nil].
	dof := aHistogram average rounded.
	^dof > 0 ifTrue: [ self degreeOfFreedom: aHistogram average rounded]
			 ifFalse:[ nil]!

shape: aNumber1 scale: aNumber2
		"Create an instance of the receiver with given shape and scale parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self error: 'Illegal creation message for this class'! !
!DhbChiSquareDistribution class categoriesFor: #degreeOfFreedom:!creation!public! !
!DhbChiSquareDistribution class categoriesFor: #distributionName!information!public! !
!DhbChiSquareDistribution class categoriesFor: #fromHistogram:!creation!public! !
!DhbChiSquareDistribution class categoriesFor: #shape:scale:!creation!public! !

