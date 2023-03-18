"Filed out from Dolphin Smalltalk"!

Core.Link
	variableSubclass: #'Core.Process'
	instanceVariableNames: 'suspendedFrame priority myList callbackDepth tls _unused7 fpControl threadSync thread exceptionEnvironment _unused12 newWindow debugger name debugStream'
	classVariableNames: 'DefaultMaxStack'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'DefaultFpControl' -> 16r80007. 'DefaultStack' -> 16r1 }!
Core.Process guid: (Core.GUID fromString: '{87b4c64e-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Process comment: 'A Process represents an individual thread of execution in the image.

Note that the name "Process" is historic - a Smalltalk Process is much more similar to a "thread" than a true process, since all Processes share the same execution context (the image). Dolphin''s processes do not map directly onto native threads, but are "green" threads. The multi-threading system is implemented internally by the VM and image, with all "green" threads running within a single Win32 thread. This means that a call to a long running (or blocking) external API call will block the entire system, so a facility is provided to "overlap" such calls. This is done by marking the external method with the "overlap" annotation, in which case the VM will perform the call on a separate native thread. For the duration of the overlapped operation the calling Process is blocked, but other Processes in the image will continue to run. 

A Process can in any of the following states:
	- active		The Process is actually running. Usually you will only be able to catch the main UI process in this state.
	- debug		The Process is currently being debugged.
	- ready		The Process is ready to run, but currently suspended on one of the Processors priority queues.
	- suspended	The Process has been suspended (see #suspend), and will not run again until sent #resume.
				Note that a suspended process with no active references will be garbage collected.
	- waiting	The Process is waiting on a <Semaphore>, i.e. it has sent #wait to a Semaphore with no excess signals.
				A Process remains waiting on a Semaphore until it reaches the front of that Semaphores queue of
				waiting Processes and the Semaphore is sent a #signal message.
	- dead		The Process has been terminated, or has run to completion.

A Process in any state other than #dead is considered alertable, and may be sent an interrupt by the VM at any time. See<ProcessorScheduler> for more details.

In general it is not a good idea to manipulate the contents of a live process directly (e.g. in an Inspector). For performance reasons the VM tends to assume that a Process'' state is consistent, and it does not perform much error checking. Hence it is quite easy to crash the system by modification of instance variables and the stack. It is quite safe to view the contents, but if a live Process is inspected you may find that the snapshot is invalidated by the stack growing and shrinking to meet requirements, which could cause errors in the inspector when trying to access non-existant stack slots.

Instance Variables:
	suspendedFrame 		<Integer> address of suspendedFrame when in states ready, waiting, or suspended, otherwise nil.
	priority 				<Integer> priority level (see ProcessorScheduler).
	myList 				<LinkedList> on which the process is currently queued if in states ready or waiting, otherwise nil.
	callbackDepth 			<Integer> number of callbacks which have not yet been returned from (i.e. nested depth).
	primitiveFailureCode		<Integer> code reported by last primitive failure.
	primitiveFailureData 		<Object> argument supplied by last primitive failure. Value depends on primitive and failure reason.
	fpControl 				<Integer> floating point control flags. See Intel/CRT docs.
	threadSync			<Semaphore> used for overlapped call synchronisationby the VM.
	thread 				Pointer to overlapped call control block. For VM use only.
	exceptionEnvironment	List of active exception frames <ExceptionHandler> in LIFO order.
	_alreadyPrinted			<IdentitySet> of objects which have already printed in a recursive #printOn:
	_reserved1			Reserved for future use.
	debugger 				<debugEventHandler> associated with the Process, if any. Used as a destination for debug events.
	name 				The <Object> ''name'' of the process. Usually a <String> or <CompiledMethod>.
	_reserved2			Reserved for future use.

Class Variables:
	DefaultFpControl		<Integer> default floating point control flags to initialize fpControl instance variable.
	DefaultMaxStack 		<Integer> maximum stack depth (size up to which a Process may grow - virtual memory reserved).
	DefaultStack			<Integer> initial stack depth (initial virtual memory committed).'!
!Core.Process categoriesForClass!Kernel-Processes! !
!Core.Process methodsFor!

at: anInteger ifAbsent: exceptionBlock 
	"Answer an <Object> which is the element of the receiver 
	at the specified <SmallInteger> index. If the index is out of bounds 
	answer the result of evaluating the <niladicValuable> exceptionBlock."

	^(anInteger > 0 and: [anInteger <= self size]) 
		ifTrue: [self at: anInteger]
		ifFalse: [exceptionBlock value]!

at: anInteger put: anObject
	"Replace the receiver's indexed instance variable at the argument, index, with the argument, value. Answer value."

	"Primitive Failure Reasons:
		InvalidParameter1	- index is not a SmallInteger
		OutOfBounds		- index out of bounds (not in the range 1..receiver's indexable size)"

	<primitive: 176>
	^self
		_primitiveError: _failureCode
		at: anInteger
		put: anObject!

basicAt: anInteger put: anObject
	"Private - Replace the receiver's indexed instance variable at the argument, index, with the argument, value. Answer value.
	MUST not be reimplemented (except by classes whose instances have special representations such as SmallInteger)."

	"Primitive Failure Reasons:
		InvalidParameter1	- index is not a SmallInteger
		OutOfBounds		- index out of bounds (not in the range 1..receiver's indexable size)"

	<primitive: 176>
	^self
		_primitiveError: _failureCode
		at: anInteger
		put: anObject!

basicSuspendedFrame
	"Private - Answer the SmallInteger pointer into the stack of the suspended frame. If nil then
	the process has terminated (or is not yet initialized)."

	^suspendedFrame!

callbackDepth
	"Private - Answer the depth of outstanding callbacks from the VM in the receiver's stack.
	An example of a callback is an entry from the Smalltalk window procedure to
	View>>dispatchMessage:. Recursive callbacks (callbacks which occur during the
	processing of another callback, e.g. sending a Win32 message in the handler for
	another Win32 message) will increase the callback depth to a figure greater than one.
	The Main (user interface) process will always have a callback depth >= 1 when
	examined.

	Whether a Process' stack contains callbacks affects the way it must be unwound
	on termination, or when handling an exception, since the callbacks from the 
	VM must themselves be properly unwound, not just the Smalltalk stack."

	^callbackDepth!

canDebug
	"Answer whether the receiver can be debugged (this requires that a debugger
	be available)."

	^self respondsTo: #debuggerClass!

debugger
	"Private - Answer the object which is currently claiming to be the 'debugger' on this
	process. This object will receiver debug events as and when they occur in the receiver
	(it need not be an actual <Debugger>). The answer will be nil if there is no debugger."

	^debugger!

debugger: anObject
	"Private - anObject is claiming to be the debugger for the receiver, so save it so
	that it can later be sent debug events which occur in the receiver. Any 
	existing debugger is disconnected."

	debugger := anObject!

debugStream
	"Answer a <DebugTraceStream> for this Process. Note that although the stream itself is unique to the process, and so output to its buffer will not intermingle with trace output from other processes, the OS debug output stream is a shared resource. To avoid output becoming intermingled, it is advisable not to flush data between newlines."

	^debugStream
		ifNil: 
			[debugStream := #{Kernel.DebugTraceStream} valueOrNil ifNotNil: [:dts | dts new] ifNil: [DeafObject current]]!

errno
	"Answer the value of the C runtime 'errno' global variable saved on completion of the last
	overlapped call made from the receiver."

	^OS.CRTLibrary nonblocking errno!

exceptionEnvironment
	"Private - Answer the receiver's exception environment (a LIFO stack of ExceptionHandlers).
	A linked list of ExceptionHandlers is maintained to expedite the search for handlers 
	when an exception occurs."

	^exceptionEnvironment!

exceptionEnvironment: anExceptionHandler
	"Private - Set the receiver's exception environment to be the argument,
	anExceptionHandler. N.B. Use with care, the previous exception environment
	should be linked to the new exception environment."

	exceptionEnvironment := anExceptionHandler!

finalize
	"Private - Ensure the receiver is properly terminated.
	This method should only be invoked if the process dies because there
	are no outstanding references to it. If normally terminated, then
	it will not be finalized."

	self terminate!

fpControl
	"Answer the current floating point control word for the receiver. This is an <integer>
	combination of flags from the CRT FP control word enumerations:
		_DN_xxx	- Denormal control (mask _MCW_DN)
		_EM_xxx 	- Exception masking (mask _MCW_EM)
		_IC_xxx	- Infinity control (mask _MCW_IC)set
		_PC_xxx	- Precision control (mask _MCW_PC)
		_RC_xxx	- Rounding control (mask _MCW_RC)
	See the CRT documentation on MSDN for further details."

	^fpControl!

fpControl: anInteger
	fpControl := anInteger!

frameAtAddress: spInteger
	"Private - Answer a frame representing the real stack frame at the specified SP (a
	SmallInteger address/2 in the receiver), or nil if the address is not within this process."

	^self frameAtIndex: (self indexOfSP: spInteger)!

frameAtIndex: anInteger
	"Private - Answer a StackFrame represent a real frame in the receiver at the specified index,
	or nil if the index is out of bounds."

	^self frameClass process: self index: anInteger!

frameClass
	"Private - Answer the class of object to use to represent the receiver's activation records"

	^StackFrame!

id
	"Answer an id which is unique for the lifetime of the process within
	this particular session. Should the process be terminated in the session
	then the id may be re-used, i.e. this is really only useful to help with debugging."

	^self yourAddress bitShift: -16!

indexOfSP: anInteger
	"Private - Answer the index into the receiver of the VM stack pointer value, anInteger (which is a pointer, bitshifted right one position, although this is an implementation
	detail which may be changed)."

	<primitive: 175>
	^((anInteger bitShift: -1) - (self yourAddress bitShift: -2)) - self class instSize + 1!

interruptWith: aBlock
	"Private - Interrupt the receiver with the specified block. The block is evaluated regardless of
	the receiver's current state (unless dead). On completion of the block, the receiver resumes whatever
	it was doing before, including waiting on a Semaphore, etc."

	"Implementation Note: aBlock is evaluated with asynchronous process switching disabled!!"

	^self queueInterrupt: Processor genericInterrupt with: aBlock!

isActive
	"Answer whether the receiver is the current active process."

	^Processor activeProcess == self
	
	!

isAlive
	"Answer whether the receiver is either ready, waiting, or active."

	^self isActive or: [self suspendingList notNil]	!

isAlive: aSemaphore 
	"Private - Answer whether the receiver is either ready, waiting on the specified 
	Semaphore, or active."

	| state |
	state := self state.
	^state == #ready 
		or: [state == #running or: [state == #waiting and: [self suspendingList == aSemaphore]]]!

isDead
	^suspendedFrame isNil!

isDebuggee
	"Private - Answer whether the receiver is currently being debugged."

	^debugger notNil!

isInCallback
	"Private - Answer whether the receiver is processing a callback from the VM.

	Whether a Process' stack contains callbacks affects the way it must be unwound
	on termination, or when handling an exception, since the callbacks from the 
	VM must themselves be properly unwound (and in the same order in which they
	were made), not just the Smalltalk stack."

	^self callbackDepth > 0!

isMain
	"Answer whether the receiver is the main user I/F process (i.e. it
	manages the input queue)."

	^SessionManager.Current inputState main == self!

isReady
	"Answer whether the receiver is Ready to run but inactive"

	^self state == #ready	!

isSuspended
	"Answer whether the receiver is Suspended/Terminated."

	^self state == #suspended
	
	!

isTerminated
	"Answer whether the receiver has Terminated."

	^self state == #dead
	
	!

isWaiting
	"Answer whether the receiver is waiting on a Semaphore."

	^self state == #waiting	!

kill
	"Terminate the receiver with extreme prejudice. Any outstanding unwind blocks
	will not be run. It is necessary, however, to correctly maintain the VM's callback stack,
	so all outstanding callbacks are unwound. Finally, the receiver is put to sleep, permanently.
	N.B. This should not be sent to a process which is not the active process if it has callbacks."

	self isDead ifTrue: [^self].
	self isActive 
		ifTrue: [self shutdown]
		ifFalse: 
			["As the receiver is not active, we queue an interrupt which will
				cause the VM to activate the receiver (even if Waiting or Suspended)."

			self queueInterrupt: Processor killInterrupt]!

lastError
	"Answer the value of the Win32 error code (i.e. the result of GetLastError()) run in the
	context of the overlapped external call thread associated with the receiver."

	^OS.Kernel32 threadGetLastError!

name
	"Answer the 'name' of the Process. This is usually defined by the creator of the process.
	The default name is the home method (which allows access to the source of the forking block, 
	even for immediate expressions). The name need not be a String (all Objects respond to #displayString)"

	^name!

name: anObject
	"Set the name of the Process to the argument, anObject (see #name)"

	name := anObject!

newWindow
	^newWindow!

newWindow: aWindow
	newWindow := aWindow!

primTerminate
	"Private - Transition the receiver from its current state to the Terminated state. Once terminated, a Process cannot (easily) be resumed or restarted."

	"Primitive Failure Reasons:

		AlreadyComplete	- The process is suspended (processes can only be terminated from within their own running context)
		ThreadIsTerminating	- The process is already on the pending terminations list (i.e. waiting for its associated OS thread to terminate)
		Retry				- The receiver is the last running process, so it cannot be terminated until another process has been started (an Idle Panic interrupt will also be generated). Assuming correct recovery after the idle panic, a second attempt at termination should succeed."

	"Implementation Note: This primitive is approximately equivalent to:

		self suspendUnconditionally. 
		suspendedFrame := nil

	except that the primitive can correctly terminate any process, even the active process. The
	active process cannot terminate itself correctly in this way in Smalltalk without the
	assistance of another process, because as soon as it suspends itself, it will obviously stop
	running, and so will be unable to nil out its suspended context. It is considered that the
	use of a simple primitive to terminate processes is both less error prone, and consumes less
	resources, than the alternative of dedicating another process to this task."

	<primitive: 91>
	^_failureCode == _PrimitiveFailureCode.ThreadIsTerminating or: 
			[_failureCode == _PrimitiveFailureCode.Retry
				ifTrue: [false	"Please try again"]
				ifFalse: [self primitiveFailed: _failureCode]]!

printOn: aStream
	"Append a short debug description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self name;
		nextPutAll: ', id: ';
		print: self id;
		nextPutAll: ', priority: ';
		print: self priority;
		nextPutAll: ', state: ';
		print: self state;
		nextPut: $)!

priority
	"Answer the receiver's priority (see ProcessorScheduler)"

	^priority
!

priority: anInteger
	"Set the receiver's priority to anInteger and Answer the previous priority. Note that 
	if the receiver is the currently active process, the new priority is lower, and there 
	are higher-priority processes ready to run, the active process will be preempted.
	If the receiver is not the active process, and its priority is increased above that of
	the active process, then the active process will be preempted.

	Primitive failure reasons:
		InvalidParameter1 -	anInteger is not a SmallInteger.
		IntegerOutOfRange -	anInteger is not in the range of permissible priorities (1..highest priority)."

	<primitive: 92>
	^(_failureCode == _PrimitiveFailureCode.InvalidParameter1
		or: [_failureCode == _PrimitiveFailureCode.IntegerOutOfRange])
			ifTrue: [self error: ('Invalid Process priority <1p>' expandMacrosWith: anInteger)]
			ifFalse: [self primitiveFailed: _failureCode]!

queueInterrupt: anInteger
	"Queue an interrupt with the specified number for the receiver (which can be in any resumable state)
	and a nil argument."

	^self queueInterrupt: anInteger with: nil!

queueInterrupt: anInteger with: anObject
	"Queue an interrupt with the specified number for the receiver (which can be in any resumable state).
	The argument is passed to the interrupted process and can be of any type as necessary.

	Primitive failure reasons:
		InvalidParameter1 	- anInteger is not a SmallInteger.
		IllegalStateChange	- the receiver is dead (i.e. not runnable)."

	<primitive: 98>
	^self primitiveFailed: _failureCode!

resetFloatingPoint
	OS.Ucrt
		_clearfp;
		_control87: fpControl
			mask: ##(OS.CRTConstants._MCW_DN | OS.CRTConstants._MCW_EM | OS.CRTConstants._MCW_IC
					| OS.CRTConstants._MCW_PC | OS.CRTConstants._MCW_RC)!

resume
	"Change the state of the receiver from Suspended to Ready (by placing it at the end of the Processor's queue for the receiver's priority). Fail if the receiver is already waiting in a queue (in a Semaphore or the Processor). See #resume: for further details (sending this message is equivalent to sending #resume: with nil as the argument)."

	<primitive: 87>
	^self primitiveFailed: _failureCode!

resume: suspendingListOrNil
	"Change the state of the receiver from Suspended to Ready/Waiting by placing it at the end of the Processor's queue for the receiver's priority if suspendingListOrNil is nil, otherwise returning it to the queue associated with suspendingListOrNil. Fail if the receiver is already waiting in a queue (in a Semaphore or the Processor) - i.e. it is only appropriate to send this message to previously #suspend'd Processes, it is not the means by which to start currently Waiting or Ready processes (which have to wait either for the Semaphore on which they are Waiting to be signalled, or their turn to run after higher priority processes, and in a round robin fashion with respect to Processes of the same priority if they are Ready to run)."

	"Primitive failure reasons:
		IllegalStateChange 	- the receiver is not suspended on a scheduler or semaphore list.
		AssertionFailure		- the receiver has been terminated (or not properly initialized)."

	<primitive: 87>
	^self primitiveFailed: _failureCode!

resumeUnconditionally
	"Change the state of the receiver to Ready to run regardless of its current state (unless terminated)."

	<primitive: 87>
	myList isNil ifTrue: [^self primitiveFailed: _failureCode]!

setFpControl: flagsInteger mask: maskInteger
	"Set the current floating point control word for the receiver. If the receiver is the
	current active process, then the processor control word is updated. Once set the VM will
	maintain isolated fp state for each Process. The mask should be one or more of:
		_MCW_DN	- Denormal control (flags _DN_xxx)
		_MCW_EM	- Exception masking (flags _EM_xxx)
		_MCW_IC	- Infinity control (flags _IC_xxx)
		_MCW_PC	- Precision control (flags _PC_xxx)
		_MCW_RC	- Rounding control (mask _RC_xxx)

	Note that you can unmask some FP exceptions that are masked by default such as _EM_DENORMAL
	and _EM_INEXACT, it is unwise to do so for anything other than short well tested blocks of code as 
	this may cause any Floating point code in external libraries that is not written to expect these 
	exceptions (e.g. in Windows controls) to fail in unexpected ways. Unmasking _EM_INEXACT, in
	particular, will quickly kill a development image."

	| current |
	current := fpControl.
	fpControl := (current bitAnd: maskInteger bitInvert) bitOr: (flagsInteger bitAnd: maskInteger).
	self isActive
		ifTrue: 
			["Set it whether or not it is different from the current control value as some external code could have changed it."
			self resetFloatingPoint].
	^current!

setLaunchBlock: aBlockClosure
	"Private - Initialize the receiver and install aBlockClosure as the launch frame of the
	receiver (which must be a new process). The VM needs a correctly established frame in order
	to start running a process."

	| baseFrame |
	callbackDepth := priority := 0.
	fpControl := Processor activeProcess fpControl ?? DefaultFpControl.
	self beFinalizable.
	self at: 1 put: aBlockClosure receiver.
	"Note that we must allow space for the block's stack temps"
	baseFrame := self frameClass new setProcess: self index: 2 + aBlockClosure localCount.
	baseFrame
		basicSender: 0;
		basicIP: aBlockClosure initialIP + VMConstants.ObjectHeaderSize - 1;
		sp: baseFrame frameSize + 1;
		method: aBlockClosure method;
		environment: aBlockClosure.
	baseFrame bp: 2.
	self suspendedFrame: baseFrame!

setPriority: anInteger 
	priority := anInteger!

shutdown
	"Private - Terminate the receiver with extreme prejudice. Any outstanding unwind blocks
	will not be run. It is necessary, however, to correctly maintain the VM's callback stack,
	so all outstanding callbacks ARE unwound. Finally, the receiver is put to sleep, permanently.
	N.B. This should not be sent to a process which is not the active process if it has callbacks.
	Sending this method directly is not recommended (send either #kill or #terminate instead)."

	"Inform any debugger so that it can close.
	You will not be able to debug past this point."
	debugger notNil ifTrue: [debugger perform: #onTerminate].

	"Unwind any outstanding callbacks."
	Processor unwindCallbacks.
	self beUnfinalizable.
	[self primTerminate == true] whileFalse!

size
	"Answer the number of indexed variables in the receiver (0 for non-indexable objects,
	as the named instance variables are not included)."

	"Implementation Note: Access thisContext to get the process size saved down as the
	processes dynamically change size to accommodate their stack. Normally the process
	size is only recorded from the SP on process switches, when thisContext is accessed,
	on GC's, on invocations of the #allReferences primitive, and on image save."

	thisContext.
	^super size!

spOfIndex: anInteger
	"Private - Answer a VM stack pointer value (SmallInteger) for the specified index of the
	receiver."

	| sp |
	sp := (self yourAddress bitShift: -1) + ((anInteger + self class instSize - 1) * 2).
	"The result must always be a SmallInteger, or the VM will not interpret the stack pointer correctly and may crash,
	this means the SP value can be negative when interpreted as a signed value"
	^(16r40000000 + sp bitAnd: 16r7FFFFFFF) + -16r40000000!

stackTrace: anInteger
	"Private - Answer a <readableString> containing a stack trace to the depth specified by the <integer> argument.
	The frame for this method is excluded so that the top frame is the caller."

	^self topFrame sender stackTrace: anInteger!

state
	"Private - Answer a symbol identifying the receiver's state."

	^self isActive
		ifTrue: [#running]
		ifFalse: 
			[| list |
			"The state may change, so minimize chance of getting
			it wrong by storing suspendingList in a temporary"
			list := self suspendingList.
			list isNil
				ifTrue: 
					[self isDebuggee
						ifTrue: [#debug]
						ifFalse: [self basicSuspendedFrame isNil ifTrue: [#dead] ifFalse: [#suspended]]]
				ifFalse: [(list isKindOf: Semaphore) ifTrue: [#waiting] ifFalse: [#ready]]]!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler. 
	Processes cannot be saved and restored correctly so output them as 
	nil by default"

	anSTBOutFiler saveObject: self as: nil.!

suspend
	"Transition the receiver from Running (if active), Waiting (if waiting on a Semaphore) or Ready (if waiting to be scheduled by the Processor) states to the Suspended state (i.e. not runnable). If the receiver is the activeProcess, suspend it and schedule another,  otherwise remove the receiver from the list of Ready processes in the Processor, or the  list of Waiting processes in a Semaphore, and nil out its suspending list backpointer. The receiver may be transitioned back to the Ready state at any time by sending it #resume (but remember that resuming a Process that was waiting on a Semaphore when it was suspended may upset process synchronisation because it will not return to the Semaphores waiting list).
	Report an error if the receiver is already Suspended (which is recognised by a null backpointer, as this indicates that the process is not waiting in a list).

	Suspended processes have a 'nil' suspending list, are not the active process, and have a non-zero suspendedFrame address (which distinguishes them from terminated processes). If the process is the last runnable process, then answer false, otherwise answer the receiver (when resumed)."

	"Primitive failure results:
		AlreadyComplete	- the process is already suspended.
		Retry				- the process is the active process and could not be suspended because it is the only runnable process remaining.
		ThreadIsTerminating	- the process is pending termination"

	<primitive: 88>
	^_failureCode == _PrimitiveFailureCode.Retry
		ifTrue: [false]
		ifFalse: [self primitiveFailed: _failureCode]!

suspendedFrame
	"Private - Answer a stack frame for the receiver's suspended context, nil if the receiver is dead."

	| frameAddress |
	frameAddress := self basicSuspendedFrame.
	^frameAddress isNil ifFalse: [self frameAtAddress: frameAddress]!

suspendedFrame: aStackFrameOrIndex
	"Private - Set the suspended frame index of the receiver."

	suspendedFrame := self spOfIndex: aStackFrameOrIndex asInteger!

suspendingList
	"Private - Answer the list (semaphore or Processor queue) on which the receiver has been 
	suspended. A Process which has been suspended, or which is currently active,
	will answer nil."

	^myList!

suspendUnconditionally
	"As #suspend, but fails silently attempts at suspending processes which are already Suspended.
	Answers the receiver.

	Primitive failure results:
		Completed			- the process is already suspended.
		Retry				- the process is the active process and could not be suspended because it is the only runnable process remaining.
		ThreadIsTerminating	- the process is pending termination

	The Completed and Retry failure codes are ignored. Any other failure code is unexpected, and will result in an exception being raised."

	<primitive: 88>
	^_failureCode == _PrimitiveFailureCode.Retry
		ifTrue: [false]
		ifFalse: [_failureCode == _PrimitiveFailureCode.Completed ifTrue: [self] ifFalse: [self primitiveFailed: _failureCode]]!

terminate
	"Transition the receiver from its current state to the Terminated state. Once Terminated, 
	a Process cannot be resumed or restarted.

	Implementation note: In order to ensure that all unwind blocks (see BlockClosure>>andFinally:
	and BlockClosure>>ifCurtailed:) are run, termination is achieved by raising a ProcessTermination 
	exception which is caught and handled by the launch block of the receiver (see 
	BlockClosure>>newProcess). The launch block handler for ProcessTermination #return:'s, dropping
	all later stack frames, and thus causing any unwind blocks to be executed. As its last action the launch
	block sends #shutdown message to the Process for final cleanup."

	self isDead ifTrue: [^self].
	self isActive
		ifTrue: 
			[ProcessTermination signalWith: self.
			"Won't get this far unless the process hasn't completed its initialization,
			 and established a based handler block for the ProcessTermination signal."
			self shutdown]
		ifFalse: 
			["Exceptions can only be raised in active processes (and a process must be active
			 to terminate itself), so as the receiver is not active, we must queue an interrupt 
			 which will cause the VM to activate the receiver (even if Waiting or Suspended)."
			self queueInterrupt: Processor terminateInterrupt]!

threadSync
	^threadSync!

threadVarAt: aSymbol
	^tls ifNotNil: [tls lookup: aSymbol]!

threadVarAt: aSymbol put: anObject
	^(tls ifNil: [tls := IdentityDictionary new]) at: aSymbol put: anObject!

topFrame
	"Private - Answer a frame representing the top activation record of the receiver's stack.
	We deliberately answer a frame for the sender if the receiver is the active
	process, as the current context will be invalidated immediately this method
	returns. Of course that frame will also be invalidated should the sender
	subsequently return too."

	^self isActive 
		ifTrue: [(self frameAtAddress: thisContext) sender]
		ifFalse: [self suspendedFrame]! !
!Core.Process categoriesForMethods!
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
basicAt:put:!accessing!private! !
basicSuspendedFrame!private!stack frames! !
callbackDepth!accessing!private! !
canDebug!development!public!testing! !
debugger!accessing!development!private! !
debugger:!accessing!development!private! !
debugStream!accessing!public! !
errno!accessing!public! !
exceptionEnvironment!accessing!debugger-step over!public! !
exceptionEnvironment:!accessing!debugger-step over!private! !
finalize!finalizing!private! !
fpControl!accessing!public! !
fpControl:!accessing!private! !
frameAtAddress:!private!stack frames! !
frameAtIndex:!private!stack frames! !
frameClass!private!stack frames! !
id!accessing!public! !
indexOfSP:!private!stack frames! !
interruptWith:!interrupts!private! !
isActive!public!states-testing! !
isAlive!public!states-testing! !
isAlive:!private!states-testing! !
isDead!public!states-testing! !
isDebuggee!private!states-testing! !
isInCallback!private!testing! !
isMain!public!testing! !
isReady!public!states-testing! !
isSuspended!public!states-testing! !
isTerminated!public!states-testing! !
isWaiting!public!states-testing! !
kill!public!states-changing! !
lastError!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
newWindow!accessing!public! !
newWindow:!accessing!public! !
primTerminate!private!states-changing! !
printOn:!printing!public! !
priority!accessing!public! !
priority:!accessing!public! !
queueInterrupt:!interrupts!public! !
queueInterrupt:with:!interrupts!public! !
resetFloatingPoint!helpers!private! !
resume!public!states-changing! !
resume:!public!states-changing! !
resumeUnconditionally!public!states-changing! !
setFpControl:mask:!accessing!public! !
setLaunchBlock:!initializing!private! !
setPriority:!accessing!private! !
shutdown!private!states-changing! !
size!accessing!public! !
spOfIndex:!private!stack frames! !
stackTrace:!helpers!private! !
state!private!states-changing! !
stbSaveOn:!binary filing!public! !
suspend!public!states-changing! !
suspendedFrame!private!stack frames! !
suspendedFrame:!private!stack frames! !
suspendingList!accessing!private! !
suspendUnconditionally!public!states-changing! !
terminate!public!states-changing! !
threadSync!accessing!private! !
threadVarAt:!accessing!public! !
threadVarAt:put:!accessing!public! !
topFrame!private!stack frames! !
!

!Core.Process class methodsFor!

forContext: aBlockClosure priority: priorityInteger maxStack: slotsInteger
	"Private - Answer a suspended instance of the receiver that will execute the block,
	aBlockClosure, at the priority, anInteger, reserving slotsInteger as the maximum stack size.
	N.B. There are certain requirements which must be met by the launch block, aBlockClosure,
	if the new process is to die quietly without causing a GPF:
		1) It must be a zero argument BlockClosure (not just any old niladic valuable)
		2) It must have a null home stack frame (i.e. its home context is marked as having
		already returned).
		3) It must catch ProcessTermination notifications, and proceed through to its 
		shutdown code (e.g. [...] on: ProcessTermination do: [:pt | pt return]).
		4) It must send #shutdown to the active process so that it is properly terminated.
		5) It must perform a ^-return as its last action.
	Items (2) and (5) ensure that any attempt to drop off the bottom of the process stack
	is trapped by the VM and results in a 'Context Expiry' walkback rather than an
	unrecoverable GPF."

	^(self new: DefaultStack max: slotsInteger ?? DefaultMaxStack)
		setLaunchBlock: aBlockClosure;
		priority: priorityInteger;
		yourself!

initialize
	"Initialize the class variables of the receiver:
		DefaultStack		-	The initial stack size of new Processes. This should be relatively
							small so as not to waste space, and to reduce instantiation overhead,
							but not so small that it causes a stack fault and growth. A default
							value which corresponds to less than one OS page (normally 4k bytes, 
							or 1024 object pointers) will be rounded up to one OS page. The
							actual stack size will be slightly less than the number of pointers
							which fit on one OS page, because the VM adjusts it to account for 
							Process' fixed instance variables, and overhead.
		DefaultMaxStack	-	The maximum size to which the stack of new Processes can grow before
							the VM signals a stack overflow. Processes grow by a number of pages each time 
							a stack overflow occurs, from the initial size, up to this maximum.
							This value should be large enough to allow useful work to be done by 
							recursive methods, but not so large that programming errors go 
							undetected, It is unlikely that a stack need be large than 65536, 
							and for those instances, specific instantiation is recommended.
		DefaultFpControl	-	Default floating point control word - see msdn documentation for the
							CRT function _controlfp_s().

	Evaluate me to initialize:
		Process initialize
	"

	self addClassConstant: 'DefaultStack' value: 1.	"Let the VM work out the minimum size (will be at least one OS page)"
	DefaultMaxStack := 64 * 1024.	"Grow to 64K slots (256Kb) before overflow."

	"See FloatingPointException for an explanation of the default FP exception mask"
	self addClassConstant: 'DefaultFpControl'
		value: OS.CRTConstants._RC_NEAR | OS.CRTConstants._IC_PROJECTIVE | OS.CRTConstants._DN_SAVE
				| OS.CRTConstants._PC_64
					| (OS.CRTConstants._MCW_EM maskClear: OS.CRTConstants._EM_ZERODIVIDE | OS.CRTConstants._EM_INVALID)!

new
	"Processes should be created by sending one of the #fork family of messages to a block."

	^self shouldNotImplement! !
!Core.Process class categoriesForMethods!
forContext:priority:maxStack:!instance creation!private! !
initialize!development!initializing!public! !
new!instance creation!public! !
!

