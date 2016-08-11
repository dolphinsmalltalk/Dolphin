"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #VMTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
VMTest guid: (GUID fromString: '{D03F75A2-8C1C-4559-8177-EFF37D37A6E8}')!
VMTest comment: 'Test the VM primitives and other VM related operations.

SUnitBrowser openOnTestCase: self'!
!VMTest categoriesForClass!Unclassified! !
!VMTest methodsFor!

assertImmutableAtPut: anObject 
	self assert: anObject isImmutable.
	self should: [anObject at: 0 put: $x] raise: BoundsError.
	self should: [anObject at: anObject size + 1 put: $x] raise: BoundsError.
	1 to: anObject size
		do: [:each | self should: [anObject at: each put: $x] raise: Processor constWriteSignal]!

assertImmutableBasicAtPut: anObject 
	self assert: anObject isImmutable.
	self should: [anObject basicAt: 0 put: $x] raise: BoundsError.
	self should: [anObject basicAt: anObject size + 1 put: $x] raise: BoundsError.
	1 to: anObject size
		do: [:each | self should: [anObject basicAt: each put: $x] raise: Processor constWriteSignal]!

assertImmutableInstVarAtPut: anObject 
	| size |
	self assert: anObject isImmutable.
	self should: [anObject instVarAt: 0 put: $x] raise: BoundsError.
	size := anObject class instSize + anObject basicSize.
	self should: [anObject instVarAt: size + 1 put: $x] raise: BoundsError.
	1 to: size
		do: [:each | self should: [anObject instVarAt: each put: $x] raise: Processor constWriteSignal]!

assertImmutableResize: anObject 
	self assert: anObject isImmutable.
	"Should get an error on any resize attempt, whether doesn't change size, grows or shrinks"
	self should: [anObject resize: anObject size] raise: Processor constWriteSignal.
	self should: [anObject resize: anObject size + 1] raise: Processor constWriteSignal.
	self should: [anObject resize: anObject size - 1] raise: Processor constWriteSignal!

earlyTermination: aBoolean 
	"N.B. Timing is critical to much of this, so its not going to be possible to debug through it. Its really only to show up
	problems in the VM, so debugging at the Smalltalk level is not terribly useful anyway."

	"1) Call is terminated before completion"

	| proc a aCopy state list |
	self assert: Processor pendingTerminations isEmpty
		description: 'Previous overlapped calls still not terminated'.
	proc := 
			[a := 1.
			
			[a := 2.
			KernelLibrary default sleep: 50] ifCurtailed: [a := 0].
			a := 3] 
					forkAt: Processor userInterruptPriority.	"High priority background proc runs but then blocks..."
	self assert: proc isWaiting description: 'Proc should be blocked on the overlapped call semaphore'.
	self assert: a == 2 description: 'Not at stage 2'.
	aBoolean ifTrue: [Processor sleep: 2].
	proc terminate.
	aCopy := a.
	list := proc suspendingList.
	state := proc state.
	state == #dead 
		ifTrue: [self assert: aCopy == 0 | (aCopy == 3)]
		ifFalse: 
			["On occasion NT will put Dolphin to sleep for 50mS+ and consequentlty the Process will have finished up anyway"

			"The Process will not be able to terminate until the overlapped call completes"
			| count |
			self 
				assert: (list == Processor pendingTerminations or: [list == (proc instVarNamed: 'threadSync')]).
			"a will still be run, because the VM will not reschedule the process to run the curtailment block until the overlapped
		call can be terminated."
			self assert: aCopy == 2.

			"Let the sleep: complete (allow a reasonable period so we can be fairly sure  it does)"
			count := 0.
			[a ~= 0 and: [count < 100]] whileTrue: 
					[Processor sleep: 5.
					count := count + 1].
			"The curtailment block should now have run"
			self assert: a == 0.
			"and the process should have died"
			self assert: proc isTerminated.
			self assert: Processor pendingTerminations isEmpty]!

exerciseReplaceElementsOf: targetCollection from: startInteger to: stopInteger with: sourceCollection startingAt: startAtInteger
	| fieldsBefore fieldsAfter captureFields expected target |
	captureFields := [:obj | (1 to: obj class instSize) collect: [:i | obj instVarAt: i]].
	fieldsBefore := captureFields value: targetCollection.
	target := targetCollection copy.
	target
		replaceFrom: startInteger
		to: stopInteger
		with: sourceCollection
		startingAt: startAtInteger.
	"The fixed fields should not have been touched"
	fieldsAfter := captureFields value: target.
	self assert: fieldsAfter = fieldsBefore.
	"Build the expected result using low-level operations to avoid inadvertently using the primitive under test"
	expected := targetCollection class ofSize: targetCollection size.
	1 to: startInteger - 1 do: [:i | expected at: i put: (targetCollection at: i)].
	startInteger to: stopInteger do: [:i | expected at: i put: (sourceCollection at: i - startInteger + startAtInteger)].
	stopInteger + 1 to: targetCollection size do: [:i | expected at: i put: (targetCollection at: i)].
	"Did it work?"
	self assert: target = expected!

exerciseReplaceElementsOf: targetCollection with: sourceCollection
	| target |
	targetCollection isImmutable: true.

	"Immutable target"
	self should: 
			[sourceCollection
				replaceElementsOf: targetCollection
				from: 1
				to: targetCollection size
				startingAt: 1]
		raise: Processor constWriteSignal.

	"Move first of source to first of target"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 1
		to: 1
		with: sourceCollection
		startingAt: 1.

	"Move last of source to first of target"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 1
		to: 1
		with: sourceCollection
		startingAt: sourceCollection size.

	"First over last"
	self
		exerciseReplaceElementsOf: targetCollection
		from: targetCollection size
		to: targetCollection size
		with: sourceCollection
		startingAt: 1.

	"Move two from middle of source to middle of target"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 2
		to: 3
		with: sourceCollection
		startingAt: 3.

	"From 2 to end of source over whole target"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 1
		to: targetCollection size
		with: sourceCollection
		startingAt: 2.

	"Complete overwrite"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 1
		to: targetCollection size
		with: sourceCollection
		startingAt: 1.

	"Move last of target to middle of source"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 2
		to: 2
		with: sourceCollection
		startingAt: sourceCollection size.

	"Last two from source over last two from target"
	self
		exerciseReplaceElementsOf: targetCollection
		from: targetCollection size - 1
		to: targetCollection size
		with: sourceCollection
		startingAt: sourceCollection size - 1.

	"Shuffle down - needs to be done forwards, or will get all 5's"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 1
		to: targetCollection size - 1
		with: targetCollection
		startingAt: 2.

	"Shuffle up - needs to be done in reverse, or will get all 1's"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 2
		to: targetCollection size
		with: targetCollection
		startingAt: 1.

	"No-op move over self"
	self
		exerciseReplaceElementsOf: targetCollection
		from: 1
		to: targetCollection size
		with: targetCollection
		startingAt: 1.

	"StartAt = end, count = 2 (source bounds error)"
	target := targetCollection copy.
	self should: 
			[target
				replaceFrom: 1
				to: 2
				with: sourceCollection
				startingAt: sourceCollection size]
		raise: BoundsError.

	"Off end of target"
	target := targetCollection copy.
	self should: 
			[target
				replaceFrom: 2
				to: target size + 1
				with: sourceCollection
				startingAt: 1]
		raise: BoundsError.

	"Overlapping out of bounds"
	target := targetCollection copy.
	self should: 
			[target
				replaceFrom: 1
				to: 5
				with: target
				startingAt: 2]
		raise: BoundsError.
	self should: 
			[target
				replaceFrom: 2
				to: 6
				with: target
				startingAt: 1]
		raise: BoundsError!

getCPUTime
	"Answer the total CPU time consumed since Dolphin was started, in milliseconds."

	| lib user kernel creation exit |
	creation := FILETIME new.
	exit := FILETIME new.
	user := FILETIME new.
	kernel := FILETIME new.
	lib := KernelLibrary default.
	lib 
		getThreadTimes: lib getCurrentThread
		lpCreationTime: creation
		lpExitTime: exit
		lpKernelTime: kernel
		lpUserTime: user.
	^(kernel asInteger + user asInteger) // 10000!

isGPF: gpf reading: aBoolean address: anAddress 
	| address isReading info |
	info := gpf exceptionRecord information.
	isReading := (info at: 1) = 0.
	address := info at: 2.
	^(isReading eqv: aBoolean) and: [address = anAddress]!

suspendAndTerminate
	"N.B. Timing is critical to much of this, so its not going to be possible to debug through it. Its really only to show up
	problems in the VM, so debugging at the Smalltalk level is not terribly useful anyway."

	| proc a i |
	"1) Call requests completion, but is suspended before Interpreter allows it to complete, then terminated"
	self assert: Processor pendingTerminations isEmpty.

	proc := [a := 1. KernelLibrary default sleep: 10. a := 2] forkAt: Processor userInterruptPriority.	"High priority background proc runs but then blocks..."
	self assert: (proc isWaiting).		"proc should be blocked on the overlapped call semaphore"
	self assert: a == 1.
	proc suspend.				"suspend it before it gets a chance to queue its termination request"
	self assert: (proc isSuspended).
	Processor sleep: 20.			"wait for the overlapped call to complete"
	self assert: (proc isSuspended).
	self assert: a ==1.
	proc terminate.
	i := 1.
	[Processor sleep: 10. proc isTerminated or: [i > 100]] whileFalse: [i := i + 1].
	self assert: proc isTerminated.
	self assert: a == 1.

	self assert: Processor pendingTerminations isEmpty.

	"2) Ditto, but resumed and so allowed to complete"!

testBSTRArg
	"#1377 - Make sure there is no problem in the VM's automatic conversion of a string to a BSTR.
	In an unpatched VM this typically crashes the whole system."
	| dom |
	dom := IXMLDOMDocument new.
	1000 timesRepeat: 
			[| instr |
			instr := dom createProcessingInstruction: 'ATarget' data: 'Some data'.
			self assert: instr data = 'Some data'.
			self assert: instr target = 'ATarget'.
			instr free]!

testCRTFault
	"Tests that the VM sends an interrupt when the CRT is passed an invalid parameter and calls
	the invalid parameter handler (issue #59). On an unfixed V2015 VM this will just crash."

	self 
		should: [CRTLibrary default _close: -1]
		raise: CRTError
		matching: [:err | err errno = EBADF]!

testDwordAtOffsetPut
	| bytes dword max |
	max := 12.
	4 to: max
		by: 4
		do: 
			[:each | 
			bytes := ByteArray new: each - 1.
			self should: [bytes dwordAtOffset: each - 4 put: 1] raise: BoundsError.
			bytes := ByteArray new: each.
			"This large integer will be 4-bytes long"
			dword := (2 raisedToInteger: 31) - 1.
			self assert: dword isImmutable.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: (bytes dwordAtOffset: each - 4) = dword.
			"This large integer will be 8-bytes long"
			dword := dword + 1.
			self assert: dword isImmutable.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: (bytes dwordAtOffset: each - 4) = dword.
			dword := 16rFFFFFFFF.
			self assert: dword isImmutable.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: bytes = ((ByteArray new: each - 4) , #[16rFF 16rFF 16rFF 16rFF]).
			bytes dwordAtOffset: each - 4 put: #[16rAA 16rBB 16rCC 16rDD].
			self assert: (bytes dwordAtOffset: each - 4) = 16rDDCCBBAA.
			dword := DWORD fromInteger: 16r11223344.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: (bytes dwordAtOffset: each - 4) = 16r11223344.
			dword isImmutable: true.
			bytes := ByteArray new: each.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: (bytes dwordAtOffset: each - 4) = 16r11223344.
			bytes := ByteArray new: each.
			bytes isImmutable: true.
			self should: [bytes dwordAtOffset: each - 4 put: 1] raise: Processor constWriteSignal]!

testEvaluationOrder
	| i |
	i := 2.
	self assert: (3 between: i and: (i := 4))!

testGPFTrap
	""

	self 
		should: [ExternalAddress new dwordAtOffset: 0]
		raise: GPFault
		matching: 
			[:gpf | 
			self 
				isGPF: gpf
				reading: true
				address: 0].
	self 
		should: [ExternalAddress new dwordAtOffset: 0 put: 1]
		raise: GPFault
		matching: 
			[:gpf | 
			self 
				isGPF: gpf
				reading: false
				address: 0]!

testImmutableAtPut
	#(#(1 2 3) #[1 2 3] 'abc') do: 
			[:each | 
			| a |
			self assertImmutableAtPut: each.
			a := each copy.
			self assert: a isImmutable not.
			1 to: 3 do: [:i | a at: i put: (a at: 3 - i + 1)].
			a isImmutable: true.
			self assertImmutableAtPut: a].
	self assertImmutableAtPut: #abc!

testImmutableBasicAtPut
	#(#(1 2 3) #[1 2 3] 'abc' 1.0e38) do: 
			[:each | 
			| a |
			self assertImmutableBasicAtPut: each.
			a := each shallowCopy.
			self assert: a isImmutable not.
			1 to: 3 do: [:i | a basicAt: i put: (a basicAt: 3 - i + 1)].
			a isImmutable: true.
			self assertImmutableBasicAtPut: a].
	self assertImmutableBasicAtPut: #abc!

testImmutableBufferAtPuts
	| b |
	b := #[0 0 0 0 0 0 0 0 0 0 0 0].
	self should: [b byteAtOffset: 0 put: 1] raise: Processor constWriteSignal.
	self should: [b sbyteAtOffset: 0 put: 1] raise: Processor constWriteSignal.
	self should: [b wordAtOffset: 0 put: 1] raise: Processor constWriteSignal.
	self should: [b swordAtOffset: 0 put: 1] raise: Processor constWriteSignal.
	self should: [b dwordAtOffset: 0 put: 1] raise: Processor constWriteSignal.
	self should: [b sdwordAtOffset: 0 put: 1] raise: Processor constWriteSignal.
	self should: [b qwordAtOffset: 0 put: 1] raise: Processor constWriteSignal.
	self should: [b sqwordAtOffset: 0 put: 1] raise: Processor constWriteSignal.
	self should: [b floatAtOffset: 0 put: 1.23] raise: Processor constWriteSignal.
	self should: [b doubleAtOffset: 0 put: 1.23] raise: Processor constWriteSignal!

testImmutableInstVarAtPut
	| instances |
	instances := OrderedCollection withAll: #(#(1 2 3) #[1 2 3] 'abc').
	"The compiler test class has a lot of named iv's"
	instances add: ((CompilerTestClasses current testClass new)
				isImmutable: true;
				yourself).
	"Sets have named and indexable variables"
	instances add: ((self class methodDictionary values asSet)
				isImmutable: true;
				yourself).
	instances do: 
			[:each | 
			| a size |
			self assertImmutableInstVarAtPut: each.
			a := each copy.
			self assert: a isImmutable not.
			size := a class instSize + a basicSize.
			1 to: size do: [:i | a instVarAt: i put: (a instVarAt: size - i + 1)].
			a isImmutable: true.
			self assertImmutableInstVarAtPut: a].
	self assertImmutableInstVarAtPut: #abc!

testImmutableNextPut
	#(#[1 2 3] 'abc' #(1 2 3)) do: 
			[:s | 
			| strm |
			self assertImmutableAtPut: s.
			strm := WriteStream on: s.
			self should: [strm nextPut: s last] raise: Processor constWriteSignal]!

testImmutableNextPutAll
	#(#[1 2 3] 'abc' #(1 2 3)) do: 
			[:s | 
			| strm |
			self assertImmutableAtPut: s.
			strm := WriteStream on: s.
			self should: [strm nextPutAll: (s copyFrom: 2 to: 3)] raise: Processor constWriteSignal]!

testImmutableReplacePrimitives
	#(#[1 2 3] 'abc' #(1 2 3)) do: 
			[:s | 
			self assertImmutableAtPut: s.
			self should: 
					[s 
						replaceFrom: 1
						to: 2
						with: (s copyFrom: 2 to: 3)]
				raise: Processor constWriteSignal]!

testImmutableResize
	#(#(1 2 3) #[1 2 3] 'abcd') do: [:each | self assertImmutableResize: each]!

testImmutableStringCompare
	| s1 s2 |
	s1 := 'abc'.
	s2 := String 
				with: $a
				with: $b
				with: $c.
	self assert: s1 = s2!

testImmutableWriteAccessors
	| class inst |
	class := CompilerTestClasses current testClass.
	inst := (class new)
				isImmutable: true;
				yourself.
	"Note that the primitive write accessor will fail and fall back on executing the method bytecodes, which will fail sending #errorInstVarAt:put:"
	class instVarNames 
		do: [:each | self should: [inst perform: (each , ':') asSymbol with: each] raise: Processor constWriteSignal]!

testMakeLargeUnsigned
	| bytes |
	bytes := ByteArray new: 8.
	self assert: (VMLibrary default makeLargeUnsigned: bytes) == 0.
	bytes := ByteArray new: 8.
	bytes qwordAtOffset: 0 put: 1.
	self assert: (VMLibrary default makeLargeUnsigned: bytes) == 1.
	bytes := ByteArray new: 8.
	bytes qwordAtOffset: 0 put: SmallInteger maximum.
	self assert: (VMLibrary default makeLargeUnsigned: bytes) == SmallInteger maximum.
	bytes := ByteArray new: 8.
	bytes qwordAtOffset: 0 put: SmallInteger minimum.
	self assert: (VMLibrary default makeLargeUnsigned: bytes) 
				= ((2 raisedToInteger: 64) + SmallInteger minimum).
	bytes := ByteArray new: 8.
	bytes qwordAtOffset: 0 put: (2 raisedToInteger: 31).
	self assert: (VMLibrary default makeLargeUnsigned: bytes) = (2 raisedToInteger: 31).
	self assert: (VMLibrary default makeLargeUnsigned: Float fmax) 
				= (#[255 255 255 255 255 255 239 127] qwordAtOffset: 0).
	self assert: (VMLibrary default makeLargeUnsigned: Float fminNormalized) 
				= (Float fminNormalized shallowCopy becomeA: LargeInteger).
	"#1130"
	#(16r7FFFFFFFFFFFFFFF 16rFFFFFFFFFFFFFFFF) 
		do: [:each | (VMLibrary default makeLargeUnsigned: each) = each]!

testMustBeBoolean
	| trueClass falseClass pseudoTrue pseudoFalse |
	"Short jump if false +3"
	self should: [1 ifTrue: [1] ifFalse: [2]] raise: Error.
	"Short jump if false +5"
	self should: [1 ifTrue: [1 + 2] ifFalse: [2]] raise: Error.
	"Short jump if false +8"
	self should: [1 ifTrue: [1 + 2 + 3] ifFalse: [2]] raise: Error.
	"Near jump if false +8"
	self should: [1 ifTrue: [1 + 2 + 3 + 4] ifFalse: [2]] raise: Error.
	"Near jump if true +2"
	self should: [1 ifFalse: [2] ifTrue: [1]] raise: Error.
	self should: [1 ifTrue: [2]] raise: Error.
	self should: [1 ifFalse: [2]] raise: Error.
	self should: [[1] whileTrue] raise: Error.
	self should: [[1] whileTrue: [1 + 2]] raise: Error.
	self should: [[1] whileFalse] raise: Error.
	self should: [[1] whileFalse: [1 + 2]] raise: Error.
	trueClass := MustBeBooleanTestClasses current trueClass.
	falseClass := MustBeBooleanTestClasses current falseClass.
	pseudoTrue := trueClass new.
	pseudoFalse := falseClass new.
	self assert: (pseudoTrue and: [true]).
	self deny: (pseudoFalse and: [true]).
	"short jump if false"
	self assert: (pseudoTrue ifTrue: [1] ifFalse: [2]) = 1.
	self assert: (pseudoFalse ifTrue: [1] ifFalse: [2]) = 2.
	"Near jump if false"
	self assert: (pseudoTrue ifTrue: [1 + 2 + 3 + 4] ifFalse: [2]) = (1 + 2 + 3 + 4).
	self assert: (pseudoFalse ifTrue: [1 + 2 + 3 + 4] ifFalse: [2]) = 2!

testOverlappedCallsSuspendAndTerminate
	5 timesRepeat: [self suspendAndTerminate]!

testOverlappedCallTermination
	"N.B. Timing is critical to much of this, so its not going to be possible to debug through it. Its really only to show up
	problems in the VM, so debugging at the Smalltalk level is not terribly useful anyway."

	"1) Call is terminated before completion, before it has even started in fact"
	1 to: 10 do: [:i | self earlyTermination: false].
	"2) Call is terminated before completion, but is allowed to start"
	1 to: 10 do: [:i | self earlyTermination: true]!

testPrimitiveAt
	"First some error cases - accessing non-indexable objects"

	| array |
	self
		should: [Array at: 1]
		raise: Error
		matching: [:ex | ex messageText = 'not indexable'].
	self
		should: [Array at: 0]
		raise: Error
		matching: [:ex | ex messageText = 'not indexable'].
	self
		should: [Array at: nil]
		raise: Error
		matching: [:ex | ex messageText = 'not indexable'].
	array := Array with: 1.
	self should: [(array at: 1) == 1].
	"Some tests are repeated with a new array in case of different behaviour resulting from caching"
	self should: [(array at: 1) == 1].
	"Now attempt some out of bounds accesses"
	self should: [array at: 0] raise: BoundsError.
	self should: [array at: 2] raise: BoundsError.
	array := Array with: 1.
	self should: [array at: 0] raise: BoundsError.
	array := Array with: 1.
	self should: [array at: 2] raise: BoundsError.
	self should: [array at: SmallInteger maximum] raise: BoundsError.
	self should: [array at: SmallInteger minimum] raise: BoundsError.

	"Repeat for an object with one named instance variable and no #at: override"
	array := MourningWeakArray with: 1.
	self should: [(array at: 1) == 1].
	self should: [(array at: 1) == 1].
	self should: [array at: 0] raise: BoundsError.
	self should: [array at: 2] raise: BoundsError.
	array := Array with: 1.
	self should: [array at: 0] raise: BoundsError.
	array := Array with: 1.
	self should: [array at: 2] raise: BoundsError.
	self should: [array at: SmallInteger maximum] raise: BoundsError.
	self should: [array at: SmallInteger minimum] raise: BoundsError.

	"And again for one with a number of named instance variables (a method)"
	array := Object compiledMethodAt: #addDependent:.
	self should: [(array at: 1) == #getDependents].
	self should: [(array at: 1) == #getDependents].
	self should: 
			[| lit |
			lit := array at: 2.
			lit == WeakArray or: [(lit isKindOf: VariableBinding) and: [lit value == WeakArray]]].
	self should: [(array at: 3) == #setDependents:].
	self should: [(array at: array size) == #add:].
	self should: [array at: 0] raise: BoundsError.
	self should: [array at: array size + 1] raise: BoundsError.
	self should: [array at: SmallInteger maximum] raise: BoundsError.
	self should: [array at: SmallInteger minimum] raise: BoundsError.

	"LargeIntegers"
	self should: [array at: SmallInteger maximum + 1] raise: BoundsError.
	self should: [array at: (2 raisedToInteger: 31) - 1] raise: BoundsError.
	self should: [array at: (2 raisedToInteger: 31)] raise: BoundsError.
	self should: [array at: (2 raisedToInteger: 32) - 1] raise: BoundsError.
	self should: [array at: (2 raisedToInteger: 32)] raise: BoundsError.
	self should: [array at: SmallInteger minimum - 1] raise: BoundsError.
	self should: [array at: (-2 raisedToInteger: 31)] raise: BoundsError.

	"Try accessing with non-integer indices"
	self
		should: [array at: $1]
		raise: Error
		matching: [:ex | ex messageText = 'Index: $1 is not an integer'].
	self
		should: [array at: '1']
		raise: Error
		matching: [:ex | ex messageText = 'Index: ''1'' is not an integer'].
	self
		should: [array at: nil]
		raise: Error
		matching: [:ex | ex messageText = 'Index: nil is not an integer'].
	self
		should: [array at: #[1]]
		raise: Error
		matching: [:ex | ex messageText = 'Index: #[1] is not an integer'].
	self
		should: [array at: #'1']
		raise: Error
		matching: [:ex | ex messageText = 'Index: #''1'' is not an integer'].
	self
		should: [array at: #(1)]
		raise: Error
		matching: [:ex | ex messageText = 'Index: #(1) is not an integer'].
	self
		should: [array at: #(1)]
		raise: Error
		matching: [:ex | ex messageText = 'Index: #(1) is not an integer'].
	array := Array with: 'a' with: 'b'.
	self should: [(array at: 1) = 'a'].
	self should: [(array at: 1) = 'a'].
	self should: [(array at: 2) = 'b'].
	self should: [array at: 0] raise: BoundsError.
	self should: [array at: 3] raise: BoundsError.
	array := MourningWeakArray with: 'a' with: 'b'.
	self should: [(array at: 1) = 'a'].
	self should: [(array at: 1) = 'a'].
	self should: [(array at: 2) = 'b'].
	self should: [array at: 0] raise: BoundsError.
	self should: [array at: 3] raise: BoundsError.
	array := (-100 to: 100) asArray.
	-100 to: 100 do: [:i | self should: [(array at: i + 100 + 1) == i]]!

testPrimitiveAtPut
	"First some error cases - accessing non-indexable objects"

	| array |
	self
		should: [Array at: 1 put: nil]
		raise: Error
		matching: [:ex | ex messageText = 'not indexable'].
	self
		should: [Array at: 0 put: nil]
		raise: Error
		matching: [:ex | ex messageText = 'not indexable'].
	self
		should: [Array at: nil put: nil]
		raise: Error
		matching: [:ex | ex messageText = 'not indexable'].
	array := Array with: 1.
	self should: [(array at: 1 put: 1) == 1 and: [(array at: 1) == 1]].
	"One second access, will be in the cache"
	self should: [(array at: 1 put: '1') = '1' and: [(array at: 1) = '1']].

	"Now attempt some out of bounds accesses"
	self should: [array at: 0 put: '0'] raise: BoundsError.
	self should: [array at: 2 put: '2'] raise: BoundsError.
	array := Array with: 1.
	self should: [array at: 0 put: '0'] raise: BoundsError.
	array := Array with: 1.
	self should: [array at: 2 put: '2'] raise: BoundsError.
	self should: [array at: SmallInteger maximum put: nil] raise: BoundsError.
	self should: [array at: SmallInteger minimum put: nil] raise: BoundsError!

testPrimitiveIsNullBytes
	| addr handle |
	addr := ExternalAddress new.
	self assert: addr isNull.
	addr := ExternalAddress fromInteger: 1.
	self assert: addr isNull not.
	addr := ExternalAddress fromInteger: -1.
	self assert: addr isNull not.
	handle := ExternalHandle new.
	self assert: handle isNull.
	handle := ExternalHandle fromInteger: 1.
	self assert: handle isNull not.
	handle := ExternalHandle fromInteger: -1.
	self assert: handle isNull not.

	"The primitive will fail as will backup code"
	0 to: 3
		do: 
			[:each | 
			| bytes |
			bytes := DWORDBytes newFixed: each.
			self should: [bytes isNull] raise: BoundsError].

	"The primitive will fail, but the backup code will work"
	5 to: 9
		do: 
			[:each | 
			| bytes |
			bytes := DWORDBytes newFixed: each.
			self assert: bytes isNull]!

testPrimitiveReplaceElements
	self exerciseReplaceElementsOf: #($a $b $c $d $e) with: #(1 2 3 4 5 6).
	self exerciseReplaceElementsOf: #($a $b $c $d $e) with: #(1 2 3 4 5 6).
	self exerciseReplaceElementsOf: #($a $b $c $d $e)
		with: ((#(2 3 4 5 6) asOrderedCollection)
				addFirst: 1;
				yourself).
	self exerciseReplaceElementsOf: ((#(nil $a $b $c $d $e) asOrderedCollection)
				removeFirst;
				yourself)
		with: #(1 2 3 4 5 6).
	self exerciseReplaceElementsOf: ((#($b $c $d $e) asOrderedCollection)
				addFirst: $a;
				yourself)
		with: ((#(0 1 2 3 4 5 6) asOrderedCollection)
				removeFirst;
				yourself)!

testPrimitiveResume
	| a b c d e sem state list |
	sem := Semaphore new.
	a := 
			[state := 'a1'.
			sem wait.
			state := state , ', a2'.
			Processor suspendActive.
			state := state , ', a3'.
			Processor suspendActive.
			state := state , ', a4'.
			Processor suspendActive.
			state := state , ', a5']
					forkAt: Processor userInterruptPriority.
	self assert: 'a1' equals: state.
	self assert: a isWaiting.
	self assert: a equals: sem first.
	a suspend.
	self assert: a isSuspended.
	self assert: sem isEmpty.
	self assert: 'a1' equals: state.
	b := 
			[a resume: sem.
			state := state , ', b'] forkAt: Processor userInterruptPriority.
	"Regression test for #Process>>resume: suspends calling/active process #89"
	self assert: b isDead.
	self assert: 'a1, b' equals: state.
	"Check that the process was 'resumed' correctly onto the requested list"
	self assert: a isWaiting.
	self assert: a equals: sem first.
	"And that it is runnable."
	sem signal.
	self assert: 'a1, b, a2' equals: state.
	self assert: a isSuspended.
	list := (Processor instVarNamed: 'processLists') at: a priority.
	"Resumed process is schedulable, but lower priority than the active process, so waits."
	c := 
			[a resume: list.
			state := state , ', c'] forkAt: Processor lowIOPriority.
	self assert: 'a1, b, a2, c, a3' equals: state.
	self assert: a isSuspended.
	self assert: c isDead.
	"Resumed process is same priority, and although we expect a rescheduling it is pushed on the back of the list, so still waits"
	d := 
			[a resume: list.
			state := state , ', d'] forkAt: a priority.
	self assert: 'a1, b, a2, c, a3, d, a4' equals: state.
	self assert: d isDead.
	self assert: a isSuspended.
	"Resumed process is higher priority, so resumes immediately."
	e := 
			[a resume: list.
			state := state , ', e'] forkAt: a priority - 1.
	self assert: 'a1, b, a2, c, a3, d, a4, a5, e' equals: state.
	self assert: e isDead.
	self assert: a isDead!

testPrimitiveStringAt
	| array |
	
	array := String with: $1.
	self should: [(array at: 1) == $1].
	"Some tests are repeated with a new array in case of different behaviour resulting from caching"
	self should: [(array at: 1) == $1].
	self should: [array at: 0] raise: BoundsError.
	self should: [array at: 2] raise: BoundsError.
	array := String with: $1.
	self should: [array at: 0] raise: BoundsError.
	array := String with: $1.
	self should: [array at: 2] raise: BoundsError.

	self should: [array at: SmallInteger maximum] raise: BoundsError.
	self should: [array at: SmallInteger minimum] raise: BoundsError.

	"LargeIntegers"
	self should: [array at: SmallInteger maximum+1] raise: BoundsError.
	self should: [array at: (2 raisedToInteger: 31)-1] raise: BoundsError.
	self should: [array at: (2 raisedToInteger: 31)] raise: BoundsError.
	self should: [array at: (2 raisedToInteger: 32)-1] raise: BoundsError.
	self should: [array at: (2 raisedToInteger: 32)] raise: BoundsError.
	self should: [array at: SmallInteger minimum-1] raise: BoundsError.
	self should: [array at: (-2 raisedToInteger: 31)] raise: BoundsError.


	array := 'ab' copy.
	self should: [(array at: 1) == $a].
	self should: [(array at: 1) == $a].
	self should: [(array at: 2) == $b].
	self should: [array at: 0] raise: BoundsError.
	self should: [array at: 3] raise: BoundsError.

	"Try accessing with non-integer indices"
	self should: [array at: $1] raise: Error matching: [:ex | ex messageText = 'Index: $1 is not an integer'].
	self should: [array at: '1'] raise: Error matching: [:ex | ex messageText = 'Index: ''1'' is not an integer'].
	self should: [array at: nil] raise: Error matching: [:ex | ex messageText = 'Index: nil is not an integer'].
	self should: [array at: #[1]] raise: Error matching: [:ex | ex messageText = 'Index: #[1] is not an integer'].
	self should: [array at: #'1'] raise: Error matching: [:ex | ex messageText = 'Index: #''1'' is not an integer'].
	self should: [array at: #(1)] raise: Error matching: [:ex | ex messageText = 'Index: #(1) is not an integer'].
	self should: [array at: #(1)] raise: Error matching: [:ex | ex messageText = 'Index: #(1) is not an integer'].

	array := (0 to: 255) collect: [:i | Character value: i].
	0 to: 255 do: [:i | self should: [(array at: i+1) == (Character value: i)]].
!

testSignedFromUnsigned
	"Test SmallIntegers and 4 & 8 byte LargeIntegers"

	#(0 1 16r3FFFFFFF 16r40000000 16r7FFFFFFF 16r80000000 16rFFFFFFFF) do: 
			[:each | 
			| signed expected dword |
			self assert: each isImmutable.
			expected := each > 16r7FFFFFFF ifTrue: [each - 16rFFFFFFFF - 1] ifFalse: [each].
			signed := VMLibrary default signedFromUnsigned: each.
			self assert: signed = expected.
			each class == SmallInteger 
				ifFalse: 
					[dword := each + 1 - 1.
					self assert: dword isImmutable.
					signed := VMLibrary default signedFromUnsigned: dword.
					self assert: signed = expected.
					self assert: signed isImmutable]].
	self should: [VMLibrary default signedFromUnsigned: 16r100000000] raise: Error.
	self should: [VMLibrary default signedFromUnsigned: (2 raisedToInteger: 32) + 1] raise: Error! !
!VMTest categoriesFor: #assertImmutableAtPut:!private!unit tests! !
!VMTest categoriesFor: #assertImmutableBasicAtPut:!private!unit tests! !
!VMTest categoriesFor: #assertImmutableInstVarAtPut:!private!unit tests! !
!VMTest categoriesFor: #assertImmutableResize:!private!unit tests! !
!VMTest categoriesFor: #earlyTermination:!helpers!public! !
!VMTest categoriesFor: #exerciseReplaceElementsOf:from:to:with:startingAt:!private!unit tests! !
!VMTest categoriesFor: #exerciseReplaceElementsOf:with:!private!unit tests! !
!VMTest categoriesFor: #getCPUTime!helpers!private! !
!VMTest categoriesFor: #isGPF:reading:address:!helpers!private! !
!VMTest categoriesFor: #suspendAndTerminate!helpers!public! !
!VMTest categoriesFor: #testBSTRArg!public!unit tests! !
!VMTest categoriesFor: #testCRTFault!public!unit tests! !
!VMTest categoriesFor: #testDwordAtOffsetPut!public!unit tests! !
!VMTest categoriesFor: #testEvaluationOrder!public!unit tests! !
!VMTest categoriesFor: #testGPFTrap!public!unit tests! !
!VMTest categoriesFor: #testImmutableAtPut!public!unit tests! !
!VMTest categoriesFor: #testImmutableBasicAtPut!public!unit tests! !
!VMTest categoriesFor: #testImmutableBufferAtPuts!public!unit tests! !
!VMTest categoriesFor: #testImmutableInstVarAtPut!public!unit tests! !
!VMTest categoriesFor: #testImmutableNextPut!public!unit tests! !
!VMTest categoriesFor: #testImmutableNextPutAll!public!unit tests! !
!VMTest categoriesFor: #testImmutableReplacePrimitives!public!unit tests! !
!VMTest categoriesFor: #testImmutableResize!public!unit tests! !
!VMTest categoriesFor: #testImmutableStringCompare!public!unit tests! !
!VMTest categoriesFor: #testImmutableWriteAccessors!public!unit tests! !
!VMTest categoriesFor: #testMakeLargeUnsigned!public!unit tests! !
!VMTest categoriesFor: #testMustBeBoolean!public!unit tests! !
!VMTest categoriesFor: #testOverlappedCallsSuspendAndTerminate!public!unit tests! !
!VMTest categoriesFor: #testOverlappedCallTermination!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveAt!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveAtPut!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveIsNullBytes!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveReplaceElements!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveResume!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringAt!public!unit tests! !
!VMTest categoriesFor: #testSignedFromUnsigned!public!unit tests! !

!VMTest class methodsFor!

resources
	^Array with: MustBeBooleanTestClasses! !
!VMTest class categoriesFor: #resources!Accessing!public! !

