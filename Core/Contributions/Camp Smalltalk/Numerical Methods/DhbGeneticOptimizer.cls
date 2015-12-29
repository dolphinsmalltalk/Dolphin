"Filed out from Dolphin Smalltalk XP"!

DhbFunctionOptimizer subclass: #DhbGeneticOptimizer
	instanceVariableNames: 'chromosomeManager'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbGeneticOptimizer guid: (GUID fromString: '{E55002A6-7D2B-11D6-B6CC-00022D5019C8}')!
DhbGeneticOptimizer comment: ''!
!DhbGeneticOptimizer categoriesForClass!DHB Numerical! !
!DhbGeneticOptimizer methodsFor!

chromosomeManager: aChromosomeManager
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	chromosomeManager := aChromosomeManager.
	^self!

collectPoints
	"Private - 
	(c) Copyrights Didier BESSET, 2000, all rights reserved. 
	Initial code: 23-Feb-00"

	| bestPoint |
	bestPoints isEmpty not ifTrue: [bestPoint := bestPoints removeFirst].
	bestPoints removeAll: bestPoints asArray.
	chromosomeManager population do: [:each | self addPointAt: each].
	bestPoint notNil ifTrue: [bestPoints add: bestPoint].
	result := bestPoints first position!

computePrecision
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^1!

evaluateIteration
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| randomScale |
	randomScale := self randomScale.
	chromosomeManager reset.
	[ chromosomeManager isFullyPopulated]
		whileFalse: [ self processRandomParents: randomScale].
	self collectPoints.
	^self computePrecision!

initializeIterations
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	chromosomeManager randomizePopulation.
	self collectPoints!

processRandomParents: aNumberArray
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	chromosomeManager process: ( bestPoints at: ( self randomIndex: aNumberArray)) position
						and:  ( bestPoints at: ( self randomIndex: aNumberArray)) position.!

randomIndex: aNumberArray
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| x n |
	x := Number random.
	n := 1.
	aNumberArray do: 
		[ :each |
		  x < each
			ifTrue: [ ^n].
		  n := n + 1.
		].
	^aNumberArray size	"Never reached unless an error occurs"!

randomScale
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| norm fBest fWorst answer|
	fBest := bestPoints first value.
	fWorst := bestPoints last value.
	norm := 1 / ( fBest - fWorst).
	answer := bestPoints collect: [ :each | (each value - fWorst) * norm].
	norm := 1 / ( answer inject: 0 into: [ :sum :each | each + sum]).
	fBest := 0.
	^answer collect: [ :each | fBest := each * norm + fBest. fBest]! !
!DhbGeneticOptimizer categoriesFor: #chromosomeManager:!initialization!public! !
!DhbGeneticOptimizer categoriesFor: #collectPoints!operation!public! !
!DhbGeneticOptimizer categoriesFor: #computePrecision!information!public! !
!DhbGeneticOptimizer categoriesFor: #evaluateIteration!operation!public! !
!DhbGeneticOptimizer categoriesFor: #initializeIterations!operation!public! !
!DhbGeneticOptimizer categoriesFor: #processRandomParents:!operation!public! !
!DhbGeneticOptimizer categoriesFor: #randomIndex:!information!public! !
!DhbGeneticOptimizer categoriesFor: #randomScale!information!public! !

!DhbGeneticOptimizer class methodsFor!

defaultMaximumIterations
		"Private - Answers the default maximum number of iterations for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^500!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^0! !
!DhbGeneticOptimizer class categoriesFor: #defaultMaximumIterations!information!public! !
!DhbGeneticOptimizer class categoriesFor: #defaultPrecision!information!public! !

