"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #StsSourceComparisonModel
	instanceVariableNames: 'differences lines1 lines2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsSourceComparisonModel guid: (GUID fromString: '{1E36BE55-3ED9-11D4-B101-000000000000}')!
StsSourceComparisonModel comment: ''!
!StsSourceComparisonModel categoriesForClass!Unclassified! !
!StsSourceComparisonModel methodsFor!

chooseStartingRunBetween: range1 and: range2 from: start 
	range1 isNil ifTrue: [^range2 isNil ifFalse: [range2]].
	(range2 isNil or: [range1 <= range2 and: [range2 > range1]]) ifTrue: [^range1].
	^range1 x - start x + range1 y - start y < (range2 x - start x + range2 y - start y) 
		ifTrue: [range1]
		ifFalse: [range2]!

compare: aString1 with: aString2 
	lines1 := self splitToLines: aString1.
	lines2 := self splitToLines: aString2.
	differences := ReadStream on: self findDifferences!

compareLine: index1 with: index2 
	^(index1 > lines1 size or: [index2 > lines2 size]) 
		ifTrue: [false]
		ifFalse: [(lines1 at: index1) trimBlanks = (lines2 at: index2) trimBlanks]!

compareLinesAt: aPoint 
	^self compareLine: aPoint x with: aPoint y!

findDifferences
	| equalRuns diffs top bottom run first |
	top := 1 @ 1.
	bottom := lines1 size @ lines2 size.
	diffs := OrderedCollection new.
	(equalRuns := self findEqualRuns) isEmpty 
		ifTrue: 
			[^diffs
				add: (Array with: top with: bottom);
				yourself].
	run := equalRuns first.
	run first > top ifTrue: [diffs add: (Array with: top with: run first - 1)].
	equalRuns size = 1 
		ifTrue: 
			[((run at: 2) < (bottom x @ bottom x) or: [(run at: 2) < (bottom y @ bottom y)]) 
				ifTrue: [diffs add: (Array with: (run at: 2) + 1 with: bottom)].
			^diffs].
	first := (run at: 2) + 1.
	2 to: equalRuns size
		do: 
			[:i | 
			run := equalRuns at: i.
			diffs add: (Array with: first with: run first - 1).
			first := (run at: 2) + 1].
	first > bottom ifFalse: [diffs add: (Array with: first with: bottom)].
	^diffs!

findEndOfMatchFrom: start 
	| end |
	(start x > lines1 size and: [start y > lines2 size]) ifTrue: [^nil].
	(self compareLinesAt: start) ifFalse: [^nil].
	end := start.
	[self compareLinesAt: end] whileTrue: 
			[(end x >= lines1 size and: [end y >= lines2 size]) ifTrue: [^end].
			end := end + 1].
	^end - 1!

findEqualRuns
	| start end equalRuns |
	equalRuns := OrderedCollection new.
	start := 1 @ 1.
	[true] whileTrue: 
			[(end := self findEndOfMatchFrom: start) isNil 
				ifTrue: [(start := self findStartOfMatchFrom: start) isNil ifTrue: [^equalRuns]]
				ifFalse: 
					[equalRuns add: (Array with: start with: end).
					start := end + 1]]!

findStartOfMatchFrom: start 
	| i j k l found1 found2 |
	i := start x.
	k := start y.
	found1 := found2 := nil.
	[true] whileTrue: 
			[(i > lines1 size and: [k > lines2 size]) 
				ifTrue: 
					[^self 
						chooseStartingRunBetween: found1
						and: found2
						from: start].
			j := k.
			[j <= lines2 size and: [found1 isNil]] whileTrue: 
					[(self compareLine: i with: j) ifTrue: [found1 := i @ j].
					j := j + 1].
			l := i.
			[l <= lines1 size and: [found2 isNil]] whileTrue: 
					[(self compareLine: l with: k) ifTrue: [found2 := l @ k].
					l := l + 1].
			(found1 notNil and: [found2 notNil]) 
				ifTrue: 
					[^self 
						chooseStartingRunBetween: found1
						and: found2
						from: start].
			i := i + 1.
			k := k + 1]!

getRange1: anArray 
	^self 
		getRangeFrom: anArray first x
		to: anArray last x
		ofLines: lines1!

getRange2: anArray 
	^self 
		getRangeFrom: anArray first y
		to: anArray last y
		ofLines: lines2!

getRangeFrom: start to: end ofLines: aCollection 
	| startPos endPos |
	startPos := 0.
	1 to: start - 1 do: [:i | startPos := startPos + (aCollection at: i) size + 2].
	endPos := startPos.
	start to: end do: [:i | endPos := endPos + (aCollection at: i) size + 2].
	^startPos + 1 to: endPos!

nextDifference
	differences atEnd ifTrue: [differences reset].
	^differences atEnd ifFalse: [differences next]!

splitToLines: aString 
	| stream coll |
	coll := OrderedCollection new.
	stream := ReadStream on: aString.
	[stream atEnd] whileFalse: [coll add: stream nextLine].
	^coll! !
!StsSourceComparisonModel categoriesFor: #chooseStartingRunBetween:and:from:!private! !
!StsSourceComparisonModel categoriesFor: #compare:with:!public! !
!StsSourceComparisonModel categoriesFor: #compareLine:with:!private! !
!StsSourceComparisonModel categoriesFor: #compareLinesAt:!private! !
!StsSourceComparisonModel categoriesFor: #findDifferences!private! !
!StsSourceComparisonModel categoriesFor: #findEndOfMatchFrom:!private! !
!StsSourceComparisonModel categoriesFor: #findEqualRuns!private! !
!StsSourceComparisonModel categoriesFor: #findStartOfMatchFrom:!private! !
!StsSourceComparisonModel categoriesFor: #getRange1:!public! !
!StsSourceComparisonModel categoriesFor: #getRange2:!public! !
!StsSourceComparisonModel categoriesFor: #getRangeFrom:to:ofLines:!private! !
!StsSourceComparisonModel categoriesFor: #nextDifference!public! !
!StsSourceComparisonModel categoriesFor: #splitToLines:!private! !

