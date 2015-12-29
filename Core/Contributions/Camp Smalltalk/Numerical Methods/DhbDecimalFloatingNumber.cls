"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbDecimalFloatingNumber
	instanceVariableNames: 'mantissa exponent'
	classVariableNames: 'Digits'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbDecimalFloatingNumber guid: (GUID fromString: '{E550026B-7D2B-11D6-B6CC-00022D5019C8}')!
DhbDecimalFloatingNumber comment: ''!
!DhbDecimalFloatingNumber categoriesForClass!DHB Numerical! !
!DhbDecimalFloatingNumber methodsFor!

- aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new: ( self value - aNumber value)!

* aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new: ( self value * aNumber value)!

/ aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new: ( self value / aNumber value)!

+ aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new: ( self value + aNumber value)!

normalize: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	exponent := (self class digits - (aNumber log: 10)) floor.
	mantissa := ( aNumber * ( 10 raisedToInteger: exponent)) truncated.
	^self!

printOn: aStream
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	mantissa printOn: aStream.
	aStream nextPutAll: 'xE'.
	exponent negated printOn: aStream.!

sqrt
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self class new:  self value sqrt!

value
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^mantissa / ( 10 raisedToInteger: exponent)! !
!DhbDecimalFloatingNumber categoriesFor: #-!operation!public! !
!DhbDecimalFloatingNumber categoriesFor: #*!operation!public! !
!DhbDecimalFloatingNumber categoriesFor: #/!operation!public! !
!DhbDecimalFloatingNumber categoriesFor: #+!operation!public! !
!DhbDecimalFloatingNumber categoriesFor: #normalize:!public!transformation! !
!DhbDecimalFloatingNumber categoriesFor: #printOn:!display!public! !
!DhbDecimalFloatingNumber categoriesFor: #sqrt!operation!public! !
!DhbDecimalFloatingNumber categoriesFor: #value!information!public! !

!DhbDecimalFloatingNumber class methodsFor!

defaultDigits
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^15!

defaultDigits: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	Digits := anInteger.!

digits
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	Digits isNil
		ifTrue: [ Digits := self defaultDigits].
	^Digits!

new: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	^self new normalize: aNumber!

resetDigits
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/6/99 "
	Digits := nil.! !
!DhbDecimalFloatingNumber class categoriesFor: #defaultDigits!information!public! !
!DhbDecimalFloatingNumber class categoriesFor: #defaultDigits:!public!transformation! !
!DhbDecimalFloatingNumber class categoriesFor: #digits!information!public! !
!DhbDecimalFloatingNumber class categoriesFor: #new:!creation!public! !
!DhbDecimalFloatingNumber class categoriesFor: #resetDigits!public!transformation! !

