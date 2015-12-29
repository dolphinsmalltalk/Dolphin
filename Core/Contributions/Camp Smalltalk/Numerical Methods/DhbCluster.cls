"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbCluster
	instanceVariableNames: 'accumulator previousSampleSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbCluster guid: (GUID fromString: '{E5500282-7D2B-11D6-B6CC-00022D5019C8}')!
DhbCluster comment: ''!
!DhbCluster categoriesForClass!DHB Numerical! !
!DhbCluster methodsFor!

accumulate: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	accumulator accumulate: aVector.!

centerOn: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	self subclassResponsibility!

changes
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "

	^(self sampleSize - previousSampleSize) abs!

collectAccumulatorResults
	self subclassResponsibility!

distanceTo: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self subclassResponsibility!

initialize
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "

	previousSampleSize := 0.
	^self!

isInsignificantIn: aClusterFinder
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/17/00 "
	^self sampleSize <= aClusterFinder minimumClusterSize!

isUndefined
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self subclassResponsibility!

reset
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "

	previousSampleSize := self sampleSize.
	self collectAccumulatorResults.
	accumulator reset!

sampleSize
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^accumulator count! !
!DhbCluster categoriesFor: #accumulate:!public!transformation! !
!DhbCluster categoriesFor: #centerOn:!initialization!public! !
!DhbCluster categoriesFor: #changes!information!public! !
!DhbCluster categoriesFor: #collectAccumulatorResults!public!transformation! !
!DhbCluster categoriesFor: #distanceTo:!information!public! !
!DhbCluster categoriesFor: #initialize!initialization!public! !
!DhbCluster categoriesFor: #isInsignificantIn:!information!public! !
!DhbCluster categoriesFor: #isUndefined!information!public! !
!DhbCluster categoriesFor: #reset!public!transformation! !
!DhbCluster categoriesFor: #sampleSize!information!public! !

!DhbCluster class methodsFor!

new
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^super new initialize! !
!DhbCluster class categoriesFor: #new!creation!public! !

