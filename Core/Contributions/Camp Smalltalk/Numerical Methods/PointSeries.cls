"Filed out from Dolphin Smalltalk XP"!

Object subclass: #PointSeries
	instanceVariableNames: 'points'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointSeries guid: (GUID fromString: '{E550029C-7D2B-11D6-B6CC-00022D5019C8}')!
PointSeries comment: ''!
!PointSeries categoriesForClass!DHB Numerical! !
!PointSeries methodsFor!

add: anObject
	"Add a point to the receiver"
	self primitiveAdd: anObject.
	self changed: self changedSymbol.
	^anObject!

at: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^points at: anInteger!

changedSymbol
	"Answers the symbol of the event sent when the points of the receiver change"
	^#pointsChanged!

collectPoints: aBlock
	^points collect: aBlock!

do: aBlock
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	self pointsDo: aBlock.!

firstPoint
	"Answers the first point stored in the receiver"
	^self at: 1!

initialize
	"Create the point collection"
	points := SortedCollection sortBlock: self sortBlock.
	^self!

isEmpty
		"
		 (c) Copyrights Didier BESSET, 1998, all rights reserved.
		 Initial code: 28/9/98 "
	^points isEmpty!

notEmpty
	^points notEmpty!

pointCollection
		" Answer the collection of points.
		 (c) Copyrights Didier BESSET, 1998, all rights reserved.
		 Initial code: 28/9/98 "
	^self collectPoints: [ :each | each]!

pointsDo: aBlock
	points do: aBlock.!

primitiveAdd: aPoint
	"Private - Add a point to the receiver"
	points add: aPoint.!

primitiveRemove: aPoint
	"Private - Removes a point from the receiver"
	points remove: aPoint.!

remove: anObject
	"Add a point to the receiver"
	self primitiveRemove: anObject.
	self changed: self changedSymbol.
	^anObject!

size
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^points size!

sort
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	points := ( points asSortedCollection: self sortBlock) asOrderedCollection.!

sortBlock
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	^[ :a :b | a x < b x]! !
!PointSeries categoriesFor: #add:!public!public methods! !
!PointSeries categoriesFor: #at:!public!public methods! !
!PointSeries categoriesFor: #changedSymbol!public!public methods! !
!PointSeries categoriesFor: #collectPoints:!public!public methods! !
!PointSeries categoriesFor: #do:!public!public methods! !
!PointSeries categoriesFor: #firstPoint!public!public methods! !
!PointSeries categoriesFor: #initialize!public!public methods! !
!PointSeries categoriesFor: #isEmpty!public!public methods! !
!PointSeries categoriesFor: #notEmpty!public!public methods! !
!PointSeries categoriesFor: #pointCollection!public!public methods! !
!PointSeries categoriesFor: #pointsDo:!public!public methods! !
!PointSeries categoriesFor: #primitiveAdd:!privateMethods!public! !
!PointSeries categoriesFor: #primitiveRemove:!privateMethods!public! !
!PointSeries categoriesFor: #remove:!public!public methods! !
!PointSeries categoriesFor: #size!public!public methods! !
!PointSeries categoriesFor: #sort!public!public methods! !
!PointSeries categoriesFor: #sortBlock!privateMethods!public! !

!PointSeries class methodsFor!

new
	"Create a new instance and initialize it"
	^super new initialize! !
!PointSeries class categoriesFor: #new!creation!public! !

