"Filed out from Dolphin Smalltalk 7"!

Number subclass: #Fraction
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Fraction guid: (GUID fromString: '{87b4c65b-026e-11d3-9fd7-00a0cc3e4a32}')!
Fraction comment: 'Instances of class Fraction represent rational numbers which are not integers, e.g. 3/4. They are always represented in the most reduced form possible. Fractions are usually created by a division operation between two integers where the numerator cannot be divided exactly the denominator. Unlike Float, Fraction has effectively limitless precision, and thus calculations involving Fractions do not suffer from rounding errors. This can be useful where absolute accuracy is required, but Fraction arithmetic is not supported directly by the CPU, and thus calculations are orders of magnitude slower.

Instance Variables:
	numerator		<integer>
	denominator	<integer>

'!
!Fraction categoriesForClass!Magnitude-Numbers! !
!Fraction methodsFor!

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

= anObject
	"Answer whether the receiver is numerically equivalent to the <Object>, anObject - i.e. whether the difference between the receiver and comparand is zero."

	^anObject understandsArithmetic and: [anObject equalToFraction: self]!

addToFloat: aFloat
	"Private - Add the receiver to the known Float, aFloat."

	^aFloat + self asFloat
!

addToFraction: aFraction
	"Private - Add the known Fraction, aFraction, to the receiver. This is obviously fastest
	if the receiver and aFraction have the same denominator"

	^denominator = aFraction denominator
		ifTrue: [ 
			Fraction
				rationalisedNumerator: numerator + aFraction numerator
				denominator: denominator ]
		ifFalse: [
			Fraction
				rationalisedNumerator: numerator * aFraction denominator + (aFraction numerator * denominator)
				denominator: denominator * aFraction denominator ]!

addToInteger: anInteger 
	"Private - Add the known integer, anInteger, to the receiver. There is no need
	to rationalise the result."

	^Fraction
		numerator: anInteger * denominator + numerator
		denominator: denominator!

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
	"Private - Answer the lower generality <ArithmeticValue>, anArithmeticValue,
	converted to a Fraction"

	^Fraction numerator: anArithmeticValue denominator: 1
!

denominator
	"Answer the smallest <integer> denominator of the receiver."

	^denominator!

displayOn: aStream
	"Append to the <puttableStream>, aStream, a <readableString> whose characters are 
	a representation of the receiver as a user would want to see it (in this case sans parenthesis)."
	
	aStream 
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

	^Fraction
		rationalisedNumerator: denominator * aFraction numerator
		denominator: numerator * aFraction denominator!

divideIntoInteger: anInteger
	"Private - Divide the receiver into the known integer, anInteger.
	Answer the result."

	^Fraction
		rationalisedNumerator: anInteger * denominator
		denominator: numerator!

equalToFloat: aFloat
	"Private - Answer whether the receiver is equal to the the known <Float>, aFloat. We are careful to avoid any loss of precision."

	^aFloat isFinite and: [aFloat asTrueFraction equalToFraction: self]!

equalToFraction: aFraction 
	"Private - Answer whether the receiver is equal to the known <Fraction>, aFraction."

	^numerator * aFraction denominator = (aFraction numerator * denominator)!

equalToInteger: anInteger
	"Private - Answer whether the receiver is equal to the known <Integer>, anInteger."

	^anInteger * denominator = numerator!

generality
	"Private - Answer the generality of the receiver."

	^30
!

greaterThanFloat: aFloat
	"Private - Answer whether the receiver is greater than the known Float, aFloat"

	| fpclass |
	fpclass := aFloat fpClass.
	^((fpclass anyMask: Float.FpClassFinite) and: [self greaterThanFraction: aFloat asTrueFraction])
		or: [fpclass anyMask: Float.FpClassNegative]!

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

	^Fraction
		rationalisedNumerator: numerator * aFraction numerator
		denominator: denominator * aFraction denominator
!

multiplyByInteger: anInteger
	"Private - Multiply the receiver by the known integer, anInteger.
	Answer the result."

	^Fraction
		rationalisedNumerator: anInteger * numerator
		denominator: denominator!

negated
	"Answer an instance of class Fraction which is the negative of the receiver."

	^Fraction
		numerator: self numerator negated
		denominator: self denominator
!

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
		ifTrue: [ 
			Fraction
				rationalisedNumerator: aFraction numerator - numerator
				denominator: denominator ]
		ifFalse: [
			Fraction
				rationalisedNumerator: aFraction numerator * denominator - (numerator * aFraction denominator)
				denominator: denominator * aFraction denominator ]!

subtractFromInteger: anInteger 
	"Private - Subtract the receiver from the known integer, anInteger.
	There is no need to rationalise the result."

	^Fraction
		numerator: anInteger * denominator - numerator
		denominator: denominator!

truncated
	"Answer the receiver as a kind of Integer truncating the fraction part."

	^numerator quo: denominator! !
!Fraction categoriesFor: #-!arithmetic!public! !
!Fraction categoriesFor: #*!arithmetic!public! !
!Fraction categoriesFor: #/!arithmetic!public! !
!Fraction categoriesFor: #//!arithmetic!public! !
!Fraction categoriesFor: #+!arithmetic!public! !
!Fraction categoriesFor: #<!comparing!public! !
!Fraction categoriesFor: #=!comparing!public! !
!Fraction categoriesFor: #addToFloat:!double dispatch!private! !
!Fraction categoriesFor: #addToFraction:!double dispatch!private! !
!Fraction categoriesFor: #addToInteger:!double dispatch!private! !
!Fraction categoriesFor: #asFloat!converting!public! !
!Fraction categoriesFor: #asFraction!converting!public! !
!Fraction categoriesFor: #coerce:!coercing!private! !
!Fraction categoriesFor: #denominator!accessing!public! !
!Fraction categoriesFor: #displayOn:!printing!public! !
!Fraction categoriesFor: #divideIntoFloat:!double dispatch!private! !
!Fraction categoriesFor: #divideIntoFraction:!double dispatch!private! !
!Fraction categoriesFor: #divideIntoInteger:!double dispatch!private! !
!Fraction categoriesFor: #equalToFloat:!double dispatch!private! !
!Fraction categoriesFor: #equalToFraction:!double dispatch!private! !
!Fraction categoriesFor: #equalToInteger:!double dispatch!private! !
!Fraction categoriesFor: #generality!coercing!private! !
!Fraction categoriesFor: #greaterThanFloat:!double dispatch!private! !
!Fraction categoriesFor: #greaterThanFraction:!double dispatch!private! !
!Fraction categoriesFor: #greaterThanInteger:!double dispatch!private! !
!Fraction categoriesFor: #hash!comparing!public! !
!Fraction categoriesFor: #isFraction!public!testing! !
!Fraction categoriesFor: #isLiteral!public!testing! !
!Fraction categoriesFor: #isZero!public!testing! !
!Fraction categoriesFor: #multiplyByFloat:!double dispatch!private! !
!Fraction categoriesFor: #multiplyByFraction:!double dispatch!private! !
!Fraction categoriesFor: #multiplyByInteger:!double dispatch!private! !
!Fraction categoriesFor: #negated!arithmetic!public! !
!Fraction categoriesFor: #numerator!accessing!public! !
!Fraction categoriesFor: #numerator:denominator:!accessing!private! !
!Fraction categoriesFor: #printOn:!printing!public! !
!Fraction categoriesFor: #reciprocal!arithmetic!public! !
!Fraction categoriesFor: #squared!mathematical!public! !
!Fraction categoriesFor: #subtractFromFloat:!double dispatch!private! !
!Fraction categoriesFor: #subtractFromFraction:!double dispatch!private! !
!Fraction categoriesFor: #subtractFromInteger:!double dispatch!private! !
!Fraction categoriesFor: #truncated!public!truncation and round off! !

!Fraction class methodsFor!

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
!Fraction class categoriesFor: #numerator:denominator:!instance creation!public! !
!Fraction class categoriesFor: #rationalisedNumerator:denominator:!instance creation!public! !
!Fraction class categoriesFor: #readFrom:!instance creation!public! !

Fraction class methodProtocol: #'Fraction factory' attributes: #(#ansi #readOnly) selectors: #(#numerator:denominator:)!

