"Filed out from Dolphin Smalltalk"!

Magnitude subclass: #ArithmeticValue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ArithmeticValue guid: (GUID fromString: '{87b4c64f-026e-11d3-9fd7-00a0cc3e4a32}')!

ArithmeticValue isAbstract: true!

ArithmeticValue comment: ''!

!ArithmeticValue categoriesForClass!Magnitude-General! !

!ArithmeticValue methodsFor!

- operand
	"Answer the difference between the receiver and the <number>
	argument, operand."

	^self + operand negated!

% anArithmeticValue
	"Answer the remainder defined by division with truncation toward zero."

	^self rem: anArithmeticValue!

* operand
	"Answer the result of multiplying the receiver by the <number>
	argument, operand."

	^self subclassResponsibility!

** aNumber 
	"Answer the receiver raised to the power of the argument, aNumber."
	
	^self raisedTo: aNumber!

/ operand
	"Answer the result of dividing the receiver by <number> argument, 
	operand. Raise a <ZeroDivide> exception if the operand is zero."

	^self subclassResponsibility!

// operand
	"Answer the <integer> quotient defined by division with truncation toward negative infinity
	of the receiver by the <number> operand;
		e.g. 7 // 2 = 3, -7 // 2 = -4. 
	Raise a <ZeroDivide> exception if the operand is zero."

	^(self / operand) floor!

\\ operand
	"Answer the remainder defined by division of the receiver by the <number>, operand,
	with truncation toward negative infinity; e.g. 7 \\ 2 = 1, -7 \\ 2 = 1, 7 \\ -2 = -1. 
	This is the modulo operation, but it is not the same as C modulo (%) which truncates 
	towards zero (but see #rem:). 
	Raise a ZeroDivide exception if the operand is zero."

	^self - (self // operand * operand)!

+ operand
	"Answer the sum of the receiver and the <number> argument, 
	operand."

	^self subclassResponsibility!

= comparand
	"Answer whether the receiver is numerically equivalent to the <Object>, 
	comparand - i.e. whether the difference between the receiver and comparand
	is zero.
	Implementation Note: #isZero is used to test the difference instead of the 
	infinitely recursive '= 0'"

	^comparand understandsArithmetic 
		and: [(self - comparand) isZero]!

abs
	"Answer a <number> that is the absolute value (positive magnitude) of the receiver."

	^self negative
		ifTrue: [self negated] 
		ifFalse: [self]!

addToFloat: aFloat
	"Private - Answer the result of adding the receiver to the known Float, aFloat, by coercing 
	the less general of it and the receiver. Overridden by subclasses which can implement 
	more efficiently."

	^aFloat retry: #+ coercing: self
!

addToFraction: aFraction
	"Private - Answer the result of adding the receiver to the known fraction, aFraction,
	by coercing the less general of it and the receiver. Overridden by subclasses 
	which can implement more efficiently."

	^aFraction retry: #+ coercing: self!

addToInteger: anInteger
	"Private - Answer the result of adding the receiver to the known integer, anInteger, by	
	coercing the less general of it and the receiver. Overridden by subclasses which 
	can implement more efficiently."

	^anInteger retry: #+ coercing: self!

addToScaledDecimal: operand
	"Private - Answer the result of adding the receiver to the known <ScaledDecimal>, operand."

	^operand retry: #+ coercing: self!

ceiling
	"Answer the <integer> nearest the receiver toward positive infinity
	(i.e. the smallest <integer> greater than or equal to the receiver)."

	| anInteger |
	anInteger := self // 1.
	^anInteger = self 
		ifTrue: [anInteger]
		ifFalse: [anInteger + 1]!

closeTo: aNumber precision: precisionFloat
	^(self - aNumber) abs <= precisionFloat!

coerce: anArithmeticValue
	"Private - Coerce anArithmeticValue (which must be of a lower generality than the receiver) to be the 
	same type as a anArithmeticValue."

	^self subclassResponsibility!

divideIntoFloat: aFloat
	"Private - Answer the result of dividing the receiver into the known Float, aFloat, by 
	coercing the less general of it and the receiver. Overridden by subclasses which 
	can implement more efficiently."

	^aFloat retry: #/ coercing: self!

divideIntoFraction: aFraction
	"Private - Answer the result of dividing the receiver into the known fraction, aFraction,
	by coercing the less general of it and the receiver. Overridden by subclasses 
	which can implement more efficiently."

	^aFraction retry: #/ coercing: self!

divideIntoInteger: anInteger
	"Private - Answer the result of dividing the receiver into the known integer, anInteger, 
	by coercing the less general of it and the receiver. Overridden by subclasses 
	which can implement more efficiently."

	^anInteger retry: #/ coercing: self!

divideIntoScaledDecimal: operand
	"Private - Answer the result of dividing the known <ScaledDecimal>, operand, by the receiver."

	^operand retry: #/ coercing: self!

equalToFloat: aFloat
	"Private - Answer whether the receiver is equal to the the known Float, aFloat, by coercing 
	the less general of it and the receiver. Overridden by subclasses which can implement 
	more efficiently and/or correctly."

	^aFloat retry: #= coercing: self!

equalToFraction: aFraction
	"Private - Answer whether the receiver is equal to the known <Fraction>, aFraction, by coercing the less general of it and the receiver and comparing again. Overridden by subclasses which can implement more correctly and/or efficiently."

	^aFraction retry: #= coercing: self!

equalToInteger: anInteger
	"Private - Answer whether the receiver is equal to the known <Integer>, anInteger, by coercing the less general of it and the receiver and comparing again. Overridden by subclasses which can implement more correctly and/or efficiently."

	^anInteger retry: #= coercing: self!

equalToScaledDecimal: aScaledDecimal
	"Private - Answer whether the receiver is equal to the known <ScaledDecimal>, aScaledDecimal, by coercing the less general of it and the receiver and comparing again. Overridden by subclasses which can implement more correctly and/or efficiently."

	^aScaledDecimal retry: #= coercing: self!

floor
	"Answer the <integer> nearest the receiver toward negative infinity
	(i.e. the largest integer less than or equal to the receiver)."

	^self // 1!

fractionPart
	"Answer a <number> of the same type as the receiver, representing the fractional part of  the receiver."

	^self - self truncated!

generality
	"Private - Answer the Smalltalk generality of the receiver, used for performing type conversions"

	^self subclassResponsibility!

greaterOrEqualToFloat: aFloat
	"Private - Answer whether the receiver is greater than or equal to the known <Float> argument, by coercing the less general of it and the receiver."

	^aFloat retry: #<= coercing: self!

greaterOrEqualToFraction: aFraction
	"Private - Answer whether the receiver is greater than or equal to the known <Fraction> argument, by coercing the less general of it and the receiver."

	^aFraction retry: #<= coercing: self!

greaterOrEqualToInteger: anInteger
	"Private - Answer whether the receiver is greater than or equal to the known <integer> argument, by coercing the less general of it and the receiver. "

	^anInteger retry: #<= coercing: self!

greaterOrEqualToScaledDecimal: aScaledDecimal
	"Private - Answer whether the receiver is greater than or equal to the known <ScaledDecimal> argument."

	^aScaledDecimal retry: #<= coercing: self!

greaterThanFloat: aFloat
	"Private - Answer whether the receiver is greater than the known Float, aFloat, by coercing the less general of it and the receiver."

	^aFloat retry: #< coercing: self!

greaterThanFraction: aFraction
	"Private - Answer whether the receiver is greater than the known <Fraction> argument."

	^aFraction retry: #< coercing: self!

greaterThanInteger: anInteger
	"Private - Answer whether the receiver is greater than the known <integer> argument."

	^anInteger retry: #< coercing: self!

greaterThanScaledDecimal: operand
	"Private - Answer whether the receiver is greater than the known <ScaledDecimal>, operand."

	^operand retry: #< coercing: self!

integerPart
	"Answer an <integer>  representing the whole integer part of the receiver."

	^self truncated!

isZero
	"Answer whether the receiver is zero. Many subclasses cannot be zero, since
	there is a more compact representation for zero in SmallInteger (e.g. 
	Fraction and LargeIntegers)"

	^self = self class zero!

multiplyByFloat: aFloat
	"Private - Answer the result of multiplying the known Float, aFloat,
	by the receiver, by coercing the less general of it and the recever.
	Overridden by subclasses which can implement more efficiently."

	^aFloat retry: #* coercing: self!

multiplyByFraction: aFraction
	"Private - Answer the result of multiplying the known fraction, aFraction,
	by the receiver, by coercing the less general of it and the recever.
	Overridden by subclasses which can implement more efficiently."

	^aFraction retry: #* coercing: self!

multiplyByInteger: anInteger
	"Private - Answer the result of multiplying the known integer, anInteger,
	by the receiver, by coercing the less general of it and the recever.
	Overridden by subclasses which can implement more efficiently."

	^anInteger retry: #* coercing: self!

multiplyByScaledDecimal: operand
	"Private - Answer the result of multiplying the known <ScaledDecimal>, operand, by receiver."

	^operand retry: #* coercing: self!

negated
	"Answer a <number> of the same type of the receiver
	which is its negation."

	^self class zero - self!

negative
	"Answer whether the receiver is negative."

	^self < self class zero!

positive
	"Answer whether the receiver is positive or zero."

	^self negative not!

quo: operand
	"Answer the <number> quotient resulting from by division of the receiver
	by the argument, operand, with truncation toward zero.
	(i.e. 'C' like integer division);  e.g. 6 quo: 2 = 3, 7 quo: 2 = 3, -7 quo: 2 = -3 
	(whereas -7 // 3 = -4).
	Signal a ZeroDivide exception if operand is zero."

	^(self / operand) truncated!

quotientFromInteger: anInteger 
	"Private - Answer the quotient resulting from division of the argument, anInteger, by
	the receiver, with truncation towards zero."

	^(anInteger / self) truncated!

raisedTo: operand
	"Answer an <ArithmeticValue> which is the receiver raised to the power of 
	the <number> argument, operand.
	Raise a FloatingPointException for overflow if the answer must be
	a <Float> and exceeds the representable range of a double precision
	floating point number."

	^self subclassResponsibility	!

raisedToInteger: anInteger
	"Answer the receiver raised to the specified <integer> power."

	| bit answer |
	anInteger <= 0
		ifTrue: [^anInteger == 0 ifTrue: [1] ifFalse: [(self raisedToInteger: anInteger negated) reciprocal]].
	bit := 1 bitShift: anInteger highBit - 1.
	answer := self.
	[(bit := bit bitShift: -1) > 0] whileTrue: 
			[answer := answer * answer.
			(anInteger anyMask: bit) ifTrue: [answer := answer * self]].
	^answer!

reciprocal
	"Answer a <number> which is the reciprocal of the receiver (i.e. 1/receiver).
	Raise a <ZeroDivide> exception if the receiver is zero."

	^self class one / self!

rem: operand
	"Answer the <number> remainder resulting from division of the receiver by
	the <number>, operand, with truncation toward zero; 
		e.g. 7 rem: 2 = 1, -7 rem: 2 = -1 (whereas -7 \\ 2 = 1)"

	^self - ((self quo: operand) * operand)!

retry: aSymbol coercing: anArithmeticValue
	"Private - The binary selector, aSymbol, was attempted with a receiver and argument 
	of different type, and	could not be performed directly. This method requests
	the ArithmeticValue of higher generality to coerce (type convert) the ArithmeticValue 
	of lower generality to its generality, and then the message is retried. Equivalence, #=, 
	is special cased to answer false if the argument is not a number (since non-anArithmeticValue
	cannot be coerced). The method reports an error if both receiver and argument, 
	aNumber, have the same generality. "

	| selfGen argGen |
	selfGen := self generality.
	argGen := anArithmeticValue generality.
	selfGen > argGen
		ifTrue: [^self perform: aSymbol with: (self coerce: anArithmeticValue)].
	selfGen < argGen
		ifTrue: [^(anArithmeticValue coerce: self) perform: aSymbol with: anArithmeticValue].
	^self error: 'cannot coerce ArithmeticValues of same generality'!

roundDownTo: anArithmeticValue 
	"Answer the nearest multiple of the <ArithmeticValue> argument which
	is less than or equal to the receiver."

	^(self / anArithmeticValue) floor * anArithmeticValue!

rounded
	"Answer the <integer> nearest the receiver according to the following rule:
		N rounded = the nearest integer I = N + (N sign * (1/2)) truncated toward zero"

	^((self class zero + self sign) / 2 + self) truncated!

roundTo: factor
	"Answer the multiple of the <number> argument, factor, that is nearest the receiver"

	^factor * (self / factor) rounded!

roundUpTo: anArithmeticValue 
	"Answer the nearest multiple of the <ArithmeticValue> argument which
	is greater than or equal to the receiver."

	^(self / anArithmeticValue) ceiling * anArithmeticValue!

sign
	"Answer the <integer> sign of the receiver:
		1 if the receiver is greater than 0, 
		-1 if less than 0
		0 if equal to 0."

	^self negative 
		ifTrue: [-1]
		ifFalse: [
			self isZero
				ifTrue: [0]
				ifFalse: [1]]!

squared
	"Answer a <number> that is the receiver multiplied by itself."

	^self * self!

strictlyPositive
	"Answer whether the receiver is greater than zero."

	^self > self class zero!

subtractFromFloat: aFloat
	"Private - Answer the result of subtracting the receiver from the known Float,
	aFloat, by coercing the less general of it and the receiver. Overridden by 
	subclasses which can implement more efficiently."

	^aFloat retry: #- coercing: self
!

subtractFromFraction: aFraction
	"Private - Answer the result of subtracting the receiver from the known fraction, aFraction,
	by coercing the less general of it and the receiver. Overridden by subclasses 
	which can implement more efficiently."

	^aFraction retry: #- coercing: self!

subtractFromInteger: anInteger
	"Private - Answer the result of subtracting the receiver from the known integer,
	 anInteger, by coercing the less general of it and the receiver. Overridden by 
	subclasses which can implement more efficiently."

	^anInteger retry: #- coercing: self!

subtractFromScaledDecimal: operand
	"Private - Answer the result of subtracting the receiver from the 
	known <ScaledDecimal>, operand."

	^operand retry: #- coercing: self!

truncated
	"Answer the <integer> nearest the receiver toward zero"

	^self quo: 1!

truncateTo: factor
	"Answer the next multiple of the <number> argument, factor, that is nearest the receiver 
	toward zero."

	^((self quo: factor) * factor)
!

understandsArithmetic
	"Answer whether the receiver understands basic arithmetic (+, -, etc). 
	All Numbers do."

	^true! !

!ArithmeticValue categoriesForMethods!
-!arithmetic!public! !
%!arithmetic!public! !
*!arithmetic!public! !
**!mathematical!public! !
/!arithmetic!public! !
//!arithmetic!public! !
\\!arithmetic!public! !
+!arithmetic!public! !
=!comparing!public! !
abs!arithmetic!public! !
addToFloat:!double dispatch!private! !
addToFraction:!double dispatch!private! !
addToInteger:!double dispatch!private! !
addToScaledDecimal:!double dispatch!private! !
ceiling!public!truncation and round off! !
closeTo:precision:!comparing!public! !
coerce:!coercing!private! !
divideIntoFloat:!double dispatch!private! !
divideIntoFraction:!double dispatch!private! !
divideIntoInteger:!double dispatch!private! !
divideIntoScaledDecimal:!double dispatch!private! !
equalToFloat:!double dispatch!private! !
equalToFraction:!double dispatch!private! !
equalToInteger:!double dispatch!private! !
equalToScaledDecimal:!double dispatch!private! !
floor!public!truncation and round off! !
fractionPart!accessing!public! !
generality!coercing!private! !
greaterOrEqualToFloat:!double dispatch!private! !
greaterOrEqualToFraction:!double dispatch!private! !
greaterOrEqualToInteger:!double dispatch!private! !
greaterOrEqualToScaledDecimal:!double dispatch!private! !
greaterThanFloat:!double dispatch!private! !
greaterThanFraction:!double dispatch!private! !
greaterThanInteger:!double dispatch!private! !
greaterThanScaledDecimal:!double dispatch!private! !
integerPart!accessing!public! !
isZero!public!testing! !
multiplyByFloat:!double dispatch!private! !
multiplyByFraction:!double dispatch!private! !
multiplyByInteger:!double dispatch!private! !
multiplyByScaledDecimal:!double dispatch!private! !
negated!arithmetic!public! !
negative!public!testing! !
positive!public!testing! !
quo:!arithmetic!public! !
quotientFromInteger:!double dispatch!private! !
raisedTo:!mathematical!public! !
raisedToInteger:!mathematical!public! !
reciprocal!arithmetic!public! !
rem:!arithmetic!public! !
retry:coercing:!coercing!private! !
roundDownTo:!public!truncation and round off! !
rounded!public!truncation and round off! !
roundTo:!public!truncation and round off! !
roundUpTo:!public!truncation and round off! !
sign!public!testing! !
squared!mathematical!public! !
strictlyPositive!public!testing! !
subtractFromFloat:!double dispatch!private! !
subtractFromFraction:!double dispatch!private! !
subtractFromInteger:!double dispatch!private! !
subtractFromScaledDecimal:!double dispatch!private! !
truncated!public!truncation and round off! !
truncateTo:!public!truncation and round off! !
understandsArithmetic!public!testing! !
!

!ArithmeticValue class methodsFor!

one
	"Answer the receiver's representation of one."

	^self subclassResponsibility!

zero
	"Answer the receiver's representation of zero."

	^self subclassResponsibility! !

!ArithmeticValue class categoriesForMethods!
one!instance creation!public! !
zero!instance creation!public! !
!

