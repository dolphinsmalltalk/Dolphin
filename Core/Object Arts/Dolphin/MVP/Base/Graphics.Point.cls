"Filed out from Dolphin Smalltalk"!

Core.ArithmeticValue
	subclass: #'Graphics.Point'
	instanceVariableNames: 'x y'
	classVariableNames: 'Zero'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Point guid: (Core.GUID fromString: '{87b4c658-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.Point comment: 'A Point represents an x-y pair of numbers usually indicating a point on a two-dimensional Cartesian coordinate plane. Points are often used to designate the location of pixels within a Bitmap or on the display screen. By Smalltalk convention, x increases to the right and y down, consistent with the layout of text on a page and with pixels in Windows'' bitmaps. This "left-handed" coordinate system is the convention for Points used within the standard Smalltalk image (in classes such as Rectangle) but there is nothing in the Point class itself that prohibits the implied use of a "right-handed" coordinate system in which y increases in the upward direction.

A Point is typically created using the binary message @ to a Number:

150 @ 200

Arithmetic operations can be carried out between two Points or between a Point and a Number. Each of the arithmetic messages returns a new Point as the result. Note the need to make use of parentheses in the expressions below due to the equal precedence assigned to all binary messages (such as @ and +).

(150 @ 200) + (50 @ 50) "Addition of Points"
(150 @ 200) + 100 "Addition of scalar"
(150 @ 200) * 3 "Scaling"'!

!Graphics.Point categoriesForClass!Graphics-Geometry! !

!Graphics.Point methodsFor!

- anArithmeticValue
	"Answer the receiver minus anArithmeticValue as a Point."

	^anArithmeticValue subtractFromPoint: self!

* anArithmeticValue
	"Answer a <Point> with the receiver's coordinates multiplied by the <arithmeticValue> argument."

	^anArithmeticValue multiplyByPoint: self!

/ anArithmeticValue
	"Answer a <Point> with the receiver's coordinates divided by the <ArithmeticValue> argument. If the operand is zero then a <ZeroDivide> is raised."

	^anArithmeticValue divideIntoPoint: self!

@ aNumber
	"Answer a <Point3D> with the receiver as X, Y coordinates and the <number> argument as Z."

	^Point3D
		x: x
		y: y
		z: aNumber!

+ anArithmeticValue
	"Answer the <Point> sum of receiver and the <arithmeticValue> argument."

	^anArithmeticValue addToPoint: self!

< aMagnitude
	"Answer whether the receiver is above and to the left of the <magnitude> argument.
	N.B. No double dispatch to reduce the number of methods that must be implemented."

	| aPoint |
	aPoint := aMagnitude asGenericPoint.
	^x < aPoint x and: [y < aPoint y]!

<= aMagnitude
	"Answer whether the receiver is neither below nor to the right of the <magnitude> argument.
	N.B. No double dispatch to reduce the number of methods that must be implemented."

	| aPoint |
	aPoint := aMagnitude asGenericPoint.
	^x <= aPoint x and: [y <= aPoint y]!

<=> aMagnitude
	"Answer the receiver's <integer> collation order with respect to the <Number> argument. Colloquially known as the spaceship operator.
	The answer is < 0 if the receiver should collate before the argument, 0 if they have the same collation order, or > 0 if the receiver should collate after the argument."

	| aPoint |
	aPoint := aMagnitude asGenericPoint.
	^y = aPoint y
		ifTrue: [x = aPoint x ifTrue: [0] ifFalse: [x < aPoint x ifTrue: [-1] ifFalse: [1]]]
		ifFalse: [y < aPoint y ifTrue: [-1] ifFalse: [1]]!

= anObject
	"Answer whether the receiver is considered equivalent to the	<Object> argument."

	^self == anObject or: 
			[self species == anObject species
				ifTrue: [x = anObject x and: [y = anObject y]]
				ifFalse: [super = anObject]]!

abs
	"Answer a <Point> that is the absolute value (positive magnitude) of the receiver."

	^x abs @ y abs!

addToPoint: aPoint
	"Private - Answer the <point> result of adding the receiver to the known <point> argument."

	^self class x: aPoint x + x y: aPoint y + y!

asGenericPoint
	"Answer the receiver"

	^self!

asParameter
	"Answer the receiver in a form suitable for passing to an external function."

	^POINTL fromPoint: self!

asPoint
	"Answer the receiver"

	^self!

asPoint3D
	"Answer a Point3D with the receiver."

	^self x @ self y @ 0!

asUInt32
	"Answer the receiver in a form suitable for returning as the result of a window procedure (or passing to a function expecting a 32-bit value)."

	^((y bitAnd: 16rFFFF) bitShift: 16) bitOr: (x bitAnd: 16rFFFF)!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as a Windows LRESULT (32 or 64-bit, depending on host OS) return value. The default is self (which will cause the default window proc. of the window to be called for most objects other than Integers when used as a return value)."

	^(self x bitAnd: VMConstants.HalfPtrMask)
		bitOr: ((self y bitAnd: VMConstants.HalfPtrMask) bitShift: VMConstants.HalfPtrBits)!

ceiling
	"Answer a new Point with the x and y values of the receiver truncated
	toward positive infinity."

	^x ceiling @ y ceiling!

coerce: anArithmeticValue
	"Private - Answer the lower generality <arithmeticValue> argument converted to a <point>."

	^anArithmeticValue asGenericPoint!

corner: aPoint
	"Answers a Rectangle defined by the receiver and aPoint."

	^Rectangle origin: self corner: aPoint!

degrees
	"Answer the angle the receiver makes with origin in degrees. right is 0; down is 90."

	x = 0 
		ifTrue: [y >= 0 ifTrue: [^90.0] ifFalse: [^270.0]]
		ifFalse: 
			[| tan theta |
			tan := y asFloat / x asFloat.
			theta := tan arcTan.
			x >= 0 
				ifTrue: [y >= 0 ifTrue: [^theta radiansToDegrees] ifFalse: [^360.0 + theta radiansToDegrees]]
				ifFalse: [^180.0 + theta radiansToDegrees]]!

displayOn: aStream
	"Append a short textual description of the receiver to the <puttableStream> argument."

	aStream
		print: x;
		nextPut: $@;
		print: y!

dist: aPoint 
	"Answer the distance between aPoint and the receiver."

	^(aPoint - self) r!

divideIntoInteger: anInteger
	"Private - Answer the <point> result of dividing the receiver into the known <integer> argument."

	^Point x: anInteger / x y: anInteger / y!

divideIntoPoint: aPoint
	"Private - Answer the <point> result of dividing the receiver into the known <point> argument."

	^Point x: aPoint x / x y: aPoint y / y!

dotProduct: aPoint 
	"Answer a Number that is the sum of the product of the x coordinates
	and the product of the y coordinates of the receiver and aPoint"

	^(x * aPoint x) + (y * aPoint y)!

extent: aPoint
	"Answers a Rectangle whose origin is the receiver and whose
	extent is the argument aPoint"

	^Rectangle origin: self extent: aPoint!

floor
	"Answer a new Point with the x and y values of the receiver truncated
	toward negative infinity."

	^x floor @ y floor!

generality
	"Private - Answer the Smalltalk generality of the receiver, used for performing type conversions"

	^50!

hash
	"Answer the <integer> hash value for the receiver."

	^(x hash bitShift: 2) bitXor: y hash!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

isZero
	^x = 0 and: [y = 0]!

max
	"Answer the maximum of the receiver's x and y co-ordinates."

	^x max: y!

max: aPoint
	"Answer a new Point with the maximum of the x coordinates
	and the maximum of the y coordinates of the receiver and aPoint"

	^(x max: aPoint x) @ (y max: aPoint y)!

min
	"Answer the maximum of the receiver's x and y co-ordinates."

	^x min: y!

min: aPoint
	"Answer a new Point with the maximum of the x coordinates
	and the maximum of the y coordinates of the receiver and aPoint"

	^(x min: aPoint x) @ (y min: aPoint y)!

multiplyByPoint: aPoint
	"Private - Answer the <point> result of mulplying the receiver by the known <point> argument."

	^Point x: x * aPoint x y: y * aPoint y!

printOn: aStream
	"Append a short textual description of the receiver to the <puttableStream> argument."

	aStream
		nextPut: $(;
		display: self;
		nextPut: $)!

r
	"Answer the receiver's radius (magnitude) in a polar coordinate 
	system."

	^(self dotProduct: self) sqrt!

raisedTo: operand
	"Answer an <ArithmeticValue> which is the receiver raised to the power of 
	the <number> argument, operand."

	^(x raisedTo: operand) @ (y raisedTo: operand)!

rounded
	"Answer a new Point with the x and y values of the receiver rounded.
	Implementation Note: Superclass implementation works, but we can do it more efficiently."

	^x rounded @ y rounded!

roundTo: aNumber 
	"Answer a new <point> with the x, y values of the receiver rounded."

	^(x roundTo: aNumber) @ (y roundTo: aNumber)!

subtractFromInteger: anInteger
	^(Point x: anInteger y: anInteger) - self!

subtractFromPoint: aPoint
	"Private - Answer the <point> result of subtracting the receiver from the known <point> argument."

	^Point x: aPoint x - x y: aPoint y - y!

transpose
	"Answer a new Point with the x and y coordinates of the receiver
	reversed"

	^self class x: y y: x!

truncated
	"Answer a new Point with the x and y values of the receiver truncated toward zero"

	^x truncated @ y truncated!

x
	"Answer the receiver's x coordinate"

	^x!

x: aNumber
	"Set the receiver's x coordinate"

	x := aNumber!

x: xCoord y: yCoord
	"Private - Set the x and y coordinates of the receiver.
	Primarily intended for instance creation. Answer the receiver."

	x := xCoord.
	y := yCoord!

y
	"Answer the receiver's y coordinate"

	^y!

y: aNumber
	"Set the receiver's y coordinate"

	y := aNumber! !

!Graphics.Point categoriesForMethods!
-!arithmetic!public! !
*!arithmetic!public! !
/!arithmetic!public! !
@!converting!public! !
+!arithmetic!public! !
<!comparing!public! !
<=!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
abs!arithmetic!public! !
addToPoint:!double dispatch!private! !
asGenericPoint!converting!public! !
asParameter!converting!public! !
asPoint!converting!public! !
asPoint3D!converting!public! !
asUInt32!converting!public! !
asUIntPtr!converting!public! !
ceiling!public!truncation and round off! !
coerce:!coercing!private! !
corner:!converting!public! !
degrees!accessing!public! !
displayOn:!printing!public! !
dist:!operations!public! !
divideIntoInteger:!double dispatch!private! !
divideIntoPoint:!double dispatch!private! !
dotProduct:!operations!public! !
extent:!converting!public! !
floor!public!truncation and round off! !
generality!coercing!private! !
hash!comparing!public! !
isSelfEvaluating!public!testing! !
isZero!public! !
max!comparing!public! !
max:!comparing!public! !
min!comparing!public! !
min:!comparing!public! !
multiplyByPoint:!double dispatch!private! !
printOn:!printing!public! !
r!accessing!public! !
raisedTo:!mathematical!public! !
rounded!public!truncation and round off! !
roundTo:!public!truncation and round off! !
subtractFromInteger:!double dispatch!private! !
subtractFromPoint:!double dispatch!private! !
transpose!operations!public! !
truncated!public!truncation and round off! !
x!accessing!public! !
x:!accessing!public! !
x:y:!accessing!private! !
y!accessing!public! !
y:!accessing!public! !
!

Graphics.Point methodProtocol: #point attributes: #(#readOnly) selectors: #(#- #% #* #** #/ #// #\\ #+ #< #<= #> #>= #abs #addToFloat: #addToFraction: #addToInteger: #addToPoint: #addToPoint3D: #addToScaledDecimal: #asGenericPoint #asPoint #between:and: #ceiling #corner: #degrees #dist: #divideIntoFloat: #divideIntoFraction: #divideIntoInteger: #divideIntoPoint: #divideIntoPoint3D: #divideIntoScaledDecimal: #dotProduct: #equalToFloat: #equalToFraction: #equalToInteger: #equalToScaledDecimal: #extent: #floor #fractionPart #generality #greaterOrEqualToFloat: #greaterOrEqualToFraction: #greaterOrEqualToInteger: #greaterOrEqualToScaledDecimal: #greaterThanFloat: #greaterThanFraction: #greaterThanInteger: #greaterThanScaledDecimal: #integerPart #isZero #max: #min: #multiplyByFloat: #multiplyByFraction: #multiplyByInteger: #multiplyByPoint: #multiplyByPoint3D: #multiplyByScaledDecimal: #negated #negative #positive #quo: #r #raisedTo: #raisedToInteger: #reciprocal #rem: #roundDownTo: #rounded #roundTo: #roundUpTo: #sign #squared #strictlyPositive #subtractFromFloat: #subtractFromFraction: #subtractFromInteger: #subtractFromPoint: #subtractFromPoint3D: #subtractFromScaledDecimal: #truncated #truncateTo: #understandsArithmetic #x #x: #y #y:)!

!Graphics.Point class methodsFor!

initialize
	Zero := (self x: 0 y: 0)
				beImmutableObject;
				yourself!

new
	"Answer a new instance of the receiver equal to zero."

	^self zero!

one
	"Answer the receiver's representation of one."

	^self x: 1 y: 1!

unitialize
	#{Zero} binding setValue: nil!

x: xCoord y: yCoord 
	"Answer a new instance of the receiver with the specified
	x and y coordinates"

	<primitive: 157>
	^self basicNew x: xCoord y: yCoord!

zero
	"Answer the receiver's representation of zero."

	^Zero! !

!Graphics.Point class categoriesForMethods!
initialize!class initialization!development!public! !
new!instance creation!public! !
one!instance creation!public! !
unitialize!class hierarchy-removing!public! !
x:y:!instance creation!public! !
zero!instance creation!public! !
!

