"Filed out from Dolphin Smalltalk 7"!

Integer subclass: #SmallInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmallInteger guid: (GUID fromString: '{87b4c65f-026e-11d3-9fd7-00a0cc3e4a32}')!
SmallInteger comment: 'Class SmallInteger is an optimized representation of 31-bit 2''s complement integers.

Wherever an Integer may be represented as a SmallInteger, then its only truly valid representation is as a SmallInteger. (i.e their "normalized" representation is as a SmallInteger). The range is such that the majority of integers used for counting and indexing, and even arithmetical tasks, will be SmallIntegers.'!
!SmallInteger categoriesForClass!Magnitude-Numbers! !
!SmallInteger methodsFor!

- operand
	"Answer the result of subtracting the <number>, operand, from the receiver. The primitive
	fails iff the operand is not a SmallInteger, but does not set the primitive failure code."

	<primitive: 14>
	^operand subtractFromInteger: self!

& anInteger
	"Answer the result of a bitwise AND between the receiver and the argument, anInteger. N.B.
	Use of #bitAnd: is preferred (even though it is more typing) because it is a special
	selector (i.e. it is more compact and faster), and is portable. The primitive fails iff
	aNumber is not a SmallInteger, and does not set the failure code."

	<primitive: 40>
	^anInteger bitAnd: self!

* aNumber
	"Answer the result of multiplying the receiver by aNumber. 
	The primitive may fail for the following reasons, but does not set the failure code:
		- aNumber is not a SmallInteger.
		- the result requires more than 31-bits to represent. 

	When the primitive fails we use a double dispatch to ask aNumber to multiply the receiver, 
	which we know to be a kind of Integer, by itself."

	<primitive: 9>
	^aNumber multiplyByInteger: self!

/ operand
	"Answer the result of dividing the receiver by the <number>, operand.
	Attempted division by zero will cause a <ZeroDivide> exception to be
	raised.

	The primitive may fail for the following reasons, but does not set the failure code:
		 - aNumber is not a SmallInteger.
		 - the result cannot be represented exactly as an Integer."

	<primitive: 10>
	^operand divideIntoInteger: self!

// aNumber
	"Answer the integer quotient defined by division with truncation toward negative
	infinity.

	The primitive fails only if aNumber is not a SmallInteger, and does not set the failure code.
	Attempted division by zero will cause a ZeroDivide exception to be raised by the VM."

	<primitive: 12>
	^super // aNumber!

\\ aNumber
	"Answer the integer remainder defined by division with trunction toward negative infinity. This is 
	the modulo operation. N.B. This is not the same as the C/C++ modulus operator (%), which always
	truncates towards zero.

	The primitive fails only if aNumber is not a SmallInteger, and does not set the failure code.
	Attempted division by zero will cause a ZeroDivide exception to be raised by the VM."

	<primitive: 11>
	^super \\ aNumber!

_deepCopy: anIdentityDictionary
	^self!

| anInteger
	"Answer the result of a bitwise OR between the receiver and the argument, anInteger. N.B.
	Use of #bitOr: is preferred (even though it is more typing) because it is a special selector
	(i.e. it is more compact and faster), and is portable.The primitive fails iff the operand is
	not a SmallInteger, but does not set the primitive failure code."

	<primitive: 41>
	^anInteger bitOr: self!

+ aNumber
	"Add the argument, aNumber, to the receiver and answer the result. The primitive fails 
	iff the operand is not a SmallInteger, but does not set the primitive failure code."

	<primitive: 15>
	^aNumber addToInteger: self!

< aNumber
	"Answer whether the receiver is less than the argument, aNumber.The primitive fails iff
	aNumber is not a SmallInteger, and does not set the failure code."

	<primitive: 18>
	^aNumber greaterThanInteger: self!

<< anInteger
	"Answer the result of shifting the receiver left anInteger bits."

	<primitive: 43>
	^self bitShift: anInteger!

<= aNumber
	"Answer whether the receiver is numerically less than or equal to the argument aNumber.The
	primitive fails iff aNumber is not a SmallInteger, and does not set the failure code."

	<primitive: 20>
	^super <= aNumber!

= aNumber
	"Answer whether the receiver is equal to aNumber. Numbers are considered equal if their
	difference is zero. The primitive fails iff aNumber is not a SmallInteger, and does not set
	the failure code."

	<primitive: 16>
	^super = aNumber!

> aNumber
	"Answer whether the receiver is greater than the argument, aNumber. The primitive fails iff
	aNumber is not a SmallInteger, and does not set the failure code."

	<primitive: 19>
	^super > aNumber!

>= aNumber
	"Answer whether the receiver is greater than or equal to the argument, aNumber.The primitive
	fails iff aNumber is not a SmallInteger, and does not set the failure code."

	<primitive: 17>
	^super >= aNumber!

allMask: mask
	"Answer whether all of the bits that are set in the <integer> mask are also set in the
	receiver.The primitive fails iff the operand is not a SmallInteger, but does not set the
	primitive failure code."

	<primitive: 146>
	^super allMask: mask!

anyMask: mask
	"Answer whether any of the bits that are set in the <integer> mask are also set in the
	receiver.The primitive fails iff the operand is not a SmallInteger, but does not set the
	primitive failure code."

	<primitive: 145>
	^super anyMask: mask!

asFloat
	"Answer the floating point representation of the receiver. The primitive should not fail."

	<primitive: 168>
	^self primitiveFailed!

asStackPointer
	^self!

at: index put: value
	"Replace the receivers indexed instance variable at the argument, index, with the argument,
	value. Not valid for immediate, objects which are constants. Do not remove this method, as
	the primitive implementation in Object will behave unexpectedly for immediate objects."

	^self shouldNotImplement!

basicAt: index
	"Private - Answer the receivers indexed instance variable at the
	argument, index. Not valid for immediate objects,  which have no indexable
	variables as such.
	Do not remove this method, as the primitive implementation in Object
	will behave unexpectedly for immediate objects."

	^self shouldNotImplement!

basicAt: index put: value
	"Private - Replace the receivers indexed instance variable at the
	argument, index, with the argument, value. Not valid for immediate,
	objects which are constants.
	Do not remove this method, as the primitive implementation in Object
	will behave unexpectedly for immediate objects."

	^self shouldNotImplement!

basicIdentityHash
	"Answer the <integer> identity hash value for the receiver (itself)."

	"Implementation Note: We must override because the identity hash primitives do not work for
	immediate objects."

	^self!

basicShallowCopy
	"SmallIntegers have an immediate representation - i.e. they have only
	one representation for a particular value - and are immutable."

	^self
!

basicSize
	"Private - We must override the primitive implementation in Object,
	which does not expect to be invoked  for SmallInteger receivers"

	^0!

basicYourAddress
	"Private - Answer the address of the bytes of the receiver. 
	Assumes the receiver is an address."

	^self!

bitAnd: anInteger
	"Answer an Integer whose bits are the logical AND of the receiver's bits and those of the
	argument anInteger. The primitive fails iff the operand is not a SmallInteger, but does not
	set the primitive failure code."

	<primitive: 40>
	^anInteger bitAnd: self!

bitOr: anInteger
	"Answer an Integer whose bits are the logical OR of the receiver's bits
	and those of the argument anInteger. The primitive fails 
	iff the operand is not a SmallInteger, but does not set the primitive failure code."

	<primitive: 41>
	^anInteger bitOr: self!

bitShift: anInteger
	"Answer an Integer whose value (in two's-complement representation) is the receiver's value 
	(in 2's complement) shifted left by the number of bits indicated by the argument anInteger. 
	Negative arguments shift right in left shifts. The sign bit is extended in right shifts.
	A right shift of more than 30 bits will lose all significant bits, so the result will be 0
	for positive receivers, and -1 for negative receivers (sign extension).

	The primitive may fail for the following reasons, but does not set the failure code:
		 - anInteger is not a SmallInteger.
		 - the result overflowed the SmallInteger range."

	<primitive: 43>
	^(self becomeA: LargeInteger) bitShift: anInteger!

bitXor: mask
	"Answer an <integer> whose bits are the logical XOR of the receiver's
	bits and those of the argument, mask.The primitive fails 
	iff the operand is not a SmallInteger, but does not set the primitive failure code."

	<primitive: 42>
	^mask bitXor: self!

byteAt: index
	"Private - Answer the byte at index, index, of the absolute value of the
	receiver (i.e. magnitude  only representation).

	Primitive failure reasons:
		0 -	the argument, index, is not a SmallInteger
		1 -	the argument index is not in the range 1..4."

	<primitive: 158>
	^index > self byteSize
		ifTrue: [0]
		ifFalse: [self errorSubscriptBounds: index].

	"Equivalent to:
		^(self abs bitShift: 1 - index * 8) bitAnd: 16rFF"!

byteSize
	"Private - Answer the number of bytes in the receiver's 2's complement
	representation."

	^VMConstants.IntPtrSize!

coerce: anArithmeticValue
	"Private - Answer anArithmeticValue coerced to be a SmallInteger."

	^anArithmeticValue truncated
!

deepCopy
	"SmallIntegers have an immediate representation - i.e. they have only
	one representation for a particular value - and are immutable."

	^self
!

generality
	"Private - Answer the generality in the Smalltalk number system of the receiver.
	SmallIntegers are the lowest generality (10)"

	^10
!

hash
	"Answer the SmallInteger hash value for the receiver (itself)."

	^self!

highBit
	"Answer the index (1 based) of the high order bit of the positive 2's complement 
	representation of the receiver. e.g.

		SmallInteger maximum highBit

	Implementation Note: Although this can be implemented relatively efficiently
	in Smalltalk by using a series of conditional tests and a table lookup,
	it can be implemented in a single instruction in x86 assembler, hence the
	(very fast) primitive.

	The primitive fails only if the receiver is negative, so does not set the failure code."

	<primitive: 54>
	^self primitiveFailed!

identityHash
	"Answer the <integer> identity hash value for the receiver (itself)."

	"Implementation Note: We must override because the identity hash primitives do not work for
	immediate objects."

	^self!

instVarAt: index
	"Private - Answer the receivers instance variable at the argument, index. 
	Not valid for SmallIntegers,  which have no instance variables in the true sense.
	Do not remove this method, as the primitive implementation in Object
	will behave unexpectedly for SmallIntegers."

	^self shouldNotImplement!

instVarAt: index put: value
	"Private - Replace the receivers instance variable at the argument, index, 
	with the argument, value. Not valid for SmallIntegers, which are constants.
	Do not remove this method, as the primitive implementation in Object
	will behave unexpectedly for SmallIntegers."

	^self shouldNotImplement!

isAtomic
	"Answer whether or not the receiver it the single unique instance of its class that
	represents its value."

	"SmallIntegers are encoded in object references, so are effectively atomic."

	^true!

isImmediate
	"Answer whether the receiver has an immediate representation."

	^true
!

isZero
	"Answer whether the receiver is zero. SmallIntegers can be zero, and there is a
	very fast check."

	^self == 0!

lowBit
	"Answer the index of the lowest bit of the receiver which is set.
	Unlike #highBit, this is meaningful for negative numbers too.
	Implementation Note: The primitive makes use of the Intel
	BSF instruction."

	| i t |
	<primitive: 152>
	self == 0 ifTrue: [^self].
	t := self.
	i := 1.
	[(t bitAnd: 16rF) == 0] whileTrue: [
		i := i + 4.
		t := t bitShift: -4].
	[(t bitAnd: 1) == 0] whileTrue: [
		i := i + 1.
		t := t bitShift: -1].
	^i!

multiplyByInteger: anInteger 
	"Private - Answer the result of multiplying the receiver by the argument, anInteger.

	Implementation Note: Invoked when SmallInteger multiplied by another SmallInteger but the
	result overflows the SmallInteger range (a fairly common occurrence). The superclass
	implementation does not work because it goes through the generic coercion mechanism, which
	does not expect to be invoked for two numbers of the same generality."

	^(LargeInteger fromSmallInteger: self) * anInteger!

printString
	"Answer the <readableString> representation of the receiver in base 10."

	"Implementation Note: Although this method is strictly not necessary
	(SmallInteger>>printOn:base:showRadix: makes it redundant), printing SmallIntegers is such a
	common operation that it is worth providing an optimised version generating a String."

	| value aString i |
	<primitive: 44>
	(value := self) < 0 ifTrue: [^'-' , self negated printString].
	i := ##(VMConstants.SmallIntegerMax log truncated + 1).
	aString := Utf8String new: i.
	[value < 10] whileFalse: 
			[aString at: i put: (Character digitValue: value \\ 10).
			i := i - 1.
			value := value // 10].
	aString at: i put: (Character digitValue: value \\ 10).
	^aString copyFrom: i to: aString size!

quo: aNumber
	"Answer the integer quotient defined by division with truncation toward zero.

	The primitive fails only if aNumber is not a SmallInteger, and does not set the failure code.
	Attempted division by zero will cause a ZeroDivide exception to be raised by the VM."

	<primitive: 53>
	^(aNumber quoAndRemFromInteger: self) basicAt: 1
!

quoAndRem: aNumber
	"Answer a 2-element array containing the integer quotient and remainder
	resulting from division of the receiver by the argument with truncation 
	toward zero.

	The primitive fails only if aNumber is not a SmallInteger, and does not set the failure code.
	Attempted division by zero will cause a ZeroDivide exception to be raised by the VM."

	<primitive: 13>
	^aNumber quoAndRemFromInteger: self!

refersToLiteral: anObject 
	"Private - Answer whether the receiver is a reference to the literal argument.
	This assumes that the receiver is in the role of a literal."

	^self == anObject!

shallowCopy
	"SmallIntegers have an immediate representation - i.e. they have only
	one representation for a particular value - and are immutable."

	^self
!

species
	"Answer the 'species' of the receiver.
	Implementation Note: The primitive superclass implementation
	will fail for immediate classes, so we must override here."

	^SmallInteger!

yourAddress
	"Answer the address of the bytes of the receiver. 
	Assume that the integer is being used as an address, so answer self."

	^self! !
!SmallInteger categoriesFor: #-!arithmetic!public! !
!SmallInteger categoriesFor: #&!bit manipulation!public! !
!SmallInteger categoriesFor: #*!arithmetic!public! !
!SmallInteger categoriesFor: #/!arithmetic!public! !
!SmallInteger categoriesFor: #//!arithmetic!public! !
!SmallInteger categoriesFor: #\\!arithmetic!public! !
!SmallInteger categoriesFor: #_deepCopy:!copying!private! !
!SmallInteger categoriesFor: #|!bit manipulation!public! !
!SmallInteger categoriesFor: #+!arithmetic!public! !
!SmallInteger categoriesFor: #<!comparing!public! !
!SmallInteger categoriesFor: #<<!bit manipulation!public! !
!SmallInteger categoriesFor: #<=!comparing!public! !
!SmallInteger categoriesFor: #=!comparing!public! !
!SmallInteger categoriesFor: #>!comparing!public! !
!SmallInteger categoriesFor: #>=!comparing!public! !
!SmallInteger categoriesFor: #allMask:!bit manipulation!public! !
!SmallInteger categoriesFor: #anyMask:!bit manipulation!public! !
!SmallInteger categoriesFor: #asFloat!converting!public! !
!SmallInteger categoriesFor: #asStackPointer!converting!private! !
!SmallInteger categoriesFor: #at:put:!accessing!public! !
!SmallInteger categoriesFor: #basicAt:!accessing!private! !
!SmallInteger categoriesFor: #basicAt:put:!accessing!private! !
!SmallInteger categoriesFor: #basicIdentityHash!comparing!public! !
!SmallInteger categoriesFor: #basicShallowCopy!copying!public! !
!SmallInteger categoriesFor: #basicSize!accessing!private! !
!SmallInteger categoriesFor: #basicYourAddress!accessing!private! !
!SmallInteger categoriesFor: #bitAnd:!bit manipulation!public! !
!SmallInteger categoriesFor: #bitOr:!bit manipulation!public! !
!SmallInteger categoriesFor: #bitShift:!bit manipulation!public! !
!SmallInteger categoriesFor: #bitXor:!bit manipulation!public! !
!SmallInteger categoriesFor: #byteAt:!accessing!private! !
!SmallInteger categoriesFor: #byteSize!accessing!private! !
!SmallInteger categoriesFor: #coerce:!coercing!private! !
!SmallInteger categoriesFor: #deepCopy!copying!public! !
!SmallInteger categoriesFor: #generality!coercing!private! !
!SmallInteger categoriesFor: #hash!comparing!public! !
!SmallInteger categoriesFor: #highBit!bit manipulation!public! !
!SmallInteger categoriesFor: #identityHash!comparing!public! !
!SmallInteger categoriesFor: #instVarAt:!accessing!private! !
!SmallInteger categoriesFor: #instVarAt:put:!accessing!private! !
!SmallInteger categoriesFor: #isAtomic!public!testing! !
!SmallInteger categoriesFor: #isImmediate!public!testing! !
!SmallInteger categoriesFor: #isZero!public!testing! !
!SmallInteger categoriesFor: #lowBit!bit manipulation!public! !
!SmallInteger categoriesFor: #multiplyByInteger:!double dispatch!private! !
!SmallInteger categoriesFor: #printString!printing!public! !
!SmallInteger categoriesFor: #quo:!arithmetic!public! !
!SmallInteger categoriesFor: #quoAndRem:!arithmetic!public! !
!SmallInteger categoriesFor: #refersToLiteral:!private!testing! !
!SmallInteger categoriesFor: #shallowCopy!copying!public! !
!SmallInteger categoriesFor: #species!accessing!public! !
!SmallInteger categoriesFor: #yourAddress!accessing!public! !

!SmallInteger class methodsFor!

basicNew
	"SmallIntegers are immediate objects, and cannot be instantiated directly, they
	can only be created by literal references or by operations on other SmallIntegers."

	^self shouldNotImplement!

hasImmediateInstances
	"Answer whether the receiver's instances are immutable objects encoded entirely 
	in an Oop (e.g. SmallIntegers)."

	^true!

maxBytes
	"Answer the largest number of radix-256 digits which can be represented
	in a SmallInteger (31-bits, so not all 4 byte numbers will fit)."

	^VMConstants.IntPtrSize!

maximum
	"Answer the largest positive integer value which can be
	represented as a SmallInteger."

	^VMConstants.SmallIntegerMax!

minimum
	"Answer the largest negative integer value which can be 
	represented as a SmallInteger"

	^VMConstants.SmallIntegerMin! !
!SmallInteger class categoriesFor: #basicNew!instance creation!public! !
!SmallInteger class categoriesFor: #hasImmediateInstances!public!testing! !
!SmallInteger class categoriesFor: #maxBytes!constants!public! !
!SmallInteger class categoriesFor: #maximum!constants!public! !
!SmallInteger class categoriesFor: #minimum!constants!public! !

