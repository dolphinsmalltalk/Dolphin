"Filed out from Dolphin Smalltalk"!

Core.Number subclass: #'Core.Fraction'
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Fraction guid: (Core.GUID fromString: '{87b4c65b-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Fraction comment: 'Instances of class Fraction represent rational numbers which are not integers, e.g. 3/4. They are always represented in the most reduced form possible. Fractions are usually created by a division operation between two integers where the numerator cannot be divided exactly the denominator. Unlike Float, Fraction has effectively limitless precision, and thus calculations involving Fractions do not suffer from rounding errors. This can be useful where absolute accuracy is required, but Fraction arithmetic is not supported directly by the CPU, and thus calculations are orders of magnitude slower.

Instance Variables:
	numerator		<integer>
	denominator	<integer>

'!
!Core.Fraction categoriesForClass!Magnitude-Numbers! !
!Core.Fraction methodsFor!

- aNumber
	"Answer the difference between the receiver and aNumber."

	^aNumber subtractFromFraction: self!

* aNumber
	"Answer the result of multiplying the receiver by aNumber."

	^aNumber multiplyByFraction: self!

/ operand
	"Answer the result of dividing the receiver by the <number>, operand.
	Raise a <ZeroDivide> exception if the operand is zero."

	^operand divideIntoFraction: self!

// aNumber
	"Answer the integer quotient after dividing the receiver by aNumber
	with truncation towards negative infinity."

	^(numerator * aNumber denominator) //
		(denominator * aNumber numerator)!

+ aNumber
	"Answer sum of the receiver and aNumber."

	^aNumber addToFraction: self!

< aNumber
	"Answer whether the receiver is less than the argument, aNumber"

	^aNumber greaterThanFraction: self!

<= aNumber
	"Answer whether the receiver is less than or equal to the argument, aNumber."

	^aNumber greaterOrEqualToFraction: self!

= anObject
	"Answer whether the receiver is numerically equivalent to the <Object>, anObject - i.e. whether the difference between the receiver and comparand is zero."

	^anObject understandsArithmetic and: [anObject equalToFraction: self]!

addToFloat: aFloat
	"Private - Add the receiver to the known Float, aFloat."

	^aFloat + self asFloat
!

addToFraction: aFraction
	"Private - Answer the <Fraction> result of adding the receiver to the known <Fraction> argument."

	"This is obviously fastest if the receiver and aFraction have the same denominator."

	^denominator = aFraction denominator
		ifTrue: [Fraction rationalisedNumerator: numerator + aFraction numerator denominator: denominator]
		ifFalse: 
			[Fraction
				rationalisedNumerator: numerator * aFraction denominator + (aFraction numerator * denominator)
				denominator: denominator * aFraction denominator]!

addToInteger: anInteger
	"Private - Answer the <Fraction> result of adding the known <integer> to the receiver. There is no need to rationalise the result."

	^Fraction numerator: anInteger * denominator + numerator denominator: denominator!

asFloat
	"Answer a Float that closely approximates the value of the receiver. This implementation
	will answer the closest floating point number to the receiver. In case of a tie, it will use
	the IEEE 754 round to nearest even mode. In case of overflow, it will answer +/- Float
	infinity, or, if the overflow exceptions is unmasked, raise a FloatingPointException."

	| a b mantissa exponent hasTruncatedBits lostBit n ha hb hm |
	a := numerator abs.
	b := denominator.	"denominator is always positive"
	ha := a highBit.
	hb := b highBit.

	"Number of bits to keep in mantissa plus one to handle rounding."
	n := 1 + Float.Precision.

	"If both numerator and denominator are represented exactly in floating point number,
	then fastest thing to do is to use hardwired float division."
	(ha < n and: [hb < n]) ifTrue: [^numerator asFloat / denominator asFloat].

	"Shift the fraction by a power of two exponent so as to obtain a mantissa with n bits.
	First guess is rough, the mantissa might have n+1 bits."
	exponent := ha - hb - n.
	exponent >= 0 ifTrue: [b := b bitShift: exponent] ifFalse: [a := a bitShift: exponent negated].
	mantissa := a quo: b.
	hasTruncatedBits := a > (mantissa * b).
	hm := mantissa highBit.

	"Check for gradual underflow, in which case the mantissa will loose bits.
	Keep at least one bit to let underflow preserve the sign of zero."
	lostBit := Float.EMin - (exponent + hm - 1).
	lostBit > 0 ifTrue: [n := n - lostBit max: 1].

	"Remove excess bits in the mantissa."
	hm > n
		ifTrue: 
			[exponent := exponent + hm - n.
			hasTruncatedBits := hasTruncatedBits or: [mantissa anyBitSetFrom: 1 to: hm - n].
			mantissa := mantissa bitShift: n - hm].

	"Check if mantissa must be rounded upward.
	The case of tie (mantissa odd & hasTruncatedBits not)
	will be handled by Integer>>asFloat."
	(hasTruncatedBits and: [mantissa odd]) ifTrue: [mantissa := mantissa + 1].
	^(self positive ifTrue: [mantissa asFloat] ifFalse: [mantissa asFloat negated])
		timesTwoPower: exponent!

asFraction
	"Answer a Fraction approximating the receiver."

	^self
!

coerce: anArithmeticValue
	"Private - Coerce the <arithmeticValue> argument (which is assumed to be of a lower generality than the receiver) to a <Fraction>."

	^Fraction numerator: anArithmeticValue denominator: 1!

denominator
	"Answer the smallest <integer> denominator of the receiver."

	^denominator!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		print: numerator;
		nextPut: $/;
		print: denominator!

divideIntoFloat: aFloat
	"Private - Divide the receiver into the known Float, aFloat.
	Answer the result."

	^aFloat / self asFloat!

divideIntoFraction: aFraction
	"Private - Divide the receiver into the known Fraction, aFraction.
	Answer the result."

	^Fraction rationalisedNumerator: denominator * aFraction numerator
		denominator: numerator * aFraction denominator!

divideIntoInteger: anInteger
	"Private - Divide the receiver into the known integer, anInteger.
	Answer the result."

	^Fraction rationalisedNumerator: anInteger * denominator denominator: numerator!

equalToFloat: aFloat
	"Private - Answer whether the receiver is equal to the known <Float>, aFloat. We are careful to avoid any loss of precision."

	^aFloat isFinite and: [aFloat asTrueFraction equalToFraction: self]!

equalToFraction: aFraction 
	"Private - Answer whether the receiver is equal to the known <Fraction>, aFraction."

	^numerator * aFraction denominator = (aFraction numerator * denominator)!

equalToInteger: anInteger
	"Private - Answer whether the receiver is equal to the known <Integer>, anInteger."

	^anInteger * denominator = numerator!

equalToScaledDecimal: aScaledDecimal
	"Private - Answer whether the receiver is equal to the known <ScaledDecimal>, aScaledDecimal."

	^self equalToFraction: aScaledDecimal asFraction!

generality
	"Private - Answer the generality of the receiver."

	^30
!

greaterOrEqualToFloat: aFloat
	"Private - Answer whether the receiver is greater than or equal to the known <Float> argument."

	| fpclass negativeArg |
	negativeArg := (fpclass := aFloat fpClass) anyMask: Float.FpClassNegative.
	(fpclass anyMask: Float.FpClassFinite)
		ifFalse: 
			["aFloat is a NaN, -∞ or ∞, so obviously we are only greater if it is -∞."
			^negativeArg].
	numerator < 0 ~~ negativeArg
		ifTrue: 
			["Different signs - as the receiver cannot be zero, it is greater if the argument is negative"
			^negativeArg].
	"Fast cases eliminated, we need to compare fractions"
	^self greaterOrEqualToFraction: aFloat asTrueFraction!

greaterOrEqualToFraction: aFraction
	"Private - Answer whether the receiver is greater than the known Fraction, aFraction"

	^numerator * aFraction denominator >= (aFraction numerator * denominator)!

greaterOrEqualToInteger: anInteger
	"Private - Answer whether the receiver is greater than the known integer, anInteger"

	^anInteger * denominator <= numerator!

greaterThanFloat: aFloat
	"Private - Answer whether the receiver is greater than the known Float argument."

	"Implementation Note: The FP classification checks are expanded inline for performance reasons, but essentially this is:
	"

	| fpclass negativeArg |
	negativeArg := (fpclass := aFloat fpClass) anyMask: Float.FpClassNegative.
	(fpclass anyMask: Float.FpClassFinite)
		ifFalse: 
			["aFloat is NaN, -∞ or ∞, so obviously we are only greater if it is -∞."
			^negativeArg].
	numerator < 0 ~~ negativeArg
		ifTrue: 
			["Different signs - as the receiver cannot be zero, it is greater if the argument is negative"
			^negativeArg].
	"Fast cases eliminated, we need to compare fractions"
	^self greaterThanFraction: aFloat asTrueFraction!

greaterThanFraction: aFraction
	"Private - Answer whether the receiver is greater than the known Fraction, aFraction"

	^numerator * aFraction denominator > (aFraction numerator * denominator)!

greaterThanInteger: anInteger
	"Private - Answer whether the receiver is greater than the known integer, anInteger"

	^anInteger * denominator < numerator!

hash
	"Answer the <integer> hash value for the receiver."

	"Implementation Note: This should be the same hash value as the equivalent <Integer>, if
	integral, or <Float>, if exactly representable as a Float."

	| float |
	denominator isPowerOfTwo
		ifTrue: 
			["Possibly representable as a Float, if not too large"
			denominator == 1 ifTrue: [^numerator hash].
			float := [self asFloat] on: FloatingPointException do: [:ex | Float.Infinity].
			float isFinite ifTrue: [^float hash]].
	^numerator hash bitXor: denominator hash!

isFraction
	"Answer true if receiver is an instance of class Fraction, else answer false."

	^true
!

isLiteral
	"Answer whether the receiver the receiver has a literal representation which
	is recognised by the Compiler"

	^false!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

isZero
	"Answer whether the receiver is equal to its class' zero"

	^numerator isZero!

multiplyByFloat: aFloat
	"Private - Multiply the receiver by the known Float, aFloat.
	Answer the result."

	^aFloat * self asFloat!

multiplyByFraction: aFraction
	"Private - Multiply the receiver by the known Fraction, aFraction.
	Answer the result."

	^Fraction rationalisedNumerator: numerator * aFraction numerator
		denominator: denominator * aFraction denominator!

multiplyByInteger: anInteger
	"Private - Multiply the receiver by the known integer, anInteger.
	Answer the result."

	^Fraction rationalisedNumerator: anInteger * numerator denominator: denominator!

negated
	"Answer an instance of class Fraction which is the negative of the receiver."

	^Fraction numerator: self numerator negated denominator: self denominator!

negative
	"Answer whether the receiver is negative."

	"Implementation Note: The denominator is always positive."

	^numerator < 0!

numerator
	"Answer the <integer> numerator of the receiver reduced to its lowest common denominator."

	^numerator!

numerator: num denominator: div
	"Private - The numerator and denominator of the receiver are set to the num and div
	arguments respectively. Intended for instance initialisation."

	div == 0 ifTrue: [^num divideByZero].
	div negative
		ifTrue: 
			[numerator := num negated.
			denominator := div negated]
		ifFalse: 
			[numerator := num.
			denominator := div].
	self isImmutable: true!

printOn: aStream
	"Append a short textual description of the receiver to aStream."
	
	"The ANSI standard states that the printString of a Fraction is not bracketed, but historically it has been.
	 We provide displayString for end-user format."

	aStream 
		nextPut: $(;
		print: numerator;
		nextPut: $/;
		print: denominator;
		nextPut: $)
!

reciprocal
	"Answer the reciprocal of the receiver by dividing the denominator by the numerator."

	| n d |
	n := numerator positive 
				ifTrue: 
					[d := numerator.
					denominator]
				ifFalse: 
					[d := numerator negated.
					denominator negated].
	d == 1 ifTrue: [^n] ifFalse: [^self class numerator: n denominator: d]!

squared
	"Answer the receiver multiplied by the receiver."

	^self class
		numerator: numerator squared denominator: denominator squared
!

subtractFromFloat: aFloat
	"Private - Subtract the receiver from the known Float, aFloat."

	^aFloat - self asFloat
!

subtractFromFraction: aFraction
	"Private - Subtract the receiver from the known Fraction, aFraction. This is obviously fastest
	if the receiver and aFraction have the same denominator"

	^denominator = aFraction denominator
		ifTrue: [Fraction rationalisedNumerator: aFraction numerator - numerator denominator: denominator]
		ifFalse: 
			[Fraction
				rationalisedNumerator: aFraction numerator * denominator - (numerator * aFraction denominator)
				denominator: denominator * aFraction denominator]!

subtractFromInteger: anInteger
	"Private - Subtract the receiver from the known integer, anInteger.
	There is no need to rationalise the result."

	^Fraction numerator: anInteger * denominator - numerator denominator: denominator!

truncated
	"Answer the receiver as a kind of Integer truncating the fraction part."

	^numerator quo: denominator! !
!Core.Fraction categoriesForMethods!
-!arithmetic!public! !
*!arithmetic!public! !
/!arithmetic!public! !
//!arithmetic!public! !
+!arithmetic!public! !
<!comparing!public! !
<=!comparing!public! !
=!comparing!public! !
addToFloat:!double dispatch!private! !
addToFraction:!double dispatch!private! !
addToInteger:!double dispatch!private! !
asFloat!converting!public! !
asFraction!converting!public! !
coerce:!coercing!private! !
denominator!accessing!public! !
displayOn:!printing!public! !
divideIntoFloat:!double dispatch!private! !
divideIntoFraction:!double dispatch!private! !
divideIntoInteger:!double dispatch!private! !
equalToFloat:!double dispatch!private! !
equalToFraction:!double dispatch!private! !
equalToInteger:!double dispatch!private! !
equalToScaledDecimal:!double dispatch!private! !
generality!coercing!private! !
greaterOrEqualToFloat:!double dispatch!private! !
greaterOrEqualToFraction:!double dispatch!private! !
greaterOrEqualToInteger:!double dispatch!private! !
greaterThanFloat:!double dispatch!private! !
greaterThanFraction:!double dispatch!private! !
greaterThanInteger:!double dispatch!private! !
hash!comparing!public! !
isFraction!public!testing! !
isLiteral!public!testing! !
isSelfEvaluating!public!testing! !
isZero!public!testing! !
multiplyByFloat:!double dispatch!private! !
multiplyByFraction:!double dispatch!private! !
multiplyByInteger:!double dispatch!private! !
negated!arithmetic!public! !
negative!public!testing! !
numerator!accessing!public! !
numerator:denominator:!accessing!private! !
printOn:!printing!public! !
reciprocal!arithmetic!public! !
squared!mathematical!public! !
subtractFromFloat:!double dispatch!private! !
subtractFromFraction:!double dispatch!private! !
subtractFromInteger:!double dispatch!private! !
truncated!public!truncation and round off! !
!

!Core.Fraction class methodsFor!

numerator: top denominator: bottom
	"Answer a <Fraction> with numerator and denominator,
	initialised to the <integer> arguments, top, and, bottom.
	It is assumed that the arguments are such that a normalised
	<Fraction> will result - use #normalisedNumerator:denominator if
	you're not sure and require the smallest possible denominator."

	^self basicNew numerator: top denominator: bottom!

rationalisedNumerator: numInteger denominator: divInteger
	"Answer a Fraction which is the rationalised form of numInteger divided by divInteger."

	| gcd denominator numerator |
	divInteger negative
		ifTrue: 
			[denominator := 0 - divInteger truncated.
			numerator := 0 - numInteger truncated]
		ifFalse: 
			[denominator := divInteger truncated.
			numerator := numInteger truncated].
	gcd := numerator gcd: denominator.
	denominator = gcd ifTrue: [^numerator // gcd].
	gcd == 1 ifTrue: [^self basicNew numerator: numerator denominator: denominator].
	^self basicNew numerator: numerator // gcd denominator: denominator // gcd!

readFrom: aStream
	"Instantiate a new instance of the receiver from aStream and answer it.
	Handles negative fractions with a leading minus sign.
	Does not handle NLS characters (e.g. thousand separators)"

	^(super readFrom: aStream) asFraction! !
!Core.Fraction class categoriesForMethods!
numerator:denominator:!instance creation!public! !
rationalisedNumerator:denominator:!instance creation!public! !
readFrom:!instance creation!public! !
!

Core.Fraction class methodProtocol: #'Fraction factory' attributes: #(#ansi #readOnly) selectors: #(#numerator:denominator:)!

