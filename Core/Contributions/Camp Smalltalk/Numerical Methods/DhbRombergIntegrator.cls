"Filed out from Dolphin Smalltalk XP"!

DhbTrapezeIntegrator subclass: #DhbRombergIntegrator
	instanceVariableNames: 'order points interpolator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbRombergIntegrator guid: (GUID fromString: '{E5500296-7D2B-11D6-B6CC-00022D5019C8}')!
DhbRombergIntegrator comment: ''!
!DhbRombergIntegrator categoriesForClass!DHB Numerical! !
!DhbRombergIntegrator methodsFor!

computeInitialValues
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	super computeInitialValues.
	points := OrderedCollection new: order.
	interpolator := DhbNevilleInterpolator points: points.
	points add: 1 @ sum.!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	| interpolation |
	points addLast: (points last x * 0.25) @ self higherOrderSum.
	points size < order
		ifTrue: [ ^1].
	interpolation := interpolator valueAndError: 0.
	points removeFirst.
	result := interpolation at: 1.
	^self relativePrecision: ( interpolation at: 2) abs!

initialize
		"Private - initialize the parameters of the receiver with default values.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	order := self class defaultOrder.
	^super initialize!

order: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	anInteger < 2
		ifTrue: [ self error: 'Order for Romberg integration must be larger than 1'].
	order := anInteger.! !
!DhbRombergIntegrator categoriesFor: #computeInitialValues!operation!public! !
!DhbRombergIntegrator categoriesFor: #evaluateIteration!operation!public! !
!DhbRombergIntegrator categoriesFor: #initialize!initialization!public! !
!DhbRombergIntegrator categoriesFor: #order:!initialization!public! !

!DhbRombergIntegrator class methodsFor!

defaultOrder
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	^5! !
!DhbRombergIntegrator class categoriesFor: #defaultOrder!information!public! !

