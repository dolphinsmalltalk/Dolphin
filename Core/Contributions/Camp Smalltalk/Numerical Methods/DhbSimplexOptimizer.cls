"Filed out from Dolphin Smalltalk XP"!

DhbFunctionOptimizer subclass: #DhbSimplexOptimizer
	instanceVariableNames: 'worstVector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbSimplexOptimizer guid: (GUID fromString: '{E55002A8-7D2B-11D6-B6CC-00022D5019C8}')!
DhbSimplexOptimizer comment: ''!
!DhbSimplexOptimizer categoriesForClass!DHB Numerical! !
!DhbSimplexOptimizer methodsFor!

buildInitialSimplex
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	| projectedFunction finder partialResult |
	projectedFunction := DhbProjectedOneVariableFunction 
				function: functionBlock.
	finder := DhbOneVariableFunctionOptimizer forOptimizer: self.
	finder setFunction: projectedFunction.
	[bestPoints size < (result size + 1)] whileTrue: 
			[projectedFunction
				setArgument: result;
				bumpIndex.
			partialResult := finder
						reset;
						evaluate.
			bestPoints add: (optimizingPointClass 
						vector: (projectedFunction argumentWith: partialResult)
						function: functionBlock)]!

computeInitialValues
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	bestPoints 
		add: (optimizingPointClass vector: result function: functionBlock).
	self buildInitialSimplex.
	worstVector := bestPoints removeLast position!

computePrecision
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/16/00 "
	| functionValues bestFunctionValue |
	functionValues := bestPoints collect: [ :each | each value].
	bestFunctionValue := functionValues removeFirst.
	^functionValues inject: 0
					into: [ :max :each | ( self precisionOf: ( each - bestFunctionValue) abs relativeTo: bestFunctionValue abs) max: max]!

contract
	"Private - Contract the Simplex around the best Vector.
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/16/00 "

	| bestVector oldVectors |
	bestVector := bestPoints first position.
	oldVectors := OrderedCollection with: worstVector.
	[bestPoints size > 1] whileTrue: [oldVectors add: bestPoints removeLast position].
	oldVectors do: [:each | self contract: each around: bestVector].
	worstVector := bestPoints removeLast position.
	^self computePrecision!

contract: aVector around: bestVector 
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/16/00 "

	bestPoints 
		add: (optimizingPointClass vector: bestVector * 0.5 + (aVector * 0.5)
				function: functionBlock)!

evaluateIteration
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	| centerOfGravity newPoint nextPoint |
	centerOfGravity := (bestPoints inject: ((worstVector copy)
						atAllPut: 0;
						yourself)
				into: [:sum :each | each position + sum]) * (1 / bestPoints size).
	newPoint := optimizingPointClass vector: 2 * centerOfGravity - worstVector
				function: functionBlock.
	(newPoint betterThan: bestPoints first) 
		ifTrue: 
			[nextPoint := optimizingPointClass 
						vector: newPoint position * 2 - centerOfGravity
						function: functionBlock.
			(nextPoint betterThan: newPoint) ifTrue: [newPoint := nextPoint]]
		ifFalse: 
			[newPoint := optimizingPointClass 
						vector: centerOfGravity * 0.666667 + (worstVector * 0.333333)
						function: functionBlock.
			(newPoint betterThan: bestPoints first) ifFalse: [^self contract]].
	worstVector := bestPoints removeLast position.
	bestPoints add: newPoint.
	result := bestPoints first position.
	^self computePrecision!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	super printOn: aStream.
	aStream cr. 
	worstVector printOn: aStream.! !
!DhbSimplexOptimizer categoriesFor: #buildInitialSimplex!operation!public! !
!DhbSimplexOptimizer categoriesFor: #computeInitialValues!initialization!public! !
!DhbSimplexOptimizer categoriesFor: #computePrecision!operation!public! !
!DhbSimplexOptimizer categoriesFor: #contract!operation!public! !
!DhbSimplexOptimizer categoriesFor: #contract:around:!operation!public! !
!DhbSimplexOptimizer categoriesFor: #evaluateIteration!operation!public! !
!DhbSimplexOptimizer categoriesFor: #printOn:!display!public! !

!DhbSimplexOptimizer class methodsFor!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^DhbFloatingPointMachine new defaultNumericalPrecision * 1000! !
!DhbSimplexOptimizer class categoriesFor: #defaultPrecision!information!public! !

