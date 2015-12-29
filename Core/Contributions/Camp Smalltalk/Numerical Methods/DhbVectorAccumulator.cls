"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbVectorAccumulator
	instanceVariableNames: 'count average'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbVectorAccumulator guid: (GUID fromString: '{E550026A-7D2B-11D6-B6CC-00022D5019C8}')!
DhbVectorAccumulator comment: ''!
!DhbVectorAccumulator categoriesForClass!DHB Numerical! !
!DhbVectorAccumulator methodsFor!

accumulate: aVectorOrArray
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	| delta |
	count := count + 1.
	delta := average - aVectorOrArray asVector scaleBy: 1 / count.
	average accumulateNegated: delta.
	^delta!

average
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^average!

count
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^count!

initialize: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	average := DhbVector new: anInteger.
	self reset.
	^self!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	super printOn: aStream.
	aStream space.
	count printOn: aStream.
	aStream space.
	average printOn: aStream.!

reset
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	count := 0.
	average atAllPut: 0.! !
!DhbVectorAccumulator categoriesFor: #accumulate:!public!transformation! !
!DhbVectorAccumulator categoriesFor: #average!information!public! !
!DhbVectorAccumulator categoriesFor: #count!information!public! !
!DhbVectorAccumulator categoriesFor: #initialize:!initialization!public! !
!DhbVectorAccumulator categoriesFor: #printOn:!display!public! !
!DhbVectorAccumulator categoriesFor: #reset!public!transformation! !

!DhbVectorAccumulator class methodsFor!

new: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	^self new initialize: anInteger! !
!DhbVectorAccumulator class categoriesFor: #new:!creation!public! !

