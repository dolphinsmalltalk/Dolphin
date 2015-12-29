"Filed out from Dolphin Smalltalk XP"!

DhbStatisticalMoments subclass: #DhbFastStatisticalMoments
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbFastStatisticalMoments guid: (GUID fromString: '{E55002A7-7D2B-11D6-B6CC-00022D5019C8}')!
DhbFastStatisticalMoments comment: ''!
!DhbFastStatisticalMoments categoriesForClass!DHB Numerical! !
!DhbFastStatisticalMoments methodsFor!

accumulate: aNumber 
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| var |
	var := 1.
	1 to: moments size
		do: 
			[:n | 
			moments at: n put: (moments at: n) + var.
			var := var * aNumber]!

average
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	self count = 0 ifTrue: [^nil].
	^(moments at: 2) / self count!

kurtosis
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| var x1 x2 x3 x4 kFact kConst n m4 xSquared |
	n := self count.
	n < 4 ifTrue: [^nil].
	var := self variance.
	var = 0 ifTrue: [^nil].
	x1 := (moments at: 2) / n.
	x2 := (moments at: 3) / n.
	x3 := (moments at: 4) / n.
	x4 := (moments at: 5) / n.
	xSquared := x1 squared.
	m4 := x4 - (4 * x1 * x3) + (6 * x2 * xSquared) - (xSquared squared * 3).
	kFact := n * (n + 1) / (n - 1) / (n - 2) / (n - 3).
	kConst := 3 * (n - 1) * (n - 1) / (n - 2) / (n - 3).
	^kFact * (m4 * n / var squared) - kConst!

skewness
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| x1 x2 x3 n stdev |
	n := self count.
	n < 3 ifTrue: [^nil].
	stdev := self standardDeviation.
	stdev = 0 ifTrue: [^nil].
	x1 := (moments at: 2) / n.
	x2 := (moments at: 3) / n.
	x3 := (moments at: 4) / n.
	^(x3 - (3 * x1 * x2) + (2 * x1 * x1 * x1)) * n * n 
		/ (stdev squared * stdev * (n - 1) * (n - 2))!

unnormalizedVariance
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/22/00 "

	^(moments at: 3) - ((moments at: 2) squared * self count)!

variance
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 17/6/99 "

	| n |
	n := self count.
	n < 2 ifTrue: [^nil].
	^((moments at: 3) - ((moments at: 2) squared / n)) / (n - 1)! !
!DhbFastStatisticalMoments categoriesFor: #accumulate:!public!transformation! !
!DhbFastStatisticalMoments categoriesFor: #average!information!public! !
!DhbFastStatisticalMoments categoriesFor: #kurtosis!information!public! !
!DhbFastStatisticalMoments categoriesFor: #skewness!information!public! !
!DhbFastStatisticalMoments categoriesFor: #unnormalizedVariance!information!public! !
!DhbFastStatisticalMoments categoriesFor: #variance!information!public! !

