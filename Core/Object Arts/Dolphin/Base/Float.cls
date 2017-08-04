"Filed out from Dolphin Smalltalk 7"!

Number variableByteSubclass: #Float
	instanceVariableNames: ''
	classVariableNames: 'EMax EMin FpClassInfinite FpClassNaN FpClassNegative FpClassStrictlyPositive FpClassZero Ln2 MinValLogBase2 Precision SignificantDifference'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Float guid: (GUID fromString: '{87b4c65a-026e-11d3-9fd7-00a0cc3e4a32}')!
Float addClassConstant: 'EMax' value: 1023!
Float addClassConstant: 'EMin' value: -1022!
Float addClassConstant: 'FpClassInfinite' value: 516!
Float addClassConstant: 'FpClassNaN' value: 3!
Float addClassConstant: 'FpClassNegative' value: 60!
Float addClassConstant: 'FpClassStrictlyPositive' value: 896!
Float addClassConstant: 'FpClassZero' value: 96!
Float addClassConstant: 'Ln2' value: 0.6931471805599453!
Float addClassConstant: 'MinValLogBase2' value: -1074!
Float addClassConstant: 'Precision' value: 53!
Float addClassConstant: 'SignificantDifference' value: 1.0e-9!
Float comment: 'Float is the class of double precision floating point Numbers (64-bit) in IEEE-754 format. Note that the original Smalltalk-80 definition of Float, was only single precision, but this is considered somewhat outdated. Rather than introduce the complexity of multiple classes to represent floating point numbers, we have chosen to standardise on double precision.

Class Variables:
	SignificantDifference	<Float>. Difference between two Floats which is considered sufficient to deem them unequal. The smallest this can be is Float class>>epsilon.
	DefaultSigFigs	<SmallInteger>. Default digits of precision displayed.

'!
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
	exception if the operand is zero. The primitive will fail if aNumber is not a SmallInteger
	of Float, but does not set the failure code."

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

= comperand
	"Answer whether the receiver is numerically equivalent to the argument, comperand (e.g. 1 =
	1.0 is true).The primitive will fail if aNumber is not a SmallInteger of Float, but does not
	set the failure code. May also raise a floating point exception."

	<primitive: 163>
	^super = comperand!

> aNumber
	"Answer true if the receiver is greater than aNumber. The primitive will fail if aNumber is
	not a SmallInteger of Float, but does not set the failure code. May also raise a floating
	point exception."

	<primitive: 45>
	^aNumber < self!

abs
	"Answer a Number that is the absolute value - positive magnitude - of the receiver."

	^CRTLibrary default fabs: self
	!

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
	significand := self finiteSignificand.
	roundingIncludesLimits := significand even.
	exp := self exponent - 52 max: MinValLogBase2.
	baseExpEstimate := (self exponent * base asFloat reciprocalLogBase2 - 1.0e-10) ceiling.
	exp >= 0
		ifTrue: 
			[significand ~= 16r10000000000000
				ifTrue: 
					[r := significand bitShift: 1 + exp.
					s := 2.
					mPlus := mMinus := 1 bitShift: exp]
				ifFalse: 
					[r := significand bitShift: 2 + exp.
					s := 4.
					mPlus := 2 * (mMinus := 1 bitShift: exp)]]
		ifFalse: 
			[(exp = MinValLogBase2 or: [significand ~= 16r10000000000000])
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
	significand := self finiteSignificand.
	exp := self exponent - 52 max: MinValLogBase2.
	exp >= 0
		ifTrue: 
			[significand ~= 16r10000000000000
				ifTrue: 
					[r := significand bitShift: 1 + exp.
					s := 2.
					mPlus := mMinus := 1 bitShift: exp]
				ifFalse: 
					[r := significand bitShift: 2 + exp.
					s := 4.
					mPlus := 2 * (mMinus := 1 bitShift: exp)]]
		ifFalse: 
			[(exp = MinValLogBase2 or: [significand ~= 16r10000000000000])
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
	"Answer a <Float> which is the inverse cosine of the receiver in radians. If the receiver is not in the 
	range -1 .. 1 (non-inclusive) then a FloatingPointException will be raised."

	^CRTLibrary default acos: self!

arcSin
	"Answer a <Float> which is the inverse sine of the receiver in radians. If the receiver is not in the 
	range -1 .. 1 (non-inclusive) then a FloatingPointException will be raised."

	^CRTLibrary default asin: self!

arcTan
	"Answer a <Float> which is the inverse tangent of the receiver in radians."

	^CRTLibrary default atan: self!

arcTan: aFloat
	"Answer the arc-tangent of the receiver/aFloat in radians."

	^CRTLibrary default atan: self x: aFloat!

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

ceiling
	"Answer the integer nearest the receiver toward positive infinity."

	^(CRTLibrary default ceil: self) truncated
!

coerce: anArithmeticValue
	"Private - Answer the lower generality ArithmeticValue, anArithmeticValue, 
	converted to a Float."

	^anArithmeticValue asFloat
!

cos
	"Answer a <Float> which is the cosine of the receiver, which is treated as an angle in radians.
	May raise a FloatingPointException in the case of underflow."

	^CRTLibrary default cos: self!

divideIntoFloat: aFloat
	"Private - Answer the result of dividing the receiver by the known Float, aFloat. 
	If we get here, then the floating point multiplication must have failed due to some floating
	point exception."

	^self shouldNotImplement!

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

	^CRTLibrary default exp: self!

exponent
	"Answer the SmallInteger which is the exponent part of the receiver as a Float."

	^self isZero ifTrue: [-1] ifFalse: [(CRTLibrary default _logb: self) truncated]!

finiteSignificand
	^(self timesTwoPower: Precision - 1 - (self exponent max: EMin)) truncated abs!

floor
	"Answer the integer nearest the receiver toward negative infinity."

	^(CRTLibrary default floor: self) truncated
!

floorLog10
	"Answer the base 10 exponent of the receiver (an Integer between -308 and 308)."

	^self log floor!

fpClass
	^CRTLibrary default _fpclass: self!

fractionPart
	"Answer a <Float> representing the fractional part of the receiver."

	^CRTLibrary default modf: self intptr: Float new!

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

	^anInteger asFloat < self!

hash
	"Answer the <SmallInteger> hash value for the receiver. If the receiver is a whole
	number, then the hash of the integer part is used, otherwise the integerPart is
	bitXor'd with the bits of the fractionPart."

	| integerPart fractionPart |
	integerPart := Float new.
	fractionPart := CRTLibrary default modf: self intptr: integerPart.
	fractionPart isZero ifTrue: [^integerPart truncated hash].
	fractionPart := (##(VMConstants.SmallIntegerMax + 1.0) * 
			fractionPart timesTwoPower: (fractionPart exponent abs truncated + 1)).
	^(integerPart truncated bitXor: fractionPart truncated) bitAnd: VMConstants.SmallIntegerMax!

integerPart
	"Answer a <Float> representing the whole integer part of the receiver.
	Implementation Note: Avoid truncaction to integer which can be time
	consuming if the receiver is very large."

	| intPart |
	intPart := Float new.
	CRTLibrary default modf: self intptr: intPart.
	^intPart
!

isFinite
	"Answer whether the receiver represents a finite (non-infinite, non-NaN), value."

	^CRTLibrary default _finite: self!

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

lessOrEquals: aNumber 
	"Answer whether the receiver is numerically less than or equal to aNumber, within the
	default numerical precision."

	(self equals: aNumber) ifTrue: [^true].
	^self < aNumber!

ln
	"Answer the a Float which is the natural logarithm of the receiver.
	May raise FloatingPointException (e.g. if the receiver is negative)."

	^CRTLibrary default log: self!

log
	"Answer a <Float> which is the base 10 logarithm of the receiver.
	May raise a FloatingPointException (e.g. if the receiver is negative).

	Implementation Note: Although we could implement this in terms of #ln,
	that tends to lead to unfortunate precision errors such as '1000.0 log truncated'
	evaluating to 2. It is also faster to use the log10() function directly."

	^CRTLibrary default log10: self!

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
			[aStream nextPutAll: 'NaN'.
			^self].
	(classification anyMask: FpClassNegative) ifTrue: [aStream nextPut: $-].
	(classification anyMask: FpClassInfinite)
		ifTrue: 
			[aStream nextPutAll: 'Infinity'.
			^self].
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
			[aStream nextPutAll: 'NaN'.
			^self].
	(classification anyMask: FpClassNegative) ifTrue: [aStream nextPut: $-].
	(classification anyMask: FpClassInfinite)
		ifTrue: 
			[aStream nextPutAll: 'Infinity'.
			^self].
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
	figures. Ensure that there is always a digit following the decimal point.
	#printOn:decimalPlaces: may be more convenient when printing reports, formatting output
	fields, etc, as it does not drop into exponential format."

	"Implementation Note: Make use of the CRT to avoid reinventing the wheel. "

	| buf ptPos |
	self isFinite ifFalse: [self printOn: aStream].
	buf := String newFixed: (anInteger bitShift: 1) + 10.
	CRTLibrary default
		_gcvt_s: buf
		bufferSize: buf size + 1
		value: self
		digits: anInteger.
	buf := buf trimNulls.
	"Ensure decimal separator is always a $. for printOn:, which outputs Smalltalk real syntax"
	ptPos := buf findString: CRTLibrary default decimalSeparator.
	ptPos == 0
		ifTrue: 
			[aStream
				nextPutAll: buf;
				nextPutAll: '.0']
		ifFalse: 
			[| size |
			aStream
				next: ptPos - 1
					putAll: buf
					startingAt: 1;
				nextPut: $..
			size := buf size.
			ptPos = size
				ifTrue: 
					["Smalltalk requires a trailing zero to follow decimal points"
					aStream nextPut: $0]
				ifFalse: 
					[(buf at: ptPos + 1) == $e ifTrue: [aStream nextPut: $0].
					aStream
						next: buf size - ptPos
						putAll: buf
						startingAt: ptPos + 1]]!

raisedTo: operand 
	"Answer a <Float> which is the receiver raised to the power of the <number>
	argument, operand.
	Note: ANSI standard says that it is an error for the receiver to be negative, but I 
	think that is bogus (unless the operand is non-integral). This implementation will, 
	however, raise an error (a ZeroDivide in fact, but ANSI doesn't specify the precise 
	exception) if the receiver is zero and the argument not strictly positive)."

	^operand strictlyPositive 
		ifTrue: [CRTLibrary default pow: self y: operand asFloat]
		ifFalse: [CRTLibrary default pow: self reciprocal y: operand abs asFloat]!

reciprocalLogBase2
	^self = 10.0 ifTrue: [##(Ln2 / 10.0 ln)] ifFalse: [Ln2 / self ln]!

rounded
	"Answer the <integer> nearest the receiver."

	^(self < 0.0 ifTrue: [self - 0.5] ifFalse: [self + 0.5]) truncated!

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
	For exceptional values, infinity and NaN, just answer the bit pattern."

	^self isFinite
		ifTrue: [self finiteSignificand]
		ifFalse: [(VMLibrary default makeLargeUnsigned: self) bitAnd: 16r000FFFFFFFFFFFFF]!

sin
	"Answer a <Float> which is the sine of the receiver, 
	which is treated as an angle in radians.
	May raise FloatingPointException."

	^CRTLibrary default sin: self!

sqrt
	"Answer the Float which is the square root of the receiver.
	Raises a FloatingPointExceptoin if the receiver is negative."

	^CRTLibrary default sqrt: self!

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
	"Answer a <Float> which is the tangent of the receiver, 
	which is treated as an angle in radians.
	May raise a FloatingPointException."

	^CRTLibrary default tan: self!

timesTwoPower: aNumber
	"Answer the receiver times two to the power of the argument, aNumber."

	| int |
	int := aNumber asInteger.
	^int class == SmallInteger
		ifTrue: [CRTLibrary default ldexp: self exp: int]
		ifFalse: [self * (2 raisedToInteger: int) asFloat]!

truncated
	"Answer the <integer> nearest the receiver toward zero.
	Note that for many large floats the answer may be reported
	to more digits of precision that the floating point receiver
	was capable of representing (there are only about 15 digits 
	of precision in a double).
	Implementation Note: Rather than calculate the integer approximation
	by a series of divisions (as in versions of Dolphin prior to 3.02), a
	process which was both very slow for large Floats and also prone
	to error, we use precise #asTrueFraction.

	Primitive failure results:
		0 -	the receiver is not finite.
		1 -	more than 64-bits are required to represent the receiver 
			as an Integer.
	May also raise a floating point exception."

	<primitive: 166>
	^self asTrueFraction truncated
! !
!Float categoriesFor: #-!arithmetic!public! !
!Float categoriesFor: #*!arithmetic!public! !
!Float categoriesFor: #/!arithmetic!public! !
!Float categoriesFor: #+!arithmetic!public! !
!Float categoriesFor: #<!comparing!public! !
!Float categoriesFor: #=!comparing!public! !
!Float categoriesFor: #>!comparing!public! !
!Float categoriesFor: #abs!mathematical!public! !
!Float categoriesFor: #absPrintExactlyOn:base:!printing!private! !
!Float categoriesFor: #absPrintExactlyOn:base:decimalPlaces:showTrailingFractionalZeros:!printing!private! !
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
!Float categoriesFor: #ceiling!public!truncation and round off! !
!Float categoriesFor: #coerce:!coercing!private! !
!Float categoriesFor: #cos!mathematical!public! !
!Float categoriesFor: #divideIntoFloat:!double dispatch!private! !
!Float categoriesFor: #divideIntoFraction:!double dispatch!private! !
!Float categoriesFor: #divideIntoInteger:!double dispatch!private! !
!Float categoriesFor: #equals:!comparing!public! !
!Float categoriesFor: #exp!mathematical!public! !
!Float categoriesFor: #exponent!accessing!public! !
!Float categoriesFor: #finiteSignificand!helpers!private! !
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
!Float categoriesFor: #isFinite!public!testing! !
!Float categoriesFor: #isInfinite!public!testing! !
!Float categoriesFor: #isLiteral!public!testing! !
!Float categoriesFor: #isNaN!public!testing! !
!Float categoriesFor: #lessOrEquals:!comparing!public! !
!Float categoriesFor: #ln!mathematical!public! !
!Float categoriesFor: #log!mathematical!public! !
!Float categoriesFor: #multiplyByFloat:!double dispatch!private! !
!Float categoriesFor: #multiplyByFraction:!double dispatch!private! !
!Float categoriesFor: #multiplyByInteger:!double dispatch!private! !
!Float categoriesFor: #negative!public!testing! !
!Float categoriesFor: #printOn:!printing!public! !
!Float categoriesFor: #printOn:base:!printing!public! !
!Float categoriesFor: #printOn:decimalPlaces:!printing!public! !
!Float categoriesFor: #printOn:significantFigures:!printing!public! !
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

	^Processor activeProcess fpeMask allMask: (CRTConstants._EM_DENORMAL bitOr: CRTConstants._EM_UNDERFLOW)!

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

fmax
	"Answer a <Float> representing the largest value
	allowed by the characterized floating point representation."

	^1.7976931348623157e308!

fmin
	"Answer a <Float> representing the smallest value
	allowed by the characterized floating point representation."

	^self denormalized
		ifTrue: [self fminDenormalized]
		ifFalse: [self fminNormalized]!

fminDenormalized
	"Answer a <Float> representing the smallest denormalized value
	allowed by the characterized floating point representation."

	^##(1.0 timesTwoPower: MinValLogBase2)!

fminNormalized
	"Answer a <Float> representing the smallest normalized value
	allowed by the characterized floating point representation."

	^2.2250738585072014e-308!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the class variables of the receiver
		Float initialize
	"

	self addClassConstant: 'EMin' value: -1022.
	self addClassConstant: 'EMax' value: 1023.
	self addClassConstant: 'Ln2' value: 0.6931471805599453.
	self addClassConstant: 'MinValLogBase2' value: -1074.
	self addClassConstant: 'Precision' value: 53.
	self addClassConstant: 'SignificantDifference' value: 1.0e-9.
	self assert: [SignificantDifference >= self epsilon].
	self addClassConstant: 'FpClassInfinite'
		value: CRTConstants._FPCLASS_NINF | CRTConstants._FPCLASS_PINF.
	self addClassConstant: 'FpClassStrictlyPositive'
		value: CRTConstants._FPCLASS_PD | CRTConstants._FPCLASS_PN | CRTConstants._FPCLASS_PINF.
	self addClassConstant: 'FpClassNegative'
		value: CRTConstants._FPCLASS_ND | CRTConstants._FPCLASS_NN | CRTConstants._FPCLASS_NINF
				| CRTConstants._FPCLASS_NZ.
	self addClassConstant: 'FpClassZero' value: CRTConstants._FPCLASS_NZ | CRTConstants._FPCLASS_PZ.
	self addClassConstant: 'FpClassNaN' value: CRTConstants._FPCLASS_QNAN | CRTConstants._FPCLASS_SNAN.
	#(#FloatD #FloatE #FloatQ) do: [:each | Smalltalk at: each ifAbsentPut: [self]]!

maxExponent
	"Private - The maximum allowed decimal exponent (power of 10) in the literal Float form."

	^308!

maxLiteralIntegerExponent
	"Private - The maximum allowed exponent (power of 10) in the literal integer form '<int>e<powerOf10>'
	when the result will be converted to a Float."

	^self maxExponent!

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

	^##(-1.0 arcCos)!

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

	CRTLibrary default _clearfp.
	self setExceptionMask: Processor activeProcess fpeMask.
	self resetPrecision!

resetPrecision
	CRTLibrary default
		_controlfp_s: nil
		newControl: CRTConstants._PC_64
		mask: CRTConstants._MCW_PC!

setExceptionMask: anInteger
	"Private - Set the current floating point exception mask to anInteger."

	| errno |
	(errno := CRTLibrary default
				_controlfp_s: nil
				newControl: anInteger
				mask: CRTConstants._MCW_EM) == 0
		ifFalse: [CRTError signalWith: errno]!

zero
	"Answer the receiver's representation of zero."

	^0.0! !
!Float class categoriesFor: #denormalized!public!testing! !
!Float class categoriesFor: #e!constants!public! !
!Float class categoriesFor: #emax!constants!public! !
!Float class categoriesFor: #emin!constants!public! !
!Float class categoriesFor: #epsilon!constants!public! !
!Float class categoriesFor: #fmax!constants!public! !
!Float class categoriesFor: #fmin!constants!public! !
!Float class categoriesFor: #fminDenormalized!constants!public! !
!Float class categoriesFor: #fminNormalized!constants!public! !
!Float class categoriesFor: #icon!constants!public! !
!Float class categoriesFor: #initialize!development!initializing!private! !
!Float class categoriesFor: #maxExponent!constants!private! !
!Float class categoriesFor: #maxLiteralIntegerExponent!constants!private! !
!Float class categoriesFor: #negativeZero!public! !
!Float class categoriesFor: #new!instance creation!public! !
!Float class categoriesFor: #one!instance creation!public! !
!Float class categoriesFor: #onStartup!event handling!private! !
!Float class categoriesFor: #pi!constants!public! !
!Float class categoriesFor: #precision!constants!public! !
!Float class categoriesFor: #radix!constants!public! !
!Float class categoriesFor: #readFrom:!instance creation!public! !
!Float class categoriesFor: #reset!initializing!public! !
!Float class categoriesFor: #resetPrecision!initializing!private! !
!Float class categoriesFor: #setExceptionMask:!initializing!private! !
!Float class categoriesFor: #zero!instance creation!public! !

Float class methodProtocol: #floatCharacterization attributes: #(#ansi #readOnly) selectors: #(#denormalized #e #emax #emin #epsilon #fmax #fmin #fminDenormalized #fminNormalized #pi #precision #radix)!

