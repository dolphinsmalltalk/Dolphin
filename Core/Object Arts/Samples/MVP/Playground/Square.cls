"Filed out from Dolphin Smalltalk X6"!

RegularPolygon subclass: #Square
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Square guid: (GUID fromString: '{87B4C682-026E-11D3-9FD7-00A0CC3E4A32}')!
Square comment: 'A Square is a particular type of <PlayShape> that may be added to a <Playground>. It is part of the Playground sample package used as a Smalltalk learning aid. See this package''s comment for more details.'!
!Square categoriesForClass!Samples! !
!Square methodsFor!

defaultColor
	"Answer a default background color for the receiver. 
	Let's make Squares red to start with."

	^Color red!

defaultPosition
	"Answer a default position for the centre of the receiver. This may be overidden
	by subclasses that wish to start off at another location"

	^200 @ 100! !
!Square categoriesFor: #defaultColor!constants!public! !
!Square categoriesFor: #defaultPosition!constants!public! !

