"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ProcessTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProcessTest guid: (GUID fromString: '{3601a8c6-de0f-4218-a7df-40838259fc47}')!
ProcessTest comment: ''!
!ProcessTest categoriesForClass!Unclassified! !
!ProcessTest methodsFor!

assertBlock: copyBlockClosure in: copyProcess2 isCopyOf: srcBlockClosure in: sourceProcess2 visited: anIdentitySet
	(anIdentitySet includes: copyBlockClosure) ifTrue: [^true].
	anIdentitySet add: copyBlockClosure.
	self assert: copyBlockClosure isKindOf: BlockClosure.
	self assert: srcBlockClosure isKindOf: BlockClosure.
	srcBlockClosure isClean
		ifTrue: [self assert: copyBlockClosure sameAs: srcBlockClosure]
		ifFalse: 
			[self deny: copyBlockClosure sameAs: srcBlockClosure.
			self assert: copyBlockClosure initialIP equals: srcBlockClosure initialIP.
			self assert: copyBlockClosure method sameAs: srcBlockClosure method.
			self assert: copyBlockClosure argumentCount sameAs: srcBlockClosure argumentCount.
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
	self assert: (srcFrame isKindOf: BlockFrame).
	self assert: (copyFrame isKindOf: BlockFrame).
	"	self assert: copyFrame homeFrame asInteger = srcFrame homeFrame asInteger."
	srcBlock := srcFrame basicBP.
	copyBlock := copyFrame basicBP.
	self assert: srcBlock ~~ copyBlock.
	self assert: srcBlock method = copyBlock method.
	self assert: srcBlock initialIP = copyBlock initialIP.
	self assert: srcBlock argumentCount = copyBlock argumentCount.
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
	self assert: (copyContext isKindOf: self methodContextClass).
	self assert: (srcContext isKindOf: self methodContextClass).
	self assert: copyContext ~~ srcContext.
	self assert: ((copyContext outer == 0 and: [srcContext outer == 0]) 
				or: [copyContext outer ~= srcContext outer]).
	self assert: copyContext size = srcContext size.
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
	self assert: (srcFrame isKindOf: StackFrame).
	self assert: (copyFrame isKindOf: StackFrame).
	srcContext := srcFrame basicBP.
	copyContext := copyFrame basicBP.
	self assert: srcContext ~~ copyContext.
	self assert: (copyFrame process indexOfSP: copyContext outer) = copyFrame asInteger.
	self assert: (copyFrame process indexOfSP: copyContext outer) 
				= (srcFrame process indexOfSP: srcContext outer).
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
			[self deny: (sourceHandlers identityIncludes: env).
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
			self deny: copyExceptionHandler == srcExceptionHandler.
			self assert: (copyExceptionHandler isKindOf: ExceptionHandlerSet).
			srcHandlers := srcExceptionHandler instVarNamed: 'handlers'.
			copyHandlers := copyExceptionHandler instVarNamed: 'handlers'.
			copyHandlers with: srcHandlers
				do: 
					[:eachCopy :eachSrc |
					self assert: eachCopy key == eachSrc key.
					self assertBlock: eachCopy value in: copyProcess2 isCopyOf: eachSrc value in: sourceProcess2 visited: anIdentitySet.
					"self
						assertExceptionHandler: eachCopy
						in: copyProcess2
						isCopyOf: eachSrc
						in: sourceProcess2
						visited: anIdentitySet"]]
		ifFalse: 
			[self assert: (copyExceptionHandler isKindOf: ExceptionHandler).
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
	self 
		assert: ((copyArg == copyProcess2 and: [srcArg == sourceProcess2]) or: [copyArg == srcArg])!

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
	self assert: copyFrame asInteger = srcFrame asInteger.
	self assert: copyFrame sp = srcFrame sp.
	self assert: copyFrame bp = srcFrame bp.
	self assert: copyFrame ip = srcFrame ip.
	self assert: copyFrame method == srcFrame method.
	self 
		assertObject: copyFrame receiver
		in: copyFrame process
		isOrIsCopyOf: srcFrame receiver
		in: srcFrame process
		visited: anIdentitySet.
	self assert: copyFrame argumentCount = srcFrame argumentCount.
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
		ifTrue: [self assert: copyFrame bp == srcFrame bp]
		ifFalse: 
			[(srcBase isKindOf: BlockClosure) 
				ifTrue: 
					[self 
						assertBlockFrame: copyFrame
						isCopyOf: srcFrame
						visited: anIdentitySet]
				ifFalse: 
					[self assert: (srcBase isKindOf: self methodContextClass).
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

testCopy
	| sem shared |
	sem := Semaphore new.
	shared := IdentityDictionary with: #state -> 0.
	shared at: #sourceProcess put: (self forkWaiterOn: sem sharing: shared).
	Processor sleep: 1.
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
	self assert: (shared at: #state) == 0.
	sem signal.
	self assert: (shared at: #state) == 1.
	(shared at: #copyProcess) resume.
	self assert: (shared at: #state) == 2!

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
					[self assert: (shared at: #copyProcess) state == #suspended.
					self assertStack: (shared at: #copyProcess) topFrame sender
						copiedCorrectlyFrom: (shared at: #sourceProcess) topFrame sender].
			HRESULTError signalWith: -1] 
					on: HRESULTError
					do: [:ex | ex return: Processor activeProcess identityHash]).
	Trace
		display: Processor activeProcess id;
		display: ': 1,  copyProcess = ';
		print: (shared at: #copyProcess);
		cr.
	Trace
		display: Processor activeProcess id printString , ': 2 ' , String lineDelimiter;
		flush.
	self assert: (shared at: #state) == Processor activeProcess identityHash.
	"N.B. Don't terminate the copy process, as this will run the unwind handlers, one of which
	disconnects the TestRunner from update events so it stops refreshing and showing progress.
	Also don't let if finalize and terminate itself"
	(shared at: #copyProcess) == Processor activeProcess 
		ifTrue: 
			[waitForCopy signal.
			Processor activeProcess beUnfinalizable.
			Processor suspendActive].
	Trace
		display: Processor activeProcess id printString , ': 3' , String lineDelimiter;
		flush.
	self assert: (shared at: #copyProcess) isSuspended.
	Trace
		display: Processor activeProcess id printString , ': 4 ' , String lineDelimiter;
		flush.
	(shared at: #copyProcess) resume.
	Trace
		display: Processor activeProcess id printString , ': 5 ' , String lineDelimiter;
		flush.
	waitForCopy wait.
	Trace
		display: Processor activeProcess id printString , ': 6 ' , String lineDelimiter;
		flush.
	self assert: (shared at: #state) == (shared at: #copyProcess) identityHash.
	Trace
		display: Processor activeProcess id printString , ': 7 ' , String lineDelimiter;
		flush.!

testCopyNestedBlocks
	| sem sourceProcess copyProcess |
	sem := Semaphore new.
	sourceProcess := self forkNested: sem.
	copyProcess := sourceProcess copy.
	self assert: copyProcess state == #suspended.
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
	self assert: (shared at: #state) = 1.
	sem wait.
	self assert: (shared at: #state) = 4.
	(shared at: #copyProcess) resume.
	sem wait.
	self assert: (shared at: #state) = 5!

testForkedBlockHomeFrame
	"Bug #52 - access to out-of-proc home frame, e.g. when debugging ProgressDialog operation block"

	[self assert: (Processor activeProcess topFrame homeFrame) isNil] fork. Processor sleep: 10!

testOverlappedErrno
	self assert: (CRTLibrary nonblocking chmod: '' pmode: 0) < 0.
	self assert: Processor activeProcess errno = 2!

testOverlappedLastError
	| temp1 temp2 |
	KernelLibrary default setLastError: 0.
	self assert: KernelLibrary default getLastError = 0.
	KernelLibrary default threadSetLastError: 0.
	self assert: KernelLibrary default threadGetLastError = 0.
	temp1 := File temporaryFilename.
	temp2 := File temporaryFilename.
	File
		delete: temp1;
		delete: temp2.
	self 
		should: [File copy: temp1 to: temp2]
		raise: Win32Error
		matching: 
			[:ex | 
			ex statusCode = 2].
	self assert: Processor activeProcess lastError = 2.
	self assert: KernelLibrary default getLastError = 0.
	self assert: KernelLibrary default threadGetLastError = 2!

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
	Processor sleep: 1.
	copyProcess := sourceProcess copy.
	self assert: x == 0.
	sem signal.
	self assert: x == 1.
	copyProcess resume.
	self assert: x == 1!

testUnwindFromActiveProcess
	| sema process |
	sema := Semaphore forMutualExclusion.
	self assert: sema excessSignals > 0.
	process := 
			[sema critical: 
					[self deny: sema excessSignals > 0.
					Processor activeProcess terminate]] 
					forkAt: Processor userInterruptPriority.
	self assert: sema excessSignals > 0!

testUnwindFromForeignProcess
	| sema process |
	sema := Semaphore forMutualExclusion.
	self assert: sema excessSignals > 0.
	process := 
			[sema critical: 
					[self deny: sema excessSignals > 0.
					sema wait	"deadlock"]] 
					forkAt: Processor userInterruptPriority.
	self deny: sema excessSignals > 0.
	"This is for illustration only - the BlockCannotReturn cannot 
	be handled here (it's truncated already)"
	self shouldnt: [process terminate] raise: Error.
	self assert: sema excessSignals > 0! !
!ProcessTest categoriesFor: #assertBlock:in:isCopyOf:in:visited:!helpers!private! !
!ProcessTest categoriesFor: #assertBlockFrame:isCopyOf:visited:!helpers!private! !
!ProcessTest categoriesFor: #assertContext:in:isCopyOf:in:visited:!helpers!private! !
!ProcessTest categoriesFor: #assertContextFrame:isCopyOf:visited:!helpers!private! !
!ProcessTest categoriesFor: #assertDisparateEnvironments:source:!helpers!private! !
!ProcessTest categoriesFor: #assertExceptionHandler:in:isCopyOf:in:visited:!helpers!private! !
!ProcessTest categoriesFor: #assertObject:in:isOrIsCopyOf:in:visited:!helpers!private! !
!ProcessTest categoriesFor: #assertOuterContext:in:isCopyOf:in:visited:!helpers!private! !
!ProcessTest categoriesFor: #assertProcess:copiedCorrectlyFrom:below:!helpers!private! !
!ProcessTest categoriesFor: #assertStack:copiedCorrectlyFrom:!helpers!private! !
!ProcessTest categoriesFor: #assertStackFrame:isCopyOf:visited:!helpers!private! !
!ProcessTest categoriesFor: #forkNested:!helpers!private! !
!ProcessTest categoriesFor: #forkWaiterOn:sharing:!helpers!private! !
!ProcessTest categoriesFor: #testCopy!public!unit tests! !
!ProcessTest categoriesFor: #testCopyExceptionHandlers!public!unit tests! !
!ProcessTest categoriesFor: #testCopyNestedBlocks!public!unit tests! !
!ProcessTest categoriesFor: #testCopyWhileUnwinding!public!unit tests! !
!ProcessTest categoriesFor: #testForkedBlockHomeFrame!public!unit tests! !
!ProcessTest categoriesFor: #testOverlappedErrno!public!unit tests! !
!ProcessTest categoriesFor: #testOverlappedLastError!public!unit tests! !
!ProcessTest categoriesFor: #testSchedulerTermination!public!tests! !
!ProcessTest categoriesFor: #testSeparateContexts!public!unit tests! !
!ProcessTest categoriesFor: #testUnwindFromActiveProcess!public!tests! !
!ProcessTest categoriesFor: #testUnwindFromForeignProcess!public!tests! !

