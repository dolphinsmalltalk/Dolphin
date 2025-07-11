﻿"Filed out from Dolphin Smalltalk"!

Core.Random
	subclass: #'Kernel.RandomLinearCongruential'
	instanceVariableNames: 'multiplier increment modulus'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AnsiCIncrement' -> 16r3039.
			'AnsiCModulus' -> 16r80000000.
			'AnsiCMultiplier' -> 16r41C64E6D
		}!

Kernel.RandomLinearCongruential guid: (Core.GUID fromString: '{23d4b049-ae11-4fd4-872a-7fa0b04b2e6b}')!

Kernel.RandomLinearCongruential comment: '<RandomLinearCongruential> is a specialized <Random> stream that provides generic implementation of the Linear Congruential class of pseudo-random number generators. 

LCG generators are of the form:
	X[k] = ((a * X[k-1]) + c) mod m
The values of a, c, and m are the multiplier, increment and modulus constants respectively. These values are configurable in instances of RandomLinearCongruential, but they must be chosen very carefully to give good results. The instance creation method #newParkMiller answers an instance configured as Park & Miller''s "minimum standard" generator, which is a reasonable choice as a default random number generator, but it is inadequate for crypographic applications. Other suitable values for a, c, and m can easily be found on the net, including those with much larger periods.'!

!Kernel.RandomLinearCongruential categoriesForClass!Collections-Streams! !

!Kernel.RandomLinearCongruential methodsFor!

increment
	^increment!

increment: anInteger
	increment := anInteger!

lcg
	^seed * multiplier + increment rem: modulus!

modulus
	^modulus!

modulus: anInteger
	modulus := anInteger!

multiplier
	^multiplier!

multiplier: anInteger
	multiplier := anInteger!

next
	"Answer the next <Float> between 0 and 1 in the pseudo-random number stream."

	seed := self lcg.
	^seed / modulus asFloat!

peek
	"Answer the next <Float> between 0 and 1 in the pseudo-random number stream,
	but do not advance over it."

	^self lcg / modulus asFloat!

setModulus: modInteger multiplier: mulInteger increment: incInteger 
	modulus := modInteger.
	multiplier := mulInteger.
	increment := incInteger.
	seed := 1! !

!Kernel.RandomLinearCongruential categoriesForMethods!
increment!accessing!public! !
increment:!initializing!private! !
lcg!helpers!private! !
modulus!accessing!public! !
modulus:!initializing!private! !
multiplier!accessing!public! !
multiplier:!initializing!private! !
next!public!reading! !
peek!public!reading! !
setModulus:multiplier:increment:!initializing!private! !
!

!Kernel.RandomLinearCongruential class methodsFor!

newANSIC
	"Answer a new <RandomLinearCongruential> configured as the ANSI C rand() generator."

	^self 
		newModulus: AnsiCModulus
		multiplier: AnsiCMultiplier
		increment: AnsiCIncrement!

newModulus: mInteger multiplier: aInteger increment: cInteger 
	"Answer a new <RandomLinearCongruential> generator, configured with the specified a, c, and m
	constants."

	^(self basicNew)
		setModulus: mInteger
			multiplier: aInteger
			increment: cInteger;
		yourself!

newParkMiller
	"Answer a new <RandomLinearCongruential> configured as Park and Miller's 'Minimum Standard' 
	congruential generator (see 'Numerical Recipes in C', 2nd Edition; Press, Flannery, Teukolsky and 
	Vetterling; Cambridge University Press, 1992). "

	^self 
		newModulus: 16r7FFFFFFF
		multiplier: ##(7 raisedToInteger: 5)
		increment: 0!

newParkMiller2
	"Answer a new <RandomLinearCongruential> configured as Park and Miller's 'Minimum Standard' 
	congruential generator, but with an alternate multiplier."

	^self 
		newModulus: 16r7FFFFFFF
		multiplier: 48271
		increment: 0! !

!Kernel.RandomLinearCongruential class categoriesForMethods!
newANSIC!instance creation!public! !
newModulus:multiplier:increment:!instance creation!public! !
newParkMiller!instance creation!public! !
newParkMiller2!instance creation!public! !
!

