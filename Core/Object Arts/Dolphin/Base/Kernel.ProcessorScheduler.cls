"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ProcessorScheduler
	instanceVariableNames: 'processLists activeProcess pendingReturns comStubs _reserved pendingTerminations'
	classVariableNames: 'ConstWriteSignal InterruptSelectors'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProcessorScheduler guid: (GUID fromString: '{87b4c4aa-026e-11d3-9fd7-00a0cc3e4a32}')!
ProcessorScheduler comment: 'The singleton instance of ProcessorScheduler (the global, Processor) manages the set of live, ready to run, processes, scheduling the interpreter in a round-robin fashion but in strict priority order.

Processor is the destination for all asynchronous interrupts from the VM, and also manages ''callbacks'' (i.e. invocations of Smalltalk code from external systems, such as the dispatching of windows messages to the window procedure). In particular the Processor ensures that processes return from callbacks in strict LIFO order so that synchronization with the native machine stack is maintained.

Asynchronous interrupts may be delivered to a process at any time including when the process is suspended, e.g. waiting on a Semaphore. The only exceptions are that any interrupts queued to terminated processes are discarded, and that interrupts will not be delivered while asynchronous events are disabled (see #(enable|disable)Interrupts). Interrupts may be sent by the VM to notify of certain conditions, such as the weak loss or finalization queues exceeding their high water marks, but they can also be used to ''inject'' code from one process into another (see Process>>#interruptWith:). A similar mechanism is used when one Process explicitly terminates another (i.e. murder rather than suicide) to inject a terminate signal which is then used to raise an exception caught by a handler at the very base of the Process entry point. This has the effect of running all unwind blocks (set up by #ifCurtailed: and #ensure:) so that a Process can shut down cleanly.

Note that much of the behaviour of the ''processor'' is actually implemented in the process subsystem of the VM. This is partly for performance reasons, and partly because primitives are atomic.

Instance Variables:
	processLists 	<Array> of <LinkedList>s of processes which are ready to run and awaiting scheduling.
	activeProcess 	The <Process> which is currently executing
	pendingReturns	<Semaphore> on which out-of-order callback exit attempts wait their turn to exit.
	comStubs		<PermanentRegistry> of currently registered COM server stub object. Used to map virtual callbacks to their destination object.
	_reserved		nil. Reserved for future use.
	pendingTerminations	<Semaphore> on which processes being terminated wait until any outstanding overlapped calls have been terminated.
		
Class Variables:
	InterruptSelectors	<Array> of <Symbol> selectors for each of the interrupt numbers sent by the VM.'!
!ProcessorScheduler categoriesForClass!Kernel-Processes! !
!ProcessorScheduler methodsFor!

activePriority
	"Answer the priority of the current active process."

	^self activeProcess priority!

activeProcess
	"Answer the current active process."

	^activeProcess!

bereavedOverflow: interruptArg 
	"Private - The VM has detected that the bereavement queue has reached its high water mark.
	Inform the memory manager."

	MemoryManager current bereavedOverflow: interruptArg.
	self enableInterrupts!

callback: cookie evaluate: aNiladicBlock 
	"Private - Evaluate aNiladicBlock and return the result to the VM. Should any
	attempt be made to make a far return over this context, then ensure that the
	VM stack for the callback is unwound."

	^self callback: cookie return: (aNiladicBlock ifCurtailed: [self unwindCallback: cookie])!

callback: receiver perform: aSymbol cookie: cookie 
	"Private - Entry point from the VM. Suspend whatever the receiver is doing and send the 
	Object, receiver, the unary message whose selector is aSymbol. Return the result to the 
	VM. The receiver will then resume its previously active context.
	We must trap any attempts to return over the callback (e.g. due to trapping an exception
	in an outer context) and unwind the VM stack too.
	WARNING: Do not remove or modify this method."

	^self callback: cookie
		return: ([receiver perform: aSymbol] ifCurtailed: [self unwindCallback: cookie])!

callback: receiver perform: aSymbol with: arg cookie: cookie 
	"Private - Entry point from the VM. Suspend whatever the receiver is doing and send the 
	Object, receiver, the binary message whose selector is aSymbol with the argument, arg. 
	Return the result to the VM.  The receiver will then resume its previously active context.
	We must trap any attempts to return over the callback (e.g. due to trapping an exception
	in an outer context) and unwind the VM stack too.
	WARNING: Do not remove or modify this method."

	^self callback: cookie
		return: ([receiver perform: aSymbol with: arg] ifCurtailed: [self unwindCallback: cookie])!

callback: receiver perform: aSymbol with: arg1 with: arg2 cookie: cookie 
	"Private - Entry point from the VM. Suspend whatever the receiver is doing and send the 
	Object, the keyword message whose selector is aSymbol with the arguments, arg1 and arg2.
	Return the result to the VM.  The receiver will then resume its previously active context.
	We must trap any attempts to return over the callback (e.g. due to trapping an exception
	in an outer context) and unwind the VM stack too.
	WARNING: Do not remove or modify this method."

	^self callback: cookie
		return: (
			[receiver 
				perform: aSymbol
				with: arg1
				with: arg2] 
					ifCurtailed: [self unwindCallback: cookie])!

callback: receiver perform: aSymbol with: arg1 with: arg2 with: arg3 cookie: cookie 
	"Private - Entry point from the VM. Suspend whatever the receiver is doing and send the 
	Object, the keyword message whose selector is aSymbol with the arguments, arg1, arg2 and arg3.
	Return the result to the VM.  The receiver will then resume its previously active context.
	We must trap any attempts to return over the callback (e.g. due to trapping an exception
	in an outer context) and unwind the VM stack too.
	WARNING: Do not remove or modify this method."

	^self callback: cookie
		return: (
			[receiver 
				perform: aSymbol
				with: arg1
				with: arg2
				with: arg3] 
					ifCurtailed: [self unwindCallback: cookie])!

callback: receiver perform: aSymbol withArguments: anArray cookie: cookie 
	"Private - Entry point from the VM. Suspend whatever the receiver is doing and send the 
	Object, receiver, the keyword message whose selector is aSymbol with the arguments contained
	in anArray. Return the result to the VM. The receiver will resume from its active context
	before the callback.
	We must trap any attempts to return over the callback (e.g. due to trapping an exception
	in an outer context) and unwind the VM stack too.
	WARNING: Do not remove or modify this method."

	^self callback: cookie
		return: ([receiver perform: aSymbol withArguments: anArray] 
				ifCurtailed: [self unwindCallback: cookie])!

callback: cookie return: result 
	"Private - Return the <Object>, result, to the VM as the result of the callback identified by the 
	<integer>, cookie, which the VM passed in when it originated the callback,
	restoring the current active process to the context it was executing before the callback occurred.
	If the primitive returns nil, then we wait on the Processor's pendingCallbacks list (Semaphore).
	The primitive does not return here if the callback return succeeds.
	The VM ensures that when a callback exit succeeds pendingCallbacks has enough signals such
	that any Processes which attempted to return from callbacks out of sync since the last successful 
	callback return, will be restarted so that they can try to return again.
	This mechanism is necessary to synchronise the multiple threads in Smalltalk with the single VM
	thread. It works quite satifactorily unless a Process with an active callback lower down the VM
	stack than the pending callbacks becomes indefinitely blocked - the result is a deadlock."

	[(self primReturn: result callback: cookie) isNil] whileTrue: 
			["There is a more recent callback which has still not returned, so we must wait..."
			pendingReturns wait].
	^result	"Will not get this far unless in restarted image"!

callback: anInteger withArgumentsAt: anAddress cookie: cookie 
	"Private - Entry point from the VM. Suspend whatever the receiver is doing and evaluate
	the callback message or block with magic cookie, anInteger, whose arguments are stored in 
	the VM's stack at the address, anAddress."

	^self callback: cookie
		return: ([(ExternalCallback callback: anInteger withArgumentsAt: anAddress) asUIntPtr] 
				ifCurtailed: [self unwindCallback: cookie])!

cannotReturn: anObject
	"Private - Sent when the VM is unable to return anObject from the current active block
	because it's home method has already returned, or is homed in another process. This happens 
	when a block which contains a ^-return is stored into a variable, and is evaluated at some point
	not in the call stack above the method from which the block originated. In other
	words, blocks which are stored for parameterizing, etc, (e.g. a sort block), or used to 
	fork new processes, cannot contain ^-returns.
	N.B. If you get a walkback with this error from BlockClosure>>newProcess (the bottom
	stack frame) then it is advisable to Kill the offending process, as further walkbacks
	will occur if it is terminated normally."

	^CannotReturnError signalWith: anObject!

constWrite: exceptionRecordBytes 
	"Private - The VM generated a GP Fault interrupt. The argument is the relevant 
	EXCEPTION_RECORD."

	| exceptionRecord |
	self enableInterrupts.
	exceptionRecord := EXCEPTION_RECORD fromBytes: exceptionRecordBytes.
	^self constWriteSignal signalWith: exceptionRecord!

constWriteSignal
	^ConstWriteSignal!

crtFault: aByteArray 
	"Private - The VM generated a CRT Fault interrupt. The argument is the relevant exception
	record, the first argument of which is the fault code. An example of where this is fired is
	when an invalid parameter is passed to any CRT function, e.g. attempting to close an invalid
	file descriptor as follows: 
		CRTLibrary default _close: -1
	"

	| exceptionRecord |
	self enableInterrupts.
	exceptionRecord := EXCEPTION_RECORD fromBytes: aByteArray.
	^CRTError signalWith: exceptionRecord information first!

enableAsyncEvents: aBoolean
	"Private - Enable/disable asynchronous interrupts and semaphore signals. This does not
	prevent process switches due to synchronous process synchronisation, but it does prevent a
	process from being pre-empted due to asynchronous events. N.B. Do not rely on disabling
	async events as a means of process synchronisation because this facility may not be
	available in a future pre-emptive multi-threaded VM."

	<primitive: 95>
	^self primitiveFailed: _failureCode!

enableInterrupts
	"Private - Enable asynchronous interrupts and semaphore signals, and yield the processor in
	case a process switch would have occurred while async. events were disasbled.
	N.B. This is similar to #enableAsyncEvents:, but yields the processor if necessary. It is
	intended to be used from interrupt handlers: Since the VM dispatches interrupts even if it
	means pre-empting a higher priority process, we must allow that higher priority process to
	be rescheduled when re-enabling async. events. Where async. events are turned off to disable
	process switching in critical sections, the basic, #enableAsyncEvents:, message should be
	sent, since the normal process scheduling will not have been disrupted. Generally speaking
	this message need only be used in an interrupt handler."

	(self enableAsyncEvents: true) ifFalse: [self yield]!

forkMain
	"Private - Start a new main process."

	^self systemProcessOwner forkMain!

forkMainIfMain
	"Private - Start a new main process if executed in the context of the current
	main process. Answer whether the active process was formerly the main 
	process."

	| wasMain |
	wasMain := self isActiveMain.
	wasMain ifTrue: [self forkMain].
	^wasMain!

fpException: ieeeExceptionBytes 
	"Private - The active process has caused an IEEE floating point exception, whose details
	are the argument. Raise a matching Smalltalk exception."

	| ieeeRecord |
	self enableInterrupts.
	ieeeRecord := _FPIEEE_RECORD fromBytes: ieeeExceptionBytes.
	ieeeRecord isZeroDivide 
		ifTrue: [ZeroDivide dividend: ieeeRecord operand1 value]
		ifFalse: [FloatingPointException signalWith: ieeeRecord]!

fpStackFault: exceptionRecordBytes
	"Private - The VM generated an interrupt because it detected a floating point stack over or
	underflow. The argument is the relevant Win32 EXCEPTION_RECORD.
	Note that the VM will have reinitialized the floating point stack to avoid repeated FP
	stack check errors. FP stack check errors are an indication of a serious bug in some
	floating point code, the prime suspect being the reported module, however it is worth
	bearing in mind that said module might be an innocent victim of the mess left by some
	previous user of the FP stack."

	| exceptionRecord |
	activeProcess resetFloatingPoint.
	self enableInterrupts.
	exceptionRecord := EXCEPTION_RECORD fromBytes: exceptionRecordBytes.
	Win32Fault signal: 'Floating point stack under/overflow' with: exceptionRecord!

genericInterrupt
	"Private - Answer the interrupt number of the generic interrupt."

	^7!

gpFault: exceptionRecordBytes 
	"Private - The VM generated a GP Fault interrupt. The argument is the relevant 
	EXCEPTION_RECORD.
	Notes: 
	1) GPFs most commonly occur during an external library call - check the parameters,
	it is often possible to identify the culprit from the reported invalid address.
	2) GPFs are OFTEN recoverable (by catching the GPFault exception and handling it,
	or during development by dismissing the walkback), but be aware that the VM is likely
	to become unstable if the faulting code overwrote any Smalltalk memory. Furthermore the 
	problem will often not show up until the next GC or later.
	3) If a GP fault occurred while WRITING to memory, then the chances are that corruption 
	may have occurred and you should prepare for the worst!!"

	| exceptionRecord |
	self enableInterrupts.
	exceptionRecord := EXCEPTION_RECORD fromBytes: exceptionRecordBytes.
	GPFault signalWith: exceptionRecord
	"
ExternalAddress new dwordAtOffset:0
"!

highestPriority
	"Answer the highest priority level available"

	^processLists size!

highIOPriority
	"Answer the priority for critical I/O processes (e.g. network I/O)"

	^9!

hospiceOverflow: interruptArg 
	"Private - The VM has detected that the finalization queue has reached its high water mark.
	Inform the memory manager."

	"N.B. We don't enable interrupts, as we don't want to affect thread scheduling immediately."

	MemoryManager current hospiceOverflow: interruptArg!

idlePanic: interruptArg 
	"Private - The processor has determined that there are no processes ready to run - i.e. it
	is in a state of 'idle panic'. The argument is the interrupt enable/disable status. We take
	the remedial action of starting another idle process."

	SessionManager inputState idlePanic.
	self enableInterrupts!

idleProcess
	"Private - Answer the current idle process."

	^self systemProcessOwner idler!

interruptWith: aBlock 
	"Private - Another process queued the argument aBlock for evaluation as an interrupt block
	in the context of the receiver, so evaluate it. The queuer of the block will not get an
	answer. The block is evaluated with async events disabled."

	aBlock value.
	self enableInterrupts!

iret: frameOffset list: suspendingList
	"Private - Return to the active process'  frame, at the specified offset from the process base, on completion of an interrupt, restoring the <List>|<Semaphore>, suspendingList, which is nil if the process was active at the time of the interrupt. If a process is interrupted while suspended on a list, then it is re-suspended on that list when it has finished handling the interrupt, but note that it will be placed at the back of the list regardless of the position it was in when interrupted."
	
	"Primitive failure reasons:
		InvalidParameter1 -	the argument, frameOffset, is not a SmallInteger"

	"Be warned: This primitive method is not intended to be sent by user code it does not perform much error checking, and may cause the VM to terminate unexpectedly if the specified frameOffset is invalid."

	<primitive: 68>
	^self primitiveFailed: _failureCode!

isActiveMain
	"Answer whether or not the active process is the main GUI process."

	^activeProcess isMain!

isAtomic
	"Answer whether or not the receiver is the single unique instance of its class that can
	represents its value."

	"There can only be one ProcessorScheduler instance."

	^true!

kill: interruptArg 
	"Private - The active process has been sent a kill interrupt, terminate it without running
	its unwind blocks."

	self enableInterrupts.
	activeProcess kill!

killInterrupt
	"Private - Answer the interrupt number of the Kill interrupt. The kill interrupt is used to
	terminate a Process with extreme prejudice (i.e. without giving it a change to run its
	unwind blocks)."

	^9!

lowIOPriority
	"Answer the priority for normal I/O processes (e.g. keyboard/mouse input)."

	^8!

mainProcess
	"Private - Answer the current User Interface (Main) process"

	^self systemProcessOwner main!

noMemory: interruptArg 
	"Private - The VM was unable to allocate or commit some virtual memory. In some cases this
	is not fatal, and Dolphin can continue. In other cases the VM will have no choice but to
	call FatalAppExit()."

	self enableInterrupts.
	OutOfMemoryError signal!

onBreak: interruptArg
	"Private - A halt instruction was encountered.
	Note that async events are not re-enabled if the event is forwarded to a debugger."

	| debugger |
	debugger := activeProcess debugger.
	debugger isNil ifTrue: [self enableInterrupts] ifFalse: [debugger onBreak: interruptArg]!

onStartup: args 
	"Private - Interrupt sent by the VM after the image has been loaded. Interrupts are disabled.
	N.B. DO NOT REMOVE THIS METHOD OR YOUR SYSTEM WILL NOT START."

	"Any overlapped calls waiting for threads to terminate are wasting their time."

	pendingTerminations := Semaphore new.

	"Pass control to the SessionManager to start up as it wishes"
	SessionManager current onStartup: args!

otOverflow: anInteger
	"Private - The VM has allocated more memory for object headers. Inform the memory manager."

	MemoryManager current otOverflow: anInteger!

pendingTerminations
	^pendingTerminations!

primReturn: anObject callback: cookie 
	"Private - Return the <Object>, result, to the VM as the result of the callback identified by the <integer>, cookie, which the VM passed in when it originated the callback.
	Restore the current active process to the context it was executing before the callback occurred.

	Primitive failure codes:
		NoCallbackActive 	- the current active process is not in a callback
		Retry				- the callback identified by cookied was not the last
	
	Answer nil in the latter case so that #callbackReturn: keeps trying to exit (assuming no deadlock, it will eventually succeed when its turn comes). Where the process is attempting to return from a non-existant callback (perhaps the image was saved down with a process in the middle of a callback) then answer self so that the process continues, effectively ignoring the callback return request."

	<primitive: 104>
	^activeProcess isInCallback ifFalse: [self]!

primUnwindCallback: cookie 
	"Private - Unwind (i.e. abnormally terminate) the callback identified by the <integer>, cookie, The context is unaffected (i.e. we continue to run in our caller).
	Note that this is achieved by raising a Win32 structured exception, and therefore any intervening frame based unwind handlers will be run.
	The primitive answers self if it 'succeeds'.

	Primitive failure codes:
		NoCallbackActive 	- the current active process is not in a callback
		Retry				- the callback identified by cookied was not the current one. The callbacks must be completed in FIFO order.

	Answer nil in the latter case, so that the caller can put the active process to sleep to wait its turn. In the former case, answer self to ignore the unwind request and continue."

	<primitive: 107>
	^activeProcess isInCallback ifFalse: [self]!

primUnwindInterrupt
	"Private - Unwind (i.e. abnormally terminate) the most recent interrupt for the current active process, the context is unaffected (i.e. we continue to run in our caller).
	The primitive answers self if it 'succeeds'. The primitive does not fail."

	<primitive: 150>
	^self primitiveFailed: _failureCode!

processesAt: anInteger 
	"Answer the number of processes at the specified priority level."

	^(processLists at: anInteger) size!

returnValue: anObject toFrame: frameAddress 
	"Private - Return anObject to the active process'  frame at the specified 
	address (a SmallInteger - the actual address is frameAddress*2).
	The primitive does not fail.
	Be warned: This primitive method is not intended to be sent by user code
	it does not perform any error checking, and may cause the VM to
	terminate unexpectedly if the specified frameAddress is invalid."

	<primitive: 78>
	^self!

setHighestPriority: priority activeProcess: aProcess 
	"Private - Construct the process lists, and set the active process to aProcess.
	Used only during bootstrap to generate the singleton instance of the
	ProcessorScheduler class - Processor"

	processLists := (1 to: priority) collect: [:i | LinkedList new].
	activeProcess := aProcess.
	pendingReturns := Semaphore new!

sleep: anIntegerOrDuration
	"Delay the current active process for the specified <Duration>. For backwards compatibility also supports an <integer> argument specifying the delay in milliseconds."

	(Delay forDuration: (anIntegerOrDuration isInteger
				ifTrue: [anIntegerOrDuration milliseconds]
				ifFalse: [anIntegerOrDuration]))
		wait!

stackOverflow: interruptArg 
	"Private - The active process overflowed its maximum stack. This is most commonly caused by 
	failing to terminate a recursion. The default maximum stack should be sufficient for a 
	depth of several thousand message sends, but can be increased if necessary."

	self enableAsyncEvents: true.
	StackOverflow signal!

suspendActive
	"Suspend the currently active process. A suspended process is removed from consideration
	by the scheduler (it will not be waiting on any of the Processor's lists), and will not 
	therefore be able to run until it is #resume'd."

	activeProcess suspend!

systemBackgroundPriority
	"Answer the priority for background processes (idle time)"

	^2!

systemBasePriority
	"Answer the lowest possible priority."

	^1!

systemProcessOwner
	"Private - Answer the object responsible for maintaining the system processes (excluding
	those which belong to the memory manager."

	^SessionManager inputState!

terminate: interruptArg
	"Private - The current active process has been sent a terminate interrupt, terminate it."

	self enableAsyncEvents: true.
	self terminateActive!

terminateActive
	"Terminate the current active process"

	activeProcess terminate!

terminateInterrupt
	"Private - Answer the interrupt number of the Terminate interrupt. The terminate interrupt can be used
	to terminate a process gracefully, even if it is not the current active process."

	^1!

timingPriority
	"Answer the priority for timing process. This must be the highest possible priority."

	^10!

unregisterCOMStubs
	"Private - Unregister all COM object stubs."

	comStubs := nil!

unusedInterrupt: interruptArg
	"Private - The current active process has been sent an unknown interrupt, raise an error."

	self enableInterrupts.
	self error: ('Unknown interrupt with <1p>' expandMacrosWith: interruptArg)!

unwindCallback: cookie 
	"Private - Unwind (i.e. abnormally terminate) the most recent callback of the current
	active process, passing the VM back the <SmallInteger> cookie which it passed in as one
	of the arguments to the entry point through which it originally called in to Smalltalk.
	The primitive method answers nil if an attempt was made to unwind
	a callback out of synchronisation with other callbacks (i.e. another Process is handling
	a more recent callback and has not yet returned/unwound it). If this happens we put
	the current active process to sleep until the VM signals the pendingCallbacks Semaphore on 
	a successful callback return or unwind, at which point this process can make another
	attempt at unwinding the callback identified by the cookie."

	[(self primUnwindCallback: cookie) isNil] whileTrue: [pendingReturns wait]!

unwindCallbacks
	"Private - Unwind the outstanding callbacks in the active process. This
	lives in ProcessorScheduler rather than Process, because callback returns
	can only be made while a Process is active."

	[activeProcess isInCallback] whileTrue: [self unwindCallback: 0]!

userBackgroundPriority
	"Answer the priority for user background processes."

	^3!

userBreak: interruptArg 
	"Private - The user pressed the interrupt key combination (e.g. CTRL+BREAK) to interrupt the
	active process. Forward to the SessionManager as the response will depend on the application
	requirements."

	self enableInterrupts.
	SessionManager current onUserBreak!

userBreakInterrupt
	"Private - Answer the interrupt number of the CTRL+BREAK interrupt."

	^11!

userInterruptPriority
	"Answer the priority for high-priority user interaction processes, such
	as window management tasks of limited duration"

	^7!

userSchedulingPriority
	"Answer the priority for normal user interation"

	^5!

vmi: frameOffset list: suspendingList no: interruptNumber with: arg 
	"Private - The VM has delivered the <integer> interrupt, interruptNumber, which was queued
	with the <Object> argument, arg. At the time the interrupt occurred the process' active
	stack frame was at the <integer> offset, frameOffset, from the process base, and the
	process' suspendingList was the <Semaphore> suspendingList (nil if not waiting). N.B. The VM
	ensures that the current active process is the process for which the interrupt is intended,
	which may mean that a Semaphore wait is interrupted (this will be resumed on return from the
	interrupt, so there are no ill effects), or a suspended Process may be temporarily resumed.

	Implementation Notes:
	-	The frame is passed in as an offset, rather than a real address, because
		the process base address may not be the same on reloading a saved image, and it is possible
		to return from the interrupt in a subsequent session, e.g. when debugging a process.
	-	The VM ensures that the current active process is the process during
		whose execution the interrupt originally occurred, which may mean that a Semaphore wait 
		is interrupted (this will be resumed on return from the interrupt, so there are no side
		effects), or a suspended Process may be temporarily resumed.
	-	Async. process switches are disabled on entry to this method."

	[self perform: (InterruptSelectors basicAt: interruptNumber) with: arg] 
		ifCurtailed: [self primUnwindInterrupt].
	self iret: frameOffset list: suspendingList!

win32Fault: exceptionRecordBytes 
	"Private - The VM generated an unhandled Win32 Exception interrupt. The argument is the relevant 
	EXCEPTION_RECORD."

	| exceptionRecord |
	self enableInterrupts.
	exceptionRecord := EXCEPTION_RECORD fromBytes: exceptionRecordBytes.
	Win32Fault signalWith: exceptionRecord!

yield
	"Suspend the current active process, giving other processes at the same
	priority (and higher priorities of course?) a chance to run. If there are no
	other processes at the same, or higher, priority then the active process
	continues running.
	The primitive does not fail, and is much faster than the alternative
	of prodding a higher priority process to cause a rescheduling
	to occur (e.g. the timing process)."

	<primitive: 156>
	self sleep: 0

	"Sleeping, for whatever duration, yields the processor."!

zeroDivide: interruptArg 
	"Private - The VM generated a Integer Divide by Zero interrupt. This will happen if any attempt is
	made to divide by zero, either in the execution of Dolphin code, in a Dolphin primitive, OR in
	an external library function."

	self enableInterrupts.
	ZeroDivide dividend: interruptArg! !
!ProcessorScheduler categoriesFor: #activePriority!processes-accessing!public! !
!ProcessorScheduler categoriesFor: #activeProcess!debugger-step over!processes-accessing!public! !
!ProcessorScheduler categoriesFor: #bereavedOverflow:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #callback:evaluate:!callbacks!not restartable!private!vm entry points! !
!ProcessorScheduler categoriesFor: #callback:perform:cookie:!callbacks!not restartable!private!vm entry points! !
!ProcessorScheduler categoriesFor: #callback:perform:with:cookie:!callbacks!not restartable!private!vm entry points! !
!ProcessorScheduler categoriesFor: #callback:perform:with:with:cookie:!callbacks!not restartable!private!vm entry points! !
!ProcessorScheduler categoriesFor: #callback:perform:with:with:with:cookie:!callbacks!not restartable!private!vm entry points! !
!ProcessorScheduler categoriesFor: #callback:perform:withArguments:cookie:!callbacks!not restartable!private!vm entry points! !
!ProcessorScheduler categoriesFor: #callback:return:!callbacks!private! !
!ProcessorScheduler categoriesFor: #callback:withArgumentsAt:cookie:!callbacks!not restartable!private!vm entry points! !
!ProcessorScheduler categoriesFor: #cannotReturn:!exceptions!not restartable!private! !
!ProcessorScheduler categoriesFor: #constWrite:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #constWriteSignal!accessing!private! !
!ProcessorScheduler categoriesFor: #crtFault:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #enableAsyncEvents:!interrupts-status!private! !
!ProcessorScheduler categoriesFor: #enableInterrupts!interrupts-status!private! !
!ProcessorScheduler categoriesFor: #forkMain!private!processes-accessing! !
!ProcessorScheduler categoriesFor: #forkMainIfMain!private!processes-accessing! !
!ProcessorScheduler categoriesFor: #fpException:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #fpStackFault:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #genericInterrupt!interrupts-names!private! !
!ProcessorScheduler categoriesFor: #gpFault:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #highestPriority!processes-accessing!public! !
!ProcessorScheduler categoriesFor: #highIOPriority!priority names!public! !
!ProcessorScheduler categoriesFor: #hospiceOverflow:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #idlePanic:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #idleProcess!private!processes-accessing! !
!ProcessorScheduler categoriesFor: #interruptWith:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #iret:list:!interrupts!private! !
!ProcessorScheduler categoriesFor: #isActiveMain!public!testing! !
!ProcessorScheduler categoriesFor: #isAtomic!public!testing! !
!ProcessorScheduler categoriesFor: #kill:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #killInterrupt!interrupts-names!private! !
!ProcessorScheduler categoriesFor: #lowIOPriority!priority names!public! !
!ProcessorScheduler categoriesFor: #mainProcess!private!processes-accessing! !
!ProcessorScheduler categoriesFor: #noMemory:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #onBreak:!development!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #onStartup:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #otOverflow:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #pendingTerminations!accessing!private! !
!ProcessorScheduler categoriesFor: #primReturn:callback:!callbacks!private! !
!ProcessorScheduler categoriesFor: #primUnwindCallback:!callbacks!private! !
!ProcessorScheduler categoriesFor: #primUnwindInterrupt!interrupts!private! !
!ProcessorScheduler categoriesFor: #processesAt:!processes-accessing!public! !
!ProcessorScheduler categoriesFor: #returnValue:toFrame:!callbacks!must not strip!private! !
!ProcessorScheduler categoriesFor: #setHighestPriority:activeProcess:!development!initializing!private! !
!ProcessorScheduler categoriesFor: #sleep:!processes-synchronising!public! !
!ProcessorScheduler categoriesFor: #stackOverflow:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #suspendActive!processes-changing state!public! !
!ProcessorScheduler categoriesFor: #systemBackgroundPriority!priority names!public! !
!ProcessorScheduler categoriesFor: #systemBasePriority!priority names!public! !
!ProcessorScheduler categoriesFor: #systemProcessOwner!accessing!private! !
!ProcessorScheduler categoriesFor: #terminate:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #terminateActive!processes-changing state!public! !
!ProcessorScheduler categoriesFor: #terminateInterrupt!interrupts-names!private! !
!ProcessorScheduler categoriesFor: #timingPriority!priority names!public! !
!ProcessorScheduler categoriesFor: #unregisterCOMStubs!callbacks!initializing!private! !
!ProcessorScheduler categoriesFor: #unusedInterrupt:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #unwindCallback:!callbacks!private! !
!ProcessorScheduler categoriesFor: #unwindCallbacks!callbacks!private! !
!ProcessorScheduler categoriesFor: #userBackgroundPriority!priority names!public! !
!ProcessorScheduler categoriesFor: #userBreak:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #userBreakInterrupt!interrupts-names!private! !
!ProcessorScheduler categoriesFor: #userInterruptPriority!priority names!public! !
!ProcessorScheduler categoriesFor: #userSchedulingPriority!priority names!public! !
!ProcessorScheduler categoriesFor: #vmi:list:no:with:!interrupts!interrupts-handling!must not strip!not restartable!private! !
!ProcessorScheduler categoriesFor: #win32Fault:!interrupts-handling!private! !
!ProcessorScheduler categoriesFor: #yield!processes-changing state!public! !
!ProcessorScheduler categoriesFor: #zeroDivide:!interrupts-handling!private! !

!ProcessorScheduler class methodsFor!

initialize
	"Initialize the receiver's class variables:
		ProcessorScheduler initialize
	"

	ConstWriteSignal := Signal description: 'Attempt to update read-only object'.
	self initializeInterruptSelectors!

initializeInterruptSelectors
	"Private - Initialize the mapping between VM interrupt numbers and the corresponding messages sent to self when those interrupts arrive.
	Note that we have to store a copy of the literal array (which is marked immutable by the compiler) because the debugger adds/removes
	some interrupt selectors when it is installed/uninstalled."

	InterruptSelectors := #(#terminate: #stackOverflow: #onBreak: #unusedInterrupt: #gpFault: #idlePanic: #interruptWith: #onStartup: #kill: #fpException: #userBreak: #zeroDivide: #otOverflow: #constWrite: #win32Fault: #fpStackFault: #noMemory: #hospiceOverflow: #bereavedOverflow: #crtFault:) 
				copy!

interruptSelectors
	^InterruptSelectors!

new
	"There can be only one scheduler, and it is stored in the global variable Processor (which
	must not be reassigned!!)."

	^self shouldNotImplement!

newPriorities: highestPriority activeProcess: aProcess 
	"Private - Create Processor during boot."

	^self basicNew setHighestPriority: highestPriority activeProcess: aProcess! !
!ProcessorScheduler class categoriesFor: #initialize!development!initializing!public! !
!ProcessorScheduler class categoriesFor: #initializeInterruptSelectors!initializing!must not strip!private! !
!ProcessorScheduler class categoriesFor: #interruptSelectors!accessing!private! !
!ProcessorScheduler class categoriesFor: #new!instance creation!public! !
!ProcessorScheduler class categoriesFor: #newPriorities:activeProcess:!development!instance creation!private! !

