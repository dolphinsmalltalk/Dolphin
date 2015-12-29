"Filed out from Dolphin Smalltalk XP"!

DhbCluster subclass: #DhbEuclideanCluster
	instanceVariableNames: 'center'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbEuclideanCluster guid: (GUID fromString: '{E550029D-7D2B-11D6-B6CC-00022D5019C8}')!
DhbEuclideanCluster comment: ''!
!DhbEuclideanCluster categoriesForClass!DHB Numerical! !
!DhbEuclideanCluster methodsFor!

centerOn: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	center := aVector.
	accumulator := DhbVectorAccumulator new: aVector size.!

collectAccumulatorResults
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	center := accumulator average copy.!

distanceTo: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^( aVector - center) norm!

isUndefined
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^center isNil!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator count printOn: aStream.
	aStream nextPutAll: ': '.
	center printOn: aStream.! !
!DhbEuclideanCluster categoriesFor: #centerOn:!initialization!public! !
!DhbEuclideanCluster categoriesFor: #collectAccumulatorResults!public!transformation! !
!DhbEuclideanCluster categoriesFor: #distanceTo:!information!public! !
!DhbEuclideanCluster categoriesFor: #isUndefined!initialization!public! !
!DhbEuclideanCluster categoriesFor: #printOn:!display!public! !

