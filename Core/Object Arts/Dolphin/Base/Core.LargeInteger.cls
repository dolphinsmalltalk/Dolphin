"Filed out from Dolphin Smalltalk"!

Core.Integer
	variableByteSubclass: #'Core.LargeInteger'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.LargeInteger guid: (Core.GUID fromString: '{87b4c65e-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.LargeInteger isIndirection: true!

Core.LargeInteger comment: 'Class LargeInteger is the class of Integers which are outside the range of SmallIntegers (i.e. outside (SmallInteger minimum..SmallInteger maximum). Basically any Integer requiring more than 31-bits to be represented in 2''s complement will be a LargeInteger.

LargeIntegers in Dolphin do not follow the standard signed-magnitude radix-256 Smalltalk representation, with separate subclasses for positive and negative integers. Dolphin''s LargeIntegers follow standard machine representation, in that they are 2''s complement, 32-bit granular (i.e. they might have 32, 64, 96, ...n*32 bits). This representation has the dual advantages of higher performance, and simplified external interfacing. In particular the 32 and 64-bit Integers have the same representation externally as they do in Dolphin. Note that all integers are considered immutable - attempts to update the individual bytes will fail.

LargeInteger includes high performance primitive implementations for the common arithmetical operations and bit manipulations.'!

!Core.LargeInteger categoriesForClass!Magnitude-Numbers! !

!Core.LargeInteger methodsFor!

- operand
	"Answer a <number> which is the difference between the receiver and the <number> argument, operand."

	<primitive: 22>
	^operand subtractFromInteger: self!

* operand
	"Answer the <number> result of multiplying the receiver by the <number> argument, operand."

	<primitive: 29>
	^operand multiplyByInteger: self!

/ operand
	"Answer the <number> which is the result of dividing the receiver by <number> argument, operand. If their is any remainder, then the result will be a <Fraction>. 
	Raise a <ZeroDivide> exception if the operand is zero."

	<primitive: 30>
	^operand divideIntoInteger: self!

// operand
	"Answer a <number> which is the quotient resulting from dividing the receiver by the <number> argument, operand,  with truncation towards negative infinity."

	<primitive: 32>
	^super // operand!

\\ operand
	"Answer the <integer> remainder defined by division with truncation toward negative infinity; e.g. 7 \\ 2 = 1, -7 \\ 2 = 1, 7 \\ -2 = -1. 
	This is the modulo operation, but it is not the same as C modulo (%) which truncates towards zero. Report an error if the aNumber is zero."

	<primitive: 31>
	^super \\ operand!

+ operand
	"Answer a <number> which is the sum of the receiver and the <number> argument, operand."

	<primitive: 21>
	^operand addToInteger: self!

< operand
	"Answer whether the receiver is less than the <number>, operand."

	<primitive: 23>
	^operand greaterThanInteger: self!

<= anArithmeticValue
	"Answer whether the receiver is less than or equal to the <arithmeticValue> argument"

	<primitive: 25>
	^anArithmeticValue greaterOrEqualToInteger: self!

= comperand
	"Answer whether the receiver is equal to the <Object>, comperand."

	<primitive: 27>
	^comperand understandsArithmetic and: [comperand equalToInteger: self]!

> operand
	"Answer whether the receiver is greater than the <number>, operand."

	<primitive: 24>
	^operand < self!

>= aNumber
	"Answer whether the receiver is greater than or equal to aNumber."

	<primitive: 26>
	^super >= aNumber!

addToInteger: anInteger
	"Private - Answer the <integer> result of adding the known <integer> to the receivers. We should only normally get here if anInteger is a SmallInteger."

	"Implementation Notes: As addition is commutative we can use the large integer add primitive. We do not supersend if the primitive fails because it does not fail for Integer arguments, and a non-Integer argument breaks the preconditions of this method."

	"Primitive Failure Reasons:
		InvalidParameter1	- anInteger is not an Integer.
	"

	<primitive: 21>
	^self primitiveFailed: _failureCode!

asByteArray
	"Answer a <ByteArray> containing a copy of the receiver's native bytes (little-endian, 32-bit granularity, 2's complement)."

	| byteSize |
	byteSize := self basicSize.
	^self
		replaceBytesOf: (ByteArray new: byteSize)
		from: 1
		to: byteSize
		startingAt: 1!

asFloat
	"Answer the floating point representation of the receiver. Some precision may be lost. The result will be the nearest fp value calculated using IEEE round-to-nearest even rounding."

	"Primitive Failure Reasons: 
		FloatInexactResult	- The receiver cannot be represented exactly as an IEEE double precision floating point number."

	<primitive: 167>
	| result nTruncatedBits |
	result := self abs.
	nTruncatedBits := result highBit - Float precision.
	nTruncatedBits > 0
		ifTrue: 
			[| exponent mask trailingBits carry |
			mask := (1 bitShift: nTruncatedBits) - 1.
			trailingBits := result bitAnd: mask.
			carry := trailingBits bitShift: 1 - nTruncatedBits.
			result := result bitShift: nTruncatedBits negated.
			exponent := nTruncatedBits.
			(carry isZero or: [(trailingBits bitAnd: (mask bitShift: -1)) isZero and: [result even]])
				ifFalse: [result := result + 1].
			^self positive
				ifTrue: [result asFloat timesTwoPower: exponent]
				ifFalse: [result asFloat negated timesTwoPower: exponent]].

	"Should never reach this code as the primitive should handle the non-truncated case"
	result := 0.0.
	self basicSize to: 1
		by: -1
		do: [:i | result := result * 256.0 + (self byteAt: i) asFloat].
	^result!

bitAnd: mask
	"Answer an integer whose bits are the logical AND of the bits of the 2's complement representation of the receiver and the bits of the 2's complement representation of the Integer argument, mask. Note that this implies sign extension of the shorter of the two operands."

	"Implementation Note: Because Dolphin Integers are always represented in 2's complement, this is a very fast operation."

	"Primitive Failure Reasons:
		InvalidParameter1	- The argument is not an Integer (large or small).
	"

	<primitive: 34>
	^self primitiveFailed: _failureCode!

bitInvert
	"Answer an integer whose bits are the complement of the receiver."

	<primitive: 38>
	^self primitiveFailed: _failureCode!

bitOr: anInteger
	"Answer an integer whose bits are the logical OR of the receiver's bits and those of the argument, anInteger."

	"Primitive Failure Reasons:
		InvalidParameter1	- The argument is not an Integer (large or small).
	"

	<primitive: 35>
	^self primitiveFailed: _failureCode!

bitShift: delta
	"Answer an integer which is the receiver bits shifted by the SmallInteger argument, delta, bit positions. The shift direction is left if delta is positive, or right if delta is negative).
	Note that the shift is arithmetic, rather than logical, so sign bits are shifted in from the left on right shifts."

	"Primitive Failure Reasons:
		InvalidParameter1	- Argument, delta, is not a SmallInteger
	"

	<primitive: 37>
	"The superclass implementation is relatively slow, but does support LargeInteger deltas!!"
	^super bitShift: delta!

bitXor: anInteger
	"Answer an integer whose bits are the logical XOR of the receiver's bits and those of the argument, anInteger."

	"Primitive Failure Reasons:
		InvalidParameter1	- The argument is not an Integer (large or small).
	"

	<primitive: 36>
	^self primitiveFailed: _failureCode!

byteAt: index 
	"Private - Answer the byte (radix 256 digit) at index in the receiver.
	Note that the receiver is in two's complement representation, so
	the answer may be negative."

	| size |
	size := self basicSize.
	^index < size 
		ifTrue: [self basicAt: index]
		ifFalse: 
			[index == size 
				ifTrue: 
					[| answer |
					answer := self basicAt: index.
					answer > 127 ifTrue: [answer - 256] ifFalse: [answer]]
				ifFalse: [self signBit * -1]]!

byteSize
	"Private - Answer the number of bytes in the receiver's 2's complement
	representation."

	^self basicSize!

digitAt: anInteger 
	"Answer the n'th byte of 2's complement representation of the receiver."

	"Implementation Note: As Dolphin's LargeIntegers are stored directly in 2's complement 32-bit digits, we can make use of the standard byte accessing primitive, passing potential out of bounds accesses to the superclass implementation."

	<primitive: 60>
	^super digitAt: anInteger!

digitLength
	"Answer the number of significant radix-256 digits necessary to
	represent the absolute magnitude of the receiver."

	"Implementation Note: Superclass implementation will work, but this is better than twice as fast"

	| size abs |
	abs := self abs.
	size := abs basicSize.
	[(abs basicAt: size) == 0 and: [size > 0]] whileTrue: [size := size - 1].
	^size!

gcd: anInteger
	"Answer the greatest common divisor of the receiver and the <integer>, anInteger, computed using Lehmer's adapatation of the Euclid's method. See Knuth vol. II"

	| u v t |
	"L1: Initialize"
	u := self abs.
	v := anInteger abs.
	u < v
		ifTrue: 
			[t := v.
			v := u.
			u := t].
	[v isImmediate] whileFalse: 
			[| uHat vHat a b c d q |
			(uHat := u bitShift: (t := ##(VMConstants.SmallIntegerMax highBit) - u highBit)) isImmediate
				ifFalse: 
					[t := t - 1.
					uHat := uHat bitShift: -1].
			vHat := v bitShift: t.
			a := d := 1.
			b := c := 0.
			"L2: Test quotient"
			
			[| vPrime |
			(vPrime := vHat + d) ~~ 0 and: 
					[| vPrimePrime |
					(vPrimePrime := vHat + c) ~~ 0 and: [(q := (uHat + a) // vPrimePrime) = ((uHat + b) // vPrime)]]]
					whileTrue: 
						["L3: Emulate Euclid"
						c := a - (q * (a := c)).
						d := b - (q * (b := d)).
						vHat := uHat - (q * (uHat := vHat))].
			"L4: Multiprecision step"
			b == 0
				ifTrue: [v := u \\ (u := v)]
				ifFalse: 
					[t := u * a + (v * b).
					v := u * c + (v * d).
					u := t]].
	^v gcd: u!

generality
	"Private - Answer the generality of the receiver in the Smalltalk number system.
	Integers are the lowest generalities (20 Large, 10 Small)."

	^20!

greaterThanInteger: anInteger
	"Private - Answer whether the receiver is greater than the known integer, anInteger."

	<primitive: 24>
	^super greaterThanInteger: anInteger!

hash
	"Answer the <integer> hash value of the receiver."

	<primitive: 106>
	| hash |
	hash := 2166136261.
	"FNV1a"
	1 to: self basicSize
		do: [:i | hash := (hash bitXor: (self basicAt: i)) * 16777619 bitAnd: 16rFFFFFFFF].
	"Fold to 30 bits so is always positive SmallInteger"
	^(hash bitShift: -30) bitXor: (hash bitAnd: 16r3FFFFFFF)!

highBit
	"Answer the <integer> index of the most significant non-zero bit of the binary representation of the receiver.
	N.B. This operation is not defined for negative integers."

	<primitive: 53>
	^super highBit!

int32AtOffset: anInteger
	"Private - Answers the signed 4-byte integer at byte offset anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(Int32)+1))."

	<primitive: 122>
	^self primitiveFailed: _failureCode!

intPtrAtOffset: anInteger put: anObject
	"Private - Store anObject as a signed machine-word sized integer at anInteger offset in the receiver. anInteger must be representable in a machine word. Uses the intPtrAtOffset:put: primitive. This is intended only as a way to initialize a new LargeInteger with a SmallInteger value."

	<primitive: 183>
	^self primitiveFailed: _failureCode!

isZero
	"Answer whether the receiver is zero.
	LargeIntegers cannot be zero, because there is a more compact representation
	(i.e. SmallInteger 0)."

	^false!

limbSize
	"Private - Answer the number of 32-bit limbs in the receiver."

	^self basicSize bitShift: -2!

lowBit
	"Answer the index of the lowest order bit of the receiver which is set."

	| i |
	i := 1.
	"An invariant is that the receiver is normalized, and so cannot be zero"
	
	[| byte |
	byte := self basicAt: i.
	byte == 0 ifFalse: [^byte lowBit + ((i - 1) * 8)].
	i := i + 1]
			repeat!

multiplyByInteger: anInteger
	"Private - Answer the result of multiplying the receiver by the argument, anInteger."

	"N.B. If we get in here, then anInteger must be small, in which case we just perform the arithmetic in reverse (at present the SmallInteger prim's cannot handle LargeInteger arguments, but the LI prims can handle SmallInteger args). The primitive should not fail for an Integer argument, so we treat that as an error."

	<primitive: 29>
	^self primitiveFailed: _failureCode!

negated
	"Answer the negative value of the receiver."

	"The primitive does not fail."

	<primitive: 39>
	^self bitInvert + 1!

normalize
	"Private - Answer the receiver in its minimal 2's complement representation.
	The answer may be the receiver, a compressed version of the receiver (without leading sign digits), or a SmallInteger."

	<primitive: 28>
	^self primitiveFailed: _failureCode!

printOn: aWriteStream base: anInteger
	"Print the receiver in <integer> base anInteger to the <puttableStream>, aWriteStream.
	The base must be between 2 and 36."

	| halfDigits halfPower head tail nDigitsUnderestimate |
	self < 0
		ifTrue: 
			[aWriteStream nextPut: $-.
			self negated printOn: aWriteStream base: anInteger.
			^self].
	nDigitsUnderestimate := anInteger == 10
				ifTrue: 
					[((self highBit - 1) * 1233 bitShift: -12) + 1	"This is because (2 log)/(10 log)*4096 is slightly greater than 1233"]
				ifFalse: [self highBit quo: anInteger highBit].

	"splitting digits with a whole power of two is more efficient"
	halfDigits := 1 bitShift: nDigitsUnderestimate highBit - 2.

	"Separate in two halves, head and tail"
	halfPower := anInteger raisedToInteger: halfDigits.
	head := self quo: halfPower.
	tail := self - (head * halfPower).

	"print head"
	head printOn: aWriteStream base: anInteger.

	"print tail without the overhead to count the digits"
	tail
		printOn: aWriteStream
		base: anInteger
		nDigits: halfDigits!

printOn: aWriteStream base: baseInteger nDigits: digitsInteger
	"Append a textual representation of the receiver in <integer> base, baseInteger, to the <puttableStream>, aWriteStream, using at least <integer> digits, digitsInteger.
	Behavior is undefined unless it holds that 0 <= self < (baseInteger raisedToInteger: digitsInteger)."

	| halfPower half head tail |
	digitsInteger <= 1
		ifTrue: 
			[digitsInteger > 0 ifTrue: [aWriteStream nextPut: (Character digitValue: self)].
			^self].
	"In order to reduce cost of LargeInteger arithmetic, use a divide and conquer algorithm."
	halfPower := digitsInteger bitShift: -1.
	half := baseInteger raisedToInteger: halfPower.
	head := self quo: half.
	tail := self - (head * half).
	head
		printOn: aWriteStream
		base: baseInteger
		nDigits: digitsInteger - halfPower.
	tail
		printOn: aWriteStream
		base: baseInteger
		nDigits: halfPower!

quo: aNumber
	"Answer the integer quotient of the receiver divided by aNumber with truncation toward zero (i.e. like C integer division)."

	<primitive: 33>
	^aNumber quotientFromInteger: self
!

quotientFromInteger: anInteger
	"Private - Answer the <integer> quotient resulting from dividing the integer receiver into the argument, anInteger. Truncation is towards zero."

	"Implementation Note: We should normally only be here when attempting to divide a SmallInteger by a LargeInteger, the result of which, by the definition must be 0|-1, since ANY normalized LargeInteger must be greater in absolute magnitude than any SmallInteger, EXCEPT the special case of the largest negative SmallInteger the absolute value of which is a LargeInteger."

	^(anInteger == VMConstants.SmallIntegerMin and: [self = ##(VMConstants.SmallIntegerMin negated)])
		ifTrue: [-1]
		ifFalse: [0]!

reciprocal
	^Fraction numerator: 1 denominator: self!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:"

	"Primitive Failure Reasons:
		InvalidParameter1	- aByteObject is not a byte object
		InvalidParameter2	- start is not a SmallInteger.
		InvalidParameter3	- stop is not a SmallInteger.
		InvalidParameter4	- fromStart is not a SmallInteger.
		OutOfBounds		- 'from' or 'to' interval is out-of-bounds
	"

	<primitive: 142>
	^self primitiveFailed: _failureCode!

signBit
	"Private - Answer the receiver's sign bit. This will be 0 for positive integers
	and 1 for negative integers."

	^(self basicAt: self basicSize) bitShift: -7!

subtractFromInteger: anInteger 
	"Private - Subtract the receiver from the known integer, anInteger
	and answer the result.
	N.B. The negated receiver may not be large if the receiver is VMConstants.SmallIntegerMax+1
	and therefore it is better to send #+ that #addToInteger:."

	^self negated + anInteger!

uint32AtOffset: anInteger
	"Private - Answer the unsigned 4-byte integer at offset (i.e. zero relative) anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (4+1))."

	<primitive: 120>
	^self primitiveFailed: _failureCode!

uint32AtOffset: anInteger put: anObject
	"Private - Store an unsigned 4 byte value at byte offset anInteger within the receiver. Note
	that this will fail unless the LargeInteger has first been marked as mutable."

	<primitive: 121>
	_failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: [^self uint32AtOffset: anInteger put: anObject asInteger].
	_failureCode == _PrimitiveFailureCode.OutOfBounds
		ifTrue: 
			[^self isImmutable
				ifTrue: [Processor constWriteSignal signalWith: self]
				ifFalse: [self errorSubscriptBounds: anInteger]].
	_failureCode == _PrimitiveFailureCode.InvalidParameter1 ifTrue: [^Error nonIntegerIndex: anInteger].
	^self primitiveFailed: _failureCode! !

!Core.LargeInteger categoriesForMethods!
-!arithmetic!public! !
*!arithmetic!public! !
/!arithmetic!public! !
//!arithmetic!public! !
\\!arithmetic!public! !
+!arithmetic!public! !
<!comparing!public! !
<=!comparing!public! !
=!comparing!public! !
>!comparing!public! !
>=!comparing!public! !
addToInteger:!double dispatch!private! !
asByteArray!converting!public! !
asFloat!converting!public! !
bitAnd:!bit manipulation!public! !
bitInvert!bit manipulation!public! !
bitOr:!bit manipulation!public! !
bitShift:!bit manipulation!public! !
bitXor:!bit manipulation!public! !
byteAt:!accessing!private! !
byteSize!accessing!private! !
digitAt:!accessing!public! !
digitLength!accessing!public! !
gcd:!factorization!public! !
generality!coercing!private! !
greaterThanInteger:!double dispatch!private! !
hash!comparing!public! !
highBit!bit manipulation!public! !
int32AtOffset:!accessing!private! !
intPtrAtOffset:put:!initializing!primitives!private! !
isZero!public!testing! !
limbSize!accessing!private! !
lowBit!bit manipulation!public! !
multiplyByInteger:!double dispatch!private! !
negated!arithmetic!public! !
normalize!converting!private! !
printOn:base:!printing!private! !
printOn:base:nDigits:!printing!private! !
quo:!arithmetic!public! !
quotientFromInteger:!double dispatch!private! !
reciprocal!arithmetic!public! !
replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private! !
signBit!private!testing! !
subtractFromInteger:!double dispatch!private! !
uint32AtOffset:!accessing!primitives!private! !
uint32AtOffset:put:!accessing!primitives!private! !
!

!Core.LargeInteger class methodsFor!

fromBytes: bytes 
	"Answer an instance of the receiver instantiated from the byte object, bytes,
	which is assumed to contain a positive Integer magnitude."

	| size answer |
	size := bytes size.
	answer := self basicNew: (size roundUpTo: 4) + 4.
	1 to: size do: [:i | answer basicAt: i put: (bytes basicAt: i)].
	answer isImmutable: true.
	^answer normalize!

fromSmallInteger: anInteger 
	"Private - Answer an instance of the receiver representing the SmallInteger value,
	anInteger. Note that the result is NOT normalized, as otherwise the answer
	would just be the SmallInteger!! Because the answer is not normalized, it is
	not strictly a valid LargeInteger in all circumstances, hence this routine is 
	private."

	^(anInteger becomeA: self)
		isImmutable: true;
		yourself!

new: anInteger
	"Private - Answer a new LargeInteger of the requested number of 32-bit digits."

	^self basicNew: (anInteger bitShift: 2)!

new64
	"Private - Answer a new 64-bit LargeInteger.
	N.B. The answer is not a valid LargeInteger since zero is a SmallInteger."

	^self basicNew: 8! !

!Core.LargeInteger class categoriesForMethods!
fromBytes:!instance creation!public! !
fromSmallInteger:!instance creation!private! !
new:!instance creation!private! !
new64!instance creation!private! !
!

