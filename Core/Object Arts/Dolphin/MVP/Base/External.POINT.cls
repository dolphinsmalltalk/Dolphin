"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'External.POINT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.POINT guid: (Core.GUID fromString: '{5a0c3f56-8db8-4509-8563-3affe77805b2}')!
External.POINT isNonInstantiable: true!
External.POINT comment: '`POINT` is the abstract class of structures representing positions in a 2-dimensional space. There are concrete subclasses for different types of co-ordinate value.'!
!External.POINT categoriesForClass!External-Data-Structured! !
!External.POINT methodsFor!

- anArithmeticValue
	"Answer the receiver minus anArithmeticValue as a Point."

	^anArithmeticValue subtractFromPoint: self!

% anArithmeticValue
	"Answer the remainder defined by division with truncation toward zero."

	^self rem: anArithmeticValue!

* anArithmeticValue
	"Answer a Point with the receiver's coordinates multiplied by anArithmeticValue."

	^anArithmeticValue multiplyByPoint: self!

** aNumber 
	"Answer the receiver raised to the power of the argument, aNumber."
	
	^self raisedTo: aNumber!

/ operand
	"Answer a Point with the receiver's coordinates divided by the <number>, 
	operand. If the operand is zero then a <ZeroDivide> is raised."

	^operand divideIntoPoint: self!

// operand
	"Answer the <integer> quotient defined by division with truncation toward negative infinity
	of the receiver by the <number> operand;
		e.g. 7 // 2 = 3, -7 // 2 = -4. 
	Raise a <ZeroDivide> exception if the operand is zero."

	^(self / operand) floor!

@ zCoord
	"Answer a Point3D with the receiver as X, Y coordinates and the argument as Z."

	^Graphics.Point3D
		x: self x
		y: self y
		z: zCoord!

\\ operand
	"Answer the remainder defined by division of the receiver by the <number>, operand,
	with truncation toward negative infinity; e.g. 7 \\ 2 = 1, -7 \\ 2 = 1, 7 \\ -2 = -1. 
	This is the modulo operation, but it is not the same as C modulo (%) which truncates 
	towards zero (but see #rem:). 
	Raise a ZeroDivide exception if the operand is zero."

	^self - (self // operand * operand)!

+ anArithmeticValue
	"Answer the sum of receiver and aPoint as a Point."

	^anArithmeticValue addToPoint: self!

< aMagnitude
	"Answer whether the receiver is above and to the left of the <magnitude> argument."

	| aPoint |
	aPoint := aMagnitude asGenericPoint.
	^self x < aPoint x and: [self y < aPoint y]!

<= aMagnitude
	"Answer whether the receiver is neither below nor to the right of the <magnitude> argument."

	| aPoint |
	aPoint := aMagnitude asGenericPoint.
	^self x <= aPoint x and: [self y <= aPoint y]!

<=> aMagnitude
	"Answer the receiver's <integer> collation order with respect to the <Number> argument. Colloquially known as the spaceship operator.
	The answer is < 0 if the receiver should collate before the argument, 0 if they have the same collation order, or > 0 if the receiver should collate after the argument.
	N.B. Gives an incorrect answer if either operand is a NaN."

	^self = aMagnitude ifTrue: [0] ifFalse: [self < aMagnitude ifTrue: [-1] ifFalse: [1]]!

= anObject
	"Answer whether the receiver is considered equivalent to the	<Object> argument."

	^self == anObject or: 
			[self species == anObject species
				ifTrue: [self x = anObject x and: [self y = anObject y]]
				ifFalse: [anObject = self]]!

> anArithmeticValue
	"Answer whether the receiver is below and to the right of anArithmeticValue."

	^anArithmeticValue < self!

>= anArithmeticValue
	"Answer whether the receiver is neither above nor to the left of anArithmeticValue."

	^anArithmeticValue <= self!

abs
	"Answer a <Point> that is the absolute value (positive magnitude) of the receiver."

	^self x abs @ self y abs!

addToFloat: aFloat
	^(aFloat + self x) @ (aFloat + self y)!

addToFraction: aFraction
	"Private - Answer the <point> result of adding the known <Fraction> argument to the receiver's co-ordinates."

	^(aFraction + self x) @ (aFraction + self y)!

addToInteger: anInteger
	"Private - Answer the <Point> result of adding the known <integer> to the receiver's x and y co-ordinates."

	^(anInteger + self x) @ (anInteger + self y)!

addToPoint: aPoint
	"Private - Answer the <point> result of adding the receiver to the known <point> argument."

	^(aPoint x + self x) @ (aPoint y + self y)!

addToPoint3D: aPoint3D
	"Private - Answer the <Point3D> result of adding the receiver's x and y co-ordinates to the x and y co-ordinates of the known <Point3D> argument."

	^(aPoint3D x + self x) @ (aPoint3D y + self y) @ aPoint3D z!

addToScaledDecimal: aScaledDecimal
	"Private - Answer the <point> result of adding the known <ScaledDecimal> argument to the receiver's co-ordinates."

	^(aScaledDecimal + self x) @ (aScaledDecimal + self y)!

asDword
	"Answer the receiver in a form suitable for passing or returning 
	as a 32-bit value (i.e. a 32-bit integer)."

	^(UInt32 fromPoint: self) value!

asGenericPoint
	"Answer a Point created that matches the receiver"

	^self!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Point>."

	^self asPoint!

asPoint
	"Answer a Point created that matches the receiver"

	^Graphics.Point x: self x y: self y!

asPoint3D
	"Answer a Point3D with the receiver."

	^self x @ self y @ 0!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning 
	as a  machine-word sized (32 or 64-bit) value."

	^self asPoint asUIntPtr!

between: min and: max
	"Answer whether the receiver is inclusively between the <magnitude> arguments, 
	min and max."

	^self >= min and: [self <= max]!

ceiling
	"Answer a new Point with the x and y values of the receiver truncated
	toward positive infinity."

	^self!

coerce: anArithmeticValue
	"Private - Answer the lower generality <arithmeticValue> argument converted to a <point>."

	^anArithmeticValue asGenericPoint!

corner: aPoint
	"Answers a Rectangle defined by the receiver and aPoint."

	^UI.Rectangle origin: self corner: aPoint!

degrees
	"Answer the angle the receiver makes with origin in degrees. right is 0; down is 90."

	| x |
	(x := self x) = 0
		ifTrue: [self y >= 0 ifTrue: [^90.0] ifFalse: [^270.0]]
		ifFalse: 
			[| y tan theta |
			tan := (y := self y) asFloat / x asFloat.
			theta := tan arcTan.
			x >= 0
				ifTrue: [y >= 0 ifTrue: [^theta radiansToDegrees] ifFalse: [^360.0 + theta radiansToDegrees]]
				ifFalse: [^180.0 + theta radiansToDegrees]]!

dist: aPoint 
	"Answer the distance between aPoint and the receiver."

	^(aPoint - self) r!

divideIntoFloat: aFloat
	"Private - Answer the result of dividing the receiver into the known Float, aFloat."

	^(aFloat / self x) @ (aFloat / self y)!

divideIntoFraction: aFraction
	"Private - Answer the result of dividing the receiver into the known fraction, aFraction."

	^(aFraction / self x) @ (aFraction / self y)!

divideIntoInteger: anInteger
	"Private - Answer the result of dividing the receiver into the known integer, anInteger."

	^(anInteger / self x) @ (anInteger / self y)!

divideIntoPoint: aPoint
	"Private - Answer the result of dividing the receiver into the known Point, aPoint."

	^(aPoint x / self x) @ (aPoint y / self y)!

divideIntoPoint3D: aPoint3D
	"Private - Answer the result of dividing the receiver into the known Point3D, aPoint3D, by coercing the less general of it and the receiver."

	"Note that this will always yield a division by zero."

	^(aPoint3D x / self x) @ (aPoint3D y / self y) @ (aPoint3D z / 0)!

divideIntoScaledDecimal: aScaledDecimal
	"Private - Answer the result of dividing the known <ScaledDecimal>, aScaledDecimal, by the receiver."

	^(aScaledDecimal / self x) @ (aScaledDecimal / self y)!

dotProduct: aPoint 
	"Answer a <Number> that is the sum of the product of the x coordinates and the product of the y coordinates of the receiver and the <point> argument."

	^(self x * aPoint x) + (self y * aPoint y)!

equalToFloat: aFloat
	"Private - Answer whether the receiver is equal to the known <Float> argument."

	^self x = aFloat and: [self y = aFloat]!

equalToFraction: aFraction
	"Private - Answer whether the receiver is equal to the known <Fraction>, aFraction, by coercing the less general of it and the receiver and comparing again. Overridden by subclasses which can implement more correctly and/or efficiently."

	^self x = aFraction and: [self y = aFraction]!

equalToInteger: anInteger
	"Private - Answer whether the receiver is equal to the known <Integer>, anInteger, by coercing the less general of it and the receiver and comparing again. Overridden by subclasses which can implement more correctly and/or efficiently."

	^self x = anInteger and: [self y = anInteger]!

equalToScaledDecimal: aScaledDecimal
	"Private - Answer whether the receiver is equal to the known <ScaledDecimal>, aScaledDecimal, by coercing the less general of it and the receiver and comparing again. Overridden by subclasses which can implement more correctly and/or efficiently."

	^self x = aScaledDecimal and: [self y = aScaledDecimal]!

extent: aPoint
	"Answers a Rectangle whose origin is the receiver and whose
	extent is the argument aPoint"

	^UI.Rectangle origin: self extent: aPoint!

floor
	"Answer a new <Point> with the x and y values of the receiver truncated toward negative infinity."

	^self!

fractionPart
	"Answer a <number> of the same type as the receiver, representing the fractional part of  the receiver."

	^self - self truncated
!

generality
	"Private - Answer the Smalltalk generality of the receiver, used for performing type conversions"

	^50!

greaterOrEqualToFloat: aFloat
	"Private - Answer whether the receiver is greater than or equal to the known <Float> argument."

	^self x >= aFloat and: [self y >= aFloat]!

greaterOrEqualToFraction: aFraction
	"Private - Answer whether the receiver is greater than or equal to the known <Fraction> argument."

	^self x >= aFraction and: [self y >= aFraction]!

greaterOrEqualToInteger: anInteger 
	"Private - Answer whether the receiver is greater than or equal to the known <integer> argument."

	^self x >= anInteger and: [self y >= anInteger]!

greaterOrEqualToScaledDecimal: aScaledDecimal
	"Private - Answer whether the receiver is greater than or equal to the known <ScaledDecimal> argument."

	^self x >= aScaledDecimal and: [self y >= aScaledDecimal]!

greaterThanFloat: aFloat
	"Private - Answer whether the receiver is greater than the known Float, aFloat."

	^self x > aFloat and: [self y > aFloat]!

greaterThanFraction: aFraction
	"Private - Answer whether the receiver is greater than the known <Fraction> argument."

	^self x > aFraction and: [self y > aFraction]!

greaterThanInteger: anInteger
	"Private - Answer whether the receiver is greater than the known <integer> argument."

	^self x > anInteger and: [self y > anInteger]!

greaterThanScaledDecimal: aScaledDecimal
	"Private - Answer whether the receiver is greater than the known <ScaledDecimal> argument."

	^self x > aScaledDecimal and: [self y > aScaledDecimal]!

hash
	"Answer the <integer> hash value for the receiver."

	^(self x hash bitShift: 2) bitXor: self y hash!

integerPart
	"Answer an <integer> representing the whole integer part of the receiver."

	^self truncated!

isZero
	"Answer whether the receiver is equal to Point zero."

	^self x = 0 and: [self y = 0]!

max: aPoint
	"Answer a new Point with the maximum of the x coordinates	and the maximum of the y coordinates of the receiver and aPoint"

	^(self x max: aPoint x) @ (self y max: aPoint y)!

min: aPoint
	"Answer a new Point with the maximum of the x coordinates	and the maximum of the y coordinates of the receiver and aPoint"

	^(self x min: aPoint x) @ (self y min: aPoint y)!

multiplyByFloat: aFloat
	"Private - Answer the result of multiplying the receiver by the known Float, aFloat."

	^(self x * aFloat) @ (self y * aFloat)!

multiplyByFraction: aFraction
	"Private - Answer the result of multiplying the receiver by the known fraction, aFraction."

	^(self x * aFraction) @ (self y * aFraction)!

multiplyByInteger: anInteger
	"Private - Answer the result of multiplying the receiver by the known integer, anInteger."

	^(self x * anInteger) @ (self y * anInteger)!

multiplyByPoint: aPoint
	"Private - Answer the result of multiplying the known Point, aPoint."

	^(self x * aPoint x) @ (self y * aPoint y)!

multiplyByPoint3D: aPoint3D
	"Private - Answer the result of multiplying the known Point3D, aPoint3D, by the receiver."

	^(aPoint3D x * self x) @ (aPoint3D y * self y) @ 0!

multiplyByScaledDecimal: aScaledDecimal
	"Private - Answer the result of multiplying the known <ScaledDecimal>, aScaledDecimal, by receiver."

	^(self x * aScaledDecimal) @ (self y * aScaledDecimal)!

negated
	"Answer a <number> of the same type of the receiver
	which is its negation."

	^(0 - self x) @ (0 - self y)!

negative
	"Answer whether the receiver is negative."

	^self x < 0 and: [self y < 0]!

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

r
	"Answer the receiver's radius (magnitude) in a polar coordinate 
	system."

	^(self dotProduct: self) sqrt!

raisedTo: operand
	"Answer an <ArithmeticValue> which is the receiver raised to the power of 
	the <number> argument, operand."

	^(self x raisedTo: operand) @ (self y raisedTo: operand)!

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

	^(1 / self x) @ (1 / self y)!

rem: operand
	"Answer the <number> remainder resulting from division of the receiver by
	the <number>, operand, with truncation toward zero; 
		e.g. 7 rem: 2 = 1, -7 rem: 2 = -1 (whereas -7 \\ 2 = 1)"

	^self - ((self quo: operand) * operand)!

retry: aSymbol coercing: anArithmeticValue
	"Private - The binary selector <Symbol>, aSymbol, was attempted with a receiver and <arithmeticValue> argument, anArithmeticValue, of different type, and could not be performed directly. This method requests the <arithmeticValue> of higher generality to coerce (type convert) the <arithmeticValue> of lower generality to its generality, and then the message is retried.  Report an error if both receiver and argument have the same generality."

	| selfGen argGen |
	(selfGen := self generality) > (argGen := anArithmeticValue generality)
		ifTrue: [^self perform: aSymbol with: (self coerce: anArithmeticValue)].
	selfGen < argGen
		ifTrue: [^(anArithmeticValue coerce: self) perform: aSymbol with: anArithmeticValue].
	^self error: 'cannot coerce ArithmeticValues of same generality'!

roundDownTo: anArithmeticValue 
	"Answer the nearest multiple of the <ArithmeticValue> argument which
	is less than or equal to the receiver."

	^(self / anArithmeticValue) floor * anArithmeticValue!

rounded
	"Answer a new Point with the x and y values of the receiver rounded."

	^self!

roundTo: aNumber 
	"Answer a new <point> with the x, y values of the receiver rounded."

	^(self x roundTo: aNumber) @ (self y roundTo: aNumber)!

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

species
	^UI.Point!

squared
	"Answer a <number> that is the receiver multiplied by itself."

	^(self x squared) @ (self y squared)!

strictlyPositive
	"Answer whether the receiver is greater than zero."

	^self > self class zero!

subtractFromFloat: aFloat
	"Private - Answer the result of subtracting the receiver from the known Float, aFloat."

	^(aFloat - self x) @ (aFloat - self y)!

subtractFromFraction: aFraction
	"Private - Answer the result of subtracting the receiver from the known fraction, aFraction."

	^(aFraction - self x) @ (aFraction - self y)!

subtractFromInteger: anInteger
	"Private - Answer the result of subtracting the receiver from the known integer, anInteger."

	^(anInteger - self x) @ (anInteger - self y)!

subtractFromPoint: aPoint
	"Private - Answer the result of subtracting the receiver from the known Point, aPoint."

	^(aPoint x - self x) @ (aPoint y - self y)!

subtractFromPoint3D: aPoint3D
	"Private - Answer the result of subtracting the receiver from the known Point3D, aPoint3D."

	^(aPoint3D x - self x) @ (aPoint3D y - self y) @ aPoint3D z!

subtractFromScaledDecimal: aScaledDecimal
	"Private - Answer the result of subtracting the receiver from the known <ScaledDecimal>, aScaledDecimal."

	^(aScaledDecimal - self x) @ (aScaledDecimal - self y)!

truncated
	"Answer a new Point with the x and y values of the receiver truncated toward zero"

	^self!

truncateTo: factor
	"Answer the next multiple of the <number> argument, factor, that is nearest the receiver 
	toward zero."

	^((self quo: factor) * factor)
!

understandsArithmetic
	^true!

value
	"Answer the receiver's value field as an equivalent Smalltalk object (a <Point>)."

	^self asPoint!

value: aPoint
	"Set the value buffered by the receiver to aPoint."

	self
		x: aPoint x;
		y: aPoint y!

x
	^self subclassResponsibility!

x: anObject
	self subclassResponsibility!

y
	^self subclassResponsibility!

y: anObject
	self subclassResponsibility! !
!External.POINT categoriesForMethods!
-!arithmetic!public! !
%!arithmetic!public! !
*!arithmetic!public! !
**!mathematical!public! !
/!arithmetic!public! !
//!arithmetic!public! !
@!converting!public! !
\\!arithmetic!public! !
+!arithmetic!public! !
<!comparing!public! !
<=!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
>!comparing!public! !
>=!comparing!public! !
abs!arithmetic!public! !
addToFloat:!double dispatch!private! !
addToFraction:!double dispatch!private! !
addToInteger:!double dispatch!private! !
addToPoint:!double dispatch!private! !
addToPoint3D:!double dispatch!private! !
addToScaledDecimal:!double dispatch!private! !
asDword!converting!public! !
asGenericPoint!converting!public! !
asObject!converting!public! !
asPoint!converting!public! !
asPoint3D!converting!public! !
asUIntPtr!converting!public! !
between:and:!comparing!public! !
ceiling!public!truncation and round off! !
coerce:!coercing!private! !
corner:!converting!public! !
degrees!accessing!public! !
dist:!operations!public! !
divideIntoFloat:!double dispatch!private! !
divideIntoFraction:!double dispatch!private! !
divideIntoInteger:!double dispatch!private! !
divideIntoPoint:!double dispatch!private! !
divideIntoPoint3D:!double dispatch!private! !
divideIntoScaledDecimal:!double dispatch!private! !
dotProduct:!operations!public! !
equalToFloat:!double dispatch!private! !
equalToFraction:!double dispatch!private! !
equalToInteger:!double dispatch!private! !
equalToScaledDecimal:!double dispatch!private! !
extent:!converting!public! !
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
hash!comparing!public! !
integerPart!accessing!public! !
isZero!public!testing! !
max:!comparing!public! !
min:!comparing!public! !
multiplyByFloat:!double dispatch!private! !
multiplyByFraction:!double dispatch!private! !
multiplyByInteger:!double dispatch!private! !
multiplyByPoint:!double dispatch!private! !
multiplyByPoint3D:!double dispatch!private! !
multiplyByScaledDecimal:!double dispatch!private! !
negated!arithmetic!public! !
negative!public!testing! !
positive!public!testing! !
quo:!arithmetic!public! !
r!accessing!public! !
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
species!comparing!public! !
squared!mathematical!public! !
strictlyPositive!public!testing! !
subtractFromFloat:!double dispatch!private! !
subtractFromFraction:!double dispatch!private! !
subtractFromInteger:!double dispatch!private! !
subtractFromPoint:!double dispatch!private! !
subtractFromPoint3D:!double dispatch!private! !
subtractFromScaledDecimal:!double dispatch!private! !
truncated!public!truncation and round off! !
truncateTo:!public!truncation and round off! !
understandsArithmetic!public!testing! !
value!accessing!public! !
value:!accessing!public! !
x!accessing!public! !
x:!accessing!public! !
y!accessing!public! !
y:!accessing!public! !
!

External.POINT methodProtocol: #arithmeticValue attributes: #(#readOnly) selectors: #(#- #% #* #** #/ #// #\\ #+ #< #<= #> #>= #abs #addToFloat: #addToFraction: #addToInteger: #addToPoint: #addToPoint3D: #addToScaledDecimal: #between:and: #ceiling #divideIntoFloat: #divideIntoFraction: #divideIntoInteger: #divideIntoPoint: #divideIntoScaledDecimal: #equalToFloat: #equalToFraction: #equalToInteger: #equalToScaledDecimal: #floor #fractionPart #generality #greaterOrEqualToFloat: #greaterOrEqualToFraction: #greaterOrEqualToInteger: #greaterOrEqualToScaledDecimal: #greaterThanFloat: #greaterThanFraction: #greaterThanInteger: #greaterThanScaledDecimal: #integerPart #isZero #max: #min: #multiplyByFloat: #multiplyByFraction: #multiplyByInteger: #multiplyByPoint: #multiplyByPoint3D: #multiplyByScaledDecimal: #negated #negative #positive #quo: #raisedTo: #raisedToInteger: #reciprocal #rem: #roundDownTo: #rounded #roundTo: #roundUpTo: #sign #squared #strictlyPositive #subtractFromFloat: #subtractFromFraction: #subtractFromInteger: #subtractFromPoint: #subtractFromPoint3D: #subtractFromScaledDecimal: #truncated #truncateTo: #understandsArithmetic)!
External.POINT methodProtocol: #magnitude attributes: #(#ansi #readOnly) selectors: #(#< #<= #> #>= #between:and: #max: #min:)!
External.POINT methodProtocol: #point attributes: #(#readOnly) selectors: #(#- #% #* #** #/ #// #\\ #+ #< #<= #> #>= #abs #addToFloat: #addToFraction: #addToInteger: #addToPoint: #addToPoint3D: #addToScaledDecimal: #asGenericPoint #asPoint #between:and: #ceiling #corner: #degrees #dist: #divideIntoFloat: #divideIntoFraction: #divideIntoInteger: #divideIntoPoint: #divideIntoPoint3D: #divideIntoScaledDecimal: #dotProduct: #equalToFloat: #equalToFraction: #equalToInteger: #equalToScaledDecimal: #extent: #floor #fractionPart #generality #greaterOrEqualToFloat: #greaterOrEqualToFraction: #greaterOrEqualToInteger: #greaterOrEqualToScaledDecimal: #greaterThanFloat: #greaterThanFraction: #greaterThanInteger: #greaterThanScaledDecimal: #integerPart #isZero #max: #min: #multiplyByFloat: #multiplyByFraction: #multiplyByInteger: #multiplyByPoint: #multiplyByPoint3D: #multiplyByScaledDecimal: #negated #negative #positive #quo: #r #raisedTo: #raisedToInteger: #reciprocal #rem: #roundDownTo: #rounded #roundTo: #roundUpTo: #sign #squared #strictlyPositive #subtractFromFloat: #subtractFromFraction: #subtractFromInteger: #subtractFromPoint: #subtractFromPoint3D: #subtractFromScaledDecimal: #truncated #truncateTo: #understandsArithmetic #x #x: #y #y:)!

!External.POINT class methodsFor!

fromPoint: aPoint
	"Answer a new instance of the receiver representing aPoint."
	
	^self x: aPoint x y: aPoint y!

getFieldNames
	^#(#x #y)!

icon
	"Answer a suitable iconic representation for the receiver."

	^Graphics.Point icon!

marshal: aPoint
	"Answer a new instance of the receiver representing aPoint."

	aPoint class == self class ifTrue: [^aPoint].
	^self x: aPoint x y: aPoint y!

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments."

	^self basicNew
		x: x;
		y: y;
		yourself! !
!External.POINT class categoriesForMethods!
fromPoint:!instance creation!public! !
getFieldNames!constants!private! !
icon!constants!development!public! !
marshal:!instance creation!public! !
x:y:!instance creation!public! !
!

