"Filed out from Dolphin Smalltalk 7"!

Core.Tests.WriteStreamTest subclass: #'Core.Tests.LimitedWriteStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.LimitedWriteStreamTest guid: (Core.GUID fromString: '{9744cad5-27af-421d-a0ce-d2c7d68cf05d}')!
Core.Tests.LimitedWriteStreamTest comment: ''!
!Core.Tests.LimitedWriteStreamTest categoriesForClass!Unclassified! !
!Core.Tests.LimitedWriteStreamTest methodsFor!

streamClass
	^LimitedWriteStream!

testLimit
	| stream overLimit |
	stream := self newStream.
	overLimit := false.
	stream
		limitBlock: [overLimit := true];
		nextPutAll: self string.
	self
		assert: stream limit equals: self streamClass defaultLimit;
		assert: (stream limit: self stringSize) identicalTo: stream;
		assert: stream limit equals: self stringSize;
		deny: overLimit.
	self stringSize - 1 to: 0
		by: -1
		do: 
			[:i |
			overLimit := false.
			self
				assert: (stream limit: i) identicalTo: stream;
				assert: stream limit equals: i;
				assert: stream position equals: i;
				assert: stream contents equals: (self string copyFrom: 1 to: i);
				assert: overLimit]!

testLimitBlock
	| stream overLimit limitBlock |
	stream := self newStream.
	overLimit := false.
	limitBlock := [overLimit := true].
	self
		assert: stream limitBlock equals: LimitedWriteStream defaultLimitBlock;
		assert: (stream limitBlock: limitBlock) identicalTo: stream;
		assert: stream limitBlock identicalTo: limitBlock;
		deny: overLimit!

testNextColonPut
	| underlying stream overLimit |
	underlying := String writeStream.
	underlying nextPutAll: 'Initial'.
	stream := self streamClass
				over: underlying
				limit: 5
				limitBlock: [overLimit := true].
	overLimit := false.
	stream next: 10 put: $a.
	self assert: overLimit.
	self assert: stream contents equals: 'Initialaaaaa'!

testNextPut
	| stream overLimit |
	super testNextPut.
	stream := self streamClass
				on: String new
				limit: self stringSize
				limitBlock: [overLimit := true].
	overLimit := false.
	self string keysAndValuesDo: 
			[:i :each |
			| end |
			end := i + (self string encodedSizeOf: each) - 1.
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: end;
				assert: stream contents equals: (self string copyFrom: 1 to: end);
				deny: overLimit].
	self string do: 
			[:each |
			overLimit := false.
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize;
				assert: stream contents equals: self string;
				assert: overLimit]!

testNextPutAll
	| stream overLimit str |
	stream := self streamClass
				on: String new
				limit: self stringSize
				limitBlock: [overLimit := true].
	overLimit := false.
	str := self string.
	self
		assert: (stream nextPutAll: str) equals: str;
		assert: stream position equals: self stringSize;
		assert: stream contents equals: str;
		deny: overLimit.
	self
		assert: (stream nextPutAll: str) equals: str;
		assert: stream position equals: self stringSize;
		assert: stream contents equals: str;
		assert: overLimit!

testNextPutAllThroughLimit
	| stream overLimit |
	stream := self streamClass
				on: String new
				limit: self stringSize - 1
				limitBlock: [overLimit := true].
	overLimit := false.
	self
		assert: (stream nextPutAll: self string) equals: self string;
		assert: stream position equals: self stringSize - 1;
		assert: stream contents equals: self string allButLast;
		assert: overLimit!

testOn
	| stream |
	stream := self newStream.
	self
		assert: stream limit equals: self streamClass defaultLimit;
		assert: stream limitBlock equals: self streamClass defaultLimitBlock!

testOnFromTo
	| stream |
	stream := self streamClass
				on: self string , self string
				from: self stringSize + 1
				to: self stringSize * 2.
	self
		assert: stream limit equals: self streamClass defaultLimit;
		assert: stream limitBlock equals: self streamClass defaultLimitBlock!

testOnLimitLimitBlock
	| collection overLimit limitBlock stream |
	collection := String new.
	overLimit := false.
	limitBlock := [overLimit := true].
	stream := self streamClass
				on: collection
				limit: self stringSize
				limitBlock: limitBlock.
	self
		assert: stream originalContents identicalTo: collection;
		assert: stream position isZero;
		assert: stream limit equals: self stringSize;
		assert: stream limitBlock equals: limitBlock;
		deny: overLimit!

testOverFileStream
	"Test limiting output to a FileStream actually does limit the output"

	| temp fs stream actual |
	temp := File temporaryFilename.
	fs := FileStream write: temp.
	"Test limiting the output beyond some initial content that is not counted as part of the limit"
	fs nextPutAll: 'Initial: '.
	stream := self streamClass
				over: fs
				limit: 5
				limitBlock: [fs nextPut: $\x1F6D1].
	stream nextPutAll: '🐬 past limit'.
	fs close.
	actual := File readAllText: temp.
	self assert: actual equals: 'Initial: 🐬 🛑'.
	File delete: temp!

testRecursionDetection
	| stream array |
	stream := self newStream.
	array := {1.1. {2.1. nil. 2.2. 2.3}. 2.1. 3.1}.
	array second at: 2 put: array.
	stream print: array.
	self assert: stream contents equals: 'an Array(1.1 an Array(2.1 ... a cyclic ref to an Array... 2.2 2.3) 2.1 3.1)'!

testWith
	"like on: except it starts writing at the end of its argument collection,
	and the initial position is the collection size and the initial contents
	is the collection"

	| stream overLimit str |
	str := self string.
	stream := self streamClass with: str copy.
	overLimit := false.
	stream
		limit: self stringSize * 2;
		limitBlock: [overLimit := true].
	str keysAndValuesDo: 
			[:i :each |
			| end |
			end := i + (str encodedSizeOf: each) - 1.
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize + end;
				assert: stream contents equals: str , (str copyFrom: 1 to: end);
				deny: overLimit].
	str do: 
			[:each |
			overLimit := false.
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize * 2;
				assert: stream contents equals: str , str;
				assert: overLimit]!

testWithFromTo
	"like with: except it paritions its argument collection first using the
	from:/to: indexes"

	| stream overLimit |
	stream := self streamClass
				with: self string , self string
				from: 1
				to: self stringSize.
	overLimit := false.
	stream
		limit: self stringSize * 2;
		limitBlock: [overLimit := true].
	self string keysAndValuesDo: 
			[:i :each |
			| end |
			end := i + (self string encodedSizeOf: each) - 1.
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize + end;
				assert: stream contents equals: self string , (self string copyFrom: 1 to: end);
				deny: overLimit].
	self string do: 
			[:each |
			overLimit := false.
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize * 2;
				assert: stream contents equals: self string , self string;
				assert: overLimit]! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #streamClass!helpers!private! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testLimit!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testLimitBlock!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testNextColonPut!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testNextPut!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testNextPutAll!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testNextPutAllThroughLimit!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testOn!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testOnFromTo!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testOnLimitLimitBlock!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testOverFileStream!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testRecursionDetection!public!unit tests! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testWith!public! !
!Core.Tests.LimitedWriteStreamTest categoriesFor: #testWithFromTo!public! !

