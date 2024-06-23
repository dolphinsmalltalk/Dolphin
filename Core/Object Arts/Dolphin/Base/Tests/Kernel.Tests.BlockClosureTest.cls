"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.BlockClosureTest'
	instanceVariableNames: 'x'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.BlockClosureTest guid: (Core.GUID fromString: '{346b84aa-d94e-4ee6-9461-5195ef00255b}')!

Kernel.Tests.BlockClosureTest comment: ''!

!Kernel.Tests.BlockClosureTest methodsFor!

blockWithCopiedValue: anObject
	^[anObject]!

nestedReturn
	"Not actually a far return, therefore no method context needed"
	^[
	[x := 1.
	1] ensure: 
				[x := x + 1.
				2]] ensure: 
			[x := x + 1.
			3]!

nestedReturn1
	"Far return from protected block, therefore needs context, and protected block needs outer ref"
	^[
	[x := 1.
	^1] ensure: 
				[x := x + 1.
				2]] ensure: 
			[x := x + 1.
			3]!

nestedReturn2
	^[
	[x := 1.
	^1] ensure: 
				[x := x + 1.
				^2]] ensure: 
			[x := x + 1.
			3]!

nestedReturn3
	^[
	[x := 1.
	^1] ensure: 
				[x := x + 1.
				^2]] ensure: 
			[x := x + 1.
			^3]!

testCopyingBlock
	| blocks result |
	blocks := OrderedCollection new.
	1 to: 10 do: [:i | blocks add: [i]].
	1 to: blocks size
		do: 
			[:i |
			| block |
			block := blocks at: i.
			self assert: block argumentCount equals: 0.
			self assert: block size equals: 1.
			self assertIsNil: block outer.
			self assert: block value equals: i].
	result := blocks inject: 0 into: [:sum :each | sum + each value].
	"If blocks working correctly, then the closed over variable 'i', should have a different value in each block,
	and so the result should be the sum of numbers up to 10"
	self assert: result equals: ((1 to: 10) inject: 0 into: [:sum :each | sum + each])!

testCull
	[] cull: 1.
	[:a | ] cull: 1.
	self should: [[:a :b | ] cull: 1] raise: Error.
	self should: [[:a :b :c | ] cull: 1] raise: Error.
	self should: [[:a :b :c :d | ] cull: 1] raise: Error.
	self should: [[:a :b :c :d :e | ] cull: 1] raise: Error.
	self assert: ([0] cull: 1) equals: 0.
	self assert: ([:a | a] cull: 1) equals: 1!

testCullCull
	[] cull: 1 cull: 2.
	[:a | ] cull: 1 cull: 2.
	[:a :b | ] cull: 1 cull: 2.
	self should: [[:a :b :c | ] cull: 1 cull: 2] raise: Error.
	self should: [[:a :b :c :d | ] cull: 1 cull: 2] raise: Error.
	self should: [[:a :b :c :d :e | ] cull: 1 cull: 2] raise: Error.
	self assert: ([0] cull: 1 cull: 2) equals: 0.
	self assert: ([:a | a] cull: 1 cull: 2) equals: 1.
	self assert: ([:a :b | b] cull: 1 cull: 2) equals: 2!

testCullCullCull
	[]
		cull: 1
		cull: 2
		cull: 3.
	[:a | ]
		cull: 1
		cull: 2
		cull: 3.
	[:a :b | ]
		cull: 1
		cull: 2
		cull: 3.
	[:a :b :c | ]
		cull: 1
		cull: 2
		cull: 3.
	self should: 
			[[:a :b :c :d | ]
				cull: 1
				cull: 2
				cull: 3]
		raise: Error.
	self should: 
			[[:a :b :c :d :e | ]
				cull: 1
				cull: 2
				cull: 3]
		raise: Error.
	self assert: ([0]
				cull: 1
				cull: 2
				cull: 3)
		equals: 0.
	self assert: ([:a | a]
				cull: 1
				cull: 2
				cull: 3)
		equals: 1.
	self assert: ([:a :b | b]
				cull: 1
				cull: 2
				cull: 3)
		equals: 2.
	self assert: ([:a :b :c | c]
				cull: 1
				cull: 2
				cull: 3)
		equals: 3!

testCullCullCullCull
	[]
		cull: 1
		cull: 2
		cull: 3
		cull: 4.
	[:a | ]
		cull: 1
		cull: 2
		cull: 3
		cull: 4.
	[:a :b | ]
		cull: 1
		cull: 2
		cull: 3
		cull: 4.
	[:a :b :c | ]
		cull: 1
		cull: 2
		cull: 3
		cull: 4.
	[:a :b :c :d | ]
		cull: 1
		cull: 2
		cull: 3
		cull: 4.
	self should: 
			[[:a :b :c :d :e | ]
				cull: 1
				cull: 2
				cull: 3
				cull: 4]
		raise: Error.
	self assert: ([0]
				cull: 1
				cull: 2
				cull: 3
				cull: 4)
		equals: 0.
	self assert: ([:a | a]
				cull: 1
				cull: 2
				cull: 3
				cull: 4)
		equals: 1.
	self assert: ([:a :b | b]
				cull: 1
				cull: 2
				cull: 3
				cull: 4)
		equals: 2.
	self assert: ([:a :b :c | c]
				cull: 1
				cull: 2
				cull: 3
				cull: 4)
		equals: 3.
	self assert: ([:a :b :c :d | d]
				cull: 1
				cull: 2
				cull: 3
				cull: 4)
		equals: 4!

testEmptyBlock
	{[]. [:a | ]. [:a :b | ]} do: 
			[:each |
			self assertIsNil: (each valueWithArguments: (1 to: each argumentCount) asArray).
			true
				ifTrue: 
					[self assertIsNil: each outer.
					self assertIsNil: each receiver]]!

testEnsure
	self assert: self nestedReturn equals: 1.
	self assert: x equals: 3.
	self assert: self nestedReturn1 equals: 1.
	self assert: x equals: 3.
	self assert: self nestedReturn2 equals: 2.
	self assert: x equals: 3.
	self assert: self nestedReturn3 equals: 3.
	self assert: x equals: 3!

testEqualityOfBlocksFromSameMethod
	| temp |
	self deny: [#one] equals: [#two].
	"Perhaps these should be considered equal, in such a degenerate case, but this is more trouble than it's worth..."
	self deny: [#three] equals: [#three].
	self assert: (self blockWithCopiedValue: #one) equals: (self blockWithCopiedValue: #one).
	self deny: (self blockWithCopiedValue: #one) equals: (self blockWithCopiedValue: #two).
	temp := #foo.
	"Again, perhaps these should be considered equal, but more trouble than it's worth."
	self deny: [temp] equals: [temp]!

testExceptionInEnsure
	| result |
	result := [[1+2] ensure: [Object new blah. self fail: 'Should not get here']. self fail: 'Should not get here either'] on: MessageNotUnderstood do: [:ex | ex return: 'success']. 
	self assert: result equals: 'success'!

testNesting
	| a b c |
	a := 
			[:x1 |
			b := 
					[:x2 |
					c := [:x3 | x3 * x3].
					x2 * (c value: x2 + 1)].
			x1 * (b value: x1 + 1)].
	self assert: (a value: 1) equals: 1 * (2 * (3 * 3)).

	"a should be a full block, as it assigns method level temps"
	self assert: a outer isKindOf: self methodContextClass.
	"All the shared temps are allocated at the method level"
	self assert: b outer identicalTo: a outer.
	true
		ifTrue: 
			["C doesn't need an outer as it only refs its argument"
			self assertIsNil: c outer]!

testNoArguments
	self
		should: [:arg | arg]
		raise: Error
		matching: [:err | err description = 'Block expects 1 argument(s), 0 given'].
	self
		should: [:arg1 :arg2 | arg1 + arg2]
		raise: Error
		matching: [:err | err description = 'Block expects 2 argument(s), 0 given']!

testOneArgument
	| c |
	c := OrderedCollection new.
	c add: 'hello'.
	self
		should: [c do: [1 + 2]]
		raise: Error
		matching: [:err | err description = 'Block expects 0 argument(s), 1 given'].
	self
		should: [c do: [:arg1 :arg2 | 1 + 2]]
		raise: Error
		matching: [:err | err description = 'Block expects 2 argument(s), 1 given']!

testRecursiveBlock
	| factorial |
	factorial := [:int | int > 1 ifTrue: [(factorial value: int - 1) * int] ifFalse: [1]].
	"factorial itself is a shared temp, so the block must have an outer"
	self denyIsNil: factorial outer.
	"factorial should have one arg"
	self assert: factorial argumentCount equals: 1.
	"factorial requires no extra stack temps"
	self assert: factorial stackTempCount equals: 0.
	"factorial block itself has no copied values or shared temps of its own"
	self assert: factorial size equals: 0.
	self assert: (factorial value: 6) equals: 720!

testStbUpgradeFromVersion0
	"An STB'd block from Dolphin 5, before Dolphin had full block closures, will get rewritten to the new byte code set (see BytecodeRewriter). It won't be very efficient, but it should work as it did before."

	| block |
	"[:a | ([:b | a printString, ': ', b factorial printString ] value: a)]"
	block := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 48 32 6 4 12 0 66 108 111 99 107 67 108 111 115 117 114 101 0 0 0 0 38 3 13 0 77 101 116 104 111 100 67 111 110 116 101 120 116 2 0 0 0 1 0 0 0 38 5 18 0 67 111 109 112 105 108 101 100 69 120 112 114 101 115 115 105 111 110 4 0 0 0 129 2 0 0 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 7 0 0 0 68 111 108 112 104 105 110 210 0 0 0 15 0 0 0 85 110 100 101 102 105 110 101 100 79 98 106 101 99 116 210 0 0 0 4 0 0 0 100 111 73 116 38 0 5 0 65 114 114 97 121 2 0 0 0 210 0 0 0 72 0 0 0 91 58 97 32 124 32 40 91 58 98 32 124 32 97 32 112 114 105 110 116 83 116 114 105 110 103 44 32 39 58 32 39 44 32 98 32 102 97 99 116 111 114 105 97 108 32 112 114 105 110 116 83 116 114 105 110 103 32 93 32 118 97 108 117 101 58 32 97 41 93 13 10 18 1 0 0 1 0 0 0 14 2 18 0 83 84 66 67 111 108 108 101 99 116 105 111 110 80 114 111 120 121 0 0 0 0 186 0 0 0 0 0 0 0 224 0 0 0 210 0 0 0 14 0 0 0 80 111 111 108 68 105 99 116 105 111 110 97 114 121 18 1 0 0 1 0 0 0 6 2 11 0 65 115 115 111 99 105 97 116 105 111 110 0 0 0 0 210 0 0 0 5 0 0 0 98 108 111 99 107 82 0 0 0 0 0 0 0 114 0 0 0 2 0 0 0 1 0 0 0 146 0 0 0 2 0 0 0 129 2 0 0 192 0 0 0 210 0 0 0 4 0 0 0 100 111 73 116 18 1 0 0 2 0 0 0 210 0 0 0 57 0 0 0 98 108 111 99 107 32 58 61 32 91 58 105 110 116 32 124 32 40 91 58 105 110 116 32 124 32 105 110 116 32 102 97 99 116 111 114 105 97 108 93 32 118 97 108 117 101 58 32 105 110 116 41 32 43 32 49 93 18 1 0 0 1 0 0 0 96 1 0 0 54 0 9 0 66 121 116 101 65 114 114 97 121 21 0 0 0 251 1 13 0 89 251 1 4 0 90 18 158 106 17 143 98 106 210 1 100 105 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 210 0 0 0 9 0 0 0 102 97 99 116 111 114 105 97 108 176 1 0 0 0 0 0 0 7 0 0 0 7 0 0 0 3 0 0 0 11 0 0 0 240 1 0 0 66 2 0 0 24 0 0 0 251 1 18 0 89 251 1 10 0 90 17 158 30 176 18 161 158 176 106 17 143 106 100 105 106 2 0 0 0 0 0 0 210 0 0 0 11 0 0 0 112 114 105 110 116 83 116 114 105 110 103 210 0 0 0 2 0 0 0 58 32 106 2 0 0 0 0 0 0 210 0 0 0 1 0 0 0 44 112 2 0 0 0 0 0 0 21 0 0 0 21 0 0 0 3 0 0 0 11 0 0 0 160 0 0 0].
	self assert: block method disassembly
		equals: 'Normal, 0 args, 2 env temps, 4 literals, needs context

	1	Block Copy, 1 args, needs self, needs outer, skip +28 to 36
	8	Push Temp[0]
	9	Pop Outer[1] Temp[0]
	11	Block Copy, 1 args, needs self, needs outer, skip +14 to 32
	18	Push Temp[0]
	19	Pop Outer[1] Temp[1]
	21	Push Outer[1] Temp[0]
	23	Send[0]: #printString with 0 args
	24	Push Const[1]: '': ''
	25	Send[2]: #, with 1 args
	26	Push Outer[1] Temp[1]
	28	Send[3]: #factorial with 0 args
	29	Send[0]: #printString with 0 args
	30	Send[2]: #, with 1 args
	31	Return From Block
	32	Push Outer[1] Temp[0]
	34	Special Send #value:
	35	Return From Block
	36	Dup
	37	Return'.
	self assert: (block value: 9) equals: '9: 362880'!

testValueWithArguments
	| hash |
	hash := self identityHash.
	
	[:a |
	self assert: self identityHash equals: hash.
	self assert: a identicalTo: 1]
			valueWithArguments: #(1).
	
	[:a :b |
	self assert: self identityHash equals: hash.
	self assert: a identicalTo: 1.
	self assert: b identicalTo: 2]
			valueWithArguments: #(1 2).
	
	[:a :b :c |
	self assert: self identityHash equals: hash.
	self assert: a identicalTo: 1.
	self assert: b identicalTo: 2.
	self assert: c identicalTo: 3]
			valueWithArguments: #(1 2 3).
	
	[:a :b :c :d |
	self assert: self identityHash equals: hash.
	self assert: a identicalTo: 1.
	self assert: b identicalTo: 2.
	self assert: c identicalTo: 3.
	self assert: d identicalTo: 4]
			valueWithArguments: #(1 2 3 4).
	self should: [[3 + 4] valueWithArguments: #(1)] raise: Error.
	self shouldnt: [[3 + 4] valueWithArguments: #()] raise: Error.
	self
		should: [[3 + 4] valueWithArguments: #(1)]
		raise: Error
		matching: [:err | err description = 'Block expects 0 argument(s), 1 given'].
	self
		should: [[:i | 3 + 4] valueWithArguments: #(1 2)]
		raise: Error
		matching: [:err | err description = 'Block expects 1 argument(s), 2 given']! !

!Kernel.Tests.BlockClosureTest categoriesForMethods!
blockWithCopiedValue:!helpers!private! !
nestedReturn!helpers!private! !
nestedReturn1!helpers!private! !
nestedReturn2!helpers!private! !
nestedReturn3!helpers!private! !
testCopyingBlock!public!unit tests! !
testCull!public!tests / evaluating! !
testCullCull!public!tests / evaluating! !
testCullCullCull!public!tests / evaluating! !
testCullCullCullCull!public!tests / evaluating! !
testEmptyBlock!public!unit tests! !
testEnsure!public!unit tests! !
testEqualityOfBlocksFromSameMethod!public!unit tests! !
testExceptionInEnsure!public!unit tests! !
testNesting!public!unit tests! !
testNoArguments!public!unit tests! !
testOneArgument!public!unit tests! !
testRecursiveBlock!public!unit tests! !
testStbUpgradeFromVersion0!public!unit tests! !
testValueWithArguments!public!unit tests! !
!

