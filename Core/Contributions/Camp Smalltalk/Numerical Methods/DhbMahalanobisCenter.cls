"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbMahalanobisCenter
	instanceVariableNames: 'center inverseCovariance accumulator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbMahalanobisCenter guid: (GUID fromString: '{E5500269-7D2B-11D6-B6CC-00022D5019C8}')!
DhbMahalanobisCenter comment: ''!
!DhbMahalanobisCenter categoriesForClass!DHB Numerical! !
!DhbMahalanobisCenter methodsFor!

accumulate: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator accumulate: aVector.!

center: aVector
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator := DhbCovarianceAccumulator new: aVector size.
	center := aVector.
	inverseCovariance := DhbSymmetricMatrix identity: aVector size.
	^self!

computeParameters
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	center := accumulator average copy.
	inverseCovariance := accumulator covarianceMatrix inverse.!

count
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^accumulator count!

distanceTo: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	| delta |
	delta := aVector - center.
	^delta * inverseCovariance * delta!

initialize: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator := DhbCovarianceAccumulator new: anInteger.
	^self!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator count printOn: aStream.
	aStream nextPutAll: ': '.
	center printOn: aStream.!

reset
		"Leave center and inverse covariant matrix untouched
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator reset.! !
!DhbMahalanobisCenter categoriesFor: #accumulate:!public!transformation! !
!DhbMahalanobisCenter categoriesFor: #center:!initialization!public! !
!DhbMahalanobisCenter categoriesFor: #computeParameters!public!transformation! !
!DhbMahalanobisCenter categoriesFor: #count!information!public! !
!DhbMahalanobisCenter categoriesFor: #distanceTo:!information!public! !
!DhbMahalanobisCenter categoriesFor: #initialize:!initialization!public! !
!DhbMahalanobisCenter categoriesFor: #printOn:!display!public! !
!DhbMahalanobisCenter categoriesFor: #reset!public!transformation! !

!DhbMahalanobisCenter class methodsFor!

new: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self new initialize: anInteger!

onVector: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self new center: aVector! !
!DhbMahalanobisCenter class categoriesFor: #new:!creation!public! !
!DhbMahalanobisCenter class categoriesFor: #onVector:!creation!public! !

