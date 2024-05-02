"Filed out from Dolphin Smalltalk"!

Object subclass: #Rectangle
	instanceVariableNames: 'origin corner'
	classVariableNames: 'Empty'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Rectangle guid: (GUID fromString: '{87b4c4ad-026e-11d3-9fd7-00a0cc3e4a32}')!

Rectangle comment: 'Instances of Rectangle represent a rectangular areas in a two dimensional Cartesian coordinate system. A Rectangle contains two Points; origin, which specifies the top left corner, and corner, which indicates the bottom right corner of the region described. 

A Rectangle is typically created by sending the method #corner: to an instance of Point, although a number of other instance creation class methods are also provided:

100@100 corner: 150@150

Rectangles inhabit the same Smalltalk standard "left-handed" coordinate system as do Points; i.e. with the y axis increasing downwards. Because of this, in a non-empty Rectangle, the origin is always expected to be above and to the left of the corner. Rectangles that are not in this normalised state can be sent the message #normalize to answer a copy that is. Many of the operation messages on Rectangles will assume that the receiver is normalised.

(150@150 corner: 100@100) normalize'!

!Rectangle categoriesForClass!Graphics-Geometry! !

!Rectangle methodsFor!

_expandRectangle: aRectangle 
	"Private - Expand the <Rectangle> argument by the magnitude of the receiver.
	Double-dispatched from the Rectangle itself."

	^aRectangle species origin: aRectangle origin - origin corner: aRectangle corner + corner!

_insetRectangle: aRectangle 
	"Private - Inset the <Rectangle> argument by the magnitude of the receiver.
	Double-dispatched from the Rectangle itself."

	^aRectangle species origin: aRectangle origin + origin corner: aRectangle corner - corner!

_offsetRectangle: aRectangle 
	"Private - Offset the <Rectangle> argument by the magnitude of the receiver.
	Double-dispatched from the Rectangle itself."

	^aRectangle species origin: aRectangle origin + origin corner: aRectangle corner + corner!

= anObject 
	"Answer whether the receiver is considered equivalent to the argument
	anObject."

	"Implementation Note: We use the non-evaluating conjunction to prevent anObject being sent
	messages it might not understand."

	^self species == anObject species and: [origin = anObject origin and: [corner = anObject corner]]!

area
	"Answer the area of the receiver; the product of width and height."

	^self width * self height!

areasOutside: aRectangle
	"Answer a <collection> of <Rectangle>s describing areas of the receiver outside the
	<Rectangle> argument."

	| areas yOrigin yCorner |
	(self intersects: aRectangle) ifFalse: [^{self}].
	areas := OrderedCollection new: 4.
	yOrigin := self top.
	aRectangle top > yOrigin
		ifTrue: [areas addLast: (origin corner: corner x @ (yOrigin := aRectangle top))].
	yCorner := self bottom.
	aRectangle bottom < yCorner
		ifTrue: [areas addLast: (self left @ (yCorner := aRectangle bottom) corner: corner)].
	aRectangle left > self left
		ifTrue: [areas addLast: (self left @ yOrigin corner: aRectangle left @ yCorner)].
	aRectangle right < self right
		ifTrue: [areas addLast: (aRectangle right @ yOrigin corner: self right @ yCorner)].
	^areas!

asParameter
	"Answer the receiver in a form suitable for passing to an external function, in this case as
	a Win32 RECT structure."

	^RECT
		left: origin x asInteger
		top: origin y asInteger
		right: corner x asInteger
		bottom: corner y asInteger!

bottom
	"Answer the y coordinate of the receiver's bottom edge."

	^corner y!

bottom: aNumber 
	"Set the y-coordinate of the receiver's bottom edge."

	corner := corner x @ aNumber!

bottomAlign
	"Answers the bottom edge of the receiver. Used when paired with #bottomAlign:"

	^self bottom	!

bottomAlign: aNumber 
	"Move the receiver's bottom edge to be aligned with the specified y-coordinate. The extent
	of the receiver is maintained."

	origin := origin x @ (origin y + aNumber - corner y).
	corner := corner x @ aNumber!

bottomCenter
	"Answer a <Point> specifying the position of the centre of the bottom edge of the receiver."

	^self centerX @ self bottom!

bottomCenter: aPoint
	"Move the receiver's bottom edge to be centered over the <Point> argument."

	self
		bottom: aPoint y;
		center: aPoint x @ self centerY!

bottomLeft
	"Answer a <Point> representing the position of the receiver's bottom-left corner."

	^self left @ self bottom!

bottomLeft: aPoint 
	"Set the receiver's bottom-left corner to be at the <Point> argument. The top-right remains
	unchanged."

	origin x: aPoint x.
	corner y: aPoint y!

bottomRight
	"Answer a <Point> representing the position of the receiver's bottom-left corner. Note that
	this is the actual corner point. If it is modified, then the receiver will be affected."

	^corner!

bottomRight: aPoint 
	"Set the receiver's bottom-right corder to be the <Point> argument. The top-left remains
	unchanged."

	self corner: aPoint!

center
	"Answer a <Point> representing the position of the centre of the receiver."

	^self centerX @ self centerY!

center: aPoint 
	"Centre the receiver over the <Point> argument. The extent remains the same."

	self position: aPoint - (self extent // 2)!

centerRight
	"Answer a <Point> representing the position of the centre of the receiver's right edge."

	^self right @ self centerY!

centerX
	"Answer the x-coordinate of the point at the receiver's centre. Used in conjunction with
	#centerX:"

	^(self left + self right) // 2!

centerX: aNumber 
	"Centre the receiver over the specified x-coordinate. The extent remains the same"

	self center: aNumber @ self centerY!

centerY
	"Answer the y-coordinate of the point at the receiver's centre. Used in conjunction with
	#centerY:"

	^(self top + self bottom) // 2!

centerY: aNumber 
	"Centre the receiver over the specified y-coordinate. The extent remains the same"

	self center: self centerX @ aNumber!

constrain: aPoint 
	"Answer a <Point> which is the <Point> argument constrained to be within the bounds of the
	receiver."

	^(aPoint max: self origin) min: self corner - 1!

contains: aRectangle 
	"Answer whether the <Rectangle> argument is contained by the receiver (inclusive)."

	^aRectangle origin >= self origin and: [aRectangle corner <= self corner]!

containsPoint: aPoint
	"Answer whether the <Point> argument is contained by the receiver. Containment is defined by
	origin point <= aPoint (inclusive), and aPoint < corner point (non-inclusive)"

	^self origin <= aPoint and: [aPoint < self corner]!

copy
	"Answer a copy of the receiver."

	^self class origin: self origin copy corner: self corner copy
	
	!

corner
	"Answer the <Point> at the bottom-right corner of the receiver."

	^corner!

corner: aPoint 
	"Set the position of the receiver's bottom-right corner."

	corner := aPoint!

expandBy: delta
	"Retained for backwards compatibility, but discouraged because the use of the present tense implies that the operation happens in place, but in fact a new instance is answered. #expandedBy: should be used in preference."

	^self expandedBy: delta!

expandedBy: delta
	"Answer a new <Rectangle> that is expanded from the receiver by the argument delta, where
	delta may be a <Rectangle>, a <Point>, or a <Number>."

	^delta _expandRectangle: self!

extent
	"Answer a <Point> representing the extent of the receiver. The x-coordinate is the width and the y-coordinate is the height."

	^corner - origin!

extent: aPoint 
	"Set the extent of the receiver to equal the <Point> argument. The origin remains the same and the
	corner stays in the same quadrant it was in relative to the origin point. If aPoint contains
	any negative value, the result is undefined."

	corner := origin + aPoint!

hash
	"Answer the <integer> hash value for the receiver such that for any two Rectangles which
	compare equivalent, they have the same hash value."

	^origin hash bitXor: corner hash!

height
	"Answer the height of the receiver."

	^corner y - origin y!

height: aNumber
	"Change the receiver's height to aNumber. (The origin remains the same. If aNumber
	is negative, then the result is undefined)."

	self corner: self right @ (self top + aNumber)!

insetBy: delta 
	"Answer a new <Rectangle> that is inset from the receiver by the argument, delta, where
	delta may be a <Rectangle>, a <Point>, or a <Number>."

	^delta _insetRectangle: self!

insetCornerBy: aPoint 
	^self species origin: origin corner: corner - aPoint!

insetOriginBy: delta 
	"Answer a new <Rectangle> that is inset from the receiver by the argument, delta, where
	delta may be a <Point>, or a <Number>."

	^self species origin: origin + delta corner: corner!

insetOriginBy: originDelta cornerBy: cornerDelta 
	"Answer a <Rectangle> that is inset from the receiver by a given amounts at its origin and
	corner. The deltas may be <Number>s or <Point>s."

	^self species origin: origin + originDelta corner: corner - cornerDelta!

intersect: aRectangle
	"Answer a new <Rectangle> representing the area in which the receiver and argument overlap.
	If the receiver and aRectangle do not overlap then the result will have negative height
	and/or width."

	^self species origin: (self origin max: aRectangle origin)
		corner: (self corner min: aRectangle corner)!

intersects: aRectangle
	"Answer whether the receiver and argument overlap."

	^self origin < aRectangle corner and: 
			[aRectangle origin < self corner
				and: [self origin < self corner and: [aRectangle origin < aRectangle corner]]]!

left
	"Answer the position of the receiver's left edge."

	^origin x!

left: aNumber 
	"Sets the position of the receiver's left edge."

	origin := aNumber @ origin y!

leftAlign
	"Answers the left edge of the receiver. Used when paired with #leftAlign:"

	^self left	!

leftAlign: newLeft 
	"Move the receiver to align its left edge with the specified x-coordinate. The extent of the
	receiver is maintained."

	corner := (corner x + newLeft - origin x) @ corner y.
	origin := newLeft @ origin y!

leftCenter
	"Answer a <Point> specifying the position of the centre of the receiver's left edge."

	^self left @ self centerY!

leftCenter: aPoint 
	"Move the receiver's left edge so that it is centred over the specified <Point>."

	self left: aPoint x.
	self center: self centerX @ aPoint y!

merge: aRectangle
	"Answer the smallest <Rectangle> that contains both the receiver and argument <Rectangle>.
	The resulting rectangle will be defined by the leftmost edge of the two left edges (from the
	two rectangles being merged), the rightmost edge, the topmost edge, and the bottommost
	edge."

	^self species origin: (self origin min: aRectangle origin)
		corner: (self corner max: aRectangle corner)!

moveBy: delta
	"Move the receiver's origin and corner by the argument, delta, where delta can be a <Point>
	or a <Number>."

	"N.B. This is a transformation; the receiver itself is modified. You probably want to use
	#translatedBy: instead!!"

	self
		origin: self origin + delta;
		corner: self corner + delta!

moveTo: aPoint
	"Move the receiver so that its origin is at the specified <Point>."

	"N.B. This is a transformation; the receiver itself is modified."

	self
		corner: self bottomRight + aPoint - self origin;
		origin: aPoint!

normalize
	"Answer a Rectangle that is a normalized version of the receiver.
	ie. the origin is above and to the left of the corner"

	^self species vertex: origin vertex: corner
!

origin
	"Answer the <Point> at the top-left corner of the receiver."

	^origin!

origin: aPoint 
	"Sets the position of the receiver's top left corner."

	origin := aPoint!

origin: originPoint corner: cornerPoint
	"Set the receiver's origin and corner <Point>s."

	self
		origin: originPoint;
		corner: cornerPoint!

origin: originPoint extent: extentPoint
	"Set the receiver's origin and extent."

	self
		origin: originPoint;
		extent: extentPoint!

position
	"Answers the position of the receiver's top left corner"

	^self origin!

position: aPoint 
	"Move the receiver so that its top-left corner is at the specified position."

	self origin: aPoint extent: self extent!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream 
		print: origin; 
		nextPutAll: ' corner: '; 
		print: corner!

right
	"Answer the position of the receiver's right edge."

	^corner x!

right: aNumber 
	"Sets the position of the receiver's right edge to the <Number> argument."

	corner := aNumber @ corner y!

rightAlign
	"Answers the right edge of the receiver. Used when paired with #rightAlign:"

	^self right	!

rightAlign: aNumber 
	"Move the receiver so that its right edge is aligned with the specified x-coordinate. The
	extent of the receiver is maintained."

	origin := (origin x + aNumber - corner x) @ origin y.
	corner := aNumber @ corner y!

rightCenter
	"Answer a <Point> specifying the position of the centre of the receiver's right edge."

	^self right @ self centerY!

rightCenter: aPoint 
	"Move the receiver's right edge so that it is centred over the specified <Point>."

	self right: aPoint x.
	self center: self centerX @ aPoint y!

rounded
	"Answer a new <Rectangle> whose origin and corner coordinates are the same as the
	receiver's, but rounded to the nearest <integer>."

	^self species origin: origin rounded corner: corner rounded!

scaleBy: delta
	"Retained for backwards compatibility, but discouraged because the use of the present tense implies that the operation happens in place, but in fact a new instance is answered. #scaledBy: should be used in preference."

	^self scaledBy: delta!

scaledBy: anArithmeticValue
	"Answer a new <Rectangle> representing the receiver with origin and corner multiplied by the <ArithmeticValue> argument. Uses the #vertex:vertex: constructor in order to create a normalised rectangle"

	^self species vertex: origin * anArithmeticValue vertex: corner * anArithmeticValue!

scaleToDpi: desiredInteger from: currentInteger
	"Scale the receiver in-place by from the DPI represented by the first <integer> argument to that represented by the second integer argument.
	Note that the scaled points are also truncated. Co-ordinates in Win32 are integers, so some kind of rounding is required at or before the point of use. The expectation is that the scaling will be done once as otherwise there may be an accumulation of rounding error."

	origin := Point x: origin x * desiredInteger // currentInteger
				y: origin y * desiredInteger // currentInteger.
	corner := Point x: corner x * desiredInteger // currentInteger
				y: corner y * desiredInteger // currentInteger!

subtract: aRectangle
	| rect |
	#todo "Implememt in Smalltalk".
	rect := RECT new.
	UserLibrary default subtractRect: rect lprcSrc1: self asParameter lprcSrc2: aRectangle asParameter.
	^rect asObject!

top
	"Answer the position of the receiver's top edge."

	^origin y!

top: aNumber 
	"Set the position of the receiver's top edge to the <Number> argument."

	origin := origin x @ aNumber!

topAlign
	"Answers the top edge of the receiver. Used when paired with #topAlign:"

	^self top	!

topAlign: aNumber 
	"Move the receiver so that its top edge is aligned with the specified the y-coordinate. The
	extent of the receiver is maintained."

	corner := corner x @ (corner y + aNumber - origin y).
	origin := origin x @ aNumber!

topCenter
	"Answer a <Point> specifying the position of the centre of the receiver's top edge."

	^self centerX @ self top!

topCenter: aPoint
	"Move the receiver's top edge so that it is centred on the specified <Point>."

	self
		top: aPoint y;
		center: aPoint x @ self centerY!

topLeft
	"Answer the <Point> at the top-left corner of the receiver."

	^origin!

topLeft: aPoint 
	"Set the receiver's top-left corner to the <Point> argument. (The bottom right remains
	unchanged)."

	self origin: aPoint!

topRight
	"Answer a <Point> specifyihng the position of the receiver's top-right corner."

	^self right @ self top!

topRight: aPoint
	"Set the receiver's top-right corner to aPoint. (The bottom-left remains unchanged)."

	self
		top: aPoint y;
		right: aPoint x!

translateBy: delta 
	"Answer a new <Rectangle> representing the receiver with origin and corner incremented by delta, where delta is a <Point>, a <Number>, or another <Rectangle>. This is the message used in the IBM Red Book, but Smalltalk-80 uses #translatedBy: (which has the correct tense in that this is not an in-place operation, but rather returns a new Rectangle)."

	^self translatedBy: delta!

translatedBy: delta 
	"Annswer a new <Rectangle> representing the receiver with origin and corner incremented by delta, where delta is a <Point>, a <Number>, or another <Rectangle>."

	^delta _offsetRectangle: self!

truncated
	"Answer a new <Rectangle> whose origin and corner coordinates are the same as the
	receiver's, but truncated to the nearest <integer>."

	^self species origin: origin truncated corner: corner truncated!

vertices
	"Answer <Array> of <Point>s representing the 4 corners of the receiver in the clockwise order from the origin (top-left)."

	^{self topLeft. self topRight. self bottomRight. self bottomLeft}!

width
	"Answer the width of the receiver."

	^corner x - origin x!

width: aNumber
	"Change the receiver's width to aNumber. (The origin remains the same. If aNumber is
	negative, the result is undefined)"

	self corner: (self left + aNumber) @ self bottom! !

!Rectangle categoriesForMethods!
_expandRectangle:!double dispatch!private! !
_insetRectangle:!double dispatch!private! !
_offsetRectangle:!double dispatch!private! !
=!comparing!public! !
area!accessing!public! !
areasOutside:!accessing!public! !
asParameter!converting!public! !
bottom!accessing!public! !
bottom:!accessing!public! !
bottomAlign!accessing!public! !
bottomAlign:!accessing!public! !
bottomCenter!accessing!public! !
bottomCenter:!accessing!public! !
bottomLeft!accessing!public! !
bottomLeft:!accessing!public! !
bottomRight!accessing!public! !
bottomRight:!accessing!public! !
center!accessing!public! !
center:!accessing!public! !
centerRight!accessing!public! !
centerX!accessing!public! !
centerX:!accessing!public! !
centerY!accessing!public! !
centerY:!accessing!public! !
constrain:!public!rectangle functions! !
contains:!public!testing! !
containsPoint:!public!testing! !
copy!copying!public! !
corner!accessing!public! !
corner:!accessing!public! !
expandBy:!public!rectangle functions! !
expandedBy:!public!rectangle functions! !
extent!accessing!public! !
extent:!accessing!public! !
hash!comparing!public! !
height!accessing!public! !
height:!accessing!public! !
insetBy:!public!rectangle functions! !
insetCornerBy:!operations!public! !
insetOriginBy:!public!rectangle functions! !
insetOriginBy:cornerBy:!public!rectangle functions! !
intersect:!public!rectangle functions! !
intersects:!public!testing! !
left!accessing!public! !
left:!accessing!public! !
leftAlign!accessing!public! !
leftAlign:!accessing!public! !
leftCenter!accessing!public! !
leftCenter:!accessing!public! !
merge:!public!rectangle functions! !
moveBy:!public!transforming! !
moveTo:!public!transforming! !
normalize!public!rectangle functions! !
origin!accessing!public! !
origin:!accessing!public! !
origin:corner:!accessing!public! !
origin:extent:!accessing!public! !
position!accessing!public! !
position:!accessing!public! !
printOn:!printing!public! !
right!accessing!public! !
right:!accessing!public! !
rightAlign!accessing!public! !
rightAlign:!accessing!public! !
rightCenter!accessing!public! !
rightCenter:!accessing!public! !
rounded!public!truncation and round off! !
scaleBy:!public!transforming! !
scaledBy:!public!transforming! !
scaleToDpi:from:!public!transforming! !
subtract:!public!rectangle functions! !
top!accessing!public! !
top:!accessing!public! !
topAlign!accessing!public! !
topAlign:!accessing!public! !
topCenter!accessing!public! !
topCenter:!accessing!public! !
topLeft!accessing!public! !
topLeft:!accessing!public! !
topRight!accessing!public! !
topRight:!accessing!public! !
translateBy:!public!transforming! !
translatedBy:!public!transforming! !
truncated!converting!public! !
vertices!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
!

Rectangle methodProtocol: #rectangle attributes: #() selectors: #(#area #areasOutside: #bottom #bottom: #bottomCenter #bottomCenter: #bottomLeft #bottomLeft: #bottomRight #bottomRight: #center #center: #contains: #containsPoint: #corner #corner: #expandedBy: #extent #extent: #height #height: #insetBy: #intersect: #intersects: #left #left: #leftCenter #merge: #moveBy: #moveTo: #origin #origin: #origin:corner: #origin:extent: #right #right: #rightCenter #scaledBy: #top #top: #topCenter #topLeft #topLeft: #topRight #topRight: #translatedBy: #truncated #width #width:)!

!Rectangle class methodsFor!

center: centrePoint extent: extentPoint 
	"Answer an instance of the receiver of the extent, extentPoint, centred on centrePoint."

	^self origin: centrePoint - (extentPoint // 2) extent: extentPoint!

extent: aPoint
	"Answer an instance of the receiver of the extent, aPoint with origin at (0@0)."

	^self origin: Point.Zero corner: aPoint!

initialize
	self addClassConstant: 'Empty'
		value: (self new
				isImmutable: true;
				yourself)!

left: leftNumber top: topNumber right: rightNumber bottom: bottomNumber
	"Answer an instance of the receiver with the specified coodinates."

	^self origin: (Point x: leftNumber y: topNumber) corner: (Point x: rightNumber y: bottomNumber)!

left: left top: top width: width height: height
	"Answer a new instance of the receiver with the specified position
	and dimensions."

	^self 
		left: left
		top: top
		right: left+width
		bottom: top+height
!

new
	"Answer a new, empty, rectangle."

	^self origin: 0@0 corner: 0@0!

origin: originPoint corner: cornerPoint 
	"Answer a new instance of the receiver with specified origin and corner <Point>s."

	<primitive: 157>
	^(self basicNew)
		origin: originPoint corner: cornerPoint;
		yourself!

origin: originPoint extent: extentPoint 
	"Answer a new instance of the receiver with the specified origin and extent."

	^self origin: originPoint corner: originPoint + extentPoint!

unitialize
	(classPool bindingFor: 'Empty')
		isImmutable: false;
		value: nil!

vertex: aPoint1 vertex: aPoint2 
	"Answer a new, normalised, instance of the receiver with the specified diagonally opposite
	vertices."

	^self origin: (aPoint1 min: aPoint2) corner: (aPoint1 max: aPoint2)! !

!Rectangle class categoriesForMethods!
center:extent:!instance creation!public! !
extent:!public! !
initialize!class initialization!development!public! !
left:top:right:bottom:!instance creation!public! !
left:top:width:height:!instance creation!public! !
new!instance creation!public! !
origin:corner:!instance creation!public! !
origin:extent:!instance creation!public! !
unitialize!class hierarchy-removing!public! !
vertex:vertex:!instance creation!public! !
!

Rectangle class methodProtocol: #'rectangle factory' attributes: #(#readOnly) selectors: #(#center:extent: #extent: #left:top:right:bottom: #left:top:width:height: #new #origin:corner: #origin:extent: #vertex:vertex:)!

