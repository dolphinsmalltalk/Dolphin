"Filed out from Dolphin Smalltalk XP"!

DhbSeriesTermServer subclass: #DhbIncompleteBetaFractionTermServer
	instanceVariableNames: 'alpha1 alpha2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbIncompleteBetaFractionTermServer guid: (GUID fromString: '{E550029B-7D2B-11D6-B6CC-00022D5019C8}')!
DhbIncompleteBetaFractionTermServer comment: ''!
!DhbIncompleteBetaFractionTermServer categoriesForClass!DHB Numerical! !
!DhbIncompleteBetaFractionTermServer methodsFor!

initialTerm
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	^1!

setParameter: aNumber1 second: aNumber2 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	alpha1 := aNumber1.
	alpha2 := aNumber2!

termsAt: anInteger 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	| n n2 |
	n := anInteger // 2.
	n2 := 2 * n.
	^Array with: ( n2 < anInteger 
		ifTrue: 
			[x negated * (alpha1 + n) * (alpha1 + alpha2 + n) 
				/ ((alpha1 + n2) * (alpha1 + 1 + n2))]
		ifFalse: [x * n * (alpha2 - n) / ((alpha1 + n2) * (alpha1 - 1 + n2))])
			with: 1! !
!DhbIncompleteBetaFractionTermServer categoriesFor: #initialTerm!information!public! !
!DhbIncompleteBetaFractionTermServer categoriesFor: #setParameter:second:!initialization!public! !
!DhbIncompleteBetaFractionTermServer categoriesFor: #termsAt:!information!public! !

