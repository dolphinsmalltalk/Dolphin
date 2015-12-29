"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbHistogram
	instanceVariableNames: 'minimum binWidth overflow underflow moments contents freeExtent cacheSize desiredNumberOfBins'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbHistogram guid: (GUID fromString: '{E5500262-7D2B-11D6-B6CC-00022D5019C8}')!
DhbHistogram comment: ''!
!DhbHistogram categoriesForClass!DHB Numerical! !
!DhbHistogram methodsFor!

accumulate: aNumber
		"Accumulate aNumber into the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	| bin |
	self isCached
		ifTrue: [ ^self accumulateInCache: aNumber].
	bin := self binIndex: aNumber.
	( bin between: 1 and: contents size)
		ifTrue: [ contents at: bin put: ( contents at: bin) + 1.
					 moments accumulate: aNumber.
				   ]
		ifFalse:[ self processOverflows: bin for: aNumber].!

accumulateInCache: aNumber
		"Private - Accumulate aNumber inside a cache
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	contents add: aNumber.
	contents size > cacheSize
		ifTrue: [ self flushCache].!

adjustDimensionUpTo: aNumber
		"Private - Compute an adequate bin width and adjust the minimum and number of bins accordingly.
		 aNumber is the maximum value to accumulate. The minimum value has already been assigned.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	| maximum |
	binWidth := self roundToScale: ( aNumber - minimum) / desiredNumberOfBins.
	minimum := ( minimum / binWidth) floor * binWidth.
	maximum := ( aNumber / binWidth) ceiling * binWidth.
	contents := Array new: ( ( maximum - minimum) / binWidth) ceiling.
	contents atAllPut: 0.!

average
		"Answer the average of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments average!

binIndex: aNumber
		"Answers the index of the bin corresponding to aNumber.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^( ( aNumber - minimum) / binWidth) floor + 1!

binWidth
		"Answer the bin width for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifTrue: [ self flushCache].
	^binWidth!

chi2Against: aScaledDistribution
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/30/00 "
	| chi2 |
	chi2 := 0.
	self pointsAndErrorsDo:
		[ :each | chi2 := ( each chi2Contribution: aScaledDistribution) + chi2].
	^chi2!

chi2ConfidenceLevelAgainst: aScaledDistribution
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/30/00 "
	^( DhbChiSquareDistribution degreeOfFreedom: ( contents size - aScaledDistribution parameters size))
			confidenceLevel: ( self chi2Against: aScaledDistribution)!

collectIntegralPoints: aBlock
		"Collects the points needed to display the receiver as an integral.
		 Needed to use polymorphic behavior when plotting the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/4/99 "
	| answer bin lastContents integral norm x |
	self isCached
		ifTrue: [ self flushCache].
	answer := OrderedCollection new: ( contents size * 2 + 1).
	bin := self minimum.
	answer add: ( aBlock value: bin @ 0).
	integral := self underflow.
	norm := self totalCount.
	contents do:
		[ :each |
		  integral := integral + each.
		  x := integral / norm.
		  answer add: ( aBlock value: bin @ x).
		  bin := bin + binWidth.
		  answer add: ( aBlock value: bin @ x).
		].
	answer add: ( aBlock value: bin @ 0).
	^answer asArray!

collectPoints: aBlock
		"Collects the points needed to display the receiver.
		 Needed to use polymorphic behavior when plotting the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	| answer bin lastContents |
	self isCached
		ifTrue: [ self flushCache].
	answer := OrderedCollection new: ( contents size * 2 + 1).
	bin := self minimum.
	answer add: ( aBlock value: bin @ 0).
	contents do:
		[ :each |
		  answer add: ( aBlock value: bin @ each).
		  bin := bin + binWidth.
		  answer add: ( aBlock value: bin @ each).
		].
	answer add: ( aBlock value: bin @ 0).
	^answer asArray!

count
		"Answer the count of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments count!

countAt: aNumber
		"Answer the count in the bin corresponding to aNumber or 0 if outside the limits.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	| n |
	n := self binIndex: aNumber.
	^( n between: 1 and: contents size)
			ifTrue: [ contents at: n]
			ifFalse:[ 0]!

countOverflows: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	anInteger > 0
		ifTrue: [ overflow := overflow + 1]
		ifFalse:[ underflow := underflow + 1].!

countsBetween: aNumber1 and: aNumber2
		"Computes the events located between aNumber1 and aNumber2.
		 NOTE: This method assumes the two numbers are within the limits
			   of the receiver and that the receiver is not cached.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	| n1 n2 answer |
	n1 := self binIndex: aNumber1.
	n2 := self binIndex: aNumber2.
	answer := ( contents at: n1) * ( ( binWidth * n1 + minimum) - aNumber1) / binWidth.
	n2 > contents size
		ifTrue: [ n2 := contents size + 1]
		ifFalse:[ answer := answer + ( ( contents at: n2) * ( aNumber2 - ( binWidth * ( n2 - 1) + self maximum)) / binWidth)].
	( n1 + 1) to: ( n2 - 1) do: [ :n | answer := answer + ( contents at: n)].
	^answer!

countsUpTo: aNumber
		"Computes the events located up to aNumber.
		 NOTE: This method assumes aNumber is within the limits
					 of the receiver and that the receiver is not cached.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	| n answer |
	n := self binIndex: aNumber.
	n > contents size
		ifTrue: [ ^self count].
	answer := ( contents at: n) * ( aNumber - ( binWidth * ( n - 1) + self minimum)) / binWidth.
	1 to: ( n - 1) do: [ :m | answer := answer + ( contents at: m)].
	^answer + underflow!

errorOnAverage
		"Answer the error on the average of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments errorOnAverage!

fConfidenceLevel: aStatisticalMomentsOrHistogram
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	^moments fConfidenceLevel: aStatisticalMomentsOrHistogram!

flushCache
	"Private - 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 15/2/99"

	| maximum values |
	minimum isNil ifTrue: [minimum := contents isEmpty
					ifTrue: [0]
					ifFalse: [contents first]].
	maximum := minimum.
	contents do: [:each | each < minimum
			ifTrue: [minimum := each]
			ifFalse: [each > maximum ifTrue: [maximum := each]]].
	maximum = minimum ifTrue: [maximum := minimum + desiredNumberOfBins].
	values := contents.
	self adjustDimensionUpTo: maximum.
	values do: [:each | self accumulate: each]!

freeExtent: aBoolean
		"Defines the range of the receiver to be freely adjustable.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	( underflow = 0 and: [ overflow = 0])
		ifFalse: [ self error: 'Histogram extent cannot be redefined'].
	freeExtent := aBoolean.!

growContents: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	anInteger > 0
		ifTrue: [ self growPositiveContents: anInteger]
		ifFalse:[ self growNegativeContents: anInteger].!

growNegativeContents: anInteger 
	"Private - 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 15/2/99"

	| n newSize newContents |
	n := 1 - anInteger.
	newSize := contents size + n.
	newContents := Array new: newSize.
	newContents at: 1 put: 1.
	2 to: n do: [:i | newContents at: i put: 0].
	newContents
		replaceElementsFrom: n + 1
		to: newSize
		withArray: contents
		startingAt: 1.
	contents := newContents.
	minimum := anInteger - 1 * binWidth + minimum!

growPositiveContents: anInteger 
	"Private - 
	(c) Copyrights Didier BESSET, 1999, all rights reserved. 
	Initial code: 15/2/99"

	| n newContents |
	n := contents size.
	newContents := Array new: anInteger.
	newContents
		replaceElementsFrom: 1
		to: n
		withArray: contents
		startingAt: 1.
	n + 1 to: anInteger - 1 do: [:i | newContents at: i put: 0].
	newContents at: anInteger put: 1.
	contents := newContents!

initialize
		"Private - initializes the receiver with standard settings.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	freeExtent := false.
	cacheSize := self class defaultCacheSize.
	desiredNumberOfBins := self class defaultNumberOfBins.
	contents := OrderedCollection new: cacheSize.
	moments := DhbFixedStatisticalMoments new.
	overflow := 0.
	underflow := 0.
	^self!

inverseDistributionValue: aNumber
		"Private - Compute the value which corresponds to a integrated count of aNumber.
		 NOTE: aNumber is assumed to be between 0 and 1.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 8/3/99 "
	| count x integral |
	count := self count * aNumber.
	x := self minimum.
	integral := 0.
	contents do:
		[ :each | | delta |
		  delta := count - integral.
		  each > delta
			ifTrue: [ ^self binWidth * delta / each + x].
		  integral := integral + each.
		  x := self binWidth + x.
		].
	^self maximum!

isCached
		"Private - Answer true if the content of the receiver is cached.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^binWidth isNil!

isEmpty
		"Always false. 
		 Needed to use polymorphic behavior when plotting the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	^false!

kurtosis
		"Answer the kurtosis of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments kurtosis!

lowBinLimitAt: anInteger
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 4/3/99 "
	^( anInteger - 1) * binWidth + minimum!

maximum
		"Answer the minimum for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifTrue: [ self flushCache].
	^contents size * binWidth + minimum!

maximumCount
		"Answer the maximum count of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/2/99 "
	self isCached
		ifTrue: [ self flushCache].
	^contents inject: ( contents isEmpty ifTrue: [ 1] ifFalse:[ contents at: 1])
					into: [ :max :each | max max: each]!

minimum
		"Answer the minimum for the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifTrue: [ self flushCache].
	^minimum!

overflow
		"Answer the overflow of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^overflow!

pointsAndErrorsDo: aBlock
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/3/99 "
	| x |
	x := self minimum - ( self binWidth / 2).
	contents do:
		[ :each |
		  x := x + self binWidth.
		  aBlock value: ( DhbWeightedPoint point: x count: each).
		].!

processOverflows: anInteger for: aNumber
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	freeExtent
		ifTrue: [ self growContents: anInteger.
					 moments accumulate: aNumber
				   ]
		ifFalse:[ self countOverflows: anInteger].!

roundToScale: aNumber
	"Private - Adjust aNumber of the lowest upper scale"
	| orderOfMagnitude norm scales rValue |
	orderOfMagnitude := ( aNumber log: 10) floor.
	scales := self class scales.
	aNumber isInteger
		ifTrue: [ orderOfMagnitude < 1
						ifTrue: [ orderOfMagnitude := 1].
					  orderOfMagnitude = 1
						ifTrue: [ scales := self class integerScales].
					  orderOfMagnitude = 2
						ifTrue: [ scales := self class semiIntegerScales].
				    ].
	norm := 10 raisedToInteger: orderOfMagnitude.
	rValue := aNumber / norm.
	^( scales detect: [ :each | rValue <= each]) * norm!

setDesiredNumberOfBins: anInteger
		"Defines the desired number of bins. It may be adjusted to a few units later on.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	anInteger > 0
		ifFalse:[ self error: 'Desired number of bins must be positive'].
	desiredNumberOfBins := anInteger.!

setRangeFrom: aNumber1 to: aNumber2 bins: anInteger
		"Defines the range of the receiver by specifying the minimum, maximum and number of bins.
		 Values are adjusted to correspond to a reasonable value for the bin width and the limits.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifFalse: [ self error: 'Histogram limits cannot be redefined'].
	minimum := aNumber1.
	self setDesiredNumberOfBins: anInteger;
		   adjustDimensionUpTo: aNumber2.!

setWidth: aNumber1 from: aNumber2 bins: anInteger
		"Defines the range of the receiver by specifying the minimum, bin width and number of bins.
		 Values are adjusted to correspond to a reasonable value for the bin width and the limits.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	self isCached
		ifFalse: [ self error: 'Histogram limits cannot be redefined'].
	minimum := aNumber2.
	self setDesiredNumberOfBins: anInteger;
		   adjustDimensionUpTo: ( aNumber1 * anInteger + aNumber2).!

skewness
		"Answer the skewness of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments skewness!

standardDeviation
		"Answer the standardDeviation of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments standardDeviation!

tConfidenceLevel: aStatisticalMomentsOrHistogram
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	^moments tConfidenceLevel: aStatisticalMomentsOrHistogram!

totalCount
		"Answer the count of the recevier, inclusing underflow and overflow
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments count + underflow + overflow!

underflow
		"Answer the underflow of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^underflow!

unnormalizedVariance
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	^moments unnormalizedVariance!

variance
		"Answer the variance of the recevier
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^moments variance! !
!DhbHistogram categoriesFor: #accumulate:!public!transformation! !
!DhbHistogram categoriesFor: #accumulateInCache:!public!transformation! !
!DhbHistogram categoriesFor: #adjustDimensionUpTo:!public!transformation! !
!DhbHistogram categoriesFor: #average!information!public! !
!DhbHistogram categoriesFor: #binIndex:!information!public! !
!DhbHistogram categoriesFor: #binWidth!information!public! !
!DhbHistogram categoriesFor: #chi2Against:!information!public! !
!DhbHistogram categoriesFor: #chi2ConfidenceLevelAgainst:!information!public! !
!DhbHistogram categoriesFor: #collectIntegralPoints:!information!public! !
!DhbHistogram categoriesFor: #collectPoints:!information!public! !
!DhbHistogram categoriesFor: #count!information!public! !
!DhbHistogram categoriesFor: #countAt:!information!public! !
!DhbHistogram categoriesFor: #countOverflows:!public!transformation! !
!DhbHistogram categoriesFor: #countsBetween:and:!information!public! !
!DhbHistogram categoriesFor: #countsUpTo:!information!public! !
!DhbHistogram categoriesFor: #errorOnAverage!information!public! !
!DhbHistogram categoriesFor: #fConfidenceLevel:!public!testing! !
!DhbHistogram categoriesFor: #flushCache!public!transformation! !
!DhbHistogram categoriesFor: #freeExtent:!initialization!public! !
!DhbHistogram categoriesFor: #growContents:!public!transformation! !
!DhbHistogram categoriesFor: #growNegativeContents:!public!transformation! !
!DhbHistogram categoriesFor: #growPositiveContents:!public!transformation! !
!DhbHistogram categoriesFor: #initialize!initialization!public! !
!DhbHistogram categoriesFor: #inverseDistributionValue:!information!public! !
!DhbHistogram categoriesFor: #isCached!information!public! !
!DhbHistogram categoriesFor: #isEmpty!information!public! !
!DhbHistogram categoriesFor: #kurtosis!information!public! !
!DhbHistogram categoriesFor: #lowBinLimitAt:!information!public! !
!DhbHistogram categoriesFor: #maximum!information!public! !
!DhbHistogram categoriesFor: #maximumCount!information!public! !
!DhbHistogram categoriesFor: #minimum!information!public! !
!DhbHistogram categoriesFor: #overflow!information!public! !
!DhbHistogram categoriesFor: #pointsAndErrorsDo:!iterators!public! !
!DhbHistogram categoriesFor: #processOverflows:for:!public!transformation! !
!DhbHistogram categoriesFor: #roundToScale:!information!public! !
!DhbHistogram categoriesFor: #setDesiredNumberOfBins:!initialization!public! !
!DhbHistogram categoriesFor: #setRangeFrom:to:bins:!initialization!public! !
!DhbHistogram categoriesFor: #setWidth:from:bins:!initialization!public! !
!DhbHistogram categoriesFor: #skewness!information!public! !
!DhbHistogram categoriesFor: #standardDeviation!information!public! !
!DhbHistogram categoriesFor: #tConfidenceLevel:!public!testing! !
!DhbHistogram categoriesFor: #totalCount!information!public! !
!DhbHistogram categoriesFor: #underflow!information!public! !
!DhbHistogram categoriesFor: #unnormalizedVariance!information!public! !
!DhbHistogram categoriesFor: #variance!information!public! !

!DhbHistogram class methodsFor!

defaultCacheSize
		"Private - Answer the default cache size.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^100!

defaultNumberOfBins
		"Private - Defines the default number of bins for instances of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 16/2/99 "
	^50!

integerScales
	"Private - Scales for strict integers"
	^#( 2 4 5 8 10)!

new
		"Create a standard new instance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/2/99 "
	^super new initialize!

scales
	"Private - Scales for any number"
	^#( 1.25 2 2.5 4 5 7.5 8 10)!

semiIntegerScales
	"Private - Scales for large integers"
	^#( 2 2.5 4 5 7.5 8 10)! !
!DhbHistogram class categoriesFor: #defaultCacheSize!information!public! !
!DhbHistogram class categoriesFor: #defaultNumberOfBins!information!public! !
!DhbHistogram class categoriesFor: #integerScales!information!public! !
!DhbHistogram class categoriesFor: #new!creation!public! !
!DhbHistogram class categoriesFor: #scales!information!public! !
!DhbHistogram class categoriesFor: #semiIntegerScales!information!public! !

