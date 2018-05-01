"Filed out from Dolphin Smalltalk 7"!

Number variableByteSubclass: #Float
	instanceVariableNames: ''
	classVariableNames: 'EMax EMin EMinDenormalized FMax FMin FMinDenormalized FpClassDenormal FpClassFinite FpClassInfinite FpClassNaN FpClassNegative FpClassNormal FpClassStrictlyPositive FpClassZero Infinity InvalidOperationFlag Ln2 MantissaHighBit MantissaMask NaN NegativeInfinity Precision SignificantDifference'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Float guid: (GUID fromString: '{87b4c65a-026e-11d3-9fd7-00a0cc3e4a32}')!
Float addClassConstant: 'EMax' value: 1023!
Float addClassConstant: 'EMin' value: -1022!
Float addClassConstant: 'EMinDenormalized' value: -1074!
Float addClassConstant: 'FMax' value: 1.7976931348623157e308!
Float addClassConstant: 'FMin' value: 2.2250738585072014e-308!
Float addClassConstant: 'FMinDenormalized' value: 5.0e-324!
Float addClassConstant: 'FpClassDenormal' value: 144!
Float addClassConstant: 'FpClassFinite' value: 504!
Float addClassConstant: 'FpClassInfinite' value: 516!
Float addClassConstant: 'FpClassNaN' value: 3!
Float addClassConstant: 'FpClassNegative' value: 60!
Float addClassConstant: 'FpClassNormal' value: 264!
Float addClassConstant: 'FpClassStrictlyPositive' value: 896!
Float addClassConstant: 'FpClassZero' value: 96!
Float addClassConstant: 'InvalidOperationFlag' value: 1!
Float addClassConstant: 'Ln2' value: 0.6931471805599453!
Float addClassConstant: 'MantissaHighBit' value: 4503599627370496!
Float addClassConstant: 'MantissaMask' value: 4503599627370495!
Float addClassConstant: 'Precision' value: 53!
Float addClassConstant: 'SignificantDifference' value: 1.0e-9!
Float comment: 'Float is the class of double precision floating point Numbers (64-bit) in IEEE-754 format.'!
!Float categoriesForClass!Magnitude-Numbers! !
!Float methodsFor!

- aNumber
	"Answer the result of subtracting the argument, aNumber, from the receiver.The primitive
	will fail if aNumber is not a SmallInteger of Float, but does not set the failure code. May
	also raise a floating point exception."

	<primitive: 161>
	^aNumber subtractFromFloat: self!

* aNumber
	"Answer the result of multiplying the receiver by the argument, aNumber. The primitive will
	fail if aNumber is not a SmallInteger of Float, but does not set the failure code. May also
	raise a floating point exception."

	<primitive: 164>
	^aNumber multiplyByFloat: self!

/ operand
	"Answer the result of dividing the receiver by the <number>, operand. Raise a <ZeroDivide>
	exception if the operand is zero. The primitive will fail in two circumstances:
	1) if aNumber is not a <SmallInteger> or a <Float>
	 2) The receiver is zero, and the relevant exceptions are masked (divide-by-zero and, if
	the receiver is 0, invalid).
	The primitives does not set a failure code."

	<primitive: 165>
	^operand divideIntoFloat: self!

+ aNumber
	"Answer the result of adding aNumber to the receiver.The primitive will fail if aNumber is
	not a SmallInteger of Float, but does not set the failure code. May also raise a floating
	point exception."

	<primitive: 160>
	^aNumber addToFloat: self!

< aNumber
	"Answer true if the receiver is less than aNumber. This relational operator is implemented
	as a primitive, and >, <=, and >= are expressed in terms of it. The primitive will fail if
	aNumber is not a SmallInteger of Float, but does not set the failure code. May also raise a
	floating point exception."

	<primitive: 162>
	^aNumber greaterThanFloat: self
!

<= operand
	"Answer whether the receiver is less than or equal to the <magnitude>, operand."

	"Implementation Note: Superclass implementation does not work correctly for comparisons
	against NaN, which must always be false (except for ~=)."

	<primitive: 214>
	^(self isNaN or: [operand < self]) not!

= comperand
	"Answer whether the receiver is numerically equivalent to the argument, comperand (e.g. 1 =
	1.0 is true).The primitive will fail if aNumber is not a SmallInteger or a Float, but does
	not set the failure code. May also raise a floating point exception."

	<primitive: 47>
	^super = comperand!

> aNumber
	"Answer true if the receiver is greater than aNumber. The primitive will fail if aNumber is
	not a SmallInteger of Float, but does not set the failure code. May also raise a floating
	point exception."

	<primitive: 45>
	^aNumber < self!

>= operand
	"Answer whether the receiver is greater than or equal to the <magnitude>, operand."

	"Implementation Note: Superclass implementation does not work correctly for comparisons
	against NaN, which must always be false (except for ~=)."

	<primitive: 46>
	^(self isNaN or: [operand > self]) not!

abs
	"Answer a Number that is the absolute value - positive magnitude - of the receiver."

	<primitive: 205>
	^super abs!

absPrintExactlyOn: aStream base: base
	"Private - Print the receiver's value on a stream in the given base.  Assumes that the receiver is strictly
	positive; negative numbers, zero, and NaNs have already been handled elsewhere.
	Based upon the algorithm outlined in:
	Robert G. Burger and R. Kent Dybvig
	Printing Floating Point Numbers Quickly and Accurately
	ACM SIGPLAN 1996 Conference on Programming Language Design and Implementation
	June 1996.
	This version guarantees that the printed representation exactly represents the receiver's value
	by using exact integer arithmetic, and is based on the same method in Squeak."

	| significand exp baseExpEstimate r s mPlus mMinus scale roundingIncludesLimits d tc1 tc2 fixedFormat decPointCount slowbit shead |
	significand := self significandAsInteger.
	roundingIncludesLimits := significand even.
	exp := self exponent - ##(Precision - 1) max: EMinDenormalized.
	baseExpEstimate := (self exponent * base asFloat reciprocalLogBase2 - 1.0e-10) ceiling.
	exp >= 0
		ifTrue: 
			[significand ~= Float.MantissaHighBit
				ifTrue: 
					[r := significand bitShift: 1 + exp.
					s := 2.
					mPlus := mMinus := 1 bitShift: exp]
				ifFalse: 
					[r := significand bitShift: 2 + exp.
					s := 4.
					mPlus := 2 * (mMinus := 1 bitShift: exp)]]
		ifFalse: 
			[(exp = EMinDenormalized or: [significand ~= Float.MantissaHighBit])
				ifTrue: 
					[r := significand bitShift: 1.
					s := 1 bitShift: 1 - exp.
					mPlus := mMinus := 1]
				ifFalse: 
					[r := significand bitShift: 2.
					s := 1 bitShift: 2 - exp.
					mPlus := 2.
					mMinus := 1]].
	baseExpEstimate >= 0
		ifTrue: [s := s * (base raisedToInteger: baseExpEstimate)]
		ifFalse: 
			[scale := base raisedToInteger: baseExpEstimate negated.
			r := r * scale.
			mPlus := mPlus * scale.
			mMinus := mMinus * scale].
	(r + mPlus >= s and: [roundingIncludesLimits or: [r + mPlus > s]])
		ifTrue: [baseExpEstimate := baseExpEstimate + 1]
		ifFalse: 
			[r := r * base.
			mPlus := mPlus * base.
			mMinus := mMinus * base].
	(fixedFormat := baseExpEstimate between: -3 and: 6)
		ifTrue: 
			[decPointCount := baseExpEstimate.
			baseExpEstimate <= 0 ifTrue: [aStream nextPutAll: ('0.000000' truncateTo: 2 - baseExpEstimate)]]
		ifFalse: [decPointCount := 1].
	slowbit := 1 - s lowBit.
	shead := s bitShift: slowbit.
	
	[d := (r bitShift: slowbit) // shead.
	r := r - (d * s).
	(tc1 := r <= mMinus and: [roundingIncludesLimits or: [r < mMinus]])
		| (tc2 := r + mPlus >= s and: [roundingIncludesLimits or: [r + mPlus > s]])]
			whileFalse: 
				[aStream nextPut: (Character digitValue: d).
				r := r * base.
				mPlus := mPlus * base.
				mMinus := mMinus * base.
				(decPointCount := decPointCount - 1) = 0 ifTrue: [aStream nextPut: $.]].
	tc2 ifTrue: [(tc1 not or: [r * 2 >= s]) ifTrue: [d := d + 1]].
	aStream nextPut: (Character digitValue: d).
	decPointCount > 0
		ifTrue: 
			[decPointCount - 1 timesRepeat: [aStream nextPut: $0].
			aStream nextPutAll: '.0'].
	fixedFormat
		ifFalse: 
			[aStream nextPut: $e.
			aStream nextPutAll: (baseExpEstimate - 1) printString]!

absPrintExactlyOn: aStream base: base decimalPlaces: placesDesired showTrailingFractionalZeros: showtrailingZeros
	"Private - Print the receiver's value on a stream in the given base with fixed number of digits after floating point.
	When placesDesired are beyond Float precision, zeroes are appended.
	When showtrailingZeros is false, the trailing zeroes after decimal point will be omitted.
	If all fractional digits are zeros, the decimal point is omitted too.
	Assumes that the receiver is strictly positive; negative numbers, zero, and NaNs have already been handled elsewhere.
	Based upon the algorithm outlined in:
	Robert G. Burger and R. Kent Dybvig
	Printing Floating Point Numbers Quickly and Accurately
	ACM SIGPLAN 1996 Conference on Programming Language Design and Implementation
	June 1996.."

	| significand exp baseExpEstimate r s mPlus mMinus scale roundingLowIncludesLimits roundingHighIncludesLimits d tc1 tc2 decPointCount slowbit shead delta |
	significand := self significandAsInteger.
	exp := self exponent - ##(Precision - 1) max: EMinDenormalized.
	exp >= 0
		ifTrue: 
			[significand ~= MantissaHighBit
				ifTrue: 
					[r := significand bitShift: 1 + exp.
					s := 2.
					mPlus := mMinus := 1 bitShift: exp]
				ifFalse: 
					[r := significand bitShift: 2 + exp.
					s := 4.
					mPlus := 2 * (mMinus := 1 bitShift: exp)]]
		ifFalse: 
			[(exp = EMinDenormalized or: [significand ~= MantissaHighBit])
				ifTrue: 
					[r := significand bitShift: 1.
					s := 1 bitShift: 1 - exp.
					mPlus := mMinus := 1]
				ifFalse: 
					[r := significand bitShift: 2.
					s := 1 bitShift: 2 - exp.
					mPlus := 2.
					mMinus := 1]].
	delta := s / 2 / (base raisedTo: placesDesired).
	roundingLowIncludesLimits := (mMinus < delta and: 
					[mMinus := delta.
					true])
				or: [significand even].
	roundingHighIncludesLimits := (mPlus < delta and: 
					[mPlus := delta.
					true])
				or: [significand even].
	baseExpEstimate := (self exponent * base asFloat reciprocalLogBase2 - 1.0e-10) ceiling.
	baseExpEstimate >= 0
		ifTrue: [s := s * (base raisedToInteger: baseExpEstimate)]
		ifFalse: 
			[scale := base raisedToInteger: baseExpEstimate negated.
			r := r * scale.
			mPlus := mPlus * scale.
			mMinus := mMinus * scale].
	(r + mPlus >= s and: [roundingHighIncludesLimits or: [r + mPlus > s]])
		ifTrue: [baseExpEstimate := baseExpEstimate + 1]
		ifFalse: 
			[r := r * base.
			mPlus := mPlus * base.
			mMinus := mMinus * base].
	decPointCount := baseExpEstimate.
	baseExpEstimate <= 0
		ifTrue: 
			[placesDesired + baseExpEstimate <= 0
				ifTrue: 
					[aStream nextPut: $0.
					(showtrailingZeros and: [placesDesired > 0])
						ifTrue: 
							[aStream
								nextPut: $.;
								nextPutAll: (String new: placesDesired withAll: $0)].
					^self].
			aStream
				nextPutAll: '0.';
				nextPutAll: (String new: 0 - baseExpEstimate withAll: $0)].
	slowbit := 1 - s lowBit.
	shead := s bitShift: slowbit.
	
	[d := (r bitShift: slowbit) // shead.
	r := r - (d * s).
	(tc1 := r <= mMinus and: [roundingLowIncludesLimits or: [r < mMinus]])
		| (tc2 := r + mPlus >= s and: [roundingHighIncludesLimits or: [r + mPlus > s]])]
			whileFalse: 
				[aStream nextPut: (Character digitValue: d).
				r := r * base.
				mPlus := mPlus * base.
				mMinus := mMinus * base.
				(decPointCount := decPointCount - 1) = 0 ifTrue: [aStream nextPut: $.]].
	tc2 ifTrue: [(tc1 not or: [r * 2 >= s]) ifTrue: [d := d + 1]].
	aStream nextPut: (Character digitValue: d).
	decPointCount > 0
		ifTrue: 
			[decPointCount - 1 timesRepeat: [aStream nextPut: $0].
			(showtrailingZeros and: [placesDesired > 0])
				ifTrue: 
					[aStream
						nextPut: $.;
						nextPutAll: (String new: placesDesired withAll: $0)]]
		ifFalse: 
			[(showtrailingZeros and: [placesDesired + decPointCount > 1])
				ifTrue: [aStream nextPutAll: (String new: placesDesired + decPointCount - 1 withAll: $0)]]!

absPrintOn: aStream base: base digitCount: digitCount
	"Private - Print me in the given base, using digitCount significant figures.
	Note that it is assumed the receiver is strictly positive."

	| fuzz x exp q fBase scale logScale xi |
	fBase := base asFloat.
	exp := self floorLog: fBase.
	scale := 1.0.
	logScale := 0.
	[(x := fBase raisedTo: exp + logScale) = 0] whileTrue: 
			[scale := scale * fBase.
			logScale := logScale + 1].
	x := self * scale / x.
	fuzz := fBase raisedTo: 1 - digitCount.
	"round the last digit to be printed"
	x := 0.5 * fuzz + x.
	x >= fBase
		ifTrue: 
			["check if rounding has unnormalized x"
			x := x / fBase.
			exp := exp + 1].
	(exp < 6 and: [exp > -4])
		ifTrue: 
			["decimal notation"
			q := 0.
			exp < 0 ifTrue: [1 to: 1 - exp do: [:i | aStream nextPut: ('0.0000' at: i)]]]
		ifFalse: 
			["scientific notation"
			q := exp.
			exp := 0].
	[x >= fuzz] whileTrue: 
			["use fuzz to track significance"
			xi := x truncated.
			aStream nextPut: (Character digitValue: xi).
			x := (x - xi asFloat) * fBase.
			fuzz := fuzz * fBase.
			exp := exp - 1.
			exp = -1 ifTrue: [aStream nextPut: $.]].
	[exp >= -1] whileTrue: 
			[aStream nextPut: $0.
			exp := exp - 1.
			exp = -1 ifTrue: [aStream nextPut: $.]].
	q ~= 0
		ifTrue: 
			[aStream nextPut: $e.
			q printOn: aStream]!

addToFloat: aFloat
	"Private - Answer the result of adding the receiver to the known Float, aFloat.
	If we get here, then the floating point subtraction must have failed due to some 
	floating point exception."

	^self primitiveFailed!

addToFraction: aFraction
	"Private - Answer the result of adding the receiver to the known fraction, aFraction, 
	by coercing the less general of it and the receiver."

	^aFraction asFloat + self!

addToInteger: anInteger
	"Private - Add the known integer, anInteger, to the receiver, converting anInteger 
	to a Float. Answer the result"

	^anInteger asFloat + self!

arcCos
	"Answer a <Float> which is the inverse cosine of the receiver in radians. If the receiver is
	not in the range -1 .. 1 (non-inclusive) then a FloatingPointException will be raised
	(unless the current FP exception mask includes CRTConstants._EM_INVALID)."

	<primitive: 198>
	^self primitiveFailed!

arcSin
	"Answer a <Float> which is the inverse sine of the receiver in radians. If the receiver is
	not in the range -1 .. 1 (non-inclusive) then a FloatingPointException will be raised
	(unless the current FP exception mask includes CRTConstants._EM_INVALID)."

	<primitive: 196>
	^self primitiveFailed!

arcTan
	"Answer a <Float> which is the inverse tangent of the receiver in radians."

	<primitive: 197>
	^self primitiveFailed!

arcTan: aNumber
	"Answer the arc-tangent of the receiver/aFloat in radians."

	"The primitive only fails if the argument is not a <Float> or <SmallInteger>"

	<primitive: 199>
	^self arcTan: aNumber asFloat!

asApproximateFraction
	"Answer a <rational> (e.g. Fraction or Integer) approximating the receiver.
	This conversion uses the continued fraction method to approximate a 
	floating point number."

	| numerator1 denominator1 numerator2 denominator2 integerPart fractionPart |
	numerator1 := self truncated.
	denominator1 := 1.
	numerator2 := 1.
	denominator2 := 0.
	integerPart := numerator1.
	fractionPart := self fractionPart.
	[fractionPart = 0] whileFalse: 
			[| newD temp |
			newD := 1.0 / fractionPart.
			integerPart := newD truncated.
			fractionPart := newD fractionPart.
			temp := numerator2.
			numerator2 := numerator1.
			numerator1 := numerator1 * integerPart + temp.
			temp := denominator2.
			denominator2 := denominator1.
			denominator1 := integerPart * denominator1 + temp.
			"Is ratio past float precision?"
			1.0e14 < denominator1 
				ifTrue: 
					[^numerator2 = 0.0 
						ifTrue: [Fraction numerator: numerator1 denominator: denominator1]
						ifFalse: [Fraction numerator: numerator2 denominator: denominator2]]].
	^denominator1 = 1 
		ifTrue: [numerator1]
		ifFalse: [Fraction numerator: numerator1 denominator: denominator1]!

asFloat
	"Answer the receiver as a floating point number"

	^self
!

asFraction
	"Answer an <integer> or <fraction> approximating the receiver."

	^self asApproximateFraction!

asTrueFraction
	"Answer a <rational> that precisely represents the binary fractional value of the receiver
	using all available bits of the double precision IEEE floating point representation. Note
	that because <Float> is an imprecise representation, the result may have more precision than
	appropriate. For example the decimal number 0.1 cannot be represented precisely as a binary
	floating point number, and hence the <Float> representation is itself only approximate. When
	<Float> representation of 0.1 is converted using this method the result is a precisely
	equivalent Fraction that is very close to (1/10), but not actually equal to 0.1."

	" Extract the bits of an IEEE double float "

	| shifty sign expPart exp fraction fractionPart |
	self isFinite ifFalse: [self error: ('Cannot represent <1p> as a fraction' expandMacrosWith: self)].
	shifty := VMLibrary default makeLargeUnsigned: self.

	" Extract the sign and the biased exponent "
	sign := (shifty bitShift: -63) == 0 ifTrue: [1] ifFalse: [-1].
	expPart := (shifty bitShift: -52) bitAnd: 16r7FF.

	" Extract fractional part; answer 0 if this is a true 0.0 value "
	fractionPart := shifty bitAnd: 16r000FFFFFFFFFFFFF.
	(expPart == 0 and: [fractionPart = 0]) ifTrue: [^0].

	"Add implied leading 1 into fraction"
	fraction := expPart = 0
				ifTrue: [fractionPart bitShift: 1]
				ifFalse: [fractionPart bitOr: 16r0010000000000000].

	"Unbias exponent: 16r3FF is bias; 52 is fraction width"
	exp := ##(16r3FF + 52) - expPart.

	"Form the result. When exp>52, the exponent is adjusted by the number of trailing zero bits
	in the fraction to minimize the (huge) time otherwise spent in #gcd:. "
	^exp negative
		ifTrue: [sign * fraction bitShift: exp negated]
		ifFalse: 
			[| zeroBitsCount |
			zeroBitsCount := fraction lowBit - 1.
			exp := exp - zeroBitsCount.
			exp <= 0
				ifTrue: 
					[zeroBitsCount := zeroBitsCount + exp.
					sign * fraction bitShift: zeroBitsCount negated]
				ifFalse: 
					[Fraction numerator: (sign * fraction bitShift: zeroBitsCount negated) denominator: (1 bitShift: exp)]]!

bitRepresentation
	"Answer an <integer> representing the raw binary bit representation of the receiver. This is
	IEEE 754 64-bit double precision, with a sign bit, 11 exponent bits, and a 52-bit mantissa
	with implied leading bit."

	^self qwordAtOffset: 0!

ceiling
	"Answer the integer nearest the receiver toward positive infinity."

	<primitive: 208>
	^self asTrueFraction ceiling!

coerce: anArithmeticValue
	"Private - Answer the lower generality ArithmeticValue, anArithmeticValue, 
	converted to a Float."

	^anArithmeticValue asFloat
!

cos
	"Answer a <Float> which is the cosine of the receiver, which is treated as an angle in
	radians. May raise FloatingPointException, depending on the value of the receiver and the
	current FP exception mask."

	<primitive: 195>
	^self primitiveFailed!

divideIntoFloat: aFloat
	"Private - Answer the result of dividing the receiver by the known Float, aFloat. 
	If we get here, then the floating point division must have failed due to a floating
	point Divide-by-Zero or Invalid Operation exception that was continued."

	^aFloat isZero
		ifTrue: 
			["Invalid operation"
			NaN]
		ifFalse: 
			["Divide-by-zero"
			self sign == aFloat sign
				ifTrue: 
					["Same sign, result positive"
					Infinity]
				ifFalse: 
					["Different sign, result negative."
					NegativeInfinity]]!

divideIntoFraction: aFraction
	"Private - Answer the result of dividing the receiver into the known fraction, aFraction, 
	by coercing the less general of it and the receiver."

	^aFraction asFloat / self!

divideIntoInteger: anInteger
	"Private - Answer the result of dividing the receiver into the known integer, anInteger, 
	by coercing the less general of it and the receiver."

	^anInteger asFloat / self!

equals: aNumber
	"Answer whether the receiver is numerically equivalent to aNumber, within the
	default numerical precision."

	| max |
	^(max := self abs max: aNumber abs) <= SignificantDifference
		or:  [(self - aNumber) abs < (SignificantDifference * max)]
!

exp
	"Answer the exponential of the receiver. The primitive should not fail."

	<primitive: 201>
	^self primitiveFailed!

exponent
	"Answer the <SmallInteger> which is the exponent part of the receiver's floating point representation."

	<primitive: 209>
	self >= 1.0 ifTrue: [^self floorLog: 2].
	self > 0.0
		ifTrue: 
			[| positive |
			"0<x<1"
			positive := (1.0 / self) exponent.
			self = (1.0 / (1.0 timesTwoPower: positive))
				ifTrue: [^positive negated]
				ifFalse: [^positive negated - 1]].
	self isZero ifTrue: [^-1].
	^self negated exponent!

floor
	"Answer the integer nearest the receiver toward negative infinity."

	<primitive: 207>
	^self asTrueFraction floor!

floorLog10
	"Answer the base 10 exponent of the receiver (an Integer between -308 and 308)."

	^self log floor!

fpClass
	"Private - Answer a set of flags from the CRTConstants _FPCLASS_xxx enumeration describing
	the receiver's floating point classification, e.g. as negative or positive, finite or
	infinite, normal or denormal, etc."

	<primitive: 211>
	^self primitiveFailed!

fractionPart
	"Answer a <Float> representing the fractional part of the receiver."

	<primitive: 212>
	^self - self truncated asFloat!

generality
	"Private - Answer the generality of the receiver. Floats are the highest generality numbers 
	(though they do not offer infinite precision)."

	^40
!

greaterOrEquals: aNumber 
	"Answer whether the receiver is numerically greater than or equal to aNumber, within the
	default numerical precision."

	(self equals: aNumber) ifTrue: [^true].
	^self > aNumber!

greaterThanFraction: aFraction
	"Private - Answer whether the receiver is greater than the known Fraction, aFraction."

	^aFraction asFloat < self!

greaterThanInteger: anInteger
	"Private - Answer whether the receiver is greater than the known Integer, anInteger."

	^self isNaN not and: [anInteger asFloat < self]!

hash
	"Answer the <SmallInteger> hash value for the receiver. If the receiver is a whole
	number, then the hash must be the same as that for the equivalent integer."

	| bits |
	(self isFinite and: [self fractionPart = 0.0]) ifTrue: [^self truncated hash].
	bits := self bitRepresentation.
	^((bits bitShift: -40) bitAnd: 16r0000FFFF) + ((bits bitAnd: 16r00FFFF00) bitShift: -8)!

integerPart
	"Answer a <Float> representing the whole integer part of the receiver."

	<primitive: 213>
	^self - self fractionPart!

isDenormal
	"Answer whether the receiver represents a number too small to represent in the normalised
	range - i.e. it has leading zeroes in the mantissa."

	^self fpClass anyMask: FpClassDenormal!

isFinite
	"Answer whether the receiver represents a finite (non-infinite, non-NaN), value."

	^self fpClass anyMask: FpClassFinite!

isInfinite
	"Answer whether the receiver represents infinity (positive or negative)."

	^self fpClass anyMask: FpClassInfinite!

isLiteral
	"Answer whether the receiver has a literal string representation that can be compiled to
	create an exact copy of it. All instances have literal representations except positive and
	negative infinity and NaN, i.e. all finite values."

	^self isFinite!

isNaN
	"Answer whether the receiver is Not a Number."

	^self fpClass anyMask: FpClassNaN!

isZero
	"Answer whether the receiver is zero (positive or negative in the case of <Float>"

	^self fpClass anyMask: FpClassZero!

lessOrEquals: aNumber 
	"Answer whether the receiver is numerically less than or equal to aNumber, within the
	default numerical precision."

	(self equals: aNumber) ifTrue: [^true].
	^self < aNumber!

ln
	"Answer the a Float which is the natural logarithm of the receiver.
	May raise a <FloatingPointException> (e.g. if the receiver is negative)."

	<primitive: 200>
	^self primitiveFailed!

log
	"Answer a <Float> which is the base 10 logarithm of the receiver.
	May raise a FloatingPointException (e.g. if the receiver is negative).

	Implementation Note: Although we could implement this in terms of #ln,
	that tends to lead to unfortunate precision errors such as '1000.0 log truncated'
	evaluating to 2. It is also faster to use the log10() function directly."

	<primitive: 203>
	^self primitiveFailed!

multiplyByFloat: aFloat
	"Private - Answer the result of multiplying the known Float, aFloat, by the receiver. 
	If we get here, then the floating point multiplication must have failed due to some floating
	point exception."

	^self primitiveFailed!

multiplyByFraction: aFraction
	"Private - Multiply the receiver by the known fraction, aFraction, by converting anInteger 
	to a Float. Answer the result"

	^aFraction asFloat * self!

multiplyByInteger: anInteger
	"Private - Multiply the receiver by the known integer, anInteger, by converting anInteger 
	to a Float. Answer the result"

	^anInteger asFloat * self!

negated
	"Answer a <Float> which is the negation of the receiver."

	<primitive: 210>
	^-1.0 * self!

negative
	"Answer whether the receiver is negative.
	Implementation Note: High-bit of IEEE float is sign bit."

	^(self basicAt: 8) anyMask: 128!

printOn: aPuttableStream
	"Append the exact string representation of the receiver to the <puttableStream>, target. The
	representation used is a valid literal representation for floating point numbers, recognised
	by the Smalltalk compiler, except for the 3 special cases of inifinity, negative infinity,
	and not-a-number (NaN)."

	self printOn: aPuttableStream base: 10!

printOn: aStream base: anInteger
	"Print the receiver with the minimal number of digits that describes it unambiguously in the
	specified base. This way, every two different Float will have a different printed
	representation. More over, every Float can be reconstructed from its printed representation
	with #readFrom:."

	| classification |
	classification := self fpClass.
	(classification anyMask: FpClassNaN)
		ifTrue: 
			[aStream
				display: self class;
				nextPut: $.;
				nextPutAll: 'NaN'.
			^self].
	(classification anyMask: FpClassInfinite)
		ifTrue: 
			[aStream
				display: self class;
				nextPut: $.;
				nextPutAll: ((classification anyMask: FpClassNegative)
							ifTrue: ['NegativeInfinity']
							ifFalse: ['Infinity']).
			^self].
	(classification anyMask: FpClassNegative) ifTrue: [aStream nextPut: $-].
	(classification anyMask: FpClassZero)
		ifTrue: [aStream nextPutAll: '0.0']
		ifFalse: [self absPrintExactlyOn: aStream base: anInteger]!

printOn: aStream decimalPlaces: anInteger
	"Append the printed representation of the receiver to the <puttableStream>, aStream, rounded
	to the <integer> number of decimal places, anInteger."

	| classification |
	classification := self fpClass.
	(classification anyMask: FpClassNaN)
		ifTrue: 
			[aStream
				display: self class;
				nextPut: $.;
				nextPutAll: 'NaN'.
			^self].
	(classification anyMask: FpClassInfinite)
		ifTrue: 
			[aStream
				display: self class;
				nextPut: $.;
				nextPutAll: ((classification anyMask: FpClassNegative)
							ifTrue: ['NegativeInfinity']
							ifFalse: ['Infinity']).
			^self].
	(classification anyMask: FpClassNegative) ifTrue: [aStream nextPut: $-].
	(classification anyMask: FpClassZero)
		ifTrue: 
			[aStream nextPut: $0.
			anInteger > 0
				ifTrue: 
					[aStream nextPut: $..
					aStream next: anInteger put: $0]]
		ifFalse: 
			[self
				absPrintExactlyOn: aStream
				base: 10
				decimalPlaces: anInteger
				showTrailingFractionalZeros: true]!

printOn: aStream significantFigures: anInteger
	"Append the printed representation of the receiver to aStream with anInteger significant
	figures. Ensure that there is always a digit following the decimal point, even if zero."

	| classification abs |
	classification := self fpClass.
	(classification anyMask: FpClassNaN)
		ifTrue: 
			[aStream
				display: self class;
				nextPut: $.;
				nextPutAll: 'NaN'.
			^self].
	(classification anyMask: FpClassInfinite)
		ifTrue: 
			[aStream
				display: self class;
				nextPut: $.;
				nextPutAll: ((classification anyMask: FpClassNegative)
							ifTrue: ['NegativeInfinity']
							ifFalse: ['Infinity']).
			^self].
	abs := (classification anyMask: FpClassNegative)
				ifTrue: 
					[aStream nextPut: $-.
					self negated]
				ifFalse: [self].
	(classification anyMask: FpClassZero)
		ifTrue: [aStream nextPutAll: '0.0']
		ifFalse: 
			[abs
				absPrintOn: aStream
				base: 10
				digitCount: anInteger]!

qwordAtOffset: anInteger
	<primitive: 191>
	^self primitiveFailed!

raisedTo: operand
	"Answer a <Float> which is the receiver raised to the power of the <number>
	argument, operand.
	Note: ANSI standard says that it is an error for the receiver to be negative, but I 
	think that is bogus (unless the operand is non-integral). This implementation will, 
	however, raise an error (a ZeroDivide in fact, but ANSI doesn't specify the precise 
	exception) if the receiver is zero and the argument not strictly positive)."

	<primitive: 206>
	^self raisedTo: operand asFloat!

reciprocalLogBase2
	^self = 10.0 ifTrue: [##(Ln2 / 10.0 ln)] ifFalse: [Ln2 / self ln]!

rounded
	"Answer the <integer> nearest the receiver."

	^self fractionPart abs < 0.5
		ifTrue: [^self truncated]
		ifFalse: [^self truncated + self sign rounded]!

sign
	"Answer the <integer> sign of the receiver:
		1 if the receiver is greater than 0, 
		-1 if less than 0
		0 if equal to 0."

	| classification |
	classification := self fpClass.
	(classification anyMask: FpClassStrictlyPositive) ifTrue: [^1].
	"Handle IEEE-754 negative-zero by reporting a sign of -1"
	(classification anyMask: FpClassNegative) ifTrue: [^-1].
	^0!

significandAsInteger
	"Answer the mantissa of a Float shifted so as to have the unit of least precision equal to 1.
	For exceptional values, infinity and NaN, just answer the mantissa bits."

	| mantissaBits |
	mantissaBits := (self qwordAtOffset: 0) bitAnd: MantissaMask.
	^(self fpClass anyMask: FpClassNormal)
		ifTrue: 
			["Add in the implied leading 1"
			mantissaBits bitOr: MantissaHighBit]
		ifFalse: 
			["Answer the bit pattern as is"
			mantissaBits]!

sin
	"Answer a <Float> which is the sine of the receiver, which is treated as an angle in
	radians. May raise a <FloatingPointException>, depending on the value of the receiver and
	the current FP exception mask."

	<primitive: 193>
	^self primitiveFailed!

sqrt
	"Answer the Float which is the square root of the receiver.
	Raises a FloatingPointExceptoin if the receiver is negative."

	<primitive: 202>
	^self primitiveFailed!

subtractFromFloat: aFloat
	"Private - Answer the result of subtracting the receiver from the known Float, aFloat. 
	If we get here, then the floating point subtraction must have failed due to some floating
	point exception."

	^self primitiveFailed!

subtractFromFraction: aFraction
	"Private - Answer the result of subtracting the receiver from the known fraction, aFraction."

	^aFraction asFloat - self!

subtractFromInteger: anInteger
	"Private - Subtract the known integer, anInteger, from the receiver, converting anInteger 
	to a Float. Answer the result"

	^anInteger asFloat - self!

tan
	"Answer a <Float> which is the tangent of the receiver, which is treated as an angle in
	radians. May raise FloatingPointException, depending on the value of the receiver and the
	current FP exception mask."

	<primitive: 194>
	^self primitiveFailed!

timesTwoPower: aNumber
	"Answer the receiver times two to the power of the argument, aNumber.
	The primitive only fails if the argument is not a <SmallInteger> or a <Float>."

	<primitive: 204>
	^self * (2.0 raisedToInteger: aNumber asInteger)!

truncated
	"Answer the <integer> nearest the receiver toward zero. Note that for many large floats the
	answer may be reported to more digits of precision that the floating point receiver was
	capable of representing (there are only about 15 digits of precision in a double)."

	"The primitive fails if the receiver is not finite, or more than 64-bits are required to
	represent its value as an integer. The failure code is not set. Depending on the FP
	exception mask, may also raise an FP exception."

	<primitive: 166>
	"Implementation Note: Rather than calculate the integer approximation by a series of
	divisions (as in versions of Dolphin prior to 3.02), a process which was both very slow for
	large Floats and also prone to error, we use precise #asTrueFraction."
	^self asTrueFraction truncated
! !
!Float categoriesFor: #-!arithmetic!public! !
!Float categoriesFor: #*!arithmetic!public! !
!Float categoriesFor: #/!arithmetic!public! !
!Float categoriesFor: #+!arithmetic!public! !
!Float categoriesFor: #<!comparing!public! !
!Float categoriesFor: #<=!comparing!public! !
!Float categoriesFor: #=!comparing!public! !
!Float categoriesFor: #>!comparing!public! !
!Float categoriesFor: #>=!comparing!public! !
!Float categoriesFor: #abs!mathematical!public! !
!Float categoriesFor: #absPrintExactlyOn:base:!printing!private! !
!Float categoriesFor: #absPrintExactlyOn:base:decimalPlaces:showTrailingFractionalZeros:!printing!private! !
!Float categoriesFor: #absPrintOn:base:digitCount:!printing!private! !
!Float categoriesFor: #addToFloat:!double dispatch!private! !
!Float categoriesFor: #addToFraction:!double dispatch!private! !
!Float categoriesFor: #addToInteger:!double dispatch!private! !
!Float categoriesFor: #arcCos!mathematical!public! !
!Float categoriesFor: #arcSin!mathematical!public! !
!Float categoriesFor: #arcTan!mathematical!public! !
!Float categoriesFor: #arcTan:!mathematical!public! !
!Float categoriesFor: #asApproximateFraction!converting!public! !
!Float categoriesFor: #asFloat!converting!public! !
!Float categoriesFor: #asFraction!converting!public! !
!Float categoriesFor: #asTrueFraction!converting!public! !
!Float categoriesFor: #bitRepresentation!accessing!private! !
!Float categoriesFor: #ceiling!public!truncation and round off! !
!Float categoriesFor: #coerce:!coercing!private! !
!Float categoriesFor: #cos!mathematical!public! !
!Float categoriesFor: #divideIntoFloat:!double dispatch!private! !
!Float categoriesFor: #divideIntoFraction:!double dispatch!private! !
!Float categoriesFor: #divideIntoInteger:!double dispatch!private! !
!Float categoriesFor: #equals:!comparing!public! !
!Float categoriesFor: #exp!mathematical!public! !
!Float categoriesFor: #exponent!accessing!public! !
!Float categoriesFor: #floor!public!truncation and round off! !
!Float categoriesFor: #floorLog10!mathematical!public! !
!Float categoriesFor: #fpClass!helpers!private! !
!Float categoriesFor: #fractionPart!accessing!public! !
!Float categoriesFor: #generality!coercing!private! !
!Float categoriesFor: #greaterOrEquals:!comparing!public! !
!Float categoriesFor: #greaterThanFraction:!double dispatch!private! !
!Float categoriesFor: #greaterThanInteger:!double dispatch!private! !
!Float categoriesFor: #hash!comparing!public! !
!Float categoriesFor: #integerPart!accessing!public! !
!Float categoriesFor: #isDenormal!public!testing! !
!Float categoriesFor: #isFinite!public!testing! !
!Float categoriesFor: #isInfinite!public!testing! !
!Float categoriesFor: #isLiteral!public!testing! !
!Float categoriesFor: #isNaN!public!testing! !
!Float categoriesFor: #isZero!public!testing! !
!Float categoriesFor: #lessOrEquals:!comparing!public! !
!Float categoriesFor: #ln!mathematical!public! !
!Float categoriesFor: #log!mathematical!public! !
!Float categoriesFor: #multiplyByFloat:!double dispatch!private! !
!Float categoriesFor: #multiplyByFraction:!double dispatch!private! !
!Float categoriesFor: #multiplyByInteger:!double dispatch!private! !
!Float categoriesFor: #negated!public! !
!Float categoriesFor: #negative!public!testing! !
!Float categoriesFor: #printOn:!printing!public! !
!Float categoriesFor: #printOn:base:!printing!public! !
!Float categoriesFor: #printOn:decimalPlaces:!printing!public! !
!Float categoriesFor: #printOn:significantFigures:!printing!public! !
!Float categoriesFor: #qwordAtOffset:!accessing!private! !
!Float categoriesFor: #raisedTo:!mathematical!public! !
!Float categoriesFor: #reciprocalLogBase2!mathematical!public! !
!Float categoriesFor: #rounded!public!truncation and round off! !
!Float categoriesFor: #sign!public!testing! !
!Float categoriesFor: #significandAsInteger!accessing!public! !
!Float categoriesFor: #sin!mathematical!public! !
!Float categoriesFor: #sqrt!mathematical!public! !
!Float categoriesFor: #subtractFromFloat:!double dispatch!private! !
!Float categoriesFor: #subtractFromFraction:!double dispatch!private! !
!Float categoriesFor: #subtractFromInteger:!double dispatch!private! !
!Float categoriesFor: #tan!mathematical!public! !
!Float categoriesFor: #timesTwoPower:!mathematical!public! !
!Float categoriesFor: #truncated!public!truncation and round off! !

!Float class methodsFor!

denormalized
	"Answer whether the characterized floating point representation allows denormalized
	values."

	^(Processor activeProcess fpControl bitAnd: ##(CRTConstants._MCW_DN | CRTConstants._EM_DENORMAL))
		= CRTConstants._EM_DENORMAL!

e
	"Answer a <Float> representing the irrational number, 'e'
		Float e
	"

	^##(1 exp)!

emax
	"Answer an <integer> representing the largest exponent
	of the characterized floating point representation."

	"Implementation Note: This value is that needed to correctly calculate 
	#fmax by the expression on p141 of the ANSI Smalltalk standard, 
	but the IEEE 754 double-precision value for emax is +1023."

	^EMax!

emin
	"Answer an <integer> representing the smallest exponent of the characterized floating point
	representation."

	"Implementation Note: The IEEE 754 double-precision value for emin is -1022."

	^EMin!

epsilon
	"Answer a <Float> representing the minimum relative spacing
	in the characterized floating point representation.

		Float epsilon = (self radix asFloat raisedTo: (1 - self precision))
	"

	^2.2204460492503131e-016
!

exceptionMask
	"Answer the floating point exception mask which is active in the currently executing
	<Process>, This is a combination of flags from the CRTConstants _EM_XXX enumeration:

		_EM_DENORMAL 	- denormalized inputs
		_EM_INEXACT		- inexact result.
		_EM_INVALID		- invalid FP operations such as sqrt(-1)
		_EM_OVERFLOW	- result overflow, e.g. Float fmax*2
		_EM_UNDERFLOW	- result underflows normalized range
		_EM_ZERODIVIDE	- division by zero
	
	Where exceptions would have been raised that are masked, the computation will yield a
	continuation value. This will be an infinity value for overflow and division by zero, NaN for
	invalid operations, a denormalized number or zero for underflow."

	^Processor activeProcess fpControl bitAnd: CRTConstants._MCW_EM!

exceptionMask: anInteger
	"Set the floating point exception mask which is active in the currently executing
	<Process>. See #exceptionMask for further information. Answers the previous mask."

	Processor activeProcess setFpControl: anInteger mask: CRTConstants._MCW_EM!

fmax
	"Answer a <Float> representing the largest value
	allowed by the characterized floating point representation."

	^FMax!

fmin
	"Answer a <Float> representing the smallest value
	allowed by the characterized floating point representation."

	^self denormalized
		ifTrue: [self fminDenormalized]
		ifFalse: [self fminNormalized]!

fminDenormalized
	"Answer a <Float> representing the smallest denormalized value
	allowed by the characterized floating point representation."

	^FMinDenormalized!

fminNormalized
	"Answer a <Float> representing the smallest normalized value
	allowed by the characterized floating point representation."

	^FMin!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

infinity
	"Answer a <Float> representing positive infinity, which in practice is any value larger than FMax."

	^Infinity!

initialize
	"Private - Initialize the class variables of the receiver
		Float initialize
	"

	| fpeMask fmax emin eminDenorm mantissaBits mantissaHighBit |
	#(#FloatD #FloatE #FloatQ) do: [:each | Smalltalk at: each ifAbsentPut: [self]].
	emin := -1022.
	self addClassConstant: 'EMin' value: emin.
	self addClassConstant: 'EMax' value: 1023.
	self addClassConstant: 'Ln2' value: 0.6931471805599453.
	eminDenorm := -1074.
	self addClassConstant: 'EMinDenormalized' value: eminDenorm.
	mantissaBits := 52.
	self addClassConstant: 'Precision' value: mantissaBits + 1.
	self addClassConstant: 'SignificantDifference' value: 1.0e-9.
	self assert: [SignificantDifference >= self epsilon].
	mantissaHighBit := 1 << mantissaBits.
	"The mantissa has an implied leading bit for numbers in the normal range"
	self addClassConstant: 'MantissaMask' value: mantissaHighBit - 1.
	self addClassConstant: 'MantissaHighBit' value: mantissaHighBit.
	fmax := 1.7976931348623157e308.
	self addClassConstant: 'FMax' value: fmax.
	self addClassConstant: 'FMin' value: (1.0 timesTwoPower: emin).
	self addClassConstant: 'FMinDenormalized' value: (1.0 timesTwoPower: eminDenorm).
	"Mask out overflow/invalid while we generate the infinity/NaN constants."
	fpeMask := self exceptionMask.
	self exceptionMask: (fpeMask maskSet: CRTConstants._EM_OVERFLOW | CRTConstants._EM_INVALID).
	
	[| infinity |
	infinity := fmax * fmax.
	self addClassConstant: 'Infinity' value: infinity.
	self addClassConstant: 'NegativeInfinity' value: infinity * -1.
	self addClassConstant: 'NaN' value: infinity - infinity]
			ensure: [self exceptionMask: fpeMask].
	"Classification groups"
	self addClassConstant: 'FpClassInfinite'
		value: CRTConstants._FPCLASS_NINF | CRTConstants._FPCLASS_PINF.
	self addClassConstant: 'FpClassStrictlyPositive'
		value: CRTConstants._FPCLASS_PD | CRTConstants._FPCLASS_PN | CRTConstants._FPCLASS_PINF.
	self addClassConstant: 'FpClassNegative'
		value: CRTConstants._FPCLASS_ND | CRTConstants._FPCLASS_NN | CRTConstants._FPCLASS_NINF
				| CRTConstants._FPCLASS_NZ.
	self addClassConstant: 'FpClassZero' value: CRTConstants._FPCLASS_NZ | CRTConstants._FPCLASS_PZ.
	self addClassConstant: 'FpClassNaN' value: CRTConstants._FPCLASS_QNAN | CRTConstants._FPCLASS_SNAN.
	"Denormalized numbers - non-zero but with leading zeroes in the mantissa"
	self addClassConstant: 'FpClassDenormal' value: CRTConstants._FPCLASS_PD | CRTConstants._FPCLASS_ND.
	"Non-zero, normals"
	self addClassConstant: 'FpClassNormal' value: CRTConstants._FPCLASS_NN | CRTConstants._FPCLASS_PN.
	"Finite numbers (anything other than infinites or NaNs)"
	self addClassConstant: 'FpClassFinite'
		value: CRTConstants._FPCLASS_NN | CRTConstants._FPCLASS_ND | CRTConstants._FPCLASS_NZ
				| CRTConstants._FPCLASS_PZ | CRTConstants._FPCLASS_PD
				| CRTConstants._FPCLASS_PN!

maxExponent
	"Private - The maximum allowed decimal exponent (power of 10) in the literal Float form."

	^308!

maxLiteralIntegerExponent
	"Private - The maximum allowed exponent (power of 10) in the literal integer form '<int>e<powerOf10>'
	when the result will be converted to a Float."

	^self maxExponent!

nan
	"Answer a <Float> representing an invalid valule."

	^NaN!

negativeInfinity
	"Answer a <Float> representing negative infinity, which in practice is any value larger than -FMax."

	^NegativeInfinity!

negativeZero
	"Answer the IEEE 754 representation for negative zero"

	^-0.0!

new
	"Answer a new instance of the receiver."

	^self basicNew: 8
!

one
	"Answer the receiver's representation of one."

	^1.0!

onStartup
	"Private - Re-initialize the receiver on session startup"

	self reset!

pi
	"Answer a <Float> representing 'pi'."

	^3.14159265358979323846264338327950288!

precision
	"Answer an <integer> representing the precision (the number of bits in the mantissa) 
	of the characterized floating point representation. Note that the actual number of
	bits stored is 52. The normalized representation means that the high bit is always one
	and need not be stored."

	^Precision!

radix
	"Answer an <integer> representing the radix
	of the characterized floating point representation."

	^2!

readFrom: aStream
	"Instantiate a new instance of the receiver from aStream and answer it.
	Handles negative integers with a leading minus sign.
	Does not handle NLS characters (e.g. thousand separators and decimal separators
	other than $.)."

	^(super readFrom: aStream) asFloat!

reset
	"Reset the floating point support. Win32 resets the exception mask to a standard value
	every time an exception occurs, so this must be sent after each FloatingPointException."

	Processor activeProcess resetFloatingPoint!

statusFlags
	^CRTLibrary default _statusfp!

zero
	"Answer the receiver's representation of zero."

	^0.0! !
!Float class categoriesFor: #denormalized!public!testing! !
!Float class categoriesFor: #e!constants!public! !
!Float class categoriesFor: #emax!constants!public! !
!Float class categoriesFor: #emin!constants!public! !
!Float class categoriesFor: #epsilon!constants!public! !
!Float class categoriesFor: #exceptionMask!public! !
!Float class categoriesFor: #exceptionMask:!public! !
!Float class categoriesFor: #fmax!constants!public! !
!Float class categoriesFor: #fmin!constants!public! !
!Float class categoriesFor: #fminDenormalized!constants!public! !
!Float class categoriesFor: #fminNormalized!constants!public! !
!Float class categoriesFor: #icon!constants!public! !
!Float class categoriesFor: #infinity!public! !
!Float class categoriesFor: #initialize!development!initializing!private! !
!Float class categoriesFor: #maxExponent!constants!private! !
!Float class categoriesFor: #maxLiteralIntegerExponent!constants!private! !
!Float class categoriesFor: #nan!public! !
!Float class categoriesFor: #negativeInfinity!public! !
!Float class categoriesFor: #negativeZero!public! !
!Float class categoriesFor: #new!instance creation!public! !
!Float class categoriesFor: #one!instance creation!public! !
!Float class categoriesFor: #onStartup!event handling!private! !
!Float class categoriesFor: #pi!constants!public! !
!Float class categoriesFor: #precision!constants!public! !
!Float class categoriesFor: #radix!constants!public! !
!Float class categoriesFor: #readFrom:!instance creation!public! !
!Float class categoriesFor: #reset!initializing!public! !
!Float class categoriesFor: #statusFlags!public! !
!Float class categoriesFor: #zero!instance creation!public! !

Float class methodProtocol: #floatCharacterization attributes: #(#ansi #readOnly) selectors: #(#denormalized #e #emax #emin #epsilon #fmax #fmin #fminDenormalized #fminNormalized #pi #precision #radix)!

