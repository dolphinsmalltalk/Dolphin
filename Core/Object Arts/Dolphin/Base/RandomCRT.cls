"Filed out from Dolphin Smalltalk X6"!

Random subclass: #RandomCRT
	instanceVariableNames: 'next'
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
RandomCRT guid: (GUID fromString: '{F895D18E-E50F-4651-8A7D-9D04137DD05E}')!
RandomCRT comment: ''!
!RandomCRT categoriesForClass!Collections-Streams! !
!RandomCRT methodsFor!

next
	"Answer a pseudo-Random floating point number between 0 and 1.
	Uses the C run-time library rand() function.
	N.B. It is not recommended you use this generator, it is very poor. The range
	of numbers generated is only 15 bits. The only plus  point is speed."

	^next isNil 
		ifTrue: 
			[seed := CRTLibrary default rand.
			seed / ##(RAND_MAX + 1 asFloat)]
		ifFalse: 
			[| answer |
			answer := next.
			next := nil.
			answer]!

peek
	"Answer a pseudo-Random floating point number between 0 and 1 generated
	from the next seed, but do not advance down the stream (i.e. self peek = self peek)."

	"Implementation Note: We use the next inst. var to as a buffer for the next value."

	^next ifNil: [next := CRTLibrary default rand / ##(RAND_MAX + 1 asFloat)]!

seed: anInteger 
	"Set the seed of the Random stream to anInteger (or 1 if zero)."

	CRTLibrary default srand: anInteger.
	super seed: anInteger! !
!RandomCRT categoriesFor: #next!accessing!public! !
!RandomCRT categoriesFor: #peek!accessing!public! !
!RandomCRT categoriesFor: #seed:!accessing!public! !

