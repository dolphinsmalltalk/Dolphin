"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Examples.PlayShape'
	instanceVariableNames: 'playground'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.PlayShape guid: (Core.GUID fromString: '{87b4c4a8-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Examples.PlayShape isNonInstantiable: true!
UI.Examples.PlayShape comment: 'A PlayShape represent a basic shape that may be added to a <Playground> window and then manipulated with messages. It is part of the Playground sample package and can be used as a Smalltalk learning aid. See this package''s comment for more details.

PlayShape is an abstract class. That is, it does not contain sufficient information or implementation to stand on its own. Only subclasses of PlayShape (such as Square, Circle etc) should ever be created. PlayShape does provides a number of methods that implement basic operations that the subclasses can rely on but they are not, in themselves, complete. For example, the #drawOn: method cannot actually draw the final shape since it does not have enough information. If you accidentally try to create an instance of PlayShape and add it to a Playground then you will receive a walkback describing that "#drawOn: is the responsibility of a subclass". This indicates the abstract nature of the PlayShape class.

Instance Variables:
	playground	<Playground> or nil owning the shape.

'!
!UI.Examples.PlayShape categoriesForClass!Samples! !
!UI.Examples.PlayShape methodsFor!

delay
	"Delay for a short period after redrawing. This allows us to see some (very) limited
	animation when repeating operations"

	Processor sleep: 200
	!

drawOn: aCanvas
	"Private - Draws the receiver on aCanvas. The PlayShape class does not hold
	enough information to describe how a particular shape might be drawn successfully. 
	This method is therefore the responsibilty of a subclass which provides this additional
	behaviour. For this reason we signal a walkback that describes this method as being 
	the responsibility of a subclass."

	self subclassResponsibility!

playground: aPlayground
	"Private - Sets the Playground to which the receiver belongs. This information
	is used so that the receiver can ask it's playground to redraw whenever any 
	changes are made to it. 
	This method should only be called by a Playground when the receiver is added
	or removed. It is not intended to be called directly by a user modifying a shape.
	Hence it is marked as being private"

	playground := aPlayground!

redraw
	"Ask for the receiver to be redraw within it's current Playground.
	This is normally sent when any significant changes have been made
	to the receiver"

	playground invalidate; update.
	self delay! !
!UI.Examples.PlayShape categoriesForMethods!
delay!operations!public! !
drawOn:!drawing!private! !
playground:!accessing!private! !
redraw!operations!public! !
!

