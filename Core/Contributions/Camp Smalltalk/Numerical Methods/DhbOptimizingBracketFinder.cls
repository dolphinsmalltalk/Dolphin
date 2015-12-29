"Filed out from Dolphin Smalltalk XP"!

DhbOneVariableFunctionOptimizer subclass: #DhbOptimizingBracketFinder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbOptimizingBracketFinder guid: (GUID fromString: '{E5500290-7D2B-11D6-B6CC-00022D5019C8}')!
DhbOptimizingBracketFinder comment: ''!
!DhbOptimizingBracketFinder categoriesForClass!DHB Numerical! !
!DhbOptimizingBracketFinder methodsFor!

computeInitialValues
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	[bestPoints size < 2] whileTrue: [self addPointAt: Number random]!

evaluateIteration
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| x1 x2 |
	x1 := ( bestPoints at: 1) position.
	x2 := ( bestPoints at: 2) position.
	self addPointAt: ( x1 * 3 - ( x2 * 2)).
	precision := ( x2 - x1) * ( ( bestPoints at: 3) position - x1).
	self hasConverged
		ifFalse:[ bestPoints removeLast].
	^precision!

finalizeIterations
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	result := bestPoints.!

initializeForOptimizer: aFunctionOptimizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	super initializeForOptimizer: aFunctionOptimizer.
	bestPoints := aFunctionOptimizer bestPoints.
	^self!

setInitialPoints: aSortedCollection
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	bestPoints := aSortedCollection.! !
!DhbOptimizingBracketFinder categoriesFor: #computeInitialValues!operation!public! !
!DhbOptimizingBracketFinder categoriesFor: #evaluateIteration!operation!public! !
!DhbOptimizingBracketFinder categoriesFor: #finalizeIterations!operation!public! !
!DhbOptimizingBracketFinder categoriesFor: #initializeForOptimizer:!initialization!public! !
!DhbOptimizingBracketFinder categoriesFor: #setInitialPoints:!initialization!public! !

!DhbOptimizingBracketFinder class methodsFor!

initialPoints: aSortedCollection function: aFunction
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^super new setInitialPoints: aSortedCollection; setFunction: aFunction! !
!DhbOptimizingBracketFinder class categoriesFor: #initialPoints:function:!creation!public! !

