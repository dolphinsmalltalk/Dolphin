"Filed out from Dolphin Smalltalk"!

ArithmeticValue subclass: #Point3D
	instanceVariableNames: 'x y z'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Point3D guid: (GUID fromString: '{87b4c659-026e-11d3-9fd7-00a0cc3e4a32}')!
Point3D comment: 'A Point3D represents an x-y-z pair of numbers usually indicating a point in a three-dimensional Cartesian coordinate volume. Following the convention for Point, Point3D is often attributed a "left-handed" coordinate system. However, this is not essential and either left or right-handed systems may be adopted depending on the application.

A Point3D is typically created using the binary message @ to a Point:

150 @ 200 @ 400

Arithmetic operations can be carried out between two Point3Ds or between a Point3D and a Number. Each of the arithmetic messages returns a new Point3D as the result. Note the need to make use of parentheses in the expressions below due to the equal precedence assigned to all binary messages (such as @ and +).

(150 @ 200 @ 400) + (50 @ 50 @ 50) "Addition of Point3Ds"
(150 @ 200 @ 400) + 100 "Addition of scalar"
(150 @ 200 @ 400) * 3 "Scaling"'!
!Point3D categoriesForClass!Graphics-Geometry! !
!Point3D methodsFor!

- anArithmeticValue
	"Answer the receiver minus anArithmeticValue as a Point3D."

	^anArithmeticValue subtractFromPoint3D: self!

* anArithmeticValue
	"Answer a Point3D with the receiver's coordinates multiplied by anArithmeticValue."

	^anArithmeticValue multiplyByPoint3D: self!

/ operand
	"Answer a Point3D with the receiver's coordinates divided by the <number>, 
	operand. If the operand is zero then a <ZeroDivide> is raised."

	^operand divideIntoPoint3D: self!

+ anArithmeticValue
	"Answer the sum of receiver and anArithmeticValue as a Point3D."

	^anArithmeticValue addToPoint3D: self!

< anArithmeticValue
	"Answer whether the receiver is above and to the left of anArithmeticValue."

	| aPoint3D |
	aPoint3D := anArithmeticValue asPoint3D.
	^x < aPoint3D x and: [y < aPoint3D y and: [z < aPoint3D z]]!

<= anArithmeticValue
	"Answer whether the receiver is neither below nor to the right of anArithmeticValue."

	| aPoint3D |
	aPoint3D := anArithmeticValue asPoint3D.
	^x <= aPoint3D x and: [y <= aPoint3D y and: [z <= aPoint3D z]]!

= anObject
	"Answer whether the receiver is considered equivalent to the argument."

	^self species == anObject species 
		ifTrue: [x = anObject x and: [y = anObject y  and: [z = anObject z]]]
		ifFalse: [super = anObject]!

> anArithmeticValue
	"Answer whether the receiver is below and to the right of anArithmeticValue."

	| aPoint3D |
	aPoint3D := anArithmeticValue asPoint3D.
	^x > aPoint3D x and: [y > aPoint3D y and: [z > aPoint3D z]]!

>= anArithmeticValue
	"Answer whether the receiver is neither above nor to the left of anArithmeticValue."

	| aPoint3D |
	aPoint3D := anArithmeticValue asPoint3D.
	^x >= aPoint3D x and: [y >= aPoint3D y and: [z >= aPoint3D z]]!

abs
	"Answer aPoint3D that is the absolute value - positive magnitude - of the receiver."

	^x abs @ y abs @ z abs!

addToPoint3D: aPoint3D
	"Private - Answer the result of adding the receiver to the known Point3D"

	^(aPoint3D x + x) @ (aPoint3D y + y) @ (aPoint3D z + z)!

asPoint
	"Answer a <Point> which is the 2D equivalent of the receiver, ignoring the z-axis component."

	^x @ y!

asPoint3D
	"Answer the receiver"

	^self!

ceiling
	"Answer a new Point3D with the x, y and z values of the receiver truncated
	toward positive infinity."

	^x ceiling @ y ceiling @ z ceiling!

coerce: anArithmeticValue
	"Private - Answer the lower generality ArithmeticValue, anArithmeticValue, 
	converted to a Point3D."

	^anArithmeticValue asPoint3D!

dist: aPoint 
	"Answer the distance between aPoint and the receiver."

	^(aPoint - self) r!

divideIntoPoint3D: aPoint3D
	"Private - Answer the result of dividing the receiver into the known Point3D"

	^(aPoint3D x / x) @ (aPoint3D y / y) @ (aPoint3D z / z)
!

dotProduct: aPoint3D
	"Answer a Number that is the dot product of the receiver and aPoint3D"

	^(x * aPoint3D x) + (y * aPoint3D y) + (z * aPoint3D z)!

floor
	"Answer a new Point3D with the x, y and z values of the receiver truncated
	toward negative infinity."

	^x floor @ y floor @ z floor!

generality
	"Private - Answer the Smalltalk generality of the receiver, 
	used for performing type conversions"

	^60!

hash
	"Answer the <integer> hash value for the receiver."

	^((x hash bitShift: 2) bitXor: (y hash bitShift: 1)) bitXor: (z hash)!

max: aPoint3D
	"Answer a new Point3D with the maximum of the x coordinates,
	 y coordinates and z coordinates of the receiver and aPoint3D"

	^(x max: aPoint3D x) @ (y max: aPoint3D y) @ (z max: aPoint3D z)
!

min: aPoint3D
	"Answer a new Point3D with the minimum of the x coordinates, y coordinates
	and z coordinates of the receiver and aPoint3D"

	^(x min: aPoint3D x) @ (y min: aPoint3D y) @ (z min: aPoint3D z)
!

multiplyByPoint3D: aPoint3D
	"Private - Answer the result of multiplying the receiver by aPoint3D"

	^(x * aPoint3D x) @ (y * aPoint3D y) @ (z* aPoint3D z)!

normalize
	^self / self r!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream 
		print: x;
		nextPut: $@;
		print: y;
		nextPut: $@;
		print: z
!

r
	"Answer the receiver's radius (magnitude) in a polar coordinate 
	system."

	^(self dotProduct: self) sqrt!

raisedTo: operand
	"Answer an <ArithmeticValue> which is the receiver raised to the power of 
	the <number> argument, operand."

	^(x raisedTo: operand) @ (y raisedTo: operand) @ (z raisedTo: operand)!

rounded
	"Answer a new Point3D with the x, y and z values of the receiver rounded."

	^x rounded @ y rounded @ z rounded!

roundTo: aNumber
	"Answer a new Point3D with the x, y and z values of the receiver rounded."

	^(x roundTo: aNumber) @ (y roundTo: aNumber) @ (z roundTo: aNumber)!

subtractFromPoint3D: aPoint3D
	"Private - Answer the result of subtracting the receiver from aPoint3D"

	^(aPoint3D x - x) @ (aPoint3D y - y) @ (aPoint3D z - z)
!

truncated
	"Answer a new Point3D with the x, y and z values of the receiver truncated."

	^x truncated @ y truncated @ z truncated!

x
	"Answer the x coordinate of the receiver"

	^x!

x: aNumber
	"Set the x coordinate of the receiver"

	x := aNumber!

x: xCoord y: yCoord z: zCoord
	"Set the coordinates of the receiver with the specified
	x, y and z coordinates"

	x := xCoord.
	y := yCoord.
	z := zCoord.!

y
	"Answer the y coordinate of the receiver"

	^y!

y: aNumber
	"Set the y coordinate of the receiver"

	y := aNumber!

z
	"Answer the z coordinate of the receiver"

	^z!

z: aNumber
	"Set the z coordinate of the receiver"

	z := aNumber! !
!Point3D categoriesForMethods!
-!arithmetic!public! !
*!arithmetic!public! !
/!arithmetic!public! !
+!arithmetic!public! !
<!comparing!public! !
<=!comparing!public! !
=!comparing!public! !
>!comparing!public! !
>=!comparing!public! !
abs!arithmetic!public! !
addToPoint3D:!double dispatch!private! !
asPoint!converting!public! !
asPoint3D!converting!public! !
ceiling!public!truncation and round off! !
coerce:!coercing!private! !
dist:!operations!public! !
divideIntoPoint3D:!double dispatch!private! !
dotProduct:!operations!public! !
floor!public!truncation and round off! !
generality!coercing!private! !
hash!comparing!public! !
max:!comparing!public! !
min:!comparing!public! !
multiplyByPoint3D:!double dispatch!private! !
normalize!public! !
printOn:!printing!public! !
r!accessing!public! !
raisedTo:!mathematical!public! !
rounded!public!truncation and round off! !
roundTo:!public!truncation and round off! !
subtractFromPoint3D:!double dispatch!private! !
truncated!public!truncation and round off! !
x!accessing!public! !
x:!accessing!public! !
x:y:z:!accessing!public! !
y!accessing!public! !
y:!accessing!public! !
z!accessing!public! !
z:!accessing!public! !
!

!Point3D class methodsFor!

fromFLOATArray: aFLOATArray 
	^self 
		x: (aFLOATArray at: 1)
		y: (aFLOATArray at: 2)
		z: (aFLOATArray at: 3)!

icon
	"Answers an Icon that can be used to represent this class"

	^Point icon!

new
	"Answer a new instance of the receiver equal to zero."

	^self zero!

one
	"Answer the receiver's representation of one."

	^1 @ 1 @ 1!

origin
	"Answer a new instance of the receiver at the origin"	

	^self x: 0 y: 0 z: 0!

x: xCoord y: yCoord z: zCoord
	"Answer a new instance of the receiver with the specified
	x, y and z coordinates"

	^self basicNew x: xCoord y: yCoord z: zCoord!

xAxis
	"Answer an instance of the receiver that represents the x axis"

	^self x: 1 y: 0 z: 0!

yAxis
	"Answer an instance of the receiver that represents the y axis"

	^self x: 0 y: 1 z: 0!

zAxis
	"Answer an instance of the receiver that represents the z axis"

	^self x: 0 y: 0 z: 1!

zero
	"Answer the receiver's representation of zero."

	^0 @ 0 @ 0! !
!Point3D class categoriesForMethods!
fromFLOATArray:!public! !
icon!constants!public! !
new!instance creation!public! !
one!instance creation!public! !
origin!instance creation!public! !
x:y:z:!instance creation!public! !
xAxis!instance creation!public! !
yAxis!instance creation!public! !
zAxis!instance creation!public! !
zero!instance creation!public! !
!

