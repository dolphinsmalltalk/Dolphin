"Filed out from Dolphin Smalltalk 7"!

Number variableByteSubclass: #Float
	instanceVariableNames: ''
	classVariableNames: 'DefaultSigFigs FMax FMin SignificantDifference'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Float guid: (GUID fromString: '{87B4C65A-026E-11D3-9FD7-00A0CC3E4A32}')!
Float comment: 'Float is the class of double precision floating point Numbers (64-bit) in IEEE-754 format. Note that the original Smalltalk-80 definition of Float, was only single precision, but this is considered somewhat outdated. Rather than introduce the complexity of multiple classes to represent floating point numbers, we have chosen to standardise on double precision.

Class Variables:
	SignificantDifference	<Float>. Difference between two Floats which is considered sufficient to deem them unequal. The smallest this can be is Float class>>epsilon.
	DefaultSigFigs	<SmallInteger>. Default digits of precision displayed.

'!
!Float categoriesForClass!Magnitude-Numbers! !
!Float methodsFor!

- aNumber
	"Answer the result of subtracting the argument, aNumber, from the receiver.

	Primitive failure reasons:
		0 -	aNumber is not a SmallInteger or a Float.

	May also raise a floating point exception."

	<primitive: 161>
	^aNumber subtractFromFloat: self!

* aNumber
	"Answer the result of multiplying the receiver by the argument, aNumber.

	Primitive failure reasons:
		0 -	aNumber is not a SmallInteger or a Float.

	May also raise a floating point exception."

	<primitive: 164>
	^aNumber multiplyByFloat: self!

/ operand
	"Answer the result of dividing the receiver by the <number>, operand.
	Raise a <ZeroDivide> exception if the operand is zero.

	Primitive failure reasons:
		0 -	aNumber is not a SmallInteger or a Float."

	<primitive: 165>
	^operand divideIntoFloat: self!

+ aNumber
	"Answer the result of adding aNumber to the receiver.

	Primitive failure reasons:
		0 -	aNumber is not a SmallInteger or a Float.

	May also raise a floating point exception."

	<primitive: 160>
	^aNumber addToFloat: self!

< aNumber
	"Answer true if the receiver is less than aNumber. This relational operator is 
	implemented as a primitive, and >, <=, and >= are expressed in terms of it.

	Primitive failure reasons:
		0 -	aNumber is not a SmallInteger or a Float.

	May also raise a floating point exception."

	<primitive: 162>
	^aNumber greaterThanFloat: self
!

= comperand
	"Answer whether the receiver is numerically equivalent to the argument,
	comperand (e.g. 1 = 1.0 is true).

	Primitive failure reasons:
		0 -	aNumber is not a SmallInteger or a Float.

	May also raise a floating point exception."

	<primitive: 163>
	^super = comperand!

abs
	"Answer a Number that is the absolute value - positive magnitude - of the receiver."

	^CRTLibrary default fabs: self
	!

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

	^(CRTLibrary default _logb: self) truncated!

floor
	"Answer the integer nearest the receiver toward negative infinity."

	^(CRTLibrary default floor: self) truncated
!

floorLog10
	"Answer the base 10 exponent of the receiver (an Integer between -308 and 308)."

	^self log floor!

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

printOn: target
	"Append the ASCII representation of the receiver to the <puttableStream>, target.

	The representation we use is a valid literal representation for floating point
	numbers, recognised by the Smalltalk compiler."

	self printOn: target significantFigures: DefaultSigFigs!

printOn: aStream decimalPlaces: anInteger 
	"Append the printed representation of the receiver to the <puttableStream>,
	aStream, rounded	to the <integer> number of decimal places, anInteger.
	Implementation Note: fcvt() is a jolly quirky function, hence the
	complexity. This seemed preferable to reinventing the wheel, but
	now I'm not so sure!!"

	| sign ptPos digits |
	anInteger < 1 ifTrue: [^self rounded printOn: aStream].
	ptPos := SDWORD new.
	sign := SDWORD new.
	digits := CRTLibrary default 
				_fcvt: self
				count: anInteger
				dec: ptPos
				sign: sign.
	sign asInteger = 0 ifFalse: [aStream nextPut: $-].
	ptPos := ptPos asInteger.
	ptPos <= 0 ifTrue: [aStream nextPut: $0].
	ptPos < 0 
		ifTrue: 
			[aStream
				nextPut: $.;
				next: (ptPos negated min: anInteger) put: $0;
				nextPutAll: digits]
		ifFalse: 
			[aStream
				next: ptPos
					putAll: digits
					startingAt: 1;
				nextPut: $.;
				next: digits size - ptPos
					putAll: digits
					startingAt: ptPos + 1]!

printOn: aStream significantFigures: anInteger 
	"Append the printed representation of the receiver to aStream with
	anInteger significant figures. Ensure that there is always a digit
	following the decimal point.
	Implementation Note: Make use of the CRT to avoid reinventing the
	wheel. #printOn:decimalPlaces: may be more convenient when printing
	reports, formatting output fields, etc, as it does not drop into
	exponential format."

	| buf ptPos |
	buf := String new: (anInteger bitShift: 1) + 10.
	buf := CRTLibrary default 
				_gcvt: self
				count: anInteger
				buffer: buf.

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

rounded
	"Answer the <integer> nearest the receiver."

	^(self < 0.0 ifTrue: [self - 0.5] ifFalse: [self + 0.5]) truncated!

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
!Float categoriesFor: #abs!mathematical!public! !
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
!Float categoriesFor: #floor!public!truncation and round off! !
!Float categoriesFor: #floorLog10!mathematical!public! !
!Float categoriesFor: #fractionPart!accessing!public! !
!Float categoriesFor: #generality!coercing!private! !
!Float categoriesFor: #greaterOrEquals:!comparing!public! !
!Float categoriesFor: #greaterThanFraction:!double dispatch!private! !
!Float categoriesFor: #greaterThanInteger:!double dispatch!private! !
!Float categoriesFor: #hash!comparing!public! !
!Float categoriesFor: #integerPart!accessing!public! !
!Float categoriesFor: #lessOrEquals:!comparing!public! !
!Float categoriesFor: #ln!mathematical!public! !
!Float categoriesFor: #log!mathematical!public! !
!Float categoriesFor: #multiplyByFloat:!double dispatch!private! !
!Float categoriesFor: #multiplyByFraction:!double dispatch!private! !
!Float categoriesFor: #multiplyByInteger:!double dispatch!private! !
!Float categoriesFor: #negative!public!testing! !
!Float categoriesFor: #printOn:!printing!public! !
!Float categoriesFor: #printOn:decimalPlaces:!printing!public! !
!Float categoriesFor: #printOn:significantFigures:!printing!public! !
!Float categoriesFor: #raisedTo:!mathematical!public! !
!Float categoriesFor: #rounded!public!truncation and round off! !
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

	"Implementation Note: This value is that needed tocorrectly calculate 
	#fmax by the expression on p141 of the ANSI Smalltalk standard, 
	but the IEEE 754 double-precision value for emax is +1023."

	^1024!

emin
	"Answer an <integer> representing the smallest exponent
	of the characterized floating point representation."

	"Implementation Note: This value is that needed tocorrectly calculate 
	#fminNormalized by the expression on p142 of the ANSI Smalltalk standard, 
	but the IEEE 754 double-precision value for emin is -1022."

	^-1021!

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

	^self radix asFloat raisedTo: self emin - self precision!

fminNormalized
	"Answer a <Float> representing the smallest normalized value
	allowed by the characterized floating point representation."

	^FMin!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the class variables of the receiver
		Float initialize
	"

	"There are only just over 15 digits of precision in a 64-bit IEEE float, but not 16 digits."

	DefaultSigFigs := 15.
	SignificantDifference := 1.0e-009.
	self assert: [SignificantDifference >= self epsilon].
	FMax := ((1 - (self radix raisedTo: self precision negated)) 
				* (self radix raisedTo: self emax)) asFloat.
	FMin := self radix asFloat raisedTo: self emin - 1.
	#(#FloatD #FloatE #FloatQ) do: [:each | Smalltalk at: each ifAbsentPut: [self]]!

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

	^53!

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
	CRTLibrary default _controlfp: CRTConstants._PC_64 mask: CRTConstants._MCW_PC!

setExceptionMask: anInteger
	"Private - Set the current floating point exception mask
	to anInteger. Answer the previous mask."

	^CRTLibrary default _controlfp: anInteger mask: CRTConstants._MCW_EM!

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

