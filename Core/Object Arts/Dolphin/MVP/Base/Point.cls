"Filed out from Dolphin Smalltalk 7"!

ArithmeticValue subclass: #Point
	instanceVariableNames: 'x y'
	classVariableNames: 'Zero'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Point guid: (GUID fromString: '{87b4c658-026e-11d3-9fd7-00a0cc3e4a32}')!
Point comment: 'A Point represents an x-y pair of numbers usually indicating a point on a two-dimensional Cartesian coordinate plane. Points are often used to designate the location of pixels within a Bitmap or on the display screen. By Smalltalk convention, x increases to the right and y down, consistent with the layout of text on a page and with pixels in Windows'' bitmaps. This "left-handed" coordinate system is the convention for Points used within the standard Smalltalk image (in classes such as Rectangle) but there is nothing in the Point class itself that prohibits the implied use of a "right-handed" coordinate system in which y increases in the upward direction.

A Point is typically created using the binary message @ to a Number:

150 @ 200

Arithmetic operations can be carried out between two Points or between a Point and a Number. Each of the arithmetic messages returns a new Point as the result. Note the need to make use of parentheses in the expressions below due to the equal precedence assigned to all binary messages (such as @ and +).

(150 @ 200) + (50 @ 50) "Addition of Points"
(150 @ 200) + 100 "Addition of scalar"
(150 @ 200) * 3 "Scaling"'!
!Point categoriesForClass!Graphics-Geometry! !
!Point methodsFor!

- anArithmeticValue
	"Answer the receiver minus anArithmeticValue as a Point."

	^anArithmeticValue subtractFromPoint: self!

* anArithmeticValue
	"Answer a Point with the receiver's coordinates multiplied by anArithmeticValue."

	^anArithmeticValue multiplyByPoint: self!

/ operand
	"Answer a Point with the receiver's coordinates divided by the <number>, 
	operand. If the operand is zero then a <ZeroDivide> is raised."

	^operand divideIntoPoint: self!

@ zCoord
	"Answer a Point3D with the receiver as X, Y coordinates and the argument as Z."

	^Point3D x: x y: y z: zCoord!

+ anArithmeticValue
	"Answer the sum of receiver and aPoint as a Point."

	^anArithmeticValue addToPoint: self!

< anArithmeticValue
	"Answer whether the receiver is above and to the left of anArithmeticValue.
	N.B. No double dispatch, as would need to do for more than just #<."

	| aPoint |
	aPoint := anArithmeticValue asPoint.
	^x < aPoint x and: [ y < aPoint y ]!

<= anArithmeticValue
	"Answer whether the receiver is neither below nor to the right of anArithmeticValue.
	A double dispatch of #< with the superclass implementation of #<= would not work here."

	| aPoint |
	aPoint := anArithmeticValue asPoint.
	^x <= aPoint x and: [ y <= aPoint y ]!

= comperand
	"Answer whether the receiver is considered equivalent to the
	<Object> argument, comperand."

	^self species == comperand species
		ifTrue: [x = comperand x and: [y = comperand y]]
		ifFalse: [super = comperand]!

> anArithmeticValue
	"Answer whether the receiver is below and to the right of anArithmeticValue.
	A double dispatch of #< with the superclass implementation of #> would not work here."

	| aPoint |
	aPoint := anArithmeticValue asPoint.
	^x > aPoint x and: [y > aPoint y]
!

>= anArithmeticValue
	"Answer whether the receiver is neither above nor to the left of anArithmeticValue.
	A double dispatch of #< with the superclass implementation of #>= would not work here."
	
	| aPoint |
	aPoint := anArithmeticValue asPoint.
	^x >= aPoint x and: [ y >= aPoint y ]
!

abs
	"Answer a <Point> that is the absolute value (positive magnitude) of the receiver."

	^x abs @ y abs!

addToPoint: aPoint
	"Private - Answer the result of adding the receiver to the known Point,
	aPoint, by coercing the less general of it and the receiver. Overridden by 
	subclasses which can implement more efficiently."

	^(aPoint x + x) @ (aPoint y + y)!

asDword
	"Answer the receiver in a form suitable for returning as the result of a window
	procedure (or passing to a function expecting a 32-bit value)."

	^(DWORD fromPoint: self) value!

asParameter
	"Answer the receiver in a form suitable for passing to an external function."

	^POINTL fromPoint: self!

asPoint
	"Answer the receiver"

	^self!

asPoint3D
	"Answer a Point3D with the receiver."

	^self x @ self y @ 0!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as a Windows LRESULT
	(32 or 64-bit, depending on host OS) return value. The default is self (which will cause the
	default window proc. of the window to be called for most objects other than Integers when
	used as a return value)."

	^(self x bitAnd: VMConstants.HalfPtrMask) 
		bitOr: ((self y bitAnd: VMConstants.HalfPtrMask) bitShift: VMConstants.HalfPtrBits)!

ceiling
	"Answer a new Point with the x and y values of the receiver truncated
	toward positive infinity."

	^x ceiling @ y ceiling!

coerce: anArithmeticValue
	"Private - Answer the lower generality ArithmeticValue, anArithmeticValue, 
	converted to a Point."

	^anArithmeticValue asPoint!

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

dist: aPoint 
	"Answer the distance between aPoint and the receiver."

	^(aPoint - self) r!

divideIntoPoint: aPoint
	"Private - Answer the result of dividing the receiver into the known Point, aPoint, by 
	coercing the less general of it and the receiver. Overridden by subclasses which 
	can implement more efficiently."

	^(aPoint x / x) @ (aPoint y / y)!

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

max: aPoint
	"Answer a new Point with the maximum of the x coordinates
	and the maximum of the y coordinates of the receiver and aPoint"

	^(x max: aPoint x) @ (y max: aPoint y)!

min: aPoint
	"Answer a new Point with the maximum of the x coordinates
	and the maximum of the y coordinates of the receiver and aPoint"

	^(x min: aPoint x) @ (y min: aPoint y)!

multiplyByPoint: aPoint
	"Private - Answer the result of multiplying the known Point, aPoint,
	by the receiver, by coercing the less general of it and the recever.
	Overridden by subclasses which can implement more efficiently."

	^(x * aPoint x) @ (y * aPoint y)!

printOn: target
	"Append a short textual description of the receiver to the
	<puttableStream>, target."

	target 
		print: x;
		nextPut: $@;
		print: y!

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
	Implementation Note: Superclass implemenation works, but we can do it more efficiently."

	^x rounded @ y rounded!

roundTo: aNumber 
	"Answer a new Point3D with the x, y values of the receiver rounded."

	^(x roundTo: aNumber) @ (y roundTo: aNumber)!

subtractFromPoint: aPoint
	"Private - Answer the result of subtracting the receiver from the known Point,
	aPoint, by coercing the less general of it and the receiver. Overridden by 
	subclasses which can implement more efficiently."

	^(aPoint x - x) @ (aPoint y - y)!

transpose
	"Answer a new Point with the x and y coordinates of the receiver
	reversed"

	^y @ x!

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
!Point categoriesFor: #-!arithmetic!public! !
!Point categoriesFor: #*!arithmetic!public! !
!Point categoriesFor: #/!arithmetic!public! !
!Point categoriesFor: #@!converting!public! !
!Point categoriesFor: #+!arithmetic!public! !
!Point categoriesFor: #<!comparing!public! !
!Point categoriesFor: #<=!comparing!public! !
!Point categoriesFor: #=!comparing!public! !
!Point categoriesFor: #>!comparing!public! !
!Point categoriesFor: #>=!comparing!public! !
!Point categoriesFor: #abs!arithmetic!public! !
!Point categoriesFor: #addToPoint:!double dispatch!private! !
!Point categoriesFor: #asDword!converting!public! !
!Point categoriesFor: #asParameter!converting!public! !
!Point categoriesFor: #asPoint!converting!public! !
!Point categoriesFor: #asPoint3D!converting!public! !
!Point categoriesFor: #asUIntPtr!converting!public! !
!Point categoriesFor: #ceiling!public!truncation and round off! !
!Point categoriesFor: #coerce:!coercing!private! !
!Point categoriesFor: #corner:!converting!public! !
!Point categoriesFor: #degrees!accessing!public! !
!Point categoriesFor: #dist:!operations!public! !
!Point categoriesFor: #divideIntoPoint:!double dispatch!private! !
!Point categoriesFor: #dotProduct:!operations!public! !
!Point categoriesFor: #extent:!converting!public! !
!Point categoriesFor: #floor!public!truncation and round off! !
!Point categoriesFor: #generality!coercing!private! !
!Point categoriesFor: #hash!comparing!public! !
!Point categoriesFor: #max:!comparing!public! !
!Point categoriesFor: #min:!comparing!public! !
!Point categoriesFor: #multiplyByPoint:!double dispatch!private! !
!Point categoriesFor: #printOn:!printing!public! !
!Point categoriesFor: #r!accessing!public! !
!Point categoriesFor: #raisedTo:!mathematical!public! !
!Point categoriesFor: #rounded!public!truncation and round off! !
!Point categoriesFor: #roundTo:!public!truncation and round off! !
!Point categoriesFor: #subtractFromPoint:!double dispatch!private! !
!Point categoriesFor: #transpose!operations!public! !
!Point categoriesFor: #truncated!public!truncation and round off! !
!Point categoriesFor: #x!accessing!public! !
!Point categoriesFor: #x:!accessing!public! !
!Point categoriesFor: #x:y:!accessing!private! !
!Point categoriesFor: #y!accessing!public! !
!Point categoriesFor: #y:!accessing!public! !

!Point class methodsFor!

initialize
	self addClassConstant: 'Zero' value: ((self x: 0 y: 0) isImmutable: true; yourself)!

new
	"Answer a new instance of the receiver equal to zero."

	^self zero!

one
	"Answer the receiver's representation of one."

	^self x: 1 y: 1!

unitialize
	(classPool bindingFor: 'Zero')
		isImmutable: false;
		value: nil!

x: xCoord y: yCoord 
	"Answer a new instance of the receiver with the specified
	x and y coordinates"

	<primitive: 157>
	^self basicNew x: xCoord y: yCoord!

zero
	"Answer the receiver's representation of zero."

	^Zero! !
!Point class categoriesFor: #initialize!class initialization!development!public! !
!Point class categoriesFor: #new!instance creation!public! !
!Point class categoriesFor: #one!instance creation!public! !
!Point class categoriesFor: #unitialize!class hierarchy-removing!public! !
!Point class categoriesFor: #x:y:!instance creation!public! !
!Point class categoriesFor: #zero!instance creation!public! !

