"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbFloatingPointMachine
	instanceVariableNames: 'defaultNumericalPrecision radix machinePrecision negativeMachinePrecision smallestNumber largestNumber smallNumber largestExponentArgument'
	classVariableNames: 'UniqueInstance'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbFloatingPointMachine guid: (GUID fromString: '{E55002B0-7D2B-11D6-B6CC-00022D5019C8}')!
DhbFloatingPointMachine comment: ''!
!DhbFloatingPointMachine categoriesForClass!DHB Numerical! !
!DhbFloatingPointMachine methodsFor!

computeLargestNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/6/99 "
	| one floatingRadix fullMantissaNumber |

	one := 1.0.
	floatingRadix := self radix asFloat.
	fullMantissaNumber := one - ( floatingRadix * self negativeMachinePrecision).
	largestNumber := fullMantissaNumber.
	[ [ fullMantissaNumber := fullMantissaNumber * floatingRadix.
	    largestNumber := fullMantissaNumber.
		true] whileTrue: [ ].
		] on: Error do: [ :signal | signal return: nil].!

computeMachinePrecision
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	| one zero inverseRadix tmp |
	one := 1.0.
	zero := 0.0.
	inverseRadix := one / self radix asFloat.
	machinePrecision := one.
	[ tmp := one + machinePrecision.
	  tmp - one = zero]
		whileFalse:[  machinePrecision := machinePrecision * inverseRadix].!

computeNegativeMachinePrecision
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	| one zero floatingRadix inverseRadix tmp |
	one := 1.0.
	zero := 0.0.
	floatingRadix := self radix asFloat.
	inverseRadix := one / floatingRadix.
	negativeMachinePrecision := one.
	[ tmp := one - negativeMachinePrecision.
	  tmp - one = zero]
		whileFalse:[ negativeMachinePrecision := negativeMachinePrecision * inverseRadix].!

computeRadix
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	| one zero a b tmp1 tmp2|
	one := 1.0.
	zero := 0.0.
	a := one.
	[ a := a + a.
	  tmp1 := a + one.
	  tmp2 := tmp1 - a.
	  tmp2 - one = zero] whileTrue:[].
	b := one.
	[ b := b + b.
	  tmp1 := a + b.
	  radix := ( tmp1 - a) truncated.
	  radix = 0 ] whileTrue: [].!

computeSmallestNumber
	"Private - 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 11/6/99"

	| one floatingRadix inverseRadix fullMantissaNumber |
	one := 1 asFloat.
	floatingRadix := self radix asFloat.
	inverseRadix := one / floatingRadix.
	fullMantissaNumber := one - (floatingRadix * self negativeMachinePrecision).
	smallestNumber := fullMantissaNumber.
	[[fullMantissaNumber := fullMantissaNumber * inverseRadix.
	fullMantissaNumber = 0.0 ifTrue: [Error raise].
	smallestNumber := fullMantissaNumber.
	true]
		whileTrue: []]
		on: Error do: [:signal | signal return: nil]!

defaultNumericalPrecision
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	defaultNumericalPrecision isNil
		ifTrue: [ defaultNumericalPrecision := self machinePrecision sqrt].
	^defaultNumericalPrecision!

largestExponentArgument
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/18/00 "
	largestExponentArgument isNil
		ifTrue: [ largestExponentArgument := self largestNumber ln].
	^largestExponentArgument!

largestNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/5/99 "
	largestNumber isNil
		ifTrue: [ self computeLargestNumber].
	^largestNumber!

machinePrecision
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	machinePrecision isNil
		ifTrue: [ self computeMachinePrecision].
	^machinePrecision!

negativeMachinePrecision
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 22/4/99 "
	negativeMachinePrecision isNil
		ifTrue: [ self computeNegativeMachinePrecision].
	^negativeMachinePrecision!

radix
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	radix isNil
		ifTrue: [ self computeRadix].
	^radix!

showParameters
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/6/99 "
	Transcript cr; cr;
			nextPutAll: 'Floating-point machine parameters'; cr;
			nextPutAll: '---------------------------------';cr;
			nextPutAll: 'Radix: '.
	self radix printOn: Transcript.
	Transcript cr; nextPutAll: 'Machine precision: '.
	self machinePrecision printOn: Transcript.
	Transcript cr; nextPutAll: 'Negative machine precision: '.
	self negativeMachinePrecision printOn: Transcript.
	Transcript cr; nextPutAll: 'Smallest number: '.
	self smallestNumber printOn: Transcript.
	Transcript cr; nextPutAll: 'Largest number: '.
	self largestNumber printOn: Transcript.!

smallestNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/5/99 "
	smallestNumber isNil
		ifTrue: [ self computeSmallestNumber].
	^smallestNumber!

smallNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/5/99 "
	smallNumber isNil
		ifTrue: [ smallNumber := self smallestNumber sqrt].
	^smallNumber! !
!DhbFloatingPointMachine categoriesFor: #computeLargestNumber!information!public! !
!DhbFloatingPointMachine categoriesFor: #computeMachinePrecision!information!public! !
!DhbFloatingPointMachine categoriesFor: #computeNegativeMachinePrecision!information!public! !
!DhbFloatingPointMachine categoriesFor: #computeRadix!information!public! !
!DhbFloatingPointMachine categoriesFor: #computeSmallestNumber!information!public! !
!DhbFloatingPointMachine categoriesFor: #defaultNumericalPrecision!information!public! !
!DhbFloatingPointMachine categoriesFor: #largestExponentArgument!information!public! !
!DhbFloatingPointMachine categoriesFor: #largestNumber!information!public! !
!DhbFloatingPointMachine categoriesFor: #machinePrecision!information!public! !
!DhbFloatingPointMachine categoriesFor: #negativeMachinePrecision!information!public! !
!DhbFloatingPointMachine categoriesFor: #radix!information!public! !
!DhbFloatingPointMachine categoriesFor: #showParameters!display!public! !
!DhbFloatingPointMachine categoriesFor: #smallestNumber!information!public! !
!DhbFloatingPointMachine categoriesFor: #smallNumber!information!public! !

!DhbFloatingPointMachine class methodsFor!

new
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	UniqueInstance = nil
		ifTrue: [ UniqueInstance := super new].
	^UniqueInstance!

reset
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/4/99 "
	UniqueInstance := nil.! !
!DhbFloatingPointMachine class categoriesFor: #new!creation!public! !
!DhbFloatingPointMachine class categoriesFor: #reset!creation!public! !

