"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbLanczosFormula
	instanceVariableNames: 'coefficients sqrt2Pi'
	classVariableNames: 'UniqueInstance'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLanczosFormula guid: (GUID fromString: '{E55002B5-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLanczosFormula comment: ''!
!DhbLanczosFormula categoriesForClass!DHB Numerical! !
!DhbLanczosFormula methodsFor!

gamma: aNumber
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	^( self leadingFactor: aNumber) exp * ( self series: aNumber) * sqrt2Pi / aNumber!

initialize
		"Private - Initialize the coefficients of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	sqrt2Pi := ( Float pi * 2) sqrt.
	coefficients := #( 76.18009172947146 -86.50532032941677 24.01409824083091 -1.231739572450155 0.1208650973866179e-2 -0.5395239384953e-5).
	^self!

leadingFactor: aNumber
		"Private - Answers the log of the leading factor in Lanczos' formula.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	| temp |
	temp := aNumber + 5.5.
	^( temp ln * ( aNumber + 0.5) - temp)!

logGamma: aNumber
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	^( self leadingFactor: aNumber) + ( ( self series: aNumber) * sqrt2Pi / aNumber) ln!

series: aNumber
		"Private - Answer the value of the series of Lanczos' formula.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/3/99 "
	| term |
	term := aNumber.
	^coefficients inject: 1.000000000190015
						into: [ :sum :each | term := term + 1. each / term + sum]! !
!DhbLanczosFormula categoriesFor: #gamma:!information!public! !
!DhbLanczosFormula categoriesFor: #initialize!initialization!public! !
!DhbLanczosFormula categoriesFor: #leadingFactor:!information!public! !
!DhbLanczosFormula categoriesFor: #logGamma:!information!public! !
!DhbLanczosFormula categoriesFor: #series:!information!public! !

!DhbLanczosFormula class methodsFor!

new
		"Answer a unique instance. Create it if it does not exist.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/1/99 "
	UniqueInstance isNil
		ifTrue: [ UniqueInstance := super new.
					 UniqueInstance initialize.
					].
	^UniqueInstance! !
!DhbLanczosFormula class categoriesFor: #new!creation!public! !

