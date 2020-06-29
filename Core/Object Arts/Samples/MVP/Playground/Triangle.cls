"Filed out from Dolphin Smalltalk 7"!

RegularPolygon subclass: #Triangle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Triangle guid: (GUID fromString: '{87b4c683-026e-11d3-9fd7-00a0cc3e4a32}')!
Triangle comment: 'A Triangle is a particular type of <PlayShape> that may be added to a <Playground>. It is part of the Playground sample package used as a Smalltalk learning aid. See this package''s comment for more details.'!
!Triangle categoriesForClass!Samples! !
!Triangle methodsFor!

defaultColor
	"Answer a default background color for the receiver. 
	Let's make Trangles yellow to start with."

	^Color yellow!

defaultPosition
	"Answer a default position for the centre of the receiver."

	^200 @ 200!

defaultSides
	"Answer a default number of sides for the receiver.
	Triangles have 3 sides"

	^3! !
!Triangle categoriesFor: #defaultColor!constants!public! !
!Triangle categoriesFor: #defaultPosition!constants!public! !
!Triangle categoriesFor: #defaultSides!constants!public! !

