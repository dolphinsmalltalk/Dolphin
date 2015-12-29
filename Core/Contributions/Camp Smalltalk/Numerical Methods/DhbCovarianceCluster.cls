"Filed out from Dolphin Smalltalk XP"!

DhbCluster subclass: #DhbCovarianceCluster
	instanceVariableNames: 'center'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbCovarianceCluster guid: (GUID fromString: '{E5500283-7D2B-11D6-B6CC-00022D5019C8}')!
DhbCovarianceCluster comment: ''!
!DhbCovarianceCluster categoriesForClass!DHB Numerical! !
!DhbCovarianceCluster methodsFor!

centerOn: aVector 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved. 
	Initial code: 2/16/00"

	accumulator := aVector isNil
				ifTrue: [nil]
				ifFalse: [DhbMahalanobisCenter onVector: aVector]!

collectAccumulatorResults
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator computeParameters.!

distanceTo: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^accumulator distanceTo: aVector!

isUndefined
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^accumulator isNil!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator printOn: aStream.! !
!DhbCovarianceCluster categoriesFor: #centerOn:!initialization!public! !
!DhbCovarianceCluster categoriesFor: #collectAccumulatorResults!public!transformation! !
!DhbCovarianceCluster categoriesFor: #distanceTo:!display!public! !
!DhbCovarianceCluster categoriesFor: #isUndefined!information!public! !
!DhbCovarianceCluster categoriesFor: #printOn:!display!public! !

