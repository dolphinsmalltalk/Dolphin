"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'External.RECT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.RECT guid: (Core.GUID fromString: '{e552b3f7-8653-46d4-b764-1e59cf1c15f7}')!
External.RECT isNonInstantiable: true!
External.RECT comment: '`RECT` is the abstract class of structures representing rectangular geometries. There are concrete subclasses for different types of position and extent values.'!
!External.RECT categoriesForClass!Win32-Structs! !
!External.RECT methodsFor!

= anObject
	"Answer whether the receiver is considered equivalent to the argument	anObject."

	^self species == anObject species
		and: [self origin = anObject origin and: [self corner = anObject corner]]!

area
	"Answer the area of the receiver; the product of width and height."

	^self width * self height!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Rectangle>."

	^self asRectangle
!

asRectangle
	"Answer a new Rectangle that matches the receiver."

	^Graphics.Rectangle origin: self topLeft corner: self bottomRight!

bottom
	^self subclassResponsibility!

bottom: anObject
	self subclassResponsibility!

bottomRight
	"Answer a Point representing the bottom right position of the receiver."

	^self right @ self bottom!

center
	"Answer a <Point> representing the position of the centre of the receiver."

	^self centerX @ self centerY!

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

corner
	"Answer the Point at the bottom-right corner of the receiver"

	^self bottomRight
!

extent
	"Answer a Point representing the extent of the receiver. The x coordinate 
	is the width and the y coordinate is the height."

	^self width @ self height!

extent: newExtent
	"Set the extent of the receiver to aPoint. (The origin remains the same and
	the corner stays in the same quadrant it was in relative to the origin point.
	If aPoint contains any negative value, the result is undefined)."

	self
		width: newExtent x;
		height: newExtent y!

hash
	"Answer the <integer> hash value for the receiver such that for any two Rectangles which
	compare equivalent, they have the same hash value."

	^self origin hash bitXor: self corner hash!

height
	"Answer the height of the receiver."

	^self bottom - self top!

height: aNumber
	"Change the receiver's height to aNumber. (The origin remains the same. If aNumber is negative, then the result is undefined)."

	self bottom: self top + aNumber!

left
	^self subclassResponsibility!

left: anObject
	self subclassResponsibility!

origin
	"Answer the Point at the top left corner of the receiver"

	^self topLeft
!

right
	^self subclassResponsibility!

right: anObject
	self subclassResponsibility!

species
	^UI.Rectangle!

top
	^self subclassResponsibility!

top: anObject
	self subclassResponsibility!

topLeft
	"Answer a Point representing the top left position of the receiver."

	^self left @ self top!

width
	"Answer the width of the receiver."

	^self right - self left!

width: aNumber
	"Change the receiver's width to aNumber. (The origin remains the same. If aNumber is negative, the result is undefined)"

	self right: self left + aNumber! !
!External.RECT categoriesForMethods!
=!comparing!public! !
area!accessing!public! !
asObject!converting!public! !
asRectangle!converting!public! !
bottom!accessing!public! !
bottom:!accessing!public! !
bottomRight!accessing!public! !
center!accessing!public! !
centerRight!public! !
centerX!accessing!public! !
centerY!accessing!public! !
corner!accessing!public! !
extent!accessing!public! !
extent:!accessing!public! !
hash!comparing!public! !
height!accessing!public! !
height:!accessing!public! !
left!accessing!public! !
left:!accessing!public! !
origin!accessing!public! !
right!accessing!public! !
right:!accessing!public! !
species!comparing!public! !
top!accessing!public! !
top:!accessing!public! !
topLeft!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
!

!External.RECT class methodsFor!

extent: aPoint
	^self
		left: 0
		top: 0
		width: aPoint x
		height: aPoint y!

fromRectangle: aRectangle
	"Answer a new instance of the receiver instantiated from the Smalltalk
	Rectangle, aRectangle."

	self == aRectangle class ifTrue: [^aRectangle].
	^self 
		left: aRectangle left
		top: aRectangle top
		right: aRectangle right
		bottom: aRectangle bottom
!

icon
	"Answer a suitable iconic representation for the receiver."

	^Graphics.Rectangle icon!

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
		bottom: aRectangle bottom
!

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
		height: extentPoint y! !
!External.RECT class categoriesForMethods!
extent:!instance creation!public! !
fromRectangle:!instance creation!public! !
icon!constants!public! !
left:top:right:bottom:!instance creation!public! !
left:top:width:height:!instance creation!public! !
marshal:!instance creation!public! !
origin:corner:!instance creation!public! !
origin:extent:!instance creation!public! !
!

