"Filed out from Dolphin Smalltalk"!

Core.Integer
	subclass: #'Core.SmallInteger'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.SmallInteger guid: (Core.GUID fromString: '{87b4c65f-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.SmallInteger comment: 'Class SmallInteger is an optimized representation of 31-bit 2''s complement integers.

Wherever an Integer may be represented as a SmallInteger, then its only truly valid representation is as a SmallInteger. (i.e their "normalized" representation is as a SmallInteger). The range is such that the majority of integers used for counting and indexing, and even arithmetical tasks, will be SmallIntegers.'!

!Core.SmallInteger categoriesForClass!Magnitude-Numbers! !

!Core.SmallInteger methodsFor!

- anArithmeticValue
	"Answer the result of subtracting the <ArithmeticValue> argument from the receiver. The primitive fails iff the operand is not a SmallInteger."

	<primitive: 14>
	^anArithmeticValue subtractFromInteger: self!

& anInteger
	"Answer the result of a bitwise AND between the receiver and the argument, anInteger. N.B.	Use of #bitAnd: is preferred (even though it is more typing) because it is a special selector (i.e. it is more compact and faster), and is portable. The primitive fails iff aNumber is not a SmallInteger."

	<primitive: 40>
	^anInteger bitAnd: self!

* aNumber
	"Answer the result of multiplying the receiver by aNumber."

	"The primitive will fail if the argument is not a SmallInteger, LargeInteger, or Float, in which case we use a double dispatch to ask that argument to multiply itself the receiver, which we know to be a kind of Integer."

	<primitive: 9>
	^aNumber multiplyByInteger: self!

/ operand
	"Answer the result of dividing the receiver by the <number>, operand."
	
	"The primitive may fail for the following reasons:
		InvalidParameter1	- the operand is not a SmallInteger, LargeInteger or Float.
		FloatDivideByZero	- the operand is a Float of value zero
		Unsuccessful		- the operand is an Integer but does not divide exactly into the receiver.
	Attempted division by (integer) zero will cause a non-resumable <ZeroDivide> exception to be raised by the VM."

	<primitive: 10>
	^operand divideIntoInteger: self!

// aNumber
	"Answer the integer quotient defined by division with truncation toward negative	infinity."

	"The primitive fails with failure code InvalidParameter1 if the argument is not a SmallInteger.
	Attempted division by zero will cause a ZeroDivide exception to be raised by the VM."

	<primitive: 12>
	^super // aNumber!

\\ aNumber
	"Answer the integer remainder defined by division with trunction toward negative infinity. This is the modulo operation. 
	N.B. This is not the same as the C/C++ modulus operator (%), which always truncates towards zero."

	"The primitive fails with failure code InvalidParameter1 if the argument is not a SmallInteger.
	Attempted division by zero will cause a ZeroDivide exception to be raised by the VM."

	<primitive: 11>
	^super \\ aNumber!

_deepCopy: anIdentityDictionary
	^self!

| anInteger
	"Answer the result of a bitwise OR between the receiver and the argument, anInteger. N.B. Use of #bitOr: is preferred (even though it is more typing) because it is a special selector (i.e. it is more compact and faster), and is portable."

	"The primitive fails iff the operand is not a SmallInteger."

	<primitive: 41>
	^anInteger bitOr: self!

+ aNumber
	"Add the argument, aNumber, to the receiver and answer the result."

	"The primitive fails if the operand is not a SmallInteger, LargeInteger or Float."

	<primitive: 15>
	^aNumber addToInteger: self!

< aNumber
	"Answer whether the receiver is less than the argument, aNumber."

	"The primitive fails if aNumber is not an Integer."

	<primitive: 18>
	^aNumber greaterThanInteger: self!

<< anInteger
	"Answer the result of shifting the receiver left anInteger bits."

	<primitive: 43>
	^self bitShift: anInteger!

<= aNumber
	"Answer whether the receiver is numerically less than or equal to the argument aNumber."

	"The primitive fails if aNumber is not an Integer."

	<primitive: 20>
	^aNumber greaterOrEqualToInteger: self!

= aNumber
	"Answer whether the receiver is equal to aNumber. Numbers are considered equal if their difference is zero."

	"The primitive fails if aNumber is not an Integer."

	<primitive: 16>
	^super = aNumber!

> aNumber
	"Answer whether the receiver is greater than the argument, aNumber."

	"The primitive fails if aNumber is not an Integer."

	<primitive: 19>
	^super > aNumber!

>= aNumber
	"Answer whether the receiver is greater than or equal to the argument, aNumber."

	"The primitive fails if aNumber is not an Integer."

	<primitive: 17>
	^super >= aNumber!

allMask: mask
	"Answer whether all of the bits that are set in the <integer> mask are also set in the receiver."

	"The primitive fails iff the operand is not a SmallInteger."

	<primitive: 146>
	^super allMask: mask!

anyMask: mask
	"Answer whether any of the bits that are set in the <integer> mask are also set in the receiver."

	"The primitive fails iff the operand is not a SmallInteger."

	<primitive: 145>
	^super anyMask: mask!

asExternalAddress
	"Answer the receiver as an ExternalAddress."

	^self becomeA: External.Address!

asFloat
	"Answer the floating point representation of the receiver. The primitive should not fail."

	<primitive: 168>
	^self primitiveFailed: _failureCode!

asStackPointer
	^self!

basicAt: index
	"Private - Answer the receiver's indexed instance variable at the
	argument, index. Not valid for immediate objects,  which have no indexable
	variables as such.
	Do not remove this method, as the primitive implementation in Object
	will behave unexpectedly for immediate objects."

	^self shouldNotImplement!

basicAt: index put: value
	"Private - Replace the receiver's indexed instance variable at the
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
	"Answer an Integer whose bits are the logical AND of the receiver's bits and those of the argument anInteger."

	"The primitive fails iff the operand is not a SmallInteger."

	<primitive: 40>
	^anInteger bitAnd: self!

bitOr: anInteger
	"Answer an Integer whose bits are the logical OR of the receiver's bits and those of the argument anInteger."

	"The primitive fails iff the operand is not a SmallInteger."

	<primitive: 41>
	^anInteger bitOr: self!

bitShift: anInteger
	"Answer an Integer whose value (in two's-complement representation) is the receiver's value (in 2's complement) shifted left by the number of bits indicated by the argument anInteger. 
	Negative arguments shift right in left shifts. The sign bit is extended in right shifts.
	A right shift of more than 30 bits will lose all significant bits, so the result will be 0 for positive receivers, and -1 for negative receivers (sign extension)."

	"Primitive failure codes:
		 InvalidParameter1	- anInteger is not a SmallInteger.
		 IntegerOverflow		- the result overflowed the SmallInteger range."

	<primitive: 43>
	^(self becomeA: LargeInteger) bitShift: anInteger!

bitXor: mask
	"Answer an <integer> whose bits are the logical XOR of the receiver's bits and those of the argument, mask."

	"The primitive fails iff the operand is not a SmallInteger."

	<primitive: 42>
	^mask bitXor: self!

byteAt: index
	"Private - Answer the byte at index, index, of the absolute value of the
	receiver (i.e. magnitude  only representation).

	Primitive failure reasons:
		InvalidParameter1	- the argument, index, is not a SmallInteger
		OutOfBounds		- the argument index is not in the range 1..4."

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
	"Private - Coerce the <arithmeticValue> argument (which is assumed to be of a lower generality than the receiver) to an <integer>."

	^anArithmeticValue truncated!

decimalDigitLength
	"Private - Answer the number of digits (only) necessary to print this number in base 10."

	"N.B. The receiver is assumed to be positive."

	self < 10000
		ifTrue: 
			[^self < 100
				ifTrue: [self < 10 ifTrue: [1] ifFalse: [2]]
				ifFalse: [self < 1000 ifTrue: [3] ifFalse: [4]]].
	self < 100000000
		ifTrue: 
			[^self < 1000000
				ifTrue: [self < 100000 ifTrue: [5] ifFalse: [6]]
				ifFalse: [self < 10000000 ifTrue: [7] ifFalse: [8]]].
	self < 1000000000
		ifTrue: [^9]
		ifFalse: 
			["Special case while still 32-bit"
			VMConstants.IsWin64 ifFalse: [^10]].
	"Allow for future 64-bit SmallIntegers. Can't get here at present"
	self < 10000000000000
		ifTrue: 
			[^self < 100000000000
				ifTrue: [self < 10000000000 ifTrue: [10] ifFalse: [11]]
				ifFalse: [self < 1000000000000 ifTrue: [12] ifFalse: [13]]].
	self < 100000000000000000
		ifTrue: 
			[^self < 1000000000000000
				ifTrue: [self < 100000000000000 ifTrue: [14] ifFalse: [15]]
				ifFalse: [self < 10000000000000000 ifTrue: [16] ifFalse: [17]]].
	^self < 1000000000000000000 ifTrue: [18] ifFalse: [19]!

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
	"Answer the positive <SmallInteger> hash value for the receiver."

	<primitive: 109>
	^self hashMultiply!

highBit
	"Answer the <integer> index of the most significant non-zero bit of the binary representation of the receiver.
	N.B. This operation is not defined for negative integers."

	<primitive: 54>
	^super highBit!

identityHash
	"Answer the <integer> identity hash value for the receiver (itself)."

	<primitive: 109>
	^self hashMultiply!

instVarAt: index
	"Private - Answer the receiver's instance variable at the argument, index.
	Not valid for SmallIntegers,  which have no instance variables in the true sense.
	Do not remove this method, as the primitive implementation in Object
	will behave unexpectedly for SmallIntegers."

	^self shouldNotImplement!

instVarAt: index put: value
	"Private - Replace the receiver's instance variable at the argument, index,
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

isInt32
	"Answer whether the receiver can be represented as a 32-bit two's complement signed integer."

	^VMConstants.IsWin64 not or: [super isInt32]!

isInt64
	"Answer whether the receiver can be represented as a 64-bit two's complement signed integer."

	^true!

isUInt32
	"Answer whether the receiver can be represented as a 32-bit unsigned integer."

	^self >= 0!

isUInt64
	"Answer whether the receiver can be represented as a 64-bit unsigned integer."

	^self >= 0!

isZero
	"Answer whether the receiver is zero. SmallIntegers can be zero, and there is a
	very fast check."

	^self == 0!

lowBit
	"Answer the index of the lowest bit of the receiver which is set.
	Unlike #highBit, this is meaningful for negative numbers too."

	"Implementation Note: The primitive makes use of the Intel BSF instruction."

	<primitive: 152>
	| i t |
	self == 0 ifTrue: [^self].
	t := self.
	i := 1.
	[(t bitAnd: 16rF) == 0] whileTrue: 
			[i := i + 4.
			t := t bitShift: -4].
	[(t bitAnd: 1) == 0] whileTrue: 
			[i := i + 1.
			t := t bitShift: -1].
	^i!

multiplyByInteger: anInteger
	"Private - Answer the result of multiplying the receiver by the argument, anInteger.

	Implementation Note: Invoked when SmallInteger multiplied by another SmallInteger but the
	result overflows the SmallInteger range (a fairly common occurrence). The superclass
	implementation does not work because it goes through the generic coercion mechanism, which
	does not expect to be invoked for two numbers of the same generality."

	^(LargeInteger fromSmallInteger: self) * anInteger!

numberOfDigitsInBase: anInteger
	"Private - Answer the number of digits required to print this number in <integer> base, anInteger."

	anInteger == 10 ifFalse: [^super numberOfDigitsInBase: anInteger].
	self < 0 ifTrue: [^self negated numberOfDigitsInBase: anInteger].
	^self decimalDigitLength!

printOn: aWriteStream base: baseInteger
	"Append a text representation of the digits of the receiver on the <puttableStream>, aWriteStream,
	in the <integer> base, baseInteger."

	| n divisor |
	n := self < 0
				ifTrue: 
					[aWriteStream nextPut: $-.
					0 - self]
				ifFalse: [self].
	divisor := baseInteger == 10
				ifTrue: 
					["Allow for 64-bit SmallIntegers in future"
					#(1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000 10000000000 100000000000 1000000000000 10000000000000 100000000000000 1000000000000000 10000000000000000 100000000000000000 1000000000000000000)
						at: n decimalDigitLength]
				ifFalse: [baseInteger raisedToInteger: (n numberOfDigitsInBase: baseInteger) - 1].
	[divisor > 1] whileTrue: 
			[| digit |
			digit := n // divisor.
			aWriteStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: digit + 1).
			n := n - (digit * divisor).
			divisor := divisor // baseInteger].
	aWriteStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: n + 1)!

printOn: aWriteStream base: baseInteger nDigits: digitsInteger
	"Append a base, baseInteger, representation of the receiver to the <puttableStream>, aWriteStream, using a minimum of, digitsInteger, digits.
	Note that if the receiver is negative, the sign is counted as one of the digits. The output does not have a radix prefix."

	| n numberOfDigits hasSign divisor |
	n := self < 0
				ifTrue: 
					[aWriteStream nextPut: $-.
					hasSign := 1.
					0 - self]
				ifFalse: 
					[hasSign := 0.
					self].
	divisor := baseInteger == 10
				ifTrue: 
					[numberOfDigits := n decimalDigitLength.
					#(1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000 10000000000 100000000000 1000000000000 10000000000000 100000000000000 1000000000000000 10000000000000000 100000000000000000 1000000000000000000)
						at: numberOfDigits]
				ifFalse: 
					[numberOfDigits := n numberOfDigitsInBase: baseInteger.
					baseInteger raisedToInteger: numberOfDigits - 1].
	aWriteStream next: digitsInteger - (hasSign + numberOfDigits) put: $0.
	[divisor > 1] whileTrue: 
			[| digit |
			digit := n // divisor.
			aWriteStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: digit + 1).
			n := n - (digit * divisor).
			divisor := divisor // baseInteger].
	aWriteStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: n + 1)!

printString
	"Answer the <readableString> representation of the receiver in base 10."

	"Implementation Note: Although this method is strictly not necessary (SmallInteger>>printOn:base: makes it redundant), printing SmallIntegers is such a common operation that it is worth providing an optimised version generating a String."

	<primitive: 44>
	| integer answer digits |
	self < 0 ifTrue: [^'-' , self negated printString].
	answer := String new: (digits := self decimalDigitLength).
	integer := self.
	digits to: 1
		by: -1
		do: 
			[:i |
			| n |
			n := integer // 10.
			answer basicAt: i put: ##($0 codePoint) + (integer - (n * 10)).
			integer := n].
	^answer!

printStringBase: anInteger
	"Answer the <readableString> representation of the receiver in base, anInteger, where 0 < anInteger <= 36."

	self < 0 ifTrue: [^'-' , (self negated printStringBase: anInteger)].
	self < anInteger ifTrue: [^String with: (Character digitValue: self)].
	^self printStringBase: anInteger nDigits: (self numberOfDigitsInBase: anInteger)!

printStringBase: baseInteger nDigits: lengthInteger
	"Answer the <readableString> representation of the receiver in base, anInteger, where 0 < anInteger <= 36, padded/truncated to exactly, lengthInteger, digits.
	The receiver should not be negative, and should be less than (baseInteger ** lengthInteger)."

	| integer next digits |
	digits := String new: lengthInteger.
	integer := self.
	lengthInteger to: 1
		by: -1
		do: 
			[:i |
			next := integer // baseInteger.
			digits at: i put: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: integer - (next * baseInteger) + 1).
			integer := next].
	^digits!

quo: aNumber
	"Answer the integer quotient defined by division with truncation toward zero."

	"The primitive fails with failure code InvalidParameter1 if the argument is not a SmallInteger.
	Attempted division by zero will cause a ZeroDivide exception to be raised by the VM."

	<primitive: 13>
	^aNumber quotientFromInteger: self!

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

	^SmallInteger! !

!Core.SmallInteger categoriesForMethods!
-!arithmetic!public! !
&!bit manipulation!public! !
*!arithmetic!public! !
/!arithmetic!public! !
//!arithmetic!public! !
\\!arithmetic!public! !
_deepCopy:!copying!private! !
|!bit manipulation!public! !
+!arithmetic!public! !
<!comparing!public! !
<<!bit manipulation!public! !
<=!comparing!public! !
=!comparing!public! !
>!comparing!public! !
>=!comparing!public! !
allMask:!bit manipulation!public! !
anyMask:!bit manipulation!public! !
asExternalAddress!converting!public! !
asFloat!converting!public! !
asStackPointer!converting!private! !
basicAt:!accessing!private! !
basicAt:put:!accessing!private! !
basicIdentityHash!comparing!public! !
basicShallowCopy!copying!public! !
basicSize!accessing!private! !
basicYourAddress!accessing!private! !
bitAnd:!bit manipulation!public! !
bitOr:!bit manipulation!public! !
bitShift:!bit manipulation!public! !
bitXor:!bit manipulation!public! !
byteAt:!accessing!private! !
byteSize!accessing!private! !
coerce:!coercing!private! !
decimalDigitLength!enquiries!private! !
deepCopy!copying!public! !
generality!coercing!private! !
hash!comparing!public! !
highBit!bit manipulation!public! !
identityHash!comparing!public! !
instVarAt:!accessing!private! !
instVarAt:put:!accessing!private! !
isAtomic!public!testing! !
isImmediate!public!testing! !
isInt32!public!testing! !
isInt64!public!testing! !
isUInt32!public!testing! !
isUInt64!public!testing! !
isZero!public!testing! !
lowBit!bit manipulation!public! !
multiplyByInteger:!double dispatch!private! !
numberOfDigitsInBase:!enquiries!private! !
printOn:base:!printing!public! !
printOn:base:nDigits:!printing!public! !
printString!printing!public! !
printStringBase:!printing!public! !
printStringBase:nDigits:!printing!public! !
quo:!arithmetic!public! !
refersToLiteral:!private!testing! !
shallowCopy!copying!public! !
species!accessing!public! !
!

!Core.SmallInteger class methodsFor!

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

!Core.SmallInteger class categoriesForMethods!
basicNew!instance creation!public! !
hasImmediateInstances!public!testing! !
maxBytes!constants!public! !
maximum!constants!public! !
minimum!constants!public! !
!

