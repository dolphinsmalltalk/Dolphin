"Filed out from Dolphin Smalltalk 7"!

Core.Magnitude subclass: #'Core.ArithmeticValue'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ArithmeticValue guid: (Core.GUID fromString: '{87b4c64f-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.ArithmeticValue isNonInstantiable: true!
Core.ArithmeticValue comment: ''!
!Core.ArithmeticValue categoriesForClass!Magnitude-General! !
!Core.ArithmeticValue methodsFor!

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

addToPoint: aPoint
	"Private - Answer the result of adding the receiver to the known Point, aPoint, by coercing 
	the less general of it and the receiver. Overridden by subclasses which can implement 
	more efficiently."

	^aPoint retry: #+ coercing: self
!

addToPoint3D: aPoint3D
	"Private - Answer the result of adding the receiver to the known Point3D, aPoint3D, by coercing 
	the less general of it and the receiver. Overridden by subclasses which can implement 
	more efficiently."

	^aPoint3D retry: #+ coercing: self
!

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

divideIntoPoint: aPoint
	"Private - Answer the result of dividing the receiver into the known Point, aPoint, by 
	coercing the less general of it and the receiver. Overridden by subclasses which 
	can implement more efficiently."

	^aPoint retry: #/ coercing: self!

divideIntoPoint3D: aPoint3D
	"Private - Answer the result of dividing the receiver into the known Point3D, aPoint3D, by 
	coercing the less general of it and the receiver. Overridden by subclasses which 
	can implement more efficiently."

	^aPoint3D retry: #/ coercing: self!

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

floor
	"Answer the <integer> nearest the receiver toward negative infinity
	(i.e. the largest integer less than or equal to the receiver)."

	^self // 1!

generality
	"Private - Answer the Smalltalk generality of the receiver, used for performing type conversions"

	^self subclassResponsibility!

greaterThanFloat: aFloat
	"Private - Answer whether the receiver is greater than the known Float, aFloat, by coercing 
	the less general of it and the receiver. Overridden by subclasses which can implement 
	more efficiently."

	^aFloat retry: #< coercing: self!

greaterThanFraction: aFraction
	"Private - Answer whether the receiver is greater than the known Fraction, aFraction, by 
	coercing the less general of it and the receiver. Overridden by subclasses which 
	can implement more efficiently."

	^aFraction retry: #< coercing: self!

greaterThanInteger: anInteger
	"Private - Answer whether the receiver is greater than the known integer, anInteger, by 
	coercing the less general of it and the receiver. Overridden by subclasses which 
	can implement more efficiently."

	^anInteger retry: #< coercing: self!

greaterThanScaledDecimal: operand
	"Private - Answer whether the receiver is greater than the known <ScaledDecimal>, operand."

	^operand retry: #< coercing: self!

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

multiplyByPoint: aPoint
	"Private - Answer the result of multiplying the known Point, aPoint,
	by the receiver, by coercing the less general of it and the recever.
	Overridden by subclasses which can implement more efficiently."

	^aPoint retry: #* coercing: self!

multiplyByPoint3D: aPoint3D
	"Private - Answer the result of multiplying the known Point3D, aPoint3D,
	by the receiver, by coercing the less general of it and the recever.
	Overridden by subclasses which can implement more efficiently."

	^aPoint3D retry: #* coercing: self!

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

subtractFromPoint: aPoint
	"Private - Answer the result of subtracting the receiver from the known Point,
	aPoint, by coercing the less general of it and the receiver. Overridden by 
	subclasses which can implement more efficiently."

	^aPoint retry: #- coercing: self
!

subtractFromPoint3D: aPoint3D
	"Private - Answer the result of subtracting the receiver from the known Point3D,
	aPoint3D, by coercing the less general of it and the receiver. Overridden by 
	subclasses which can implement more efficiently."

	^aPoint3D retry: #- coercing: self
!

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
!Core.ArithmeticValue categoriesFor: #-!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #%!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #*!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #**!mathematical!public! !
!Core.ArithmeticValue categoriesFor: #/!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #//!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #\\!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #+!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #=!comparing!public! !
!Core.ArithmeticValue categoriesFor: #abs!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #addToFloat:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #addToFraction:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #addToInteger:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #addToPoint:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #addToPoint3D:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #addToScaledDecimal:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #ceiling!public!truncation and round off! !
!Core.ArithmeticValue categoriesFor: #coerce:!coercing!private! !
!Core.ArithmeticValue categoriesFor: #divideIntoFloat:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #divideIntoFraction:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #divideIntoInteger:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #divideIntoPoint:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #divideIntoPoint3D:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #divideIntoScaledDecimal:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #equalToFloat:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #equalToFraction:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #equalToInteger:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #floor!public!truncation and round off! !
!Core.ArithmeticValue categoriesFor: #generality!coercing!private! !
!Core.ArithmeticValue categoriesFor: #greaterThanFloat:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #greaterThanFraction:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #greaterThanInteger:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #greaterThanScaledDecimal:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #isZero!public!testing! !
!Core.ArithmeticValue categoriesFor: #multiplyByFloat:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #multiplyByFraction:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #multiplyByInteger:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #multiplyByPoint:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #multiplyByPoint3D:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #multiplyByScaledDecimal:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #negated!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #negative!public!testing! !
!Core.ArithmeticValue categoriesFor: #positive!public!testing! !
!Core.ArithmeticValue categoriesFor: #quo:!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #quotientFromInteger:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #raisedTo:!mathematical!public! !
!Core.ArithmeticValue categoriesFor: #raisedToInteger:!mathematical!public! !
!Core.ArithmeticValue categoriesFor: #reciprocal!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #rem:!arithmetic!public! !
!Core.ArithmeticValue categoriesFor: #retry:coercing:!coercing!private! !
!Core.ArithmeticValue categoriesFor: #roundDownTo:!public!truncation and round off! !
!Core.ArithmeticValue categoriesFor: #rounded!public!truncation and round off! !
!Core.ArithmeticValue categoriesFor: #roundTo:!public!truncation and round off! !
!Core.ArithmeticValue categoriesFor: #roundUpTo:!public!truncation and round off! !
!Core.ArithmeticValue categoriesFor: #sign!public!testing! !
!Core.ArithmeticValue categoriesFor: #squared!mathematical!public! !
!Core.ArithmeticValue categoriesFor: #strictlyPositive!public!testing! !
!Core.ArithmeticValue categoriesFor: #subtractFromFloat:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #subtractFromFraction:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #subtractFromInteger:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #subtractFromPoint:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #subtractFromPoint3D:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #subtractFromScaledDecimal:!double dispatch!private! !
!Core.ArithmeticValue categoriesFor: #truncated!public!truncation and round off! !
!Core.ArithmeticValue categoriesFor: #truncateTo:!public!truncation and round off! !
!Core.ArithmeticValue categoriesFor: #understandsArithmetic!public!testing! !

!Core.ArithmeticValue class methodsFor!

one
	"Answer the receiver's representation of one."

	^self subclassResponsibility!

zero
	"Answer the receiver's representation of zero."

	^self subclassResponsibility! !
!Core.ArithmeticValue class categoriesFor: #one!instance creation!public! !
!Core.ArithmeticValue class categoriesFor: #zero!instance creation!public! !

