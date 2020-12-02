"Filed out from Dolphin Smalltalk 7"!

ArithmeticValue subclass: #Number
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Number guid: (GUID fromString: '{87b4c657-026e-11d3-9fd7-00a0cc3e4a32}')!
Number isAbstract: true!
Number comment: 'Number is the abstract class which defines the common protocol of all numeric objects.

Its messages support standard arithmetic operations and comparisons, which are mostly implemented by subclasses.'!
!Number categoriesForClass!Magnitude-Numbers! !
!Number methodsFor!

arcCos
	"Answer a <Float> which is the inverse cosine of the receiver in radians"

	^self asFloat arcCos!

arcSin
	"Answer a <Float> which is the inverse sine of the receiver in radians"

	^self asFloat arcSin!

arcTan
	"Answer a <Float> which is the inverse tangent of the receiver in radians"

	^self asFloat arcTan!

arcTan: aNumber
	"Answer the arc-tangent of the receiver/aNumber in radians."

	^self asFloat arcTan: aNumber!

asFloat
	"Answer the receiver represented as the nearest possible <Float>.
	 Implementation Note: Dolphin only supports double precision floating 
	point numbers, so the answer will be such (i.e. a FloatD) even if a smaller 
	representation is possible."

	^self subclassResponsibility!

asFloatD
	"Answer a 'd' precision floating-point number approximating the receiver."

	^self asFloat!

asFloatE
	"Answer an 'e' precision floating-point number approximating the receiver.
	 Implementation Note: Dolphin only suppots double precision floating 
	point numbers, so the answer will be such (i.e. a FloatD)."

	^self asFloat!

asFloatQ
	"Answer a 'q' precision floating-point number approximating the receiver.
	 Implementation Note: Dolphin only suppots double precision floating 
	point numbers, so the answer will be such (i.e. a FloatD)."

	^self asFloat!

asFraction
	"Answer an <integer> or <fraction> approximating the receiver."

	^self subclassResponsibility!

asInteger
	"Answer the nearest <integer> value to the receiver."

	^self rounded!

asScaledDecimal: scale
	"Answer a <ScaledDecimal> number, with the fractional precision 
	specified by the <integer>, scale, which most nearly approximates
	the receiver."

	^ScaledDecimal
		newFromNumber: self
		scale: scale
!

asTrueFraction
	"Answer a <rational> that precisely represents the same value as the receiver."

	^self asFraction!

closeTo: aNumber 
	"Pharo compatibility"

	^ self closeTo: aNumber precision: 0.0001!

closeTo: aNumber precision: precisionFloat
	| max |
	^(max := self abs max: aNumber abs) <= precisionFloat
		or: [(self - aNumber) abs < (precisionFloat * max)]!

copy
	"Answer a copy of the receiver (by default a copy which shares the receiver's 
	instance variables). Numbers are immutable, so we answer the receiver itself."

	^self!

cos
	"Answer a <Float> which is the cosine of the receiver, 
	which is treated as an angle in radians"

	^self asFloat cos!

days
	^Duration days: self!

degreesToRadians
	"Answer a <Float> representing the receiver converted from degrees to radians."
	
	^self * ##(Float pi / 180.0)!

denominator
	"Answer the <integer> denominator of the receiver."

	^1!

divideByZero
	"Private - Generate a division by zero error"

	^ZeroDivide dividend: self!

divideIntoDuration: aDuration 
	"Private - Answer a new <Duration> which represents the the value in seconds of aDuration divided by the receiver."

	^aDuration class seconds: aDuration asSeconds / self!

even
	"Answer whether the receiver is an even number. Zero is considered even"

	^(self \\ 2) isZero!

exp
	"Answer a <Float> which is the natrual exponential value of the 
	receiver (i.e. 'e' raised to the power of the receiver).
	This is the inverse of #ln."

	^self asFloat exp!

floorLog: operand
	"Answer an <integer> which is the logarithm to the <number> base, operand,
	of the receiver, truncated towards negative infinity."
	
	^(self log: operand) floor!

fractionPart
	"Answer a <number> of the same type as the receiver, representing the 
	fractional part of  the receiver."

	^self - self truncated
!

hour
	^self hours!

hours
	"Answer a <Duration> which is equivalent to the number of hours represented by the receiver."

	^Duration hours: self!

integerPart
	"Answer an <integer>  representing the whole integer part of 
	the receiver."

	^self truncated!

isFloat
	"Answer true if receiver is an instance of class Float, else answer false."

	^false
!

isFraction
	"Answer true if receiver is an instance of class Fraction, else answer false."

	^false
!

isLiteral
	"Answer whether the receiver the receiver has a literal representation which
	is recognised by the Compiler"

	^true!

isNumber
	"Coerces numbers to true and everything else to false."

	^true!

ln
	"Answer a <Float> which is the natural logarithm of the receiver."

	^self asFloat ln!

log
	"Answer the common logarithm (log to the base 10) of the receiver"

	^self asFloat log!

log: operand
	"Answer a <Float> which is the logarithm to the <number> base, 
	operand, of the receiver."

	^self ln / operand ln!

microseconds
	^Duration microseconds: self!

milliseconds
	^Duration milliseconds: self!

minutes
	^Duration minutes: self!

nanoseconds
	^Duration nanoseconds: self!

numerator
	"Answer the <integer> numerator of the receiver. Default is the receiver which can be 
	overridden by the subclasses (e.g. Fraction)."

	^self!

odd
	"Answer whether the receiver is an odd number."

	^self even not!

radiansToDegrees
	"Answer a <Float> which is the receiver converted from radians to degrees."

	^self * ##(180.0 / Float pi)!

raisedTo: operand
	"Answer a <number> which is the receiver raised to the power of 
	the <number> argument, operand.
	Raise a FloatingPointException for overflow if the answer must be
	a <Float> and exceeds the representable range of a double precision
	floating point number."

	self = self class one ifTrue: [^self].
	operand isInteger ifTrue: [^self raisedToInteger: operand].
	self isZero ifTrue: [^operand <= 0 ifTrue: [self error: 'Invalid operands'] ifFalse: [self]].
	^(self asFloat ln * operand) exp!

seconds
	^Duration seconds: self!

sin
	"Answer a <Float> which is the sine of the receiver, 
	which is treated as an angle in radians."

	^self asFloat sin!

sqrt
	"Answer a <number> which is the positive square root of the receiver."
	
	^self asFloat sqrt!

tan
	"Answer a <Float> which is the tangent of the receiver, 
	which is treated as an angle in radians."

	^self asFloat tan!

to: stop
	"Answer an <interval> from the receiver up to the argument, stop, with an interval of 1 
	between elements."

	^Interval from: self to: stop by: 1!

to: stop by: step
	"Answer an <interval> from the receiver up to the argument, stop, with an interval of 
	the argument, step, between elements."

	^Interval from: self to: stop by: step!

to: stop by: step do: operation
	"Evaluate the <monadicBlock> argument, operation, for each <number> between the 
	receiver and the <number> argument, stop, in increments of the <number> argument, step."

	"Implementation Note:  This message is inlined by the compiler for all cases where the step is
	a numeric literal (i.e. most of the time), so this implementation is not much used."

	(self to: stop by: step) do: operation!

to: stop do: operation
	"Evaluate the <monadicBlock> operation passing it the <number> sequence beginning 
	with the receiver, and incrementing by one until the <number> argument, stop, is reached, 
	inclusive. 
	Implementation Note: This method is critical to overall system performance, and is normally inlined by 
	the compiler, so this implementation is used only when #perform:'ed."

	(self to: stop) do: operation! !
!Number categoriesFor: #arcCos!mathematical!public! !
!Number categoriesFor: #arcSin!mathematical!public! !
!Number categoriesFor: #arcTan!mathematical!public! !
!Number categoriesFor: #arcTan:!mathematical!public! !
!Number categoriesFor: #asFloat!converting!public! !
!Number categoriesFor: #asFloatD!converting!public! !
!Number categoriesFor: #asFloatE!converting!public! !
!Number categoriesFor: #asFloatQ!converting!public! !
!Number categoriesFor: #asFraction!converting!public! !
!Number categoriesFor: #asInteger!converting!public! !
!Number categoriesFor: #asScaledDecimal:!converting!public! !
!Number categoriesFor: #asTrueFraction!converting!public! !
!Number categoriesFor: #closeTo:!comparing!public! !
!Number categoriesFor: #closeTo:precision:!comparing!public! !
!Number categoriesFor: #copy!copying!public! !
!Number categoriesFor: #cos!mathematical!public! !
!Number categoriesFor: #days!converting!durations!public! !
!Number categoriesFor: #degreesToRadians!converting!public! !
!Number categoriesFor: #denominator!accessing!public! !
!Number categoriesFor: #divideByZero!exceptions!private! !
!Number categoriesFor: #divideIntoDuration:!double dispatch!durations!private! !
!Number categoriesFor: #even!public!testing! !
!Number categoriesFor: #exp!mathematical!public! !
!Number categoriesFor: #floorLog:!mathematical!public! !
!Number categoriesFor: #fractionPart!accessing!public! !
!Number categoriesFor: #hour!converting!durations!public! !
!Number categoriesFor: #hours!converting!durations!public! !
!Number categoriesFor: #integerPart!accessing!public! !
!Number categoriesFor: #isFloat!public!testing! !
!Number categoriesFor: #isFraction!public!testing! !
!Number categoriesFor: #isLiteral!public!testing! !
!Number categoriesFor: #isNumber!public!testing! !
!Number categoriesFor: #ln!mathematical!public! !
!Number categoriesFor: #log!mathematical!public! !
!Number categoriesFor: #log:!mathematical!public! !
!Number categoriesFor: #microseconds!converting!durations!public! !
!Number categoriesFor: #milliseconds!converting!durations!public! !
!Number categoriesFor: #minutes!converting!durations!public! !
!Number categoriesFor: #nanoseconds!converting!durations!public! !
!Number categoriesFor: #numerator!accessing!public! !
!Number categoriesFor: #odd!public!testing! !
!Number categoriesFor: #radiansToDegrees!converting!public! !
!Number categoriesFor: #raisedTo:!mathematical!public! !
!Number categoriesFor: #seconds!converting!durations!public! !
!Number categoriesFor: #sin!mathematical!public! !
!Number categoriesFor: #sqrt!mathematical!public! !
!Number categoriesFor: #tan!mathematical!public! !
!Number categoriesFor: #to:!enumerating!public! !
!Number categoriesFor: #to:by:!enumerating!public! !
!Number categoriesFor: #to:by:do:!enumerating!public! !
!Number categoriesFor: #to:do:!enumerating!public! !

Number methodProtocol: #number attributes: #(#ansi #readOnly) selectors: #(#- #* #/ #// #\\ #+ #< #<= #> #>= #abs #asFloat #asFloatD #asFloatE #asFloatQ #asFraction #asInteger #asScaledDecimal: #between:and: #ceiling #floor #fractionPart #integerPart #max: #min: #negated #negative #positive #quo: #raisedTo: #raisedToInteger: #reciprocal #rem: #rounded #roundTo: #sign #sqrt #squared #strictlyPositive #to: #to:by: #to:by:do: #to:do: #truncated #truncateTo:)!
Number methodProtocol: #rational attributes: #(#ansi #readOnly) selectors: #(#- #* #/ #// #\\ #+ #< #<= #> #>= #abs #asFloat #asFloatD #asFloatE #asFloatQ #asFraction #asInteger #asScaledDecimal: #between:and: #ceiling #denominator #floor #fractionPart #integerPart #max: #min: #negated #negative #numerator #positive #quo: #raisedTo: #raisedToInteger: #reciprocal #rem: #rounded #roundTo: #sign #sqrt #squared #strictlyPositive #to: #to:by: #to:by:do: #to:do: #truncated #truncateTo:)!

!Number class methodsFor!

errorExponentTooLarge: anInteger
	^InvalidFormat signal: ('Exponent <1p> is too large' expandMacrosWith: anInteger) with: self!

errorInvalidFormat
	"Private - Raise an error that some attempt to create an instance of the receiver failed
	because the some input was in the wrong format."

	^InvalidFormat signalWith: self!

fromString: aString 
	"Instantiate a new instance of the receiver from the <readableString> argument."

	| stream answer |
	#todo.	"Should be separate fromDisplayString: version which converts from locale specific format (this method from Smalltalk format)"
	stream := aString readStream.
	answer := self readFrom: stream.
	stream atEnd ifFalse: [^self errorInvalidFormat].
	^answer!

maxLiteralIntegerExponent
	"Private - The maximum allowed exponent (power of 10) in the literal integer form '<int>e<powerOf10>'.
	This is an arbitrary limit imposed to prevent accidentally causing pathologically long
	computations, for example by accidentally evaluating the string representation of a Guid like 
	this one: 5e967948-0810-11d4-a876-0050da643bf9."

	"There is no real physical limit (other than memory), but calculating a literal integer can
	be slow for large 'e'. For most practical purposes integers of 2000 or so decimal digits ought to be
	sufficient bearing in mind that the absolute maximum decimal exponent of a 64-bit Float is
	308!!"

	^2000!

new
	"Answer a new instance of the receiver.
	Numbers are either immutable, or require more specific instantiation
	methods, therefore the standard instance creation protocol is not supported."

	^self shouldNotImplement!

one
	"Answer the receiver's representation of one. For many Numbers this 
	is the SmallInteger 1"

	^1!

readDecimalIntegerFrom: aStream allowPlus: aBoolean 
	"Private - Read a positive or negative decimal integer from the <gettableStream>, aStream, which
	has neither radix nor exponent. Return nil if there is no integer at the current position in
	the stream."

	| isNegative plus |
	isNegative := aStream peekFor: $-.
	plus := aBoolean and: [isNegative not and: [aStream peekFor: $+]].
	^(self readIntegerFrom: aStream radix: 10) 
		ifNil: 
			[(isNegative or: [plus]) ifTrue: [aStream pop].
			nil]
		ifNotNil: [:value | isNegative ifTrue: [value negated] ifFalse: [value]]!

readExponentIntegerFrom: aStream initialInteger: anInteger
	"Private - A partially recognised exponentInteger has been read from the <gettableStream>, aStream,
	which is positioned immediately after the $r. Read the rest of the Integer and answer its value,
	or if not an exponentInteger, pop the $r and answer anInteger. Note that the exponent is always
	considered to be expressed in base 10."

	"Allow plus prefix on exponent, e.g. 1.0e+16, although not strictly Smalltalk syntax."

	^(self readDecimalIntegerFrom: aStream allowPlus: true)
		ifNil: 
			[aStream pop.
			anInteger]
		ifNotNil: 
			[:exponent |
			exponent > self maxLiteralIntegerExponent
				ifTrue: [self errorExponentTooLarge: exponent]
				ifFalse: [anInteger * exponent exp10]]!

readFractionFrom: aStream initialInteger: anInteger 
	"Private - A partially recognised Fraction has been read from the <gettableStream>, aStream,
	which is positioned immediate after the $/. Read the rest of the Fraction and answer its value,
	or if not a Fraction (determined by the immediate presence of an integer denominator), pop the 
	$/ and answer anInteger."

	^(self readDecimalIntegerFrom: aStream allowPlus: false) 
		ifNil: 
			[aStream pop.
			anInteger]
		ifNotNil: [:denominator | Fraction numerator: anInteger denominator: denominator]!

readFrom: aStream
	"Instantiate a new sub-instance of the receiver from aStream and answer it.
	Any numbers in the stream are expected to obey Smalltalk syntax 
	rather than any locale specific formatting, i.e. this is not intended for reading
	user input. For convenience the set of recognised Number types is expanded
	from just the Smalltalk literal types to also include Fractions."

	| value |
	^(value := self readSmalltalkSyntaxFrom: aStream) isNil 
		ifTrue: [0]
		ifFalse: [
			(value isInteger and: [aStream peekFor: $/]) 
				ifTrue: [self readFractionFrom: aStream initialInteger: value]
				ifFalse: [value]]
!

readIntegerFrom: aStream radix: radix
	"Private - Answer a positive <integer> instantiated from the text representation on aStream 
	using the specified radix. If no integer is found, then answer nil.
	Note: This is intended for reading Integer's obeying Smalltalk syntax, not locale specific
	formats, and therefore it does not handle NLS characters (e.g. thousand separators)."

	| value accumulator |
	accumulator := 0.
	[aStream atEnd] whileFalse: [ | char digit |
		char := aStream next.
		((digit := char digitValue) < radix and: [digit >= 0])
			ifTrue: [value := accumulator := accumulator * radix + digit]
			ifFalse: [aStream pop. ^value]].
	^value
!

readRadixIntegerFrom: aStream initialInteger: anInteger
	"Private - A partially recognised radixInteger has been read from the <gettableStream>, aStream,
	which is positioned immediately after the $r. Read the rest of the Integer and answer its value,
	or if not a radixInteger, pop the $r and answer anInteger."

	| radixInteger |
	^(anInteger < 2 or: [anInteger > 36 or: [(radixInteger := self readIntegerFrom: aStream radix: anInteger) isNil]])
		ifTrue: [aStream pop. anInteger]
		ifFalse: [
			(aStream peekFor: $e) 
				ifTrue: [self readExponentIntegerFrom: aStream initialInteger: radixInteger]
				ifFalse: [radixInteger]]!

readScaledDecimalFrom: aStream mantissa: aNumber precision: anInteger
	"Private - A partially recognised ScaledDecimal has been read from the <gettableStream>, aStream,
	which is positioned immediate after the $s. Read the rest of the ScaledDecimal (which will just
	be the explict scale, if there is one) and answer it."

	| scale |
	(scale := self readIntegerFrom: aStream radix: 10) isNil
		ifTrue: 
			["Implied scale based on the precision specified for the fractional part, .e.g. 2.50s"
			scale := anInteger].
	scale > ScaledDecimal maxPrecision
		ifTrue: 
			[| message |
			message := 'Scale <1p> is too large' expandMacrosWith: scale.
			InvalidFormat signal: message with: self].
	^ScaledDecimal newFromNumber: aNumber scale: scale!

readSmalltalkRealFrom: aStream initialInteger: anInteger
	"Private - Answer a new, positive, <Float> or <ScaledDecimal>, read from the
	<gettableStream>, aStream. The <integer>, integerPart, has already been read from the stream
	and we are currently positioned immediately after the decimal point."

	| nextChar precision fractionalPart start significand impliedScale |
	start := aStream position.
	"Attempt to read positive fractional part"
	(fractionalPart := self readIntegerFrom: aStream radix: 10) isNil
		ifTrue: 
			["Actually just an Integer with a trailing full stop, which we must pop back
			 onto the stream"
			aStream pop.
			^anInteger].
	precision := impliedScale := aStream position - start.

	"So as to not accumulate round off errors the mantissa is kept in integer form."
	fractionalPart = 0
		ifTrue: 
			[significand := anInteger.
			precision := 0]
		ifFalse: [significand := anInteger * precision exp10 + fractionalPart].

	"Process any exponent..."
	((nextChar := aStream peek) == $e or: [nextChar == $d or: [nextChar == $q]])
		ifTrue: 
			[| exponent |
			aStream next.	"Skip the exponent character"
			"Allow plus prefix on the exponent, although not ANSI Smalltalk syntax"
			(exponent := self readDecimalIntegerFrom: aStream allowPlus: true) notNil
				ifTrue: 
					[exponent > Float maxExponent ifTrue: [self errorExponentTooLarge: exponent].
					^exponent >= precision
						ifTrue: [(significand * (exponent - precision) exp10) asFloat]
						ifFalse: 
							["Note that the fraction does not need to be
							 normalized before #asFloat conversion,
							 which will be faster than Integer>>gcd: "
							(Fraction numerator: significand denominator: (exponent negated + precision) exp10) asFloat]].

			"Found Float with trailing exponent character which is not part of the
			number, e.g. 1.5e From ANSI standard p 28: 'An exponentLetter must be
			followed by an explicit exponent'"
			aStream pop]
		ifFalse: 
			[nextChar == $s
				ifTrue: 
					[aStream next.	"Skip the $s"
					^self
						readScaledDecimalFrom: aStream
						mantissa: significand / precision exp10
						precision: impliedScale]].

	"Normal Float, such as 2.5 (perhaps with trailing exponent character)"
	^precision = 0
		ifTrue: [significand asFloat]
		ifFalse: 
			["Again the fraction does not need to be normalized before conversion"
			(Fraction numerator: significand denominator: precision exp10) asFloat]!

readSmalltalkSyntaxFrom: aStream
	"Private - Instantiate a new sub-instance of the receiver from aStream and answer it.
	If no Number is found at the streams current position then answer nil.
	Any numbers in the stream are expected to obey Smalltalk syntax 
	rather than any locale specific formatting, i.e. this is not intended for reading
	user input.  
	WARNING: If you modify this method you may break the compiler.
	Implementation Note: The basic idea is to read the initial integer part and
	then proceed to read a Float if a decimal point is found, a ScaledDecimal if a
	$s is found, etc. Note that Fractions are not a literal type, as otherwise the
	meaning of expressions such as '1+3/4' would not be consistent with the
	normal language semantics (Smalltalk has no operator precedence)."

	| isNegative integerPart answer |
	isNegative := aStream peekFor: $-.
	(integerPart := self readIntegerFrom: aStream radix: 10) isNil
		ifTrue: 
			["There's nothing for you here"
			isNegative ifTrue: [aStream pop].
			^nil].

	"The type of number is determined by what we find next"
	answer := aStream atEnd
				ifTrue: [integerPart]
				ifFalse: 
					[| nextChar |
					nextChar := aStream next.
					nextChar == $.
						ifTrue: 
							[| float |
							float := self readSmalltalkRealFrom: aStream initialInteger: integerPart.
							(isNegative and: [float isZero]) ifTrue: [^Float negativeZero] ifFalse: [float]]
						ifFalse: 
							[nextChar == $r
								ifTrue: [self readRadixIntegerFrom: aStream initialInteger: integerPart]
								ifFalse: 
									[nextChar == $s
										ifTrue: 
											[self
												readScaledDecimalFrom: aStream
												mantissa: integerPart
												precision: 0]
										ifFalse: 
											[nextChar == $e
												ifTrue: [self readExponentIntegerFrom: aStream initialInteger: integerPart]
												ifFalse: 
													[aStream pop.
													integerPart]]
									"Also support St-80 format integer of the form 1e5, not valid ANSI syntax though"]]].
	^isNegative ifTrue: [answer negated] ifFalse: [answer]!

zero
	"Answer the receiver's representation of zero. For many Numbers this 
	is the SmallInteger 0"

	^0! !
!Number class categoriesFor: #errorExponentTooLarge:!parsing!private! !
!Number class categoriesFor: #errorInvalidFormat!exceptions!private! !
!Number class categoriesFor: #fromString:!instance creation!public! !
!Number class categoriesFor: #maxLiteralIntegerExponent!constants!private! !
!Number class categoriesFor: #new!instance creation!public! !
!Number class categoriesFor: #one!instance creation!public! !
!Number class categoriesFor: #readDecimalIntegerFrom:allowPlus:!parsing!private! !
!Number class categoriesFor: #readExponentIntegerFrom:initialInteger:!parsing!private! !
!Number class categoriesFor: #readFractionFrom:initialInteger:!parsing!private! !
!Number class categoriesFor: #readFrom:!instance creation!public! !
!Number class categoriesFor: #readIntegerFrom:radix:!parsing!private! !
!Number class categoriesFor: #readRadixIntegerFrom:initialInteger:!parsing!private! !
!Number class categoriesFor: #readScaledDecimalFrom:mantissa:precision:!parsing!private! !
!Number class categoriesFor: #readSmalltalkRealFrom:initialInteger:!parsing!public! !
!Number class categoriesFor: #readSmalltalkSyntaxFrom:!parsing!private! !
!Number class categoriesFor: #zero!instance creation!public! !

