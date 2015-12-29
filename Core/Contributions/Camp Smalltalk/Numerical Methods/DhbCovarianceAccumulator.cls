"Filed out from Dolphin Smalltalk XP"!

DhbVectorAccumulator subclass: #DhbCovarianceAccumulator
	instanceVariableNames: 'covariance'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbCovarianceAccumulator guid: (GUID fromString: '{E5500289-7D2B-11D6-B6CC-00022D5019C8}')!
DhbCovarianceAccumulator comment: ''!
!DhbCovarianceAccumulator categoriesForClass!DHB Numerical! !
!DhbCovarianceAccumulator methodsFor!

accumulate: anArray
		"Accumulate anArray into the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	| delta count1 r|
	count1 := count.
	delta := super accumulate: anArray.
	r := count1 / count.
	1 to: delta size
		do: [ :n |
			  1 to: n do:
				  [ :m |
					( covariance at: n) at: m put: ( count1 * ( delta at: n) * ( delta at: m) + ( r * ( ( covariance at: n) at: m))).
				  ].
			].!

covarianceMatrix
		"Answer a matrix containing the covariance of the accumulated data.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	| rows n |
	n := 0.
	rows := covariance collect:
				[ :row | n := n + 1. row, ( ( ( n + 1) to: covariance size) collect: [ :m | ( covariance at: m) at: n ])].
	^DhbSymmetricMatrix rows: rows!

initialize: anInteger
		"Private - Initialize the receiver to accumulate vectors of dimension anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	covariance := ( ( 1 to: anInteger) collect: [ :n | DhbVector new: n]) asVector.
	^super initialize: anInteger!

reset
		"Set all accumulators to zero.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	super reset.
	covariance do: [ :each | each atAllPut: 0].! !
!DhbCovarianceAccumulator categoriesFor: #accumulate:!public!transformation! !
!DhbCovarianceAccumulator categoriesFor: #covarianceMatrix!information!public! !
!DhbCovarianceAccumulator categoriesFor: #initialize:!initialization!public! !
!DhbCovarianceAccumulator categoriesFor: #reset!public!transformation! !

