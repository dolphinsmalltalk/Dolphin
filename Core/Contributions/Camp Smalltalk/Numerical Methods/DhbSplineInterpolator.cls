"Filed out from Dolphin Smalltalk XP"!

DhbNewtonInterpolator subclass: #DhbSplineInterpolator
	instanceVariableNames: 'startPointDerivative endPointDerivative'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbSplineInterpolator guid: (GUID fromString: '{E55002AD-7D2B-11D6-B6CC-00022D5019C8}')!
DhbSplineInterpolator comment: ''!
!DhbSplineInterpolator categoriesForClass!DHB Numerical! !
!DhbSplineInterpolator methodsFor!

computeSecondDerivatives
	"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "

	| size u w s dx inv2dx |
	size := pointCollection size.
	coefficients := Array new: size.
	u := Array new: size - 1.
	startPointDerivative isNil 
		ifTrue: 
			[coefficients at: 1 put: 0.
			u at: 1 put: 0]
		ifFalse: 
			[coefficients at: 1 put: -1 / 2.
			s := 1 / (( self xPointAt: 2) x - ( self xPointAt: 1) x).
			u at: 1
				put: 3 * s 
						* (s * (( self yPointAt: size) - ( self yPointAt: size - 1)) 
								- startPointDerivative)].
	2 to: size - 1
		do: 
			[:n | 
			dx := (self xPointAt: n) - (self xPointAt: ( n - 1)).
			inv2dx := 1 / (( self xPointAt: n + 1) - (self xPointAt: n - 1)).
			s := dx * inv2dx.
			w := 1 / (s * (coefficients at: n - 1) + 2).
			coefficients at: n put: (s - 1) * w.
			u at: n
				put: (((( self yPointAt: n + 1) - ( self yPointAt: n)) 
						/ (( self xPointAt: n + 1) - ( self xPointAt: n)) 
							- ((( self yPointAt: n) - ( self yPointAt: n - 1)) / dx)) * 6 
						* inv2dx - ((u at: n - 1) * s)) 
						* w].
	endPointDerivative isNil 
		ifTrue: [coefficients at: size put: 0]
		ifFalse: 
			[w := 1 / 2.
			s := 1 / ((self xPointAt:  size) - (self xPointAt: ( size - 1))).
			u at: 1
				put: 3 * s * (endPointDerivative 
								- (s * (self yPointAt: size) - (self yPointAt: size - 1))).
			coefficients at: size
				put: s - (w * (u at: size - 1) / ((coefficients at: size - 1) * w + 1))].
	size - 1 to: 1
		by: -1
		do: 
			[:n | 
			coefficients at: n
				put: (coefficients at: n) * (coefficients at: n + 1) + (u at: n)]!

defaultSamplePoints
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/5/99 "
	^SortedCollection sortBlock: [ :a :b | a x < b x]!

endPointDerivative: aNumber
		"Defines the end point derivatives.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	endPointDerivative := aNumber.
	self resetCoefficients.!

resetEndPointDerivatives
		"Set the end point derivatives to undefined.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	self setEndPointDerivatives: ( Array new: 2).!

setEndPointDerivatives: anArray
		"Defines the end point derivatives.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	startPointDerivative := anArray at: 1.
	endPointDerivative := anArray at: 2.
	self resetCoefficients.!

startPointDerivative: aNumber
		"Defines the end point derivatives.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "
	startPointDerivative := aNumber.
	self resetCoefficients.!

value: aNumber 
	"Computes the value of a cubic spline interpolation over the points of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/4/99 "

	| n1 n2 n step a b |
	coefficients isNil ifTrue: [self computeSecondDerivatives].
	n2 := pointCollection size.
	n1 := 1.
	[n2 - n1 > 1] whileTrue: 
			[n := (n1 + n2) // 2.
			(self xPointAt:  n) > aNumber ifTrue: [n2 := n] ifFalse: [n1 := n]].
	step := (self xPointAt: n2) - (self xPointAt: n1).
	a := ((self xPointAt: n2) - aNumber) / step.
	b := (aNumber - (self xPointAt: n1)) / step.
	^a * (self yPointAt: n1) + (b * (self yPointAt: n2)) 
		+ ((a * (a squared - 1) * (coefficients at: n1) 
				+ (b * (b squared - 1) * (coefficients at: n2))) * step squared 
				/ 6)! !
!DhbSplineInterpolator categoriesFor: #computeSecondDerivatives!public!transformation! !
!DhbSplineInterpolator categoriesFor: #defaultSamplePoints!information!public! !
!DhbSplineInterpolator categoriesFor: #endPointDerivative:!initialization!public! !
!DhbSplineInterpolator categoriesFor: #resetEndPointDerivatives!information!public! !
!DhbSplineInterpolator categoriesFor: #setEndPointDerivatives:!information!public! !
!DhbSplineInterpolator categoriesFor: #startPointDerivative:!information!public! !
!DhbSplineInterpolator categoriesFor: #value:!information!public! !

