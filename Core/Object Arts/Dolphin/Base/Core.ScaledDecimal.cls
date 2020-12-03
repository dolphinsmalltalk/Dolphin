"Filed out from Dolphin Smalltalk 7"!

Core.Number subclass: #'Core.ScaledDecimal'
	instanceVariableNames: 'fraction scale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ScaledDecimal guid: (Core.GUID fromString: '{f44c914b-2b3f-11d3-8368-7a8b5a000000}')!
Core.ScaledDecimal comment: 'ScaledDecimal is a Number class to represent fixed point decimal numbers. It supports unbounded precision, with no practical limit to the number of digits before and after the decimal point.

ScaledDecimal conforms to the following ANSI protocols:
	Float
	magnitude
	number
	Object
	rational
	scaledDecimal

A ScaledDecimal represents a value as a Fraction and the number of digits after the decimal point. This representation allows us to take advantage of the implementation of unbounded rational numbers provided by Fraction with very small amount of simple code.

We are grateful to Richard A. Harmon for contributing his ANSI compliant ScaledDecimal implementation from which this class was derived.
'!
!Core.ScaledDecimal categoriesForClass!Magnitude-Numbers! !
!Core.ScaledDecimal methodsFor!

- operand
	"Answer the difference between the receiver and the <number>
	argument, operand."

	^operand subtractFromScaledDecimal: self!

* operand
	"Answer the result of multiplying the receiver by the <number>
	argument, operand."

	^operand multiplyByScaledDecimal: self!

/ operand
	"Answer the result of dividing the receiver by <number> argument, 
	operand. Raise a <ZeroDivide> exception if the operand is zero."

	^operand divideIntoScaledDecimal: self!

// operand 
	"Answer the <integer> quotient defined by division with truncation toward negative infinity
	of the receiver by the <number> operand."

	^fraction // operand!

+ operand
	"Answer the sum of the receiver and the <number> argument, 
	operand."

	^operand addToScaledDecimal: self
!

< operand
	"Answer whether the receiver is less than the <number>, operand."

	^operand greaterThanScaledDecimal: self
!

addToScaledDecimal: operand
	"Private - Answer the <ScaledDecimal> result of adding the receiver
	to the known <ScaledDecimal>."

	^self species
		newFromNumber: operand asFraction + fraction
		scale: (self scale max: operand scale)!

asFloat
	"Answer the receiver represented as the nearest possible <Float>."

	^fraction asFloat
!

asFraction
	"Answer an <integer> or <fraction> approximating the receiver."

	^fraction!

asScaledDecimal: newScale
	"Answer a new <ScaledDecimal>, with a fractional precision of scale, 
	which most nearly approximates the receiver."

	^self species
		newFromNumber: fraction
		scale: newScale!

coerce: coercee
	"Private - Coerce the <ArithmeticValue>, coercee, which must be of a lower generality than the receiver, to be the 
	same type as the receiver."

	^coercee asScaledDecimal: scale
!

denominator
	"Answer the <integer> denominator of the receiver."

	^fraction denominator
!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| scaler quo num denom scaled |
	scaler := scale exp10.
	num := fraction numerator.
	denom := fraction denominator.
	scaled := (num * scaler + (denom bitShift: -1)) // denom.
	num negative
		ifTrue: 
			[aPuttableStream nextPut: $-.
			scaled := scaled negated].
	quo := scaled quo: scaler.
	quo printOn: aPuttableStream.
	scale > 0
		ifTrue: 
			[| rem |
			aPuttableStream nextPut: $..
			rem := scaled.
			scale timesRepeat: 
					[rem := (rem - (quo * scaler)) * 10.
					quo := rem quo: scaler.
					aPuttableStream nextPut: (Character digitValue: quo)]]!

divideIntoScaledDecimal: operand
	"Private - Answer the result of dividing the known <ScaledDecimal>, operand, by the receiver."

	^self species
		newFromNumber: operand asFraction / fraction
		scale: (scale max: operand scale)!

fractionPart
	"Answer a <number> of the same type as the receiver, representing the 
	fractional part of  the receiver."

	^self species
		newFromNumber: fraction fractionPart
		scale: scale!

generality
	"Private - Answer the Smalltalk generality of the receiver, used for performing type conversions.
	ScaledDecimals are considered more general than Fractions but less general than Floats."

	"There is some controversy as to whether this is the correct generality for ScaledDecimals.
	Theoretically ScaledDecimals are more general than Floats, however traditionally Floats
	have been considered more general than Fractions although they clearly aren't (perhaps
	this arrangement was chosen for reasons of efficiency). Therefore making ScaledDecimals
	sit in between fits with the historic arrangements. It may be that the whole scheme needs to
	be altered for ANSI compatibility (or that the ANSI standard needs to be altered for
	compatibility with existing applications)."

	^35!

greaterThanScaledDecimal: comperand
	"Private - Answer whether the receiver is greater than the known <ScaledDecimal>, comperand."

	^comperand asFraction < fraction!

hash
	"Answer the <integer> hash value for the receiver." 

	^fraction hash
!

integerPart
	"Answer a <ScaledDecimal> representing the integral part of the receiver."

	^self species
		newFromNumber: fraction integerPart
		scale: scale!

isLiteral
	"Answer if this number can be represented as a literal that when evaluated would result in an equivalent ScaledDecimal.
	This is only the case when the fraction can be represented precisely within the scale."

	^fraction isInteger or: [(10 raisedTo: scale) \\ fraction denominator = 0]!

isZero
	"Answer whether the receiver is equal to its class' zero"

	^fraction isZero!

multiplyByScaledDecimal: operand
	"Private - Multiply the receiver by the known <ScaledDecimal>, operand,
	answering the result."

	^self species
		newFromNumber: operand asFraction * fraction
		scale: (scale max: operand scale)!

negated
	"Answer a <number> of the same type of the receiver
	which is its negation."

	^self species
		newFromNumber: fraction negated
		scale: scale!

numerator
	"Answer the <integer> numerator of the receiver."

	^fraction numerator
!

printOn: target
	"Append, to the <puttableStream>, target, a string whose characters are a 
	the same as those which would result from sending a #printString
	message to the receiver."

	self displayOn: target.
	target nextPut: $s!

raisedToInteger: operand
	"Answer the receiver raised to the <integer> power, operand."

	^self species
		newFromNumber: (fraction raisedToInteger: operand)
		scale: self scale
!

reciprocal
	"Answer a <ScaledDecimal> which is the reciprocal of the receiver (i.e. 1/receiver).
	Raise a ZeroDivide exception if the receiver is zero.
	Implementation Note: Override because we can implement this much more
	efficiently by simply flipping over our Fraction (done in its own efficient reciprocal)."

	^self species
		newFromNumber: fraction reciprocal
		scale: scale
!

scale
	"Answer an <integer> which represents the total number of digits used to 
	represent the fraction part of the receiver, including trailing zeroes."

	^scale
!

setFraction: f scale: s 
	"Private - Initialize the receiver's identity variables."

	fraction := f.
	scale := s.
	self isImmutable: true!

storeOn: aStream
	"Append to the <puttableStream> argument, target, an expression which when evaluated will answer a collection similar to the receiver.
	Use the literal form of ScaledDecimals when precise."

	self isLiteral
		ifTrue: [self printOn: aStream]
		ifFalse: 
			[aStream
				nextPut: $(;
				display: fraction;
				nextPut: $s;
				print: scale;
				nextPut: $)]!

subtractFromScaledDecimal: operand
	"Private - Answer the result of subtracting the receiver from the 
	known <ScaledDecimal>, operand."

	^self species
		newFromNumber: operand asFraction - fraction
		scale: (scale max: operand scale)!

truncated
	"Answer the <integer> nearest the receiver toward zero."

	^fraction truncated
! !
!Core.ScaledDecimal categoriesFor: #-!arithmetic!public! !
!Core.ScaledDecimal categoriesFor: #*!arithmetic!public! !
!Core.ScaledDecimal categoriesFor: #/!arithmetic!public! !
!Core.ScaledDecimal categoriesFor: #//!arithmetic!public! !
!Core.ScaledDecimal categoriesFor: #+!arithmetic!public! !
!Core.ScaledDecimal categoriesFor: #<!comparing!public! !
!Core.ScaledDecimal categoriesFor: #addToScaledDecimal:!double dispatch!private! !
!Core.ScaledDecimal categoriesFor: #asFloat!converting!public! !
!Core.ScaledDecimal categoriesFor: #asFraction!converting!public! !
!Core.ScaledDecimal categoriesFor: #asScaledDecimal:!converting!public! !
!Core.ScaledDecimal categoriesFor: #coerce:!coercing!private! !
!Core.ScaledDecimal categoriesFor: #denominator!accessing!public! !
!Core.ScaledDecimal categoriesFor: #displayOn:!printing!public! !
!Core.ScaledDecimal categoriesFor: #divideIntoScaledDecimal:!double dispatch!private! !
!Core.ScaledDecimal categoriesFor: #fractionPart!accessing!public! !
!Core.ScaledDecimal categoriesFor: #generality!coercing!private! !
!Core.ScaledDecimal categoriesFor: #greaterThanScaledDecimal:!double dispatch!private! !
!Core.ScaledDecimal categoriesFor: #hash!comparing!public! !
!Core.ScaledDecimal categoriesFor: #integerPart!accessing!public! !
!Core.ScaledDecimal categoriesFor: #isLiteral!public!testing! !
!Core.ScaledDecimal categoriesFor: #isZero!public!testing! !
!Core.ScaledDecimal categoriesFor: #multiplyByScaledDecimal:!double dispatch!private! !
!Core.ScaledDecimal categoriesFor: #negated!arithmetic!public! !
!Core.ScaledDecimal categoriesFor: #numerator!accessing!public! !
!Core.ScaledDecimal categoriesFor: #printOn:!printing!public! !
!Core.ScaledDecimal categoriesFor: #raisedToInteger:!mathematical!public! !
!Core.ScaledDecimal categoriesFor: #reciprocal!arithmetic!public! !
!Core.ScaledDecimal categoriesFor: #scale!accessing!public! !
!Core.ScaledDecimal categoriesFor: #setFraction:scale:!initializing!private! !
!Core.ScaledDecimal categoriesFor: #storeOn:!public! !
!Core.ScaledDecimal categoriesFor: #subtractFromScaledDecimal:!double dispatch!private! !
!Core.ScaledDecimal categoriesFor: #truncated!public!truncation and round off! !

Core.ScaledDecimal methodProtocol: #scaledDecimal attributes: #(#ansi #readOnly) selectors: #(#- #* #/ #// #\\ #+ #< #<= #> #>= #abs #asFloat #asFloatD #asFloatE #asFloatQ #asFraction #asInteger #asScaledDecimal: #between:and: #ceiling #floor #fractionPart #integerPart #max: #min: #negated #negative #positive #quo: #raisedTo: #raisedToInteger: #reciprocal #rem: #rounded #roundTo: #scale #sign #sqrt #squared #strictlyPositive #to: #to:by: #to:by:do: #to:do: #truncated #truncateTo:)!

!Core.ScaledDecimal class methodsFor!

maxPrecision
	"Private - The maximum allowed precision for <ScaledDecimal>s parsed from literal string format. The
	theoretical limit of the implementation is unbounded, but we impose an arbitrary limit to
	prevent accidentally causing pathologically long computations. The ANSI standard specifies a
	minimum upper on bound on the precision of ScaledDecimals of 30, so 9999 ought to be
	sufficient for most purposes."

	^9999!

newFromNumber: aNumber scale: scaleInteger
	"Answer a new instance of me."

	^self basicNew
		setFraction: aNumber asFraction scale: scaleInteger;
		yourself!

one
	"Answer the receiver's representation of one."

	^self
		newFromNumber: 1
		scale: 0!

zero
	"Answer the receiver's representation of zero."

	^self
		newFromNumber: 0
		scale: 0
! !
!Core.ScaledDecimal class categoriesFor: #maxPrecision!accessing!private! !
!Core.ScaledDecimal class categoriesFor: #newFromNumber:scale:!instance creation!public! !
!Core.ScaledDecimal class categoriesFor: #one!instance creation!public! !
!Core.ScaledDecimal class categoriesFor: #zero!instance creation!public! !

