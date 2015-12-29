"Filed out from Dolphin Smalltalk XP"!

DhbNevilleInterpolator subclass: #DhbBulirschStoerInterpolator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbBulirschStoerInterpolator guid: (GUID fromString: '{E55002AF-7D2B-11D6-B6CC-00022D5019C8}')!
DhbBulirschStoerInterpolator comment: ''!
!DhbBulirschStoerInterpolator categoriesForClass!DHB Numerical! !
!DhbBulirschStoerInterpolator methodsFor!

computeDifference: aNumber at: anInteger1 order: anInteger2
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 28/5/99 "
	| diff ratio |
	ratio := ( ( self xPointAt: anInteger1) - aNumber) * ( rightErrors at: anInteger1)
							/ ( (  self xPointAt: ( anInteger1 + anInteger2)) - aNumber).
	diff := ( ( leftErrors at: ( anInteger1 + 1)) - ( rightErrors at: anInteger1))
							/ ( ratio - ( leftErrors at: ( anInteger1 + 1))).
	rightErrors at: anInteger1 put: ( leftErrors at: ( anInteger1 + 1)) * diff.	
	leftErrors at: anInteger1 put: ratio * diff.! !
!DhbBulirschStoerInterpolator categoriesFor: #computeDifference:at:order:!information!public! !

