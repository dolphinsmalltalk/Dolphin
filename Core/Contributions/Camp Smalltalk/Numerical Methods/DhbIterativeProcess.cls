"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbIterativeProcess
	instanceVariableNames: 'precision desiredPrecision maximumIterations result iterations'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbIterativeProcess guid: (GUID fromString: '{E550028A-7D2B-11D6-B6CC-00022D5019C8}')!
DhbIterativeProcess comment: ''!
!DhbIterativeProcess categoriesForClass!DHB Numerical! !
!DhbIterativeProcess methodsFor!

desiredPrecision: aNumber
		"Defines the desired precision for the result.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	aNumber > 0
		ifFalse: [ ^self error: 'Illegal precision: ', aNumber printString].
	desiredPrecision := aNumber.!

evaluate
	"Perform the iteration until either the desired precision is attained or the number of iterations exceeds the maximum.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	iterations := 0.
	self initializeIterations.
	
	[iterations := iterations + 1.
	precision := self evaluateIteration.
	self hasConverged or: [iterations >= maximumIterations]] 
			whileFalse: [].
	self finalizeIterations.
	^self result!

evaluateIteration
		"Dummy method (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^self subclassResponsibility!

finalizeIterations
	"Perform cleanup operation if needed (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "!

hasConverged
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 20/4/99 "
	^precision <= desiredPrecision!

initialize
		"Private - initialize the parameters of the receiver with default values.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	desiredPrecision := self class defaultPrecision.
	maximumIterations := self class defaultMaximumIterations.
	^self!

initializeIterations
	"Initialize the iterations (must be implemented by subclass when needed).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "!

iterations
		"Answers the number of iterations performed.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^iterations!

limitedSmallValue: aNumber
		"Private - prevent aNumber from being smaller in absolute value than a small number.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	^aNumber abs < DhbFloatingPointMachine new smallNumber
			ifTrue: [ DhbFloatingPointMachine new smallNumber]
			ifFalse:[ aNumber]!

maximumIterations: anInteger
		"Defines the maximum number of iterations.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	( anInteger isInteger and: [ anInteger > 1])
		ifFalse: [ ^self error: 'Invalid maximum number of iteration: ', anInteger printString].
	maximumIterations := anInteger.!

precision
		"Answer the attained precision for the result.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^precision!

precisionOf: aNumber1 relativeTo: aNumber2
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 3/5/99 "
	^aNumber2 > DhbFloatingPointMachine new defaultNumericalPrecision
		ifTrue: [ aNumber1 / aNumber2]
		ifFalse:[ aNumber1]!

result
		"Answer the result of the iterations (if any)
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^result! !
!DhbIterativeProcess categoriesFor: #desiredPrecision:!initialization!public! !
!DhbIterativeProcess categoriesFor: #evaluate!operation!public! !
!DhbIterativeProcess categoriesFor: #evaluateIteration!operation!public! !
!DhbIterativeProcess categoriesFor: #finalizeIterations!operation!public! !
!DhbIterativeProcess categoriesFor: #hasConverged!information!public! !
!DhbIterativeProcess categoriesFor: #initialize!initialization!public! !
!DhbIterativeProcess categoriesFor: #initializeIterations!operation!public! !
!DhbIterativeProcess categoriesFor: #iterations!information!public! !
!DhbIterativeProcess categoriesFor: #limitedSmallValue:!information!public! !
!DhbIterativeProcess categoriesFor: #maximumIterations:!initialization!public! !
!DhbIterativeProcess categoriesFor: #precision!information!public! !
!DhbIterativeProcess categoriesFor: #precisionOf:relativeTo:!information!public! !
!DhbIterativeProcess categoriesFor: #result!information!public! !

!DhbIterativeProcess class methodsFor!

defaultMaximumIterations
		"Private - Answers the default maximum number of iterations for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^50!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^DhbFloatingPointMachine new defaultNumericalPrecision!

new
		"Create an instance of the class.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^super new initialize! !
!DhbIterativeProcess class categoriesFor: #defaultMaximumIterations!information!public! !
!DhbIterativeProcess class categoriesFor: #defaultPrecision!information!public! !
!DhbIterativeProcess class categoriesFor: #new!creation!public! !

