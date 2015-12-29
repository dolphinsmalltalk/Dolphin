"Filed out from Dolphin Smalltalk XP"!

DhbFunctionalIterator subclass: #DhbTrapezeIntegrator
	instanceVariableNames: 'from to sum step'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbTrapezeIntegrator guid: (GUID fromString: '{E5500295-7D2B-11D6-B6CC-00022D5019C8}')!
DhbTrapezeIntegrator comment: ''!
!DhbTrapezeIntegrator categoriesForClass!DHB Numerical! !
!DhbTrapezeIntegrator methodsFor!

computeInitialValues
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	step := to - from.
	sum := ( ( functionBlock value: from) + ( functionBlock value: to)) * step /2.
	result := sum.!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	| oldResult |
	oldResult := result.
	result := self higherOrderSum.
	^self relativePrecision: ( result - oldResult) abs!

from: aNumber1 to: aNumber2
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	from := aNumber1.
	to := aNumber2.!

higherOrderSum
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 26/4/99 "
	| x newSum |
	x := step / 2 + from.
	newSum := 0.
	[ x < to ]
		whileTrue: [ newSum := ( functionBlock value: x) + newSum.
					 x := x + step.
				   ].
	sum := ( step * newSum + sum) / 2.
	step := step / 2.
	^sum!

initialize: aBlock from: aNumber1 to: aNumber2
		"Private - Initialize the parameters of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	functionBlock := aBlock.
	self from: aNumber1 to: aNumber2.
	^self! !
!DhbTrapezeIntegrator categoriesFor: #computeInitialValues!operation!public! !
!DhbTrapezeIntegrator categoriesFor: #evaluateIteration!operation!public! !
!DhbTrapezeIntegrator categoriesFor: #from:to:!initialization!public! !
!DhbTrapezeIntegrator categoriesFor: #higherOrderSum!public!transformation! !
!DhbTrapezeIntegrator categoriesFor: #initialize:from:to:!initialization!public! !

!DhbTrapezeIntegrator class methodsFor!

defaultMaximumIterations
		"Private - Answers the default maximum number of iterations for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^13!

function: aBlock from: aNumber1 to: aNumber2
		"Create an new instance with given parameters.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^super new initialize: aBlock from: aNumber1 to: aNumber2!

new
		"Private - Block the constructor method for this class.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^self error: 'Method new:from:to: must be used'! !
!DhbTrapezeIntegrator class categoriesFor: #defaultMaximumIterations!information!public! !
!DhbTrapezeIntegrator class categoriesFor: #function:from:to:!creation!public! !
!DhbTrapezeIntegrator class categoriesFor: #new!creation!public! !

