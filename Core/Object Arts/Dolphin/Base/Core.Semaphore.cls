"Filed out from Dolphin Smalltalk 7"!

Core.LinkedList subclass: #'Core.Semaphore'
	instanceVariableNames: 'signals'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Semaphore guid: (Core.GUID fromString: '{87b4c524-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Semaphore comment: ''!
!Core.Semaphore categoriesForClass!Kernel-Processes! !
!Core.Semaphore methodsFor!

= anObject
	"Answer whether the receiver and anObject are considered equivalent.
	An equality comparison based on the list of processes waiting on the
	receiver does not make sense for a Semaphore, so override back to
	the default (identity-based) implementation from Object."

	<primitive: 110>
	^self primitiveFailed: _failureCode!

add: newElement afterIndex: index
	"Add newElement to the receiver immediately after the element currently at the
	specified <integer> index. index must be between 0 and the receiver's current 
	size (if not raise an exception). Answer newElement."

	^self shouldNotImplement!

critical: aBlock
	"Evaluate aBlock as a critical section - i.e. aBlock is evaluated only when
	no other Blocks are being evaluated under the control of the receiver.
	Ensure semaphore does not remain decremented, even should an exception be thrown by aBlock.
	However note that the critical section will remain 'locked' until the exception is
	actually handled and the stack is unwound past this point.

	Implementation Note: It is possible that the VM may interrupt this process between
	the time that the #wait completes and any subsequent instructions being run
	(in fact it is quite likely in a low priority process). If the interrupt terminates the 
	process, then the Semaphore could be left locked. The simpler
	implementation in 2.1 and earlier (with the #wait outside the #ensure: block)
	thus had a very small window when the Semaphore could be left in an invalid
	state if the process was interrupted. This implementation fixes that bug - it
	is not possible for the process to be interrupted without a value having been
	assigned into the return value holder."

	| retHolder |
	retHolder := {OS.Win32Constants.WAIT_FAILED}.
	^
	[self wait: OS.Win32Constants.INFINITE ret: retHolder.
	aBlock value]
			ensure: [(retHolder at: 1) == OS.Win32Constants.WAIT_OBJECT_0 ifTrue: [self signal]]!

critical: aBlock atPriority: anInteger
	"Evaluate aBlock as a critical section - i.e. aBlock is evaluated only when
	no other Blocks are being evaluated under the control of the receiver.
	Ensure semaphore does not remain decremented, even should an exception be thrown by aBlock.
	The active processes priority is temporarily raised to the argument, anInteger,
	during the execution of the critical section.
	The purpose of this message is to avoid the starvation of a high priority process which can occur
	if it shares a critical section with a low priority process which never gets scheduled due to other
	process' activities."

	| activePriority waitResult |
	activePriority := Processor activeProcess priority: anInteger.
	waitResult := Array new: 1.
	^
	[self wait: OS.Win32Constants.INFINITE ret: waitResult.
	aBlock value] ensure: 
				[(waitResult basicAt: 1) == OS.Win32Constants.WAIT_OBJECT_0 ifTrue: [self signal].
				Processor activeProcess priority: activePriority]!

excessSignals
	"Private - Answer the count of signals in excess of waits to the receiver"

	^signals!

excessSignals: anInteger
	signals := anInteger!

hash
	"Answer the SmallInteger hash value for the receiver. 
	A hash value based on the list of processes waiting on the
	receiver does not make sense for a Semaphore, so override back to
	the default (identity hash) implementation from Object."

	^self identityHash!

initialize
	"Private - Initialize the instance variables of the receiver."

	signals := 0
!

primSetSignals: pulse
	"Private - Set the excess signal count of the receiver to the argument, anInteger, starting the first Waiting process, if any.

	Primitive failure reasons:
		InvalidParameter1	- pulse is not a SmallInteger."

	<primitive: 99>
	^self primitiveFailed: _failureCode!

printOn: aStream
	"Print a string representation of self on aStream."

	self excessSignals > 0 
		ifTrue: [aStream basicPrint: self; nextPut: $(; print: self excessSignals; nextPutAll: ' signals)']
		ifFalse: [super printOn: aStream]!

pulse
	"As #set, except that the excess signal count of the receiver is always set to 0.
	This 'pulsing' behaviour is useful for signalling a process only if there is one
	waiting, and otherwise leaving the receiver unsignalled."

	self primSetSignals: 0!

reset
	"Reset the excess signals recorded by the receiver to zero. There is no effect on any waiting processes."

	signals := 0
!

set
	"As #signal, except that if there are no Processes waiting for the receiver
	then the excess signal count is set to one, no matter how many times #set 
	is sent, and no matter what its previous value. This is useful for
	implementing process synchronisation 'Events', whereby one wants to record
	that something has happened, but not how many times it has happened."

	self primSetSignals: 1!

signal
	"Send a signal through the receiver. If one or more Processes are Waiting on the receiver,
	then transition the first of those Processes (on a FIFO basis, independent of priority) 
	from Waiting to Ready. 

	If no Processes are Waiting on the receiver, then the excess signal is remembered so that 
	subsequent #waits will not cause the sending Process to Wait.

	The primitive should not fail.

	N.B. A signalled Process will not normally run immediately unless it is of a higher priority 
	than 	the current active Process (i.e. does not yield), and there are not already Processes at 
	or above its priority which are also Ready (these will run instead)."

	<primitive: 85>
	^self primitiveFailed: _failureCode!

terminateProcess
	"Terminate the first process waiting on the receiver"

	self notEmpty ifTrue: [self first terminate]!

wait
	"The active Process must receiver a signal through the receiver before proceeding.
	Waiting processes may be interrupted, but will return to waiting when they have
	finished processing the interrupt. See #wait: and #wait:ret: for further details."

	| ret |
	ret := Array new: 1.
	self wait: OS.Win32Constants.INFINITE ret: ret.
	^ret basicAt: 1!

wait: timeout
	"The active Process must receive a signal through the receiver before 
	proceeding, or be interrupted (i.e. receive an interrupt from the VM), or timeout
	after anInteger milliseconds. See #wait:ret: for further details.

	The answer (written into the first slot of the return value holder by the primitive) could be 
	WAIT_OBJECT_0 if the wait completed successfully (either because the Semaphore had 
	excess signals, or because it was signalled), or WAIT_IO_COMPLETION if the primitive
	was interrupted, or WAIT_TIMEOUT if the wait timed out. BUT, the latter two results are
	not actually possible from this method since 
	1) 	an interrupted process will either not return here (if the Semaphore>>wait is returned 
		over and unwound), or will be resumed when the interrupt complets.
	2)	we request an INFINITE timeout."

	| ret |
	ret := Array new: 1.
	self wait: timeout ret: ret.
	^ret basicAt: 1!

wait: timeout ret: returnValueHolder
	"Private - The active Process must receive a signal through the receiver before proceeding, or be interrupted (i.e. receive an interrupt from the VM), or timeout after anInteger milliseconds. Answer the argument, returnValueHolder, with its first instance variable updated to hold and <integer> return code.

	At present the only valid values for timeout are, INFINITE, meaning wait for ever, and 0, meaning don't wait at all. The behaviour of these is as follows: 
		INFINITE- Wait until the semaphore is signalled, answering WAIT_OBJECT_O. 0 - If the receiver has excess signals, then decrement the count, and answer 
		WAIT_OBJECT_O, otherwise return immediately without waiting, but answer WAIT_TIMEOUT. i.e this is a way to 'poll' a Semaphore.

	If no signal has been sent, then the active Process will be transitioned from Running to Waiting until one is sent, when it may be returned to the Ready state.

	The purpose the returnValueHolder argument is to allow #wait to atomically wait for the availablity of a Semaphore _and_ update a variable in the enclosing context as to the outcome of that wait. This is important to the correct implementation of
	Semaphore>>critical:, for example, as otherwise it is not possible to reliably determine in unwind handling whether the Semaphore was acquitrf or not - one can't rely on a normal return value, because the process may not yet have proceeded far enough to assign it back into a temporary in the calling context.

	Primitive failure reasons:
		InvalidParameter1	- Timeout is not a SmallInteger
		NotSupported		- anInteger is not either INFINITE (-1) or 0.
		InvalidParameter2	- returnValueHolder is not of an appropriate shape to hold the return value (it must be a pointer object with at least one slot, e.g. a one element Array)"

	<primitive: 86>
	^self primitiveFailed: _failureCode! !
!Core.Semaphore categoriesFor: #=!comparing!public! !
!Core.Semaphore categoriesFor: #add:afterIndex:!adding!public! !
!Core.Semaphore categoriesFor: #critical:!process synchronisation!public! !
!Core.Semaphore categoriesFor: #critical:atPriority:!process synchronisation!public! !
!Core.Semaphore categoriesFor: #excessSignals!accessing!private! !
!Core.Semaphore categoriesFor: #excessSignals:!initializing!private! !
!Core.Semaphore categoriesFor: #hash!comparing!public! !
!Core.Semaphore categoriesFor: #initialize!initializing!private! !
!Core.Semaphore categoriesFor: #primSetSignals:!private!process synchronisation! !
!Core.Semaphore categoriesFor: #printOn:!printing!public! !
!Core.Semaphore categoriesFor: #pulse!process synchronisation!public! !
!Core.Semaphore categoriesFor: #reset!process synchronisation!public! !
!Core.Semaphore categoriesFor: #set!process synchronisation!public! !
!Core.Semaphore categoriesFor: #signal!process synchronisation!public! !
!Core.Semaphore categoriesFor: #terminateProcess!process synchronisation!public! !
!Core.Semaphore categoriesFor: #wait!process synchronisation!public! !
!Core.Semaphore categoriesFor: #wait:!process synchronisation!public! !
!Core.Semaphore categoriesFor: #wait:ret:!private!process synchronisation! !

Core.Semaphore methodProtocol: #mutualExclusionLock attributes: #(#readOnly) selectors: #(#critical:)!

!Core.Semaphore class methodsFor!

boolean
	"Answer a new Boolean Semaphore, initially signalled.
	The communication messages #set, and #pulse are intended for use
	with Boolean Semaphores, rather than #signal."

	^(self basicNew)
		excessSignals: 1;
		yourself!

forMutualExclusion
	"Answer a new instance of the receiver with one excess signal (i.e a Boolean semaphore)."

	^self boolean!

new
	"Answer a new semaphore which will block when the first wait is executed on it 
	(i.e. it's initial value is zero)."

	^self basicNew initialize! !
!Core.Semaphore class categoriesFor: #boolean!instance creation!public! !
!Core.Semaphore class categoriesFor: #forMutualExclusion!instance creation!public! !
!Core.Semaphore class categoriesFor: #new!instance creation!public! !

