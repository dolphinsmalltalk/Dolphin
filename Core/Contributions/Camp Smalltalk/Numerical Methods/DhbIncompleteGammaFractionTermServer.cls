"Filed out from Dolphin Smalltalk XP"!

DhbSeriesTermServer subclass: #DhbIncompleteGammaFractionTermServer
	instanceVariableNames: 'alpha'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbIncompleteGammaFractionTermServer guid: (GUID fromString: '{E5500272-7D2B-11D6-B6CC-00022D5019C8}')!
DhbIncompleteGammaFractionTermServer comment: ''!
!DhbIncompleteGammaFractionTermServer categoriesForClass!DHB Numerical! !
!DhbIncompleteGammaFractionTermServer methodsFor!

initialTerm
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	lastTerm := x - alpha + 1.
	^lastTerm!

setParameter: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	alpha := aNumber asFloat!

termsAt: anInteger 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	lastTerm := lastTerm + 2.
	^Array with: (alpha - anInteger) * anInteger with: lastTerm! !
!DhbIncompleteGammaFractionTermServer categoriesFor: #initialTerm!information!public! !
!DhbIncompleteGammaFractionTermServer categoriesFor: #setParameter:!initialization!public! !
!DhbIncompleteGammaFractionTermServer categoriesFor: #termsAt:!information!public! !

