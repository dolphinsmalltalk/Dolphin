"Filed out from Dolphin Smalltalk"!

Core.Tests.StreamTest
	subclass: #'Core.Tests.NullStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.NullStreamTest guid: (Core.GUID fromString: '{9acbef26-66af-43a0-baf6-3facc80760ac}')!

Core.Tests.NullStreamTest comment: ''!

!Core.Tests.NullStreamTest methodsFor!

expectedAnsiProtocolNames
	^#(#gettableStream #Object #puttableStream)!

isReadableStreamClass
	^false!

testAtEnd
	| subject |
	subject := self streamOn: 'abc'.
	self assert: subject atEnd!

testContentSpecies
	self assert: self streamClass new contentsSpecies equals: String!

testIsEmpty
	| subject |
	subject := self streamOn: 'abc'.
	self assert: subject isEmpty!

testNext
	| subject |
	subject := self streamOn: 'abc'.
	self should: [subject next] raise: Stream endOfStreamSignal.
	self should: [subject next: 2] raise: Stream endOfStreamSignal.
	self should: 
			[subject
				next: 2
				into: (String new: 2)
				startingAt: 1]
		raise: Stream endOfStreamSignal!

testNextAvailable
	| subject |
	subject := self streamOn: #(1 2 3).
	self assert: subject nextAvailable isNil.
	self assert: (subject nextAvailable: 3) equals: #()!

testNextLine
	| subject |
	subject := self streamOn: 'abc
def'.
	self assert: subject nextLine equals: ''.
	subject := self streamOn: #(1 2 3).
	self assert: subject nextLine equals: #()!

testNextPut
	| subject |
	subject := NullStream new.
	subject isImmutable: true.
	self assert: (subject nextPut: $A) equals: $A.
	self assert: subject position equals: 0.
	self assert: subject atEnd.
	self assert: (subject next: 10 put: $B) equals: $B.
	self assert: subject position equals: 0.
	self assert: subject atEnd.
!

testNextPutAll
	| subject |
	subject := NullStream new.
	subject isImmutable: true.
	self assert: (subject nextPutAll: 'abc') equals: 'abc'.
	self assert: subject position equals: 0.
	self assert: subject atEnd.
	self assert: (subject next: 3 putAll: 'def' startingAt: 1) equals: 'def'.
	self assert: subject position equals: 0.
	self assert: subject atEnd.
	self should: [subject next: 3 putAll: 'def' startingAt: 0] raise: BoundsError.
	self should: [subject next: 3 putAll: 'def' startingAt: 2] raise: BoundsError!

testPeek
	| subject |
	subject := self streamOn: 'abc'.
	self assertIsNil: subject peek!

testPeekFor
	| subject |
	subject := self streamOn: 'abc'.
	self deny: (subject peekFor: $a)!

testPosition
	| subject |
	subject := self streamOn: 'abc'.
	self assert: subject position equals: 0!

testSkip
	| subject |
	subject := self streamOn: 'abc'.
	self should: [subject skip: 1] raise: Stream endOfStreamSignal!

testSkipThrough
	| subject |
	subject := self streamOn: 'abc'.
	self assertIsNil: (subject skipThrough: $b)!

testSkipTo
	| subject |
	subject := self streamOn: 'abc'.
	self deny: (subject skipTo: $b).
	self deny: (subject skipTo: $d)!

testUpTo
	| subject |
	subject := self streamOn: 'abc'.
	self assert: (subject upTo: $b) equals: ''.
	subject := self streamOn: #(1 2 3).
	self assert: (subject upTo: 4) equals: #()!

testUpToEnd
	| subject |
	subject := self streamOn: 'abc'.
	self assert: subject upToEnd equals: ''.
	subject := self streamOn: #(1 2 3).
	self assert: subject upToEnd equals: #()! !

!Core.Tests.NullStreamTest categoriesForMethods!
expectedAnsiProtocolNames!constants!private! !
isReadableStreamClass!public!testing! !
testAtEnd!public!unit tests! !
testContentSpecies!public!unit tests! !
testIsEmpty!public!unit tests! !
testNext!public!unit tests! !
testNextAvailable!public!unit tests! !
testNextLine!public!unit tests! !
testNextPut!public!unit tests! !
testNextPutAll!public!unit tests! !
testPeek!public!unit tests! !
testPeekFor!public!unit tests! !
testPosition!public!unit tests! !
testSkip!public!unit tests! !
testSkipThrough!public!unit tests! !
testSkipTo!public!unit tests! !
testUpTo!public!unit tests! !
testUpToEnd!public!unit tests! !
!

!Core.Tests.NullStreamTest class methodsFor!

streamClass
	^NullStream! !

!Core.Tests.NullStreamTest class categoriesForMethods!
streamClass!helpers!private! !
!

