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

firstVmVersionRespectingNonInstantiable
	"Private - The first VM version that refuses to instantiate abstract classes."

	^#(2016 7 0 51)!

has7052OrLater
	^self isAtLeastVmVersion: #(2016 7 0 52)!

has7053OrLater
	^self isAtLeastVmVersion: #(2016 7 0 53)!

has7054OrLater
	^self isAtLeastVmVersion: #(2016 7 0 54)!

hashBytes: aByteArray
	"Private - PJW hash (Aho, Sethi, and Ullman pp. 434-438).
	Note that this algorithm is optimised for ASCII characters, making it a good choice for symbols, but probably not as a general byte hash algorithm."

	| h |
	h := 0.
	1 to: aByteArray size
		do: 
			[:i |
			| g ki |
			ki := aByteArray basicAt: i.
			h := (h << 4) + ki.
			g := h & 16rF0000000.
			g ~~ 0 ifTrue: [h := (h bitXor: g >> 24) bitXor: g]].
	^h!

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
			result := method value: VMLibrary default withArguments: {each}.
			self assert: result equals: each.
			self assert: each class == result class].
	"Negative HRESULTs should cause the primitive to fail with the failure data set to the HR code."
	#(-1 -16r40000000 -16r40000001 -16r80000000) do: 
			[:each |
			| result |
			result := method value: VMLibrary default withArguments: {each}.
			self assert: result key equals: -1.
			self assert: result value equals: each.
			self assert: each class == result value class]!

testExtCallRetLpwstr
	| expected actual method |
	self skipUnless: [self has7054OrLater].
	method := Compiler
				compile: 'w: anInteger
	| proc |
	<stdcall: lpwstr AnswerDWORD lpvoid>
	proc := Processor activeProcess.
	^proc primitiveFailureCode -> proc primitiveFailureData'
				in: VMLibrary.
	expected := 'abc' asUnicodeString.
	actual := method value: VMLibrary default withArguments: {expected yourAddress}.
	self assert: actual equals: expected.
	self assert: actual isKindOf: UnicodeString!

testFPFaultInPrimitive
	"An FP fault occurring in a primitive should be reported in the primitive method, not some
	subsequently invoked method, even when interrupts are off."

	| mask receiver |
	mask := Float exceptionMask.
	Float exceptionMask: (mask maskClear: CRTConstants._EM_OVERFLOW).
	receiver := 2.0.
	
	[self
		should: 
			[Processor enableAsyncEvents: false.
			(receiver timesTwoPower: Float emax) * 5.0]
		raise: FloatingPointException
		matching: 
			[:fpe |
			self
				isFault: fpe
				raisedIn: Float >> #timesTwoPower:
				receiver: receiver]]
			ensure: [Float exceptionMask: mask]!

testFPStatus
	"Tests that FP status notifications are isolated to individual Smalltalk processes and are preserved across context switches."

	| value sem1 sem2 oldMask mainStatus1 status1 status2 mainStatus2 |
	sem1 := Semaphore new.
	sem2 := Semaphore new.
	Float reset.
	
	[Float exceptionMask: _MCW_EM.
	value := Float.FMax * Float.FMax.
	status1 := Float statusFlags.
	sem1 signal.
	sem2 wait.

	"Status flags should be the same, despite switching away to another process that performs other invalid FP ops"
	status2 := Float statusFlags.
	Float reset.
	sem1 signal]
			forkAt: Processor userInterruptPriority.	"High priority background proc runs but then blocks..."
	sem1 wait.
	self assert: value isInfinite.
	oldMask := Float exceptionMask.
	
	[Float exceptionMask: _MCW_EM.
	mainStatus1 := Float statusFlags.
	self assert: mainStatus1 equals: 0.
	self assert: (status1 anyMask: CRTConstants._SW_OVERFLOW).
	value := 100.0 / 0.
	mainStatus1 := Float statusFlags.
	sem2 signal.
	sem1 wait.
	mainStatus2 := Float statusFlags]
			ensure: [Float exceptionMask: oldMask].
	self assert: (mainStatus1 anyMask: CRTConstants._SW_ZERODIVIDE).
	self assert: mainStatus2 equals: mainStatus1.
	self assert: status2 equals: status1.
	self assert: value isInfinite!

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

testPrimitiveAllInstances
	| actual |
	"There are few things we can rely on having a fixed number of instances"
	actual := Processor class primAllInstances.
	self assert: actual equals: {Processor}!

testPrimitiveAt
	self verifyPrimitiveAt: [:a :i | a at: i] performBlock: [:a :i | a perform: #at: with: i]!

testPrimitiveAtPut
	self verifyPrimitiveAtPut: [:a :i :v | a at: i put: v]
		performBlock: 
			[:a :i :v |
			a
				perform: #at:put:
				with: i
				with: v]!

testPrimitiveBasicAt
	self verifyPrimitiveAt: [:a :i | a basicAt: i] performBlock: [:a :i | a perform: #basicAt: with: i].
	"#basicAt: access into strings returns the byte encoding"
	self assert: ('abc' basicAt: 1) equals: $a codePoint.
	self assert: ('abc' perform: #basicAt: with: 3) equals: $c codePoint.
	self assert: ('abc' basicAt: 2) equals: $b codePoint.
	self assert: ('abc' copy perform: #basicAt: with: 2) equals: $b codePoint.
	#(-1 0 4) do: 
			[:each |
			self should: ['abc' basicAt: each] raise: BoundsError.
			self should: ['abc' copy basicAt: each] raise: BoundsError.
			self should: ['abc' perform: #basicAt: with: each] raise: BoundsError.
			self should: ['abc' copy perform: #basicAt: with: each] raise: BoundsError]!

testPrimitiveBasicAtPut
	self verifyPrimitiveAtPut: [:a :i :v | a basicAt: i put: v]
		performBlock: 
			[:a :i :v |
			a
				perform: #basicAt:put:
				with: i
				with: v]!

testPrimitiveBytesEqual
	| method string1 string2 string3 string4 bytes1 bytes2 string5 string6 string7 mismatchedClassFailure |
	method := self
				createPrimitiveMethod: (String >> #=) primitiveIndex
				in: Object
				argCount: 1
				setsFailCode: true.
	bytes1 := #[1 2 3 4 5 6 7 8].
	bytes2 := #[4 5 6 7 8 9 10 11].
	string1 := 'abc'.
	string2 := 'ab'.
	string3 := 'abd'.
	"Exactly one word in length"
	string4 := 'abcd'.
	string5 := ''.
	"More than one word, odd length"
	string6 := 'abcdefghi'.
	string7 := 'abcdefghj'.
	mismatchedClassFailure := self has7052OrLater ifTrue: ['failed1'] ifFalse: ['failed0'].
	{{string1. string1. true}.
		{bytes1. bytes1. true}.
		{bytes1. bytes1 copy. true}.
		{bytes1. bytes2. false}.
		{bytes2. bytes1. false}.
		{string1. string1 copy. true}.
		{string1.
			string1 copy
				isImmutable: true;
				yourself.
			true}.
		{string2. string2 copy. true}.
		{string3. string3 copy. true}.
		{string4. string4 copy. true}.
		{string5. string5 copy. true}.
		{string6. string6 copy. true}.
		{string6. string7. false}.
		{string7. string6. false}.
		{string1. string2. false}.
		{string2. string1. false}.
		{string1. string3. false}.
		{string3. string1. false}.
		{string1. string4. false}.
		{string4. string1. false}.
		{string1. string5. false}.
		{string5. string1. false}.
		{string1. string1 asSymbol. mismatchedClassFailure}.
		{string1 asSymbol. string1. mismatchedClassFailure}} do: 
				[:each |
				| actual |
				actual := method value: each first withArguments: {each second}.
				self assert: actual equals: each last]!

testPrimitiveBytesIsNull
	| method subject |
	method := self createPrimitiveMethodLike: ExternalIntegerBytes >> #isNull setsFailCode: true.
	subject := DWORDBytes new.
	self assert: (method value: subject withArguments: #()).
	subject isImmutable: true.
	self assert: (method value: subject withArguments: #()).
	subject := DWORDBytes fromInteger: 1.
	self deny: (method value: subject withArguments: #()).
	subject := UIntPtrBytes newFixed: 8.
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

testPrimitiveExtraInstanceSpec
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #extraInstanceSpec setsFailCode: false.
	Smalltalk allClasses do: 
			[:each |
			self assert: (method value: each withArguments: #())
				equals: ((each instanceSpec bitShift: -15) bitAnd: 16rFFFF)]!

testPrimitiveFindString
	"Test string search primitive"

	| method foundCases failureCases notFoundCases unlikely comment large expectedForStartingAtOffEnd |
	method := self createPrimitiveMethodLike: String >> #findString:startingAt: setsFailCode: true.
	failureCases := #(#('abc' 'a' 'b' 'failed0') #('abc' 'a' 0 'failed1') #('abc' 'a' -1 'failed1') #('abc' #a 1 'failed2')).
	foundCases := #(#('abc' 'a' 1 1) #('abc' 'b' 1 2) #('abc' 'c' 1 3) #('abc' 'ab' 1 1) #('abc' 'b' 2 2) #('abc' 'bc' 2 2) #('abc' 'c' 3 3))
				asOrderedCollection.
	unlikely := '!!@#^%'.
	comment := Object comment.
	large := Object comment , unlikely.
	foundCases addLast: {large. unlikely. 1. comment size + 1}.
	foundCases addLast: {large , comment. unlikely. large size // 2. comment size + 1}.
	foundCases
		addLast: {large , large. unlikely. large size - unlikely size + 2. large size + comment size + 1}.
	notFoundCases := #(#('abc' '' 1 0) #('abc' '' 3 0) #('abc' 'd' 1 0) #('abc' 'ad' 1 0) #('abc' 'abd' 1 0) #('abc' 'a' 2 0) #('abc' 'ab' 2 0) #('abc' 'a' 3 0) #('abc' 'cd' 3 0))
				asOrderedCollection.
	"Older VM failed the primitive if the startingAt argument was too large."
	expectedForStartingAtOffEnd := (self isAtLeastVmVersion: #(2016 7 0 53))
				ifTrue: [0]
				ifFalse: ['failed1'].
	notFoundCases addAll: (#(#('abc' '' 4) #('abc' 'c' 4) #('abc' 'ab' 4))
				collect: [:each | each copyWith: expectedForStartingAtOffEnd]).
	notFoundCases addLast: {large. unlikely reverse. 1. 0}.
	foundCases , notFoundCases , failureCases do: 
			[:each |
			| subject actual match expected startingAt |
			subject := each first.
			match := each second.
			startingAt := each third.
			expected := each fourth.
			actual := method value: subject withArguments: {match. startingAt}.
			self assert: actual equals: expected]!

testPrimitiveHashBytes
	| method |
	method := self
				createPrimitiveMethod: (String >> #hash) primitiveIndex
				in: Object
				argCount: 0
				setsFailCode: false.
	{'abcdefghijklmnopqrstuvwxyz'. String new: 8 withAll: $\x7F. #[255 255 255 255 255 255 239 127]}
		do: 
			[:each |
			1 to: each size
				do: 
					[:i |
					| slice |
					slice := each copyFrom: 1 to: i.
					self assert: (method value: slice withArguments: #()) equals: (self hashBytes: slice)]]!

testPrimitiveIdentical
	| method |
	method := self createPrimitiveMethodLike: Object >> #== setsFailCode: false.
	#(#(1 1 true) #(1 2 false) #(2 1 false) #(#x #x true) #(#x #y false) #(1 #x false) #(#x 1 false))
		do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each third]!

testPrimitiveInstanceCounts
	"Test primitive that returns instance count stats, but not requesting any specific classes."

	| stats counts |
	stats := MemoryManager current primInstanceStats: nil.
	"Kick a couple of tyres"
	self assert: stats size \\ 3 == 0.
	counts := IdentityDictionary new.
	1 to: stats size
		by: 3
		do: [:i | counts at: (stats at: i) put: (stats at: i + 1)].
	self assert: (counts at: Symbol) > 30000.
	self assert: (counts at: VMLibrary) equals: 1.
	counts keysAndValuesDo: 
			[:class :count |
			class isMetaclass
				ifTrue: 
					["Metaclasses should have only a single instance"
					self assert: count equals: 1].
			class isNonInstantiable ifTrue: [self assert: count equals: 0]].
	self deny: (counts includes: SmallInteger).
	self assert: (counts at: Character) >= 256.
	self assert: (counts at: MemoryManager) equals: 1.
	"Test primitive failure"
	#(1 'a' #[1 2 3]) do: 
			[:each |
			self
				should: [MemoryManager current primInstanceStats: each]
				raise: Error
				matching: [:ex | ex messageText = 'Primitive MemoryManager>>primInstanceStats: failed (0)']].
	"Test requesting stats for a specific class"
	stats := MemoryManager current primInstanceStats: {Metaclass}.
	self assert: stats first equals: Metaclass.
	self assert: stats second >= Smalltalk allClasses size!

testPrimitiveInstanceCounts2
	"Test primitive that returns instance count stats for a list of requested classes."

	| stats baseClasses counts |
	self skipUnless: 
			["Crashing bug in older VMs"
			self has7052OrLater].
	baseClasses := Object owningPackage classes.
	stats := MemoryManager current primInstanceStats: baseClasses asArray.
	self assert: stats size equals: baseClasses size * 3.
	"Verify a few instance counts"
	counts := IdentityDictionary new.
	1 to: stats size
		by: 3
		do: [:i | counts at: (stats at: i) put: (stats at: i + 1)].
	self assert: (counts keys noDifference: baseClasses).
	"Some sanity checks that the stats look reasonable."
	self assert: (counts at: Symbol) = Symbol primAllInstances size.
	self assert: (counts at: String) > 30000.
	self assert: (counts at: Object) < 100.
	self assert: (counts at: VMLibrary) equals: 1.
	self assert: (counts at: Processor class) equals: 1.
	(baseClasses select: [:each | each isAbstract])
		do: [:each | self assert: (counts at: each) equals: 0]!

testPrimitiveInstVarAt
	| mutableOc method immutableBytes mutableBytes immutableOc |
	method := self createPrimitiveMethodLike: Object >> #instVarAt: setsFailCode: true.
	mutableOc := OrderedCollection with: '3' with: '4'.
	self deny: mutableOc isImmutable.
	immutableOc := mutableOc copy
				isImmutable: true;
				yourself.
	self assert: immutableOc isImmutable.
	1 to: 2
		do: 
			[:i |
			self assert: (method value: mutableOc withArguments: {i}) equals: i.
			self assert: (method value: immutableOc withArguments: {i}) equals: i].
	3 to: 4
		do: 
			[:i |
			self assert: (method value: mutableOc withArguments: {i}) equals: i printString.
			self assert: (method value: immutableOc withArguments: {i}) equals: i printString].
	immutableBytes := #[10 20 30 40].
	self assert: immutableBytes isImmutable.
	mutableBytes := immutableBytes copy.
	self deny: mutableBytes isImmutable.
	1 to: immutableBytes size
		do: 
			[:i |
			self assert: (method value: immutableBytes withArguments: {i}) equals: i * 10.
			self assert: (method value: mutableBytes withArguments: {i}) equals: i * 10].
	"Out of bounds"
	{-1. 0. 5. SmallInteger minimum. SmallInteger maximum} do: 
			[:each |
			self assert: (method value: mutableOc withArguments: {each}) equals: 'failed1'.
			self assert: (method value: immutableOc withArguments: {each}) equals: 'failed1'.
			self assert: (method value: mutableBytes withArguments: {each}) equals: 'failed1'.
			self assert: (method value: immutableBytes withArguments: {each}) equals: 'failed1'].
	"Invalid index"
	{SmallInteger minimum - 1. SmallInteger maximum + 1. nil} do: 
			[:each |
			self assert: (method value: mutableOc withArguments: {each}) equals: 'failed0'.
			self assert: (method value: immutableOc withArguments: {each}) equals: 'failed0'.
			self assert: (method value: mutableBytes withArguments: {each}) equals: 'failed0'.
			self assert: (method value: immutableBytes withArguments: {each}) equals: 'failed0']!

testPrimitiveInstVarAtPut
	| mutableOc method immutableBytes mutableBytes immutableOc immutableString mutableString |
	method := self createPrimitiveMethodLike: Object >> #instVarAt:put: setsFailCode: true.
	mutableOc := OrderedCollection new: 2.
	self deny: mutableOc isImmutable.
	immutableOc := mutableOc copy
				isImmutable: true;
				yourself.
	self assert: immutableOc isImmutable.
	self assert: (method value: mutableOc withArguments: #(1 1)) equals: 1.
	self assert: (method value: mutableOc withArguments: #(2 2)) equals: 2.
	self assert: mutableOc size equals: 2.
	self assert: (method value: mutableOc withArguments: #(3 '3')) equals: '3'.
	self assert: (method value: mutableOc withArguments: #(4 '4')) equals: '4'.
	self assert: mutableOc asArray equals: #('3' '4').
	self assert: (method value: immutableOc withArguments: #(1 1)) equals: 'failed1'.
	immutableBytes := #[10 20 30 40].
	mutableString := String new: 4.
	immutableString := 'abcd'.
	self assert: immutableBytes isImmutable.
	mutableBytes := immutableBytes copy.
	self deny: mutableBytes isImmutable.
	1 to: immutableBytes size
		do: 
			[:i |
			self assert: (method value: immutableBytes withArguments: {i. i * 10}) equals: 'failed1'.
			self assert: (method value: immutableString withArguments: {i. 96 + i}) equals: 'failed1'.
			self assert: (method value: mutableString withArguments: {i. 96 + i}) equals: 96 + i.
			self assert: (method value: mutableBytes withArguments: {i. i * 10}) equals: i * 10.
			self assert: (mutableBytes basicAt: i) equals: i * 10].
	self assert: mutableString equals: immutableString.
	"Out of bounds"
	{-1. 0. 5. SmallInteger minimum. SmallInteger maximum} do: 
			[:each |
			self assert: (method value: mutableOc withArguments: {each. each}) equals: 'failed1'.
			self assert: (method value: immutableOc withArguments: {each. each}) equals: 'failed1'.
			self assert: (method value: mutableString withArguments: {each. each}) equals: 'failed1'.
			self assert: (method value: immutableString withArguments: {each. each}) equals: 'failed1'.
			self assert: (method value: mutableBytes withArguments: {each. each}) equals: 'failed1'.
			self assert: (method value: immutableBytes withArguments: {each. each}) equals: 'failed1'].
	"Invalid index"
	{SmallInteger minimum - 1. SmallInteger maximum + 1. nil} do: 
			[:each |
			self assert: (method value: mutableOc withArguments: {each. each}) equals: 'failed0'.
			self assert: (method value: immutableOc withArguments: {each. each}) equals: 'failed0'.
			self assert: (method value: mutableString withArguments: {each. each}) equals: 'failed0'.
			self assert: (method value: immutableString withArguments: {each. each}) equals: 'failed0'.
			self assert: (method value: mutableBytes withArguments: {each. each}) equals: 'failed0'.
			self assert: (method value: immutableBytes withArguments: {each. each}) equals: 'failed0'].
	"Invalid byte content"
	#($a -1 256 nil) do: 
			[:each |
			self assert: (method value: mutableString withArguments: #(1 #each)) equals: 'failed2'.
			self assert: (method value: mutableBytes withArguments: #(1 #each)) equals: 'failed2']!

testPrimitiveIsKindOf
	"Test the isKindOf primitive (which does not fail)"

	| method proto |
	method := self createPrimitiveMethodLike: Object >> #isKindOf: setsFailCode: false.
	"SmallInteger"
	{nil. 123. 1 -> 2. #[1 2 3]. 'abc'. Object. Object class. ProtoObject. ProtoObject class} do: 
			[:subject |
			subject basicClass
				withAllSuperclassesDo: [:class | self assert: (method value: subject withArguments: {class})].
			self assert: (method value: subject withArguments: #(nil)).
			self deny: (method value: subject withArguments: #(1)).
			self deny: (method value: subject withArguments: {Float}).
			self deny: (method value: subject withArguments: {Object new}).
			subject isBehavior
				ifTrue: 
					[subject isMetaclass
						ifTrue: [self deny: (method value: subject withArguments: {Object class})]
						ifFalse: 
							[Class withAllSuperclassesDo: [:class | self assert: (method value: subject withArguments: {class})]]]
				ifFalse: 
					[self deny: (method value: subject withArguments: {Behavior}).
					self deny: (method value: subject withArguments: {Object class})]].
	proto := ProtoObject new.
	self assert: (proto isKindOf: ProtoObject).
	self assert: (proto isKindOf: nil).
	self deny: (proto isKindOf: ProtoObject class).
	self deny: (proto isKindOf: 1).
	self deny: (proto isKindOf: Object).
!

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

testPrimitiveLookupMethod
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #lookupMethod: setsFailCode: true.
	self assert: (method value: Object withArguments: #(1)) equals: 'failed1'.
	"The primitive doesn't bother to check that the argument is actually a Symbol."
	self assertIsNil: (method value: Object withArguments: #(nil)).
	self assertIsNil: (method value: Object withArguments: #('size')).
	"Successful lookups"
	self assert: (method value: Object withArguments: #(#size)) equals: Object >> #size.
	self assert: (method value: Association withArguments: #(#size)) equals: Object >> #size.
	self assert: (method value: Object class withArguments: #(#size)) equals: Object >> #size.
	self assert: (method value: ByteArray withArguments: #(#size)) equals: ArrayedCollection >> #size.
	self assert: (method value: String withArguments: #(#size)) equals: ArrayedCollection >> #size.
	"Unsuccessful lookups"
	self assertIsNil: (method value: Object withArguments: #(#testPrimitiveLookupMethod)).
	self assertIsNil: (method value: ProtoObject withArguments: #(#class)).!

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

testPrimitiveNewColonFailure
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #new: setsFailCode: true.
	self assert: (method value: Array withArguments: #('failed2')) equals: 'failed0'.
	self vmRespectsNonInstantiable
		ifTrue: 
			[self assert: (method value: Array withArguments: #(-1)) equals: 'failed0'.
			"CompiledCode is abstract"
			self assert: (method value: CompiledCode withArguments: #(0)) equals: 'failed1']
		ifFalse: [self assert: (method value: Array withArguments: #(-1)) equals: 'failed1'].
	self assert: (method value: Object withArguments: #(0)) equals: 'failed2'!

testPrimitiveNewFailure
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #new setsFailCode: true.
	self assert: (method value: Array withArguments: #()) equals: 'failed0'.
	self vmRespectsNonInstantiable
		ifTrue: [self assert: (method value: Boolean withArguments: #()) equals: 'failed1']!

testPrimitiveNewFixedFailure
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #newFixed: setsFailCode: true.
	"Invalid size (must be a positive SmallInteger)"
	self assert: (method value: ByteArray withArguments: #('failed2')) equals: 'failed0'.
	self vmRespectsNonInstantiable
		ifTrue: 
			[self assert: (method value: ByteArray withArguments: #(-1)) equals: 'failed0'.
			"Only byte objects can be pinned"
			self assert: (method value: Array withArguments: #(1)) equals: 'failed2'.
			"ExternalIntegerBytes is abstract"
			self assert: (method value: ExternalIntegerBytes withArguments: #(1)) equals: 'failed1']
		ifFalse: [self assert: (method value: ByteArray withArguments: #(-1)) equals: 'failed1']!

testPrimitiveNewInitializedFailure
	| method |
	method := self
				createPrimitiveMethod: (Array class >> #with:with:with:) primitiveIndex
				in: Object
				argCount: 3
				setsFailCode: true.
	"Only valid for pointer classes"
	self assert: (method value: Array withArguments: #(1 2 3)) equals: #(1 2 3).
	self assert: (method value: Point withArguments: #(1 2 3)) equals: 'failed2'.
	self vmRespectsNonInstantiable
		ifTrue: 
			[self assert: (method value: MessageSendAbstract withArguments: #(1 2 3)) equals: 'failed1'.
			self assert: (method value: ByteArray withArguments: #(1 2 3)) equals: 'failed0']
		ifFalse: [self assert: (method value: ByteArray withArguments: #(1 2 3)) equals: 'failed1']!

testPrimitiveNewVirtualFailure
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #new:max: setsFailCode: true.
	"Invalid sizes (must be positive SmallInteger)"
	self assert: (method value: Array withArguments: #('1' 2)) equals: 'failed1'.
	self vmRespectsNonInstantiable
		ifTrue: 
			[
			"Older VM just threw an out-of-memory for negative sizes as it treated the arg as unsigned"
			self assert: (method value: Array withArguments: #(-1 2)) equals: 'failed1'.
			self assert: (method value: Array withArguments: #(1 -2)) equals: 'failed0'.
			"CompiledCode is abstract"
			self assert: (method value: CompiledCode withArguments: #(1 2)) equals: 'failed3'].
	self assert: (method value: Array withArguments: #(1 '2')) equals: 'failed0'.
	"Object is not indexable"
	self assert: (method value: Object withArguments: #(1 2)) equals: 'failed2'!

testPrimitiveNextPut
	| method subject |
	method := self createPrimitiveMethodLike: WriteStream >> #nextPut: setsFailCode: true.
	subject := String writeStream.
	"Past limit"
	self assert: (method value: subject withArguments: #($a)) equals: 'failed2'.
	"Smalltalk backup code will extend the collection"
	subject nextPut: $a.
	self assert: (method value: subject withArguments: #($b)) equals: $b.
	self assert: subject position equals: 2.
	self assert: subject contents equals: 'ab'.
	subject position: 0.0.
	self assert: (method value: subject withArguments: #($a)) equals: 'failed0'.
	subject := String writeStream: 2.
	"Not a character"
	self assert: (method value: subject withArguments: #(1)) equals: 'failed4'.
	self has7053OrLater
		ifTrue: 
			["Earlier VM assumed chars were always for byte code points"
			self assert: (method value: subject withArguments: {Character codePoint: 16r394}) equals: 'failed4']!

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

testPrimitiveSetSpecialBehavior
	| method subject before after nullTermMask |
	method := self createPrimitiveMethodLike: Object >> #setSpecialBehavior: setsFailCode: true.
	self assert: (method value: 1 withArguments: #(1)) equals: 'failed1'.
	subject := Object new.
	self assert: (method value: subject withArguments: #(nil)) equals: 'failed0'.
	before := subject getSpecialBehavior.
	self assert: (method value: subject withArguments: #(16rFF00)) equals: before.
	self assert: (method value: subject withArguments: #(16rFFFF)) equals: before.
	"The per-object flags contain a number of bits that the VM will not allow to be modified - in fact only the weak & finalize bits can be set or unset."
	after := before | _WeakMask | _FinalizeMask.
	self assert: subject getSpecialBehavior equals: after.
	self assert: subject isWeak.
	self assert: subject isFinalizable.
	self assert: (method value: subject withArguments: {_WeakMask}) equals: after.
	self assert: subject getSpecialBehavior equals: before | _WeakMask.
	self assert: subject isWeak.
	self deny: subject isFinalizable.
	self assert: (method value: subject withArguments: #(0)) equals: before | _WeakMask.
	self assert: subject getSpecialBehavior equals: before.
	self deny: subject isWeak.
	self deny: subject isFinalizable.
	subject := ByteArray new: 1.
	before := subject getSpecialBehavior.
	self assert: (method value: subject withArguments: #(16rFF00)) equals: before.
	self assert: (method value: subject withArguments: #(16rFFFF)) equals: before.
	nullTermMask := _WeakMask bitXor: _PointersMask.
	after := before | nullTermMask | _FinalizeMask.
	self assert: subject getSpecialBehavior equals: after.
	self deny: subject isWeak.
	self assert: subject isFinalizable.
	self assert: (method value: subject withArguments: {nullTermMask}) equals: after.
	self assert: subject getSpecialBehavior equals: before | nullTermMask.
	self deny: subject isWeak.
	self deny: subject isFinalizable.
	self assert: (method value: subject withArguments: #(0)) equals: before | nullTermMask.
	self assert: subject getSpecialBehavior equals: before.
	self deny: subject isWeak.
	self deny: subject isFinalizable!

testPrimitiveShallowCopy
	| method subject result |
	"Note that the primitive does not expect to be invoked for an immediate (SmallInteger) receiver."
	method := self createPrimitiveMethodLike: Object >> #shallowCopy setsFailCode: false.
	#(#(#(1) 'a') #[0 1 2 3] 'abc' #x:y:) do: 
			[:each |
			subject := #(#()).
			result := method value: subject withArguments: #().
			self deny: result sameAs: subject.
			self assert: result equals: subject.
			result with: subject do: [:a :b | self assert: a sameAs: b]]!

testPrimitiveSize
	| method subject |
	method := self createPrimitiveMethodLike: Object >> #size setsFailCode: false.
	self assert: (method value: '' withArguments: #()) equals: 0.
	self assert: (method value: #[1 2] withArguments: #()) equals: 2.
	self assert: (method value: #(#a #b #c) withArguments: #()) equals: 3.
	self assert: (method value: 1->2 withArguments: #()) equals: 0.
	subject := OrderedCollection basicNew: 5.
	self assert: (method value: subject withArguments: #()) equals: 5.
	!

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
	| subject method cantHold |
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
			self assert: (method value: subject withArguments: {each. $a}) equals: 'failed1'].
	"Objects that strings can't hold, including some special cases that have no object body (issue #234)"
	cantHold := #(0 ##(Object new) nil '' #'' true false #() #[]) asOrderedCollection.
	self has7053OrLater ifTrue: [cantHold add: (Character value: 256)].
	cantHold do: 
			[:each |
			self assert: (subject at: 1) equals: $\0.
			self assert: (subject at: 2) equals: $\0.
			self assert: (method value: subject withArguments: {1. each}) equals: 'failed2']!

testPrimitiveStringCmp
	"Test case sensitive string comparison primitive"

	| method |
	method := self createPrimitiveMethodLike: String >> #trueCompare: setsFailCode: true.
	"Note that we don't test that the primitive fails for a non-String receiver - in general primitives assume they are only used in methods of suitable receiver classes."
	#(#('a' 'b' -1) #('A' 'a' 1) #('abc' 'ABC' -1) #('abc' 'abc' 0) #('' 'a' -1) #('a' 'ab' -1) #('ab' 'a' 1) #('a' 1 'failed0'))
		do: 
			[:each |
			| subject result operand expected |
			subject := each first.
			self assert: subject class == String.
			operand := each second.
			expected := each third.
			result := method value: subject withArguments: {operand}.
			self assert: result class == expected class.
			self assert: result equals: expected].
	self has7052OrLater
		ifTrue: 
			[self assert: (method value: 'a' withArguments: {Array new}) equals: 'failed1'.
			self assert: (method value: 'a' withArguments: {WeakArray new}) equals: 'failed1']!

testPrimitiveStringCollate
	"Test case insensitive string comparison primitive"

	| method |
	method := self createPrimitiveMethodLike: String >> #_collate: setsFailCode: true.
	"Note that we don't test that the primitive fails for a non-String receiver - in general primitives assume they are only used in methods of suitable receiver classes."
	#(#('a' 'b' -1) #('b' 'a' 1) #('abc' 'ABC' 0) #('A' 'a' 0) #('' 'a' -1) #('a' 'ab' -1) #('ab' 'a' 1) #('a' 1 'failed0'))
		do: 
			[:each |
			| subject result operand expected |
			subject := each first.
			self assert: subject class == String.
			operand := each second.
			expected := each third.
			result := method value: subject withArguments: {operand}.
			self assert: result class == expected class.
			self assert: result equals: expected].
	self has7052OrLater
		ifTrue: 
			[self assert: (method value: 'a' withArguments: {Array new}) equals: 'failed1'.
			"Weak pointer objects use the same OTE flag as zero-terminated byte objects"
			self assert: (method value: 'a' withArguments: {WeakArray new}) equals: 'failed1']
		ifFalse: 
			["Older VM always uses failure code 0"
			self assert: (method value: 'a' withArguments: {Array new}) equals: 'failed0'

			"Older VM incorrectly treats weak pointer object as zero terminated string"]!

testPrimitiveStringNextIndexOfFromTo
	| method foundCases nonIntegerToFrom fromOutOfBounds toOutOfBounds emptyIntervalBounds notFoundCases |
	method := self createPrimitiveMethodLike: String >> #nextIndexOf:from:to: setsFailCode: true.
	foundCases := #(#('aabc' $a 1 1 1) #('aabc' $a 1 2 1) #('a' $a 1 1 1) #('aabc' $a 2 3 2) #('abc' $c 1 3 3) #('abac' $a 2 4 3)).
	nonIntegerToFrom := #(#('aabc' $a $b 4 'failed1') #('aabc' $a nil 4 'failed1') #('aabc' $a 1 nil 'failed0')).
	fromOutOfBounds := #(#('aabc' $a 0 4 'failed2') #('aabc' $a -1 4 'failed2')).
	emptyIntervalBounds := #(#('aabc' $a 1 -1 0) #('aabc' $a 1 0 0) #('aabc' $a 4 3 0) #('aabc' $a 5 4 0) #('' $a 1 0 0)).
	toOutOfBounds := #(#('aabc' $a 1 5 'failed2') #('' $a 1 2 'failed2')).
	notFoundCases := #(#('aabc' $d 1 1 0) #('aabc' $d 1 2 0) #('abc' $d 1 3 0) #('abac' nil 1 4 0))
				asOrderedCollection.
	self has7053OrLater
		ifTrue: 
			["Fails on earlier VM, as it truncates the codepoint to the first byte, which means $\x161 gets treated as $a"
			notFoundCases add: {'abc'. Character value: 16r161. 1. 3. 0}].
	foundCases , nonIntegerToFrom , fromOutOfBounds , emptyIntervalBounds , toOutOfBounds
		, notFoundCases do: 
				[:each |
				| subject actual char start stop expected |
				subject := each first.
				char := each second.
				start := each third.
				stop := each fourth.
				expected := each last.
				actual := method value: subject withArguments: {char. start. stop}.
				self assert: actual equals: expected]!

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
			result := method value: subject withArguments: {operand}.
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

testQwordAtOffset
	"Note that this test assumes running on a little-endian machine with 32-bit SmallIntegers."

	| bytes actual |
	bytes := #[].
	self should: [bytes qwordAtOffset: 0] raise: BoundsError.
	bytes := #[1 2 3 4 5 6 7].
	self should: [bytes qwordAtOffset: 0] raise: BoundsError.
	bytes := #[1 2 3 4 5 6 7 8].
	self should: [bytes qwordAtOffset: -1] raise: BoundsError.
	self should: [bytes qwordAtOffset: 1] raise: BoundsError.
	self should: [bytes qwordAtOffset: nil] raise: Error.
	self assert: (bytes qwordAtOffset: 0) equals: 16r807060504030201.
	"Misaligned"
	bytes := bytes copyWith: 16rAB.
	self assert: (bytes qwordAtOffset: 1) equals: 16rAB08070605040302.
	"SmallIntegers"
	bytes := ByteArray fromHexString: 'FFFFFFFF0000000000000000'.
	self assert: (bytes qwordAtOffset: 4) equals: 0.
	self assert: SmallInteger maximum byteSize equals: 4.	"Inconclusive if this is not so"
	bytes := ByteArray fromHexString: 'FFFFFF3F00000000'.
	self assert: (bytes qwordAtOffset: 0) sameAs: 16r3FFFFFFF.
	"Overflows SmallInteger"
	bytes := ByteArray fromHexString: '0000004000000000'.
	actual := bytes qwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual equals: 16r40000000.
	"Largest 4-byte large integer"
	bytes := ByteArray fromHexString: 'FFFFFF7F00000000'.
	actual := bytes qwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 4.
	self assert: actual equals: 16r7FFFFFFF.
	"Smallest 8-byte large integer"
	bytes := ByteArray fromHexString: '0000008000000000'.
	actual := bytes qwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 8.
	self assert: actual equals: 16r80000000.
	"Largest 8-byte large integer"
	bytes := ByteArray fromHexString: 'FFFFFFFFFFFFFF7F'.
	actual := bytes qwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 8.
	self assert: actual equals: 16r7FFFFFFFFFFFFFFF.
	"Smallest 12-byte large integer"
	bytes := ByteArray fromHexString: '0000000000000080'.
	actual := bytes qwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 12.
	self assert: actual equals: 16r8000000000000000.
	"Largest value"
	bytes := ByteArray fromHexString: 'FFFFFFFFFFFFFFFF'.
	actual := bytes qwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 12.
	self assert: actual equals: 16rFFFFFFFFFFFFFFFF!

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

testSqwordAtOffset
	"Note that this test assumes running on a little-endian machine with 32-bit SmallIntegers."

	| bytes actual |
	bytes := #[].
	self should: [bytes sqwordAtOffset: 0] raise: BoundsError.
	bytes := #[1 2 3 4 5 6 7].
	self should: [bytes sqwordAtOffset: 0] raise: BoundsError.
	bytes := #[1 2 3 4 5 6 7 8].
	self should: [bytes sqwordAtOffset: -1] raise: BoundsError.
	self should: [bytes sqwordAtOffset: 1] raise: BoundsError.
	self should: [bytes sqwordAtOffset: nil] raise: Error.
	self assert: (bytes sqwordAtOffset: 0) equals: 16r0807060504030201.
	"Misaligned"
	bytes := bytes copyWith: 16rAB.
	self assert: (bytes sqwordAtOffset: 1) equals: -16r54F7F8F9FAFBFCFE.
	"SmallIntegers"
	bytes := ByteArray fromHexString: 'FFFFFFFF0000000000000000'.
	self assert: (bytes sqwordAtOffset: 4) equals: 0.
	self assert: SmallInteger maximum byteSize equals: 4.	"Inconclusive if this is not so"
	bytes := ByteArray fromHexString: 'FFFFFF3F00000000'.
	self assert: (bytes sqwordAtOffset: 0) sameAs: 16r3FFFFFFF.
	bytes := ByteArray fromHexString: '000000C0FFFFFFFF'.
	self assert: (bytes sqwordAtOffset: 0) sameAs: -16r40000000.
	"Overflows SmallInteger (any value in lower 32-bits is treated as positive)"
	bytes := ByteArray fromHexString: '0000004000000000'.
	actual := bytes sqwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual equals: 16r40000000.
	"Largest 4-byte large integer"
	bytes := ByteArray fromHexString: 'FFFFFF7F00000000'.
	actual := bytes sqwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 4.
	self assert: actual equals: 16r7FFFFFFF.
	"Smallest 8-byte large integer"
	bytes := ByteArray fromHexString: '0000008000000000'.
	actual := bytes sqwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 8.
	self assert: actual equals: 16r80000000.
	"Largest 8-byte large positive integer"
	bytes := ByteArray fromHexString: 'FFFFFFFFFFFFFF7F'.
	actual := bytes sqwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 8.
	self assert: actual equals: 16r7FFFFFFFFFFFFFFF.
	"Largest 8-byte large negative integer"
	bytes := ByteArray fromHexString: '0000000000000080'.
	actual := bytes sqwordAtOffset: 0.
	self assert: actual isKindOf: LargeInteger.
	self assert: actual byteSize equals: 8.
	self assert: actual equals: -16r8000000000000000.
	"Largest value, smallest negative (-1)"
	bytes := ByteArray fromHexString: 'FFFFFFFFFFFFFFFF'.
	actual := bytes sqwordAtOffset: 0.
	self assert: actual sameAs: -1!

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
	self assert: (losses at: id2) equals: 3!

verifyPrimitiveAt: opAt performBlock: performAt
	| array outOfBounds |
	array := (-100 to: 100) asArray.
	-100 to: 100
		do: 
			[:i |
			self assert: (opAt value: array value: i + 100 + 1) sameAs: i.
			self assert: (performAt value: array value: i + 100 + 1) sameAs: i].
	"Valid case, first and last, with and without named fields"
	array := {'a'. 'b'}.
	self assert: (opAt value: array value: 1) equals: 'a'.
	self assert: (opAt value: array value: 2) equals: 'b'.
	array := MourningWeakArray with: 'a' with: 'b'.
	self assert: (opAt value: array value: 1) equals: 'a'.
	self assert: (opAt value: array value: 2) equals: 'b'.
	#(#(2) #[2]) do: 
			[:a |
			self assert: (opAt value: a value: 1) sameAs: 2.
			self assert: (performAt value: a value: 1) sameAs: 2].
	"Non-indexable object"
	#(1 0 nil) do: 
			[:each |
			{opAt. performAt} do: 
					[:op |
					self
						should: [op value: Array value: each]
						raise: Error
						matching: [:ex | ex messageText = 'not indexable']]].
	"Now attempt some out of bounds accesses in mutable and immutable arrays"
	outOfBounds := {-1. 0. 2. SmallInteger maximum. SmallInteger minimum}.
	{{2}. ByteArray with: 2. #(1). #[1]} do: 
			[:subject |
			outOfBounds do: 
					[:each |
					self should: [opAt value: subject value: each] raise: BoundsError.
					self should: [performAt value: subject value: each] raise: BoundsError]].
	"Repeat for an object with one named instance variable and no #at:/#basicAt: override"
	array := MourningWeakArray with: 2.
	self assert: (opAt value: array value: 1) sameAs: 2.
	self assert: (performAt value: array value: 1) sameAs: 2.
	outOfBounds do: 
			[:each |
			self should: [opAt value: array value: each] raise: BoundsError.
			self should: [performAt value: array value: each] raise: BoundsError].

	"And again for one with a number of named instance variables (a method)"
	array := Object compiledMethodAt: #addDependent:.
	self assert: (opAt value: array value: 1) sameAs: #getDependents.
	self should: 
			[| lit |
			lit := opAt value: array value: 2.
			lit == WeakArray or: [(lit isKindOf: VariableBinding) and: [lit value == WeakArray]]].
	self assert: (opAt value: array value: 3) sameAs: #setDependents:.
	self assert: (opAt value: array value: array size) sameAs: #add:.
	{-1. 0. array size + 1. SmallInteger maximum. SmallInteger minimum} do: 
			[:each |
			self should: [opAt value: array value: each] raise: BoundsError.
			self should: [performAt value: array value: each] raise: BoundsError].
	"LargeIntegers"
	{SmallInteger maximum + 1.
		(2 raisedToInteger: 31) - 1.
		2 raisedToInteger: 31.
		(2 raisedToInteger: 32) - 1.
		2 raisedToInteger: 32.
		SmallInteger minimum - 1.
		-2 raisedToInteger: 31} do: 
				[:each |
				self should: [opAt value: array value: each] raise: BoundsError.
				self should: [performAt value: array value: each] raise: BoundsError].
	"Non-integer indices"
	#($1 '1' nil true false #[1] #'1' #(1)) do: 
			[:each |
			{opAt. performAt} do: 
					[:block |
					self
						should: [block value: array value: each]
						raise: Error
						matching: [:ex | ex messageText = ('Index: <1p> is not an integer' expandMacrosWith: each)]]]!

verifyPrimitiveAtPut: opAtPut performBlock: performAtPut
	| bytes arrays |
	#(1 0 nil) do: 
			[:each |
			{opAtPut. performAtPut} do: 
					[:block |
					self
						should: 
							[block
								value: Array
								value: each
								value: nil]
						raise: Error
						matching: [:ex | ex messageText = 'not indexable']]].
	arrays := {Array with: 0. ByteArray with: 0. MourningWeakArray with: 0}.
	arrays do: 
			[:array |
			{opAtPut. performAtPut} do: 
					[:block |
					self should: 
							[(block
								value: array
								value: 1
								value: 123) == 123
								and: [(array at: 1) == 123]].
					"On second access, may be cached"
					self should: 
							[(block
								value: array
								value: 1
								value: 255) = 255 and: [(array at: 1) = 255]]]].
	"ByteArrays can only hold 0..255"
	bytes := ByteArray new: 1.
	#(-1 256 '1') do: 
			[:each |
			{opAtPut. performAtPut} do: 
					[:block |
					self should: 
							[block
								value: bytes
								value: 1
								value: each]
						raise: Error]].
	"Now attempt some out of bounds accesses"
	{-1.
		0.
		2.
		SmallInteger maximum.
		SmallInteger minimum.
		SmallInteger maximum + 1.
		(2 raisedToInteger: 31) - 1.
		2 raisedToInteger: 31.
		(2 raisedToInteger: 32) - 1.
		2 raisedToInteger: 32.
		SmallInteger minimum - 1.
		-2 raisedToInteger: 31} do: 
				[:each |
				arrays do: 
						[:array |
						{opAtPut. performAtPut} do: 
								[:block |
								self should: 
										[block
											value: array
											value: each
											value: nil]
									raise: BoundsError]]]!

vmRespectsNonInstantiable
	^self isAtLeastVmVersion: self firstVmVersionRespectingNonInstantiable! !
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
!VMTest categoriesFor: #firstVmVersionRespectingNonInstantiable!constants!private! !
!VMTest categoriesFor: #has7052OrLater!private!testing! !
!VMTest categoriesFor: #has7053OrLater!private!testing! !
!VMTest categoriesFor: #has7054OrLater!private!testing! !
!VMTest categoriesFor: #hashBytes:!helpers!private! !
!VMTest categoriesFor: #isFault:raisedIn:receiver:!helpers!private! !
!VMTest categoriesFor: #isGPF:reading:address:!helpers!private! !
!VMTest categoriesFor: #suspendAndTerminate!helpers!private! !
!VMTest categoriesFor: #testBSTRArg!public!unit tests! !
!VMTest categoriesFor: #testCRTFault!public!unit tests! !
!VMTest categoriesFor: #testDwordAtOffsetPut!public!unit tests! !
!VMTest categoriesFor: #testEvaluationOrder!public!unit tests! !
!VMTest categoriesFor: #testExtCallRetHRESULT!public!unit tests! !
!VMTest categoriesFor: #testExtCallRetLpwstr!public!unit tests! !
!VMTest categoriesFor: #testFPFaultInPrimitive!public!unit tests! !
!VMTest categoriesFor: #testFPStatus!public!unit tests! !
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
!VMTest categoriesFor: #testIndirectByteAtOffsetPrimitives!public!unit tests! !
!VMTest categoriesFor: #testIndirectDwordAtOffsetPrimitives!public!unit tests! !
!VMTest categoriesFor: #testIndirectSdwordAtOffsetPrimitives!public!unit tests! !
!VMTest categoriesFor: #testIndirectSwordAtOffsetPrimitives!public!unit tests! !
!VMTest categoriesFor: #testIndirectWordAtOffsetPrimitives!public!unit tests! !
!VMTest categoriesFor: #testIntDivideByZero!public!unit tests! !
!VMTest categoriesFor: #testMakeLargeUnsigned!public!unit tests! !
!VMTest categoriesFor: #testMustBeBoolean!public!unit tests! !
!VMTest categoriesFor: #testOverlappedCallsSuspendAndTerminate!public!unit tests! !
!VMTest categoriesFor: #testOverlappedCallTermination!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveAllInstances!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveAt!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveAtPut!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveBasicAt!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveBasicAtPut!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveBytesEqual!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveBytesIsNull!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveEnableInterrupts!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveExtraInstanceSpec!public! !
!VMTest categoriesFor: #testPrimitiveFindString!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveHashBytes!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveIdentical!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveInstanceCounts!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveInstanceCounts2!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveInstVarAt!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveInstVarAtPut!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveIsKindOf!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveIsNullBytes!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveLookupMethod!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveMakePoint!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveNewColonFailure!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveNewFailure!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveNewFixedFailure!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveNewInitializedFailure!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveNewVirtualFailure!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveNextPut!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveObjectCount!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveReplaceElements!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveResume!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveSetSpecialBehavior!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveShallowCopy!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveSize!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringAt!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringAtPut!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringCmp!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringCollate!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveStringNextIndexOfFromTo!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveSubtract!public!unit tests! !
!VMTest categoriesFor: #testPrimitiveYourAddress!public!unit tests! !
!VMTest categoriesFor: #testQwordAtOffset!public!unit tests! !
!VMTest categoriesFor: #testSignedFromUnsigned!public!unit tests! !
!VMTest categoriesFor: #testSqwordAtOffset!public!unit tests! !
!VMTest categoriesFor: #testVMPointersImmutable!public!unit tests! !
!VMTest categoriesFor: #testWeakMournerNotifications!public!unit tests! !
!VMTest categoriesFor: #verifyPrimitiveAt:performBlock:!helpers!private! !
!VMTest categoriesFor: #verifyPrimitiveAtPut:performBlock:!helpers!private! !
!VMTest categoriesFor: #vmRespectsNonInstantiable!private!testing! !

!VMTest class methodsFor!

resources
	^{MustBeBooleanTestClasses}! !
!VMTest class categoriesFor: #resources!Accessing!public! !

