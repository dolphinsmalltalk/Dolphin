"Filed out from Dolphin Smalltalk XP"!

DhbLagrangeInterpolator subclass: #DhbNewtonInterpolator
	instanceVariableNames: 'coefficients'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbNewtonInterpolator guid: (GUID fromString: '{E55002AC-7D2B-11D6-B6CC-00022D5019C8}')!
DhbNewtonInterpolator comment: ''!
!DhbNewtonInterpolator categoriesForClass!DHB Numerical! !
!DhbNewtonInterpolator methodsFor!

add: aPoint
		"Add a point to the collection of points.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	self resetCoefficients.
	^super add: aPoint!

computeCoefficients
		"Private - Computes the coefficients for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| size k1 kn|
	size := pointCollection size.
	coefficients := ( 1 to: size) collect: [ :n | self yPointAt: n].
	1 to: (size - 1)
		do: [ :n |
			  size to: ( n + 1)  by: -1
				do: [ :k |
					  k1 := k - 1.
					  kn := k - n.
					  coefficients at: k put: ( (( coefficients at: k) - ( coefficients at: k1)) 
											/ ((self xPointAt: k) - (self xPointAt: kn))).
					].
			].!

resetCoefficients
		"Private - Reset the coefficients of the receiver to force a new computation.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	coefficients := nil.!

value: aNumber
		"Compute the value of the Lagrange interpolation polynomial on the receiver's points at aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| answer size |
	coefficients isNil
		ifTrue: [ self computeCoefficients].
	size := coefficients size.
	answer := coefficients at: size.
	(size - 1) to: 1 by: -1
		do: [ :n | answer := answer * ( aNumber - (self xPointAt:  n)) + ( coefficients at: n)].
	^answer! !
!DhbNewtonInterpolator categoriesFor: #add:!public!transformation! !
!DhbNewtonInterpolator categoriesFor: #computeCoefficients!information!public! !
!DhbNewtonInterpolator categoriesFor: #resetCoefficients!public!transformation! !
!DhbNewtonInterpolator categoriesFor: #value:!information!public! !

