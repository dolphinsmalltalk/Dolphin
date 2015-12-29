"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbScaledProbabilityDensityFunction
	instanceVariableNames: 'probabilityDensityFunction count binWidth'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbScaledProbabilityDensityFunction guid: (GUID fromString: '{E550027A-7D2B-11D6-B6CC-00022D5019C8}')!
DhbScaledProbabilityDensityFunction comment: ''!
!DhbScaledProbabilityDensityFunction categoriesForClass!DHB Numerical! !
!DhbScaledProbabilityDensityFunction methodsFor!

changeParametersBy: aVector
		"Modify the parameters of the receiver by aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	count := count + aVector last.
	probabilityDensityFunction changeParametersBy: aVector.!

distributionFunction
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	^probabilityDensityFunction distributionFunction!

initialize: aProbabilityDensityFunction binWidth: aNumber count: anInteger 
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	probabilityDensityFunction := aProbabilityDensityFunction.
	binWidth := aNumber.
	count := anInteger.
	^self!

parameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	^probabilityDensityFunction parameters copyWith: count!

printOn: aStream
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	super printOn: aStream.
	aStream nextPut: $[;
			nextPutAll: probabilityDensityFunction class distributionName;
			nextPut: $].!

setCount: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/3/99 "
	count := aNumber.!

value: aNumber 
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	^(probabilityDensityFunction value: aNumber) * binWidth * count!

valueAndGradient: aNumber 
	"Answers an Array containing the value of the receiver at aNumber
		 and the gradient of the receiver's respective to the receiver's
		 parameters evaluated at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "

	| g temp |
	g := probabilityDensityFunction valueAndGradient: aNumber.
	temp := binWidth * count.
	^Array with: g first * temp
		   with: ( (g last collect: [:each | each * temp]) copyWith: g first * binWidth)! !
!DhbScaledProbabilityDensityFunction categoriesFor: #changeParametersBy:!public!transformation! !
!DhbScaledProbabilityDensityFunction categoriesFor: #distributionFunction!information!public! !
!DhbScaledProbabilityDensityFunction categoriesFor: #initialize:binWidth:count:!initialization!public! !
!DhbScaledProbabilityDensityFunction categoriesFor: #parameters!information!public! !
!DhbScaledProbabilityDensityFunction categoriesFor: #printOn:!display!public! !
!DhbScaledProbabilityDensityFunction categoriesFor: #setCount:!public!transformation! !
!DhbScaledProbabilityDensityFunction categoriesFor: #value:!information!public! !
!DhbScaledProbabilityDensityFunction categoriesFor: #valueAndGradient:!information!public! !

!DhbScaledProbabilityDensityFunction class methodsFor!

histogram: aHistogram against: aProbabilityDensityFunction 
	"Create a new instance of the receiver with given probability density function and histogram.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/3/99 "

	^self new 
		initialize: aProbabilityDensityFunction
		binWidth: aHistogram binWidth
		count: aHistogram totalCount!

histogram: aHistogram distributionClass: aProbabilityDensityFunctionClass 
	"Create a new instance of the receiver with given probability density function and histogram. 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 3/3/99"

	| dp |
	^(dp := aProbabilityDensityFunctionClass fromHistogram: aHistogram) isNil
		ifTrue: [nil]
		ifFalse: [self histogram: aHistogram against: dp]! !
!DhbScaledProbabilityDensityFunction class categoriesFor: #histogram:against:!creation!public! !
!DhbScaledProbabilityDensityFunction class categoriesFor: #histogram:distributionClass:!creation!public! !

