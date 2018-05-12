"Filed out from Dolphin Smalltalk 7"!

Integer variableByteSubclass: #LargeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LargeInteger guid: (GUID fromString: '{87b4c65e-026e-11d3-9fd7-00a0cc3e4a32}')!
LargeInteger isIndirection: true!
LargeInteger comment: 'Class LargeInteger is the class of Integers which are outside the range of SmallIntegers (i.e. outside (SmallInteger minimum..SmallInteger maximum). Basically any Integer requiring more than 31-bits to be represented in 2''s complement will be a LargeInteger.

LargeIntegers in Dolphin do not follow the standard signed-magnitude radix-256 Smalltalk representation, with separate subclasses for positive and negative integers. Dolphin''s LargeIntegers follow standard machine representation, in that they are 2''s complement, 32-bit granular (i.e. they might have 32, 64, 96, ...n*32 bits). This representation has the dual advantages of higher performance, and simplified external interfacing. In particular the 32 and 64-bit Integers have the same representation externally as they do in Dolphin. Note that all integers are considered immutable - attempts to update the individual bytes will fail.

LargeInteger includes high performance primitive implementations for the common arithmetical operations and bit manipulations.'!
!LargeInteger categoriesForClass!Magnitude-Numbers! !
!LargeInteger methodsFor!

- operand
	"Answer a <number> which is the difference between the receiver and the <number> argument, 
	operand."

	<primitive: 22>
	^operand subtractFromInteger: self!

* operand
	"Answer the <number> result of multiplying the receiver by 
	the <number> argument, operand."

	<primitive: 29>
	^operand multiplyByInteger: self!

/ operand
	"Answer the <number> which is the result of dividing the receiver by <number> argument, 
	operand. If their is any remainder, then the result will be a <Fraction>. Raise a <ZeroDivide> 
	exception if the operand is zero."

	<primitive: 30>
	^operand divideIntoInteger: self!

// operand
	"Answer a <number> which is the quotient resulting from dividing the receiver 
	by the <number> argument, operand,  with truncation towards negative infinity."

	<primitive: 32>
	^super // operand!

\\ operand
	"Answer the <integer> remainder defined by division with truncation toward negative 
	infinity; e.g. 7 \\ 2 = 1, -7 \\ 2 = 1, 7 \\ -2 = -1. 
	This is the modulo operation, but it is not the same as C modulo (%) which truncates 
	towards zero. Report an error if the aNumber is zero."

	<primitive: 31>
	^super \\ operand!

+ operand
	"Answer a <number> which is the sum of the receiver and 
	the <number> argument, operand."

	<primitive: 21>
	^operand addToInteger: self!

< operand
	"Answer whether the receiver is less than the <number>, operand."

	<primitive: 23>
	^operand greaterThanInteger: self!

<= operand
	"Answer whether the receiver is less than or equal to the <number>, operand."

	<primitive: 25>
	^super <= operand!

= comperand
	"Answer whether the receiver is equal to the <Object>, comperand."

	<primitive: 27>
	^super = comperand!

> operand
	"Answer whether the receiver is greater than the <number>, operand."

	<primitive: 24>
	^operand < self!

>= aNumber
	"Answer whether the receiver is greater than or equal to aNumber."

	<primitive: 26>
	^super >= aNumber!

addToInteger: anInteger
	"Private - Add the receiver to the known Integer, anInteger. 
	We should only normally get here if anInteger is a SmallInteger.
	Implementation Notes: As addition is commutative we can use the 
	large integer add primitive. We do not supersend if the primitive
	fails because it does not fail for Integer arguments, and a non-Integer
	argument breaks the preconditions of this method.

	Primitive Failure Reasons:
		0	- anInteger is not an Integer.
	"

	<primitive: 21>
	^self primitiveFailed!

asFloat
	"Answer the floating point representation of the receiver. Some precision may be lost. The
	result will be the nearest fp value calculated using IEEE round-to-nearest even rounding.

	Primitive Failure Reasons: 
		1 - The receiver has more than 64-bits "

	| result nTruncatedBits |
	<primitive: 167>
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
	"Answer an integer whose bits are the logical AND of the
	bits of the 2's complement representation of the receiver and 
	the bits of the 2's complement representation of the Integer 
	argument, mask. Note that this implies sign extension of the
	shorter of the two operands.

	Implementation Note: Because Dolphin Integers are always represented
	in 2's complement, this is a very fast operation.
	
	Primitive Failure Reasons:
		0	-	The argument is not an Integer (large or small).
	"

	<primitive: 34>
	^self primitiveFailed!

bitInvert
	"Answer an integer whose bits are the complement of the receiver."

	<primitive: 38>
	^self primitiveFailed!

bitOr: anInteger
	"Answer an integer whose bits are the logical OR of the
	receiver's bits and those of the argument, anInteger.

	Primitive Failure Reasons:
		0	-	The argument is not an Integer (large or small).
	"

	<primitive: 35>
	^self primitiveFailed!

bitShift: delta
	"Answer an integer which is the receiver bits shifted by the
	SmallInteger argument, delta, bit positions. The shift direction
	is left if delta is positive, or right if delta is negative).
	Note that the shift is arithmetic, rather than logical, so sign
	bits are shifted in from the left on right shifts.

	Primitive Failure Reasons:
		0	- Argument, delta, is not a SmallInteger

	The superclass implementation is relatively slow, but does support 
	LargeInteger deltas!! However, it is rather unlikely you will have
	enough memory to store the result (you'll need 256Mb or more)."

	<primitive: 37>
	^super bitShift: delta!

bitXor: anInteger
	"Answer an integer whose bits are the logical XOR of the
	receiver's bits and those of the argument, anInteger.

	Primitive Failure Reasons:
		0	-	The argument is not an Integer (large or small).
	"

	<primitive: 36>
	^self primitiveFailed!

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
				ifFalse: [self signBit * -1]].
	#todo	"Either remove or implement more efficiently (may be useful for Smalltalk LI algorithms"!

byteSize
	"Private - Answer the number of bytes in the receiver's 2's complement
	representation."

	^self basicSize!

digitAt: anInteger 
	"Answer the n'th byte of 2's complement representation of the receiver."

	"Implementation Note: As Dolphin's LargeIntegers are stored directly in 2's complement
	32-bit digits, we can make use of the standard byte accessing primitive, passing potential
	out of bounds accesses to the superclass implementation."

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

dwordAtOffset: anInteger
	"Private - Answer the unsigned 4 byte integer at offset (i.e. zero relative) 
	anInteger in the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - 4)."

	<primitive: 120>
	^self primitiveFailed!

dwordAtOffset: anInteger put: anObject 
	"Private - Store an unsigned 4 byte value at byte offset anInteger within the receiver. Note
	that this will fail unless the LargeInteger has first been marked as mutable."

	<primitive: 121>
	^anObject isInteger 
		ifTrue: 
			[| code |
			code := Processor activeProcess primitiveFailureCode.
			code < 2 
				ifTrue: 
					["Erroneous offset parameter"
					code == 0 
						ifTrue: [Error nonIntegerIndex: anInteger]
						ifFalse: 
							[self isImmutable 
								ifTrue: [Processor constWriteSignal signalWith: self]
								ifFalse: [self errorSubscriptBounds: anInteger]]]]
		ifFalse: [self dwordAtOffset: anInteger put: anObject asInteger]!

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

	"Implementation Note: It is assumed here that #hashBits must be >= SmallIntegerMax highBit.
	This is 30 on a 32-bit host, or 62 on a 64-bit host, and the minimum LargeInteger value is
	(2**30) or (2**62) respectively.."

	| shiftDistance highBits |
	self negative ifTrue: [^self negated hash negated].
	shiftDistance := self hashBits - self highBit + 1.
	highBits := (self bitShift: shiftDistance) + 1 bitShift: -1.
	^highBits highBit > self hashBits 
		ifTrue: [(highBits bitShift: -1) bitXor: (shiftDistance - 1) abs]
		ifFalse: [highBits bitXor: shiftDistance abs]!

intPtrAtOffset: anInteger put: anObject 
	"Private - Store anObject as a signed machine-word sized integer at anInteger offset in the receiver. anInteger must 
	be representable in a machine word. Uses the intPtrAtOffset:put: primitive. This is intended only as a way to initialize
	a new LargeInteger with a SmallInteger value."

	| value |
	<primitive: 183>
	value := anObject asInteger.
	value byteSize > VMConstants.IntPtrSize ifFalse: [^self errorCantHold: anObject].
	1 to: VMConstants.IntPtrSize
		do: [:index | self basicAt: anInteger + index put: (value digitAt: index)].
	^anObject!

isZero
	"Answer whether the receiver is zero.
	LargeIntegers cannot be zero, because there is a more compact representation
	(i.e. SmallInteger 0)."

	^false!

limbSize
	"Private - Answer the number of 32-bit limbs in the receiver."

	^self basicSize bitShift: -2!

multiplyByInteger: anInteger
	"Private - Answer the result of multiplying the receiver by the argument, anInteger.
	N.B. If we get in here, then anInteger must be small, in which case we just perform
	the arithmetic in reverse (at present the SmallInteger prim's cannot handle LargeInteger arguments,
	but the the LI prims can handle SmallInteger args).
	The primitive should not fail for an Integer argument, so we treat that as an error."

	<primitive: 29>
	^self primitiveFailed!

negated
	"Answer the negative value of the receiver.
	The primitive does not fail."

	<primitive: 39>
	^self bitInvert + 1!

normalize
	"Private - Answer the receiver in its minimal 2's complement representation.
	The answer may be the receiver, a compressed version of the receiver (without
	leading sign digits), or a SmallInteger."

	<primitive: 28>
	^self primitiveFailed!

printDecimalDigitsOn: aStream 
	"Private - Append the ASCII representation (radix 10) of the receiver to aStream. At least
	twice as fast as #basicPrintDigitsOn:base: for base 10."

	| quotient digits index |
	digits := ByteArray new: self basicSize * 3.
	index := 1.
	quotient := self.
	[quotient isImmediate] whileFalse: 
			[| quoAndRem |
			quoAndRem := quotient quoAndRem: 100.
			digits at: index put: (quoAndRem at: 2).
			index := index + 1.
			quotient := quoAndRem at: 1].
	quotient printOn: aStream.
	[(index := index - 1) > 0] whileTrue: 
			["Note that the compiler will fold the strings into a single literal"
			aStream
				nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: (digits at: index) // 10 + 1);
				nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: (digits at: index) \\ 10 + 1)]!

printDigitsOn: aStream base: anInteger 
	"Private - Recursively print the digits of the receiver in base anInteger to aStream.
	N.B. The receiver MUST be positive for this to work correctly."

	anInteger == 10 
		ifTrue: [self printDecimalDigitsOn: aStream]
		ifFalse: [self basicPrintDigitsOn: aStream base: anInteger]!

quoAndRem: aNumber
	"Private- Answer a two element array containing the integer quotient of 
	the receiver divided by aNumber with truncation toward zero (i.e. like C 
	integer division), and the corresponding remainder.
	
	Primitive Failure Reasons:
		0	- aNumber is not an Integer.
	"

	<primitive: 33>
	^aNumber quoAndRemFromInteger: self!

quoAndRemFromInteger: anInteger
	"Private - Answer a two element Array containing the quotient and remainder
	resulting from dividing the integer receiver into the argument, anInteger.
	Truncation is towards zero. 
	Implementation Note: We should normally only be here when attempting
	to divide a SmallInteger by a LargeInteger, the result of which, by the
	definition must be (0, <self>), since ANY normalized LargeInteger must be greater
	in absolute magnitude than any SmallInteger, EXCEPT the special case of the
	largest negative SmallInteger the absolute value of which is a LargeInteger."

	^(anInteger == VMConstants.SmallIntegerMin and: [self = ##(VMConstants.SmallIntegerMin negated)])
		ifTrue: [{-1. 0}]
		ifFalse: [{0. anInteger}]!

rem: operand
	"Answer the <number> remainder resulting from division of the receiver by
	the <number>, operand, with truncation toward zero; 
		e.g. 7 rem: 2 = 1, -7 rem: 2 = -1 (whereas -7 \\ 2 = 1)
	The answer is always of the same sign as the receiver, regardless of
	the sign of the argument."

	^(self quoAndRem: operand) basicAt: 2!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart 
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:

	Primitive Failure Reasons:
		0 	- fromStart is not a SmallInteger.
		1	- stop is not a SmallInteger.
		2	- start is not a SmallInteger.
		3	- aByteObject is not a byte object
		4	- 'from' or 'to' interval is out-of-bounds
	"

	<primitive: 142>
	^self primitiveFailed!

sdwordAtOffset: anInteger 
	"Private - Answers the signed 4 byte integer at byte offset anInteger in the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds."

	<primitive: 122>
	^self primitiveFailed!

signBit
	"Private - Answer the receiver's sign bit. This will be 0 for positive integers
	and 1 for negative integers."

	^(self basicAt: self basicSize) bitShift: -7!

subtractFromInteger: anInteger 
	"Private - Subtract the receiver from the known integer, anInteger
	and answer the result.
	N.B. The negated receiver may not be large if the receiver is VMConstants.SmallIntegerMax+1
	and therefore it is better to send #+ that #addToInteger:."

	^self negated + anInteger! !
!LargeInteger categoriesFor: #-!arithmetic!public! !
!LargeInteger categoriesFor: #*!arithmetic!public! !
!LargeInteger categoriesFor: #/!arithmetic!public! !
!LargeInteger categoriesFor: #//!arithmetic!public! !
!LargeInteger categoriesFor: #\\!arithmetic!public! !
!LargeInteger categoriesFor: #+!arithmetic!public! !
!LargeInteger categoriesFor: #<!comparing!public! !
!LargeInteger categoriesFor: #<=!comparing!public! !
!LargeInteger categoriesFor: #=!comparing!public! !
!LargeInteger categoriesFor: #>!comparing!public! !
!LargeInteger categoriesFor: #>=!comparing!public! !
!LargeInteger categoriesFor: #addToInteger:!double dispatch!private! !
!LargeInteger categoriesFor: #asFloat!converting!public! !
!LargeInteger categoriesFor: #bitAnd:!bit manipulation!public! !
!LargeInteger categoriesFor: #bitInvert!bit manipulation!public! !
!LargeInteger categoriesFor: #bitOr:!bit manipulation!public! !
!LargeInteger categoriesFor: #bitShift:!bit manipulation!public! !
!LargeInteger categoriesFor: #bitXor:!bit manipulation!public! !
!LargeInteger categoriesFor: #byteAt:!accessing!private! !
!LargeInteger categoriesFor: #byteSize!accessing!private! !
!LargeInteger categoriesFor: #digitAt:!accessing!public! !
!LargeInteger categoriesFor: #digitLength!accessing!public! !
!LargeInteger categoriesFor: #dwordAtOffset:!accessing!primitives!private! !
!LargeInteger categoriesFor: #dwordAtOffset:put:!accessing!primitives!private! !
!LargeInteger categoriesFor: #generality!coercing!private! !
!LargeInteger categoriesFor: #greaterThanInteger:!double dispatch!private! !
!LargeInteger categoriesFor: #hash!comparing!public! !
!LargeInteger categoriesFor: #intPtrAtOffset:put:!initializing!primitives!private! !
!LargeInteger categoriesFor: #isZero!public!testing! !
!LargeInteger categoriesFor: #limbSize!accessing!private! !
!LargeInteger categoriesFor: #multiplyByInteger:!double dispatch!private! !
!LargeInteger categoriesFor: #negated!arithmetic!public! !
!LargeInteger categoriesFor: #normalize!converting!private! !
!LargeInteger categoriesFor: #printDecimalDigitsOn:!printing!private! !
!LargeInteger categoriesFor: #printDigitsOn:base:!printing!private! !
!LargeInteger categoriesFor: #quoAndRem:!arithmetic!public! !
!LargeInteger categoriesFor: #quoAndRemFromInteger:!double dispatch!private! !
!LargeInteger categoriesFor: #rem:!arithmetic!public! !
!LargeInteger categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private! !
!LargeInteger categoriesFor: #sdwordAtOffset:!accessing!private! !
!LargeInteger categoriesFor: #signBit!private!testing! !
!LargeInteger categoriesFor: #subtractFromInteger:!double dispatch!private! !

!LargeInteger class methodsFor!

fromBytes: bytes 
	"Answer an instance of the receiver instantiated from the the byte object, bytes,
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

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new: anInteger
	"Private - Answer a new LargeInteger of the requested number of 32-bit digits."

	^self basicNew: (anInteger bitShift: 2)!

new64
	"Private - Answer a new 64-bit LargeInteger.
	N.B. The answer is not a valid LargeInteger since zero is a SmallInteger."

	^self basicNew: 8! !
!LargeInteger class categoriesFor: #fromBytes:!instance creation!public! !
!LargeInteger class categoriesFor: #fromSmallInteger:!instance creation!private! !
!LargeInteger class categoriesFor: #icon!constants!public! !
!LargeInteger class categoriesFor: #new:!instance creation!private! !
!LargeInteger class categoriesFor: #new64!instance creation!private! !

