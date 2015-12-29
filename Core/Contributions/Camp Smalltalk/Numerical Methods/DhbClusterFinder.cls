"Filed out from Dolphin Smalltalk XP"!

DhbIterativeProcess subclass: #DhbClusterFinder
	instanceVariableNames: 'dataServer dataSetSize minimumRelativeClusterSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbClusterFinder guid: (GUID fromString: '{E55002A5-7D2B-11D6-B6CC-00022D5019C8}')!
DhbClusterFinder comment: ''!
!DhbClusterFinder categoriesForClass!DHB Numerical! !
!DhbClusterFinder methodsFor!

accumulate: aVector
		"Private - Accumulate aVector into the nearest cluster.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	( result at: ( self indexOfNearestCluster: aVector)) accumulate: aVector.!

clusters: aCollectionOfClusters
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/18/00 "
	result := aCollectionOfClusters.!

collectChangesAndResetClusters
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "

	| hasEmptyClusters changes |
	changes := 0.
	hasEmptyClusters := false.
	result do: 
			[:each | 
			changes := each changes + changes.
			( each isInsignificantIn: self)
				ifTrue: 
					[each centerOn: nil.
					hasEmptyClusters := true]
				ifFalse: [each reset].
			].
	hasEmptyClusters 
		ifTrue: [result := result reject: [:each | each isUndefined]].
	^changes / 2!

dataServer: aClusterDataServer
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/18/00 "
	dataServer := aClusterDataServer.!

evaluateIteration
		"Perform an accumulation of the data from the server.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	dataServer reset.
	dataSetSize := 0.
	[ dataServer atEnd]
		whileFalse:[ self accumulate: dataServer next.
					 dataSetSize := dataSetSize + 1.
					].
	^self collectChangesAndResetClusters!

finalizeIterations
	"Close the data server.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "

	dataServer close!

indexOfNearestCluster: aVector
		"Private - Answers the index of the cluster nearest to aVector.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	| distance index |
	index := 1.
	distance := ( result at: 1) distanceTo: aVector.
	2 to: result size do:
		[ :n | | x |
		  x := ( result at: n) distanceTo: aVector.
		  x < distance
			ifTrue: [ distance := x.
					  index := n.
					].
		].
	^index!

initialize: anInteger server: aClusterDataServer type: aClusterClass
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self dataServer: aClusterDataServer.
	self clusters: ( (1 to: anInteger) collect: [ :n | aClusterClass new]).
	minimumRelativeClusterSize := 0.
	^self!

initializeIterations
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "

	dataServer open.
	result 
		do: [:each | each isUndefined ifTrue: [each centerOn: dataServer next]]!

minimumClusterSize
	^(minimumRelativeClusterSize * dataSetSize) rounded!

minimumRelativeClusterSize: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	minimumRelativeClusterSize := aNumber max: 0.!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	aStream nextPutAll: 'Iterations: '.
	iterations printOn: aStream.
	result do: [ :each | aStream cr. each printOn: aStream].! !
!DhbClusterFinder categoriesFor: #accumulate:!public!transformation! !
!DhbClusterFinder categoriesFor: #clusters:!information!public! !
!DhbClusterFinder categoriesFor: #collectChangesAndResetClusters!public!transformation! !
!DhbClusterFinder categoriesFor: #dataServer:!initialization!public! !
!DhbClusterFinder categoriesFor: #evaluateIteration!operation!public! !
!DhbClusterFinder categoriesFor: #finalizeIterations!operation!public! !
!DhbClusterFinder categoriesFor: #indexOfNearestCluster:!information!public! !
!DhbClusterFinder categoriesFor: #initialize:server:type:!information!public! !
!DhbClusterFinder categoriesFor: #initializeIterations!operation!public! !
!DhbClusterFinder categoriesFor: #minimumClusterSize!information!public! !
!DhbClusterFinder categoriesFor: #minimumRelativeClusterSize:!initialization!public! !
!DhbClusterFinder categoriesFor: #printOn:!display!public! !

!DhbClusterFinder class methodsFor!

new: anInteger server: aClusterDataServer type: aClusterClass
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	^super new initialize: anInteger server: aClusterDataServer type: aClusterClass! !
!DhbClusterFinder class categoriesFor: #new:server:type:!creation!public! !

