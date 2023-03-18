"Filed out from Dolphin Smalltalk"!

UI.Examples.PlayShape
	subclass: #'UI.Examples.RegularPolygon'
	instanceVariableNames: 'color sides position rotation radius'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.RegularPolygon guid: (Core.GUID fromString: '{87b4c680-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Examples.RegularPolygon comment: 'A RegularPolygon describes a particular type of <PlayShape> that may be added to a <Playground>. It is part of the Playground sample package used as a Smalltalk learning aid. See this package''s comment for more details.

A RegularPolygon has a number of sides and is drawn within a bounding circle of a given radius and centre position. The polygon, when drawn, is filled with a particular background color. This information is held in the instance variables of a RegularPolygon instance.

Instance Variables:
	color		<color> used to fill the polygon.
	sides		<integer> number of sides.
	position		<Point> position of the polygon centre within the playground.
	rotation		<number> of degrees by which the polygon is rotated.
	radius		<number> of pixels radius to the boundary of the polygon.

'!
!UI.Examples.RegularPolygon categoriesForClass!Samples! !
!UI.Examples.RegularPolygon methodsFor!

chooseColor
	"Open a color picking dialog on the receiver to allow the color to be changed"

	ColorDialog showModalOn: (self aspectValue: #color)

	!

color
	"Answer the color of the receiver."

	^color
!

color: aColor
	"Set the color of the receiver to aColor and ask for it to be redrawn."

	color := aColor.
	self redraw.!

defaultColor
	"Answer a default background color for the receiver. This may be overidden
	by subclasses that wish to start off with a different color."

	^Color white!

defaultPosition
	"Answer a default position for the centre of the receiver. This may be overidden
	by subclasses that wish to start off at another location"

	^100 @ 100!

defaultRadius
	"Answer a default radius for the receiver. This may be overidden
	by subclasses that wish to start off at another size"

	^50!

defaultRotation
	"Answer a default rotation in degrees for the receiver. This may be overidden
	by subclasses that wish to start off at another angle"

	^0!

defaultSides
	"Answer a default number of sides for the receiver. This may be overidden
	by subclasses that wish to start off with a different number of sides."

	^4!

drawOn: aCanvas 
	"Private - Draws the receiver on aCanvas. We use some simple trigonometry
	to calculate the vertex points of the polygon. We can then ask the canvas
	#polygon: method to plot these points."

	| angleOrigin angleIncrement vertices |
	angleOrigin := self rotation degreesToRadians.	"Convert from degrees"
	angleIncrement := (360 / self sides) degreesToRadians.	"The incremental angle between each corner"
	vertices := Array new: self sides.
	1 to: self sides
		do: 
			[:n | 
			| angle pt |
			angle := angleOrigin + (angleIncrement * (n - 1)).
			pt := angle cos @ angle sin * self radius.
			vertices at: n put: (pt + self position) rounded].

	"Draw the polygon"
	aCanvas
		brush: self color brush;
		polygon: vertices!

growBy: aNumberOfUnits
	"Grow the receiver by aNumberOfUnits and cause it to be redrawn"

	self radius: self radius+aNumberOfUnits!

initialize
	"Private - Initialize the receiver to a suitable default state.
	This method is called only during instance creation and is 
	therefore marked as private."

	radius := self defaultRadius.
	position := self defaultPosition.
	rotation := self defaultRotation.
	color := self defaultColor.
	sides := self defaultSides.
!

moveBy: aPoint
	"Move the receiver by aPoint and cause it to be redrawn"

	self position: self position+aPoint!

moveDown: anInteger
	"Move the receiver down by anInteger number of units and cause it to be redrawn"

	self moveBy: 0 @ anInteger!

moveLeft: anInteger
	"Move the receiver left by anInteger number of units and cause it to be redrawn"

	self moveRight: anInteger negated!

moveRight: anInteger
	"Move the receiver right by anInteger number of units and cause it to be redrawn"

	self moveBy: anInteger @ 0.!

moveUp: anInteger
	"Move the receiver up by anInteger number of units and cause it to be redrawn"

	self moveDown: anInteger negated!

position
	"Answer the position of the centre of the receiver."

	^position!

position: aPoint
	"Set the position of the receiver's centres to aPoint
	and ask for it to be redrawn."

	position := aPoint.
	self redraw.!

radius
	"Answer the radius of the receiver's bounding circle."

	^radius!

radius: aNumberOfUnits
	"Set the radius of the receiver's bounding circle to aNumberOfUnits
	and ask for it to be redrawn. This method rounds the number to an
	integer value and checks to ensure that the radius does not become negative"

	aNumberOfUnits <= 0 ifTrue: [
		self error: 'can''t have a negative radius' ].

	radius := aNumberOfUnits rounded.
	self redraw.!

rotateBy: aNumberOfDegrees
	"Rotate the receiver by aNumberOfDegrees and cause it to be redrawn"

	self rotation: (self rotation+aNumberOfDegrees) \\ 360!

rotation
	"Answer the rotation of the receiver in degrees"

	^rotation!

rotation: aNumberOfDegrees
	"Set the rotation of the receiver to be aNumberOfDegrees
	and ask for it to be redrawn."

	rotation := aNumberOfDegrees.
	self redraw.!

shrinkBy: aNumberOfUnits
	"Shrink the receiver by aNumberOfUnits and cause it to be redrawn"

	self growBy: aNumberOfUnits negated!

sides
	"Answer the number of sides that the receiver has. This is set when
	the receiver is created and should not be subsequently changed."

	^sides!

sides: anInteger
	"Set the number of sides of the receiver and cause it to be redrawn"

	sides := anInteger.
	self redraw.
! !
!UI.Examples.RegularPolygon categoriesForMethods!
chooseColor!operations!public! !
color!accessing!public! !
color:!accessing!public! !
defaultColor!constants!public! !
defaultPosition!constants!public! !
defaultRadius!constants!public! !
defaultRotation!constants!public! !
defaultSides!constants!public! !
drawOn:!drawing!private! !
growBy:!operations!public! !
initialize!initializing!private! !
moveBy:!operations!public! !
moveDown:!operations!public! !
moveLeft:!operations!public! !
moveRight:!operations!public! !
moveUp:!operations!public! !
position!accessing!public! !
position:!accessing!public! !
radius!accessing!public! !
radius:!accessing!public! !
rotateBy:!operations!public! !
rotation!accessing!public! !
rotation:!accessing!public! !
shrinkBy:!operations!public! !
sides!accessing!initializing!public! !
sides:!accessing!public! !
!

!UI.Examples.RegularPolygon class methodsFor!

new
	"Create an instance of the receiver with a default number of sides"
	
	^super new initialize! !
!UI.Examples.RegularPolygon class categoriesForMethods!
new!instance creation!public! !
!

