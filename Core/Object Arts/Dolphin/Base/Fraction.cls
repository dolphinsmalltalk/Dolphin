"Filed out from Dolphin Smalltalk 7"!

Number subclass: #Fraction
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
	"Answer a <Float> approximating the receiver. Note that some precision may be lost - the
	result will be the closest floating point number to the receiver calculated using the IEEE
	754 round-to-nearest-even mode."

	| a b q r exponent floatExponent nBits ha hb hq q1 |
	a := numerator abs.
	b := denominator abs.
	ha := a highBit.
	hb := b highBit.

	"If both numerator and denominator can be represented exactly, then fastest thing to do is
	to use hardwired float division."
	nBits := Float precision + 1.
	(ha < nBits and: [hb < nBits]) ifTrue: [^numerator asFloat / denominator asFloat].

	"Try and obtain a mantissa with 54 bits by integer division. This is 53 bits of IEEE 754
	mantissa plus 1 bit for rounding. First guess is rough, we might get one more bit or one
	less."
	exponent := ha - hb - nBits.
	exponent > 0 ifTrue: [b := b bitShift: exponent] ifFalse: [a := a bitShift: exponent negated].
	q := a quo: b.
	r := a - (q * b).
	hq := q highBit.

	"Check for gradual underflow, in which case we should use less bits"
	floatExponent := exponent + hq.
	floatExponent >= Float emin ifFalse: [nBits := nBits + floatExponent - Float emin].

	"Use exactly nBits."
	hq > nBits 
		ifTrue: 
			[exponent := exponent + hq - nBits.
			r := (q bitAnd: (1 bitShift: hq - nBits) - 1) * b + r.
			q := q bitShift: nBits - hq].
	hq < nBits 
		ifTrue: 
			[exponent := exponent + hq - nBits.
			q1 := (r bitShift: nBits - hq) quo: b.
			q := (q bitShift: nBits - hq) bitAnd: q1.
			r := (r bitShift: nBits - hq) - (q1 * b)].


	"Check if we should round upward. The case of exact half (q bitAnd: 1) = 1 & (r isZero) will
	be handled by Integer>>asFloat."
	((q bitAnd: 1) isZero or: [r isZero]) ifFalse: [q := q + 1].

	"Finally build the float"
	^(self positive ifTrue: [q asFloat] ifFalse: [q asFloat negated]) timesTwoPower: exponent!

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

generality
	"Private - Answer the generality of the receiver."

	^30
!

greaterThanFloat: aFloat
	"Private - Answer whether the receiver is greater than the known Float, aFloat"

	^aFloat < self asFloat!

greaterThanFraction: aFraction
	"Private - Answer whether the receiver is greater than the known Fraction, aFraction"

	| negative |
	negative := aFraction negative.
	negative = self negative ifFalse: [ ^negative ].
	^aFraction numerator * denominator < 
		(numerator * aFraction denominator)!

greaterThanInteger: anInteger
	"Private - Answer whether the receiver is greater than the known integer, anInteger"

	^anInteger * denominator < numerator!

hash
	"Answer the <integer> hash value for the receiver."

	"Implementation Note: This should be the same hash value as the equivalent <Integer> of <Float>"

	^denominator = 1 
		ifTrue: [numerator hash]
		ifFalse: 
			[[self asFloat hash] on: FloatingPointException
				do: [:ex | numerator hash bitXor: denominator hash]]!

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

	div = 0 ifTrue: [^num divideByZero].
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

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

numerator: top denominator: bottom
	"Answer a <Fraction> with numerator and denominator,
	initialised to the <integer> arguments, top, and, bottom.
	It is assumed that the arguments are such that a normalised
	<Fraction> will result - use #normalisedNumerator:denominator if
	you're not sure and require the smallest possible denominator."

	^self basicNew numerator: top denominator: bottom!

rationalisedNumerator: numInteger denominator: divInteger
	"Answer a Fraction which is the rationalised form of numInteger
	divided by divInteger."

	| gcd denominator numerator |
	denominator := divInteger truncated abs.
	numerator := divInteger negative
		ifTrue: [numInteger truncated negated]
		ifFalse: [numInteger truncated].
	gcd := numerator gcd: denominator.
	denominator = gcd ifTrue: [^numerator // gcd].
	gcd == 1 ifTrue: [^self basicNew numerator: numerator denominator: denominator].
	^self basicNew numerator: numerator // gcd denominator: denominator // gcd!

readFrom: aStream
	"Instantiate a new instance of the receiver from aStream and answer it.
	Handles negative fractions with a leading minus sign.
	Does not handle NLS characters (e.g. thousand separators)"

	^(super readFrom: aStream) asFraction! !
!Fraction class categoriesFor: #icon!constants!public! !
!Fraction class categoriesFor: #numerator:denominator:!instance creation!public! !
!Fraction class categoriesFor: #rationalisedNumerator:denominator:!instance creation!public! !
!Fraction class categoriesFor: #readFrom:!instance creation!public! !

Fraction class methodProtocol: #'Fraction factory' attributes: #(#ansi #readOnly) selectors: #(#numerator:denominator:)!

