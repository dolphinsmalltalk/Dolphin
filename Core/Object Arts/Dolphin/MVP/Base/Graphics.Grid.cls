"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Graphics.Grid'
	instanceVariableNames: 'resolution'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Grid guid: (Core.GUID fromString: '{87b4c48e-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.Grid comment: ''!
!Graphics.Grid categoriesForClass!MVP-Views-Support! !
!Graphics.Grid methodsFor!

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
!Graphics.Grid categoriesFor: #constrainPoint:!accessing!public! !
!Graphics.Grid categoriesFor: #constrainRectangle:!accessing!public! !
!Graphics.Grid categoriesFor: #resolution!accessing!public! !
!Graphics.Grid categoriesFor: #resolution:!accessing!public! !

!Graphics.Grid class methodsFor!

resolution: anInteger
	"Answers a new instance of the receiver with
	a resolution of anInteger."

	^self new
		resolution: anInteger;
		yourself! !
!Graphics.Grid class categoriesFor: #resolution:!instance creation!public! !

