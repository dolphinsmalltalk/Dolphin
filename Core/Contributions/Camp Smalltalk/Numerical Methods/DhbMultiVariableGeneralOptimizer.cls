"Filed out from Dolphin Smalltalk XP"!

DhbFunctionOptimizer subclass: #DhbMultiVariableGeneralOptimizer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbMultiVariableGeneralOptimizer guid: (GUID fromString: '{E5500291-7D2B-11D6-B6CC-00022D5019C8}')!
DhbMultiVariableGeneralOptimizer comment: ''!
!DhbMultiVariableGeneralOptimizer categoriesForClass!DHB Numerical! !
!DhbMultiVariableGeneralOptimizer methodsFor!

computeInitialValues
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	self range notNil
		ifTrue: [ self performGeneticOptimization].
	self performSimplexOptimization.!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	| optimizer |
	optimizer := DhbHillClimbingOptimizer forOptimizer: self.
	optimizer desiredPrecision: desiredPrecision;
			  maximumIterations: maximumIterations;
			  initialValue: result.
	result := optimizer evaluate.
	^optimizer precision!

finalizeIterations
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "!

origin
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	^result!

origin: anArrayOrVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	result := anArrayOrVector.!

performGeneticOptimization
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	| optimizer manager |
	optimizer := DhbGeneticOptimizer forOptimizer: self.
	manager := DhbVectorChromosomeManager new: 100 mutation: 0.1 crossover: 0.1.
	manager origin: self origin asVector; range: self range asVector.
	optimizer chromosomeManager: manager.
	result := optimizer evaluate.!

performSimplexOptimization
	"Private - 
	(c) Copyrights Didier BESSET, 2000, all rights reserved. 
	Initial code: 2/29/00"

	| optimizer |
	optimizer := DhbSimplexOptimizer forOptimizer: self.
	optimizer desiredPrecision: desiredPrecision sqrt; maximumIterations: maximumIterations; initialValue: result asVector.
	result := optimizer evaluate!

range
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	^self bestPoints!

range: anArrayOrVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/29/00 "
	bestPoints := anArrayOrVector.! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #computeInitialValues!operation!public! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #evaluateIteration!operation!public! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #finalizeIterations!operation!public! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #origin!initialization!public! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #origin:!initialization!public! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #performGeneticOptimization!operation!public! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #performSimplexOptimization!operation!public! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #range!initialization!public! !
!DhbMultiVariableGeneralOptimizer categoriesFor: #range:!initialization!public! !

