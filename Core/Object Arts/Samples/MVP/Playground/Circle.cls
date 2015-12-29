"Filed out from Dolphin Smalltalk X6"!

RegularPolygon subclass: #Circle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Circle guid: (GUID fromString: '{87B4C681-026E-11D3-9FD7-00A0CC3E4A32}')!
Circle comment: 'A Circle is a particular type of <PlayShape> that may be added to a <Playground>. It is part of the Playground sample package used as a Smalltalk learning aid. See this package''s comment for more details.'!
!Circle categoriesForClass!Samples! !
!Circle methodsFor!

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
!Circle categoriesFor: #defaultColor!constants!public! !
!Circle categoriesFor: #defaultPosition!constants!public! !
!Circle categoriesFor: #defaultSides!constants!public! !

