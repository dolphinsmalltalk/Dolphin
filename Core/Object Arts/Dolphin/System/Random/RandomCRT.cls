"Filed out from Dolphin Smalltalk"!

Random subclass: #RandomCRT
	instanceVariableNames: 'next'
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
RandomCRT guid: (GUID fromString: '{f895d18e-e50f-4651-8a7d-9d04137dd05e}')!
RandomCRT comment: ''!
!RandomCRT categoriesForClass!Collections-Streams! !
!RandomCRT methodsFor!

next
	"Answer a pseudo-Random floating point number between 0 and 1.
	Uses the C run-time library rand() function.
	N.B. It is not recommended you use this generator, it is very poor. The range
	of numbers generated is only 15 bits. The only plus  point is speed."

	^next isNil
		ifTrue: [(seed := CRTLibrary default rand asFloat) / ##(RAND_MAX + 1 asFloat)]
		ifFalse: 
			[| answer |
			answer := next.
			next := nil.
			answer]!

peek
	"Answer a pseudo-Random floating point number between 0 and 1 generated
	from the next seed, but do not advance down the stream (i.e. self peek = self peek)."

	"Implementation Note: We use the next inst. var as a buffer for the next value."

	^next ifNil: [next := CRTLibrary default rand / ##(RAND_MAX + 1 asFloat)]!

seed: anInteger 
	"Set the seed of the Random stream to anInteger (or 1 if zero)."

	CRTLibrary default srand: anInteger.
	super seed: anInteger! !
!RandomCRT categoriesForMethods!
next!accessing!public! !
peek!accessing!public! !
seed:!accessing!public! !
!

