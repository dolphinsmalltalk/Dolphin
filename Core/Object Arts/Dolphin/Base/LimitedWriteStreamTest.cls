"Filed out from Dolphin Smalltalk 7"!

WriteStreamTest subclass: #LimitedWriteStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LimitedWriteStreamTest guid: (GUID fromString: '{9744cad5-27af-421d-a0ce-d2c7d68cf05d}')!
LimitedWriteStreamTest comment: ''!
!LimitedWriteStreamTest categoriesForClass!Unclassified! !
!LimitedWriteStreamTest methodsFor!

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
				assert: stream contents equals: (self string first: i);
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
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: i;
				assert: stream contents equals: (self string first: i);
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
	| stream overLimit |
	stream := self streamClass
				on: String new
				limit: self stringSize
				limitBlock: [overLimit := true].
	overLimit := false.
	self
		assert: (stream nextPutAll: self string) equals: self string;
		assert: stream position equals: self stringSize;
		assert: stream contents equals: self string;
		deny: overLimit.
	self
		assert: (stream nextPutAll: self string) equals: self string;
		assert: stream position equals: self stringSize;
		assert: stream contents equals: self string;
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

	| stream overLimit |
	stream := self streamClass with: self string copy.
	overLimit := false.
	stream
		limit: self stringSize * 2;
		limitBlock: [overLimit := true].
	self string keysAndValuesDo: 
			[:i :each |
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize + i;
				assert: stream contents equals: self string , (self string first: i);
				deny: overLimit].
	self string do: 
			[:each |
			overLimit := false.
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize * 2;
				assert: stream contents equals: self string , self string;
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
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize + i;
				assert: stream contents equals: self string , (self string first: i);
				deny: overLimit].
	self string do: 
			[:each |
			overLimit := false.
			self
				assert: (stream nextPut: each) equals: each;
				assert: stream position equals: self stringSize * 2;
				assert: stream contents equals: self string , self string;
				assert: overLimit]! !
!LimitedWriteStreamTest categoriesFor: #streamClass!helpers!private! !
!LimitedWriteStreamTest categoriesFor: #testLimit!public!unit tests! !
!LimitedWriteStreamTest categoriesFor: #testLimitBlock!public!unit tests! !
!LimitedWriteStreamTest categoriesFor: #testNextPut!public!unit tests! !
!LimitedWriteStreamTest categoriesFor: #testNextPutAll!public!unit tests! !
!LimitedWriteStreamTest categoriesFor: #testOn!public!unit tests! !
!LimitedWriteStreamTest categoriesFor: #testOnFromTo!public!unit tests! !
!LimitedWriteStreamTest categoriesFor: #testOnLimitLimitBlock!public!unit tests! !
!LimitedWriteStreamTest categoriesFor: #testRecursionDetection!public!unit tests! !
!LimitedWriteStreamTest categoriesFor: #testWith!public! !
!LimitedWriteStreamTest categoriesFor: #testWithFromTo!public! !

