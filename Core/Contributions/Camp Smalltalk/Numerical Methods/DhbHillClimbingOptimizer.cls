"Filed out from Dolphin Smalltalk XP"!

DhbFunctionOptimizer subclass: #DhbHillClimbingOptimizer
	instanceVariableNames: 'unidimensionalFinder'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbHillClimbingOptimizer guid: (GUID fromString: '{E5500294-7D2B-11D6-B6CC-00022D5019C8}')!
DhbHillClimbingOptimizer comment: ''!
!DhbHillClimbingOptimizer categoriesForClass!DHB Numerical! !
!DhbHillClimbingOptimizer methodsFor!

computeInitialValues
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 05-Jan-00 "
	unidimensionalFinder := DhbOneVariableFunctionOptimizer forOptimizer: self.
	unidimensionalFinder desiredPrecision: desiredPrecision.
	bestPoints := ( 1 to: result size)
							collect: [ :n |
									   ( DhbVectorProjectedFunction function: functionBlock)
											direction: ( ( DhbVector new: result size)
															atAllPut: 0;
															at: n put: 1;
															yourself);
											yourself
									 ].!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	| oldResult |
	precision := 1.0.
	bestPoints inject: result
				 into: [ :prev :each | ( self minimizeDirection: each from: prev)].
	self shiftDirections.
	self minimizeDirection: bestPoints last.
	oldResult := result.
	result := bestPoints last origin.
	precision := 0.0.
	result with: oldResult do:
		[ :x0 :x1 |
		  precision := ( self precisionOf: (x0 - x1) abs relativeTo: x0 abs) max: precision.
		].
	^precision!

finalizeIterations
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "!

minimizeDirection: aVectorFunction 
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^unidimensionalFinder
		reset;
		setFunction: aVectorFunction;
		addPointAt: 0;
		addPointAt: precision;
		addPointAt: precision negated;
		evaluate!

minimizeDirection: aVectorFunction from: aVector 
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	^aVectorFunction
		origin: aVector;
		argumentWith: ( self minimizeDirection: aVectorFunction)!

shiftDirections
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| position delta firstDirection |
	firstDirection := bestPoints first direction.
	bestPoints inject: nil
					into: [ :prev :each |
							position isNil
								ifTrue: [ position := each origin]
								ifFalse:[ prev direction: each direction].
							each
							].
	position := bestPoints last origin - position.
	delta := position norm.
	delta > desiredPrecision
		ifTrue: [ bestPoints last direction: (position scaleBy: (1 / delta))]
		ifFalse:[ bestPoints last direction: firstDirection].! !
!DhbHillClimbingOptimizer categoriesFor: #computeInitialValues!initialization!public! !
!DhbHillClimbingOptimizer categoriesFor: #evaluateIteration!operation!public! !
!DhbHillClimbingOptimizer categoriesFor: #finalizeIterations!operation!public! !
!DhbHillClimbingOptimizer categoriesFor: #minimizeDirection:!operation!public! !
!DhbHillClimbingOptimizer categoriesFor: #minimizeDirection:from:!operation!public! !
!DhbHillClimbingOptimizer categoriesFor: #shiftDirections!operation!public! !

