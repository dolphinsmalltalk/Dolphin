"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #ExternalRectangle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalRectangle guid: (GUID fromString: '{e552b3f7-8653-46d4-b764-1e59cf1c15f7}')!

ExternalRectangle isAbstract: true!

ExternalRectangle comment: '`ExternalRectangle` is the abstract class of structures representing rectangular geometries. There are concrete subclasses for different types of position and extent values.'!

!ExternalRectangle categoriesForClass!Win32-Structs! !

!ExternalRectangle methodsFor!

= anObject
	"Answer whether the receiver is considered equivalent to the argument	anObject."

	^self species == anObject species
		and: [self topLeft = anObject topLeft and: [self bottomRight = anObject bottomRight]]!

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
		ifTrue: [areas addLast: (self origin corner: self right @ (yOrigin := aRectangle top))].
	yCorner := self bottom.
	aRectangle bottom < yCorner
		ifTrue: [areas addLast: (self left @ (yCorner := aRectangle bottom) corner: self corner)].
	aRectangle left > self left
		ifTrue: [areas addLast: (self left @ yOrigin corner: aRectangle left @ yCorner)].
	aRectangle right < self right
		ifTrue: [areas addLast: (aRectangle right @ yOrigin corner: self right @ yCorner)].
	^areas!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Rectangle>."

	^self asRectangle
!

asRectangle
	"Answer a new Rectangle that matches the receiver."

	^Rectangle origin: self topLeft corner: self bottomRight!

bottom
	^self subclassResponsibility!

bottom: anObject
	self subclassResponsibility!

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

	self
		left: aPoint x;
		bottom: aPoint y!

bottomRight
	"Answer a Point representing the bottom right position of the receiver."

	^self right @ self bottom!

bottomRight: aPoint
	"Set the <Point> representing the bottom right corner of the receiver."

	self
		right: aPoint x;
		bottom: aPoint y!

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

centerY
	"Answer the y-coordinate of the point at the receiver's centre. Used in conjunction with
	#centerY:"

	^(self top + self bottom) // 2!

contains: aRectangle
	"Answer whether the <Rectangle> argument is contained by the receiver (inclusive)."

	^aRectangle topLeft >= self topLeft and: [aRectangle bottomRight <= self bottomRight]!

containsPoint: aPoint
	"Answer whether the <Point> argument is contained by the receiver. Containment is defined by top-left <= aPoint (inclusive), and aPoint < bottom-right (non-inclusive)"

	^self topLeft <= aPoint and: [aPoint < self bottomRight]!

corner
	"Answer the Point at the bottom-right corner of the receiver"

	^self bottomRight
!

corner: aPoint
	"Set the position of the receiver's bottom-right corner."

	self bottomRight: aPoint!

expandBy: delta
	"Retained for backwards compatibility, but discouraged because the use of the present tense implies that the operation happens in place, but in fact a new instance is answered. #expandedBy: should be used in preference."

	^self expandedBy: delta!

expandedBy: delta
	"Answer a new <Rectangle> that is expanded from the receiver by the argument delta, where
	delta may be a <Rectangle>, a <Point>, or a <Number>."

	^delta _expandRectangle: self!

extent
	"Answer a Point representing the extent of the receiver. The x coordinate 
	is the width and the y coordinate is the height."

	^self width @ self height!

extent: newExtent
	"Set the extent of the receiver to aPoint. (The origin remains the same and the corner stays in the same quadrant it was in relative to the origin point. If aPoint contains any negative value, the result is undefined)."

	self
		width: newExtent x;
		height: newExtent y!

hash
	"Answer the <integer> hash value for the receiver such that for any two Rectangles which
	compare equivalent, they have the same hash value."

	^self topLeft hash bitXor: self bottomRight hash!

height
	"Answer the height of the receiver."

	^self bottom - self top!

height: aNumber
	"Change the receiver's height to aNumber. (The origin remains the same. If aNumber
	is negative, then the result is undefined)."

	self bottom: self top + aNumber!

insetBy: delta 
	"Answer a new <Rectangle> that is inset from the receiver by the argument, delta, where
	delta may be a <Rectangle>, a <Point>, or a <Number>."

	^delta _insetRectangle: self!

intersect: aRectangle
	"Answer a new <Rectangle> representing the area in which the receiver and argument overlap.
	If the receiver and aRectangle do not overlap then the result will have negative height
	and/or width."

	^self species origin: (self origin max: aRectangle origin)
		corner: (self corner min: aRectangle corner)!

intersects: aRectangle
	"Answer whether the receiver and argument overlap."

	| origin hisCorner |
	origin := self origin.
	hisCorner := aRectangle corner.
	^origin < hisCorner and: 
			[| hisOrigin corner |
			hisOrigin := aRectangle origin.
			corner := self corner.
			hisOrigin < corner and: [origin < corner and: [hisOrigin < hisCorner]]]!

left
	^self subclassResponsibility!

left: anObject
	self subclassResponsibility!

leftCenter
	"Answer a <Point> specifying the position of the centre of the receiver's left edge."

	^self left @ self centerY!

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

origin
	"Answer the Point at the top left corner of the receiver"

	^self topLeft
!

origin: aPoint 
	"Sets the position of the receiver's top left corner."

	self topLeft: aPoint!

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
	^self origin!

position: aPoint
	"Move the receiver so that its top-left corner is at the specified position."

	| ext |
	ext := self extent.
	self
		topLeft: aPoint;
		extent: ext!

right
	^self subclassResponsibility!

right: anObject
	self subclassResponsibility!

rightCenter
	"Answer a <Point> specifying the position of the centre of the receiver's right edge."

	^self right @ self centerY!

scaleBy: aMagnitude
	"Scale the receiver in-place by the specified <Point> or <Number> multiplier."

	self
		topLeft: self topLeft * aMagnitude;
		bottomRight: self bottomRight * aMagnitude!

scaledBy: anArithmeticValue
	"Answer a new <rectangle> representing the receiver with origin and corner multiplied by the <ArithmeticValue> argument. Uses the #vertex:vertex: constructor in order to create a normalised rectangle"

	^self species vertex: (self topLeft * anArithmeticValue) truncated
		vertex: (self bottomRight * anArithmeticValue) truncated!

scaleToDpi: desiredInteger from: currentInteger
	"Scale the receiver in-place by from the DPI represented by the first <integer> argument to that represented by the second integer argument."

	self scaleBy: desiredInteger / currentInteger!

species
	^Rectangle!

top
	^self subclassResponsibility!

top: aNumber
	"Set the position of the receiver's top edge to the <Number> argument."

	self subclassResponsibility!

topCenter
	"Answer a <Point> specifying the position of the centre of the receiver's top edge."

	^self centerX @ self top!

topLeft
	"Answer a Point representing the top left (origin) of the receiver."

	^self left @ self top!

topLeft: aPoint
	"Set the <Point> representing the top left position of the receiver."

	self
		left: aPoint x;
		top: aPoint y!

topRight
	"Answer a <Point> specifyihng the position of the receiver's top-right corner."

	^self right @ self top!

topRight: aPoint
	"Set the receiver's top-right corner to aPoint. (The bottom-left remains unchanged)."

	self
		top: aPoint y;
		right: aPoint x!

translatedBy: delta
	"Annswer a new <Rectangle> representing the receiver with origin and corner incremented by delta, where delta is an <ArithmeticValue>, or another <rectangle>."

	^delta _offsetRectangle: self!

truncated
	"Answer a <rectangle> whose origin and corner coordinates are the same as the receiver's, but truncated to the nearest <integer>."

	^self species origin: self topLeft truncated corner: self bottomRight truncated!

width
	"Answer the width of the receiver."

	^self right - self left!

width: aNumber
	"Change the receiver's width to aNumber. (The origin remains the same. If aNumber is negative, the result is undefined)"

	self right: self left + aNumber! !

!ExternalRectangle categoriesForMethods!
=!comparing!public! !
area!accessing!public! !
areasOutside:!accessing!public! !
asObject!converting!public! !
asRectangle!converting!public! !
bottom!accessing!public! !
bottom:!accessing!public! !
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
centerY!accessing!public! !
contains:!public!testing! !
containsPoint:!public!testing! !
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
intersect:!public!rectangle functions! !
intersects:!public!testing! !
left!accessing!public! !
left:!accessing!public! !
leftCenter!accessing!public! !
merge:!public!rectangle functions! !
moveBy:!public!transforming! !
moveTo:!public!transforming! !
origin!accessing!public! !
origin:!accessing!public! !
origin:corner:!accessing!public! !
origin:extent:!accessing!public! !
position!accessing!public! !
position:!accessing!public! !
right!accessing!public! !
right:!accessing!public! !
rightCenter!accessing!public! !
scaleBy:!public!transforming! !
scaledBy:!public! !
scaleToDpi:from:!public!transforming! !
species!comparing!public! !
top!accessing!public! !
top:!accessing!public! !
topCenter!accessing!public! !
topLeft!accessing!public! !
topLeft:!accessing!public! !
topRight!accessing!public! !
topRight:!accessing!public! !
translatedBy:!public!transforming! !
truncated!converting!public! !
width!accessing!public! !
width:!accessing!public! !
!

ExternalRectangle methodProtocol: #rectangle attributes: #() selectors: #(#area #areasOutside: #bottom #bottom: #bottomCenter #bottomCenter: #bottomLeft #bottomLeft: #bottomRight #bottomRight: #center #center: #contains: #containsPoint: #corner #corner: #expandedBy: #extent #extent: #height #height: #insetBy: #intersect: #intersects: #left #left: #leftCenter #merge: #moveBy: #moveTo: #origin #origin: #origin:corner: #origin:extent: #right #right: #rightCenter #scaledBy: #top #top: #topCenter #topLeft #topLeft: #topRight #topRight: #translatedBy: #truncated #width #width:)!

!ExternalRectangle class methodsFor!

center: centrePoint extent: extentPoint 
	"Answer an instance of the receiver of the extent, extentPoint, centred on centrePoint."

	^self origin: centrePoint - (extentPoint // 2) extent: extentPoint!

extent: aPoint
	^self origin: Point.Zero extent: aPoint!

fromRectangle: aRectangle
	"Answer a new instance of the receiver instantiated from the Smalltalk
	Rectangle, aRectangle."

	^self marshal: aRectangle!

icon
	"Answer a suitable iconic representation for the receiver."

	^Rectangle icon!

left: left top: top right: right bottom: bottom
	^self subclassResponsibility!

left: left top: top width: width height: height
	"Answer a new instance of the receiver with the specified position
	and dimensions."

	^self 
		left: left
		top: top
		right: left+width
		bottom: top+height
!

marshal: aRectangle
	"Answer the argument marshalled as an instance of the receiver."

	self == aRectangle class ifTrue: [^aRectangle].
	^self
		left: aRectangle left
		top: aRectangle top
		right: aRectangle right
		bottom: aRectangle bottom!

origin: originPoint corner: cornerPoint
	"Answer a new instance of the receiver with the specified origin and opposite corner"

	^self
		left: originPoint x
		top: originPoint y
		right: cornerPoint x
		bottom: cornerPoint y!

origin: originPoint extent: extentPoint
	"Answer a new instance of the receiver with the specified origin and extent"

	^self
		left: originPoint x
		top: originPoint y
		width: extentPoint x
		height: extentPoint y!

vertex: aPoint1 vertex: aPoint2 
	"Answer a new, normalised, instance of the receiver with the specified diagonally opposite
	vertices."

	^self origin: (aPoint1 min: aPoint2) corner: (aPoint1 max: aPoint2)! !

!ExternalRectangle class categoriesForMethods!
center:extent:!instance creation!public! !
extent:!instance creation!public! !
fromRectangle:!instance creation!public! !
icon!constants!public! !
left:top:right:bottom:!instance creation!public! !
left:top:width:height:!instance creation!public! !
marshal:!instance creation!public! !
origin:corner:!instance creation!public! !
origin:extent:!instance creation!public! !
vertex:vertex:!instance creation!public! !
!

ExternalRectangle class methodProtocol: #'rectangle factory' attributes: #(#readOnly) selectors: #(#center:extent: #extent: #left:top:right:bottom: #left:top:width:height: #new #origin:corner: #origin:extent: #vertex:vertex:)!

