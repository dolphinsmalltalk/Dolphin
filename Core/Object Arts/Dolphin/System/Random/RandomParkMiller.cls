"Filed out from Dolphin Smalltalk"!

RandomLinearCongruential subclass: #RandomParkMiller
	instanceVariableNames: 'quo rem'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RandomParkMiller guid: (GUID fromString: '{a3ea36ec-2371-4039-bc76-4dc1fe8e69c6}')!
RandomParkMiller comment: '<RandomParkMiller> is a specialized <RandomLinearCongruential> stream that provides an optimised implementation of Park and Miller''s ''Minimum Standard''  linear congruential pseudo-random number generator (see ''Numerical Recipes in C'', 2nd Edition; Press, Flannery, Teukolsky and Vetterling; Cambridge University Press, 1992).

RandomParkMiller differs from a generic RandomLinearCongruential generator initialised with the same constants in that it is implemented using floating point arithmetic. This makes it about twice as fast as the RandomLinearCongruential equivalent, because the latter uses large-integer arithmetic when initialised with the Park-Miller constants.'!
!RandomParkMiller categoriesForClass!Collections-Streams! !
!RandomParkMiller methodsFor!

lcg
	| remainder quotient answer |
	quotient := (seed quo: quo) asFloat.
	remainder := seed - (quotient * quo).
	answer := multiplier * remainder - (rem * quotient).
	^answer > 0.0 ifTrue: [answer] ifFalse: [answer + modulus]!

seed: anInteger
	"Set the seed of the Random stream to anInteger (or 1 if zero)."

	seed := anInteger asFloat max: 1.0!

setModulus: modInteger multiplier: mulInteger increment: incInteger 
	self assert: [incInteger = 0].
	modulus := modInteger asFloat.
	multiplier := mulInteger asFloat.
	increment := 0.
	seed := 1.0.
	quo := (modulus quo: multiplier) asFloat.
	rem := (modulus \\ multiplier) asFloat! !
!RandomParkMiller categoriesForMethods!
lcg!helpers!private! !
seed:!accessing!public! !
setModulus:multiplier:increment:!initializing!private! !
!

!RandomParkMiller class methodsFor!

new
	^super 
		newModulus: 16r7FFFFFFF
		multiplier: ##(7 raisedToInteger: 5)
		increment: 0!

newModulus: mInteger multiplier: aInteger increment: cInteger 
	"This generator only supports a fixed set of constants."

	^self shouldNotImplement! !
!RandomParkMiller class categoriesForMethods!
new!instance creation!public! !
newModulus:multiplier:increment:!instance creation!public! !
!

