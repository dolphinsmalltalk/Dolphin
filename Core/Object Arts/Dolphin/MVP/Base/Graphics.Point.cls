"Filed out from Dolphin Smalltalk 7"!

Core.ArithmeticValue subclass: #'Graphics.Point'
	instanceVariableNames: 'x y'
	classVariableNames: 'Zero'
	imports: #(#{Kernel.VMConstants private})
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

	^(External.DWORD fromPoint: self) value!

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

	^(self x bitAnd: HalfPtrMask) bitOr: ((self y bitAnd: HalfPtrMask) bitShift: HalfPtrBits)!

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

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

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

printOn: aStream
	"Append a short textual description of the receiver to the <puttableStream> argument."

	aStream
		nextPut: $(;
		print: x;
		nextPut: $@;
		print: y;
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
!Graphics.Point categoriesFor: #-!arithmetic!public! !
!Graphics.Point categoriesFor: #*!arithmetic!public! !
!Graphics.Point categoriesFor: #/!arithmetic!public! !
!Graphics.Point categoriesFor: #@!converting!public! !
!Graphics.Point categoriesFor: #+!arithmetic!public! !
!Graphics.Point categoriesFor: #<!comparing!public! !
!Graphics.Point categoriesFor: #<=!comparing!public! !
!Graphics.Point categoriesFor: #=!comparing!public! !
!Graphics.Point categoriesFor: #>!comparing!public! !
!Graphics.Point categoriesFor: #>=!comparing!public! !
!Graphics.Point categoriesFor: #abs!arithmetic!public! !
!Graphics.Point categoriesFor: #addToPoint:!double dispatch!private! !
!Graphics.Point categoriesFor: #asDword!converting!public! !
!Graphics.Point categoriesFor: #asParameter!converting!public! !
!Graphics.Point categoriesFor: #asPoint!converting!public! !
!Graphics.Point categoriesFor: #asPoint3D!converting!public! !
!Graphics.Point categoriesFor: #asUIntPtr!converting!public! !
!Graphics.Point categoriesFor: #ceiling!public!truncation and round off! !
!Graphics.Point categoriesFor: #coerce:!coercing!private! !
!Graphics.Point categoriesFor: #corner:!converting!public! !
!Graphics.Point categoriesFor: #degrees!accessing!public! !
!Graphics.Point categoriesFor: #dist:!operations!public! !
!Graphics.Point categoriesFor: #divideIntoPoint:!double dispatch!private! !
!Graphics.Point categoriesFor: #dotProduct:!operations!public! !
!Graphics.Point categoriesFor: #extent:!converting!public! !
!Graphics.Point categoriesFor: #floor!public!truncation and round off! !
!Graphics.Point categoriesFor: #generality!coercing!private! !
!Graphics.Point categoriesFor: #hash!comparing!public! !
!Graphics.Point categoriesFor: #isSelfEvaluating!public!testing! !
!Graphics.Point categoriesFor: #max:!comparing!public! !
!Graphics.Point categoriesFor: #min:!comparing!public! !
!Graphics.Point categoriesFor: #multiplyByPoint:!double dispatch!private! !
!Graphics.Point categoriesFor: #printOn:!printing!public! !
!Graphics.Point categoriesFor: #r!accessing!public! !
!Graphics.Point categoriesFor: #raisedTo:!mathematical!public! !
!Graphics.Point categoriesFor: #rounded!public!truncation and round off! !
!Graphics.Point categoriesFor: #roundTo:!public!truncation and round off! !
!Graphics.Point categoriesFor: #subtractFromPoint:!double dispatch!private! !
!Graphics.Point categoriesFor: #transpose!operations!public! !
!Graphics.Point categoriesFor: #truncated!public!truncation and round off! !
!Graphics.Point categoriesFor: #x!accessing!public! !
!Graphics.Point categoriesFor: #x:!accessing!public! !
!Graphics.Point categoriesFor: #x:y:!accessing!private! !
!Graphics.Point categoriesFor: #y!accessing!public! !
!Graphics.Point categoriesFor: #y:!accessing!public! !

!Graphics.Point class methodsFor!

initialize
	Zero := (self x: 0 y: 0)
				isImmutable: true;
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
!Graphics.Point class categoriesFor: #initialize!class initialization!development!public! !
!Graphics.Point class categoriesFor: #new!instance creation!public! !
!Graphics.Point class categoriesFor: #one!instance creation!public! !
!Graphics.Point class categoriesFor: #unitialize!class hierarchy-removing!public! !
!Graphics.Point class categoriesFor: #x:y:!instance creation!public! !
!Graphics.Point class categoriesFor: #zero!instance creation!public! !

