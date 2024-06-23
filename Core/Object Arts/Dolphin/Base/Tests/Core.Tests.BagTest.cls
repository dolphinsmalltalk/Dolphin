"Filed out from Dolphin Smalltalk"!

Core.Tests.CollectionTest
	subclass: #'Core.Tests.BagTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.BagTest guid: (Core.GUID fromString: '{31d1ecfc-cd30-4437-906f-69585c9e9c94}')!

Core.Tests.BagTest comment: ''!

!Core.Tests.BagTest methodsFor!

collectionClass
	^Bag!

testDeepCopy
	| bag |
	bag := Bag with: Object new with: Object new.
	2 timesRepeat: 
			[| copy any |
			copy := bag deepCopy.
			any := copy detect: [:each | true].
			self assert: (copy includes: any)]!

testRemoveIfAbsent
	| subject |
	subject := self collectionClass withAll: #('a' 'b' 'c' 'a').
	self assert: (subject remove: 'd' ifAbsent: [#absent]) identicalTo: #absent.
	self assert: (subject occurrencesOf: 'a') equals: 2.
	self assert: (subject remove: 'a') equals: 'a'.
	self assert: (subject includes: 'a').
	self assert: (subject occurrencesOf: 'a') equals: 1.
	self assert: (subject remove: 'a') equals: 'a'.
	self assert: (subject occurrencesOf: 'a') equals: 0.
	self assert: (subject remove: 'a' ifAbsent: [#absent]) identicalTo: #absent.
	#('b' 'c') do: 
			[:each |
			self assert: (subject occurrencesOf: each) equals: 1.
			self assert: (subject remove: each) equals: each.
			self assert: (subject occurrencesOf: each) equals: 0.
			self assert: (subject remove: each ifAbsent: [#absent]) identicalTo: #absent].
	self assert: subject isEmpty!

testSortedCounts
	| subject |
	subject := self collectionClass withAll: #('a' 'b' 'c' 'a' 'b' 'b').
	self assert: subject sortedCounts equals: {3 -> 'b'. 2 -> 'a'. 1 -> 'c'}.
	self assert: self collectionClass new sortedCounts equals: #()! !

!Core.Tests.BagTest categoriesForMethods!
collectionClass!constants!private! !
testDeepCopy!public! !
testRemoveIfAbsent!public! !
testSortedCounts!public!unit tests! !
!

