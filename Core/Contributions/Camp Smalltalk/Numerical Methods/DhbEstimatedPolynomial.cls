"Filed out from Dolphin Smalltalk XP"!

DhbPolynomial subclass: #DhbEstimatedPolynomial
	instanceVariableNames: 'errorMatrix'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbEstimatedPolynomial guid: (GUID fromString: '{E5500285-7D2B-11D6-B6CC-00022D5019C8}')!
DhbEstimatedPolynomial comment: ''!
!DhbEstimatedPolynomial categoriesForClass!DHB Numerical! !
!DhbEstimatedPolynomial methodsFor!

error: aNumber
		"Compute the error on the value of the receiver for argument aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	| errorVector term nextTerm |
	nextTerm := 1.
	errorVector := ( coefficients collect: [ :each | term := nextTerm. nextTerm := aNumber * nextTerm. term]) asVector.
	^( errorVector * errorMatrix * errorVector) sqrt!

errorMatrix
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/5/99 "
	^errorMatrix!

errorMatrix: aMatrix
		"Defines the error matrix of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	errorMatrix := aMatrix.!

valueAndError: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 20/5/99 "
	^Array with: ( self value: aNumber) with: ( self error: aNumber)! !
!DhbEstimatedPolynomial categoriesFor: #error:!information!public! !
!DhbEstimatedPolynomial categoriesFor: #errorMatrix!information!public! !
!DhbEstimatedPolynomial categoriesFor: #errorMatrix:!initialization!public! !
!DhbEstimatedPolynomial categoriesFor: #valueAndError:!information!public! !

