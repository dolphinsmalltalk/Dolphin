"Filed out from Dolphin Smalltalk XP"!

DhbSeriesTermServer subclass: #DhbIncompleteGammaSeriesTermServer
	instanceVariableNames: 'alpha sum'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbIncompleteGammaSeriesTermServer guid: (GUID fromString: '{E5500271-7D2B-11D6-B6CC-00022D5019C8}')!
DhbIncompleteGammaSeriesTermServer comment: ''!
!DhbIncompleteGammaSeriesTermServer categoriesForClass!DHB Numerical! !
!DhbIncompleteGammaSeriesTermServer methodsFor!

initialTerm
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	lastTerm := 1 / alpha.
	sum := alpha.
	^lastTerm!

setParameter: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	alpha := aNumber asFloat!

termAt: anInteger
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	sum := sum + 1.
	lastTerm := lastTerm * x / sum.
	^lastTerm! !
!DhbIncompleteGammaSeriesTermServer categoriesFor: #initialTerm!information!public! !
!DhbIncompleteGammaSeriesTermServer categoriesFor: #setParameter:!initialization!public! !
!DhbIncompleteGammaSeriesTermServer categoriesFor: #termAt:!information!public! !

