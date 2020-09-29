"Filed out from Dolphin Smalltalk 7"!

Core.Number subclass: #'Core.Integer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Integer guid: (Core.GUID fromString: '{87b4c65c-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Integer isNonInstantiable: true!
Core.Integer comment: ''!
!Core.Integer categoriesForClass!Magnitude-Numbers! !
!Core.Integer methodsFor!

- operand
	"Answer a <number> which is the difference between the receiver and the argument, operand."

	^operand subtractFromInteger: self!

& anInteger
	"Answer the result of a bitwise AND between the receiver and the argument, anInteger.
	N.B. Use of #bitAnd: is preferred (even though it is more typing) because it is
	a special selector (i.e. it is more compact and faster), and is portable."

	^self bitAnd: anInteger!

* aNumber
	"Answer the result of multiplying the receiver by aNumber."

	^aNumber multiplyByInteger: self!

/ operand
	"Answer the <number> which is the result of dividing the receiver by <number>, operand. 
	If their is any remainder, then the result will be a <Fraction>. Raise a <ZeroDivide> 
	exception if the operand is zero."

	^operand divideIntoInteger: self!

// aNumber
	"Answer the quotient resulting from dividing the receiver by aNumber with 
	truncation towards negative infinity."

	| quo |
	self isZero ifTrue: [^self].
	quo := self quo: aNumber.
	(quo negative	
		ifTrue: [quo * aNumber ~= self]
		ifFalse: [quo isZero and: [self negative ~= aNumber negative]])
				ifTrue: [^quo - 1]
				ifFalse: [^quo].
!

| anInteger
	"Answer the result of a bitwise OR between the receiver and the argument, 
	anInteger.
	N.B. Use of #bitOr: is preferred (even though it is more typing) because it is
	a special selector (i.e. it is more compact and faster), and is portable."

	^self bitOr: anInteger!

+ aNumber
	"Answer a Number which is the sum of the receiver and aNumber."

	^aNumber addToInteger: self!

< aNumber
	"Answer whether the receiver is less than the argument, aNumber."

	^aNumber greaterThanInteger: self!

<< anInteger
	"Answer the result of shifting the receiver left anInteger bits.
	N.B. Use of #bitShift: is preferred (even though it is more typing) because it is
	a special selector (i.e. it is more compact and faster), and is portable."

	^self bitShift: anInteger!

>> anInteger
	"Answer the result of shifting the receiver right anInteger bits.
	N.B. Use of #bitShift: (with a negative argument) is preferred (even 
	though it is more typing) because it is a special selector (i.e. it is 
	more compact and faster), and is portable."

	^self bitShift: anInteger negated!

addToFloat: aFloat
	"Private - Add the receiver from the known Float, aFloat."

	^aFloat + self asFloat!

addToFraction: aFraction
	"Private - Add the receiver to the known Fraction, aFraction.
	There is no need to normalise the result."

	^Fraction numerator: self * aFraction denominator + aFraction numerator
		denominator: aFraction denominator!

allMask: mask
	"Answer whether all of the bits that are set in the <integer> mask are also set in 
	the receiver."

	^(self bitAnd: mask) = mask!

anyBitSetFrom: startInteger to: stopInteger
	"Answer whether any bits are set in the specified range in the receiver's 2's complement
	representation. This is probably not a useful enquiry for negative integer, since these have
	an infinite stream of leading bits."

	"Implementation Note: This is just about the simplest implementation, but relies on a fast
	bitShift:. In normal circumanstances, for reasonable ranges, this should be fine."

	| mask |
	mask := (1 bitShift: stopInteger - startInteger + 1) - 1 bitShift: startInteger - 1.
	^(mask bitAnd: self) ~~ 0!

anyMask: mask
	"Answer whether any of the bits that are set in the <integer> mask are also set 
	in the receiver."

	^(self bitAnd: mask) ~= 0!

asBoolean
	"Answer whether the receiver is non-zero."

	^self ~= 0
!

asCharacter
	"Answer the character whose Unicode code is the receiver."

	^Character value: self!

asDword
	"Answer the receiver as an unsigned double word value. Assumes the receiver is 
	a 32 bit integer.
	Implementation Note: LargeInteger constant receiver 
	to avoid always failing the SmallInteger bitAnd: primitive."

	^16rFFFFFFFF bitAnd: self!

asExternalAddress
	"Answer the receiver as an ExternalAddress."

	^VMLibrary default addressFromInteger: self!

asExternalHandle
	"Answer the receiver as an ExternalHandle.
	Implementation Note: Use the external call primitive coercion trick for speed."

	^VMLibrary default handleFromInteger: self!

asFraction
	"Answer the normalized fractional representation of the receiver, in this
	case an exact representation."

	^self!

asInteger
	"Answer the integer value of the receiver."

	^self
!

asResourceId
	^self
!

asScaledDecimal: anInteger
	"Answer a <ScaledDecimal> number, with the fractional precision 
	of 0 (i.e. the argument is effectively ignored). See ANSI 5.6.5.3 p127."

	^ScaledDecimal newFromNumber: self scale: 0!

asSDword
	"Answer the receiver as an signed double word value. Assumes the receiver is 
	a 32 bit integer.
	Implementation Note: Get the external library primitive to perform the coercion
	for us."

	^VMLibrary default signedFromUnsigned: self!

asStackPointer
	"Private - Answer a <SmallInteger> value which can be stored into a stack slot and which will be
	correctly interpreted by the VM when processing stack frames as a pointer to the value at
	the address represented by the receiver."

	^(16r40000000 + self bitAnd: 16r7FFFFFFF) + -16r40000000!

asUIntPtr
	"Answer the receiver as an unsigned double word value. Assumes the receiver is 
	a 32 bit integer.
	Implementation Note: LargeInteger constant receiver 
	to avoid always failing the SmallInteger bitAnd: primitive."

	^VMConstants.IntPtrMask bitAnd: self!

at: anInteger 
	"Integer's do not support indexed instance variables."

	^self shouldNotImplement!

at: index put: value
	"Replace the receivers indexed instance variable at the argument, index, with the argument,
	value. Not valid for immediate, objects which are constants. Do not remove this method, as
	the primitive implementation in Object will behave unexpectedly for immediate objects."

	^self shouldNotImplement!

bitAnd: operand
	"Answer an <integer> whose bits are the logical AND of the
	receiver's bits and those of the <integer> argument, operand."

	^self subclassResponsibility!

bitAt: index
	"Answer the <integer> 0 or 1 which is the binary value of the bit at 
	the <integer> position, index, in the receiver's 2's complement binary representation."

	^(self bitAnd: (1 bitShift: index - 1)) == 0
		ifTrue: [0]
		ifFalse: [1]!

bitAt: index put: value
	"Set the binary value of the bit at the <integer> position, index, in the 
	receiver's 2's complement binary representation to the low-order bit
	of the <integer> argument, value.
	Note: Integers are immutable, so there is no effect on the receiver and the
	answer is a new integer."

	^(self bitAnd: (1 bitShift: index-1) bitInvert)
		bitOr: ((value bitAnd: 1) bitShift: index - 1)!

bitInvert
	"Answer an integer whose bits are the complement of the receiver."

	^-1 - self!

bitOr: operand
	"Answer an integer whose bits are the logical OR of the
	receiver's bits and those of the <integer> argument, operand."

	^self subclassResponsibility!

bitShift: shift
	"Answer an <integer> which is the receiver shifted left by the
	<integer>, shift, number of bit positions if the operand is positive, 	
	or shifted right for shift negated number of bit positions if the operand
	is negative."

	shift isInteger
		ifFalse: [self error: 'non-integer argument'].
	shift >= 0
		ifTrue: [^self * (2 raisedToInteger: shift)].
	^self // (2 raisedToInteger: shift negated)!

bitXor: operand
	"Answer an <integer> whose bits are the logical XOR of the
	receiver's bits and those of the <integer> argument, operand"

	^self subclassResponsibility!

byteAt: anInteger 
	"Private - Answer the byte at index, index, of the absolute value of the
	receiver (i.e. magnitude  only representation)."

	^anInteger > 0 
		ifTrue: [(self abs bitShift: (1 - anInteger) * 8) bitAnd: 16rFF]
		ifFalse: [self errorSubscriptBounds: anInteger]!

byteSize
	"Private - Answer the number of bytes in the receiver's 2's complement
	representation."

	^self subclassResponsibility!

ceiling
	"Answer the integer nearest the receiver toward positive infinity."

	^self
!

clearBit: index
	"Answer the Integer which results from clearing the index'th bit of the receiver,
	where the least significant bit is considered to have index 1."

	^self maskClear: (1 bitShift: index-1)!

coerce: anArithmeticValue
	"Private - Answer the Integer representation of anArithmeticValue."

	^anArithmeticValue asInteger!

decimalDigitLength
	"Private - Answer the number of digits (only) necessary to print this number in base 10. The receiver must be positive."

	^self numberOfDigitsInBase: 10!

digitAt: anInteger 
	"Answer the index'th byte of 2's complement representation of the receiver. e.g. 1 at: 1 =
	1, -1 at: 1 = 255 (see also #byteAt:). Report an error if index is not greater than 0, but
	answer 0/255 if index is greater than the size of the receiver as this is a sensible action
	for Integers."

	^anInteger > 0 
		ifTrue: [(self bitShift: (1 - anInteger) * 8) bitAnd: 16rFF]
		ifFalse: [self errorSubscriptBounds: anInteger]!

digitLength
	"Answer the number of significant radix-256 digits in the receiver."

	^((self abs bitOr: 1) highBit - 1 bitShift: -3) + 1!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be the Smalltalk literal format for integers if the stream is configured for the Smalltalk locale, but it could be in a <WindowsLocale> specific format."

	aPuttableStream locale displayInteger: self on: aPuttableStream!

displayString
	"Answer a String whose characters are a representation of the receiver as a user
	would want to see it.
	Implementation Note: For Integers this is the same as the #printString, and for
	many cases that has an optimized implementation of which we wish to take
	advantage."

	^self printString!

divideIntoFloat: aFloat
	"Private - Divide the receiver into the known Float, aFloat. Answer the result."

	^aFloat / self asFloat!

divideIntoFraction: aFraction
	"Private - Answer the result of dividing the receiver into the argument, with
	truncation towards negative infinity. In general Integer division is more
	likely to be inexact, so assume a Fraction will be needed. The Fraction class
	instance creation method will answer an Integer if it can."

	^Fraction rationalisedNumerator: aFraction numerator denominator: self * aFraction denominator!

divideIntoInteger: anInteger
	"Private - Answer the result of dividing the receiver into the argument, with
	truncation towards negative infinity. In general Integer division is more
	likely to be inexact, so assume a Fraction will be needed. The Fraction class
	instance creation method will answer an Integer if it can."

	^Fraction rationalisedNumerator: anInteger denominator: self!

equalToFloat: aFloat
	"Private - Answer whether the receiver is equal to the the known <Float>, aFloat. This can only be the case for Float's with no fractional value."

	^aFloat isFinite and: [aFloat fractionPart isZero and: [aFloat truncated = self]]!

equalToFraction: aFraction
	"Private - Answer whether the receiver is equal to the known <Fraction>, aFraction."

	^self * aFraction denominator = aFraction numerator!

equalToInteger: anInteger
	"Private - Answer whether the receiver is equal to the known <Integer>, anInteger."

	^self - anInteger == 0!

even
	"Answer whether the receiver is an even integer. Zero is considered even.
	Override superclass as we've a more efficient implementation."

	^(self bitAnd: 1) == 0!

exp10
	"Answer an <integer> which is base-10 exponent of the receiver (i.e. 10 raised to the power
	of the receiver)."

	"There is a small benefit in exploiting the fact that 10^N = 5^N * 2^N, at least when N is
	large. This is really only worthwhile because the LargeInteger multiplication primitive is
	not as efficient as it could be and so there is a small benefit in multiplying smaller
	numbers and then performing one bitshift to add the trailing zeroes."

	^self < 20 ifTrue: [10 raisedToInteger: self] ifFalse: [(5 raisedToInteger: self) bitShift: self]!

factorial
	"Answer the <integer> factorial of the receiver. It is an error for the receiver to be
	negative."

	^self factorial2p!

factorial2p
	"Private - 2-partition fast factorial algorithm from 'Fast Computation of Factorials of Numbers',
	Thompson & Ugur."

	| x0 x1 x2 |
	self < 2 ifTrue: [^self < 0 ifTrue: [self error: 'negative factorial'] ifFalse: [1]].
	x0 := 2.
	x1 := 10.
	x2 := x0.
	self // 2 - 1 timesRepeat: 
			[x0 := x0 + x1.
			x1 := x1 + 8.
			x2 := x2 * x0].
	self odd ifTrue: [x2 := x2 * self].
	^x2!

factorialIterative
	"Private - Answer the factorial of the receiver. The receiver must be not less than 0."

	| factorial |
	self < 0
		ifTrue: [^self error: 'negative factorial' ].
 	factorial := 1.
	2 to: self asInteger do: [ :i | factorial := i * factorial ].
	^factorial!

floor
	"Answer the integer nearest the receiver (i.e. the receiver)."

	^self!

fractionPart
	"Answer a <number> of the same type as the receiver, representing the 
	fractional part of  the receiver."

	^0!

gcd: anInteger
	"Answer the greatest common divisor of the receiver and the <integer>, anInteger, computed using Euclid's algorithm. See Knuth vol. II"

	| v u |
	u := anInteger.
	v := self.
	[v == 0] whileFalse: [v := u \\ (u := v)].
	^u abs!

gcdbin: operand 
	"Answer the greatest common divisor of the receiver and the <integer>, operand, computed 
	using Stein's binary algorithm. See Knuth vol. II"

	| k u v t |
	u := self abs.
	v := operand abs.
	k := 0.
	[u even and: [v even]] whileTrue: 
			[k := k + 1.
			u := u bitShift: -1.
			v := v bitShift: -1].
	t := u even ifTrue: [u bitShift: -1] ifFalse: [v negated].
	
	[[t even] whileTrue: [t := t bitShift: -1].
	t > 0 ifTrue: [u := t] ifFalse: [v := t negated].
	t := u - v.
	t == 0] 
			whileFalse.
	^u bitShift: k!

greaterThanFloat: aFloat
	"Private - Answer whether the receiver is greater than the known Float, aFloat."

	| fpclass |
	fpclass := aFloat fpClass.
	^(fpclass anyMask: Float.FpClassFinite)
		ifTrue: [self greaterThanFraction: aFloat asTrueFraction]
		ifFalse: 
			["aFloat is NaN, -∞ or ∞, so obviously we are only greater if it is -∞"
			fpclass anyMask: Float.FpClassNegative]!

greaterThanFraction: aFraction
	"Private - Answer whether the receiver is greater than the known Fraction, aFraction"

	^aFraction numerator < (self * aFraction denominator)!

hashMultiply
	"Answer a new positive <SmallInteger> hash value calculated from the receiver by using it's low-order bits as the seed for a simple Park-Miller LCG.
	This can be used to generate a better distributed hash value for SmallIntegers, but also for combining hash values to generate a hash for a composite object."

	<primitive: 109>
	^(self bitAnd: VMConstants.IntPtrMask) * 48271 bitAnd: VMConstants.SmallIntegerMax!

hex
	"Answer a <readableString> whose characters are a description of 
	the receiver in the hexadecimal."

	^self printStringRadix: 16!

highBit
	"Answer the <integer> index of the most significant non-zero bit of the binary representation of the receiver.
	N.B. This operation is not defined for negative integers."

	| digits |
	self < 0 ifTrue: [self error: 'high bit is infinite for negative integer'].
	digits := self digitLength.
	^(self byteAt: digits) highBit + (digits - 1 bitShift: 3)!

highByte
	"Private - Answer the most significant radix-256 digit of the receiver."

	^self byteAt: self digitLength!

highPartSigned
	"Answers the high order signed word of the receiver (assumes the receiver is a machine word sized integer)."

	^(self bitShift: ##(VMConstants.HalfPtrBits negated)) lowPartSigned!

highWord
	"Answers the high order unsigned word of the receiver (assumes the receiver is a 32-bit Integer)."

	^(self bitShift: -16) bitAnd: 16rFFFF!

integerPart
	"Answer an <integer> representing the whole integer part of the receiver."

	^self!

isBitSet: index
	"Answer whether the index'th bit of the receiver is set (has the value 1), 
	where the least significant bit is considered to have index 1."

	^self anyMask: (1 bitShift: index-1)!

isInteger
	"Answer whether the receiver is an <integer>."

	^true!

isNull
	"Answer whether the receiver is 'null' (equal to zero)."

	^self == 0!

isPowerOfTwo
	"Return true if the receiver is an integral power of two."

	^self ~~ 0 and: [(self bitAnd: self - 1) == 0]!

isPrime
	"Answer whether the receiver is a prime number. This may take a long time for larger integer values."

	| i |
	self <= 3 ifTrue: [^self > 1].
	(self even or: [self \\ 3 == 0]) ifTrue: [^false].
	i := 5.
	[i * i <= self] whileTrue: 
			[(self \\ i == 0 or: [self \\ (i + 2) == 0]) ifTrue: [^false].
			i := i + 6].
	^true!

isSDWORD
	"Answer whether the receiver can be represented as a 32-bit two's complement signed integer
	(i.e. as an SDWORD)."

	^self >= ##(-2 raisedToInteger: 31) and: [self < ##(2 raisedToInteger: 31)]!

lcm: anInteger 
	"Answer the least common multiple of the receiver and the <integer> argument."

	| gcd |
	anInteger = 0 ifTrue: [^0].
	gcd := self gcd: anInteger.
	^gcd == 0 ifTrue: [1] ifFalse: [(self // gcd * anInteger) abs]!

lowBit
	"Answer the index of the lowest order bit of the receiver which is set."

	1 to: self basicSize
		do: 
			[:i | 
			| byte |
			byte := self byteAt: i.
			byte == 0 ifFalse: [^byte lowBit + ((i - 1) * 8)]].
	^0!

lowPart
	"Answers the low order unsigned word of the receiver (assumes the receiver is a machine word sized Integer, i.e. an INT_PTR)."

	^self bitAnd: VMConstants.HalfPtrMask!

lowPartSigned
	"Answers the low order signed word of the receiver (assumes the receiver is a machine word sized Integer)."

	| part |
	part := self lowPart.
	^part > VMConstants.HalfPtrMax 
		ifTrue: [(part bitXor: VMConstants.HalfPtrMask) bitInvert]
		ifFalse: [part]!

lowWord
	"Answers the low order word of the receiver."

	^self bitAnd: 16rFFFF.!

mask: integerMask set: aBoolean
	"Answer the result of setting/resetting the specified mask in the receiver."

	^aBoolean ifTrue: [self bitOr: integerMask] ifFalse: [self bitAnd: integerMask bitInvert]!

maskClear: anInteger
	"Answer a copy of the receiver with the bits of the argument, anInteger, masked out."

	^self bitAnd: anInteger bitInvert!

maskSet: anInteger
	"Answer a copy of the receiver with the bits of the argument, anInteger, masked in"

	^self bitOr: anInteger!

multiplyByFloat: aFloat
	"Private - Multiply the receiver by the known Float, aFloat. Answer the result."

	^aFloat * self asFloat!

multiplyByFraction: aFraction
	"Private - Answer the result of multiplying the receiver by the known Fraction, aFraction."

	^Fraction rationalisedNumerator: self * aFraction numerator denominator: aFraction denominator!

negated
	"Answer a <number> of the same type of the receiver
	which is its negation.

	Implementation Note: Overridden purely for improved performance."

	^0 - self!

negative
	"Answer whether the receiver is a negative number.
	Implementation Note: Override for performance only."

	^self < 0!

noMask: mask
	"Answer whether none of the bits that are set in the <integer> argument, mask,
	are also set in the receiver."

	^(self bitAnd: mask) == 0!

normalize
	"Private - Answer the receiver in its minimal representation (i.e. itself)."

	^self!

notNull
	"Answer whether the receiver is not 'null' (not equal to zero)"

	^self ~~ 0!

numberOfDigitsInBase: anInteger
	"Private - Answer the number of digits required to print this number in <integer> base, anInteger."

	| nDigits q total |
	self < 0 ifTrue: [^self negated numberOfDigitsInBase: anInteger].
	self < anInteger ifTrue: [^1].
	(anInteger bitAnd: anInteger - 1) == 0
		ifTrue: [^self highBit + anInteger highBit - 2 quo: anInteger highBit - 1].
	q := self.
	total := 0.
	
	["Make an initial nDigits guess that is less than or equal to required number of digits"
	nDigits := anInteger == 10
				ifTrue: 
					[((q highBit - 1) * 1233 bitShift: -12) + 1	"This is because (2 log)/(10 log)*4096 is slightly greater than 1233"]
				ifFalse: [q highBit quo: anInteger highBit].
	total := total + nDigits.

	"See how many digits remains above these first nDigits guess"
	(q := q quo: (anInteger raisedToInteger: nDigits)) < anInteger]
			whileFalse.
	^q == 0 ifTrue: [total] ifFalse: [total + 1]!

printOn: aStream
	"Append the ASCII representation of the receiver to aStream.
	Although not strictly part of the ANSI protocol <number>, this method is the means by which Integer implements printString in a compliant manner that produces a literal representation of the receiver."

	aStream locale displayInteger: self on: aStream!

printOn: aWriteStream base: anInteger
	"Append a text representation of the digits of the receiver on the <puttableStream>, aWriteStream, in the <integer> base, baseInteger."

	self subclassResponsibility!

printOn: aWriteStream base: baseInteger nDigits: digitsInteger
	"Append a textual representation of the receiver in <integer> base, baseInteger, to the <puttableStream>, aWriteStream, using at least <integer> digits, digitsInteger.
	Behavior is undefined unless it holds that 0 <= self < (baseInteger raisedToInteger: digitsInteger)."

	self subclassResponsibility!

printOn: aWriteStream base: anInteger showRadix: aBoolean
	"Append a text representation of the receiver on the <puttableStream>, aWriteStream, in the <integer> base, anInteger, showing a radix prefix if the <boolean> argument, aBoolean, is true."

	self < 0
		ifTrue: 
			[aWriteStream nextPut: $-.
			self negated
				printOn: aWriteStream
				base: anInteger
				showRadix: aBoolean]
		ifFalse: 
			[aBoolean
				ifTrue: 
					[anInteger printOn: aWriteStream base: 10.
					aWriteStream nextPut: $r].
			self printOn: aWriteStream base: anInteger]!

printStringBase: anInteger
	"Answer a <readableString> whose characters are a description of the receiver in the specified <integer> radix, without a radix prefix."

	| aStream |
	aStream := String smalltalkWriteStream: 16.
	self printOn: aStream base: anInteger.
	^aStream contents!

printStringBase: baseInteger nDigits: lengthInteger
	"Answer the <readableString> representation of the receiver in base, anInteger, where 0 < anInteger <= 36, padded/truncated to exactly, lengthInteger, digits.
	Behavior is undefined unless it holds that 0 <= self < (baseInteger raisedToInteger: digitsInteger)."

	| answer |
	answer := String new: lengthInteger.
	self
		printOn: answer writeStream
		base: baseInteger
		nDigits: lengthInteger.
	^answer!

printStringRadix: anInteger
	"Answer a <readableString> whose characters are a description of the receiver in the specified <integer> radix."

	| aStream |
	aStream := String smalltalkWriteStream: 16.
	self
		printOn: aStream
		base: anInteger
		showRadix: true.
	^aStream contents!

rounded
	"Answer the integer nearest the receiver."

	^self
!

setBit: index
	"Answer the Integer which results from setting the index'th bit of the receiver,
	where the least significant bit is considered to have index 1."

	^self maskSet: (1 bitShift: index-1)!

size
	"Integer's do not support indexed instance variables."

	^self shouldNotImplement!

subtractFromFloat: aFloat
	"Private - Subtract the receiver from the known Float, aFloat, and answer the result."

	^aFloat - self asFloat!

subtractFromFraction: aFraction
	"Private - Subtract the receiver from the known fraction, aFraction and answer the result.
	There is no need to normalise the result."

	^Fraction numerator: aFraction numerator - (self * aFraction denominator)
		denominator: aFraction denominator!

timesRepeat: aBlock 
	"Evaluate aBlock repeatedly, once for each integer from 1 to the floor of 
	the receiver."

	"Implementation Note: This message is normally inlined by the Compiler,
	but it is only able to make that optimization if the argument is a literal
	block. Although at first glance infinitely recursive, the most optimal 
	implementation is to exploit that inlining and implement this method
	in terms of itself."

	self timesRepeat: [aBlock value]!

truncated
	"Answer the integer nearest the receiver toward zero."

	^self
!

yourAddress
	"Assume that the integer is being used as an address, so answer self."

	^self! !
!Core.Integer categoriesFor: #-!arithmetic!public! !
!Core.Integer categoriesFor: #&!bit manipulation!public! !
!Core.Integer categoriesFor: #*!arithmetic!public! !
!Core.Integer categoriesFor: #/!arithmetic!public! !
!Core.Integer categoriesFor: #//!arithmetic!public! !
!Core.Integer categoriesFor: #|!bit manipulation!public! !
!Core.Integer categoriesFor: #+!arithmetic!public! !
!Core.Integer categoriesFor: #<!comparing!public! !
!Core.Integer categoriesFor: #<<!bit manipulation!public! !
!Core.Integer categoriesFor: #>>!bit manipulation!public! !
!Core.Integer categoriesFor: #addToFloat:!double dispatch!private! !
!Core.Integer categoriesFor: #addToFraction:!double dispatch!private! !
!Core.Integer categoriesFor: #allMask:!bit manipulation!public! !
!Core.Integer categoriesFor: #anyBitSetFrom:to:!bit manipulation!public! !
!Core.Integer categoriesFor: #anyMask:!bit manipulation!public! !
!Core.Integer categoriesFor: #asBoolean!converting!public! !
!Core.Integer categoriesFor: #asCharacter!converting!public! !
!Core.Integer categoriesFor: #asDword!converting!public! !
!Core.Integer categoriesFor: #asExternalAddress!converting!public! !
!Core.Integer categoriesFor: #asExternalHandle!converting!public! !
!Core.Integer categoriesFor: #asFraction!converting!public! !
!Core.Integer categoriesFor: #asInteger!converting!public! !
!Core.Integer categoriesFor: #asResourceId!converting!public! !
!Core.Integer categoriesFor: #asScaledDecimal:!converting!public! !
!Core.Integer categoriesFor: #asSDword!converting!public! !
!Core.Integer categoriesFor: #asStackPointer!converting!private! !
!Core.Integer categoriesFor: #asUIntPtr!converting!public! !
!Core.Integer categoriesFor: #at:!accessing!public! !
!Core.Integer categoriesFor: #at:put:!accessing!public! !
!Core.Integer categoriesFor: #bitAnd:!bit manipulation!public! !
!Core.Integer categoriesFor: #bitAt:!bit manipulation!public! !
!Core.Integer categoriesFor: #bitAt:put:!bit manipulation!public! !
!Core.Integer categoriesFor: #bitInvert!bit manipulation!public! !
!Core.Integer categoriesFor: #bitOr:!bit manipulation!public! !
!Core.Integer categoriesFor: #bitShift:!bit manipulation!public! !
!Core.Integer categoriesFor: #bitXor:!bit manipulation!public! !
!Core.Integer categoriesFor: #byteAt:!accessing!private! !
!Core.Integer categoriesFor: #byteSize!accessing!private! !
!Core.Integer categoriesFor: #ceiling!public!truncation and round off! !
!Core.Integer categoriesFor: #clearBit:!bit manipulation!public! !
!Core.Integer categoriesFor: #coerce:!coercing!private! !
!Core.Integer categoriesFor: #decimalDigitLength!enquiries!private! !
!Core.Integer categoriesFor: #digitAt:!accessing!public! !
!Core.Integer categoriesFor: #digitLength!enquiries!public! !
!Core.Integer categoriesFor: #displayOn:!printing!public! !
!Core.Integer categoriesFor: #displayString!printing!public! !
!Core.Integer categoriesFor: #divideIntoFloat:!double dispatch!private! !
!Core.Integer categoriesFor: #divideIntoFraction:!double dispatch!private! !
!Core.Integer categoriesFor: #divideIntoInteger:!double dispatch!private! !
!Core.Integer categoriesFor: #equalToFloat:!double dispatch!private! !
!Core.Integer categoriesFor: #equalToFraction:!double dispatch!private! !
!Core.Integer categoriesFor: #equalToInteger:!double dispatch!private! !
!Core.Integer categoriesFor: #even!public!testing! !
!Core.Integer categoriesFor: #exp10!mathematical!public! !
!Core.Integer categoriesFor: #factorial!factorization!public! !
!Core.Integer categoriesFor: #factorial2p!factorization!private! !
!Core.Integer categoriesFor: #factorialIterative!factorization!private! !
!Core.Integer categoriesFor: #floor!public!truncation and round off! !
!Core.Integer categoriesFor: #fractionPart!accessing!public! !
!Core.Integer categoriesFor: #gcd:!factorization!public! !
!Core.Integer categoriesFor: #gcdbin:!factorization!public! !
!Core.Integer categoriesFor: #greaterThanFloat:!double dispatch!private! !
!Core.Integer categoriesFor: #greaterThanFraction:!double dispatch!private! !
!Core.Integer categoriesFor: #hashMultiply!comparing!public! !
!Core.Integer categoriesFor: #hex!printing!public! !
!Core.Integer categoriesFor: #highBit!bit manipulation!public! !
!Core.Integer categoriesFor: #highByte!accessing!private! !
!Core.Integer categoriesFor: #highPartSigned!bit manipulation!public! !
!Core.Integer categoriesFor: #highWord!bit manipulation!public! !
!Core.Integer categoriesFor: #integerPart!accessing!public! !
!Core.Integer categoriesFor: #isBitSet:!bit manipulation!public!testing! !
!Core.Integer categoriesFor: #isInteger!public!testing! !
!Core.Integer categoriesFor: #isNull!public!testing! !
!Core.Integer categoriesFor: #isPowerOfTwo!public!testing! !
!Core.Integer categoriesFor: #isPrime!public!testing! !
!Core.Integer categoriesFor: #isSDWORD!public!testing! !
!Core.Integer categoriesFor: #lcm:!factorization!public! !
!Core.Integer categoriesFor: #lowBit!bit manipulation!public! !
!Core.Integer categoriesFor: #lowPart!bit manipulation!public! !
!Core.Integer categoriesFor: #lowPartSigned!bit manipulation!public! !
!Core.Integer categoriesFor: #lowWord!bit manipulation!public! !
!Core.Integer categoriesFor: #mask:set:!bit manipulation!public! !
!Core.Integer categoriesFor: #maskClear:!bit manipulation!public! !
!Core.Integer categoriesFor: #maskSet:!bit manipulation!public! !
!Core.Integer categoriesFor: #multiplyByFloat:!double dispatch!private! !
!Core.Integer categoriesFor: #multiplyByFraction:!double dispatch!private! !
!Core.Integer categoriesFor: #negated!arithmetic!public! !
!Core.Integer categoriesFor: #negative!public!testing! !
!Core.Integer categoriesFor: #noMask:!bit manipulation!public! !
!Core.Integer categoriesFor: #normalize!converting!private! !
!Core.Integer categoriesFor: #notNull!public!testing! !
!Core.Integer categoriesFor: #numberOfDigitsInBase:!enquiries!private! !
!Core.Integer categoriesFor: #printOn:!printing!public! !
!Core.Integer categoriesFor: #printOn:base:!printing!public! !
!Core.Integer categoriesFor: #printOn:base:nDigits:!printing!public! !
!Core.Integer categoriesFor: #printOn:base:showRadix:!printing!public! !
!Core.Integer categoriesFor: #printStringBase:!accessing!public! !
!Core.Integer categoriesFor: #printStringBase:nDigits:!printing!public! !
!Core.Integer categoriesFor: #printStringRadix:!printing!public! !
!Core.Integer categoriesFor: #rounded!public!truncation and round off! !
!Core.Integer categoriesFor: #setBit:!bit manipulation!public! !
!Core.Integer categoriesFor: #size!accessing!public! !
!Core.Integer categoriesFor: #subtractFromFloat:!double dispatch!private! !
!Core.Integer categoriesFor: #subtractFromFraction:!double dispatch!private! !
!Core.Integer categoriesFor: #timesRepeat:!evaluating!public! !
!Core.Integer categoriesFor: #truncated!public!truncation and round off! !
!Core.Integer categoriesFor: #yourAddress!accessing!public! !

Core.Integer methodProtocol: #integer attributes: #(#ansi #readOnly) selectors: #(#- #* #/ #// #+ #< #allMask: #anyMask: #asFraction #asInteger #asScaledDecimal: #bitAnd: #bitAt: #bitAt:put: #bitOr: #bitShift: #bitXor: #ceiling #even #factorial #floor #fractionPart #gcd: #highBit #integerPart #lcm: #negated #negative #noMask: #odd #printOn:base:showRadix: #printStringRadix: #quo: #rounded #truncated)!

!Core.Integer class methodsFor!

primesUpTo: aNumber
	"Answer a <sequencedReadableCollection> of all primes less than or equal to the <integer> argument."

	| limit flags prime primes |
	limit := aNumber asInteger - 1.
	flags := ByteArray new: limit withAll: 1.
	primes := Array writeStream.
	1 to: limit
		do: 
			[:i |
			(flags at: i) == 1
				ifTrue: 
					[| k |
					prime := i + 1.
					k := i + prime.
					[k <= limit] whileTrue: 
							[flags at: k put: 0.
							k := k + prime].
					primes nextPut: prime]].
	^primes contents!

readFrom: aStream
	"Instantiate a new subinstance of the receiver from aStream and answer it.
	Handles negative integers with a leading minus sign. Also allows for bases
	other than 10 (with leading nnr format) with digits greater than 10 being
	represented by characters A-Z.
	Does not handle NLS characters (e.g. thousand separators)."

	| neg answer |
	neg := aStream peekFor: $-.
	answer := self readFrom: aStream
				initialInteger: (self readPositiveFrom: aStream radix: 10).
	^neg ifTrue: [answer negated] ifFalse: [answer]!

readFrom: aStream initialInteger: initialInteger
	"Private - Instantiate a new instance of the receiver from aStream and answer it.
	The <integer>, initialInteger, has already been read from the stream.
	All we need to do is to check whether initialInteger is in fact a radix prefix, and
	proceed accordingly."

	^(aStream peekFor: $r) 
		ifTrue: [self readPositiveFrom: aStream radix: initialInteger]
		ifFalse: [initialInteger]!

readFrom: aStream radix: anInteger
	"Instantiate a subinstance of the receiver from aStream using the specified
	radix, and answer it. 
	Note: This is intended for reading Integer's obeying Smalltalk syntax, not locale specific
	formats, and therefore it does not handle NLS characters (e.g. thousand separators)."

	| neg value |
	neg := aStream peekFor: $-.
	value := self readPositiveFrom: aStream radix: anInteger.
	^neg ifTrue: [value negated] ifFalse: [value]!

readPositiveFrom: aStream radix: anInteger
	| value |
	value := 0.
	[aStream atEnd] whileFalse: 
			[| char digit |
			char := aStream next.
			((digit := char digitValue) < anInteger and: [digit >= 0]) 
				ifTrue: [value := value * anInteger + digit]
				ifFalse: 
					[aStream pop.
					^value]].
	^value! !
!Core.Integer class categoriesFor: #primesUpTo:!enquiries!public! !
!Core.Integer class categoriesFor: #readFrom:!instance creation!public! !
!Core.Integer class categoriesFor: #readFrom:initialInteger:!instance creation!private! !
!Core.Integer class categoriesFor: #readFrom:radix:!instance creation!public! !
!Core.Integer class categoriesFor: #readPositiveFrom:radix:!instance creation!private! !

