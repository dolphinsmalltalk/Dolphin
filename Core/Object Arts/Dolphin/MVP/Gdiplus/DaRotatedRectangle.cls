"Filed out from Dolphin Smalltalk XP"!

Rectangle subclass: #DaRotatedRectangle
	instanceVariableNames: 'theta precision pPoints boundingBox imageRectangle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DaRotatedRectangle guid: (GUID fromString: '{7E39F0DC-90B1-4D3E-9949-2938D56DA83C}')!
DaRotatedRectangle comment: ''!
!DaRotatedRectangle categoriesForClass!Unclassified! !
!DaRotatedRectangle methodsFor!

boundingBox
	"answer a rectangle sized to contain the rotated rectangle"

	^boundingBox!

calcBoundingBox
	"answer a rectangle sized to contain the rotated rectangle"

	theta <= 90 
		ifTrue: 
			[boundingBox := (Rectangle origin: (pPoints at: 3) x @ (pPoints at: 1) y
						corner: (pPoints at: 2) x @ (pPoints at: 4) y) normalize].
	(theta > 90 and: [theta <= 180]) 
		ifTrue: 
			[boundingBox := (Rectangle origin: (pPoints at: 4) x @ (pPoints at: 2) y
						corner: (pPoints at: 1) x @ (pPoints at: 3) y) normalize].
	(theta > 180 and: [theta <= 270]) 
		ifTrue: 
			[boundingBox := (Rectangle origin: (pPoints at: 2) x @ (pPoints at: 4) y
						corner: (pPoints at: 3) x @ (pPoints at: 1) y) normalize].
	(theta > 270 and: [theta <= 360]) 
		ifTrue: 
			[boundingBox := (Rectangle origin: (pPoints at: 1) x @ (pPoints at: 2) y
						corner: (pPoints at: 4) x @ (pPoints at: 3) y) normalize]!

calcImageRectangle
	"answer the largest rectangle that includes actual
image bits.  I.E. with the rotation triangles removed"

	theta <= 90 
		ifTrue: 
			[imageRectangle := (Rectangle origin: (pPoints at: 1) x @ (pPoints at: 2) y
						corner: (pPoints at: 4) x @ (pPoints at: 3) y) normalize].
	(theta > 90 and: [theta <= 180]) 
		ifTrue: 
			[imageRectangle := (Rectangle origin: (pPoints at: 3) x @ (pPoints at: 1) y
						corner: (pPoints at: 2) x @ (pPoints at: 4) y) normalize].
	(theta > 180 and: [theta <= 270]) 
		ifTrue: 
			[imageRectangle := (Rectangle origin: (pPoints at: 4) x @ (pPoints at: 1) y
						corner: (pPoints at: 1) x @ (pPoints at: 2) y) normalize].
	(theta > 270 and: [theta <= 360]) 
		ifTrue: 
			[imageRectangle := (Rectangle origin: (pPoints at: 2) x @ (pPoints at: 4) y
						corner: (pPoints at: 3) x @ (pPoints at: 1) y) normalize]!

croppedImageRectangle
	"answer the largest rectangle that includes actual
image bits.  I.E. with the rotation triangles removed"

	^imageRectangle!

derivePoints: aRectangle around: oPoint
	"derive the index points of the rotated rectangle.  When the rectangle
	is created, the origin and extent are correct, but not the topRight and bottomLeft.
	These points are in the order of:
		topLeft
		topRight
		bottomLeft
		bottomRight
	relative to the rectangle that was rotated"

	pPoints := OrderedCollection new.
	pPoints
		add: (aRectangle topLeft 
					daRotateAround: oPoint
					by: theta
					roundedTo: precision);
		add: (aRectangle topRight 
					daRotateAround: oPoint
					by: theta
					roundedTo: precision);
		add: (aRectangle bottomLeft 
					daRotateAround: oPoint
					by: theta
					roundedTo: precision);
		add: (aRectangle bottomRight 
					daRotateAround: oPoint
					by: theta
					roundedTo: precision)!

height
	^(pPoints at: 3) y abs + (pPoints at: 2) y abs!

normalizePoints
	"make sure all the points in the rectangle are x positive and 
y positive points"

	| deltaX deltaY newPoints shiftX shiftY retPoints |
	deltaX := 0.
	deltaY := 0.
	newPoints := OrderedCollection new.
	retPoints := OrderedCollection new.
	pPoints do: 
			[:each | 
			(each x < 0 and: [each x abs > deltaX]) ifTrue: [deltaX := each x abs].
			(each y < 0 and: [each y abs > deltaY]) ifTrue: [deltaY := each y abs]].
	pPoints do: [:each | newPoints add: each + (deltaX @ deltaY)].
	shiftX := newPoints first x.
	shiftY := newPoints first y.
	newPoints do: 
			[:each | 
			shiftX := shiftX min: each x.
			shiftY := shiftY min: each y].
	newPoints do: [:each | retPoints add: each - (shiftX @ shiftY)].
	retPoints do: 
			[:eachPt | 
			eachPt x: eachPt x asInteger.
			eachPt y: eachPt y asInteger].
	pPoints := retPoints!

pointsAsParameter
	"Answer the topLeft, topRight and bottomLeft point
	as a parameter for passing to gdi function plgBlt"

	| ps |
	ps := StructureArray length: 3 elementClass: POINTL.
	(ps at: 1) x: (pPoints at: 1) x asInteger.
	(ps at: 1) y: (pPoints at: 1) y asInteger.
	(ps at: 2) x: (pPoints at: 2) x asInteger.
	(ps at: 2) y: (pPoints at: 2) y asInteger.
	(ps at: 3) x: (pPoints at: 3) x asInteger.
	(ps at: 3) y: (pPoints at: 3) y asInteger.
	^ps!

pPoints
	^pPoints!

pPoints: anObject
	pPoints := anObject!

precision
	^precision!

precision: anObject
	precision := anObject!

theta
	^theta!

theta: anObject
	theta := anObject!

width
	^(pPoints at: 1) x abs + (pPoints at: 4) x abs! !
!DaRotatedRectangle categoriesFor: #boundingBox!accessing!public! !
!DaRotatedRectangle categoriesFor: #calcBoundingBox!operations!public! !
!DaRotatedRectangle categoriesFor: #calcImageRectangle!operations!public! !
!DaRotatedRectangle categoriesFor: #croppedImageRectangle!accessing!public! !
!DaRotatedRectangle categoriesFor: #derivePoints:around:!operations!public! !
!DaRotatedRectangle categoriesFor: #height!accessing!public! !
!DaRotatedRectangle categoriesFor: #normalizePoints!operations!public! !
!DaRotatedRectangle categoriesFor: #pointsAsParameter!accessing!public! !
!DaRotatedRectangle categoriesFor: #pPoints!accessing!private! !
!DaRotatedRectangle categoriesFor: #pPoints:!accessing!private! !
!DaRotatedRectangle categoriesFor: #precision!accessing!private! !
!DaRotatedRectangle categoriesFor: #precision:!accessing!private! !
!DaRotatedRectangle categoriesFor: #theta!accessing!private! !
!DaRotatedRectangle categoriesFor: #theta:!accessing!private! !
!DaRotatedRectangle categoriesFor: #width!accessing!public! !

!DaRotatedRectangle class methodsFor!

fromRectangle: aRectangle around: oPoint by: fDegrees roundedTo: fPrecision
	| t |
	t := (self new origin: (aRectangle origin 
						daRotateAround: oPoint
						by: fDegrees
						roundedTo: fPrecision)
				corner: (aRectangle corner 
						daRotateAround: oPoint
						by: fDegrees
						roundedTo: fPrecision))
				precision: fPrecision;
				theta: fDegrees;
				derivePoints: aRectangle around: oPoint;
				normalizePoints.
	^(self new origin: (t pPoints at: 1) corner: (t pPoints at: 3))
		precision: fPrecision;
		theta: fDegrees;
		pPoints: t pPoints;
		calcBoundingBox;
		calcImageRectangle!

fromRectangle: aRectangle aroundCenter: fDegrees roundedTo: fPrecision
	^self 
		fromRectangle: aRectangle
		around: aRectangle center
		by: fDegrees
		roundedTo: fPrecision!

fromRectangle: aRectangle aroundOrigin: fDegrees roundedTo: fPrecision
	^self 
		fromRectangle: aRectangle
		around: 0 @ 0
		by: fDegrees
		roundedTo: fPrecision! !
!DaRotatedRectangle class categoriesFor: #fromRectangle:around:by:roundedTo:!instance creation!public! !
!DaRotatedRectangle class categoriesFor: #fromRectangle:aroundCenter:roundedTo:!instance creation!public! !
!DaRotatedRectangle class categoriesFor: #fromRectangle:aroundOrigin:roundedTo:!instance creation!public! !

