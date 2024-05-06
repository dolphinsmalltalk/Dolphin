"Filed out from Dolphin Smalltalk"!

Object subclass: #Grid
	instanceVariableNames: 'resolution'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Grid guid: (GUID fromString: '{87b4c48e-026e-11d3-9fd7-00a0cc3e4a32}')!

Grid comment: ''!

!Grid categoriesForClass!MVP-Views-Support! !

!Grid methodsFor!

constrainPoint: aPoint
	"Answers the position for aPoint
	after any grid constraints have been taken into consideration."

	^(aPoint + (resolution//2)) // resolution * resolution!

constrainRectangle: aRectangle
	"Answers the constrained position/size of aRectangle."

	^(self constrainPoint: aRectangle origin) corner: (self constrainPoint: aRectangle corner)
!

resolution
	"Answers the number of pixels between adjacent points in the grid."

	^resolution!

resolution: anInteger
	"Sets the number of pixels between adjacent points in the grid to anInteger."

	resolution := anInteger! !

!Grid categoriesForMethods!
constrainPoint:!accessing!public! !
constrainRectangle:!accessing!public! !
resolution!accessing!public! !
resolution:!accessing!public! !
!

!Grid class methodsFor!

resolution: anInteger
	"Answers a new instance of the receiver with
	a resolution of anInteger."

	^self new
		resolution: anInteger;
		yourself! !

!Grid class categoriesForMethods!
resolution:!instance creation!public! !
!

