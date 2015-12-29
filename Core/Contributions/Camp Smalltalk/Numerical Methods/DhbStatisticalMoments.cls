"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbStatisticalMoments
	instanceVariableNames: 'moments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbStatisticalMoments guid: (GUID fromString: '{E5500267-7D2B-11D6-B6CC-00022D5019C8}')!
DhbStatisticalMoments comment: ''!
!DhbStatisticalMoments categoriesForClass!DHB Numerical! !
!DhbStatisticalMoments methodsFor!

accumulate: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	| correction n n1 oldSums pascal nTerm cTerm term |
	n := moments at: 1.
	n1 := n + 1.
	correction := ((moments at: 2) - aNumber) / n1.
	oldSums := moments copyFrom: 1 to: moments size.
	moments
		at: 1 put: n1;
		at: 2 put: (moments at: 2) - correction.
	pascal := Array new: moments size.
	pascal atAllPut: 0.
	pascal
		at: 1 put: 1;
		at: 2 put: 1.
	nTerm := -1.
	cTerm := correction.
	n1 := n / n1.
	n := n negated.
	3 to: moments size
		do: 
			[:k | 
			cTerm := cTerm * correction.
			nTerm := n * nTerm.
			term := cTerm * (1 + nTerm).
			k to: 3
				by: -1
				do: 
					[:l | 
					pascal at: l put: (pascal at: l - 1) + (pascal at: l).
					term := (pascal at: l) * (oldSums at: l) + term.
					oldSums at: l put: (oldSums at: l) * correction].
			pascal at: 2 put: (pascal at: 1) + (pascal at: 2).
			moments at: k put: term * n1]!

asWeightedPoint: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/5/00 "
	^DhbWeightedPoint point: aNumber @ self average error: self errorOnAverage!

average
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	self count = 0 ifTrue: [^nil].
	^moments at: 2!

centralMoment: anInteger 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/6/99 "

	^moments at: anInteger + 1!

count
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/6/99 "

	^moments at: 1!

errorOnAverage
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 02-Jan-00 "
	^( self variance / self count) sqrt!

fConfidenceLevel: aStatisticalMomentsOrHistogram 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	| fValue |
	fValue := self variance/ aStatisticalMomentsOrHistogram variance.
	^fValue < 1
		ifTrue: [ (DhbFisherSnedecorDistribution degreeOfFreedom: aStatisticalMomentsOrHistogram count
						degreeOfFreedom: self count) 
										confidenceLevel: fValue reciprocal]
		ifFalse:[ (DhbFisherSnedecorDistribution degreeOfFreedom: self count
						degreeOfFreedom: aStatisticalMomentsOrHistogram count) 
										confidenceLevel: fValue]!

initialize: anInteger 
	"Private - ( anInteger - 1) is the degree of the highest accumulated central moment.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	moments := Array new: anInteger.
	self reset.
	^self!

kurtosis
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	| n n1 n23 |
	n := self count.
	n < 4 ifTrue: [^nil].
	n23 := (n - 2) * (n - 3).
	n1 := n - 1.
	^((moments at: 5) * n squared * (n + 1) / (self variance squared * n1) 
		- (n1 squared * 3)) / n23!

reset
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	moments atAllPut: 0!

skewness
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "

	| n v |
	n := self count.
	n < 3 ifTrue: [^nil].
	v := self variance.
	^(moments at: 4) * n squared / ((n - 1) * (n - 2) * (v sqrt * v))!

standardDeviation
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "
	^self variance sqrt!

tConfidenceLevel: aStatisticalMomentsOrHistogram
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	| sbar dof |
	dof := self count + aStatisticalMomentsOrHistogram count - 2.
	sbar := ( ( self unnormalizedVariance + aStatisticalMomentsOrHistogram unnormalizedVariance) / dof) sqrt.
	^( DhbStudentDistribution degreeOfFreedom: dof)
		confidenceLevel: ( self average - (aStatisticalMomentsOrHistogram average))
							/ ( ( 1 / self count + ( 1 / aStatisticalMomentsOrHistogram count)) sqrt * sbar)!

unnormalizedVariance
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "
	^( self centralMoment: 2) * self count!

variance
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "
	| n |
	n := self count.
	n < 2
		ifTrue: [ ^nil].
	^self unnormalizedVariance / ( n - 1)! !
!DhbStatisticalMoments categoriesFor: #accumulate:!public!transformation! !
!DhbStatisticalMoments categoriesFor: #asWeightedPoint:!creation!public! !
!DhbStatisticalMoments categoriesFor: #average!information!public! !
!DhbStatisticalMoments categoriesFor: #centralMoment:!information!public! !
!DhbStatisticalMoments categoriesFor: #count!information!public! !
!DhbStatisticalMoments categoriesFor: #errorOnAverage!information!public! !
!DhbStatisticalMoments categoriesFor: #fConfidenceLevel:!public!testing! !
!DhbStatisticalMoments categoriesFor: #initialize:!initialization!public! !
!DhbStatisticalMoments categoriesFor: #kurtosis!information!public! !
!DhbStatisticalMoments categoriesFor: #reset!public!transformation! !
!DhbStatisticalMoments categoriesFor: #skewness!information!public! !
!DhbStatisticalMoments categoriesFor: #standardDeviation!information!public! !
!DhbStatisticalMoments categoriesFor: #tConfidenceLevel:!public!testing! !
!DhbStatisticalMoments categoriesFor: #unnormalizedVariance!information!public! !
!DhbStatisticalMoments categoriesFor: #variance!information!public! !

!DhbStatisticalMoments class methodsFor!

new
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "
	^self new: 4!

new: anInteger
		"anInteger is the degree of the highest central moments
		 accumulated within the created instance.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 10/5/99 "
	^super new initialize: anInteger + 1! !
!DhbStatisticalMoments class categoriesFor: #new!creation!public! !
!DhbStatisticalMoments class categoriesFor: #new:!creation!public! !

