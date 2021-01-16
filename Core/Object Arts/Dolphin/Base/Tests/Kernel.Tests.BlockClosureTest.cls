"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.BlockClosureTest'
	instanceVariableNames: 'x'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.BlockClosureTest guid: (Core.GUID fromString: '{346b84aa-d94e-4ee6-9461-5195ef00255b}')!
Kernel.Tests.BlockClosureTest comment: ''!
!Kernel.Tests.BlockClosureTest categoriesForClass!Unclassified! !
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
!Kernel.Tests.BlockClosureTest categoriesFor: #blockWithCopiedValue:!helpers!private! !
!Kernel.Tests.BlockClosureTest categoriesFor: #nestedReturn!helpers!private! !
!Kernel.Tests.BlockClosureTest categoriesFor: #nestedReturn1!helpers!private! !
!Kernel.Tests.BlockClosureTest categoriesFor: #nestedReturn2!helpers!private! !
!Kernel.Tests.BlockClosureTest categoriesFor: #nestedReturn3!helpers!private! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testCopyingBlock!public!unit tests! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testCull!public!tests / evaluating! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testCullCull!public!tests / evaluating! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testCullCullCull!public!tests / evaluating! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testCullCullCullCull!public!tests / evaluating! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testEmptyBlock!public!unit tests! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testEnsure!public!unit tests! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testEqualityOfBlocksFromSameMethod!public!unit tests! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testNesting!public!unit tests! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testNoArguments!public!unit tests! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testOneArgument!public!unit tests! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testRecursiveBlock!public!unit tests! !
!Kernel.Tests.BlockClosureTest categoriesFor: #testValueWithArguments!public!unit tests! !

