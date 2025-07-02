"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.GUIDTest'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.GUIDTest guid: (Core.GUID fromString: '{e1371d2f-b622-4825-b412-b44260477b09}')!

Core.Tests.GUIDTest comment: ''!

!Core.Tests.GUIDTest categoriesForClass!Tests-Network-UUID! !

!Core.Tests.GUIDTest methodsFor!

assertNull: guid
	self assert: guid size equals: 16.
	self assert: guid equals: self subjectClass null.
	self assert: guid isNull.
	self assert: guid asString size equals: 38.
	self assert: (guid asByteArray allSatisfy: [:each | each = 0])!

nullDisplayString
	^'{00000000-0000-0000-0000-000000000000}'!

subjectClass
	^GUID!

testAsByteArray
	| subject bytes parts |
	subject := self subjectClass newUnique.
	bytes := subject asByteArray.
	parts := $- split: subject idlString.
	"See https://docs.microsoft.com/en-us/windows/win32/api/guiddef/ns-guiddef-guid"
	self assert: ((bytes uint32AtOffset: 0) printStringBase: 16 nDigits: 8) asLowercase
		equals: parts first.
	self assert: ((bytes uint16AtOffset: 4) printStringBase: 16 nDigits: 4) asLowercase
		equals: parts second.
	self assert: ((bytes uint16AtOffset: 6) printStringBase: 16 nDigits: 4) asLowercase
		equals: parts third.
	self assert: (bytes copyFrom: 9 to: 10) hex equals: parts fourth.
	self assert: (bytes copyFrom: 11 to: 16) hex equals: parts fifth.
	self assert: (self subjectClass fromBytes: bytes) equals: subject.
	self assert: self subjectClass null asByteArray equals: #[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]!

testAsInteger
	| guids status |
	self assert: self subjectClass null asInteger equals: 0.
	guids := (1 to: 3) collect: [:i | self subjectClass newUnique].
	status := External.UInt32Bytes new.
	guids do: 
			[:subject |
			| int cmp |
			int := subject asInteger.
			self assert: int positive.
			cmp := OS.Rpcrt4
						uuidCompare: int basicYourAddress
						uuid2: subject
						status: status.
			self assert: status value equals: 0.
			self assert: cmp equals: 0]!

testComparison
	| guid1 guid2 |
	guid1 := self subjectClass newUnique.
	guid2 := self subjectClass newUnique.
	self assert: guid1 equals: guid1.
	self assert: guid2 equals: guid2.
	self deny: guid1 equals: guid2.
	self deny: guid1 hash equals: guid2 hash!

testDisplayString
	| subject |
	subject := self subjectClass null.
	self assert: subject displayString equals: self nullDisplayString.
	subject := self subjectClass fromString: '{7EB5AF34-D3AB-4790-827D-1E61D5A00984}'.
	self assert: subject displayString equals: '{7eb5af34-d3ab-4790-827d-1e61d5a00984}'!

testFromString
	| guid string src |
	src := self subjectClass newUnique.
	string := src asString.
	guid := self subjectClass fromString: string.
	self assert: guid size equals: 16.
	self assert: guid asString size equals: 38.
	self assert: src equals: guid.
	self
		should: [GUID fromString: 'foo']
		raise: OS.RPCError
		matching: [:ex | ex statusCode = OS.Win32Errors.RPC_S_INVALID_STRING_UUID]!

testFromStringNull
	self assertNull: (self subjectClass fromString: self subjectClass null asString)!

testIsSelfEvaluating
	self assert: self subjectClass null isSelfEvaluating.
	self assert: self subjectClass newUnique isSelfEvaluating!

testNewUnique
	| uuid |
	uuid := self subjectClass newUnique.
	self assert: uuid size equals: 16.
	self deny: uuid isNull.
	self assert: uuid asString size equals: 38!

testNull
	| null |
	null := self subjectClass null.
	self assertNull: null.
	self assert: null isImmutable!

testOrder
	100 timesRepeat: 
			[| guid1 guid2 |
			guid1 := self subjectClass newUnique.
			guid2 := self subjectClass newUnique.
			(guid1 asString last: 12) = (guid2 asString last: 12)
				ifTrue: 
					[self assert: guid1 asInteger < guid2 asInteger.
					self assert: guid2 asInteger > guid1 asInteger.
					self deny: guid1 equals: guid2]]!

testSpaceships
	| subject null |
	subject := self subjectClass newUnique.
	null := self subjectClass null.
	self assert: subject <=> null equals: 1.
	self assert: subject <==> null equals: 1.
	self assert: subject <=> subject equals: 0.
	self assert: subject <==> subject equals: 0.
	self assert: null <=> subject equals: -1.
	self assert: null <==> subject equals: -1.
	self assert: null <=> null equals: 0.
	self assert: null <==> null equals: 0!

testStoreOn
	| subject stored collection |
	subject := self subjectClass newUnique.
	collection := OrderedCollection with: subject.
	stored := collection storeString.
	self assert: (Compiler evaluate: stored) equals: collection.
	self assert: (Compiler evaluate: self subjectClass null storeString) equals: self subjectClass null!

testUniqueness
	| generated size |
	size := 1000.
	generated := Set new: size.
	size timesRepeat: [generated add: self subjectClass newUnique].
	self assert: generated size equals: size! !

!Core.Tests.GUIDTest categoriesForMethods!
assertNull:!helpers!private! !
nullDisplayString!constants!private! !
subjectClass!constants!private! !
testAsByteArray!public!unit tests! !
testAsInteger!public!unit tests! !
testComparison!public!unit tests! !
testDisplayString!public!unit tests! !
testFromString!public!unit tests! !
testFromStringNull!public!unit tests! !
testIsSelfEvaluating!public!unit tests! !
testNewUnique!public!unit tests! !
testNull!public!unit tests! !
testOrder!public!unit tests! !
testSpaceships!public!unit tests! !
testStoreOn!public!unit tests! !
testUniqueness!public!unit tests! !
!

