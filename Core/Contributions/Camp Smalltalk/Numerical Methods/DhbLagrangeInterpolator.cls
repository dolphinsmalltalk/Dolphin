"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbLagrangeInterpolator
	instanceVariableNames: 'pointCollection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLagrangeInterpolator guid: (GUID fromString: '{E55002AB-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLagrangeInterpolator comment: ''!
!DhbLagrangeInterpolator categoriesForClass!DHB Numerical! !
!DhbLagrangeInterpolator methodsFor!

add: aPoint
		"Add a point to the collection of points.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^pointCollection add: aPoint!

defaultSamplePoints
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	^OrderedCollection new!

initialize
		"Private - Create an empty point collection for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self initialize: self defaultSamplePoints!

initialize: aCollectionOfPoints
		"Private - Defines the collection of points for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	pointCollection := aCollectionOfPoints.
	^self!

size
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 3/12/00 "
	^pointCollection size!

value: aNumber
		"Compute the value of the Lagrange interpolation polynomial on the receiver's points at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| norm dx products answer size |
	norm := 1.
	size := pointCollection size.
	products := Array new: size.
	products atAllPut: 1.
	1 to: size
		do: [ :n |
			  dx := aNumber - ( self xPointAt: n).
			  dx = 0
				ifTrue: [ ^( self yPointAt: n)].
			  norm := norm * dx.
			  1 to: size
				do: [ :m |
					  m = n
						ifFalse:[ products at: m put: ( (( self xPointAt: m) - ( self xPointAt: n)) * ( products at: m))].
					].
			].
	answer := 0.
	1 to: size do:
		[ :n | answer := ( self yPointAt: n) / ( ( products at: n) * ( aNumber - ( self xPointAt: n))) + answer].
	^norm * answer!

xPointAt: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^( pointCollection at: anInteger) x!

yPointAt: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 19/4/99 "
	^( pointCollection at: anInteger) y! !
!DhbLagrangeInterpolator categoriesFor: #add:!public!transformation! !
!DhbLagrangeInterpolator categoriesFor: #defaultSamplePoints!information!public! !
!DhbLagrangeInterpolator categoriesFor: #initialize!initialization!public! !
!DhbLagrangeInterpolator categoriesFor: #initialize:!initialization!public! !
!DhbLagrangeInterpolator categoriesFor: #size!information!public! !
!DhbLagrangeInterpolator categoriesFor: #value:!information!public! !
!DhbLagrangeInterpolator categoriesFor: #xPointAt:!information!public! !
!DhbLagrangeInterpolator categoriesFor: #yPointAt:!information!public! !

!DhbLagrangeInterpolator class methodsFor!

new
		"Create a new instance of the receiver without points. Points must be added with add:
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^super new initialize!

points: aCollectionOfPoints
		"Create a new instance of the receiver with given points.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	^self new initialize: aCollectionOfPoints! !
!DhbLagrangeInterpolator class categoriesFor: #new!creation!public! !
!DhbLagrangeInterpolator class categoriesFor: #points:!creation!public! !

