"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbChromosomeManager
	instanceVariableNames: 'population populationSize rateOfMutation rateOfCrossover'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbChromosomeManager guid: (GUID fromString: '{E550027B-7D2B-11D6-B6CC-00022D5019C8}')!
DhbChromosomeManager comment: ''!
!DhbChromosomeManager categoriesForClass!DHB Numerical! !
!DhbChromosomeManager methodsFor!

clone: aChromosome
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^aChromosome copy!

crossover: aChromosome1 and: aChromosome2
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^self subclassResponsibility!

isFullyPopulated
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^population size >= populationSize!

mutate: aChromosome
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^self subclassResponsibility!

population
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^population!

populationSize: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	populationSize := anInteger.!

process: aChromosome1 and: aChromosome2 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	| roll |
	roll := Number random.
	roll < rateOfCrossover 
		ifTrue: [population addAll: (self crossover: aChromosome1 and: aChromosome2)]
		ifFalse: 
			[roll < (rateOfCrossover + rateOfMutation) 
				ifTrue: 
					[population
						add: (self mutate: aChromosome1);
						add: (self mutate: aChromosome2)]
				ifFalse: 
					[population
						add: (self clone: aChromosome1);
						add: (self clone: aChromosome2)]]!

randomChromosome
	self subclassResponsibility!

randomizePopulation
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	self reset.
	[self isFullyPopulated] 
		whileFalse: [population add: self randomChromosome]!

rateOfCrossover: aNumber 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	(aNumber between: 0 and: 1) 
		ifFalse: [self error: 'Illegal rate of cross-over'].
	rateOfCrossover := aNumber!

rateOfMutation: aNumber 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "

	(aNumber between: 0 and: 1) 
		ifFalse: [self error: 'Illegal rate of mutation'].
	rateOfMutation := aNumber!

reset
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	population := OrderedCollection new: populationSize.! !
!DhbChromosomeManager categoriesFor: #clone:!operation!public! !
!DhbChromosomeManager categoriesFor: #crossover:and:!operation!public! !
!DhbChromosomeManager categoriesFor: #isFullyPopulated!information!public! !
!DhbChromosomeManager categoriesFor: #mutate:!operation!public! !
!DhbChromosomeManager categoriesFor: #population!information!public! !
!DhbChromosomeManager categoriesFor: #populationSize:!initialization!public! !
!DhbChromosomeManager categoriesFor: #process:and:!operation!public! !
!DhbChromosomeManager categoriesFor: #randomChromosome!creation!public! !
!DhbChromosomeManager categoriesFor: #randomizePopulation!operation!public! !
!DhbChromosomeManager categoriesFor: #rateOfCrossover:!initialization!public! !
!DhbChromosomeManager categoriesFor: #rateOfMutation:!initialization!public! !
!DhbChromosomeManager categoriesFor: #reset!public!transformation! !

!DhbChromosomeManager class methodsFor!

new: anInteger mutation: aNumber1 crossover: aNumber2
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^self new populationSize: anInteger; rateOfMutation: aNumber1; rateOfCrossover: aNumber2; yourself! !
!DhbChromosomeManager class categoriesFor: #new:mutation:crossover:!creation!public! !

