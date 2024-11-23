"Filed out from Dolphin Smalltalk"!

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
	| value |
	anObject isImmutable: true.
	value := anObject at: 1.
	self should: [anObject at: 0 put: value] raise: BoundsError.
	1 to: anObject size + 1
		do: [:each | self should: [anObject at: each put: value] raise: Processor constWriteSignal]!

assertImmutableBasicAtPut: anObject
	| value |
	self assert: anObject isImmutable.
	value := anObject basicAt: 1.
	self should: [anObject basicAt: 0 put: value] raise: BoundsError.
	1 to: anObject size + 1
		do: [:each | self should: [anObject basicAt: each put: value] raise: Processor constWriteSignal]!

assertImmutableInstVarAtPut: anObject
	| size value |
	self assert: anObject isImmutable.
	value := anObject instVarAt: 1.
	self should: [anObject instVarAt: 0 put: value] raise: BoundsError.
	size := anObject class instSize + anObject basicSize.
	1 to: size + 1
		do: [:each | self should: [anObject instVarAt: each put: value] raise: Processor constWriteSignal]!

assertImmutableResize: anObject
	self assert: anObject isImmutable.
	"Should get an error on any resize attempt, whether doesn't change size, grows or shrinks"
	#(0 1 -1)
		do: [:i | self should: [anObject resize: anObject size + i] raise: Processor constWriteSignal]!

assertLoopInterruptible: aBlock
	| interruptTimes start intervals execTime sampleInterval go finished |
	interruptTimes := OrderedCollection new.
	sampleInterval := 2 milliseconds.
	finished := Semaphore new.
	go := true.
	
	[
	[sampleInterval wait.
	go] whileTrue: [interruptTimes addLast: Time microsecondClockValue].
	finished signal]
			forkAt: Processor userInterruptPriority.
	start := Time microsecondClockValue.
	aBlock value.
	execTime := (Time microsecondClockValue - start) microseconds.
	go := false.
	finished wait.
	self assert: (interruptTimes size > 2
				and: [interruptTimes size * 2 >= (execTime / sampleInterval) asFloat]).
	intervals := OrderedCollection new.
	interruptTimes inject: start
		into: 
			[:last :each |
			intervals add: (each - last) microseconds.
			each].
	self assert: (intervals allSatisfy: [:each | each < (sampleInterval * 2.5)])!

compile: text in: aBehavior
	| method |
	method := Compiler compile: text in: aBehavior.
	self deny: method identicalTo: nil.
	method sourceDescriptor: text.
	^method!

createPrimitiveMethod: anInteger in: aBehavior argCount: argc
	| text |
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
		nextPutAll: '> ^_PrimitiveFailureCode keyAtValue:  _failureCode'.
	^self compile: text contents in: aBehavior!

createPrimitiveMethodLike: aCompiledMethod
	^self
		createPrimitiveMethod: aCompiledMethod primitiveIndex
		in: aCompiledMethod methodClass
		argCount: aCompiledMethod argumentCount!

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
		ifTrue: [self assert: a == 0 | (a == 3) description: 'Unexpected state ', aCopy printString]
		ifFalse: 
			[| count |
			"On occasion NT will put Dolphin to sleep for 50mS+ and consequentlty the Process will have finished up anyway"

			"The Process will not be able to terminate until the overlapped call completes"
			self assert: (list == Processor pendingTerminations or: [list == proc threadSync]) description: 'Terminated call waiting on unexpected list ', list printString.
			"a will still be run, because the VM will not reschedule the process to run the curtailment block until the overlapped
		call can be terminated."
			self assert: aCopy identicalTo: 2.

			"Let the sleep: complete (allow a reasonable period so we can be fairly sure  it does)"
			count := 0.
			[a ~= 0 and: [count < 500]] whileTrue: 
					[Processor sleep: 1 milliseconds.
					count := count + 1].
			"The curtailment block should now have run"
			self assert: a identicalTo: 0.
			"and the process should also die fairly quickly after that"
			count := 0.
			[proc isTerminated not and: [count < 50]] whileTrue: 
					[Processor sleep: 1 milliseconds.
					count := count + 1].
			self assert: proc isTerminated description: 'Process not terminated: ', proc printString.
			self assert: Processor pendingTerminations isEmpty description: 'There are still pending terminations']!

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
	self assert: fieldsAfter equals: fieldsBefore.
	"Build the expected result using low-level operations to avoid inadvertently using the primitive under test"
	expected := targetCollection class ofSize: targetCollection size.
	1 to: startInteger - 1 do: [:i | expected at: i put: (targetCollection at: i)].
	startInteger to: stopInteger
		do: [:i | expected at: i put: (sourceCollection at: i - startInteger + startAtInteger)].
	stopInteger + 1 to: targetCollection size do: [:i | expected at: i put: (targetCollection at: i)].
	"Did it work?"
	self assert: target equals: expected!

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

getCPUTime
	"Private - Answer the total CPU time consumed by Dolphin's main thread."

	| user kernel ignored |
	ignored := FILETIME new.
	user := FILETIME new.
	kernel := FILETIME new.
	KernelLibrary default
		getThreadTimes: KernelLibrary default getCurrentThread
		lpCreationTime: ignored
		lpExitTime: ignored
		lpKernelTime: kernel
		lpUserTime: user.
	^Duration microseconds: (kernel asInteger + user asInteger) / 10!

hasDolphinCrtInvalidParameterHandler
	"Private - Unfortunately the MySql ODBC driver installs a CRT invalid parameter handler that breaks tests of the Dolphin handler because it just returns and does not chain - see https://github.com/mysql/mysql-connector-odbc/blob/trunk/mysql_sys/my_init.cc#L420. DLLs should try and avoid affecting the global state set by an application, and so should not be installing a global handler for invalid parameters in the CRT that persists when the library is not active. If this is really necessary, it should be done only for the duration of the calls into the library, not globally. Fortunately we don't really need the Dolphin handler for anything other than detecting errors so they can be handled from Smalltalk. If you really have to use MySql, then then this particular piece of poor engineering isn't likely to cause major problems in itself."

	^CRTLibrary default _get_invalid_parameter_handler = (VMLibrary default getProcAddress: 'invalidParameterHandler')!

hashBytes: aByteArray
	"Private - PJW hash (Aho, Sethi, and Ullman pp. 434-438).
	Note that this algorithm is optimised for ASCII characters, making it a good choice for symbols, but probably not as a general byte hash algorithm."

	| h |
	h := 2166136261.
	1 to: aByteArray size
		do: 
			[:i |
			h := h bitXor: (aByteArray basicAt: i).
			h := (h * 16777619) bitAnd: 16rFFFFFFFF].
	^(h >> 30) bitXor: (h & 16r3FFFFFFF)!

immutableTestSubjects
	^#(#(1 2 3) #[1 2 3] 'abc' 1.0e38 ##('abc' asUtf8String
		isImmutable: true;
		yourself) ##('abc' asUtf16String
		isImmutable: true;
		yourself))!

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

skipIfVMDoesNotSupportArgumentConversionsThatAllocateMemoryInOverlappedCalls
	"Private - Currently it is not safe to performed overlapped calls with parameter types that require conversion and need to allocate memory to perform the conversion. E.g. an lpwstr parameter passed a Utf8String argument. The workaround is to ensure that the arguments are converted to the correct type in Smalltalk, e.g. by sending #asUtf16String to any strings passed as arguments to lpwstr parameters."

	^self skip!

suspendAndTerminate
	"N.B. Timing is critical to much of this, so its not going to be possible to debug through it. Its really only to show up
	problems in the VM, so debugging at the Smalltalk level is not terribly useful anyway."

	| proc a i |
	"1) Call requests completion, but is suspended before Interpreter allows it to complete, then terminated"
	self assert: Processor pendingTerminations isEmpty.
	proc := 
			[a := 1.
			KernelLibrary default sleep: 10.
			a := 2] forkAt: Processor userInterruptPriority.	"High priority background proc runs but then blocks..."
	self assert: proc isWaiting.	"proc should be blocked on the overlapped call semaphore"
	self assert: a identicalTo: 1.
	proc suspend.	"suspend it before it gets a chance to queue its termination request"
	self assert: proc isSuspended.
	Processor sleep: 20 milliseconds.	"wait for the overlapped call to complete"
	self assert: proc isSuspended.
	self assert: a identicalTo: 1.
	proc terminate.
	i := 1.
	
	[Processor sleep: 10 milliseconds.
	proc isTerminated or: [i > 100]] whileFalse: [i := i + 1].
	self assert: proc isTerminated.
	self assert: a identicalTo: 1.
	self assert: Processor pendingTerminations isEmpty

	"2) Ditto, but resumed and so allowed to complete"!

testAllReferences
	| object refs weak |
	object := Array new: 1.
	refs := object allReferences.
	self assert: refs equals: {Processor activeProcess}.
	object at: 1 put: object.
	refs := object allReferences.
	self assert: (refs noDifference: {Processor activeProcess. object})!

testAllReferencesWeak
	| object refs weak |
	object := Object new.
	weak := WeakArray with: object.
	refs := object allReferences.
	self assert: (refs noDifference: {Processor activeProcess. weak}).
	refs := object allReferences: false.
	self assert: (refs noDifference: {Processor activeProcess}).

!

testBSTRArg
	"#1377 - Make sure there is no problem in the VM's automatic conversion of a string to a BSTR.
	In an unpatched VM this typically crashes the whole system."

	| method |
	method := Compiler compile: 'test: aString <stdcall: bstr AnswerDWORD bstr>' in: VMLibrary.
	1000 timesRepeat: 
			[| bstr |
			bstr := method value: VMLibrary default withArguments: #('Some 🐬 data').
			self assert: bstr value equals: 'Some 🐬 data'.
			bstr free]!

testCRTFault
	"Tests that the VM sends an interrupt when the CRT is passed an invalid parameter and calls
	the invalid parameter handler (issue #59). On an unfixed V2015 VM this will just crash."

	| crt |
	self skipUnless: [self hasDolphinCrtInvalidParameterHandler].
	crt := CRTLibrary default.
	self
		should: 
			[Processor enableAsyncEvents: false.
			crt _close: -1]
		raise: CRTError
		matching: 
			[:err |
			"Verify that the fault is dispatched synchronously"
			self
				isFault: err
				raisedIn: CRTLibrary >> #_close:
				receiver: crt]!

testDwordAtOffsetPut
	| bytes dword max |
	bytes := ByteArray new: 4.
	{'s'. SmallInteger maximum + 1. Object new} do: 
			[:each |
			self
				should: [bytes dwordAtOffset: each put: 1]
				raise: Error
				matching: [:ex | ex messageText = ('Index: <1p> is not an integer' expandMacrosWith: each)]].
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
			self assert: (bytes dwordAtOffset: each - 4) equals: dword.
			"This large integer will be 8-bytes long"
			dword := dword + 1.
			self assert: dword isImmutable.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: (bytes dwordAtOffset: each - 4) equals: dword.
			dword := 16rFFFFFFFF.
			self assert: dword isImmutable.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: bytes equals: (ByteArray new: each - 4) , #[16rFF 16rFF 16rFF 16rFF].
			bytes dwordAtOffset: each - 4 put: #[16rAA 16rBB 16rCC 16rDD].
			self assert: (bytes dwordAtOffset: each - 4) equals: 16rDDCCBBAA.
			dword := DWORD fromInteger: 16r11223344.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: (bytes dwordAtOffset: each - 4) equals: 16r11223344.
			dword isImmutable: true.
			bytes := ByteArray new: each.
			bytes dwordAtOffset: each - 4 put: dword.
			self assert: (bytes dwordAtOffset: each - 4) equals: 16r11223344.
			bytes := ByteArray new: each.
			bytes isImmutable: true.
			self should: [bytes dwordAtOffset: each - 4 put: 1] raise: Processor constWriteSignal]!

testEvaluationOrder
	| i |
	i := 2.
	self assert: (3 between: i and: (i := 4))!

testExtCallArgBstr
	"Note that BSTR is one of the FFI parameter types that may cause the VM to perform a type conversion that allocates memory, and as such cannot be used safely in overlapped calls unless the calling code is careful to perform all conversions to BSTR from Smalltalk strings in advance with #asBSTR"

	| beers |
	{''. 'a'. '£2'. 'a' , (String with: Character null) , 'b'} do: 
			[:each |
			| subject expected actual |
			expected := each asUtf16String size.
			actual := OLEAutLibrary default sysStringLen: each.
			self assert: actual equals: expected.
			subject := each asUtf8String.
			actual := OLEAutLibrary default sysStringLen: subject.
			self assert: actual equals: expected.
			subject := each asUtf16String.
			actual := OLEAutLibrary default sysStringLen: subject.
			self assert: actual equals: expected].
	"Like most string length functions, SysStringLen reports the number of code units, not the number of characters"
	beers := Utf8String fromByteArray: #[16rF0 16r9F 16r8D 16rBB].
	self assert: (OLEAutLibrary default sysStringLen: beers) equals: 2.
	self assert: (OLEAutLibrary default sysStringLen: beers asUtf16String) equals: 2!

testExtCallArgChar32
	| method |
	method := Compiler compile: 'test: aCharacter <stdcall: char32 AnswerDWORD char32>' in: VMLibrary.
	#($\0 $\t $\x7F $\x80 $ÿ $Ā $€ $𐀀 $🐬 $\xFFFD)
		do: [:each | self assert: (method value: VMLibrary default withArguments: {each}) equals: each]!

testExtCallArgLppvoid
	"Regression test for https://github.com/dolphinsmalltalk/Dolphin/issues/940
	The issue was intermittent failure of some Active-X related tests that were passing out (and in some cases handling incoming) pointers to buffers that were arrays of pointers and doing so by taking the address of the buffer (yielding an integer) before calling the function with an lppvoid argument type.
	It turns out that there is a very longstanding bug in the VM FFI that it doesn't correctly handle LargeInteger address values as lppvoid args. Originally when Dolphin was written it expected to run in a 2Gb address space, so addresses were very unlikely to fall outside the SmallInteger range. However at some point in the recent past the application was marked as LARGEADDRESSAWARE, meaning that it is given the full 4GB address space when running on a 64-bit host OS, and a 3Gb address space on a 32-bit host OS. Even so the OS allocates dynamic memory bottom up by default, so it is unusual to encounter an address value that doesn't fit in a SmallInteger. This test forcibly creates LargeInteger address values to check that they pass through such FFI calls correctly."

	self verifyExtCallArgLppvoid: false!

testExtCallArgLpwstr
	self verifyExtCallArgLpwstr: false!

testExtCallCrtFault
	self skipUnless: [self hasDolphinCrtInvalidParameterHandler].
	self verifyExtCallCrtFault: false!

testExtCallFpFault
	self verifyExtCallFpFault: false!

testExtCallGpf
	"Test what happens when the called function GPFs"

	self verifyExtCallGpf: false!

testExtCallIntDivZero
	"Test what happens when the called function divides by zero"

	self verifyExtCallIntDivZero: false!

testExtCallOverlappedArgLppvoid
	self verifyExtCallArgLppvoid: true!

testExtCallOverlappedArgLpwstr
	self skipIfVMDoesNotSupportArgumentConversionsThatAllocateMemoryInOverlappedCalls.
	self verifyExtCallArgLpwstr: true!

testExtCallOverlappedBool8
	self verifyExtCallRetBool8: true!

testExtCallOverlappedCrtFault
	self verifyExtCallCrtFault: true!

testExtCallOverlappedFpFault
	self verifyExtCallFpFault: true!

testExtCallOverlappedGC
	| kernel event finished delay1 delay2 |
	kernel := KernelLibrary default.
	event := kernel
				createEvent: nil
				bManualReset: false
				bInitialState: false
				lpName: nil.
	finished := false.
	delay1 := Delay forDuration: 50 milliseconds.
	delay2 := Delay forDuration: 20 milliseconds.
	
	[delay1 signal.
	kernel waitForSingleObject: event dwMilliseconds: -1.
	finished := true.
	delay2 signal]
			forkAt: Processor userInterruptPriority.
	self deny: finished.
	delay1 wait.
	1 timesRepeat: 
			[MemoryManager current
				collectGarbage;
				administerLastRites].
	self deny: finished.
	kernel setEvent: event.
	delay2 wait.
	self assert: finished!

testExtCallOverlappedGpf
	"Test what happens when the called function GPFs in an overlapped call thread"

	self verifyExtCallGpf: true!

testExtCallOverlappedIntDivZero
	"Test what happens when the called function divides by zero"

	self verifyExtCallIntDivZero: true!

testExtCallOverlappedRetErrno
	self verifyExtCallRetErrno: true!

testExtCallOverlappedRetHRESULT
	"Test that HRESULT return codes are translated into exceptions correctly by overlapped calls."

	self verifyExtCallRetHRESULT: true!

testExtCallOverlappedRetLpwstr
	self verifyExtCallRetLpwstr: true!

testExtCallOverlappedRetNtStatus
	self verifyExtCallRetNtStatus: true!

testExtCallOverlappedSuspendAndTerminate
	5 timesRepeat: [self suspendAndTerminate]!

testExtCallOverlappedTermination
	"N.B. Timing is critical to much of this, so its not going to be possible to debug through it. Its really only to show up
	problems in the VM, so debugging at the Smalltalk level is not terribly useful anyway."

	"1) Call is terminated before completion, before it has even started in fact"

	1 to: 5 do: [:i | self earlyTermination: false].
	"2) Call is terminated before completion, but is allowed to start"
	1 to: 5 do: [:i | self earlyTermination: true]!

testExtCallRetErrno
	self verifyExtCallRetErrno: false!

testExtCallRetHRESULT
	"Test that HRESULT return codes are translated into exceptions correctly."

	self verifyExtCallRetHRESULT: false!

testExtCallRetLpwstr
	self verifyExtCallRetLpwstr: false!

testExtCallRetNtStatus
	self verifyExtCallRetNtStatus: false!

testExtendedCharsInCrashDump
	| path dumped index |
	path := File temporaryFilename.
	VMLibrary default
		dump: 'abc' , (String with: Character dolphin)
		path: path
		stackDepth: 0
		walkbackDepth: 1.
	dumped := File readAllText: path.
	index := dumped indexOf: Character dolphin.
	self deny: index equals: 0.
	self assert: dumped size > (index + 4).
	File delete: path!

testFPFaultInPrimitive
	"An FP fault occurring in a primitive should be reported in the primitive method, not some
	subsequently invoked method, even when interrupts are off."

	| mask receiver |
	mask := Float exceptionMask: (_MCW_EM maskClear: CRTConstants._EM_OVERFLOW).
	receiver := 2.0.
	
	[self
		should: [(receiver timesTwoPower: Float emax) * 5.0]
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
	self immutableTestSubjects do: 
			[:each |
			| a |
			self assertImmutableAtPut: each.
			a := each copy.
			a isNumber
				ifFalse: 
					[self assert: a isImmutable not.
					1 to: 3 do: [:i | a at: i put: (a at: 3 - i + 1)].
					a isImmutable: true].
			self assertImmutableAtPut: a].
	self assertImmutableAtPut: #abc!

testImmutableBasicAtPut
	self immutableTestSubjects do: 
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
	instances := OrderedCollection withAll: self immutableTestSubjects.
	"The compiler test class has a lot of named iv's"
	instances add: (CompilerTestClasses current testClass new
				isImmutable: true;
				yourself).
	"Sets have named and indexable variables"
	instances add: (self class methodDictionary values asSet
				isImmutable: true;
				yourself).
	instances do: 
			[:each |
			| a size |
			self assertImmutableInstVarAtPut: each.
			a := each copy.
			a isNumber
				ifFalse: 
					[self assert: a isImmutable not.
					size := a class instSize + a basicSize.
					1 to: size do: [:i | a instVarAt: i put: (a instVarAt: size - i + 1)].
					a isImmutable: true].
			self assertImmutableInstVarAtPut: a].
	self assertImmutableInstVarAtPut: #abc!

testImmutableNextPut
	(self immutableTestSubjects reject: [:each | each isNumber]) do: 
			[:s |
			| strm |
			self assertImmutableAtPut: s.
			strm := WriteStream on: s.
			self should: [strm nextPut: s last] raise: Processor constWriteSignal]!

testImmutableNextPutAll
	{#[1 2 3]. 'abc'. #(1 2 3). 'abc' asUtf8String. 'abc' asUtf16String. #abc} do: 
			[:each |
			| strm |
			each isImmutable: true.
			self assertImmutableAtPut: each.
			strm := WriteStream on: each.
			self should: [strm nextPutAll: (each copyFrom: 2 to: 3)] raise: Processor constWriteSignal].
	{Utf8String. Utf16String} do: 
			[:eachTarget |
			{AnsiString. Utf8String. Utf16String} do: 
					[:each |
					self should: 
							[((eachTarget with: $\x1F42C)
								isImmutable: true;
								yourself) writeStream
								nextPutAll: (each with: $£)]
						raise: Processor constWriteSignal]]!

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
	self assert: s1 equals: s2!

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
	#(16r10000 -16r8001) do: 
			[:each |
			self
				should: [p swordAtOffset: 0 put: each]
				raise: HRESULTError
				matching: [:ex | ex hresult = ##(HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]].

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
	#(-1 16r10000 -16r8001) do: [:each | self should: [p wordAtOffset: 0 put: each] 
				raise: HRESULTError
				matching: [:ex | ex hresult = ##(HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]].

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

testInterruptPendingOverlappedCall
	"Test sending a VM interrupt to a Process blocked waiting on an overlapped call"

	| evt continue kernel32 |
	kernel32 := KernelLibrary default.
	evt := kernel32
				createEvent: nil
				bManualReset: false
				bInitialState: false
				lpName: nil.
	
	[| done sem wait proc |
	wait := 0.
	continue := true.
	proc := 
			[
			[wait := wait + 1.
			[kernel32 waitForSingleObject: evt dwMilliseconds: 1000] on: HRESULTError
				do: [:ex | continue := false].
			continue]
					whileTrue]
					forkAt: 7.
	self assert: wait equals: 1.
	"Interrupt completes while the overlapped call is still pending"
	done := 0.
	proc interruptWith: [done := 1].
	Processor yield.
	self assert: done equals: 1.
	self assert: wait equals: 1.
	kernel32 setEvent: evt.
	5 milliseconds wait.
	self assert: wait equals: 2.
	"Interrupt is waiting when the overlapped call completes (but cannot return)"
	sem := Semaphore new.
	proc interruptWith: 
			[done := 0.
			sem wait.
			done := 2].
	kernel32 setEvent: evt.
	Processor yield.
	self assert: done equals: 0.
	self assert: wait equals: 2.
	"Allow interrupt to complete - and the overlapped method to return"
	sem signal.
	self assert: done equals: 2.
	5 milliseconds wait.
	self assert: wait equals: 3]
			ensure: 
				[continue := false.
				kernel32
					setEvent: evt;
					closeHandle: evt]!

testLoopsInterruptible
	"#2167: Need to test all the optimisable loop types:
		#timesRepeat:
		#whileTrue[:]
		#whileFalse[:]
		#to:[by:]do:
		#repeat		(hmmm, tricky, need some way to break the loop)
	The loops must not contain any true mesage sends, only bytecodes"

	"Timing sensitive, so too unreliable for CI build"
	self skipIfCiBuild.

	"#timesRepeat:"
	self assertLoopInterruptible: [3000000 timesRepeat: [1 + 2]].
	"#whileFalse"
	self assertLoopInterruptible: 
			[| i |
			i := 0.
			
			[i := i + 1.
			i > 4000000] whileFalse].
	"#whileTrue"
	self assertLoopInterruptible: 
			[| i |
			i := 0.
			
			[i := i + 1.
			i <= 4000000] whileTrue].
	"#whileFalse:"
	self assertLoopInterruptible: 
			[| i |
			i := 0.
			[i >= 4000000] whileFalse: [i := i + 1]].
	"#whileTrue:"
	self assertLoopInterruptible: 
			[| i |
			i := 0.
			[i < 4000000] whileTrue: [i := i + 1]].
	"#to:do:"
	self assertLoopInterruptible: [1 to: 4000000 do: [:i | i + 1]].
	"#to:by:do:"
	self assertLoopInterruptible: 
			[1 to: 5000000
				by: 2
				do: [:i | i + 1]].
	self assertLoopInterruptible: 
			[3000000 to: 1
				by: -1
				do: [:i | i + 1]]!

testMakeLargeUnsigned
	| bytes |
	bytes := ByteArray new: 8.
	self assert: (VMLibrary default makeLargeUnsigned: bytes) identicalTo: 0.
	bytes := ByteArray new: 8.
	bytes qwordAtOffset: 0 put: 1.
	self assert: (VMLibrary default makeLargeUnsigned: bytes) identicalTo: 1.
	bytes := ByteArray new: 8.
	bytes qwordAtOffset: 0 put: SmallInteger maximum.
	self assert: (VMLibrary default makeLargeUnsigned: bytes) identicalTo: SmallInteger maximum.
	bytes := ByteArray new: 8.
	bytes qwordAtOffset: 0 put: SmallInteger minimum.
	self assert: (VMLibrary default makeLargeUnsigned: bytes)
		equals: (2 raisedToInteger: 64) + SmallInteger minimum.
	bytes := ByteArray new: 8.
	bytes qwordAtOffset: 0 put: (2 raisedToInteger: 31).
	self assert: (VMLibrary default makeLargeUnsigned: bytes) equals: (2 raisedToInteger: 31).
	self assert: (VMLibrary default makeLargeUnsigned: Float fmax)
		equals: (#[255 255 255 255 255 255 239 127] qwordAtOffset: 0).
	self assert: (VMLibrary default makeLargeUnsigned: Float fminNormalized)
		equals: (Float fminNormalized shallowCopy becomeA: LargeInteger).
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
	self assert: (pseudoTrue ifTrue: [1] ifFalse: [2]) equals: 1.
	self assert: (pseudoFalse ifTrue: [1] ifFalse: [2]) equals: 2.
	"Near jump if false"
	self assert: (pseudoTrue ifTrue: [1 + 2 + 3 + 4] ifFalse: [2]) equals: 1 + 2 + 3 + 4.
	self assert: (pseudoFalse ifTrue: [1 + 2 + 3 + 4] ifFalse: [2]) equals: 2!

testPrimitiveAdd
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #+.
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts small integer, large integer and Float arguments, and fails for everything else"
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	self assert: (method value: 1 withArguments: {1 / 2}) equals: 'InvalidParameter1'.
	self verifyBinaryPrimitive: method
		forCases: #(#(16r3FFFFFFF 0 16r3FFFFFFF) #(16r3FFFFFFF -1 16r3FFFFFFE) #(16r3FFFFFFF 1 16r40000000) #(16r3FFFFFFF 16r40000000 16r7FFFFFFF) #(16r3FFFFFFF 16r7FFFFFFF 16rBFFFFFFE) #(0 16r3FFFFFFF 16r3FFFFFFF) #(-1 16r3FFFFFFF 16r3FFFFFFE) #(1 16r3FFFFFFF 16r40000000) #(1 16r7FFFFFFF 16r80000000) #(16r3FFFFFFF 16r3FFFFFFF 16r7FFFFFFE) #(-16r40000000 1 -16r3FFFFFFF) #(1 -16r40000000 -16r3FFFFFFF) #(-16r40000000 -1 -16r40000001) #(-1 -16r40000000 -16r40000001) #(-16r40000000 -16r40000000 -16r80000000) #(-1 16r40000000 16r3FFFFFFF) #(0 0.0 0.0) #(0 1.0675 1.0675) #(-1 1.0 0.0) #(16r3FFFFFFF 1.125 1073741824.125) #(-16r40000000 -1073741824.675 -2147483648.675))
				, {{-16r40000000. Float fmax. Float fmax}.
						{-16r40000000. Float fmax negated. Float fmax negated}.
						{16r3FFFFFFF. Float fmax. Float fmax}.
						{0. Float fmin. Float fmin}.
						{0. Float fmin negated. Float fmin negated}}!

testPrimitiveAllInstances
	| actual |
	"There are few things we can rely on having a fixed number of instances"
	actual := Processor class primAllInstances.
	self assert: actual equals: {Processor}!

testPrimitiveAllMask
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #allMask:.
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts small and large integer arguments, and fails for everything else"
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	{{1. -2. false}.
		{16r3FFFFFFF. 0. true}.
		{16r3FFFFFFF. -1. false}.
		{16r3FFFFFFF. 1. true}.
		{16r3FFFFFFF. 16r40000000. false}.
		{16r3FFFFFFF. 16r7FFFFFFF. false}.
		{0. 16r3FFFFFFF. false}.
		{1. 16r7FFFFFFF. false}.
		{1. 16r80000000. false}.
		{1. 16r7FFFFFFF00000000. false}.
		{-1. 16r3FFFFFFF. true}.
		{-1. 16r40000000. true}.
		{-1. 16r7FFFFFFF. true}.
		{-1. 16r80000000. true}.
		{-1. 16r7FFFFFFF00000000. true}.
		{16r3FFFFFFF. 16r3FFFFFFF. true}.
		{-16r40000000. 1. false}.
		{-16r40000000. -1. false}.
		{1. -16r40000000. false}.
		{-1. -16r40000000. true}.
		{-1. 16r40000000. true}.
		{-2. -16r100000002. true}.
		{-2. -16r100000001. false}.
		{-16r40000000. 16r40000000. true}}
			do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each last]
	"Anything allMask: 0 is always true"!

testPrimitiveAnyMask
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #anyMask:.
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts small and large integer arguments, and fails for everything else"
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	{{1. -2. false}.
		{16r3FFFFFFF. 0. false}.
		{16r3FFFFFFF. -1. true}.
		{16r3FFFFFFF. 1. true}.
		{16r3FFFFFFF. 16r40000000. false}.
		{16r3FFFFFFF. 16r40000001. true}.
		{16r3FFFFFFF. 16r7FFFFFFF. true}.
		{0. 16r3FFFFFFF. false}.
		{-1. 16r3FFFFFFF. true}.
		{-1. 0. false}.
		{16r3FFFFFFF. 16r3FFFFFFF. true}.
		{-16r40000000. 1. false}.
		{-16r40000000. -1. true}.
		{1. 16r40000000. false}.
		{1. 16r40000001. true}.
		{1. 16r7FFFFFFE. false}.
		{1. 16r7FFFFFFF. true}.
		{-1. -16r40000000. true}.
		{-1. 16r40000000. true}.
		{-1. 16r7FFFFFFFF. true}.
		{-1. 16r100000000. true}.
		{-1. 16r8000000000000000. true}.
		{-1. 16r10000000000000000. true}.
		{-2. -16r100000002. true}.
		{-2. -16r100000001. true}.
		{-16r40000000. 16r40000000. true}}
			do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each last]!

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

testPrimitiveBitShift
	| method cases overflowCases |
	method := self createPrimitiveMethodLike: SmallInteger >> #bitShift:.
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts SmallInteger arguments, and fails for everything else"
	{'s'. 1 / 2. 1.0. SmallInteger maximum + 1. SmallInteger minimum - 1}
		do: [:each | self assert: (method value: 1 withArguments: {each}) equals: 'InvalidParameter1'].
	"At present this primitive does not handle LargeInteger args, unlike some other integer arithmetic primitives"
	cases := SmallIntegerTest bitShiftTestCases.
	overflowCases := cases select: [:each | each last class == LargeInteger].
	self verifyBinaryPrimitive: method forCases: (cases difference: overflowCases).
	overflowCases
		do: [:each | self assert: (method value: each first withArguments: {each second}) equals: 'IntegerOverflow']!

testPrimitiveBytesEqual
	| method string1 string2 string3 string4 bytes1 bytes2 string5 string6 string7 |
	method := self
				createPrimitiveMethod: (ByteArray >> #=) primitiveIndex
				in: Object
				argCount: 1.
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
		{string1. string1 asSymbol. 'InvalidParameter1'}.
		{string1 asSymbol. string1. 'InvalidParameter1'}} do: 
				[:each |
				| actual |
				actual := method value: each first withArguments: {each second}.
				self assert: actual equals: each last]!

testPrimitiveBytesIsNull
	| method subject |
	method := self createPrimitiveMethodLike: ExternalIntegerBytes >> #isNull.
	subject := DWORDBytes new.
	self assert: (method value: subject withArguments: #()).
	subject isImmutable: true.
	self assert: (method value: subject withArguments: #()).
	subject := DWORDBytes fromInteger: 1.
	self deny: (method value: subject withArguments: #()).
	subject := UIntPtrBytes newFixed: 8.
	self assert: (method value: subject withArguments: #()) equals: 'ObjectTypeMismatch'.
	{ExternalAddress. ExternalHandle} do: 
			[:each |
			self assert: (each fromInteger: 1) isNull not.
			self assert: (each fromInteger: -1) isNull not.
			self assert: each new isNull].


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

testPrimitiveChangeBehavior
	"Test the becomeA:/becomeAn: primitive. We have to be careful not to pass literals as we don't want to mutate the test method."

	| method obj |
	method := self createPrimitiveMethodLike: Object >> #becomeA:.
	obj := Array new.
	"Valid cases, although the resulting object is only guaranteed to be valid at the basic level understood by the VM"
	{{Object new. Array. #()}.
		{obj. Object. obj}.
		{'a' -> 'b'. Array. #('a' 'b')}.
		{{'a'. 'b'}. Association. 'a' -> 'b'}.
		{10 @ 20 -> (100 @ 200). Rectangle. 10 @ 20 corner: 100 @ 200}.
		{ExternalHandle fromInteger: 1234. DWORDBytes. DWORDBytes fromInteger: 1234}.
		{Object guid. CLSID. CLSID fromString: '{87b4c451-026e-11d3-9fd7-00a0cc3e4a32}'}.
		{{1. 0}. OrderedCollection. OrderedCollection new}.
		{{1. 2. 'a'. 'b'}. OrderedCollection. OrderedCollection with: 'a' with: 'b'}.
		{OrderedCollection with: 'a' with: 'b'. Array. #(1 2 'a' 'b')}.
		{OrderedCollection new. Set. Set with: 0}.
		{123. SmallInteger. 123}.
		{16r3FFFFFFF. ByteArray. #[255 255 255 63]}.
		{Utf8String with: $a. Utf8String. 'a'}.
		{ByteArray with: 128. ByteArray. #[128]}.
		{{'a'. 'b'}. Array. #('a' 'b')}} do: 
				[:each |
				| subject result operand expected |
				subject := each first.
				operand := each second.
				expected := each third.
				result := method value: subject withArguments: {operand}.
				self assert: result class identicalTo: operand.
				self assert: result equals: expected].
	"Invalid cases"
	"Note that byte objects with different element sizes/encodings (e.g. different String encodings) are not considered type compatible. This could be refined in future, but staying with it for now."
	{{Object new. Association}.
		{1 -> 2. Object}.
		{{1. 2. 3}. Association}.
		{{}. Association}.
		{{1}. Association}.
		{ByteArray new. Array}.
		{{}. ByteArray}.
		{ExternalAddress new. ByteArray}.
		{{1}. OrderedCollection}.
		{AnsiString with: $a. Utf8String}} do: 
				[:each |
				| subject operand result |
				subject := each first.
				operand := each second.
				result := method value: subject withArguments: {operand}.
				self assert: result equals: 'ObjectTypeMismatch']!

testPrimitiveCopyFromTo
	| method |
	method := self
				createPrimitiveMethod: 50
				in: ArrayedCollection
				argCount: 2.
	"Non-indexable pointer class"
	self assert: (method value: (RunArray withAll: #(1 2)) withArguments: #(1 1)) equals: 'OutOfBounds'.
	"Empty collection, empty interval"
	{#[]. ''. '' asUtf8String. '' asUtf16String. #()} do: 
			[:each |
			#(#(0 -1) #(1 1) #(0 0) #(2 2))
				do: [:indices | self assert: (method value: each withArguments: indices) equals: 'OutOfBounds'].
			#(#(1 0) #(2 1)) do: 
					[:indices |
					| actual |
					actual := method value: each withArguments: indices.
					self assert: actual isEmpty.
					self assert: actual class identicalTo: each class]].
	{#[97]. 'a'. 'a' asUtf8String. 'a' asUtf16String. #($a)} do: 
			[:each |
			| actual |
			actual := method value: each withArguments: #(1 1).
			self assert: actual size equals: 1.
			self assert: actual class identicalTo: each class.
			self assert: actual first identicalTo: each first].
	{#[97 98]. 'ab'. '£' asUtf8String. $\x1F42C asUtf16String. #($a $b)} do: 
			[:each |
			| actual |
			actual := method value: each withArguments: #(1 1).
			self assert: actual size equals: 1.
			self assert: actual class identicalTo: each class.
			self assert: (actual at: 1) equals: (each at: 1).
			actual := method value: each withArguments: #(2 2).
			self assert: actual size equals: 1.
			self assert: actual class identicalTo: each class.
			self assert: (actual at: 1) equals: (each at: each size).
			actual := method value: each withArguments: #(1 2).
			self assert: actual size equals: 2.
			self assert: actual class identicalTo: each class.
			self assert: actual equals: each].
	{#[97 98 99 100].
		'abcd'.
		'a£2' asUtf8String.
		'a🐬2' asUtf16String.
		#($a $b $c $d).
		MourningWeakArray withAll: #($a $b $c $d)} do: 
				[:each |
				| actual expectedClass |
				expectedClass := each isString
							ifTrue: [each class]
							ifFalse: [each class isBytes ifTrue: [ByteArray] ifFalse: [Array]].
				self assert: (method value: each withArguments: #(4 5)) equals: 'OutOfBounds'.
				self assert: (method value: each withArguments: #(3 1)) equals: 'OutOfBounds'.
				actual := method value: each withArguments: #(1 2).
				self assert: actual size equals: 2.
				self assert: actual class identicalTo: expectedClass.
				self assert: actual first equals: each first.
				self assert: (actual at: actual size) equals: (each at: 2).
				actual := method value: each withArguments: #(2 3).
				self assert: actual size equals: 2.
				self assert: actual class identicalTo: expectedClass.
				self assert: (actual at: 1) equals: (each at: 2).
				self assert: (actual at: actual size) equals: (each at: 3).
				actual := method value: each withArguments: #(3 4).
				self assert: actual size equals: 2.
				self assert: actual class identicalTo: expectedClass.
				self assert: (actual at: 1) equals: (each at: 3).
				self assert: (actual at: actual size) equals: (each at: each size).
				actual := method value: each withArguments: #(1 4).
				self assert: actual size equals: 4.
				self assert: actual class identicalTo: expectedClass.
				self assert: actual equals: each]!

testPrimitiveDiv
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #//.
	{SmallInteger minimum. -3. -1. 0. 1. 3. SmallInteger maximum}
		do: [:each | self should: [method value: each withArguments: #(0)] raise: ZeroDivide].
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts SmallInteger, and LargeInteger arguments, and fails for everything else"
	{'s'. 1 / 2. 1.23}
		do: [:each | self assert: (method value: 1 withArguments: {each}) equals: 'InvalidParameter1'].
	"At present this primitive does not handle LargeInteger args, unlike some other integer arithmetic primitives"
	self verifyBinaryPrimitive: method
		forCases: (SmallIntegerTest integerDivideTestCases reject: [:each | each second isKindOf: Float])!

testPrimitiveDivide
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #/.
	{SmallInteger minimum. -3. -1. 0. 1. 3. SmallInteger maximum}
		do: [:each | self should: [method value: each withArguments: #(0)] raise: ZeroDivide].
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts small integer, large integer and Float arguments, and fails for everything else"
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	self assert: (method value: 1 withArguments: {1 / 2}) equals: 'InvalidParameter1'.
	"SmallInteger arguments"
	self verifyBinaryPrimitive: method
		forCases: #(#(0 1 0) #(1 1 1) #(2 1 2) #(2 2 1) #(6 2 3) #(0 16r3FFFFFFF 0) #(0 -1 0) #(0 -16r40000000 0) #(16r3FFFFFFF 1 16r3FFFFFFF) #(16r3FFFFFFF 16r3FFFFFFF 1) #(16r3FFFFFFE 2 16r1FFFFFFF)).
	"A boundary case - SmallInteger minimum / -1 is a large integer result"
	self assert: (method value: SmallInteger minimum withArguments: #(-1)) equals: 16r40000000.
	"LargeInteger arguments - zero numerator is a special case, as is min small integer divided by its absolute value"
	self verifyBinaryPrimitive: method
		forCases: #(#(0 1 0) #(0 16r3FFFFFFF 0) #(0 -1 0) #(0 -16r40000000 0) #(16r3FFFFFFF 1 16r3FFFFFFF) #(16r3FFFFFFF -1 -16r3FFFFFFF) #(16r3FFFFFFF 16r3FFFFFFF 1) #(16r3FFFFFFE 2 16r1FFFFFFF) #(16r3FFFFFFF 16r40000000 'Unsuccessful') #(16r3FFFFFFF 1.0 1.073741823e9) #(-16r40000000 1 -16r40000000) #(-16r40000000 -1 16r40000000)).
	self assert: (method value: SmallInteger minimum withArguments: {SmallInteger minimum abs})
		equals: -1.

	"Float arguments"
	self verifyBinaryPrimitive: method
		forCases: {{1. 1.0. 1.0}.
				{1. 2.0. 0.5}.
				{2. 1.0. 2.0}.
				{2. 0.5. 4.0}.
				{16r3FFFFFFF. 1.0. 1.073741823e9}.
				{16r3FFFFFFF. 0.5. 2.147483646e9}.
				{16r3FFFFFFF. Float fmax. 5.972887152857917e-300}.
				{16r3FFFFFFF. Float fmax negated. -5.972887152857917e-300}.
				{0. Float fmax. 0.0}.
				{0. Float fmax negated. 0.0}.
				{0. Float fmin. 0.0}.
				{0. Float fmin negated. 0.0}}!

testPrimitiveEnableInterrupts
	| enabled method |
	method := self createPrimitiveMethodLike: ProcessorScheduler >> #enableAsyncEvents:.
	self assert: (method value: Processor withArguments: #(1)) equals: 'InvalidParameter1'.
	self assert: (method value: Processor withArguments: #('abc')) equals: 'InvalidParameter1'.
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

testPrimitiveEqual
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #=.
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	{#(0 0 true).
		#(0 1 false).
		#(1 0 false).
		#(1 1 true).
		#(-1 0 false).
		#(-1 1 false).
		#(-1 -1 true).
		#(-1 -2 false).
		{SmallInteger minimum. SmallInteger minimum + 1. false}.
		{SmallInteger minimum. SmallInteger minimum - 1. false}.
		{SmallInteger minimum. SmallInteger minimum. true}.
		{SmallInteger minimum. SmallInteger maximum. false}.
		{SmallInteger maximum. SmallInteger maximum. true}.
		{SmallInteger maximum. SmallInteger maximum + 1. false}.
		{SmallInteger maximum. SmallInteger minimum. false}.
		{SmallInteger maximum. 16r7FFFFFFF. false}.
		{1. 16r80000000. false}.
		{1. 16r100000000. false}.
		{1. 16r7FFFFFFF00000000. false}.
		{1. 16r8000000000000000. false}.
		{1. 16r10000000000000000. false}.
		{-1. -16r80000000. false}.
		{-1. -16r80000001. false}.
		{-1. -16r100000000. false}.
		{-1. -16r8000000000000000. false}.
		{-1. -16r8000000000000001. false}.
		{-1. -16r10000000000000000. false}}
			do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each last]!

testPrimitiveExtraInstanceSpec
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #extraInstanceSpec.
	Smalltalk allClasses do: 
			[:each |
			self assert: (method value: each withArguments: #())
				equals: ((each instanceSpec bitShift: -15) bitAnd: 16rFFFF)]!

testPrimitiveFindString
	"Test string search primitive"

	| method foundCases failureCases notFoundCases unlikely comment large expectedForStartingAtOffEnd |
	method := self createPrimitiveMethodLike: String >> #findString:startingAt:.
	failureCases := #(#('abc' 'a' 'b' 'InvalidParameter2') #('abc' 'a' 0 'OutOfBounds') #('abc' 'a' -1 'OutOfBounds') #('abc' #a 1 'InvalidParameter1')).
	foundCases := #(#('abc' 'a' 1 1) #('abc' 'b' 1 2) #('abc' 'c' 1 3) #('abc' 'ab' 1 1) #('abc' 'b' 2 2) #('abc' 'bc' 2 2) #('abc' 'c' 3 3))
				asOrderedCollection.
	unlikely := '!!@#^%'.
	comment := Object comment asAnsiString.
	large := comment , unlikely.
	foundCases addLast: {large. unlikely. 1. comment size + 1}.
	foundCases addLast: {large , comment. unlikely. large size // 2. comment size + 1}.
	foundCases
		addLast: {large , large. unlikely. large size - unlikely size + 2. large size + comment size + 1}.
	notFoundCases := #(#('abc' '' 1 0) #('abc' '' 3 0) #('abc' 'd' 1 0) #('abc' 'ad' 1 0) #('abc' 'abd' 1 0) #('abc' 'a' 2 0) #('abc' 'ab' 2 0) #('abc' 'a' 3 0) #('abc' 'cd' 3 0))
				asOrderedCollection.
	"Older VM failed the primitive if the startingAt argument was too large."
	expectedForStartingAtOffEnd := 0.
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

testPrimitiveGreaterOrEqual
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #>=.
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	{#(0 0 true).
		#(0 1 false).
		#(1 0 true).
		#(1 1 true).
		#(-1 0 false).
		#(-1 1 false).
		#(-1 -1 true).
		#(-1 -2 true).
		{SmallInteger minimum. SmallInteger minimum + 1. false}.
		{SmallInteger minimum. SmallInteger minimum. true}.
		{SmallInteger minimum. SmallInteger maximum. false}.
		{SmallInteger maximum. SmallInteger maximum. true}.
		{SmallInteger maximum. SmallInteger maximum - 1. true}.
		{SmallInteger maximum. SmallInteger minimum. true}.
		{0. SmallInteger maximum + 1. false}.
		{SmallInteger maximum. SmallInteger maximum + 1. false}.
		{SmallInteger minimum. SmallInteger maximum + 1. false}.
		{0. SmallInteger minimum - 1. true}.
		{SmallInteger maximum. SmallInteger minimum - 1. true}.
		{SmallInteger minimum. SmallInteger minimum - 1. true}.
		{SmallInteger maximum. 16r7FFFFFFF. false}.
		{SmallInteger maximum. 16r80000000. false}.
		{SmallInteger maximum. 16r100000000. false}.
		{SmallInteger maximum. 16r7FFFFFFF00000000. false}.
		{SmallInteger maximum. 16r8000000000000000. false}.
		{SmallInteger maximum. 16r10000000000000000. false}.
		{SmallInteger minimum. -16r80000000. true}.
		{SmallInteger minimum. -16r80000001. true}.
		{SmallInteger minimum. -16r100000000. true}.
		{SmallInteger minimum. -16r8000000000000000. true}.
		{SmallInteger minimum. -16r8000000000000001. true}.
		{SmallInteger minimum. -16r10000000000000000. true}}
			do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each last]!

testPrimitiveGreaterThan
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #>.
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	{#(0 0 false).
		#(0 1 false).
		#(1 0 true).
		#(1 1 false).
		#(-1 0 false).
		#(-1 1 false).
		#(-1 -1 false).
		#(-1 -2 true).
		{SmallInteger minimum. SmallInteger minimum + 1. false}.
		{SmallInteger minimum. SmallInteger minimum. false}.
		{SmallInteger minimum. SmallInteger maximum. false}.
		{SmallInteger maximum. SmallInteger maximum. false}.
		{SmallInteger maximum. SmallInteger maximum - 1. true}.
		{SmallInteger maximum. SmallInteger minimum. true}.
		{0. SmallInteger maximum + 1. false}.
		{SmallInteger maximum. SmallInteger maximum + 1. false}.
		{SmallInteger minimum. SmallInteger maximum + 1. false}.
		{0. SmallInteger minimum - 1. true}.
		{SmallInteger maximum. SmallInteger minimum - 1. true}.
		{SmallInteger minimum. SmallInteger minimum - 1. true}.
		{SmallInteger maximum. 16r7FFFFFFF. false}.
		{SmallInteger maximum. 16r80000000. false}.
		{SmallInteger maximum. 16r100000000. false}.
		{SmallInteger maximum. 16r7FFFFFFF00000000. false}.
		{SmallInteger maximum. 16r8000000000000000. false}.
		{SmallInteger maximum. 16r10000000000000000. false}.
		{SmallInteger minimum. -16r80000000. true}.
		{SmallInteger minimum. -16r80000001. true}.
		{SmallInteger minimum. -16r100000000. true}.
		{SmallInteger minimum. -16r8000000000000000. true}.
		{SmallInteger minimum. -16r8000000000000001. true}.
		{SmallInteger minimum. -16r10000000000000000. true}}
			do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each last]!

testPrimitiveHashBytes
	| method |
	method := self
				createPrimitiveMethod: (String >> #hash) primitiveIndex
				in: Object
				argCount: 0.
	{'abcdefghijklmnopqrstuvwxyz'. String new: 8 withAll: $\x7F. #[255 255 255 255 255 255 239 127]}
		do: 
			[:each |
			1 to: each size
				do: 
					[:i |
					| slice |
					slice := each copyFrom: 1 to: i.
					self assert: (method value: slice withArguments: #()) equals: (self hashBytes: slice)]].
	"Test string encodings"
	#('a£') do: 
			[:each |
			self assert: (method value: each asAnsiString withArguments: #())
				equals: (method value: each asUtf8String withArguments: #())].
	#('🐬' '你好') do: [:each | self assert: each asUtf16String hash equals: each asUtf8String hash]!

testPrimitiveHighBit
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #highBit.
	{0. 0. 1. 1. 2. 2. SmallInteger maximum. VMConstants.IntPtrBits - 2. -1. 'IntegerOutOfRange'. SmallInteger minimum. 'IntegerOutOfRange'}
		pairsDo: [:each :expected | self assert: (method value: each withArguments: #()) equals: expected]!

testPrimitiveIdentical
	| method |
	method := self createPrimitiveMethodLike: Object >> #==.
	#(#(1 1 true) #(1 2 false) #(2 1 false) #(#x #x true) #(#x #y false) #(1 #x false) #(#x 1 false))
		do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each third]!

testPrimitiveIndexOfSp
	| method proc offset size sp |
	method := self createPrimitiveMethodLike: Process >> #indexOfSP:.
	proc := Processor activeProcess.
	self assert: (method value: proc withArguments: {SmallInteger maximum + 1})
		equals: 'InvalidParameter1'.
	offset := Process instSize * VMConstants.IntPtrSize.
	self assert: (method value: proc withArguments: {((proc yourAddress + offset) // 2) asStackPointer})
		equals: 1.
	size := proc size.
	self assert: (method value: proc
				withArguments: {((proc yourAddress + ((size - 1) * VMConstants.IntPtrSize) + offset) // 2)
							asStackPointer})
		equals: size.
	"Try round-tripping with spOfIndex:"
	{1. 2. 3. size//2. size} do: 
			[:i |
			sp := proc spOfIndex: i.
			self assert: (method value: proc withArguments: {sp}) equals: i].
	"Invalid SP that is not within the proc"
	{3. proc spOfIndex: (size + 1 roundUpTo: 1024)}
		do: [:each | self assert: (method value: proc withArguments: {each}) equals: 'InvalidParameter1']!

testPrimitiveInstanceCounts
	"Test primitive that returns instance count stats, but not requesting any specific classes."

	| stats counts |
	stats := MemoryManager current primInstanceStats: nil.
	"Kick a couple of tyres"
	self assert: stats size \\ 3 identicalTo: 0.
	counts := IdentityDictionary new.
	1 to: stats size
		by: 3
		do: [:i | counts at: (stats at: i) put: (stats at: i + 1)].
	self assert: (counts at: Symbol) > 25000.
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
				raise: HRESULTError
				matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.ObjectTypeMismatch)]].
	"Test requesting stats for a specific class"
	stats := MemoryManager current primInstanceStats: {Metaclass}.
	self assert: stats first equals: Metaclass.
	self assert: stats second >= Smalltalk allClasses size!

testPrimitiveInstanceCounts2
	"Test primitive that returns instance count stats for a list of requested classes."

	| stats baseClasses counts |
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
	counts
		keysAndValuesDo: [:eachClass :eachCount | eachClass isNonInstantiable ifTrue: [self assert: eachCount equals: 0]].
	self assert: (counts at: Symbol) equals: Symbol primAllInstances size.
	self assert: (counts at: AnsiString) > 30000.
	self assert: (counts at: Object) < 100.
	self assert: (counts at: VMLibrary) equals: 1.
	self assert: (counts at: Processor class) equals: 1.
	(baseClasses select: [:each | each isAbstract])
		do: [:each | self assert: (counts at: each) equals: 0]!

testPrimitiveInstVarAt
	| mutableOc method immutableBytes mutableBytes immutableOc |
	method := self createPrimitiveMethodLike: Object >> #instVarAt:.
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
			self assert: (method value: mutableOc withArguments: {each}) equals: 'OutOfBounds'.
			self assert: (method value: immutableOc withArguments: {each}) equals: 'OutOfBounds'.
			self assert: (method value: mutableBytes withArguments: {each}) equals: 'OutOfBounds'.
			self assert: (method value: immutableBytes withArguments: {each}) equals: 'OutOfBounds'].
	"Invalid index"
	{SmallInteger minimum - 1. SmallInteger maximum + 1. nil} do: 
			[:each |
			self assert: (method value: mutableOc withArguments: {each}) equals: 'InvalidParameter1'.
			self assert: (method value: immutableOc withArguments: {each}) equals: 'InvalidParameter1'.
			self assert: (method value: mutableBytes withArguments: {each}) equals: 'InvalidParameter1'.
			self assert: (method value: immutableBytes withArguments: {each}) equals: 'InvalidParameter1']!

testPrimitiveInstVarAtPut
	| mutableOc method immutableBytes mutableBytes immutableOc immutableStrings mutableStrings |
	method := self createPrimitiveMethodLike: Object >> #instVarAt:put:.
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
	self assert: (method value: immutableOc withArguments: #(1 1)) equals: 'AccessViolation'.
	immutableBytes := #[10 20 30 40].
	mutableStrings := {String new: 4. Utf8String new: 4. Utf16String new: 4}.
	immutableStrings := {AnsiString. Utf8String. Utf16String} collect: 
					[:each |
					(each fromString: 'abcd')
						isImmutable: true;
						yourself].
	self assert: immutableBytes isImmutable.
	mutableBytes := immutableBytes copy.
	self deny: mutableBytes isImmutable.
	1 to: immutableBytes size
		do: 
			[:i |
			self assert: (method value: immutableBytes withArguments: {i. i * 10}) equals: 'AccessViolation'.
			immutableStrings
				do: [:s | self assert: (method value: s withArguments: {i. 96 + i}) equals: 'AccessViolation'].
			mutableStrings do: [:s | self assert: (method value: s withArguments: {i. 96 + i}) equals: 96 + i].
			self assert: (method value: mutableBytes withArguments: {i. i * 10}) equals: i * 10.
			self assert: (mutableBytes basicAt: i) equals: i * 10].
	mutableStrings with: immutableStrings do: [:a :b | self assert: a equals: b].
	"Out of bounds"
	{-1. 0. 5. SmallInteger minimum. SmallInteger maximum} do: 
			[:each |
			| expectedImmutable |
			self assert: (method value: mutableOc withArguments: {each. each}) equals: 'OutOfBounds'.
			expectedImmutable := each <= 0 ifTrue: ['OutOfBounds'] ifFalse: ['AccessViolation'].
			self assert: (method value: immutableOc withArguments: {each. each}) equals: expectedImmutable.
			mutableStrings
				do: [:s | self assert: (method value: s withArguments: {each. $a codePoint}) equals: 'OutOfBounds'].
			immutableStrings
				do: [:s | self assert: (method value: s withArguments: {each. $a codePoint}) equals: expectedImmutable].
			self assert: (method value: mutableBytes withArguments: {each. 255}) equals: 'OutOfBounds'.
			self assert: (method value: immutableBytes withArguments: {each. 255}) equals: expectedImmutable].
	"Invalid index"
	{SmallInteger minimum - 1. SmallInteger maximum + 1. nil} do: 
			[:each |
			self assert: (method value: mutableOc withArguments: {each. each}) equals: 'InvalidParameter1'.
			self assert: (method value: immutableOc withArguments: {each. each}) equals: 'InvalidParameter1'.
			mutableStrings
				do: [:s | self assert: (method value: s withArguments: {each. each}) equals: 'InvalidParameter1'].
			immutableStrings
				do: [:s | self assert: (method value: s withArguments: {each. each}) equals: 'InvalidParameter1'].
			self assert: (method value: mutableBytes withArguments: {each. each}) equals: 'InvalidParameter1'.
			self assert: (method value: immutableBytes withArguments: {each. each}) equals: 'InvalidParameter1'].
	"Invalid byte content"
	#($a -1 256 nil) do: 
			[:each |
			mutableStrings
				do: [:s | self assert: (method value: s withArguments: #(1 #each)) equals: 'InvalidParameter2'].
			self assert: (method value: mutableBytes withArguments: #(1 #each)) equals: 'InvalidParameter2']!

testPrimitiveIsKindOf
	"Test the isKindOf primitive (which does not fail)"

	| method proto |
	method := self createPrimitiveMethodLike: Object >> #isKindOf:.
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
	self assert: proto isKindOf: ProtoObject.
	self assert: proto isKindOf: nil.
	self deny: (proto isKindOf: ProtoObject class).
	self deny: (proto isKindOf: 1).
	self deny: (proto isKindOf: Object)!

testPrimitiveLessOrEqual
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #<=.
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	{#(0 0 true).
		#(0 1 true).
		#(1 0 false).
		#(1 1 true).
		#(-1 0 true).
		#(-1 1 true).
		#(-1 -1 true).
		#(-1 -2 false).
		{SmallInteger minimum. SmallInteger minimum + 1. true}.
		{SmallInteger minimum. SmallInteger minimum. true}.
		{SmallInteger minimum. SmallInteger maximum. true}.
		{SmallInteger maximum. SmallInteger maximum. true}.
		{SmallInteger maximum. SmallInteger maximum - 1. false}.
		{SmallInteger maximum. SmallInteger minimum. false}.
		{0. SmallInteger maximum + 1. true}.
		{SmallInteger maximum. SmallInteger maximum + 1. true}.
		{SmallInteger minimum. SmallInteger maximum + 1. true}.
		{0. SmallInteger minimum - 1. false}.
		{SmallInteger maximum. SmallInteger minimum - 1. false}.
		{SmallInteger minimum. SmallInteger minimum - 1. false}.
		{SmallInteger maximum. 16r7FFFFFFF. true}.
		{SmallInteger maximum. 16r80000000. true}.
		{SmallInteger maximum. 16r100000000. true}.
		{SmallInteger maximum. 16r7FFFFFFF00000000. true}.
		{SmallInteger maximum. 16r8000000000000000. true}.
		{SmallInteger maximum. 16r10000000000000000. true}.
		{SmallInteger minimum. -16r80000000. false}.
		{SmallInteger minimum. -16r80000001. false}.
		{SmallInteger minimum. -16r100000000. false}.
		{SmallInteger minimum. -16r8000000000000000. false}.
		{SmallInteger minimum. -16r8000000000000001. false}.
		{SmallInteger minimum. -16r10000000000000000. false}}
			do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each last]!

testPrimitiveLessThan
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #<.
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	{#(0 0 false).
		#(0 1 true).
		#(1 0 false).
		#(1 1 false).
		#(-1 0 true).
		#(-1 1 true).
		#(-1 -1 false).
		#(-1 -2 false).
		{SmallInteger minimum. SmallInteger minimum + 1. true}.
		{SmallInteger minimum. SmallInteger minimum. false}.
		{SmallInteger minimum. SmallInteger maximum. true}.
		{SmallInteger maximum. SmallInteger maximum. false}.
		{SmallInteger maximum. SmallInteger maximum - 1. false}.
		{SmallInteger maximum. SmallInteger minimum. false}.
		{0. SmallInteger maximum + 1. true}.
		{SmallInteger maximum. SmallInteger maximum + 1. true}.
		{SmallInteger minimum. SmallInteger maximum + 1. true}.
		{0. SmallInteger minimum - 1. false}.
		{SmallInteger maximum. SmallInteger minimum - 1. false}.
		{SmallInteger minimum. SmallInteger minimum - 1. false}.
		{SmallInteger maximum. 16r7FFFFFFF. true}.
		{SmallInteger maximum. 16r80000000. true}.
		{SmallInteger maximum. 16r100000000. true}.
		{SmallInteger maximum. 16r7FFFFFFF00000000. true}.
		{SmallInteger maximum. 16r8000000000000000. true}.
		{SmallInteger maximum. 16r10000000000000000. true}.
		{SmallInteger minimum. -16r80000000. false}.
		{SmallInteger minimum. -16r80000001. false}.
		{SmallInteger minimum. -16r100000000. false}.
		{SmallInteger minimum. -16r8000000000000000. false}.
		{SmallInteger minimum. -16r8000000000000001. false}.
		{SmallInteger minimum. -16r10000000000000000. false}}
			do: [:each | self assert: (method value: each first withArguments: {each second}) equals: each last]!

testPrimitiveLookupMethod
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #lookupMethod:.
	self assert: (method value: Object withArguments: #(1)) equals: 'InvalidParameter1'.
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
	self assertIsNil: (method value: ProtoObject withArguments: #(#class))!

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
						argCount: i.
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
						argCount: i.
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
						argCount: i.
			expected := (Array new: (i max: Context instSize))
						replaceFrom: 1
							to: i
							with: (1 to: i) asArray
							startingAt: 1;
						yourself.
			result := method value: Context withArguments: (1 to: i) asArray.
			1 to: expected size do: [:j | self assert: (result instVarAt: j) equals: (expected at: j)]]!

testPrimitiveMod
	| method cases |
	method := self createPrimitiveMethodLike: SmallInteger >> #\\.
	{SmallInteger minimum. -3. -1. 0. 1. 3. SmallInteger maximum}
		do: [:each | self should: [method value: each withArguments: #(0)] raise: ZeroDivide].
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts SmallInteger arguments, and fails for everything else"
	{'s'. 1 / 2. SmallInteger maximum + 1. 1.0}
		do: [:each | self assert: (method value: 1 withArguments: {each}) equals: 'InvalidParameter1'].

	"SmallInteger arguments - overflow into a LargeInteger result is not possible"
	cases := SmallIntegerTest moduloTestCases.
	self verifyBinaryPrimitive: method
		forCases: (cases select: [:each | each second class == SmallInteger]).
	(cases reject: [:each | each second class == SmallInteger])
		do: [:each | self assert: (method value: each first withArguments: {each second}) equals: 'InvalidParameter1']!

testPrimitiveMultiply
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #*.
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts small integer, large integer and Float arguments, and fails for everything else"
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	self assert: (method value: 1 withArguments: {1 / 2}) equals: 'InvalidParameter1'.
	self verifyBinaryPrimitive: method
		forCases: #(#(16r3FFFFFFF 0 0) #(16r3FFFFFFF -1 -16r3FFFFFFF) #(16r3FFFFFFF 1 16r3FFFFFFF) #(-16r40000000 -1 16r40000000) #(16r3FFFFFFF 16r3FFFFFFF 16rFFFFFFF80000001) #(16r3FFFFFFF 16r40000000 16rFFFFFFFC0000000) #(16r3FFFFFFF 16r7FFFFFFF 16r1FFFFFFF40000001) #(0 16r3FFFFFFF 0) #(-1 16r3FFFFFFF -16r3FFFFFFF) #(-1 16r40000000 -16r40000000) #(1 16r3FFFFFFF 16r3FFFFFFF) #(1 16r7FFFFFFF 16r7FFFFFFF) #(16r3FFFFFFF 16r7FFFFFFF 16r1FFFFFFF40000001) #(16r3FFFFFFF 16r7FFFFFFFFFFFFFFF 16r1FFFFFFF7FFFFFFFC0000001) #(-16r40000000 1 -16r40000000) #(-16r40000000 -16r40000000 16r1000000000000000) #(0 0.0 0.0) #(0 1.0675 0.0) #(-1 1.0 -1.0) #(16r3FFFFFFF 1.125 1207959550.875) #(-16r40000000 -2.0 2147483648.0))
				, {{-16r40000000. Float fmax. Float negativeInfinity}.
						{-16r40000000. Float fmax negated. Float infinity}.
						{16r3FFFFFFF. Float fmax. Float infinity}.
						{1. Float fmin. Float fmin}.
						{-1. Float fmin. Float fmin negated}}!

testPrimitiveNewColonFailure
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #new:.
	self assert: (method value: Array withArguments: #('abc')) equals: 'InvalidParameter1'.
	self assert: (method value: Array withArguments: #(-1)) equals: 'InvalidParameter1'.
	"CompiledCode is abstract"
	self assert: (method value: CompiledCode withArguments: #(0)) equals: 'NonInstantiable'.
	self assert: (method value: Association withArguments: #(0)) equals: nil -> nil.
	self assert: (method value: Association withArguments: #(1)) equals: 'ObjectTypeMismatch'!

testPrimitiveNewFailure
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #new.
	self assert: (method value: Array withArguments: #()) equals: 'ObjectTypeMismatch'.
	self assert: (method value: Boolean withArguments: #()) equals: 'NonInstantiable'!

testPrimitiveNewFixedFailure
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #newFixed:.
	"Invalid size (must be a positive SmallInteger)"
	self assert: (method value: ByteArray withArguments: #('failed2')) equals: 'InvalidParameter1'.
	self assert: (method value: ByteArray withArguments: #(-1)) equals: 'InvalidParameter1'.
	"Only byte objects can be pinned"
	self assert: (method value: Array withArguments: #(1)) equals: 'ObjectTypeMismatch'.
	"ExternalIntegerBytes is abstract"
	self assert: (method value: ExternalIntegerBytes withArguments: #(1)) equals: 'NonInstantiable'!

testPrimitiveNewInitializedFailure
	| method |
	method := self
				createPrimitiveMethod: (Array class >> #with:with:with:) primitiveIndex
				in: Object
				argCount: 3.
	"Only valid for pointer classes"
	self assert: (method value: Array withArguments: #(1 2 3)) equals: #(1 2 3).
	self assert: (method value: Point withArguments: #(1 2 3)) equals: 'WrongNumberOfArgs'.
	self assert: (method value: MessageSendAbstract withArguments: #(1 2 3)) equals: 'NonInstantiable'.
	self assert: (method value: ByteArray withArguments: #(1 2 3)) equals: 'ObjectTypeMismatch'!

testPrimitiveNewVirtualFailure
	| method |
	method := self createPrimitiveMethodLike: Behavior >> #new:max:.
	"Invalid sizes (must be positive SmallInteger)"
	self assert: (method value: Array withArguments: #('1' 2)) equals: 'InvalidParameter1'.
	"Older VM just threw an out-of-memory for negative sizes as it treated the arg as unsigned"
	self assert: (method value: Array withArguments: #(-1 2)) equals: 'InvalidParameter1'.
	self assert: (method value: Array withArguments: #(1 -2)) equals: 'InvalidParameter2'.
	"CompiledCode is abstract"
	self assert: (method value: CompiledCode withArguments: #(1 2)) equals: 'NonInstantiable'.
	self assert: (method value: Array withArguments: #(1 '2')) equals: 'InvalidParameter2'.
	"Object is not indexable"
	self assert: (method value: Object withArguments: #(1 2)) equals: 'ObjectTypeMismatch'!

testPrimitiveNextPut
	| method subject pound euro |
	method := self createPrimitiveMethodLike: WriteStream >> #nextPut:.
	subject := AnsiString writeStream.
	self assert: subject collection isKindOf: AnsiString.
	"Past limit"
	self assert: (method value: subject withArguments: #($a)) equals: 'OutOfBounds'.
	"Smalltalk backup code will extend the collection"
	subject nextPut: $a.
	self assert: (method value: subject withArguments: #($b)) equals: $b.
	self assert: subject position equals: 2.
	self assert: subject contents equals: 'ab'.
	subject position: 0.0.
	self assert: (method value: subject withArguments: #($a)) equals: 'AssertionFailure'.
	subject := AnsiString writeStream: 2.
	"Not a character"
	self assert: (method value: subject withArguments: #(1)) equals: 'InvalidParameter1'.
	"Earlier VM assumed chars were always for byte code points"
	self assert: (method value: subject withArguments: {Character codePoint: 16r394})
		equals: 'UnmappableCharacter'.
	"Tests of string encodings"
	{AnsiString. Utf8String. Utf16String} do: 
			[:each |
			| stm |
			self assert: (method value: each writeStream withArguments: #($a)) equals: 'OutOfBounds'.
			stm := each writeStream: 1.
			self assert: (method value: stm withArguments: #($a)) equals: $a.
			self assert: stm position equals: 1.
			self assert: (method value: stm withArguments: #($b)) equals: 'OutOfBounds'].
	"Unicode symbol requiring one ansi byte"
	pound := Character value: 163.
	subject := AnsiString writeStream: 1.
	self assert: (method value: subject withArguments: {pound}) equals: pound.
	self assert: subject position equals: 1.
	self assert: (subject contents at: 1) equals: pound.
	"UTF-8, requires 2 bytes"
	0 to: 1
		do: 
			[:i |
			self assert: (method value: (Utf8String writeStream: i) withArguments: {pound})
				equals: 'OutOfBounds'].
	subject := Utf8String writeStream: 2.
	self assert: (method value: subject withArguments: {pound}) equals: pound.
	self assert: subject position equals: 2.
	self assert: subject contents equals: pound asUtf8String.
	"UTF-16 requires 1 code unit"
	0 to: 0
		do: 
			[:i |
			self assert: (method value: (Utf16String writeStream: i) withArguments: {pound})
				equals: 'OutOfBounds'].
	subject := Utf16String writeStream: 1.
	self assert: (method value: subject withArguments: {pound}) equals: pound.
	self assert: subject position equals: 1.
	self assert: subject contents equals: pound asUtf16String.
	"Another unicode symbol requiring one ansi byte"
	euro := $\x20AC.
	subject := AnsiString writeStream: 1.
	self assert: (method value: subject withArguments: {euro}) equals: euro.
	self assert: subject position equals: 1.
	self assert: (subject contents at: 1) equals: euro.
	"UTF-8, requires 3 bytes"
	0 to: 2
		do: 
			[:i |
			self assert: (method value: (Utf8String writeStream: i) withArguments: {euro}) equals: 'OutOfBounds'].
	subject := Utf8String writeStream: 3.
	self assert: (method value: subject withArguments: {euro}) equals: euro.
	self assert: subject position equals: 3.
	self assert: subject contents equals: euro asUtf8String.
	"UTF-16 requires 1 code unit"
	0 to: 0
		do: 
			[:i |
			self assert: (method value: (Utf16String writeStream: i) withArguments: {euro})
				equals: 'OutOfBounds'].
	subject := Utf16String writeStream: 1.
	self assert: (method value: subject withArguments: {euro}) equals: euro.
	self assert: subject position equals: 1.
	self assert: subject contents equals: euro asUtf16String.
	"Unicode symbol outside BMP- Not puttable into an AnsiString, should fail"
	self assert: (method value: (AnsiString writeStream: 1) withArguments: {Character dolphin})
		equals: 'UnmappableCharacter'.
	"UTF-8, requires 4 bytes"
	0 to: 3
		do: 
			[:i |
			self assert: (method value: (Utf8String writeStream: i) withArguments: {Character dolphin})
				equals: 'OutOfBounds'].
	subject := Utf8String writeStream: 4.
	self assert: (method value: subject withArguments: {Character dolphin}) equals: Character dolphin.
	self assert: subject position equals: 4.
	self assert: subject contents equals: Character dolphin asUtf8String.
	"UTF-16 requires 2 code units"
	0 to: 1
		do: 
			[:i |
			self assert: (method value: (Utf16String writeStream: i) withArguments: {Character dolphin})
				equals: 'OutOfBounds'].
	subject := Utf16String writeStream: 2.
	self assert: (method value: subject withArguments: {Character dolphin}) equals: Character dolphin.
	self assert: subject position equals: 2.
	self assert: subject contents equals: Character dolphin asUtf16String!

testPrimitiveNextPutAll
	| method |
	method := self createPrimitiveMethodLike: WriteStream >> #nextPutAll:.
	self verifyPrimitiveNextPutAllOnAnsiString: method.
	self verifyPrimitiveNextPutAllOnUtfStrings: method.
	self verifyPrimitiveNextPutAllOnByteArray: method.
	self verifyPrimitiveNextPutAllOnArray: method!

testPrimitiveObjectCount
	"Test primitive that returns object instance count."

	| method count1 count2 subject |
	method := self createPrimitiveMethodLike: MemoryManager >> #objectCount.
	subject := MemoryManager current.
	count1 := method value: subject withArguments: #().
	count2 := method value: subject withArguments: #().
	self assert: count1 equals: count2.
	self assert: count1 > 0!

testPrimitiveQuo
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #quo:.
	{SmallInteger minimum. -3. -1. 0. 1. 3. SmallInteger maximum}
		do: [:each | self should: [method value: each withArguments: #(0)] raise: ZeroDivide].
	"The primitive assumes that the receiver is a SmallInteger; it does not check.
	It accepts SmallInteger and LargeInteger arguments, and fails for everything else"
	{'s'. 1 / 2. 1.23 }
		do: [:each | self assert: (method value: 1 withArguments: {each}) equals: 'InvalidParameter1'].
	self verifyBinaryPrimitive: method forCases: (SmallIntegerTest quoTestCases reject: [:each | each second isKindOf: Float])!

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

testPrimitiveSetMutableInstVar
	| method assoc |
	method := (Association >> #value:) copy.
	method extraIndex: 49.
	assoc := 1 -> 2.
	self deny: assoc isImmutable.
	method value: assoc withArguments: #(3).
	self assert: assoc value identicalTo: 3.
	assoc isImmutable: true.
	self should: [assoc value: 4] raise: Processor constWriteSignal.
	self assert: assoc value identicalTo: 3.
	method value: assoc withArguments: #(4).
	self assert: assoc value identicalTo: 4!

testPrimitiveSetSpecialBehavior
	| method subject before after nullTermMask |
	method := self createPrimitiveMethodLike: Object >> #setSpecialBehavior:.
	self assert: (method value: 1 withArguments: #(1)) equals: 'ObjectTypeMismatch'.
	subject := Object new.
	self assert: (method value: subject withArguments: #(nil)) equals: 'InvalidParameter1'.
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
	after := before | _FinalizeMask.
	self assert: subject getSpecialBehavior equals: after.
	self deny: subject isWeak.
	self assert: subject isFinalizable.
	"The VM does not allow the null termination bit to be changed"
	self assert: (method value: subject withArguments: {nullTermMask}) equals: after.
	self assert: subject getSpecialBehavior equals: before.
	self deny: subject isWeak.
	self deny: subject isFinalizable.
	self assert: (method value: subject withArguments: #(0)) equals: before.
	self assert: subject getSpecialBehavior equals: before.
	self deny: subject isWeak.
	self deny: subject isFinalizable!

testPrimitiveShallowCopy
	| method subject result |
	"Note that the primitive does not expect to be invoked for an immediate (SmallInteger) receiver."
	method := self createPrimitiveMethodLike: Object >> #shallowCopy.
	#(#(#(1) 'a') #[0 1 2 3] 'abc' #x:y:) do: 
			[:each |
			subject := #(#()).
			result := method value: subject withArguments: #().
			self deny: result identicalTo: subject.
			self assert: result equals: subject.
			result with: subject do: [:a :b | self assert: a identicalTo: b]]!

testPrimitiveSize
	| method subject |
	method := self createPrimitiveMethodLike: Object >> #size.
	self assert: (method value: '' withArguments: #()) equals: 0.
	self assert: (method value: #[1 2] withArguments: #()) equals: 2.
	self assert: (method value: #(#a #b #c) withArguments: #()) equals: 3.
	self assert: (method value: 1 -> 2 withArguments: #()) equals: 0.
	subject := OrderedCollection basicNew: 5.
	self assert: (method value: subject withArguments: #()) equals: 5.
	self assert: (method value: 'abc' withArguments: #()) equals: 3.
	self assert: (method value: 'abc' asUtf8String withArguments: #()) equals: 3.
	self assert: (method value: Character dolphin asUtf8String withArguments: #()) equals: 4.
	self assert: (method value: Character dolphin asUtf16String withArguments: #()) equals: 2!

testPrimitiveSmallIntegerByteAt
	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #byteAt:.
	1 to: 4 do: [:each | self assert: (method value: 0 withArguments: {each}) equals: 0].
	{-255. 255} do: 
			[:subject |
			self assert: (method value: subject withArguments: #(1)) equals: subject abs.
			2 to: 4 do: [:each | self assert: (method value: subject withArguments: {each}) equals: 0].
			{-1. 0. 5. SmallInteger maximum. SmallInteger minimum}
				do: [:each | self assert: (method value: subject withArguments: {each}) equals: 'OutOfBounds']].
	self assert: (method value: 16r3F7FDEAD withArguments: #(1)) equals: 16rAD.
	self assert: (method value: 16r3F7FDEAD withArguments: #(2)) equals: 16rDE.
	self assert: (method value: 16r3F7FDEAD withArguments: #(3)) equals: 16r7F.
	self assert: (method value: 16r3F7FDEAD withArguments: #(4)) equals: 16r3F.
	1 to: 3 do: [:each | self assert: (method value: SmallInteger minimum withArguments: {each}) equals: 0].
	self assert: (method value: SmallInteger minimum withArguments: #(4)) equals: 16r40.
	self assert: (method value: 1 withArguments: #(nil)) equals: 'InvalidParameter1'!

testPrimitiveStringAt
	| method array |
	method := self createPrimitiveMethodLike: String >> #at:.
	array := String with: $1.
	self should: [(method value: array withArguments: {1}) == $1].
	"Some tests are repeated with a new array in case of different behaviour resulting from caching"
	self should: [(method value: array withArguments: {1}) == $1].
	self assert: (method value: array withArguments: {0}) equals: 'OutOfBounds'.
	self assert: (method value: array withArguments: {2}) equals: 'OutOfBounds'.
	array := String with: $1.
	self assert: (method value: array withArguments: {0}) equals: 'OutOfBounds'.
	array := String with: $1.
	self assert: (method value: array withArguments: {2}) equals: 'OutOfBounds'.
	self assert: (method value: array withArguments: {SmallInteger maximum}) equals: 'OutOfBounds'.
	self assert: (method value: array withArguments: {SmallInteger minimum}) equals: 'OutOfBounds'.

	"LargeIntegers"
	self assert: (method value: array withArguments: {SmallInteger maximum + 1})
		equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {(2 raisedToInteger: 31) - 1})
		equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {2 raisedToInteger: 31})
		equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {(2 raisedToInteger: 32) - 1})
		equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {2 raisedToInteger: 32})
		equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {SmallInteger minimum - 1})
		equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {-2 raisedToInteger: 31})
		equals: 'InvalidParameter1'.
	"Two elements"
	array := 'ab' copy.
	self should: [(method value: array withArguments: {1}) == $a].
	self should: [(method value: array withArguments: {1}) == $a].
	self should: [(method value: array withArguments: {2}) == $b].
	self assert: (method value: array withArguments: {0}) equals: 'OutOfBounds'.
	self assert: (method value: array withArguments: {3}) equals: 'OutOfBounds'.

	"Try accessing with non-integer indices"
	self assert: (method value: array withArguments: {$1}) equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {'1'}) equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {nil}) equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {#[1]}) equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {#'1'}) equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {#(1)}) equals: 'InvalidParameter1'.
	self assert: (method value: array withArguments: {#(1)}) equals: 'InvalidParameter1'.
	{AnsiString. Utf8String. Utf16String} do: 
			[:eachClass |
			| subject |
			subject := eachClass withAll: ((0 to: 127) collect: [:i | Character value: i]).
			0 to: subject size - 1
				do: [:i | self assert: (method value: subject withArguments: {i + 1}) identicalTo: (Character value: i)]].
	"Remaining ANSI characters are unique"
	array := AnsiString withAll: ((128 to: 255) collect: [:i | Character ansiValue: i]).
	128 to: 255
		do: [:i | self assert: (method value: array withArguments: {i - 127}) identicalTo: (Character ansiValue: i)].
	"UTF-8 surrogates"
	array := Utf8String withAll: ((128 to: 255) collect: [:i | Character utf8Value: i]).
	128 to: 255
		do: 
			[:i |
			| utf8 |
			utf8 := method value: array withArguments: {i - 127}.
			self assert: utf8 isUtf8Surrogate.
			self deny: utf8 equals: (Character value: i).
			self assert: utf8 equals: (Character utf8Value: i)]!

testPrimitiveStringAtPut
	| subject method cantHold |
	method := self createPrimitiveMethodLike: String >> #at:put:.
	subject := String new: 2.
	"Valid case"
	self assert: (subject at: 1) equals: $\0.
	self assert: (subject at: 2) equals: $\0.
	self assert: (method value: subject withArguments: #(1 $a)) equals: $a.
	self assert: (subject at: 1) equals: $a.
	self assert: (method value: subject withArguments: #(2 $b)) equals: $b.
	self assert: (subject at: 2) equals: $b.
	"Invalid index argument"
	self assert: (method value: subject withArguments: #($a $b)) equals: 'InvalidParameter1'.
	"Bounds errors"
	subject := String new: 2.
	#(0 3 -1 ##(SmallInteger maximum) ##(SmallInteger minimum)) do: 
			[:each |
			self assert: (subject at: 1) equals: $\0.
			self assert: (subject at: 2) equals: $\0.
			self assert: (method value: subject withArguments: {each. $a}) equals: 'OutOfBounds'].
	"Objects that strings can't hold, including some special cases that have no object body (issue #234)"
	cantHold := #(0 ##(Object new) nil '' #'' true false #() #[]) asOrderedCollection.
	cantHold do: 
			[:each |
			self assert: (subject at: 1) equals: $\0.
			self assert: (subject at: 2) equals: $\0.
			self assert: (method value: subject withArguments: {1. each}) equals: 'InvalidParameter2'].
	self assert: (method value: subject withArguments: {1. $\x100}) equals: 'UnmappableCharacter'.
	self assert: subject equals: (String new: 2)!

testPrimitiveStringCmp
	"Test case sensitive string comparison primitive"

	| method |
	method := self createPrimitiveMethodLike: String >> #<==>.
	"Note that we don't test that the primitive fails for a non-String receiver - in general primitives assume they are only used in methods of suitable receiver classes."
	#(#('a' 'b' -1) #('A' 'a' 1) #('abc' 'ABC' -1) #('abc' 'abc' 0) #('' 'a' -1) #('a' 'ab' -1) #('ab' 'a' 1) #('a' 1 'InvalidParameter1'))
		do: 
			[:each |
			| subject result operand expected |
			subject := each first asAnsiString.
			operand := each second.
			expected := each third.
			result := method value: subject withArguments: {operand}.
			self assert: result class identicalTo: expected class.
			self assert: result equals: expected].
	self assert: (method value: 'a' withArguments: {Array new}) equals: 'InvalidParameter1'.
	self assert: (method value: 'a' withArguments: {WeakArray new}) equals: 'InvalidParameter1'!

testPrimitiveStringCollate
	"Test case insensitive string comparison primitive"

	| method |
	method := self createPrimitiveMethodLike: String >> #<=>.
	"Note that we don't test that the primitive fails for a non-String receiver - in general primitives assume they are only used in methods of suitable receiver classes."
	#(#('a' 'b' -1) #('b' 'a' 1) #('abc' 'ABC' 0) #('A' 'a' 0) #('' 'a' -1) #('a' 'ab' -1) #('ab' 'a' 1) #('a' 1 'InvalidParameter1'))
		do: 
			[:each |
			| subject result operand expected |
			subject := each first asAnsiString.
			operand := each second.
			expected := each third.
			result := method value: subject withArguments: {operand}.
			self assert: result class identicalTo: expected class.
			self assert: result equals: expected].
	self assert: (method value: 'a' withArguments: {Array new}) equals: 'InvalidParameter1'.
	"Weak pointer objects use the same OTE flag as zero-terminated byte objects"
	self assert: (method value: 'a' withArguments: {WeakArray new}) equals: 'InvalidParameter1'!

testPrimitiveStringNextIndexOfFromTo
	| method subject foundCases nonIntegerToFrom fromOutOfBounds toOutOfBounds emptyIntervalBounds notFoundCases |
	method := self createPrimitiveMethodLike: String >> #nextIdentityIndexOf:from:to:.
	foundCases := #(#('aabc' $a 1 1 1) #('aabc' $a 1 2 1) #('a' $a 1 1 1) #('aabc' $a 2 3 2) #('abc' $c 1 3 3) #('abac' $a 2 4 3)).
	nonIntegerToFrom := #(#('aabc' $a $b 4 'InvalidParameter2') #('aabc' $a nil 4 'InvalidParameter2') #('aabc' $a 1 nil 'InvalidParameter3')).
	fromOutOfBounds := #(#('aabc' $a 0 4 'OutOfBounds') #('aabc' $a -1 4 'OutOfBounds')).
	emptyIntervalBounds := #(#('aabc' $a 1 -1 0) #('aabc' $a 1 0 0) #('aabc' $a 4 3 0) #('aabc' $a 5 4 0) #('' $a 1 0 0)).
	toOutOfBounds := #(#('aabc' $a 1 5 'OutOfBounds') #('' $a 1 2 'OutOfBounds')).
	notFoundCases := {#('aabc' $d 1 1 0).
				#('aabc' $d 1 2 0).
				#('abc' $d 1 3 0).
				#('abac' nil 1 4 0).
				{'abcd'. Character dolphin. 1. 4. 0}.
				{Character dolphin asUtf8String asByteArray asAnsiString.
					Character dolphin asUtf8String at: 2.
					1.
					4.
					0}.
				{Character dolphin asUtf16String asByteArray asAnsiString.
					Character dolphin asUtf16String at: 2.
					1.
					4.
					0}}
					asOrderedCollection.
	"Fails on earlier VM, as it truncates the codepoint to the first byte, which means $\x161 gets treated as $a"
	notFoundCases add: {'abc'. Character value: 16r161. 1. 3. 0}.
	foundCases , nonIntegerToFrom , fromOutOfBounds , emptyIntervalBounds , toOutOfBounds
		, notFoundCases do: 
				[:each |
				| actual char start stop expected |
				subject := each first.
				char := each second.
				start := each third.
				stop := each fourth.
				expected := each last.
				actual := method value: subject withArguments: {char. start. stop}.
				self assert: actual equals: expected].
	"UTF strings are now supported too"
	{'aa£aa' asAnsiString. 'aa£aa' asUtf8String. 'aa£aa' asUtf16String} do: 
			[:each |
			1 to: each size do: [:i | self assert: (method value: each withArguments: {$a. 1. i}) equals: 1].
			self assert: (method value: each withArguments: #($£ 1 4)) equals: 3.
			{each size + 1. SmallInteger maximum} do: 
					[:i |
					self assert: (method value: each withArguments: {$a. 1. i}) equals: 'OutOfBounds'.
					self assert: (method value: each withArguments: {$a. i. i}) equals: 'OutOfBounds'].
			{-1. 0. SmallInteger minimum} do: 
					[:i |
					self assert: (method value: each withArguments: {$a. 1. i}) equals: 0.
					self assert: (method value: each withArguments: {$a. i. each size}) equals: 'OutOfBounds']].
	subject := '𝕬 🐬 string' asUtf16String.
	1 to: 4
		do: 
			[:i |
			"Search should work, even if we start in the middle of a 32-bit character"
			self assert: (subject
						nextIdentityIndexOf: Character dolphin
						from: i
						to: subject size)
				equals: 4.
			"Search for surrogates - this should work, again regardless of whether we start in the middle of a character"
			self assert: (subject
						nextIdentityIndexOf: Character dolphin asUtf16String first
						from: i
						to: subject size)
				equals: 4].
	1 to: 7
		do: 
			[:i |
			self assert: (subject
						nextIdentityIndexOf: $s
						from: i
						to: subject size)
				equals: 7].
	"Similarly, can search for UTF-16 trail surrogates"
	1 to: 5
		do: 
			[:i |
			self assert: (subject
						nextIdentityIndexOf: (Character dolphin asUtf16String at: 2)
						from: i
						to: subject size)
				equals: 5].
	"Utf16Strings can never contain UTF-8 surrogates"
	subject := Utf16String
				withAll: (Character dolphin asUtf8String asByteArray asArray collect: [:each | Character value: each]).
	1 to: 4
		do: 
			[:i |
			| ch |
			ch := '🐬' at: i.
			self assert: ch isUtf8Surrogate.
			self assert: (subject
						nextIdentityIndexOf: ch
						from: 1
						to: subject size)
				equals: 0].
	subject := '£ 🐬 string'.
	self assert: subject encoding equals: #utf8.
	1 to: 4
		do: 
			[:i |
			"Search should work, even if we start in the middle of a 32-bit character"
			self assert: (subject
						nextIdentityIndexOf: $\x1F42C
						from: i
						to: subject size)
				equals: 4].
	1 to: 9
		do: 
			[:i |
			self assert: (subject
						nextIdentityIndexOf: $s
						from: i
						to: subject size)
				equals: 9].
	1 to: 4
		do: 
			[:i |
			| ch |
			ch := '🐬' at: i.
			1 to: 3 + i
				do: 
					[:j |
					"Search for UTF-8 surrogates - this should work, again regardless of whether we start in the middle of a character"
					self assert: (subject
								nextIdentityIndexOf: ch
								from: j
								to: subject size)
						equals: 3 + i]]!

testPrimitiveStructIsNull
	| method subject |
	method := self createPrimitiveMethodLike: ExternalStructure >> #isNull.
	subject := DWORD new.
	self deny: (method value: subject withArguments: #()).
	subject bytes isImmutable: true.
	self deny: (method value: subject withArguments: #()).
	subject bytes: nil.
	self assert: (method value: subject withArguments: #()).
	subject bytes: Object new.
	self assert: (method value: subject withArguments: #()) equals: 'ObjectTypeMismatch'.
	subject bytes: ExternalHandle new.
	self deny: (method value: subject withArguments: #()).
	subject bytes: ExternalAddress new.
	self assert: (method value: subject withArguments: #()).
	subject := DWORD fromInteger: 1.
	self deny: (method value: subject withArguments: #()).
	subject := DWORD fromAddress: 1.
	self deny: (method value: subject withArguments: #())!

testPrimitiveSubtract
	"Test the SmallInteger subtract primitive for normal, overflow and failure cases."

	| method |
	method := self createPrimitiveMethodLike: SmallInteger >> #-.
	self assert: (method value: 1 withArguments: #('s')) equals: 'InvalidParameter1'.
	"The primitive works for SmallIntegers, LargeIntegers, and Floats, but not Fractions"
	self assert: (method value: 1 withArguments: {1 / 2}) equals: 'InvalidParameter1'.
	"Note that we don't test that the primitive fails for a non-SmallInteger receiver - in general primitives assume they are only used in methods of suitable receiver classes."
	self verifyBinaryPrimitive: method
		forCases: #(#(3 2 1) #(-1 -1 0) #(-1 16r3FFFFFFF -16r40000000) #(-2 16r3FFFFFFF -16r40000001) #(-16r40000000 1 -16r40000001) #(-16r40000000 -16r40000000 0) #(-16r40000000 16r3FFFFFFF -16r7FFFFFFF) #(16r3FFFFFFF -16r40000000 16r7FFFFFFF) #(1 'a' 'InvalidParameter1') #(1 16r40000000 -16r3FFFFFFF) #(0 16r40000000 -16r40000000) #(16r3FFFFFFF 1073741823.0 0.0) #(-16r40000000 1073741823.0 -2147483647.0))
				, {{-16r40000000. Float fmax. Float fmax negated}.
						{16r3FFFFFFF. Float fmax negated. Float fmax}.
						{0. Float fmin. Float fmin negated}}!

testPrimitiveYourAddress
	| method |
	method := self createPrimitiveMethodLike: Object >> #yourAddress.
	#('' 'abc') do: 
			[:each |
			| addr |
			addr := method value: each withArguments: #().
			self deny: addr identicalTo: 0.
			self assert: (each class fromAddress: each yourAddress) equals: each].
	"Bug: #yourAddress returns 0 for an empty byte array?"
	#(#[] #[1 2 3]) do: 
			[:each |
			| addr |
			addr := method value: each withArguments: #().
			self deny: addr identicalTo: 0.
			self assert: (ByteArray fromAddress: addr length: each size) equals: each].
	self assert: (method value: nil withArguments: #()) equals: 0!

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
	self assert: (bytes qwordAtOffset: 0) identicalTo: 16r3FFFFFFF.
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
			self assert: signed equals: expected.
			each class == SmallInteger
				ifFalse: 
					[dword := each + 1 - 1.
					self assert: dword isImmutable.
					signed := VMLibrary default signedFromUnsigned: dword.
					self assert: signed equals: expected.
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
	self assert: (bytes sqwordAtOffset: 0) identicalTo: 16r3FFFFFFF.
	bytes := ByteArray fromHexString: '000000C0FFFFFFFF'.
	self assert: (bytes sqwordAtOffset: 0) identicalTo: -16r40000000.
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
	self assert: actual identicalTo: -1!

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
	self assert: subject1 first identicalTo: DeadObject current.
	self assert: subject1 second identicalTo: obj2.
	self assert: subject1 third identicalTo: DeadObject current.
	self assert: (losses at: id2) equals: 2.
	self assert: subject2 first identicalTo: DeadObject current.
	self assert: subject2 second identicalTo: obj2.
	self assert: subject2 third identicalTo: DeadObject current.
	obj2 := subject1 := subject2 := nil.
	MemoryManager current collectGarbage.
	"Garbage weak array should not have been notified of loss of obj2 as it was collected in same GC cycle"
	self assert: (losses at: id1) equals: 2.
	"Garbage but finalizable weak array should have been notified of loss of obj2"
	self assert: (losses at: id2) equals: 3!

verifyBinaryPrimitive: method forCases: aCollectionOfTriples
	| result |
	aCollectionOfTriples do: 
			[:each |
			| subject operand expected |
			subject := each first.
			self assert: subject class identicalTo: SmallInteger.
			operand := each second.
			expected := each third.
			result := method value: subject withArguments: {operand}.
			self assert: result class identicalTo: expected class.
			self assert: result equals: expected]!

verifyExtCallArgLppvoid: aBoolean
	| method string result address |
	method := Compiler compile: ('x: aString
	%<<1?overlap :>stdcall: uintptr AnswerDWORD lppvoid>
	^_failureCode'
						expandMacrosWith: aBoolean)
				in: VMLibrary.
	string := 'Hello World' asAnsiString.
	"Sanity check"
	address := string yourAddress asExternalAddress.
	result := method value: VMLibrary default withArguments: {address}.
	self assert: result equals: address basicYourAddress.

	"Integers are a special case - they should pass through directly as the pointer value"
	address := string yourAddress.
	result := method value: VMLibrary default withArguments: {address}.
	self assert: result equals: address.

	"Now check LI"
	address := string yourAddress becomeA: LargeInteger.
	result := method value: VMLibrary default withArguments: {address}.
	self assert: result equals: string yourAddress!

verifyExtCallArgLpwstr: aBoolean
	| method expected actual |
	method := Compiler
				compile: ('x: aString
	%<<1?overlap :>stdcall: lpwstr AnswerDWORD lpwstr>
	^_failureCode'
						expandMacrosWith: aBoolean)
				in: VMLibrary.
	self assert: method argumentTypes asArray equals: #('lpwstr').
	self assert: method returnType equals: 'lpwstr'.
	expected := Utf16String fromByteArray: #[97 0 32 0 163 0 32 0 111 0 114 0 32 0 116 0 119 0 111 0].
	actual := method value: VMLibrary default withArguments: {expected}.
	self assert: actual equals: expected.
	self deny: actual == expected.
	self assert: actual isKindOf: Utf16String.
	actual := method value: VMLibrary default withArguments: #('a £ or two').
	self assert: actual equals: expected.
	self assert: actual isKindOf: Utf16String.
	actual := method value: VMLibrary default withArguments: {'a £ or two' asUtf8String}.
	self assert: actual equals: expected.
	self assert: actual isKindOf: Utf16String.
	{String empty. Utf8String empty} do: 
			[:each |
			actual := method value: VMLibrary default withArguments: {each}.
			self assert: actual isKindOf: Utf16String.
			self assert: actual size equals: 0.
			self assert: actual equals: Utf16String empty]!

verifyExtCallCrtFault: aBoolean
	| lib |
	lib := aBoolean ifTrue: [CRTLibrary nonblocking] ifFalse: [CRTLibrary default].
	self
		should: [lib fgetc: nil]
		raise: CRTError
		matching: [:ex | ex tag == EINVAL]!

verifyExtCallFpFault: aBoolean
	| method exceptions fpFault |
	method := self compile: ('sqrt: arg %<<1?overlap :>stdcall: double sqrt double> ^_failureCode'
						expandMacrosWith: aBoolean)
				in: CRTLibrary.
	exceptions := OrderedCollection new.
	[2 timesRepeat: [method value: CRTLibrary default withArguments: #(-1)]] on: FloatingPointException
		do: [:ex | exceptions add: ex].
	self assert: exceptions size equals: 1.
	fpFault := exceptions first.
	self assert: fpFault tag causeName identicalTo: #InvalidOperation.
	self assert: fpFault tag operationName identicalTo: #SquareRoot.
	self assert: fpFault tag operand1 value equals: -1.0!

verifyExtCallGpf: aBoolean
	| method |
	method := self
				compile: ('test: anInteger %<<1?overlap :>stdcall: lpstr AnswerDWORD lpvoid> ^self invalidCall: _failureCode'
						expandMacrosWith: aBoolean)
				in: VMLibrary.
	"The call is repeated to verify that the threaded call is reset properly when the exception is handled. If it isn't then this will fail with i = 2"
	1 to: 2
		do: 
			[:i |
			self
				should: [method value: VMLibrary default withArguments: #(1)]
				raise: GPFault
				matching: 
					[:ex |
					ex inaccessibleAddress = 1
						and: [ex isReading and: [ex moduleFileName = VMLibrary default moduleFileName]]]]!

verifyExtCallIntDivZero: aBoolean
	| method |
	method := self
				compile: ('ldiv: numer denom: denom %<<1?overlap :>stdcall: qword ldiv sdword sdword> ^self invalidCall: _failureCode'
						expandMacrosWith: aBoolean)
				in: CRTLibrary.
	self
		should: [method value: CRTLibrary default withArguments: #(123 0)]
		raise: ZeroDivide
		matching: [:ex | ex dividend = 123]!

verifyExtCallRetBool8: aBoolean
	| method |
	method := Compiler
				compile: ('bool8: anInteger
	%<<1?overlap :>stdcall: bool8 AnswerDWORD sdword>
	^self invalidCall: _failureCode'
						expandMacrosWith: aBoolean)
				in: VMLibrary.
	1 to: 255 do: [:i | self assert: (method value: VMLibrary default withArguments: {i})].
	self assert: (method value: VMLibrary default withArguments: {-1}).
	self deny: (method value: VMLibrary default withArguments: {0}).
	"Bits outside the first byte should be ignored"
	self deny: (method value: VMLibrary default withArguments: {16r100}).
	self deny: (method value: VMLibrary default withArguments: {-32768})!

verifyExtCallRetErrno: aBoolean
	| method |
	method := self
				compile: ('errno: anInteger
	%<<1?overlap :>stdcall: errno AnswerDWORD dword>
	^''Failure '', _failureCode printString'
						expandMacrosWith: aBoolean)
				in: VMLibrary.
	self assert: (method value: VMLibrary default withArguments: {0}) identicalTo: 0.

	"Any non-zero result should fail. It is assumed the codes don't exceed the SmallInteger range"
	{SmallInteger minimum. -1. 1. SmallInteger maximum} do: 
			[:each |
			| result |
			result := method value: VMLibrary default withArguments: {each}.
			self assert: result equals: 'Failure ' , each printString]!

verifyExtCallRetHRESULT: aBoolean
	| method |
	method := self
				compile: ('hresult: anInteger
	%<<1?overlap :>stdcall: hresult AnswerDWORD dword>
	^self invalidCall: _failureCode' expandMacrosWith: aBoolean)
				in: VMLibrary.
	#(0 1 16r3FFFFFFF 16r40000000 16r7FFFFFFF) do: 
			[:each |
			| result |
			result := method value: VMLibrary default withArguments: {each}.
			self assert: result isKindOf: Integer.
			self assert: result equals: each.
			self assert: each class identicalTo: result class].

	"Negative HRESULTs should cause the primitive to fail with the failure data set to the HR code. Note that the unused bit 27 is lost."
	#(16rFFFFFFFF 16r80004005 16rC0000000 16rBFFFFFFF 16r80000000 16rEABCFFFF 16r80290422) do: 
			[:each |
			self
				should: [method value: VMLibrary default withArguments: {each}]
				raise: HRESULTError
				matching: [:ex | ex hresult = (HRESULT fromUnsignedInteger: (each bitAnd: 16r8000000 bitInvert))]]!

verifyExtCallRetLpwstr: aBoolean
	| method expected actual |
	method := Compiler
				compile: ('w: anInteger
	%<<1?overlap :>stdcall: lpwstr AnswerDWORD lpvoid>
	^self _failureCode'
						expandMacrosWith: aBoolean)
				in: VMLibrary.
	expected := 'oña' asUtf16String.
	actual := method value: VMLibrary default withArguments: {expected yourAddress}.
	self assert: actual equals: expected.
	self assert: actual isKindOf: Utf16String!

verifyExtCallRetNtStatus: aBoolean
	| method |
	method := self
				compile: ('ntstatus: anInteger
	%<<1?overlap :>stdcall: ntstatus AnswerDWORD dword>
	^self invalidCall: _failureCode'
						expandMacrosWith: aBoolean)
				in: VMLibrary.
	#(0 1 16r3FFFFFFF 16r40000000 16r7FFFFFFF) do: 
			[:each |
			| result |
			result := method value: VMLibrary default withArguments: {each}.
			self assert: result isKindOf: Integer.
			self assert: result equals: each.
			self assert: each class identicalTo: result class].

	"Negative HRESULTs should cause the primitive to fail with a failure code that can be decoded to a valid NTSTATUS code, which is then translated to an HRESULT by the addition of FACILITY_NT_BIT, and raised as an HRESULTError."
	#(16rC0000001 16rC0EC0007) do: 
			[:each |
			self
				should: [method value: VMLibrary default withArguments: {each}]
				raise: HRESULTError
				matching: [:ex | ex hresult asUnsignedInteger = (each bitOr: HRESULT.FACILITY_NT_BIT)]]!

verifyPrimitiveAt: opAt performBlock: performAt
	| array outOfBounds notAnIntFormat |
	array := (-100 to: 100) asArray.
	-100 to: 100
		do: 
			[:i |
			self assert: (opAt value: array value: i + 100 + 1) identicalTo: i.
			self assert: (performAt value: array value: i + 100 + 1) identicalTo: i].
	"Valid case, first and last, with and without named fields"
	array := {'a'. 'b'}.
	self assert: (opAt value: array value: 1) equals: 'a'.
	self assert: (opAt value: array value: 2) equals: 'b'.
	array := MourningWeakArray with: 'a' with: 'b'.
	self assert: (opAt value: array value: 1) equals: 'a'.
	self assert: (opAt value: array value: 2) equals: 'b'.
	#(#(2) #[2]) do: 
			[:a |
			self assert: (opAt value: a value: 1) identicalTo: 2.
			self assert: (performAt value: a value: 1) identicalTo: 2].
	"Non-indexable object"
	#(1 0) do: 
			[:each |
			{opAt. performAt} do: 
					[:op |
					self
						should: [op value: Array value: each]
						raise: Error
						matching: [:ex | ex messageText = 'not indexable']]].
	notAnIntFormat := 'Index: <1p> is not an integer'.
	#(nil #[] #() 'a' $b) do: 
			[:each |
			{opAt. performAt} do: 
					[:op |
					self
						should: [op value: Array value: each]
						raise: Error
						matching: [:ex | ex messageText = (notAnIntFormat expandMacrosWith: each)]]].

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
	self assert: (opAt value: array value: 1) identicalTo: 2.
	self assert: (performAt value: array value: 1) identicalTo: 2.
	outOfBounds do: 
			[:each |
			self should: [opAt value: array value: each] raise: BoundsError.
			self should: [performAt value: array value: each] raise: BoundsError].

	"And again for one with a number of named instance variables (a method)"
	array := Object compiledMethodAt: #addDependent:.
	self assert: (opAt value: array value: 1) identicalTo: #getDependents.
	self should: 
			[| lit |
			lit := opAt value: array value: 2.
			lit == WeakArray or: [(lit isKindOf: VariableBinding) and: [lit value == WeakArray]]].
	self assert: (opAt value: array value: 3) identicalTo: #setDependents:.
	self assert: (opAt value: array value: array size) identicalTo: #ifTrue:.
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
				self
					should: [opAt value: array value: each]
					raise: Error
					matching: [:ex | ex messageText = (notAnIntFormat expandMacrosWith: each)].
				self
					should: [performAt value: array value: each]
					raise: Error
					matching: [:ex | ex messageText = (notAnIntFormat expandMacrosWith: each)]].
	"Non-integer indices"
	#($1 '1' nil true false #[1] #'1' #(1)) do: 
			[:each |
			{opAt. performAt} do: 
					[:block |
					self
						should: [block value: array value: each]
						raise: Error
						matching: [:ex | ex messageText = (notAnIntFormat expandMacrosWith: each)]]]!

verifyPrimitiveAtPut: opAtPut performBlock: performAtPut
	| bytes arrays |
	{opAtPut. performAtPut} do: 
			[:block |
			self
				should: 
					[block
						value: Array
						value: 1
						value: nil]
				raise: Error
				matching: [:ex | ex messageText = 'not indexable']].
	{opAtPut. performAtPut} do: 
			[:block |
			self should: 
					[block
						value: Array
						value: 0
						value: nil]
				raise: BoundsError].
	{nil. $a. 's'. SmallInteger maximum + 1} do: 
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
						matching: [:ex | ex messageText = ('Index: <1p> is not an integer' expandMacrosWith: each)]]].
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
	{-1. 0. 2. SmallInteger maximum. SmallInteger minimum} do: 
			[:each |
			arrays do: 
					[:array |
					{opAtPut. performAtPut} do: 
							[:block |
							self should: 
									[block
										value: array
										value: each
										value: array first]
								raise: BoundsError]]]!

verifyPrimitiveNextPutAllOnAnsiString: method
	| subject buf arg |
	subject := AnsiString writeStream.
	"Past limit"
	subject := (AnsiString new: 0) writeStream.
	self assert: (method value: subject withArguments: {'a' asAnsiString}) equals: 'OutOfBounds'.
	buf := AnsiString new: 3.
	subject := buf writeStream.
	"Primitive always fails for UTF-encoded string onto Ansi target - this is to allow the decision as to what to do with code points that cannot be represented to be handled in the Smalltalk code (it is an error, currently)"
	self assert: (method value: subject withArguments: {'€' asUtf8String }) equals: 'UnmappableCharacter'.
	self assert: (method value: subject withArguments: {'€' asUtf16String}) equals: 'UnmappableCharacter'.
	"Within limit"
	arg := '£' asAnsiString.
	self assert: (method value: subject withArguments: {arg}) identicalTo: arg.
	self assert: buf equals: (AnsiString with: $£ with: $\0 with: $\0).
	self assert: subject size equals: 1.
	"Past limit"
	self assert: (method value: subject withArguments: {'or€' asAnsiString}) equals: 'OutOfBounds'.
	"Up to limit"
	arg := 'a€' asAnsiString.
	self assert: (method value: subject withArguments: {arg}) identicalTo: arg.
	self assert: buf equals: (AnsiString with: $£ with: $a with: $€).
	self assert: subject size equals: 3.
	"Invalid arg types"
	self assert: (method value: subject withArguments: #(#[])) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: #(#())) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: #($a)) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: {Object new}) equals: 'InvalidParameter1'!

verifyPrimitiveNextPutAllOnArray: method
	| subject buf arg arg2 |
	"Past limit"
	subject := (Array new: 0) writeStream.
	self assert: (method value: subject withArguments: #(#($a))) equals: 'OutOfBounds'.
	buf := Array new: 3.
	subject := buf writeStream.
	"Within limit"
	arg := {Object new}.
	self assert: (method value: subject withArguments: {arg}) identicalTo: arg.
	self assert: buf equals: arg , #(nil nil).
	self assert: subject size equals: 1.
	"Past limit"
	self assert: (method value: subject withArguments: #(#($a $b $c))) equals: 'OutOfBounds'.
	"Up to limit"
	arg2 := #($a $b).
	self assert: (method value: subject withArguments: {arg2}) identicalTo: arg2.
	self assert: buf equals: arg , arg2.
	self assert: subject size equals: 3.
	"Invalid arg types"
	self assert: (method value: subject withArguments: #('')) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: #(#[])) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: #($a)) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: {Object new}) equals: 'InvalidParameter1'!

verifyPrimitiveNextPutAllOnByteArray: method
	| subject buf arg |
	subject := ByteArray writeStream.
	"Past limit"
	subject := (ByteArray new: 0) writeStream.
	self assert: (method value: subject withArguments: #(#[1])) equals: 'OutOfBounds'.
	buf := ByteArray new: 3.
	subject := buf writeStream.
	"Within limit"
	arg := #[255].
	self assert: (method value: subject withArguments: {arg}) identicalTo: arg.
	self assert: buf equals: #[255 0 0].
	self assert: subject size equals: 1.
	"Past limit"
	self assert: (method value: subject withArguments: #(#[1 2 3])) equals: 'OutOfBounds'.
	"Up to limit"
	arg := #[1 2].
	self assert: (method value: subject withArguments: {arg}) identicalTo: arg.
	self assert: buf equals: #[255 1 2].
	self assert: subject size equals: 3.
	"Invalid arg types"
	self assert: (method value: subject withArguments: #('')) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: #(#())) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: #($a)) equals: 'InvalidParameter1'.
	self assert: (method value: subject withArguments: {Object new}) equals: 'InvalidParameter1'!

verifyPrimitiveNextPutAllOnUtfStrings: method
	| testBlock utfStringClasses |
	{Utf8String. Utf16String} do: 
			[:eachClass |
			{'a' asAnsiString. 'a' asUtf8String. 'a' asUtf16String} do: 
					[:each |
					| buf subject |
					"Past limit"
					subject := (eachClass new: 0) writeStream.
					self assert: (method value: subject withArguments: {each}) equals: 'OutOfBounds'.
					buf := eachClass new: 1.
					subject := buf writeStream.
					self assert: (method value: subject withArguments: {each , each}) equals: 'OutOfBounds'.
					"Invalid arg type"
					self assert: (method value: subject withArguments: #(#[32])) equals: 'InvalidParameter1'.
					self assert: (method value: subject withArguments: #(#($a))) equals: 'InvalidParameter1'.
					self assert: (method value: subject withArguments: #($a)) equals: 'InvalidParameter1'.
					self assert: (method value: subject withArguments: {Object new}) equals: 'InvalidParameter1'.
					"Within limit exactly"
					self assert: (method value: subject withArguments: {each}) identicalTo: each.
					self assert: buf equals: each.
					self assert: subject size equals: 1.
					self assert: subject contents equals: each]].
	"'£' requires two UTF-8 code units, '€' requires 3, and '🐬' requires 4. In UTF-16 the chars require 1, 2, and 2 code units respectively"
	testBlock := 
			[:bufClass :argClass :char |
			| arg buf subject encodingSize |
			encodingSize := (bufClass with: char) size.
			buf := bufClass new: encodingSize - 1.
			subject := buf writeStream.
			arg := argClass with: char.
			self assert: (method value: subject withArguments: {arg}) equals: 'OutOfBounds'.
			buf := bufClass new: encodingSize.
			subject := buf writeStream.
			self assert: (method value: subject withArguments: {arg}) identicalTo: arg.
			self assert: subject size equals: encodingSize.
			self assert: buf equals: arg].
	utfStringClasses := {Utf8String. Utf16String}.
	#($£ $\x20AC) do: 
			[:each |
			utfStringClasses do: 
					[:eachTarget |
					{AnsiString} , utfStringClasses do: 
							[:eachArg |
							testBlock
								value: Utf8String
								value: eachArg
								value: each.
							testBlock
								value: Utf16String
								value: eachArg
								value: each]]].
	"Characters that cannot be represented in ANSI"
	{Character dolphin. $\x4F60} do: 
			[:each |
			utfStringClasses do: 
					[:eachTarget |
					utfStringClasses do: 
							[:eachArg |
							testBlock
								value: eachTarget
								value: eachArg
								value: each]]]! !

!VMTest categoriesForMethods!
assertImmutableAtPut:!private!unit tests! !
assertImmutableBasicAtPut:!private!unit tests! !
assertImmutableInstVarAtPut:!private!unit tests! !
assertImmutableResize:!private!unit tests! !
assertLoopInterruptible:!private!unit tests! !
compile:in:!helpers!private! !
createPrimitiveMethod:in:argCount:!helpers!private! !
createPrimitiveMethodLike:!helpers!private! !
earlyTermination:!helpers!private! !
elementsExpired:of:!helpers!private! !
exerciseReplaceElementsOf:from:to:with:startingAt:!private!unit tests! !
exerciseReplaceElementsOf:with:!private!unit tests! !
findCaller:in:!helpers!private! !
findFaultInterruptFrame:!helpers!private! !
firstVmVersionRespectingNonInstantiable!constants!private! !
getCPUTime!private!unit tests! !
hasDolphinCrtInvalidParameterHandler!private!testing! !
hashBytes:!helpers!private! !
immutableTestSubjects!constants!private!unit tests! !
isFault:raisedIn:receiver:!helpers!private! !
isGPF:reading:address:!helpers!private! !
skipIfVMDoesNotSupportArgumentConversionsThatAllocateMemoryInOverlappedCalls!helpers!private! !
suspendAndTerminate!helpers!private! !
testAllReferences!public!unit tests! !
testAllReferencesWeak!public! !
testBSTRArg!public!unit tests! !
testCRTFault!public!unit tests! !
testDwordAtOffsetPut!public!unit tests! !
testEvaluationOrder!public!unit tests! !
testExtCallArgBstr!public!unit tests! !
testExtCallArgChar32!public!unit tests! !
testExtCallArgLppvoid!public!unit tests! !
testExtCallArgLpwstr!public!unit tests! !
testExtCallCrtFault!public! !
testExtCallFpFault!public! !
testExtCallGpf!public! !
testExtCallIntDivZero!public! !
testExtCallOverlappedArgLppvoid!public!unit tests! !
testExtCallOverlappedArgLpwstr!public!unit tests! !
testExtCallOverlappedBool8!public!unit tests! !
testExtCallOverlappedCrtFault!public! !
testExtCallOverlappedFpFault!public! !
testExtCallOverlappedGC!public!unit tests! !
testExtCallOverlappedGpf!public! !
testExtCallOverlappedIntDivZero!public! !
testExtCallOverlappedRetErrno!public!unit tests! !
testExtCallOverlappedRetHRESULT!public!unit tests! !
testExtCallOverlappedRetLpwstr!public!unit tests! !
testExtCallOverlappedRetNtStatus!public!unit tests! !
testExtCallOverlappedSuspendAndTerminate!public!unit tests! !
testExtCallOverlappedTermination!public!unit tests! !
testExtCallRetErrno!public!unit tests! !
testExtCallRetHRESULT!public!unit tests! !
testExtCallRetLpwstr!public!unit tests! !
testExtCallRetNtStatus!public!unit tests! !
testExtendedCharsInCrashDump!public!unit tests! !
testFPFaultInPrimitive!public!unit tests! !
testFPStatus!public!unit tests! !
testGPFTrap!public!unit tests! !
testImmutableAtPut!public!unit tests! !
testImmutableBasicAtPut!public!unit tests! !
testImmutableBufferAtPuts!public!unit tests! !
testImmutableInstVarAtPut!public!unit tests! !
testImmutableNextPut!public!unit tests! !
testImmutableNextPutAll!public!unit tests! !
testImmutableReplacePrimitives!public!unit tests! !
testImmutableResize!public!unit tests! !
testImmutableStringCompare!public!unit tests! !
testImmutableWriteAccessors!public!unit tests! !
testIndirectByteAtOffsetPrimitives!public!unit tests! !
testIndirectDwordAtOffsetPrimitives!public!unit tests! !
testIndirectSdwordAtOffsetPrimitives!public!unit tests! !
testIndirectSwordAtOffsetPrimitives!public!unit tests! !
testIndirectWordAtOffsetPrimitives!public!unit tests! !
testIntDivideByZero!public!unit tests! !
testInterruptPendingOverlappedCall!public!unit tests! !
testLoopsInterruptible!public!unit tests! !
testMakeLargeUnsigned!public!unit tests! !
testMustBeBoolean!public!unit tests! !
testPrimitiveAdd!public!unit tests! !
testPrimitiveAllInstances!public!unit tests! !
testPrimitiveAllMask!public!unit tests! !
testPrimitiveAnyMask!public!unit tests! !
testPrimitiveAt!public!unit tests! !
testPrimitiveAtPut!public!unit tests! !
testPrimitiveBasicAt!public!unit tests! !
testPrimitiveBasicAtPut!public!unit tests! !
testPrimitiveBitShift!public!unit tests! !
testPrimitiveBytesEqual!public!unit tests! !
testPrimitiveBytesIsNull!public!unit tests! !
testPrimitiveChangeBehavior!public!unit tests! !
testPrimitiveCopyFromTo!public!unit tests! !
testPrimitiveDiv!public!unit tests! !
testPrimitiveDivide!public!unit tests! !
testPrimitiveEnableInterrupts!public!unit tests! !
testPrimitiveEqual!public!unit tests! !
testPrimitiveExtraInstanceSpec!public! !
testPrimitiveFindString!public!unit tests! !
testPrimitiveGreaterOrEqual!public!unit tests! !
testPrimitiveGreaterThan!public!unit tests! !
testPrimitiveHashBytes!public!unit tests! !
testPrimitiveHighBit!public!unit tests! !
testPrimitiveIdentical!public!unit tests! !
testPrimitiveIndexOfSp!public!unit tests! !
testPrimitiveInstanceCounts!public!unit tests! !
testPrimitiveInstanceCounts2!public!unit tests! !
testPrimitiveInstVarAt!public!unit tests! !
testPrimitiveInstVarAtPut!public!unit tests! !
testPrimitiveIsKindOf!public!unit tests! !
testPrimitiveLessOrEqual!public!unit tests! !
testPrimitiveLessThan!public!unit tests! !
testPrimitiveLookupMethod!public!unit tests! !
testPrimitiveMakePoint!public!unit tests! !
testPrimitiveMod!public!unit tests! !
testPrimitiveMultiply!public!unit tests! !
testPrimitiveNewColonFailure!public!unit tests! !
testPrimitiveNewFailure!public!unit tests! !
testPrimitiveNewFixedFailure!public!unit tests! !
testPrimitiveNewInitializedFailure!public!unit tests! !
testPrimitiveNewVirtualFailure!public!unit tests! !
testPrimitiveNextPut!public!unit tests! !
testPrimitiveNextPutAll!public!unit tests! !
testPrimitiveObjectCount!public!unit tests! !
testPrimitiveQuo!public!unit tests! !
testPrimitiveReplaceElements!public!unit tests! !
testPrimitiveResume!public!unit tests! !
testPrimitiveSetMutableInstVar!public!unit tests! !
testPrimitiveSetSpecialBehavior!public!unit tests! !
testPrimitiveShallowCopy!public!unit tests! !
testPrimitiveSize!public!unit tests! !
testPrimitiveSmallIntegerByteAt!public!unit tests! !
testPrimitiveStringAt!public!unit tests! !
testPrimitiveStringAtPut!public!unit tests! !
testPrimitiveStringCmp!public!unit tests! !
testPrimitiveStringCollate!public!unit tests! !
testPrimitiveStringNextIndexOfFromTo!public!unit tests! !
testPrimitiveStructIsNull!public!unit tests! !
testPrimitiveSubtract!public!unit tests! !
testPrimitiveYourAddress!public!unit tests! !
testQwordAtOffset!public!unit tests! !
testSignedFromUnsigned!public!unit tests! !
testSqwordAtOffset!public!unit tests! !
testVMPointersImmutable!public!unit tests! !
testWeakMournerNotifications!public!unit tests! !
verifyBinaryPrimitive:forCases:!helpers!private! !
verifyExtCallArgLppvoid:!helpers!private! !
verifyExtCallArgLpwstr:!helpers!private! !
verifyExtCallCrtFault:!helpers!private! !
verifyExtCallFpFault:!helpers!private! !
verifyExtCallGpf:!helpers!private! !
verifyExtCallIntDivZero:!helpers!private! !
verifyExtCallRetBool8:!helpers!private! !
verifyExtCallRetErrno:!helpers!private! !
verifyExtCallRetHRESULT:!helpers!private! !
verifyExtCallRetLpwstr:!helpers!private! !
verifyExtCallRetNtStatus:!helpers!private! !
verifyPrimitiveAt:performBlock:!helpers!private! !
verifyPrimitiveAtPut:performBlock:!helpers!private! !
verifyPrimitiveNextPutAllOnAnsiString:!helpers!private! !
verifyPrimitiveNextPutAllOnArray:!helpers!private! !
verifyPrimitiveNextPutAllOnByteArray:!helpers!private! !
verifyPrimitiveNextPutAllOnUtfStrings:!helpers!private! !
!

!VMTest class methodsFor!

resources
	^{MustBeBooleanTestClasses}! !

!VMTest class categoriesForMethods!
resources!Accessing!public! !
!

