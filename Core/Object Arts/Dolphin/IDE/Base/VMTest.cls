"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #VMTest
	instanceVariableNames: 'expiryHandler'
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
VMTest guid: (GUID fromString: '{d03f75a2-8c1c-4559-8177-eff37d37a6e8}')!
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
	#(0 1 -1)
		do: [:i | self should: [anObject resize: anObject size + i] raise: Processor constWriteSignal]!

createPrimitiveMethod: anInteger in: aBehavior argCount: argc setsFailCode: aBoolean
	| method text |
	text := String writeStream.
	argc isZero
		ifTrue: [text nextPutAll: 'prim ']
		ifFalse: 
			[1 to: argc
				do: 
					[:i |
					text
						nextPutAll: 'op: operand';
						print: i;
						space]].
	text
		nextPutAll: '<primitive: ';
		print: anInteger;
		nextPutAll: '> ^''failed'''.
	aBoolean ifTrue: [text nextPutAll: ', Processor activeProcess primitiveFailureCode printString'].
	method := Compiler compile: text contents in: aBehavior.
	self assert: method ~~ nil.
	^method!

createPrimitiveMethodLike: aCompiledMethod setsFailCode: aBoolean
	^self
		createPrimitiveMethod: aCompiledMethod primitiveIndex
		in: aCompiledMethod methodClass
		argCount: aCompiledMethod argumentCount
		setsFailCode: aBoolean!

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
			KernelLibrary default sleep: 30] ifCurtailed: [a := 0].
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
			[a ~= 0 and: [count < 500]] whileTrue: 
					[Processor sleep: 1.
					count := count + 1].
			"The curtailment block should now have run"
			self assert: a == 0.
			"and the process should have died"
			self assert: proc isTerminated.
			self assert: Processor pendingTerminations isEmpty]!

elementsExpired: anInteger of: aMourningWeakObject
	expiryHandler value: anInteger value: aMourningWeakObject!

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

findCaller: aStackFrame in: aCompiledMethod
	| frame |
	frame := aStackFrame.
	[frame notNil and: [frame isBlockFrame or: [frame method ~~ aCompiledMethod]]]
		whileTrue: [frame := frame sender].
	^frame!

findFaultInterruptFrame: anException
	^self findCaller: anException raisingFrame in: ProcessorScheduler >> #vmi:list:no:with:!

isFault: anException raisedIn: aCompiledMethod receiver: anObject
	| frame |
	frame := self findFaultInterruptFrame: anException.
	^frame notNil and: 
			[| faultingFrame |
			faultingFrame := frame sender.
			faultingFrame notNil
				and: [faultingFrame receiver == anObject and: [faultingFrame method == aCompiledMethod]]]!

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

	| crt |
	crt := CRTLibrary default.
	self
		should: 
			[Processor enableAsyncEvents: false.
			crt _close: -1]
		raise: CRTError
		matching: 
			[:err |
			err errno = EBADF and: 
					["Verify that the fault is dispatched synchronously"
					self
						isFault: err
						raisedIn: CRTLibrary >> #_close:
						receiver: crt]]!

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

testExtCallRetHRESULT
	"Test that HRESULT return codes are translated into exceptions correctly."

	| method |
	method := Compiler
				compile: 'hresult: anInteger
	| proc |
	<stdcall: hresult AnswerDWORD sdword>
	proc := Processor activeProcess.
	^proc primitiveFailureCode -> proc primitiveFailureData'
				in: VMLibrary.
	#(0 1 16r3FFFFFFF 16r40000000 16r7FFFFFFF) do: 
			[:each |
			| result |
			result := method value: VMLibrary default withArguments: (Array with: each).
			self assert: result equals: each.
			self assert: each class == result class].
	"Negative HRESULTs should cause the primitive to fail with the failure data set to the HR code."
	#(-1 -16r40000000 -16r40000001 -16r80000000) do: 
			[:each |
			| result |
			result := method value: VMLibrary default withArguments: (Array with: each).
			self assert: result key equals: -1.
			self assert: result value equals: each.
			self assert: each class == result value class]!

testFPFaultInPrimitive
	"An FP fault occurring in a primitive should be reported in the primitive method, not some
	subsequently invoked method, even when interrupts are off."

	self
		should: 
			[Processor enableAsyncEvents: false.
			200 factorial asFloat]
		raise: FloatingPointException
		matching: 
			[:fpe |
			self
				isFault: fpe
				raisedIn: CRTLibrary >> #ldexp:exp:
				receiver: CRTLibrary default]!

testGPFTrap

	| nullPointer |
	nullPointer := ExternalAddress new.
	self
		should: 
			[Processor enableAsyncEvents: false.
			nullPointer dwordAtOffset: 0]
		raise: GPFault
		matching: 
			[:gpf |
			(self
				isGPF: gpf
				reading: true
				address: 0) and: 
						[self
							isFault: gpf
							raisedIn: ExternalAddress >> #dwordAtOffset:
							receiver: nullPointer]].
	self
		should: [nullPointer dwordAtOffset: 0 put: 1]
		raise: GPFault
		matching: 
			[:gpf |
			(self
				isGPF: gpf
				reading: false
				address: 0) and: 
						[self
							isFault: gpf
							raisedIn: ExternalAddress >> #dwordAtOffset:put:
							receiver: nullPointer]]!

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

testIndirectByteAtOffsetPrimitives
	| nullPointer b p |
	b := ByteArray newFixed: 3.
	p := b yourAddress asExternalAddress.
	#(0 1 127 128 255) do: 
			[:each |
			"Should be able to write any 32-bit integer value, and read it back"
			self assert: (p byteAtOffset: 1 put: each) equals: each.
			self assert: (b byteAtOffset: 1) equals: each.
			self assert: (b byteAtOffset: 0) equals: 0.
			self assert: (b byteAtOffset: 2) equals: 0].

	"Arg must be in range 0..255"
	#(-1 256) do: [:each | self should: [p byteAtOffset: 1 put: each] raise: Error].

	"This class of primitives had a bug whereby if the pointed at memory was inaccessible at the time of the read/write, then the primitive would corrupt the Smalltalk stack."
	nullPointer := 0 asExternalAddress.
	self
		should: 
			["Test with async events off to verify the fault interrupt is sent synchronously to the faulting frame"
			Processor enableAsyncEvents: false.
			nullPointer byteAtOffset: 0 put: 1]
		raise: GPFault
		matching: 
			[:ex |
			(self
				isGPF: ex
				reading: false
				address: 0) and: 
						[self
							isFault: ex
							raisedIn: ExternalAddress >> #byteAtOffset:put:
							receiver: nullPointer]].
	self
		should: 
			[Processor enableAsyncEvents: false.
			nullPointer byteAtOffset: 0]
		raise: GPFault
		matching: 
			[:gpf |
			(self
				isGPF: gpf
				reading: true
				address: 0) and: 
						[self
							isFault: gpf
							raisedIn: ExternalAddress >> #byteAtOffset:
							receiver: nullPointer]]!

testIndirectDwordAtOffsetPrimitives
	| nullPointer b p |
	b := ByteArray newFixed: 12.
	p := b yourAddress asExternalAddress.
	#(0 1 -1 ##(SmallInteger minimum) ##(SmallInteger maximum) ##(SmallInteger maximum + 1) ##(SmallInteger
		minimum - 1) 16rFFFFFFFF -16r80000000)
		do: 
			[:each |
			"Should be able to write any 32-bit integer value, and read it back"
			self assert: (p dwordAtOffset: 4 put: each) equals: each.
			self assert: (b dwordAtOffset: 4) equals: each asDword.
			self assert: (b dwordAtOffset: 0) equals: 0.
			self assert: (b dwordAtOffset: 8) equals: 0].

	"Error if arg requires more that 32-bits to represent as an unsigned int"
	#(16r100000000 -16r80000001) do: [:each | self should: [p sdwordAtOffset: 0 put: each] raise: Error].

	"This class of primitives had a bug whereby if the pointed at memory was inaccessible at the time of the read/write, then the primitive would corrupt the Smalltalk stack."
	nullPointer := 0 asExternalAddress.
	#(1 16r7FFFFFFF 16rFFFFFFFF) do: 
			[:each |
			self
				should: 
					["Test with async events off to verify the fault interrupt is sent synchronously to the faulting frame"
					Processor enableAsyncEvents: false.
					nullPointer dwordAtOffset: 0 put: each]
				raise: GPFault
				matching: 
					[:ex |
					(self
						isGPF: ex
						reading: false
						address: 0) and: 
								[self
									isFault: ex
									raisedIn: ExternalAddress >> #dwordAtOffset:put:
									receiver: nullPointer]]].
	self
		should: 
			[Processor enableAsyncEvents: false.
			nullPointer dwordAtOffset: 0]
		raise: GPFault
		matching: 
			[:gpf |
			(self
				isGPF: gpf
				reading: true
				address: 0) and: 
						[self
							isFault: gpf
							raisedIn: ExternalAddress >> #dwordAtOffset:
							receiver: nullPointer]]!

testIndirectSdwordAtOffsetPrimitives
	| nullPointer b p |
	b := ByteArray newFixed: 12.
	p := b yourAddress asExternalAddress.
	#(0 1 -1 ##(SmallInteger minimum) ##(SmallInteger maximum) ##(SmallInteger maximum + 1) ##(SmallInteger
		minimum - 1) 16r7FFFFFFF -16r80000000)
		do: 
			[:each |
			"Should be able to write any 32-bit integer value, and read it back"
			self assert: (p sdwordAtOffset: 4 put: each) equals: each.
			self assert: (b sdwordAtOffset: 4) equals: each.
			self assert: (b sdwordAtOffset: 0) equals: 0.
			self assert: (b sdwordAtOffset: 8) equals: 0].

	"If arg requires more than 32-bits to represent in 2's complement, then should be an error"
	#(16r80000000 -16r80000001) do: [:each | self should: [p sdwordAtOffset: 0 put: each] raise: Error].

	"This class of primitives had a bug whereby if the pointed at memory was inaccessible at the time of the read/write, then the primitive would corrupt the Smalltalk stack."
	nullPointer := 0 asExternalAddress.
	"Test with both SmallInteger and LargeInteger args as the primitive may have different code paths for these"
	#(1 16r7FFFFFFF) do: 
			[:each |
			self
				should: 
					["Test with async events off to verify the fault interrupt is sent synchronously to the faulting frame"
					Processor enableAsyncEvents: false.
					nullPointer sdwordAtOffset: 0 put: each]
				raise: GPFault
				matching: 
					[:ex |
					(self
						isGPF: ex
						reading: false
						address: 0) and: 
								[self
									isFault: ex
									raisedIn: ExternalAddress >> #sdwordAtOffset:put:
									receiver: nullPointer]]].
	self
		should: 
			[Processor enableAsyncEvents: false.
			nullPointer sdwordAtOffset: 0]
		raise: GPFault
		matching: 
			[:gpf |
			(self
				isGPF: gpf
				reading: true
				address: 0) and: 
						[self
							isFault: gpf
							raisedIn: ExternalAddress >> #sdwordAtOffset:
							receiver: nullPointer]]!

testIndirectSwordAtOffsetPrimitives
	| nullPointer b p |
	b := ByteArray newFixed: 6.
	p := b yourAddress asExternalAddress.
	#(0 -1 1 16r7FFF -16r8000) do: 
			[:each |
			"Should be able to write any 32-bit integer value, and read it back"
			self assert: (p swordAtOffset: 2 put: each) equals: each.
			self assert: (b swordAtOffset: 2) equals: each.
			self assert: (b swordAtOffset: 0) equals: 0.
			self assert: (b swordAtOffset: 4) equals: 0].

	"Error if arg requires more that 16-bits to represent as 2's complement signed int"
	#(16r10000 -16r8001) do: [:each | self should: [p swordAtOffset: 0 put: each] raise: Error].

	"This class of primitives had a bug whereby if the pointed at memory was inaccessible at the time of the read/write, then the primitive would corrupt the Smalltalk stack."
	nullPointer := 0 asExternalAddress.
	self
		should: 
			["Test with async events off to verify the fault interrupt is sent synchronously to the faulting frame"
			Processor enableAsyncEvents: false.
			nullPointer swordAtOffset: 0 put: 1]
		raise: GPFault
		matching: 
			[:ex |
			(self
				isGPF: ex
				reading: false
				address: 0) and: 
						[self
							isFault: ex
							raisedIn: ExternalAddress >> #swordAtOffset:put:
							receiver: nullPointer]].
	self
		should: 
			[Processor enableAsyncEvents: false.
			nullPointer swordAtOffset: 0]
		raise: GPFault
		matching: 
			[:gpf |
			(self
				isGPF: gpf
				reading: true
				address: 0) and: 
						[self
							isFault: gpf
							raisedIn: ExternalAddress >> #swordAtOffset:
							receiver: nullPointer]]!

testIndirectWordAtOffsetPrimitives
	| nullPointer b p |
	b := ByteArray newFixed: 6.
	p := b yourAddress asExternalAddress.
	#(0 1 16r7FFF 16r8000 16rFFFF) do: 
			[:each |
			"Should be able to write any 32-bit integer value, and read it back"
			self assert: (p wordAtOffset: 2 put: each) equals: each.
			self assert: (b wordAtOffset: 2) equals: each.
			self assert: (b wordAtOffset: 0) equals: 0.
			self assert: (b wordAtOffset: 4) equals: 0].

	"Error if arg is negative or requires more that 16-bits to represent as an unsigned int"
	#(-1 16r10000 -16r8001) do: [:each | self should: [p wordAtOffset: 0 put: each] raise: Error].

	"This class of primitives had a bug whereby if the pointed at memory was inaccessible at the time of the read/write, then the primitive would corrupt the Smalltalk stack."
	nullPointer := 0 asExternalAddress.
	self
		should: 
			["Test with async events off to verify the fault interrupt is sent synchronously to the faulting frame"
			Processor enableAsyncEvents: false.
			nullPointer wordAtOffset: 0 put: 1]
		raise: GPFault
		matching: 
			[:ex |
			(self
				isGPF: ex
				reading: false
				address: 0) and: 
						[self
							isFault: ex
							raisedIn: ExternalAddress >> #wordAtOffset:put:
							receiver: nullPointer]].
	self
		should: 
			[Processor enableAsyncEvents: false.
			nullPointer wordAtOffset: 0]
		raise: GPFault
		matching: 
			[:gpf |
			(self
				isGPF: gpf
				reading: true
				address: 0) and: 
						[self
							isFault: gpf
							raisedIn: ExternalAddress >> #wordAtOffset:
							receiver: nullPointer]]!

testIntDivideByZero
	#(#/ #// #\\ #quo:) do: 
			[:op |
			Processor enableAsyncEvents: false.
			[123 perform: op with: 0] on: ZeroDivide
				do: 
					[:ex |
					self assert: ex tag equals: 123.
					self assert: (self
								isFault: ex
								raisedIn: SmallInteger >> op
								receiver: 123)]]!

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
	1 to: 5 do: [:i | self earlyTermination: false].
	"2) Call is terminated before completion, but is allowed to start"
	1 to: 5 do: [:i | self earlyTermination: true]!

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

testPrimitiveBytesIsNull
	| method subject |
	method := self createPrimitiveMethodLike: ExternalIntegerBytes >> #isNull setsFailCode: true.
	subject := DWORDBytes new.
	self assert: (method value: subject withArguments: #()).
	subject isImmutable: true.
	self assert: (method value: subject withArguments: #()).
	subject := DWORDBytes fromInteger: 1.
	self deny: (method value: subject withArguments: #()).
	subject := ExternalIntegerBytes newFixed: 8.
	self assert: (method value: subject withArguments: #()) equals: 'failed0'!

testPrimitiveEnableInterrupts
	| enabled method |
	method := self createPrimitiveMethodLike: ProcessorScheduler >> #enableAsyncEvents:
				setsFailCode: true.
	self assert: (method value: Processor withArguments: #(1)) equals: 'failed0'.
	self assert: (method value: Processor withArguments: #('abc')) equals: 'failed0'.
	enabled := method value: Processor withArguments: #(false).
	self assert: enabled description: 'Interrupts unexpectedly disabled before test'.
	enabled := method value: Processor withArguments: #(false).
	self deny: enabled description: 'Interrupts should have been disabled previously'.
	enabled := method value: Processor withArguments: #(true).
	self deny: enabled description: 'Interrupts should have remained disabled'.
	enabled := method value: Processor withArguments: #(true).
	self assert: enabled description: 'Interrupts should have been enabled'.
	enabled := method value: Processor withArguments: #(true).
	self assert: enabled description: 'Interrupts should have remained enabled'!

testPrimitiveInstanceCounts
	"Test primitive that returns instance count stats for a list of requested classes."

	| method stats |
	method := self createPrimitiveMethodLike: MemoryManager >> #primInstanceStats: setsFailCode: true.
	stats := method value: MemoryManager current withArguments: #(nil).
	"Kick a couple of tyres"
	self assert: stats size \\ 3 == 0.
	1 to: stats size
		by: 3
		do: 
			[:i |
			| class |
			class := stats at: i.
			class isMetaclass
				ifTrue: 
					["Metaclasses should have only a single instance"
					self assert: (stats at: i + 1) equals: 1].
			class == SmallInteger ifTrue: [self assert: (stats at: i + 1) equals: 0]].
	#(1 'a') do: 
			[:each |
			self assert: (method value: MemoryManager current withArguments: (Array with: each))
				equals: 'failed0']!

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

testPrimitiveIsSuperclassOf
	"Test the currently unused isSuperclassOf primitive."

	| method |
	method := self
				createPrimitiveMethod: 109
				in: Behavior
				argCount: 1
				setsFailCode: true.
	"The primitive is like includesBehavior with arg/receiver inverted, and if both are the same class then the answer is true."
	self assert: (method value: Association withArguments: (Array with: Association)).
	self assert: (method value: Magnitude withArguments: (Array with: Association)).
	self assert: (method value: Object withArguments: (Array with: Association)).
	self deny: (method value: Association withArguments: (Array with: Object)).
	self deny: (method value: Association withArguments: (Array with: SmallInteger)).
	self deny: (method value: Object class withArguments: (Array with: Behavior)).
	self assert: (method value: Object class withArguments: (Array with: Object class)).
	self assert: (method value: Object class withArguments: (Array with: Magnitude class)).
	self assert: (method value: Object withArguments: (Array with: Magnitude class)).
	self assert: (method value: Behavior withArguments: (Array with: Object class)).
	self assert: (method value: Magnitude class withArguments: (Array with: Association class))!

testPrimitiveMakePoint
	"Test the general object instantiation and initialization primitive (it doesn't just make Points)."

	| primitiveIndex method result expected |
	primitiveIndex := (Array class >> #with:) primitiveIndex.
	"Indexable type with no fixed fields, e.g. Array"
	0 to: 2
		do: 
			[:i |
			method := self
						createPrimitiveMethod: primitiveIndex
						in: Array class
						argCount: i
						setsFailCode: true.
			expected := (1 to: i) asArray.
			result := method value: Array withArguments: expected.
			self assert: result equals: expected].
	"Non-indexable type, e.g. Point3D"
	0 to: 3
		do: 
			[:i |
			method := self
						createPrimitiveMethod: primitiveIndex
						in: Point3D class
						argCount: i
						setsFailCode: true.
			expected := Point3D basicNew.
			1 to: i do: [:j | expected instVarAt: j put: j].
			result := method value: Point3D withArguments: (1 to: i) asArray.
			self assert: result equals: expected].
	"Indexable type with fixed fields too, e.g. Context"
	0 to: 4
		do: 
			[:i |
			method := self
						createPrimitiveMethod: primitiveIndex
						in: Context class
						argCount: i
						setsFailCode: true.
			expected := (Array new: (i max: Context instSize))
						replaceFrom: 1
							to: i
							with: (1 to: i) asArray
							startingAt: 1;
						yourself.
			result := method value: Context withArguments: (1 to: i) asArray.
			1 to: expected size do: [:j | self assert: (result instVarAt: j) equals: (expected at: j)]]!

testPrimitiveObjectCount
	"Test primitive that returns object instance count."

	| method count1 count2 subject |
	method := self createPrimitiveMethodLike: MemoryManager >> #objectCount setsFailCode: true.
	subject := MemoryManager current.
	count1 := method value: subject withArguments: #().
	count2 := method value: subject withArguments: #().
	self assert: count1 equals: count2.
	self assert: count1 > 0!

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
	self assert: state equals: 'a1'.
	self assert: a isWaiting.
	self assert: sem first equals: a.
	a suspend.
	self assert: a isSuspended.
	self assert: sem isEmpty.
	self assert: state equals: 'a1'.
	b := 
			[a resume: sem.
			state := state , ', b'] forkAt: Processor userInterruptPriority.
	"Regression test for #Process>>resume: suspends calling/active process #89"
	self assert: b isDead.
	self assert: state equals: 'a1, b'.
	"Check that the process was 'resumed' correctly onto the requested list"
	self assert: a isWaiting.
	self assert: sem first equals: a.
	"And that it is runnable."
	sem signal.
	self assert: state equals: 'a1, b, a2'.
	self assert: a isSuspended.
	list := (Processor instVarNamed: 'processLists') at: a priority.
	"Resumed process is schedulable, but lower priority than the active process, so waits."
	c := 
			[a resume: list.
			state := state , ', c'] forkAt: Processor lowIOPriority.
	self assert: state equals: 'a1, b, a2, c, a3'.
	self assert: a isSuspended.
	self assert: c isDead.
	"Resumed process is same priority, and although we expect a rescheduling it is pushed on the back of the list, so still waits"
	d := 
			[a resume: list.
			state := state , ', d'] forkAt: a priority.
	self assert: state equals: 'a1, b, a2, c, a3, d, a4'.
	self assert: d isDead.
	self assert: a isSuspended.
	"Resumed process is higher priority, so resumes immediately."
	e := 
			[a resume: list.
			state := state , ', e'] forkAt: a priority - 1.
	self assert: state equals: 'a1, b, a2, c, a3, d, a4, a5, e'.
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

testPrimitiveStringAtPut
	| subject method |
	method := self createPrimitiveMethodLike: String >> #at:put: setsFailCode: true.
	subject := String new: 2.
	"Valid case"
	self assert: (subject at: 1) equals: $\0.
	self assert: (subject at: 2) equals: $\0.
	self assert: (method value: subject withArguments: #(1 $a)) equals: $a.
	self assert: (subject at: 1) equals: $a.
	self assert: (method value: subject withArguments: #(2 $b)) equals: $b.
	self assert: (subject at: 2) equals: $b.
	"Invalid index argument"
	self assert: (method value: subject withArguments: #($a $b)) equals: 'failed0'.
	"Bounds errors"
	subject := String new: 2.
	#(0 3 -1 ##(SmallInteger maximum) ##(SmallInteger minimum)) do: 
			[:each |
			self assert: (subject at: 1) equals: $\0.
			self assert: (subject at: 2) equals: $\0.
			self assert: (method value: subject withArguments: (Array with: each with: $a)) equals: 'failed1'].
	"Objects that strings can't hold, including some special cases that have no object body (issue #234)"
	#(0 ##(Object new) nil '' #'' true false #() #[]) do: 
			[:each |
			self assert: (subject at: 1) equals: $\0.
			self assert: (subject at: 2) equals: $\0.
			self assert: (method value: subject withArguments: (Array with: 1 with: each)) equals: 'failed2']!

testPrimitiveStringCmp
	"Test case sensitive string comparison primitive"

	| method |
	method := self createPrimitiveMethodLike: String >> #trueCompare: setsFailCode: true.
	"Note that we don't test that the primitive fails for a non-String receiver - in general primitives assume they are only used in methods of suitable receiver classes."
	#(#('a' 'b' -1) #('abc' 'abc' 0) #('' 'a' -1) #('a' 'ab' -1) #('ab' 'a' 1) #('a' 1 'failed0')) do: 
			[:each |
			| subject result operand expected |
			subject := each first.
			self assert: subject class == String.
			operand := each second.
			expected := each third.
			result := method value: subject withArguments: (Array with: operand).
			self assert: result class == expected class.
			self assert: result equals: expected]!

testPrimitiveSubtract
	"Test the SmallInteger subtract primitive for normal, overflow and failure cases."

	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #- setsFailCode: false.
	"Note that we don't test that the primitive fails for a non-SmallInteger receiver - in general primitives assume they are only used in methods of suitable receiver classes."
	#(#(3 2 1) #(-1 -1 0) #(-1 16r3FFFFFFF -16r40000000) #(-2 16r3FFFFFFF -16r40000001) #(-16r40000000 1 -16r40000001) #(-16r40000000 -16r40000000 0) #(-16r40000000 16r3FFFFFFF -16r7FFFFFFF) #(16r3FFFFFFF -16r40000000 16r7FFFFFFF) #(1 'a' 'failed') #(1 16r40000000 'failed'))
		do: 
			[:each |
			| subject result operand expected |
			subject := each first.
			self assert: subject class == SmallInteger.
			operand := each second.
			expected := each third.
			result := method value: subject withArguments: (Array with: operand).
			self assert: result class == expected class.
			self assert: result equals: expected]!

testPrimitiveYourAddress
	| method |
	method := self createPrimitiveMethodLike: Object >> #yourAddress setsFailCode: false.
	#('' 'abc') do: 
			[:each || addr |
			addr := method value: each withArguments: #().
			self deny: addr == 0.
			self assert: (String fromAddress: each) equals: each].
	"Bug: #yourAddress returns 0 for an empty byte array?"
	#(#[]#[1 2 3]) do: 
			[:each || addr |
			addr := method value: each withArguments: #().
			self deny: addr == 0.
			self assert: (ByteArray fromAddress: addr length: each size) equals: each].
	self assert: (method value: nil withArguments: #()) equals: 0.
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
	self should: [VMLibrary default signedFromUnsigned: (2 raisedToInteger: 32) + 1] raise: Error!

testVMPointersImmutable
	| vmPointers |
	vmPointers := VMLibrary default registry yourAddress asExternalAddress.
	self
		should: [vmPointers dwordAtOffset: 0 put: 1]
		raise: Processor constWriteSignal
		matching: 
			[:ex |
			self
				isFault: ex
				raisedIn: ExternalAddress >> #dwordAtOffset:put:
				receiver: vmPointers]!

testWeakMournerNotifications
	| subject1 subject2 losses obj1 obj2 obj3 id1 id2 |
	obj1 := Object new.
	obj2 := Object new.
	obj3 := Object new.
	subject1 := MourningWeakArray
				with: obj1
				with: obj2
				with: obj3.
	subject1 pathologist: self.
	subject2 := MourningWeakArray
				with: obj3
				with: obj2
				with: obj1.
	subject2 pathologist: self.
	subject2 beFinalizable.
	losses := IdentityDictionary new.
	id1 := subject1 identityHash.
	losses at: id1 put: 0.
	id2 := subject2 identityHash.
	losses at: id2 put: 0.
	expiryHandler := 
			[:count :mourner |
			| id |
			id := mourner identityHash.
			losses at: id put: (losses at: id) + count].
	obj1 := obj3 := nil.
	MemoryManager current collectGarbage.
	"Weak array should have been notified of loss of obj1 and obj3"
	self assert: (losses at: id1) equals: 2.
	self assert: subject1 first == DeadObject current.
	self assert: subject1 second == obj2.
	self assert: subject1 third == DeadObject current.
	self assert: (losses at: id2) equals: 2.
	self assert: subject2 first == DeadObject current.
	self assert: subject2 second == obj2.
	self assert: subject2 third == DeadObject current.
	obj2 := subject1 := subject2 := nil.
	MemoryManager current collectGarbage.
	"Garbage weak array should not have been notified of loss of obj2 as it was collected in same GC cycle"
	self assert: (losses at: id1) equals: 2.
	"Garbage but finalizable weak array should have been notified of loss of obj2"
	self assert: (losses at: id2) equals: 3! !
!VMTest categoriesFor: #assertImmutableAtPut:!private!unit tests! !
!VMTest categoriesFor: #assertImmutableBasicAtPut:!private!unit tests! !
!VMTest categoriesFor: #assertImmutableInstVarAtPut:!private!unit tests! !
!VMTest categoriesFor: #assertImmutableResize:!private!unit tests! !
!VMTest categoriesFor: #createPrimitiveMethod:in:argCount:setsFailCode:!helpers!private! !
!VMTest categoriesFor: #createPrimitiveMethodLike:setsFailCode:!helpers!private! !
!VMTest categoriesFor: #earlyTermination:!helpers!private! !
!VMTest categoriesFor: #elementsExpired:of:!helpers!private! !
!VMTest categoriesFor: #exerciseReplaceElementsOf:from:to:with:startingAt:!private!unit tests! !
!VMTest categoriesFor: #exerciseReplaceElementsOf:with:!private!unit tests! !
!VMTest categoriesFor: #findCaller:in:!helpers!private! !
!VMTest categoriesFor: #findFaultInterruptFrame:!helpers!private! !
!VMTest categoriesFor: #isFault:raisedIn:receiver:!helpers!private! !
!VMTest categoriesFor: #isGPF:reading:address:!helpers!private! !
!VMTest categoriesFor: #suspendAndTerminate!helpers!private! !
!VMTest categoriesFor: #testBSTRArg!public!unit tests! !
!VMTest categoriesFor: #testCRTFault!public!unit tests! !
!VMTest categoriesFor: #testDwordAtOffsetPut!public!unit tests! !
!VMTest categoriesFor: #testEvaluationOrder!public!unit tests! !
!VMTest categoriesFor: #testExtCallRetHRESULT!public!unit tests! !
!VMTest categoriesFor: #testFPFaultInPrimitive!public!unit tests! !
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
!VMTest categoriesFor: #testIndirectByteAtOffsetPrimitives!public! !
!VMTest categoriesFor: #testIndirectDwordAtOffsetPrimitives!public! !
!VMTest categoriesFor: #testIndirectSdwordAtOffsetPrimitives!public! !
!VMTest categoriesFor: #testIndirectSwordAtOffsetPrimitives!public! !
!VMTest categoriesFor: #testIndirectWordAtOffsetPrimitives!public! !
!VMTest categoriesFor: #testIntDivideByZero!public!unit tests! !
!VMTest categoriesFor: #testMakeLargeUnsigned!public!unit tests! !
!VMTest categoriesFor: #testMustBeBoolean!public!unit tests! !
!VMTest categoriesFor: #testOverlappedCallsSuspendAndTerminate!public!unit tests! !
!VMTest categoriesFor: #testOverlappedCallTermination!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveAt!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveAtPut!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveBytesIsNull!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveEnableInterrupts!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveInstanceCounts!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveIsNullBytes!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveIsSuperclassOf!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveMakePoint!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveObjectCount!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveReplaceElements!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveResume!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringAt!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringAtPut!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringCmp!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveSubtract!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveYourAddress!public!unit tests! !
!VMTest categoriesFor: #testSignedFromUnsigned!public!unit tests! !
!VMTest categoriesFor: #testVMPointersImmutable!public!unit tests! !
!VMTest categoriesFor: #testWeakMournerNotifications!public!unit tests! !

!VMTest class methodsFor!

resources
	^Array with: MustBeBooleanTestClasses! !
!VMTest class categoriesFor: #resources!Accessing!public! !

