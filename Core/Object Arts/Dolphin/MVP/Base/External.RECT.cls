"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'External.RECT'
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

	self right: self left + newExtent x.
	self bottom: self top + newExtent y!

height
	"Answer the height of the receiver."

	^self bottom - self top!

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

top
	^self subclassResponsibility!

top: anObject
	self subclassResponsibility!

topLeft
	"Answer a Point representing the top left position of the receiver."

	^self left @ self top!

width
	"Answer the width of the receiver."

	^self right - self left! !
!External.RECT categoriesFor: #area!accessing!public! !
!External.RECT categoriesFor: #asObject!converting!public! !
!External.RECT categoriesFor: #asRectangle!converting!public! !
!External.RECT categoriesFor: #bottom!accessing!public! !
!External.RECT categoriesFor: #bottom:!accessing!public! !
!External.RECT categoriesFor: #bottomRight!accessing!public! !
!External.RECT categoriesFor: #center!accessing!public! !
!External.RECT categoriesFor: #centerX!accessing!public! !
!External.RECT categoriesFor: #centerY!accessing!public! !
!External.RECT categoriesFor: #corner!accessing!public! !
!External.RECT categoriesFor: #extent!accessing!public! !
!External.RECT categoriesFor: #extent:!accessing!public! !
!External.RECT categoriesFor: #height!accessing!public! !
!External.RECT categoriesFor: #left!accessing!public! !
!External.RECT categoriesFor: #left:!accessing!public! !
!External.RECT categoriesFor: #origin!accessing!public! !
!External.RECT categoriesFor: #right!accessing!public! !
!External.RECT categoriesFor: #right:!accessing!public! !
!External.RECT categoriesFor: #top!accessing!public! !
!External.RECT categoriesFor: #top:!accessing!public! !
!External.RECT categoriesFor: #topLeft!accessing!public! !
!External.RECT categoriesFor: #width!accessing!public! !

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
!External.RECT class categoriesFor: #extent:!instance creation!public! !
!External.RECT class categoriesFor: #fromRectangle:!instance creation!public! !
!External.RECT class categoriesFor: #icon!constants!public! !
!External.RECT class categoriesFor: #left:top:right:bottom:!instance creation!public! !
!External.RECT class categoriesFor: #left:top:width:height:!instance creation!public! !
!External.RECT class categoriesFor: #origin:corner:!instance creation!public! !
!External.RECT class categoriesFor: #origin:extent:!instance creation!public! !

