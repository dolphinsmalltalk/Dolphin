"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbIncompleteGammaFunction
	instanceVariableNames: 'alpha alphaLogGamma series fraction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbIncompleteGammaFunction guid: (GUID fromString: '{E5500299-7D2B-11D6-B6CC-00022D5019C8}')!
DhbIncompleteGammaFunction comment: ''!
!DhbIncompleteGammaFunction categoriesForClass!DHB Numerical! !
!DhbIncompleteGammaFunction methodsFor!

evaluateFraction: aNumber 
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "

	fraction isNil 
		ifTrue: 
			[fraction := DhbIncompleteGammaFractionTermServer new.
			fraction setParameter: alpha].
	fraction setArgument: aNumber.
	^(DhbContinuedFraction server: fraction)
		desiredPrecision: DhbFloatingPointMachine new defaultNumericalPrecision;
		evaluate!

evaluateSeries: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	series isNil
		ifTrue: [ series := DhbIncompleteGammaSeriesTermServer new.
				  series setParameter: alpha.
				].
	series setArgument: aNumber.
	^(DhbInfiniteSeries server: series)
		desiredPrecision: DhbFloatingPointMachine new defaultNumericalPrecision;
		evaluate!

initialize: aNumber
		"Private - Defines the parameter alpha of the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	alpha := aNumber asFloat.
	alphaLogGamma := alpha logGamma.
	^self!

value: aNumber
		"Compute the value of the receiver for argument aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	| x norm |
	aNumber = 0
		ifTrue: [ ^0].
	x := aNumber asFloat.
	norm := [ ( x ln * alpha - x - alphaLogGamma) exp] on: Error do: [ :signal | signal return: nil].
	norm isNil
		ifTrue: [ ^1].
	^x - 1 < alpha
		ifTrue: [ ( self evaluateSeries: x) * norm]
		ifFalse:[ 1 - ( norm / ( self evaluateFraction: x))]! !
!DhbIncompleteGammaFunction categoriesFor: #evaluateFraction:!information!public! !
!DhbIncompleteGammaFunction categoriesFor: #evaluateSeries:!information!public! !
!DhbIncompleteGammaFunction categoriesFor: #initialize:!initialization!public! !
!DhbIncompleteGammaFunction categoriesFor: #value:!information!public! !

!DhbIncompleteGammaFunction class methodsFor!

shape: aNumber
		"Defines a new instance of the receiver with paramater aNumber
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/3/99 "
	^super new initialize: aNumber! !
!DhbIncompleteGammaFunction class categoriesFor: #shape:!creation!public! !

