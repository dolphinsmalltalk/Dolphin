"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.ProcessTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ProcessTest guid: (Core.GUID fromString: '{3601a8c6-de0f-4218-a7df-40838259fc47}')!
Core.Tests.ProcessTest comment: ''!
!Core.Tests.ProcessTest categoriesForClass!Unclassified! !
!Core.Tests.ProcessTest methodsFor!

assertBlock: copyBlockClosure in: copyProcess2 isCopyOf: srcBlockClosure in: sourceProcess2 visited: anIdentitySet
	(anIdentitySet includes: copyBlockClosure) ifTrue: [^true].
	anIdentitySet add: copyBlockClosure.
	self assert: copyBlockClosure isKindOf: BlockClosure.
	self assert: srcBlockClosure isKindOf: BlockClosure.
	srcBlockClosure isClean
		ifTrue: [self assert: copyBlockClosure identicalTo: srcBlockClosure]
		ifFalse: 
			[self deny: copyBlockClosure identicalTo: srcBlockClosure.
			self assert: copyBlockClosure initialIP equals: srcBlockClosure initialIP.
			self assert: copyBlockClosure method identicalTo: srcBlockClosure method.
			self assert: copyBlockClosure argumentCount identicalTo: srcBlockClosure argumentCount.
			self
				assert: ((copyBlockClosure outer isNil and: [srcBlockClosure outer isNil]) or: 
							[| copyOuter srcOuter |
							copyOuter := copyBlockClosure outer.
							srcOuter := srcBlockClosure outer.
							self
								assertOuterContext: copyOuter
								in: copyProcess2
								isCopyOf: srcOuter
								in: sourceProcess2
								visited: anIdentitySet])].
	^true!

assertBlockFrame: copyFrame isCopyOf: srcFrame visited: anIdentitySet
	"Should be a shallow copy of the context with separate slots, but the same values for the temps"

	| copyBlock srcBlock |
	self assert: srcFrame isKindOf: BlockFrame.
	self assert: copyFrame isKindOf: BlockFrame.
	"	self assert: copyFrame homeFrame asInteger = srcFrame homeFrame asInteger."
	srcBlock := srcFrame basicBP.
	copyBlock := copyFrame basicBP.
	self deny: srcBlock identicalTo: copyBlock.
	self assert: srcBlock method equals: copyBlock method.
	self assert: srcBlock initialIP equals: copyBlock initialIP.
	self assert: srcBlock argumentCount equals: copyBlock argumentCount.
	"The method context must not be shared"
	self
		assertContext: copyBlock outer
		in: copyFrame process
		isCopyOf: srcBlock outer
		in: srcFrame process
		visited: anIdentitySet!

assertContext: copyContext in: copyProcess2 isCopyOf: srcContext in: sourceProcess2 visited: anIdentitySet
	(anIdentitySet includes: copyContext) ifTrue: [^true].
	anIdentitySet add: copyContext.
	self assert: copyContext isKindOf: self methodContextClass.
	self assert: srcContext isKindOf: self methodContextClass.
	self deny: copyContext identicalTo: srcContext.
	self assert: ((copyContext outer == 0 and: [srcContext outer == 0])
				or: [copyContext outer ~= srcContext outer]).
	self assert: copyContext size equals: srcContext size.
	1 to: copyContext size
		do: 
			[:i |
			self
				assertObject: (copyContext at: i)
				in: copyProcess2
				isOrIsCopyOf: (srcContext at: i)
				in: sourceProcess2
				visited: anIdentitySet].
	^true!

assertContextFrame: copyFrame isCopyOf: srcFrame visited: anIdentitySet
	| copyContext srcContext |
	self assert: srcFrame isKindOf: StackFrame.
	self assert: copyFrame isKindOf: StackFrame.
	srcContext := srcFrame basicBP.
	copyContext := copyFrame basicBP.
	self deny: srcContext identicalTo: copyContext.
	self assert: (copyFrame process indexOfSP: copyContext outer) equals: copyFrame asInteger.
	self assert: (copyFrame process indexOfSP: copyContext outer)
		equals: (srcFrame process indexOfSP: srcContext outer).
	"The method context must not be shared"
	self
		assertContext: copyContext
		in: copyFrame process
		isCopyOf: srcContext
		in: srcFrame process
		visited: anIdentitySet!

assertDisparateEnvironments: copyProcess2 source: sourceProcess2
	| sourceHandlers env |
	sourceHandlers := OrderedCollection new.
	env := sourceProcess2 exceptionEnvironment.
	[env isNil] whileFalse: 
			[sourceHandlers add: env.
			env := env outer].
	env := copyProcess2 exceptionEnvironment.
	[env isNil] whileFalse: 
			[self deny: (sourceHandlers identityIncludes: env) description: 'Handler was not copied'.
			env := env outer]!

assertExceptionHandler: copyExceptionHandler in: copyProcess2 isCopyOf: srcExceptionHandler in: sourceProcess2 visited: anIdentitySet
	(anIdentitySet includes: copyExceptionHandler) ifTrue: [^true].
	anIdentitySet add: copyExceptionHandler.
	self
		assert: ((copyExceptionHandler outer isNil and: [srcExceptionHandler outer isNil]) or: 
					[self
						assertExceptionHandler: copyExceptionHandler outer
						in: copyProcess2
						isCopyOf: srcExceptionHandler outer
						in: sourceProcess2
						visited: anIdentitySet]).
	self
		assertBlock: (copyExceptionHandler instVarNamed: 'protectedBlock')
		in: copyProcess2
		isCopyOf: (srcExceptionHandler instVarNamed: 'protectedBlock')
		in: sourceProcess2
		visited: anIdentitySet.
	self
		assertBlock: (copyExceptionHandler instVarNamed: 'returnContinuation')
		in: copyProcess2
		isCopyOf: (srcExceptionHandler instVarNamed: 'returnContinuation')
		in: sourceProcess2
		visited: anIdentitySet.
	(srcExceptionHandler isKindOf: ExceptionHandlerSet)
		ifTrue: 
			[| copyHandlers srcHandlers |
			self deny: copyExceptionHandler identicalTo: srcExceptionHandler.
			self assert: copyExceptionHandler isKindOf: ExceptionHandlerSet.
			srcHandlers := srcExceptionHandler instVarNamed: 'handlers'.
			copyHandlers := copyExceptionHandler instVarNamed: 'handlers'.
			1 to: copyHandlers size
				by: 2
				do: 
					[:i |
					self assert: (copyHandlers at: i) identicalTo: (srcHandlers at: i).
					self
						assertBlock: (copyHandlers at: i + 1)
						in: copyProcess2
						isCopyOf: (srcHandlers at: i + 1)
						in: sourceProcess2
						visited: anIdentitySet]]
		ifFalse: 
			[self assert: copyExceptionHandler isKindOf: ExceptionHandler.
			self
				assertBlock: (copyExceptionHandler instVarNamed: 'handler')
				in: copyProcess2
				isCopyOf: (srcExceptionHandler instVarNamed: 'handler')
				in: sourceProcess2
				visited: anIdentitySet.
			self
				assertObject: (copyExceptionHandler instVarNamed: 'selector')
				in: copyProcess2
				isOrIsCopyOf: (srcExceptionHandler instVarNamed: 'selector')
				in: sourceProcess2
				visited: anIdentitySet].
	^true!

assertObject: copyArg in: copyProcess2 isOrIsCopyOf: srcArg in: sourceProcess2 visited: anIdentitySet
	| class |
	class := srcArg class.
	class == BlockClosure
		ifTrue: 
			[^self
				assertBlock: copyArg
				in: copyProcess2
				isCopyOf: srcArg
				in: sourceProcess2
				visited: anIdentitySet].
	class == self methodContextClass
		ifTrue: 
			[^self
				assertContext: copyArg
				in: copyProcess2
				isCopyOf: srcArg
				in: sourceProcess2
				visited: anIdentitySet].
	(class inheritsFrom: ExceptionHandlerAbstract)
		ifTrue: 
			[^self
				assertExceptionHandler: copyArg
				in: copyProcess2
				isCopyOf: srcArg
				in: sourceProcess2
				visited: anIdentitySet].
	self assert: ((copyArg == copyProcess2 and: [srcArg == sourceProcess2]) or: [copyArg == srcArg])!

assertOuterContext: copyOuter in: copyProcess2 isCopyOf: srcOuter in: sourceProcess2 visited: anIdentitySet
	^copyOuter class == BlockClosure
		ifTrue: 
			[self
				assertBlock: copyOuter
				in: copyProcess2
				isCopyOf: srcOuter
				in: sourceProcess2
				visited: anIdentitySet]
		ifFalse: 
			[self
				assertContext: copyOuter
				in: copyProcess2
				isCopyOf: srcOuter
				in: sourceProcess2
				visited: anIdentitySet]!

assertProcess: copyProcess2 copiedCorrectlyFrom: sourceProcess2 below: aStackFrame 
	| copyTopFrame srcTopFrame |
	srcTopFrame := aStackFrame ifNil: [sourceProcess2 topFrame].
	copyTopFrame := copyProcess2 topFrame.
	self assertStack: copyTopFrame copiedCorrectlyFrom: srcTopFrame!

assertStack: copyTopFrame copiedCorrectlyFrom: srcTopFrame
	| srcFrame visited copyFrame |
	srcFrame := srcTopFrame.
	copyFrame := copyTopFrame.
	visited := IdentitySet new.
	[srcFrame isNil] whileFalse: 
			[self
				assertStackFrame: copyFrame
				isCopyOf: srcFrame
				visited: visited.
			srcFrame := srcFrame sender.
			copyFrame := copyFrame sender].
	self assertDisparateEnvironments: copyTopFrame process source: srcTopFrame process!

assertStackFrame: copyFrame isCopyOf: srcFrame visited: anIdentitySet
	| srcBase |
	self assert: copyFrame asInteger equals: srcFrame asInteger.
	self assert: copyFrame sp equals: srcFrame sp.
	self assert: copyFrame bp equals: srcFrame bp.
	self assert: copyFrame ip equals: srcFrame ip.
	self assert: copyFrame method identicalTo: srcFrame method.
	self
		assertObject: copyFrame receiver
		in: copyFrame process
		isOrIsCopyOf: srcFrame receiver
		in: srcFrame process
		visited: anIdentitySet.
	self assert: copyFrame argumentCount equals: srcFrame argumentCount.
	1 to: copyFrame argumentCount
		do: 
			[:i |
			self
				assertObject: (copyFrame argAt: i)
				in: copyFrame process
				isOrIsCopyOf: (srcFrame argAt: i)
				in: srcFrame process
				visited: anIdentitySet].
	srcBase := copyFrame basicBP.
	srcBase isInteger
		ifTrue: [self assert: copyFrame bp identicalTo: srcFrame bp]
		ifFalse: 
			[(srcBase isKindOf: BlockClosure)
				ifTrue: 
					[self
						assertBlockFrame: copyFrame
						isCopyOf: srcFrame
						visited: anIdentitySet]
				ifFalse: 
					[self assert: srcBase isKindOf: self methodContextClass.
					self
						assertContextFrame: copyFrame
						isCopyOf: srcFrame
						visited: anIdentitySet]]!

forkNested: s
	| x |
	x := 0.
	^
	[[s wait] value.
	x := x + 1] forkAt: Processor userInterruptPriority!

forkWaiterOn: s sharing: anIdentityDictionary
	| x |
	x := 0.
	^
	[s wait.
	x := x + 1.
	anIdentityDictionary at: #state put: (anIdentityDictionary at: #state) + 1] 
			forkAt: Processor userInterruptPriority!

isMemTopDown
	"It is possible to configure Windows so that memory for 32-bit processes is allocated top-down. This is really a debugging mode to help detect issues in 32-bit apps when run large address aware.
	If this mode is enabled, then we don't need to try and push process allocations over the 2Gb boundary, as actually we may end up doing the reverse."

	| allocationPreference |
	allocationPreference := (OS.RegKey localMachineRoot
				at: 'System\CurrentControlSet\Control\Session Manager\Memory Management')
				mode: #read;
				valueAt: 'AllocationPreference' ifAbsent: [0].
	^allocationPreference allMask: OS.Win32Constants.MEM_TOP_DOWN!

testAsStackPointer
	{0 -> 0.
		-1 -> -1.
		SmallInteger maximum -> SmallInteger maximum.
		SmallInteger minimum -> SmallInteger minimum.
		SmallInteger maximum + 1 -> ((SmallInteger maximum + 1) bitInvert + 1).
		SmallInteger minimum - 1 -> ((SmallInteger minimum - 1) bitInvert - 1).
		16rFFFFFFFF // 2 -> -1} do: [:pair | self assert: pair key asStackPointer equals: pair value]!

testCopy
	| sem shared |
	sem := Semaphore new.
	shared := IdentityDictionary with: #state -> 0.
	shared at: #sourceProcess put: (self forkWaiterOn: sem sharing: shared).
	Processor sleep: 1 milliseconds.
	shared at: #copyProcess put: (shared at: #sourceProcess) copy.
	"	Transcript
		print: Processor activeProcess id;
		display: ': ';
		print: copyProcess;
		display: ' in ';
		display: copyProcess suspendedFrame;
		cr.
"
	self
		assertProcess: (shared at: #copyProcess)
		copiedCorrectlyFrom: (shared at: #sourceProcess)
		below: nil.
	self assert: (shared at: #state) identicalTo: 0.
	sem signal.
	self assert: (shared at: #state) identicalTo: 1.
	(shared at: #copyProcess) resume.
	self assert: (shared at: #state) identicalTo: 2!

testCopyExceptionHandlers
	| shared waitForCopy |
	waitForCopy := Semaphore new.
	shared := IdentityDictionary with: #state -> 1.
	shared at: #sourceProcess put: Processor activeProcess.
	shared at: #state
		put: (
			[shared at: #copyProcess put: (shared at: #sourceProcess) copy.
			Processor activeProcess == (shared at: #sourceProcess)
				ifTrue: 
					[self assert: (shared at: #copyProcess) state identicalTo: #suspended.
					self assertStack: (shared at: #copyProcess) topFrame sender
						copiedCorrectlyFrom: (shared at: #sourceProcess) topFrame sender].
			OS.HRESULTError signalWith: -1]
					on: OS.HRESULTError
					do: [:ex | ex return: Processor activeProcess identityHash]).
	Processor activeProcess debugStream
		print: Processor activeProcess id;
		nextPutAll: ': 1,  copyProcess = ';
		print: (shared at: #copyProcess);
		cr.
	Processor activeProcess debugStream
		print: Processor activeProcess id;
		nextPutAll: ': 2';
		cr.
	self assert: (shared at: #state) identicalTo: Processor activeProcess identityHash.
	"N.B. Don't terminate the copy process, as this will run the unwind handlers, one of which
	disconnects the TestRunner from update events so it stops refreshing and showing progress.
	Also don't let if finalize and terminate itself"
	(shared at: #copyProcess) == Processor activeProcess
		ifTrue: 
			[waitForCopy signal.
			Processor activeProcess beUnfinalizable.
			"The copied process will not progress to step 3"
			Processor suspendActive].
	Processor activeProcess debugStream
		print: Processor activeProcess id;
		nextPutAll: ': 3';
		cr.
	self assert: (shared at: #copyProcess) isSuspended.
	Processor activeProcess debugStream
		print: Processor activeProcess id;
		nextPutAll: ': 4';
		cr.
	(shared at: #copyProcess) resume.
	Processor activeProcess debugStream
		print: Processor activeProcess id;
		nextPutAll: ': 5';
		cr.
	waitForCopy wait.
	Processor activeProcess debugStream
		print: Processor activeProcess id;
		nextPutAll: ': 6';
		cr.
	self assert: (shared at: #state) identicalTo: (shared at: #copyProcess) identityHash.
	Processor activeProcess debugStream
		print: Processor activeProcess id;
		nextPutAll: ': 7';
		cr!

testCopyNestedBlocks
	| sem sourceProcess copyProcess |
	sem := Semaphore new.
	sourceProcess := self forkNested: sem.
	copyProcess := sourceProcess copy.
	self assert: copyProcess state identicalTo: #suspended.
	self
		assertProcess: copyProcess
		copiedCorrectlyFrom: sourceProcess
		below: nil!

testCopyWhileUnwinding
	| sem shared err |
	shared := SharedIdentityDictionary with: #state -> 1.
	sem := Semaphore new.
	err := Signal description: 'test'.
	
	[
	[
	[shared at: #state put: 2.
	err signal] ensure: 
				[shared at: #copyProcess put: Processor activeProcess copy.
				shared at: #state put: (shared at: #state) + 1.
				sem signal]]
			on: err
			do: [:ex | shared at: #state put: (shared at: #state) + 1]]
			forkAt: 3.
	self assert: (shared at: #state) equals: 1.
	sem wait.
	self assert: (shared at: #state) equals: 4.
	(shared at: #copyProcess) resume.
	sem wait.
	self assert: (shared at: #state) equals: 5!

testForkedBlockHomeFrame
	"Bug #52 - access to out-of-proc home frame, e.g. when debugging ProgressDialog operation block"

	[self assertIsNil: Processor activeProcess topFrame homeFrame] fork.
	Processor sleep: 10 milliseconds!

testLargeAddress
	| blocks sem1 sem2 result proc value copy1 copy2 frame expected isTopDown |
	self skipIfWin32.
	isTopDown := self isMemTopDown.
	isTopDown
		ifTrue: [self assert: Processor activeProcess yourAddress > SmallInteger maximum]
		ifFalse: 
			[blocks := OrderedCollection new: 3000.
			"Start by blocking out a few large chunks (mainly just to speed up the test a bit)"
			
			[
			[blocks addLast: (Array new: 1 max: 1024 * 1024 * 128).
			true] on: OutOfMemoryError
					do: [:ex | false]]
					whileTrue.
			"Reserve enough Process sized blocks of virtual memory to start pushing allocations beyond the 2Gb boundary"
			
			[| block |
			block := Process new: 1 max: Process.DefaultMaxStack.
			blocks addLast: block.
			block yourAddress <= 16r7FFFFFFF]
					whileTrue].
	"Now fork a process in large address space"
	sem1 := Semaphore new.
	sem2 := Semaphore new.
	value := {nil}.
	proc := 
			[sem1 wait.
			"Deliberately assign to an outer temp to ensure there is a Context to copy"
			result := 200 factorial.
			value at: 1 put: result.
			sem2 signal]
					fork.
	self assert: proc yourAddress >= 16r7FFFFFFF.
	self assert: proc basicSuspendedFrame class equals: SmallInteger.
	copy1 := proc copy.
	self assert: copy1 basicSuspendedFrame class equals: SmallInteger.
	frame := copy1 topFrame.
	self assert: frame basicSP class equals: SmallInteger.
	self assert: frame basicBP class equals: SmallInteger.
	self assert: frame basicSender class equals: SmallInteger.
	blocks := nil.
	MemoryManager current
		collectGarbage;
		administerLastRites.
	copy2 := proc copy.
	copy2 yourAddress < proc yourAddress
		ifTrue: 
			[self assert: copy2 basicSuspendedFrame class equals: SmallInteger.
			frame := copy2 topFrame.
			self assert: frame basicSP class equals: SmallInteger.
			self assert: frame basicBP class equals: SmallInteger.
			self assert: frame basicSender class equals: SmallInteger].
	sem1 signal.
	sem2 wait.
	expected := 200 factorial.
	self assert: result equals: expected.
	self assert: value first equals: expected.
	value at: 1 put: nil.
	sem1 signal.
	copy1 resume.
	sem2 wait.
	self assert: value first equals: expected.
	value at: 1 put: nil.
	sem1 signal.
	copy2 resume.
	sem2 wait.
	self assert: value first equals: expected!

testOverlappedErrno
	self assert: (OS.CRTLibrary nonblocking chmod: '' pmode: 0) < 0.
	self assert: Processor activeProcess errno equals: 2!

testOverlappedLastError
	| temp1 temp2 |
	OS.KernelLibrary default setLastError: 0.
	self assert: OS.KernelLibrary default getLastError equals: 0.
	OS.KernelLibrary default threadSetLastError: 0.
	self assert: OS.KernelLibrary default threadGetLastError equals: 0.
	temp1 := File temporaryFilename.
	temp2 := File temporaryFilename.
	File
		delete: temp1;
		delete: temp2.
	self
		should: [File copy: temp1 to: temp2]
		raise: OS.Win32Error
		matching: [:ex | ex statusCode = 2].
	self assert: Processor activeProcess lastError equals: 2.
	self assert: OS.KernelLibrary default getLastError equals: 0.
	self assert: OS.KernelLibrary default threadGetLastError equals: 2!

testSchedulerTermination
	| process sema gotHere sema2 |
	gotHere := false.
	sema := Semaphore new.
	sema2 := Semaphore new.
	process := 
			[sema signal.
			sema2 wait.
			"will be suspended here"
			gotHere := true	"e.g., we must *never* get here"]
					forkAt: Processor activeProcess priority.
	sema wait.	"until process gets scheduled"
	process terminate.
	sema2 signal.
	Processor yield.	"will give process a chance to continue and
horribly screw up"
	self assert: gotHere not!

testSeparateContexts
	| sem x sourceProcess copyProcess |
	sem := Semaphore new.
	x := 0.
	sourceProcess := 
			[sem wait.
			x := x + 1] forkAt: Processor userInterruptPriority.
	Processor sleep: 1 milliseconds.
	copyProcess := sourceProcess copy.
	self assert: x identicalTo: 0.
	sem signal.
	self assert: x identicalTo: 1.
	copyProcess resume.
	self assert: x identicalTo: 1!

testUnwindFromActiveProcess
	| sema process |
	sema := Semaphore forMutualExclusion.
	self assert: sema excessSignals > 0.
	process := 
			[sema critical: 
					[self deny: sema excessSignals > 0.
					Processor activeProcess terminate]]
					forkAt: Processor userInterruptPriority.
	self assert: sema excessSignals > 0.
	self assert: process isDead!

testUnwindFromForeignProcess
	| sema process |
	sema := Semaphore forMutualExclusion.
	self assert: sema excessSignals > 0.
	process := [sema critical: 
					[self deny: sema excessSignals > 0.
					sema wait	"deadlock"]]
				forkAt: Processor userInterruptPriority.
	self deny: sema excessSignals > 0.
	"This is for illustration only - the BlockCannotReturn cannot 
	be handled here (it's truncated already)"
	self shouldnt: [process terminate] raise: Error.
	self assert: sema excessSignals > 0! !
!Core.Tests.ProcessTest categoriesFor: #assertBlock:in:isCopyOf:in:visited:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertBlockFrame:isCopyOf:visited:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertContext:in:isCopyOf:in:visited:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertContextFrame:isCopyOf:visited:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertDisparateEnvironments:source:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertExceptionHandler:in:isCopyOf:in:visited:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertObject:in:isOrIsCopyOf:in:visited:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertOuterContext:in:isCopyOf:in:visited:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertProcess:copiedCorrectlyFrom:below:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertStack:copiedCorrectlyFrom:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #assertStackFrame:isCopyOf:visited:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #forkNested:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #forkWaiterOn:sharing:!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #isMemTopDown!helpers!private! !
!Core.Tests.ProcessTest categoriesFor: #testAsStackPointer!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testCopy!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testCopyExceptionHandlers!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testCopyNestedBlocks!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testCopyWhileUnwinding!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testForkedBlockHomeFrame!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testLargeAddress!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testOverlappedErrno!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testOverlappedLastError!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testSchedulerTermination!public!tests! !
!Core.Tests.ProcessTest categoriesFor: #testSeparateContexts!public!unit tests! !
!Core.Tests.ProcessTest categoriesFor: #testUnwindFromActiveProcess!public!tests! !
!Core.Tests.ProcessTest categoriesFor: #testUnwindFromForeignProcess!public!tests! !

