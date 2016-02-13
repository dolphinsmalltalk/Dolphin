"Filed out from Dolphin Smalltalk 7"!

Object subclass: #PlimboleCell
	instanceVariableNames: 'location velocity plimbole'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
PlimboleCell guid: (GUID fromString: '{A9D9AE5C-52B6-43B7-9E6C-1BB39EF49F8A}')!
PlimboleCell comment: ''!
!PlimboleCell categoriesForClass!Kernel-Objects! !
!PlimboleCell methodsFor!

color
	^RGB fromHTMLSpec: (self palette at: self directionIndex + 1)!

direction
	^self velocity degrees truncated!

directionIndex
	^self directions keyAtEqualValue: self velocity ifAbsent: []!

directions
	^##((Dictionary new)
		at: 0 put: 0 @ -1;
		at: 1 put: 1 @ 0;
		at: 2 put: 0 @ 1;
		at: 3 put: -1 @ 0;
		yourself)!

drawOn: aCanvas inView: aView 
	| cellCenter cellExtent cellRect presenter text |
	presenter := aView presenter.
	cellExtent := presenter cellExtent.
	cellCenter := (self location * cellExtent + (cellExtent / 2)) rounded.
	cellRect := (Rectangle center: cellCenter extent: cellExtent) insetBy: 2 .
	aCanvas fillRectangle: cellRect color: self color.
!

location
	^location!

location: aPoint 
	location := aPoint!

palette
	^self parent palette!

parent
	^plimbole!

printOn: aStream 
	self basicPrintOn: aStream.
	aStream
		nextPut: $(;
		display: self direction;
		nextPut: $)!

reverse
	self velocity: self velocity negated!

rotate
	| dir newVelocity |
	dir := self direction.
	dir = 0 ifTrue: [newVelocity := 0 @ 1].
	dir = 90 ifTrue: [newVelocity := -1 @ 0].
	dir = 180 ifTrue: [newVelocity := 0 @ -1].
	dir = 270 ifTrue: [newVelocity := 1 @ 0].
	self velocity: newVelocity!

setLocation: aPoint direction: directionIndex plimbole: aPlimbole 
	location := aPoint.
	velocity := self directions at: directionIndex.
	plimbole := aPlimbole!

velocity
	^velocity!

velocity: aPoint 
	velocity := aPoint!

x
	^self location x!

y
	^self location y! !
!PlimboleCell categoriesFor: #color!accessing!public! !
!PlimboleCell categoriesFor: #direction!accessing!public! !
!PlimboleCell categoriesFor: #directionIndex!accessing!private! !
!PlimboleCell categoriesFor: #directions!constants!public! !
!PlimboleCell categoriesFor: #drawOn:inView:!drawing!private! !
!PlimboleCell categoriesFor: #location!accessing!public! !
!PlimboleCell categoriesFor: #location:!accessing!public! !
!PlimboleCell categoriesFor: #palette!accessing!public! !
!PlimboleCell categoriesFor: #parent!accessing!public! !
!PlimboleCell categoriesFor: #printOn:!printing!public! !
!PlimboleCell categoriesFor: #reverse!operations!public! !
!PlimboleCell categoriesFor: #rotate!operations!public! !
!PlimboleCell categoriesFor: #setLocation:direction:plimbole:!public! !
!PlimboleCell categoriesFor: #velocity!accessing!public! !
!PlimboleCell categoriesFor: #velocity:!accessing!public! !
!PlimboleCell categoriesFor: #x!accessing!public! !
!PlimboleCell categoriesFor: #y!accessing!public! !

!PlimboleCell class methodsFor!

location: aLocationPoint direction: directionIndex parent: aPlimbole 
	^(super new)
		setLocation: aLocationPoint
			direction: directionIndex
			plimbole: aPlimbole;
		yourself! !
!PlimboleCell class categoriesFor: #location:direction:parent:!instance creation!public! !

