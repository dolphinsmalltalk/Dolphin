"Filed out from Dolphin Smalltalk XP"!

DhbChromosomeManager subclass: #DhbVectorChromosomeManager
	instanceVariableNames: 'origin range'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbVectorChromosomeManager guid: (GUID fromString: '{E55002A2-7D2B-11D6-B6CC-00022D5019C8}')!
DhbVectorChromosomeManager comment: ''!
!DhbVectorChromosomeManager categoriesForClass!DHB Numerical! !
!DhbVectorChromosomeManager methodsFor!

crossover: aChromosome1 and: aChromosome2
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| index new1 new2|
	index := ( aChromosome1 size - 1) random + 2.
	new1 := self clone: aChromosome1.
	new1 replaceFrom: index to: new1 size with: aChromosome2 startingAt: index.
	new2 := self clone: aChromosome2.
	new2 replaceFrom: index to: new2 size with: aChromosome1 startingAt: index.
	^Array with: new1 with: new2!

mutate: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	| index |
	index := aVector size random + 1.
	^( aVector copy)
			at: index put: ( self randomComponent: index);
			yourself!

origin: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	origin := aVector.!

randomChromosome
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^( ( 1 to: origin size) collect: [ :n | self randomComponent: n]) asVector!

randomComponent: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	^( range at: anInteger) asFloat random + ( origin at: anInteger)!

range: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 23-Feb-00 "
	range := aVector.! !
!DhbVectorChromosomeManager categoriesFor: #crossover:and:!operation!public! !
!DhbVectorChromosomeManager categoriesFor: #mutate:!operation!public! !
!DhbVectorChromosomeManager categoriesFor: #origin:!initialization!public! !
!DhbVectorChromosomeManager categoriesFor: #randomChromosome!creation!public! !
!DhbVectorChromosomeManager categoriesFor: #randomComponent:!information!public! !
!DhbVectorChromosomeManager categoriesFor: #range:!initialization!public! !

