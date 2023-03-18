"Filed out from Dolphin Smalltalk"!

UI.Examples.RegularPolygon
	subclass: #'UI.Examples.Circle'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.Circle guid: (Core.GUID fromString: '{87b4c681-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Examples.Circle comment: 'A Circle is a particular type of <PlayShape> that may be added to a <Playground>. It is part of the Playground sample package used as a Smalltalk learning aid. See this package''s comment for more details.'!
!UI.Examples.Circle categoriesForClass!Samples! !
!UI.Examples.Circle methodsFor!

defaultColor
	"Answer a default background color for the receiver. 
	Let's make Circles blue to start with."

	^Color blue!

defaultPosition
	"Answer a default position for the centre of the receiver. This may be overidden
	by subclasses that wish to start off at another location"

	^100 @ 200!

defaultSides
	"Answer a default number of sides for the receiver. 
	Circles effectively have many sides"

	^100! !
!UI.Examples.Circle categoriesForMethods!
defaultColor!constants!public! !
defaultPosition!constants!public! !
defaultSides!constants!public! !
!

