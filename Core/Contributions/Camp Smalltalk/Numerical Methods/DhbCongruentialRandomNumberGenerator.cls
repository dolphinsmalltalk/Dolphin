"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbCongruentialRandomNumberGenerator
	instanceVariableNames: 'constant modulus multiplicator seed'
	classVariableNames: 'UniqueInstance'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbCongruentialRandomNumberGenerator guid: (GUID fromString: '{E550029E-7D2B-11D6-B6CC-00022D5019C8}')!
DhbCongruentialRandomNumberGenerator comment: ''!
!DhbCongruentialRandomNumberGenerator categoriesForClass!DHB Numerical! !
!DhbCongruentialRandomNumberGenerator methodsFor!

floatValue
		"Answer the next pseudo-random value between 0 and 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^self value asFloat / modulus!

initialize
		"Private - Initializes the constants of the receiver with D. Knuth's constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	self initialize: 2718281829.0 multiplicator: 3141592653.0 modulus: 4294967296.0.!

initialize: aNumber1 multiplicator: aNumber2 modulus: aNumber3
		"Private - Initializes the constants needed by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	constant := aNumber1.
	modulus := aNumber2.
	multiplicator := aNumber3.
	self setSeed: 1.!

integerValue: anInteger
		"Answer a random integer between 0 and the anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( self value  \\ ( anInteger * 1000)) // 1000!

setSeed: aNumber
		"Set the seed of the receiver to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	seed := aNumber.!

value
		"Answer the next pseudo-random value.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	seed := ( seed * multiplicator + constant) \\ modulus.
	^seed! !
!DhbCongruentialRandomNumberGenerator categoriesFor: #floatValue!information!public! !
!DhbCongruentialRandomNumberGenerator categoriesFor: #initialize!initialization!public! !
!DhbCongruentialRandomNumberGenerator categoriesFor: #initialize:multiplicator:modulus:!initialization!public! !
!DhbCongruentialRandomNumberGenerator categoriesFor: #integerValue:!information!public! !
!DhbCongruentialRandomNumberGenerator categoriesFor: #setSeed:!public!transformation! !
!DhbCongruentialRandomNumberGenerator categoriesFor: #value!information!public! !

!DhbCongruentialRandomNumberGenerator class methodsFor!

constant: aNumber1 multiplicator: aNumber2 modulus: aNumber3 
	"Create a new instance of the receiver with given constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "

	^super new 
		initialize: aNumber1
		multiplicator: aNumber2
		modulus: aNumber3!

new
		"Create a new instance of the receiver with D. Knuth's constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	UniqueInstance isNil
		ifTrue: [ UniqueInstance := super new initialize.
					 UniqueInstance setSeed: 1.
				   ].
	^UniqueInstance!

seed: aNumber
		"Create a new instance of the receiver with given seed
		  using D. Knuth's constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^( super new) initialize; setSeed: aNumber; yourself! !
!DhbCongruentialRandomNumberGenerator class categoriesFor: #constant:multiplicator:modulus:!creation!public! !
!DhbCongruentialRandomNumberGenerator class categoriesFor: #new!creation!public! !
!DhbCongruentialRandomNumberGenerator class categoriesFor: #seed:!creation!public! !

