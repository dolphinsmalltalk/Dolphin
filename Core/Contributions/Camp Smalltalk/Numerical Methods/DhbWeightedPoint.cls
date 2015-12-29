"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbWeightedPoint
	instanceVariableNames: 'xValue yValue weight error'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbWeightedPoint guid: (GUID fromString: '{E5500266-7D2B-11D6-B6CC-00022D5019C8}')!
DhbWeightedPoint comment: ''!
!DhbWeightedPoint categoriesForClass!DHB Numerical! !
!DhbWeightedPoint methodsFor!

chi2ComparisonContribution: aWeightedPoint
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^(aWeightedPoint yValue - yValue) squared / ( 1 / aWeightedPoint weight + ( 1 / weight))!

chi2Contribution: aFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^(yValue - ( aFunction value: xValue)) squared * weight!

error
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	error isNil
		ifTrue: [ error := 1 / weight sqrt].
	^error!

initialize: aPoint error: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	error := aNumber.
	^self initialize: aPoint weight: 1 / aNumber squared!

initialize: aPoint weight: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	xValue := aPoint x.
	yValue := aPoint y.
	weight := aNumber.
	^self!

point
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^xValue @ yValue!

weight
	^weight!

xValue
	^xValue!

yValue
	^yValue! !
!DhbWeightedPoint categoriesFor: #chi2ComparisonContribution:!information!public! !
!DhbWeightedPoint categoriesFor: #chi2Contribution:!information!public! !
!DhbWeightedPoint categoriesFor: #error!accessing!public! !
!DhbWeightedPoint categoriesFor: #initialize:error:!initialization!public! !
!DhbWeightedPoint categoriesFor: #initialize:weight:!initialization!public! !
!DhbWeightedPoint categoriesFor: #point!accessing!public! !
!DhbWeightedPoint categoriesFor: #weight!accessing!public! !
!DhbWeightedPoint categoriesFor: #xValue!accessing!public! !
!DhbWeightedPoint categoriesFor: #yValue!accessing!public! !

!DhbWeightedPoint class methodsFor!

point: aPoint
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^self new initialize: aPoint weight: 1!

point: aNumber count: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^self point: aNumber @ anInteger
		weight: ( anInteger > 0 ifTrue: [ 1 / anInteger]
								ifFalse:[ 1])!

point: aPoint error: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^self new initialize: aPoint error: aNumber!

point: aPoint weight: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^self new initialize: aPoint weight: aNumber! !
!DhbWeightedPoint class categoriesFor: #point:!creation!public! !
!DhbWeightedPoint class categoriesFor: #point:count:!creation!public! !
!DhbWeightedPoint class categoriesFor: #point:error:!creation!public! !
!DhbWeightedPoint class categoriesFor: #point:weight:!creation!public! !

