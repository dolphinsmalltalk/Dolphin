"Filed out from Dolphin Smalltalk"!

Core.Number
	variableByteSubclass: #'Core.Float'
	instanceVariableNames: ''
	classVariableNames: 'DefaultDecimalExponents FMinDenormalized Infinity NaN NegativeInfinity'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'EMax' -> 16r3FF.
			'EMin' -> -16r3FE.
			'EMinDenormalized' -> -16r432.
			'FMax' -> 1.7976931348623157e308.
			'FMin' -> 2.2250738585072014e-308.
			'FpClassDenormal' -> 16r90.
			'FpClassFinite' -> 16r1F8.
			'FpClassInfinite' -> 16r204.
			'FpClassNaN' -> 16r3.
			'FpClassNegative' -> 16r3C.
			'FpClassNormal' -> 16r108.
			'FpClassStrictlyPositive' -> 16r380.
			'FpClassZero' -> 16r60.
			'InvalidOperationFlag' -> 16r1.
			'Ln2' -> 0.6931471805599453.
			'MantissaHighBit' -> 16r10000000000000.
			'MantissaMask' -> 16rFFFFFFFFFFFFF.
			'Precision' -> 16r35.
			'SignificantDifference' -> 1.0e-9
		}!

Core.Float guid: (Core.GUID fromString: '{87b4c65a-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Float comment: 'Float is the class of double precision floating point Numbers (64-bit) in IEEE-754 format.'!

!Core.Float categoriesForClass!Magnitude-Numbers! !

!Core.Float methodsFor!

- aNumber
	"Answer the result of subtracting the argument, aNumber, from the receiver."

	"The primitive will fail if aNumber is not a SmallInteger of Float. May also raise a floating point exception."

	<primitive: 161>
	^aNumber subtractFromFloat: self!

* aNumber
	"Answer the result of multiplying the receiver by the argument, aNumber."

	"The primitive will fail if aNumber is not a SmallInteger of Float. May also raise a floating point exception."

	<primitive: 164>
	^aNumber multiplyByFloat: self!

/ aNumber
	"Answer the result of dividing the receiver by the argument, aNumber. Raise a <ZeroDivide> exception if the operand is zero."


	"Primitive failure codes:
		InvalidParameter1	- aNumber is not a <SmallInteger> or a <Float>
	 
	If the operand is zero, and the receiver is finite (because if infinite, division-by-zero will not raise an exception); and the relevant exceptions are unmasked, then a ZeroDivide exception will be raised. If the exception is resumed then the primitive will fail and the method will return continuation value of either Float.Infinity or Float.NegativeInfinity, for division by 0.0 and -0.0 respectively, except where the receiver is NaN, in which case the result is also NaN. If ZeroDivide is masked, then division by zero will result in a continuation value direct from the primitive."

	<primitive: 165>
	^aNumber = 0
		ifTrue: 
			["If we get here then ZeroDivide/Invalid must have been unmasked, but the ZeroDivide raised was resumed. Therefore we should return the appropriate continuation value."
			self isNaN
				ifTrue: [self]
				ifFalse: [self negative ~~ aNumber negative ifTrue: [NegativeInfinity] ifFalse: [Infinity]]]
		ifFalse: [
			"aNumber is not a <SmallInteger> or a <Float>; ask it to divide the receiver's floating point value."
			aNumber divideIntoFloat: self]!

+ aNumber
	"Answer the result of adding the argument, aNumber, to the receiver.The primitive will fail if aNumber is not a SmallInteger of Float. May also raise a floating point exception."

	<primitive: 160>
	^aNumber addToFloat: self!

< aNumber
	"Answer true if the receiver is less than the argument, aNumber. If the receiver or argument is NaN, then always answer false. This relational operator is implemented as a primitive, and >, <=, and >= are expressed in terms of it."

	"The primitive will fail if aNumber is not a SmallInteger of Float."

	<primitive: 162>
	^aNumber greaterThanFloat: self!

<= aNumber
	"Answer whether the receiver is less than or equal to the argument, aNumber."

	"Implementation Note: Superclass implementation does not work correctly for comparisons against NaN, which must always be false (except for ~=)."

	<primitive: 214>
	^aNumber greaterOrEqualToFloat: self!

= anObject
	"Answer whether the receiver is numerically equivalent to the argument, anObject (e.g. 1 = 1.0 is true). If either receiver or argument are NaN, then answer false."

	"The primitive will fail if aNumber is not a SmallInteger of Float."

	<primitive: 47>
	^anObject understandsArithmetic and: [anObject equalToFloat: self]!

> aNumber
	"Answer true if the receiver is greater than aNumber. If either receiver or argument are NaN, then answer false."

	"The primitive will fail if aNumber is not a SmallInteger of Float."

	<primitive: 45>
	^aNumber < self!

>= aNumber
	"Answer whether the receiver is greater than or equal to the argument, aNumber. If either receiver or argument are NaN, then answer false."

	"Implementation Note: Superclass implementation does not work correctly for comparisons against NaN, which must always be false (except for ~=)."

	<primitive: 46>
	^aNumber <= self!

abs
	"Answer a <Float> that is the absolute value - positive magnitude - of the receiver."

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
	(fixedFormat := baseExpEstimate >= DefaultDecimalExponents start
				and: [baseExpEstimate <= DefaultDecimalExponents stop])
			ifTrue: 
				[decPointCount := baseExpEstimate.
				baseExpEstimate <= 0
					ifTrue: 
						[aStream
							nextPutAll: '0.';
							next: baseExpEstimate negated put: $0]]
			ifFalse: [decPointCount := 1].
	slowbit := 1 - s lowBit.
	shead := s bitShift: slowbit.
	
	[d := (r bitShift: slowbit) // shead.
	r := r - (d * s).
	(tc1 := r <= mMinus and: [roundingIncludesLimits or: [r < mMinus]])
		| (tc2 := r + mPlus >= s and: [roundingIncludesLimits or: [r + mPlus > s]])]
			whileFalse: 
				[aStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: d + 1).
				r := r * base.
				mPlus := mPlus * base.
				mMinus := mMinus * base.
				(decPointCount := decPointCount - 1) = 0 ifTrue: [aStream nextPut: $.]].
	tc2 ifTrue: [(tc1 not or: [r * 2 >= s]) ifTrue: [d := d + 1]].
	aStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: d + 1).
	decPointCount > 0
		ifTrue: 
			[decPointCount - 1 timesRepeat: [aStream nextPut: $0].
			aStream nextPutAll: '.0'].
	fixedFormat
		ifFalse: 
			[aStream
				nextPut: $e.
			baseExpEstimate - 1 printOn: aStream base: 10]!

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
								next: placesDesired put: $0].
					^self].
			aStream
				nextPutAll: '0.';
				next: 0 - baseExpEstimate put: $0].
	slowbit := 1 - s lowBit.
	shead := s bitShift: slowbit.
	
	[d := (r bitShift: slowbit) // shead.
	r := r - (d * s).
	(tc1 := r <= mMinus and: [roundingLowIncludesLimits or: [r < mMinus]])
		| (tc2 := r + mPlus >= s and: [roundingHighIncludesLimits or: [r + mPlus > s]])]
			whileFalse: 
				[aStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: d + 1).
				r := r * base.
				mPlus := mPlus * base.
				mMinus := mMinus * base.
				(decPointCount := decPointCount - 1) = 0 ifTrue: [aStream nextPut: $.]].
	tc2 ifTrue: [(tc1 not or: [r * 2 >= s]) ifTrue: [d := d + 1]].
	aStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: d + 1).
	decPointCount > 0
		ifTrue: 
			[decPointCount - 1 timesRepeat: [aStream nextPut: $0].
			(showtrailingZeros and: [placesDesired > 0])
				ifTrue: 
					[aStream
						nextPut: $.;
						next: placesDesired put: $0]]
		ifFalse: 
			[(showtrailingZeros and: [placesDesired + decPointCount > 1])
				ifTrue: [aStream next: placesDesired + decPointCount - 1 put: $0]]!

absPrintOn: aStream base: base digitCount: digitCount decimalExponents: anInterval
	"Private - Print me in the given base, using digitCount significant figures. Scientific notation is used if the exponent falls outside the specified <Interval>.
	Note that it is assumed the receiver is strictly positive. "

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
	(exp >= anInterval start and: [exp <= anInterval stop])
		ifTrue: 
			["decimal notation"
			q := 0.
			exp < 0
				ifTrue: 
					[aStream
						nextPutAll: '0.';
						next: -1 - exp put: $0]]
		ifFalse: 
			["scientific notation"
			q := exp.
			exp := 0].
	[x >= fuzz] whileTrue: 
			["use fuzz to track significance"
			xi := x truncated.
			aStream nextPut: ('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: xi + 1).
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

	"Perform the FP addition again with exceptions masked to get a continuation value"

	| mask |
	mask := Float exceptionMask: OS.CRTConstants._MCW_EM.
	^[aFloat + self] ensure: [Float exceptionMask: mask]!

addToFraction: aFraction
	"Private - Answer the <Float> result of adding the receiver to the known <Fraction> argument."

	^aFraction asFloat + self!

addToInteger: anInteger
	"Private - Answer the <Float> result of adding the known <integer> to the receiver, first converting it to a <Float>."

	^anInteger asFloat + self!

arcCos
	"Answer a <Float> which is the inverse cosine of the receiver in radians. If the receiver is not in the range -1 .. 1 (non-inclusive) then a FloatingPointException will be raised
	(unless the current FP exception mask includes CRTConstants._EM_INVALID)."

	<primitive: 198>
	^NaN!

arcSin
	"Answer a <Float> which is the inverse sine of the receiver in radians. If the receiver is not in the range -1 .. 1 (non-inclusive) then a FloatingPointException will be raised.
	If the exception is resumed, or the current FP exception mask includes CRTConstants._EM_INVALID, then return a NaN continuation value."

	<primitive: 196>
	^NaN!

arcTan
	"Answer a <Float> which is the inverse tangent of the receiver in radians."

	<primitive: 197>
	^self primitiveFailed: _failureCode!

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
	(self fpClass anyMask: FpClassFinite)
		ifFalse: [ArithmeticError signal: ('Cannot represent <1p> as a fraction' expandMacrosWith: self)].
	shifty := self uint64AtOffset: 0.
	" Extract the sign and the biased exponent "
	sign := (shifty bitShift: -63) == 0 ifTrue: [1] ifFalse: [-1].
	expPart := (shifty bitShift: -52) bitAnd: 16r7FF.

	" Extract fractional part; answer 0 if this is a true 0.0 value "
	fractionPart := shifty bitAnd: 16r000FFFFFFFFFFFFF.
	(expPart == 0 and: [fractionPart == 0]) ifTrue: [^0].

	"Add implied leading 1 into fraction"
	fraction := expPart == 0
				ifTrue: [fractionPart bitShift: 1]
				ifFalse: [fractionPart bitOr: 16r0010000000000000].

	"Unbias exponent: 16r3FF is bias; 52 is fraction width"
	exp := ##(16r3FF + 52) - expPart.

	"Form the result. When exp>52, the exponent is adjusted by the number of trailing zero bits
	in the fraction to minimize the (huge) time otherwise spent in #gcd:. "
	^exp < 0
		ifTrue: [sign * fraction bitShift: exp negated]
		ifFalse: 
			[| zeroBitsCount |
			exp := exp - (zeroBitsCount := fraction lowBit - 1).
			exp <= 0
				ifTrue: [sign * fraction bitShift: (zeroBitsCount + exp) negated]
				ifFalse: 
					[Fraction numerator: (sign * fraction bitShift: zeroBitsCount negated) denominator: (1 bitShift: exp)]]!

bitRepresentation
	"Answer an <integer> representing the raw binary bit representation of the receiver. This is
	IEEE 754 64-bit double precision, with a sign bit, 11 exponent bits, and a 52-bit mantissa
	with implied leading bit."

	^self uint64AtOffset: 0!

byteSize
	"Floating point objects in Dolphin are always doubles."

	^8!

ceiling
	"Answer the integer nearest the receiver toward positive infinity."

	<primitive: 208>
	^self asTrueFraction ceiling!

coerce: anArithmeticValue
	"Private - Coerce the <arithmeticValue> argument (which is assumed to be of a lower generality than the receiver) to a <Float>."

	^anArithmeticValue asFloat!

cos
	"Answer a <Float> which is the cosine of the receiver, which is treated as an angle in radians. May raise FloatingPointException, depending on the value of the receiver and the current FP exception mask."

	<primitive: 195>
	"If we get here, it must be because a FloatPointException occured and was resumed, so return the appropriate continuation value."
	^NaN!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be the Smalltalk literal format for floating point numbers if the stream is configured for the Smalltalk locale, but it could be in a <WindowsLocale> specific format."

	aPuttableStream locale displayFloat: self on: aPuttableStream!

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

	^self closeTo: aNumber precision: SignificantDifference!

equalToFraction: aFraction
	"Private - Answer whether the receiver is equal to the known <Fraction>, aFraction."

	^aFraction equalToFloat: self!

equalToInteger: anInteger
	"Private - Answer whether the receiver is equal to the known <Integer>, anInteger."

	^anInteger equalToFloat: self!

exp
	"Answer the exponential of the receiver. The primitive should not fail."

	<primitive: 201>
	^self primitiveFailed: _failureCode!

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

floorLog: operand
	"Answer an <integer> which is the logarithm to the <number> base, operand,
	of the receiver, truncated towards negative infinity."
	
	(operand == 2 and: [self > 0.0]) ifTrue: [^self exponent].
	^(self log: operand) floor
!

floorLog10
	"Answer the base 10 exponent of the receiver (an Integer between -308 and 308)."

	^self log floor!

fpClass
	"Private - Answer a set of flags from the CRTConstants _FPCLASS_xxx enumeration describing the receiver's floating point classification, e.g. as negative or positive, finite or infinite, normal or denormal, etc.
	The primitive should not fail."

	<primitive: 211>
	^self primitiveFailed: _failureCode!

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

greaterOrEqualToFraction: aFraction
	| fpclass |
	fpclass := self fpClass.
	^(fpclass anyMask: Float.FpClassFinite)
		ifTrue: [self asTrueFraction greaterOrEqualToFraction: aFraction]
		ifFalse: [(fpclass bitAnd: ##(FpClassNaN | FpClassNegative)) == 0]!

greaterOrEqualToInteger: anInteger
	"Private - Answer whether the receiver is greater than the known Integer, anInteger."

	^anInteger asFloat <= self!

greaterThanFraction: aFraction
	"Private - Answer whether the receiver is greater than the known Fraction, aFraction."

	| fpclass |
	fpclass := self fpClass.
	^(fpclass anyMask: Float.FpClassFinite)
		ifTrue: [self asTrueFraction greaterThanFraction: aFraction]
		ifFalse: [(fpclass bitAnd: ##(FpClassNaN bitOr: FpClassNegative)) == 0]!

greaterThanInteger: anInteger
	"Private - Answer whether the receiver is greater than the known Integer, anInteger."

	^anInteger asFloat < self!

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

isFloat
	"Answer true if receiver is an instance of class Float, else answer false."

	^true
!

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
	May raise an <ArithmeticError>, e.g. if the receiver is negative, but only if all FP ZeroDivide/Invalid exceptions are unmasked (which is the default)."

	<primitive: 200>
	"We may get here if ZeroDivide/Invalid FP exceptions are unmasked but the FloatingPointException was continued, in which case answer the same continuation value that one would get with exceptions masked."
	^self isZero ifTrue: [NegativeInfinity] ifFalse: [NaN]!

log
	"Answer a <Float> which is the base 10 logarithm of the receiver.
	May raise an <ArithmeticError>, e.g. if the receiver is negative, although only if ZeroDivide/Invalid FP exceptions are unmasked (which they are by default)."

	"Implementation Note: Although we could implement this in terms of #ln, that tends to lead to unfortunate precision errors such as '1000.0 log truncated' evaluating to 2. It is also faster to use the log10() function directly."

	<primitive: 203>
	"We may get here if ZeroDivide/Invalid FP exceptions are unmasked but the FloatingPointException was continued, in which case answer the same continuation value that one would get with exceptions masked."
	^self isZero ifTrue: [NegativeInfinity] ifFalse: [NaN]!

multiplyByFloat: aFloat
	"Private - Answer the result of multiplying the known Float, aFloat, by the receiver. 
	If we get here, then the floating point multiplication has probably failed due to some floating point exception, but that has been resumed. Unfortunately it is too late to examine the FP control flags."

	"Perform the multiplication again with exceptions masked to get a continuation value"

	| mask |
	mask := Float exceptionMask: OS.CRTConstants._MCW_EM.
	^[aFloat * self] ensure: [Float exceptionMask: mask]!

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
	"Answer whether the receiver is negative."

	^self fpClass anyMask: FpClassNegative!

printOn: aPuttableStream
	"Append the exact Smalltalk literal representation of the receiver to the <puttableStream> argument."

	Locale smalltalk displayFloat: self on: aPuttableStream!

printOn: aStream base: anInteger
	"Print the receiver with the minimal number of digits that describes it unambiguously in the specified base. This way, every two different Float will have a different printed representation. More over, every Float can be reconstructed from its printed representation with #readFrom:."

	| classification |
	classification := self fpClass.
	(classification anyMask: FpClassNaN)
		ifTrue: 
			[aStream nextPutAll: Locale smalltalk nan.
			^self].
	(classification anyMask: FpClassInfinite)
		ifTrue: 
			[aStream nextPutAll: ((classification anyMask: FpClassNegative)
						ifTrue: [Locale smalltalk negativeInfinity]
						ifFalse: [Locale smalltalk infinity]).
			^self].
	(classification anyMask: FpClassZero)
		ifTrue: 
			[(classification anyMask: FpClassNegative)
				ifTrue: [aStream nextPutAll: '-0.0']
				ifFalse: [aStream nextPutAll: '0.0'].
			^self].
	((classification anyMask: FpClassNegative)
		ifTrue: 
			[aStream nextPut: $-.
			self abs]
		ifFalse: [self]) absPrintExactlyOn: aStream base: anInteger!

printOn: aStream base: baseInteger decimalPlaces: placesInteger
	"Append the printed representation of the receiver to the <puttableStream>, aStream, in <integer> base, baseInteger, rounded to the <integer> number of decimal places, placeInteger."

	| classification |
	classification := self fpClass.
	(classification anyMask: FpClassNaN)
		ifTrue: 
			[aStream nextPutAll: Locale smalltalk nan.
			^self].
	(classification anyMask: FpClassInfinite)
		ifTrue: 
			[aStream nextPutAll: ((classification anyMask: FpClassNegative)
						ifTrue: [Locale smalltalk negativeInfinity]
						ifFalse: [Locale smalltalk infinity]).
			^self].
	(classification anyMask: FpClassZero)
		ifTrue: 
			[(classification anyMask: FpClassNegative) ifTrue: [aStream nextPut: $-].
			aStream nextPut: $0.
			placesInteger > 0
				ifTrue: 
					[aStream nextPut: $..
					aStream next: placesInteger put: $0].
			^self].
	((classification anyMask: FpClassNegative)
		ifTrue: 
			[aStream nextPut: $-.
			self abs]
		ifFalse: [self])
			absPrintExactlyOn: aStream
			base: baseInteger
			decimalPlaces: placesInteger
			showTrailingFractionalZeros: true!

printOn: aStream base: baseInteger significantFigures: digitsInteger
	"Append the printed representation of the receiver to the <puttableStream>, aStream, in <integer> base, baseInteger, with <integer>, digitsInteger, significant figures. Note that there is always a digit following the decimal point, even if zero."

	self
		printOn: aStream
		base: baseInteger
		significantFigures: digitsInteger
		decimalExponents: DefaultDecimalExponents!

printOn: aStream base: baseInteger significantFigures: digitsInteger decimalExponents: anInterval
	"Append the printed representation of the receiver to the <puttableStream>, aStream, in <integer> base, baseInteger, with <integer>, digitsInteger, significant figures. Note that there is always a digit following the decimal point, even if zero."

	| classification |
	classification := self fpClass.
	(classification anyMask: FpClassNaN)
		ifTrue: 
			[aStream nextPutAll: Locale smalltalk nan.
			^self].
	(classification anyMask: FpClassInfinite)
		ifTrue: 
			[aStream nextPutAll: ((classification anyMask: FpClassNegative)
						ifTrue: [Locale smalltalk negativeInfinity]
						ifFalse: [Locale smalltalk infinity]).
			^self].
	(classification anyMask: FpClassZero)
		ifTrue: 
			[(classification anyMask: FpClassNegative)
				ifTrue: [aStream nextPutAll: '-0.0']
				ifFalse: [aStream nextPutAll: '0.0'].
			^self].
	((classification anyMask: FpClassNegative)
		ifTrue: 
			[aStream nextPut: $-.
			self abs]
		ifFalse: [self])
			absPrintOn: aStream
			base: baseInteger
			digitCount: digitsInteger
			decimalExponents: anInterval!

printOn: aStream decimalPlaces: anInteger
	"Append the printed representation of the receiver to the <puttableStream>, aStream, rounded to the <integer> number of decimal places, anInteger."

	self printOn: aStream base: 10 decimalPlaces: anInteger!

printOn: aStream significantFigures: anInteger
	"Append the printed representation of the receiver in base 10 to the <puttableStream>, aStream, with <integer>, anInteger, significant figures. Note that there is always a digit following the decimal point, even if zero."

	self
		printOn: aStream
		base: 10
		significantFigures: anInteger
		decimalExponents: DefaultDecimalExponents!

raisedTo: aNumber
	"Answer a <Float> which is the receiver raised to the power of the <number> argument.
	Note: ANSI standard says that it is an error for the receiver to be negative, but I think that is bogus (unless the operand is non-integral). This implementation will, however, raise an error (a ZeroDivide in fact, but ANSI doesn't specify the precise exception) if the receiver is zero and the argument not strictly positive)."

	<primitive: 206>
	^aNumber isFloat
		ifTrue: 
			[| mask |
			"FP exception must have been continued - repeat with exceptions masked to get correct continuation value"
			mask := self class exceptionMask: OS.CRTConstants._MCW_EM.
			[self raisedTo: aNumber] ensure: [self class exceptionMask: mask]]
		ifFalse: [self raisedTo: aNumber asFloat]!

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
	mantissaBits := (self uint64AtOffset: 0) bitAnd: MantissaMask.
	^(self fpClass anyMask: FpClassNormal)
		ifTrue: 
			["Add in the implied leading 1"
			mantissaBits bitOr: MantissaHighBit]
		ifFalse: 
			["Answer the bit pattern as is"
			mantissaBits]!

sin
	"Answer a <Float> which is the sine of the receiver, which is treated as an angle in radians. May raise a <FloatingPointException>, depending on the value of the receiver and the current FP exception mask."

	<primitive: 193>
	"If we get here, it must be because a FloatPointException occured and was resumed, so return the appropriate continuation value."
	^NaN!

sqrt
	"Answer the Float which is the square root of the receiver.
	Raises a FloatingPointException if the receiver is negative and _EM_INVALID is unmasked. If _EM_INVALID is masked, or the <FloatingPointException> is continuted, then a continuation value of Float.NaN will result."

	<primitive: 202>
	"Continuation value"
	^NaN!

subtractFromFloat: aFloat
	"Private - Answer the result of subtracting the receiver from the known Float, aFloat. 
	If we get here, then the floating point subtraction must have failed due to some floating
	point exception."

	"Perform the FP subtraction again with exceptions masked to get a continuation value"

	| mask |
	mask := Float exceptionMask: OS.CRTConstants._MCW_EM.
	^[aFloat - self] ensure: [Float exceptionMask: mask]!

subtractFromFraction: aFraction
	"Private - Answer the result of subtracting the receiver from the known fraction, aFraction."

	^aFraction asFloat - self!

subtractFromInteger: anInteger
	"Private - Subtract the known integer, anInteger, from the receiver, converting anInteger 
	to a Float. Answer the result"

	^anInteger asFloat - self!

tan
	"Answer a <Float> which is the tangent of the receiver, which is treated as an angle in radians. May raise FloatingPointException, depending on the value of the receiver and the current FP exception mask."

	<primitive: 194>
	^self primitiveFailed: _failureCode!

timesTwoPower: aNumber
	"Answer the receiver times two to the power of the argument, aNumber."

	"The primitive only fails if the argument is not a <SmallInteger> or a <Float>."

	<primitive: 204>
	^self * (2.0 raisedToInteger: aNumber asInteger)!

truncated
	"Answer the <integer> nearest the receiver toward zero. Note that for many large floats the answer may be reported to more digits of precision that the floating point receiver was capable of representing (there are only about 15 digits of precision in a double)."

	"The primitive fails if the receiver is not finite, or more than 64-bits are required to represent its value as an integer. Depending on the FP exception mask, may also raise an FP exception."

	<primitive: 166>
	"Implementation Note: Rather than calculate the integer approximation by a series of divisions (as in versions of Dolphin prior to 3.02), a process which was both very slow for large Floats and also prone to error, we use precise #asTrueFraction."
	^self asTrueFraction truncated
!

uint64AtOffset: anInteger
	<primitive: 191>
	^self primitiveFailed: _failureCode! !

!Core.Float categoriesForMethods!
-!arithmetic!public! !
*!arithmetic!public! !
/!arithmetic!public! !
+!arithmetic!public! !
<!comparing!public! !
<=!comparing!public! !
=!comparing!public! !
>!comparing!public! !
>=!comparing!public! !
abs!mathematical!public! !
absPrintExactlyOn:base:!printing!private! !
absPrintExactlyOn:base:decimalPlaces:showTrailingFractionalZeros:!printing!private! !
absPrintOn:base:digitCount:decimalExponents:!printing!private! !
addToFloat:!double dispatch!private! !
addToFraction:!double dispatch!private! !
addToInteger:!double dispatch!private! !
arcCos!mathematical!public! !
arcSin!mathematical!public! !
arcTan!mathematical!public! !
arcTan:!mathematical!public! !
asApproximateFraction!converting!public! !
asFloat!converting!public! !
asFraction!converting!public! !
asTrueFraction!converting!public! !
bitRepresentation!accessing!private! !
byteSize!constants!public! !
ceiling!public!truncation and round off! !
coerce:!coercing!private! !
cos!mathematical!public! !
displayOn:!printing!public! !
divideIntoFloat:!double dispatch!private! !
divideIntoFraction:!double dispatch!private! !
divideIntoInteger:!double dispatch!private! !
equals:!comparing!public! !
equalToFraction:!double dispatch!private! !
equalToInteger:!double dispatch!private! !
exp!mathematical!public! !
exponent!accessing!public! !
floor!public!truncation and round off! !
floorLog:!mathematical!public! !
floorLog10!mathematical!public! !
fpClass!helpers!private! !
fractionPart!accessing!public! !
generality!coercing!private! !
greaterOrEquals:!comparing!public! !
greaterOrEqualToFraction:!double dispatch!private! !
greaterOrEqualToInteger:!double dispatch!private! !
greaterThanFraction:!double dispatch!private! !
greaterThanInteger:!double dispatch!private! !
hash!comparing!public! !
integerPart!accessing!public! !
isDenormal!public!testing! !
isFinite!public!testing! !
isFloat!public!testing! !
isInfinite!public!testing! !
isLiteral!public!testing! !
isNaN!public!testing! !
isZero!public!testing! !
lessOrEquals:!comparing!public! !
ln!mathematical!public! !
log!mathematical!public! !
multiplyByFloat:!double dispatch!private! !
multiplyByFraction:!double dispatch!private! !
multiplyByInteger:!double dispatch!private! !
negated!arithmetic!public! !
negative!public!testing! !
printOn:!printing!public! !
printOn:base:!printing!public! !
printOn:base:decimalPlaces:!printing!public! !
printOn:base:significantFigures:!printing!public! !
printOn:base:significantFigures:decimalExponents:!printing!public! !
printOn:decimalPlaces:!printing!public! !
printOn:significantFigures:!printing!public! !
raisedTo:!mathematical!public! !
reciprocalLogBase2!mathematical!public! !
rounded!public!truncation and round off! !
sign!public!testing! !
significandAsInteger!accessing!public! !
sin!mathematical!public! !
sqrt!mathematical!public! !
subtractFromFloat:!double dispatch!private! !
subtractFromFraction:!double dispatch!private! !
subtractFromInteger:!double dispatch!private! !
tan!mathematical!public! !
timesTwoPower:!mathematical!public! !
truncated!public!truncation and round off! !
uint64AtOffset:!accessing!private! !
!

!Core.Float class methodsFor!

defaultDecimalExponents
	"Answer an <Interval> that specifies the range of exponents over which Floats are (by default) printed in decimal (as opposed to scientific) format by printing methods."

	^DefaultDecimalExponents!

defaultDecimalExponents: anInteger
	"Set the <Interval> that is used as the default range of exponents over which Floats are printed in decimal (as opposed to scientific) format by print methods."

	DefaultDecimalExponents := anInteger!

denormalized
	"Answer whether the characterized floating point representation allows denormalized
	values."

	^(Processor activeProcess fpControl bitAnd: ##(OS.CRTConstants._MCW_DN | OS.CRTConstants._EM_DENORMAL))
		= OS.CRTConstants._EM_DENORMAL!

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
	"Answer the floating point exception mask which is active in the currently executing <Process>. This controls the types of error condition that may result in a <FloatingPointException> being raised when performing floating point operations. The mask is a combination of flags from the CRTConstants _EM_XXX enumeration, and 'masks out' the relevant exception, i.e. to prevent the class of exception occuring the associated mask bit is set, to allow it the associated mask bits is cleared. The mask bits are:

		_EM_DENORMAL 	- denormalized inputs
		_EM_INEXACT		- inexact result
		_EM_INVALID		- invalid FP operations such as sqrt(-1)
		_EM_OVERFLOW	- result overflow, e.g. Float fmax*2
		_EM_UNDERFLOW	- result underflows normalized range
		_EM_ZERODIVIDE	- division by zero
	
	You should be careful about unmasking some classes of exception, especially _EM_INEXACT, as this may generate continuous exceptions that crash the image.

	Where exceptions would have been raised that are masked, the computation will yield a continuation value. This will be an infinity value for overflow and division by zero, NaN for invalid operations, a denormalized number or zero for underflow.
	Note that some operations on continuation values that might normally be expected to raise a <FloatingPointException> will complete successfully with a further continuation value. An example is dividing infinities (or NaNs) by zero.

	See Process class>>#initialize for a description of the default exception mask, and the class comment of <FloatingPointException> for further background information."

	^Processor activeProcess fpControl bitAnd: OS.CRTConstants._MCW_EM!

exceptionMask: anInteger
	"Set the floating point exception mask which is active in the currently executing
	<Process>. See #exceptionMask for further information. Answers the previous mask."

	^Processor activeProcess setFpControl: anInteger mask: OS.CRTConstants._MCW_EM!

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

infinity
	"Answer a <Float> representing positive infinity, which in practice is any value larger than FMax."

	^Infinity!

initialize
	"Private - Initialize the class variables of the receiver
		Float initialize
	"

	| fpeMask fmax emin eminDenorm mantissaBits mantissaHighBit |
	#(#FloatD #FloatE #FloatQ) do: [:each | (Core declareVariable: each) value: self].
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
	self addClassVariable: 'FMinDenormalized' value: (1.0 timesTwoPower: eminDenorm).
	"Mask out overflow/invalid while we generate the infinity/NaN constants."
	fpeMask := self exceptionMask.
	self exceptionMask: (fpeMask maskSet: OS.CRTConstants._EM_OVERFLOW | OS.CRTConstants._EM_INVALID).
	
	[| infinity |
	infinity := fmax * fmax.
	self addClassConstant: 'Infinity' value: infinity.
	self addClassConstant: 'NegativeInfinity' value: infinity * -1.
	self addClassConstant: 'NaN' value: infinity - infinity]
			ensure: [self exceptionMask: fpeMask].
	"Classification groups"
	self addClassConstant: 'FpClassInfinite'
		value: OS.CRTConstants._FPCLASS_NINF | OS.CRTConstants._FPCLASS_PINF.
	self addClassConstant: 'FpClassStrictlyPositive'
		value: OS.CRTConstants._FPCLASS_PD | OS.CRTConstants._FPCLASS_PN | OS.CRTConstants._FPCLASS_PINF.
	self addClassConstant: 'FpClassNegative'
		value: OS.CRTConstants._FPCLASS_ND | OS.CRTConstants._FPCLASS_NN | OS.CRTConstants._FPCLASS_NINF
				| OS.CRTConstants._FPCLASS_NZ.
	self addClassConstant: 'FpClassZero'
		value: OS.CRTConstants._FPCLASS_NZ | OS.CRTConstants._FPCLASS_PZ.
	self addClassConstant: 'FpClassNaN'
		value: OS.CRTConstants._FPCLASS_QNAN | OS.CRTConstants._FPCLASS_SNAN.
	"Denormalized numbers - non-zero but with leading zeroes in the mantissa"
	self addClassConstant: 'FpClassDenormal'
		value: OS.CRTConstants._FPCLASS_PD | OS.CRTConstants._FPCLASS_ND.
	"Non-zero, normals"
	self addClassConstant: 'FpClassNormal'
		value: OS.CRTConstants._FPCLASS_NN | OS.CRTConstants._FPCLASS_PN.
	"Finite numbers (anything other than infinites or NaNs)"
	self addClassConstant: 'FpClassFinite'
		value: OS.CRTConstants._FPCLASS_NN | OS.CRTConstants._FPCLASS_ND | OS.CRTConstants._FPCLASS_NZ
				| OS.CRTConstants._FPCLASS_PZ | OS.CRTConstants._FPCLASS_PD
				| OS.CRTConstants._FPCLASS_PN.
	DefaultDecimalExponents := -3 to: 6!

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
	^OS.Ucrt _statusfp!

zero
	"Answer the receiver's representation of zero."

	^0.0! !

!Core.Float class categoriesForMethods!
defaultDecimalExponents!accessing!public! !
defaultDecimalExponents:!accessing!public! !
denormalized!public!testing! !
e!constants!public! !
emax!constants!public! !
emin!constants!public! !
epsilon!constants!public! !
exceptionMask!accessing!public! !
exceptionMask:!accessing!public! !
fmax!constants!public! !
fmin!constants!public! !
fminDenormalized!constants!public! !
fminNormalized!constants!public! !
infinity!constants!public! !
initialize!development!initializing!private! !
maxExponent!constants!private! !
maxLiteralIntegerExponent!constants!private! !
nan!constants!public! !
negativeInfinity!constants!public! !
negativeZero!constants!public! !
new!instance creation!public! !
one!instance creation!public! !
onStartup!event handling!private! !
pi!constants!public! !
precision!constants!public! !
radix!constants!public! !
readFrom:!instance creation!public! !
reset!initializing!public! !
statusFlags!accessing!public! !
zero!instance creation!public! !
!

Core.Float class methodProtocol: #floatCharacterization attributes: #(#ansi #readOnly) selectors: #(#denormalized #e #emax #emin #epsilon #fmax #fmin #fminDenormalized #fminNormalized #pi #precision #radix)!

