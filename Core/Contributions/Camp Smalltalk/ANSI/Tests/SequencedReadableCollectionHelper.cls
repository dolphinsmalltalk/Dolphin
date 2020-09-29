"Filed out from Dolphin Smalltalk 7"!

TestCaseHelper subclass: #SequencedReadableCollectionHelper
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
SequencedReadableCollectionHelper guid: (Core.GUID fromString: '{739ae9ac-703e-451d-8fda-64b1e591215d}')!
SequencedReadableCollectionHelper comment: ''!
!SequencedReadableCollectionHelper categoriesForClass!Unclassified! !
!SequencedReadableCollectionHelper methodsFor!

canonicalObject
	^testCase canonicalObject copy!

canonicalObjects
"answer a dictionary of subsequences of the canonical object"
	| can cl |
	can := testCase canonicalObject.
	cl := can copyingClass. 
	^(Dictionary new) at: #a put: (cl with: (can at: 1));
		at: #b put: (cl with: (can at: 2));
		at: #c put: (cl with: (can at: 3));
		at: #d put: (cl with: (can at: 4));
		at: #ab put: (cl with: (can at: 1) with: (can at: 2));
		at: #bc put: (cl with: (can at: 2) with: (can at: 3));
		at: #cd put: (cl with: (can at: 3) with: (can at: 4));
		at: #abc put: (cl with: (can at: 1) with: (can at: 2) with: (can at: 3));
		at: #bcd put: (cl with: (can at: 2) with: (can at: 3) with: (can at: 4));
		at: #abcd put: (cl with: (can at: 1) with: (can at: 2) with: (can at: 3) with:(can at: 4));
		yourself!

object: anObject!

testXafterX
	" <sequencedReadableCollection>#after: "
	| co |
	co := self canonicalObject.
	self value: [co after: (co at: 2)]
		should: [:r | r = (co at: 3)]
		conformTo: #sequencedReadableCollection
		selector: #after:!

testXatX
	" <sequencedReadableCollection>#at: "
	| cos b |
	cos := self canonicalObjects.
	b := (cos at:#b) at:1.
	self value: [(cos at:#abcd) at: 2]
		should: [:r | r = b]
		conformTo: #sequencedReadableCollection
		selector: #at:!

testXatXifAbsentX
	" <sequencedReadableCollection>#at:ifAbsent: "

	| cos b |
	cos := self canonicalObjects.
	b := (cos at: #b) at: 1.
	self value: [(cos at: #abcd) at: 2 ifAbsent: [nil]]
		should: [:r | r = b]
		conformTo: #sequencedReadableCollection
		selector: #at:ifAbsent:.
	self value: [(cos at: #abcd) at: 47 ifAbsent: [nil]]
		should: [:r | r isNil]
		conformTo: #sequencedReadableCollection
		selector: #at:ifAbsent:!

testXbeforeX
	" <sequencedReadableCollection>#before: "

	| co |
	co := self canonicalObject.
	self value: [co before: (co at: 3)]
		should: [:r | r = (co at: 2)]
		conformTo: #sequencedReadableCollection
		selector: #after:!

testXconcatenateOp
	" <sequencedReadableCollection>#, (Return Values: <RECEIVER>)"

	| cos |
	cos := self canonicalObjects.
	self value: [(cos at: #ab) , (cos at: #cd)]
		should: [:r | r = (cos at: #abcd)]
		conformTo: #sequencedReadableCollection
		selector: #,!

testXcopyFromXtoX
	" <sequencedReadableCollection>#copyFrom:to: (Return Values: <RECEIVER>)"

	| cos |
	cos := self canonicalObjects.
	self value: [(cos at: #abcd) copyFrom: 2 to: 3]
		should: [:r | r = (cos at: #bc)]
		conformTo: #sequencedReadableCollection
		selector: #copyFrom:to:.
	self value: [(cos at: #abcd) copyFrom: 3 to: 2]
		should: [:r | r isEmpty]
		conformTo: #sequencedReadableCollection
		selector: #copyFrom:to:!

testXcopyReplaceAllXwithX
	" <sequencedReadableCollection>#copyReplaceAll:with: (Return Values: <RECEIVER>)"

	| cos |
	cos := self canonicalObjects.
	self value: [(cos at:#abcd) copyReplaceAll:(cos at:#bc) with: (cos at:#bcd)]
		should: [:r | r = ((cos at:#abcd), (cos at:#d)) ]
		conformTo: #sequencedReadableCollection
		selector: #copyReplaceAll:with:.!

testXcopyReplaceFromXtoXwithObjectX
	" <sequencedReadableCollection>#copyReplaceFrom:to:withObject: (Return Values: <RECEIVER>)"
	| cos c |
	cos := self canonicalObjects.
	c := (cos at:#c).
   self value:[(cos at:#abcd) copyReplaceFrom: 3 to: 2 withObject:((cos at:#b) at:1)]
	    should: [:r | r = ((cos at:#ab), (cos at:#bcd))]
		conformTo: #sequencedReadableCollection
		selector: #copyReplaceFrom:to:withObject:.
   self value:[(cos at:#abc) copyReplaceFrom: 4 to: 3 withObject:((cos at:#d) at:1)]
	    should: [:r | r = (cos at:#abcd)]
		conformTo: #sequencedReadableCollection
		selector: #copyReplaceFrom:to:withObject:.
   self value:[(cos at:#abc) copyReplaceFrom: 1 to: 2 withObject:(c at:1)]
	    should: [:r | r = (c, c, c)]
		conformTo: #sequencedReadableCollection
		selector: #copyReplaceFrom:to:withObject:.!

testXcopyReplaceFromXtoXwithX
	" <sequencedReadableCollection>#copyReplaceFrom:to:with: (Return Values: <RECEIVER>)"

	| cos |
	cos := self canonicalObjects.
   self value:[(cos at:#abcd) copyReplaceFrom: 3 to: 2 with:(cos at:#bc)]
	    should: [:r | r = ((cos at:#ab), (cos at:#bc), (cos at:#cd))]
		conformTo: #sequencedReadableCollection
		selector: #copyReplaceFrom:to:with:.
   self value:[(cos at:#abcd) copyReplaceFrom: 5 to: 4 with:(cos at:#bc)]
	    should: [:r | r = ((cos at:#abcd), (cos at:#bc))]
		conformTo: #sequencedReadableCollection
		selector: #copyReplaceFrom:to:with:.
   self value:[(cos at:#abcd) copyReplaceFrom: 1 to: 3 with:(cos at:#bc)]
	    should: [:r | r = (cos at:#bcd)]
		conformTo: #sequencedReadableCollection
		selector: #copyReplaceFrom:to:with:.!

testXcopyReplacingXwithObjectX
	" <sequencedReadableCollection>#copyReplacing:withObject: (Return Values: <RECEIVER>)"
	| cos c a b |
	cos := self canonicalObjects.
	a := cos at:#a.
	b := cos at:#b.
	c := cos at:#c.
   self value:[((cos at:#ab), (cos at:#bc)) copyReplacing:(b at:1) withObject:(c at:1)]
	    should: [:r | r = (a, c, c, c)]
		conformTo: #sequencedReadableCollection
		selector: #copyReplacing:withObject:.!

testXcopyWithoutX
	" <sequencedReadableCollection>#copyWithout: (Return Values: <RECEIVER>)"
	| cos c a b |
	cos := self canonicalObjects.
	a := cos at:#a.
	b := cos at:#b.
	c := cos at:#c.
   self value:[(cos at:#abc) copyWithout:(b at:1)]
	    should: [:r | r = (a, c)]
		conformTo: #sequencedReadableCollection
		selector: #copyWithout:!

testXcopyWithX
	" <sequencedReadableCollection>#copyWith: (Return Values: <RECEIVER>)"
	| cos d |
	cos := self canonicalObjects.
	d := cos at:#d.
   self value:[(cos at:#abc) copyWith:(d at:1)]
	    should: [:r | r = (cos at: #abcd)]
		conformTo: #sequencedReadableCollection
		selector: #copyWith:!

testXequalityOp
	" <sequencedReadableCollection>#= "
	| copy cos |
	cos := self canonicalObjects.
	copy := (cos at: #abc) copy.
	self
		value:[(cos at:#abc) = copy]
	    should: [:r | r]
		conformTo: #sequencedReadableCollection
		selector: #=.
	self
		value:[(cos at:#ab) = copy]
	    shouldnt: [:r | r]
		conformTo: #sequencedReadableCollection
		selector: #=!

testXfindFirstX
	" <sequencedReadableCollection>#findFirst: "
	| cos d b it |
	cos := self canonicalObjects.
	b := (cos at: #b) at: 1.
	d := (cos at: #d) at: 1.
	it := (cos at: #ab), (cos at: #bc).
	self
		value:[it findFirst: [:e | e = b]]
	    should: [:r | r = 2]
		conformTo: #sequencedReadableCollection
		selector: #findFirst:.
	self
		value:[(cos at:#abc) findFirst: [:e | e = d]]
	    should: [:r | r = 0]
		conformTo: #sequencedReadableCollection
		selector: #findFirst:.!

testXfindLastX
	" <sequencedReadableCollection>#findLast: "
	| cos d b it |
	cos := self canonicalObjects.
	b := (cos at: #b) at: 1.
	d := (cos at: #d) at: 1.
	it := (cos at: #ab), (cos at: #bc).
	self
		value:[it findLast: [:e | e = b]]
	    should: [:r | r = 3]
		conformTo: #sequencedReadableCollection
		selector: #findLast:.
	self
		value:[(cos at:#abc) findLast: [:e | e = d]]
	    should: [:r | r = 0]
		conformTo: #sequencedReadableCollection
		selector: #findLast:.!

testXfirst
	" <sequencedReadableCollection>#first "
	| cos a |
	cos := self canonicalObjects.
	a := (cos at: #a) at: 1.
	self
		value:[(cos at: #abcd) first]
	    should: [:r | r = a]
		conformTo: #sequencedReadableCollection
		selector: #first.!

testXfromXtoXdoX
	" <sequencedReadableCollection>#from:to:do: "
	| co col |
	co := self canonicalObject.
	col := OrderedCollection new.
	self
		value: [co from: 1 to: co size do: [:e | col add: e]]
	    should: [:r | co asOrderedCollection = col]
		conformTo: #sequencedReadableCollection
		selector: #from:to:do:.!

testXfromXtoXkeysAndValuesDoX
	" <sequencedReadableCollection>#from:to:keysAndValuesDo: "

	| co col |
	co := self canonicalObject.
	col := Array new: 4.
	self value: [co from: 1 to: 4 keysAndValuesDo: [:i :e | col at: i put: e]]
		should: [:r | col = co asArray]
		conformTo: #sequencedReadableCollection
		selector: #from:to:keysAndValuesDo:!

testXindexOfSubCollectionXstartingAtX
	" <sequencedReadableCollection>#indexOfSubCollection:startingAt: "
	| cos |
	cos := self canonicalObjects.
	self
		value:[(cos at: #abcd) indexOfSubCollection:(cos at:#bc) startingAt:1]
	    should: [:r | r = 2]
		conformTo: #sequencedReadableCollection
		selector: #indexOfSubCollection:startingAt:.
	self
		value:[(cos at: #abcd) indexOfSubCollection:(cos at:#bc) startingAt:3]
	    should: [:r | r = 0]
		conformTo: #sequencedReadableCollection
		selector: #indexOfSubCollection:startingAt:.!

testXindexOfSubCollectionXstartingAtXifAbsentX
	" <sequencedReadableCollection>#indexOfSubCollection:startingAt:ifAbsent: "
	| cos |
	cos := self canonicalObjects.
	self
		value:[(cos at: #abcd) indexOfSubCollection:(cos at:#bc) startingAt:1 ifAbsent:[nil] ]
	    should: [:r | r = 2]
		conformTo: #sequencedReadableCollection
		selector: #indexOfSubCollection:startingAt:ifAbsent:.
	self
		value:[(cos at: #abcd) indexOfSubCollection:(cos at:#bc) startingAt:3 ifAbsent:[nil]]
	    should: [:r | r isNil]
		conformTo: #sequencedReadableCollection
		selector: #indexOfSubCollection:startingAt:ifAbsent:.!

testXindexOfX
	" <sequencedReadableCollection>#indexOf: "
	| cos c |
	cos := self canonicalObjects.
	c := (cos at:#c) at:1.
	self
		value:[(cos at: #abcd) indexOf: c]
	    should: [:r | r = 3]
		conformTo: #sequencedReadableCollection
		selector: #indexOf:.
	self
		value:[(cos at: #abcd) indexOf: 42]
	    should: [:r | r = 0]
		conformTo: #sequencedReadableCollection
		selector: #indexOf:.!

testXindexOfXifAbsentX
	" <sequencedReadableCollection>#indexOf:ifAbsent: "
	| cos c |
	cos := self canonicalObjects.
	c := (cos at:#c) at:1.
	self
		value:[(cos at: #abcd) indexOf: c ifAbsent:[nil]]
	    should: [:r | r = 3]
		conformTo: #sequencedReadableCollection
		selector: #indexOf:ifAbsent:.
	self
		value:[(cos at: #abcd) indexOf: 42 ifAbsent:[nil]]
	    should: [:r | r isNil]
		conformTo: #sequencedReadableCollection
		selector: #indexOf:ifAbsent:.!

testXlast
	" <sequencedReadableCollection>#last "
	| cos d |
	cos := self canonicalObjects.
	d := (cos at: #d) at: 1.
	self
		value:[(cos at: #abcd) last]
	    should: [:r | r = d]
		conformTo: #sequencedReadableCollection
		selector: #last.!

testXreverse
	" <sequencedReadableCollection>#reverse (Return Values: <RECEIVER>)"

	| cos abc |
	cos := self canonicalObjects.
	abc := cos at:#abc.
	self
		value: [abc reverse]
		should:
			[:r |
			r size = 3 and:
				[((r at: 1) = (abc at: 3)) and:
					[(r at: 3) = (abc at: 1)]]]
		conformTo: #sequencedReadableCollection
		selector: #reverse!

testXreverseDoX
	" <sequencedReadableCollection>#reverseDo: "
	| col cos abc |
	cos := self canonicalObjects.
	abc := cos at:#abc.
	col := OrderedCollection new.
	self
		value: [abc reverseDo: [:e | col add: e]]
	    should: [:r | col = abc reverse asOrderedCollection]
		conformTo: #sequencedReadableCollection
		selector: #reverseDo:.!

testXwithXdoX
	" <sequencedReadableCollection>#with:do: "
	| col cos abc bcd |
	cos := self canonicalObjects.
	abc := cos at:#abc.
	bcd := cos at:#bcd.
	col := OrderedCollection new.
	self
		value: [abc with: bcd do: [:e1 :e2 | col add: (e1 = e2)]]
	    should: [:r | col = #(false false false) asOrderedCollection]
		conformTo: #sequencedReadableCollection
		selector: #with:do:.! !
!SequencedReadableCollectionHelper categoriesFor: #canonicalObject!public! !
!SequencedReadableCollectionHelper categoriesFor: #canonicalObjects!public! !
!SequencedReadableCollectionHelper categoriesFor: #object:!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXafterX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXatX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXatXifAbsentX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXbeforeX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXconcatenateOp!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXcopyFromXtoX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXcopyReplaceAllXwithX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXcopyReplaceFromXtoXwithObjectX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXcopyReplaceFromXtoXwithX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXcopyReplacingXwithObjectX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXcopyWithoutX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXcopyWithX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXequalityOp!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXfindFirstX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXfindLastX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXfirst!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXfromXtoXdoX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXfromXtoXkeysAndValuesDoX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXindexOfSubCollectionXstartingAtX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXindexOfSubCollectionXstartingAtXifAbsentX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXindexOfX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXindexOfXifAbsentX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXlast!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXreverse!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXreverseDoX!public! !
!SequencedReadableCollectionHelper categoriesFor: #testXwithXdoX!public! !

