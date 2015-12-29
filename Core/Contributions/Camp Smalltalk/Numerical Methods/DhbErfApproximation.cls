"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbErfApproximation
	instanceVariableNames: 'constant series norm'
	classVariableNames: 'UniqueInstance'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbErfApproximation guid: (GUID fromString: '{E5500286-7D2B-11D6-B6CC-00022D5019C8}')!
DhbErfApproximation comment: ''!
!DhbErfApproximation categoriesForClass!DHB Numerical! !
!DhbErfApproximation methodsFor!

initialize
		"Private - Initialize constants needed to evaluate the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/1/99 "
	constant := 0.2316419.
	norm := 1 / ( Float pi * 2) sqrt.
	series := DhbPolynomial coefficients: #( 0.31938153 -0.356563782 1.781477937 -1.821255978 1.330274429).!

normal: aNumber
		"Computes the value of the Normal distribution for aNumber
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/1/99 "

	^[ ( aNumber squared * -0.5) exp * norm]
			on: Error do: [ :signal | signal return: 0]!

value: aNumber
		"Answer erf( aNumber) using an approximation from Abramovitz and Stegun, Handbook of Mathematical Functions.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/1/99 "
	| t |
	aNumber = 0
		ifTrue: [ ^0.5].
	aNumber > 0
		ifTrue: [ ^1- ( self value: aNumber negated)].
	aNumber < -20
		ifTrue: [ ^0].
	t := 1 / (1 - (constant * aNumber)).
	^( series value: t) * t * (self normal: aNumber)! !
!DhbErfApproximation categoriesFor: #initialize!initialization!public! !
!DhbErfApproximation categoriesFor: #normal:!information!public! !
!DhbErfApproximation categoriesFor: #value:!information!public! !

!DhbErfApproximation class methodsFor!

new
		"Answer a unique instance. Create it if it does not exist.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 5/1/99 "
	UniqueInstance isNil
		ifTrue: [ UniqueInstance := super new.
					 UniqueInstance initialize.
					].
	^UniqueInstance! !
!DhbErfApproximation class categoriesFor: #new!creation!public! !

