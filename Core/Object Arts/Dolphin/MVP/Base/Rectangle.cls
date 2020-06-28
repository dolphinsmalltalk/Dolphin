"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Rectangle
	instanceVariableNames: 'origin corner'
	classVariableNames: 'Empty'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
		left: origin x
		top: origin y
		right: corner x
		bottom: corner y!

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

	self bottom: aPoint y.
	self center: aPoint x @ self centerY!

bottomLeft
	"Answer a <Point> representing the position of the receiver's bottom-left corner."

	^origin x @ corner y!

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

	^aRectangle origin >= origin and: [aRectangle corner <= corner]!

containsPoint: aPoint 
	"Answer whether the <Point> argument is contained by the receiver. Containment is defined by
	origin point <= aPoint (inclusive), and aPoint < corner point (non-inclusive)"

	^origin <= aPoint and: [aPoint < corner]!

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
	"Answer a new <Rectangle> that is expanded from the receiver by the argument delta, where
	delta may be a <Rectangle>, a <Point>, or a <Number>."

	^delta _expandRectangle: self!

expandedBy: delta 
	"Present for VisualWorks compatibility. Use #expandBy: in preference."

	^self expandBy: delta!

extent
	"Answer a <Point> representing the extent of the receiver. The x-coordinate is the width and
	the y-coordinate is the height."

	^self width @ self height!

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

	corner := corner x @ (origin y + aNumber)!

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

	^self species origin: (origin max: aRectangle origin) corner: (corner min: aRectangle corner)!

intersects: aRectangle 
	"Answer whether the receiver and argument overlap."

	^origin < aRectangle corner 
		and: [aRectangle origin < corner and: [origin < corner and: [aRectangle origin < aRectangle corner]]]!

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

	^self species origin: (origin min: aRectangle origin) corner: (corner max: aRectangle corner)!

moveBy: delta 
	"Move the receiver's origin and corner by the argument, delta, where delta can be a <Point>
	or a <Number>."

	"N.B. This is a transformation; the receiver itself is modified. You probably want to use
	#translatedBy: instead!!"

	origin := origin + delta.
	corner := corner + delta!

moveTo: aPoint 
	"Move the receiver so that its origin is at the specified <Point>."

	"N.B. This is a transformation; the receiver itself is modified."

	corner := corner + aPoint - origin.
	origin := aPoint!

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

	origin := originPoint.
	corner := cornerPoint!

origin: originPoint extent: extentPoint
	"Set the receiver's origin and extent."

	origin := originPoint.
	self extent: extentPoint.!

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
	"Answer a new <Rectangle> representing the receiver with origin and corner multiplied by
	delta, where delta is a Point or a Number. Use the #vertex:vertex: constructor in order to
	create a normalised rectangle"

	^self species vertex: origin * delta vertex: corner * delta!

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

	^self centerX @ origin y!

topCenter: aPoint 
	"Move the receiver's top edge so that it is centred on the specified <Point>."

	self top: aPoint y.
	self center: aPoint x @ self centerY!

topLeft
	"Answer the <Point> at the top-left corner of the receiver."

	^origin!

topLeft: aPoint 
	"Set the receiver's top-left corner to the <Point> argument. (The bottom right remains
	unchanged)."

	self origin: aPoint!

topRight
	"Answer a <Point> specifyihng the position of the receiver's top-right corner."

	^corner x @ origin y!

topRight: aPoint 
	"Set the receiver's top-right corner to aPoint. (The bottom-left remains unchanged)."

	origin y: aPoint y.
	corner x: aPoint x!

translateBy: delta 
	"Answer a new <Rectangle> representing the receiver with origin and corner incremented by
	delta, where delta is a <Point>, a <Number>, or another <Rectangle>. This is the message
	used in the IBM Red Book, but Smalltalk-80 uses #translatedBy: (which has the correct
	tense)."

	^self translatedBy: delta!

translatedBy: delta 
	"Annswer a new <Rectangle> representing the receiver with origin and corner incremented by
	delta, where delta is a <Point>, a <Number>, or another <Rectangle>."

	^delta _offsetRectangle: self!

truncated
	"Answer a new <Rectangle> whose origin and corner coordinates are the same as the
	receiver's, but truncated to the nearest <integer>."

	^self species origin: origin truncated corner: corner truncated!

width
	"Answer the width of the receiver."

	^corner x - origin x!

width: aNumber 
	"Change the receiver's width to aNumber. (The origin remains the same. If aNumber is
	negative, the result is undefined)"

	corner := (origin x + aNumber) @ corner y! !
!Rectangle categoriesFor: #_expandRectangle:!double dispatch!private! !
!Rectangle categoriesFor: #_insetRectangle:!double dispatch!private! !
!Rectangle categoriesFor: #_offsetRectangle:!double dispatch!private! !
!Rectangle categoriesFor: #=!comparing!public! !
!Rectangle categoriesFor: #area!accessing!public! !
!Rectangle categoriesFor: #areasOutside:!accessing!public! !
!Rectangle categoriesFor: #asParameter!converting!public! !
!Rectangle categoriesFor: #bottom!accessing!public! !
!Rectangle categoriesFor: #bottom:!accessing!public! !
!Rectangle categoriesFor: #bottomAlign!accessing!public! !
!Rectangle categoriesFor: #bottomAlign:!accessing!public! !
!Rectangle categoriesFor: #bottomCenter!accessing!public! !
!Rectangle categoriesFor: #bottomCenter:!accessing!public! !
!Rectangle categoriesFor: #bottomLeft!accessing!public! !
!Rectangle categoriesFor: #bottomLeft:!accessing!public! !
!Rectangle categoriesFor: #bottomRight!accessing!public! !
!Rectangle categoriesFor: #bottomRight:!accessing!public! !
!Rectangle categoriesFor: #center!accessing!public! !
!Rectangle categoriesFor: #center:!accessing!public! !
!Rectangle categoriesFor: #centerX!accessing!public! !
!Rectangle categoriesFor: #centerX:!accessing!public! !
!Rectangle categoriesFor: #centerY!accessing!public! !
!Rectangle categoriesFor: #centerY:!accessing!public! !
!Rectangle categoriesFor: #constrain:!public!rectangle functions! !
!Rectangle categoriesFor: #contains:!public!testing! !
!Rectangle categoriesFor: #containsPoint:!public!testing! !
!Rectangle categoriesFor: #copy!copying!public! !
!Rectangle categoriesFor: #corner!accessing!public! !
!Rectangle categoriesFor: #corner:!accessing!public! !
!Rectangle categoriesFor: #expandBy:!public!rectangle functions! !
!Rectangle categoriesFor: #expandedBy:!public!rectangle functions! !
!Rectangle categoriesFor: #extent!accessing!public! !
!Rectangle categoriesFor: #extent:!accessing!public! !
!Rectangle categoriesFor: #hash!comparing!public! !
!Rectangle categoriesFor: #height!accessing!public! !
!Rectangle categoriesFor: #height:!accessing!public! !
!Rectangle categoriesFor: #insetBy:!public!rectangle functions! !
!Rectangle categoriesFor: #insetCornerBy:!operations!public! !
!Rectangle categoriesFor: #insetOriginBy:!public!rectangle functions! !
!Rectangle categoriesFor: #insetOriginBy:cornerBy:!public!rectangle functions! !
!Rectangle categoriesFor: #intersect:!public!rectangle functions! !
!Rectangle categoriesFor: #intersects:!public!testing! !
!Rectangle categoriesFor: #left!accessing!public! !
!Rectangle categoriesFor: #left:!accessing!public! !
!Rectangle categoriesFor: #leftAlign!accessing!public! !
!Rectangle categoriesFor: #leftAlign:!accessing!public! !
!Rectangle categoriesFor: #leftCenter!accessing!public! !
!Rectangle categoriesFor: #leftCenter:!accessing!public! !
!Rectangle categoriesFor: #merge:!public!rectangle functions! !
!Rectangle categoriesFor: #moveBy:!public!transforming! !
!Rectangle categoriesFor: #moveTo:!public!transforming! !
!Rectangle categoriesFor: #normalize!public!rectangle functions! !
!Rectangle categoriesFor: #origin!accessing!public! !
!Rectangle categoriesFor: #origin:!accessing!public! !
!Rectangle categoriesFor: #origin:corner:!accessing!public! !
!Rectangle categoriesFor: #origin:extent:!accessing!public! !
!Rectangle categoriesFor: #position!accessing!public! !
!Rectangle categoriesFor: #position:!accessing!public! !
!Rectangle categoriesFor: #printOn:!printing!public! !
!Rectangle categoriesFor: #right!accessing!public! !
!Rectangle categoriesFor: #right:!accessing!public! !
!Rectangle categoriesFor: #rightAlign!accessing!public! !
!Rectangle categoriesFor: #rightAlign:!accessing!public! !
!Rectangle categoriesFor: #rightCenter!accessing!public! !
!Rectangle categoriesFor: #rightCenter:!accessing!public! !
!Rectangle categoriesFor: #rounded!public!truncation and round off! !
!Rectangle categoriesFor: #scaleBy:!public!transforming! !
!Rectangle categoriesFor: #subtract:!public!rectangle functions! !
!Rectangle categoriesFor: #top!accessing!public! !
!Rectangle categoriesFor: #top:!accessing!public! !
!Rectangle categoriesFor: #topAlign!accessing!public! !
!Rectangle categoriesFor: #topAlign:!accessing!public! !
!Rectangle categoriesFor: #topCenter!accessing!public! !
!Rectangle categoriesFor: #topCenter:!accessing!public! !
!Rectangle categoriesFor: #topLeft!accessing!public! !
!Rectangle categoriesFor: #topLeft:!accessing!public! !
!Rectangle categoriesFor: #topRight!accessing!public! !
!Rectangle categoriesFor: #topRight:!accessing!public! !
!Rectangle categoriesFor: #translateBy:!public!transforming! !
!Rectangle categoriesFor: #translatedBy:!public!transforming! !
!Rectangle categoriesFor: #truncated!converting!public! !
!Rectangle categoriesFor: #width!accessing!public! !
!Rectangle categoriesFor: #width:!accessing!public! !

Rectangle methodProtocol: #rectangle attributes: #(#readOnly) selectors: #(#area #areasOutside: #bottom #bottom: #bottomCenter #bottomCenter: #bottomLeft #bottomLeft: #bottomRight #bottomRight: #contains: #containsPoint: #corner #corner: #expandBy: #extent #extent: #height #height: #insetBy: #intersect: #intersects: #left #left: #leftCenter #merge: #moveBy: #moveTo: #origin #origin: #origin:corner: #origin:extent: #right #right: #rightCenter #scaleBy: #top #top: #topCenter #topLeft #topLeft: #topRight #topRight: #translateBy: #truncated #width #width:)!

!Rectangle class methodsFor!

center: centrePoint extent: extentPoint 
	"Answer an instance of the receiver of the extent, extentPoint, centred on centrePoint."

	^self origin: centrePoint - (extentPoint // 2) extent: extentPoint!

initialize
	self addClassConstant: 'Empty'
		value: (self new
				isImmutable: true;
				yourself)!

left: leftNumber top: topNumber right: rightNumber bottom: bottomNumber 
	"Answer an instance of the receiver with the specified coodinates."

	^self origin: leftNumber @ topNumber corner: rightNumber @ bottomNumber!

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
!Rectangle class categoriesFor: #center:extent:!instance creation!public! !
!Rectangle class categoriesFor: #initialize!class initialization!development!public! !
!Rectangle class categoriesFor: #left:top:right:bottom:!instance creation!public! !
!Rectangle class categoriesFor: #new!instance creation!public! !
!Rectangle class categoriesFor: #origin:corner:!instance creation!public! !
!Rectangle class categoriesFor: #origin:extent:!instance creation!public! !
!Rectangle class categoriesFor: #unitialize!class hierarchy-removing!public! !
!Rectangle class categoriesFor: #vertex:vertex:!instance creation!public! !

