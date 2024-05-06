"Filed out from Dolphin Smalltalk"!

Object subclass: #Mutex
	instanceVariableNames: 'owner semaphore'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

Mutex guid: (GUID fromString: '{87b4c4a4-026e-11d3-9fd7-00a0cc3e4a32}')!

Mutex comment: 'Mutex is the class of process synchronisation objects which provide mutually exclusive access to critical sections, potentially permitting a single process to enter such critical sections multiple times recursively (in some other Smalltalk systems this class is in fact called, RecursionLock).

If any process is in a Mutex, then no other process is permitted to enter that Mutex, but that process may re-enter.

Mutex is particulary useful where the use of a simple mutual exclusion <Semaphore> alone might cause deadlock, e.g. in implementing process safe collections.

Access to the Mutex is through the #critical: method only. Versions of Dolphin prior to 3.0 also supported #wait and #signal messages, but these were not entirely safe.

Instance Variables:

	owner		<Process> which currently owns the instance, or nil if no owner
	semaphore	<Semaphore> used for mutual exclusion	'!

!Mutex categoriesForClass!Kernel-Processes! !

!Mutex methodsFor!

critical: aNiladicBlock
	"Wait until the receiver is NOT owned by another Process than that currently
	active, and then evaluate the argument, aNiladicBlock, to the 
	exclusion of other Processes using this mutex, answering the result.
	Implementation Note: We could use Semaphore>>critical: to implement the
	#ifFalse: branch, but we code inline to avoid the overhead of a further #ensure:
	block to reset the owner instance variable in addition to that in Semaphore>>critical:
	which guarantees that the Semaphore is never left unsignalled on exit."

	| active stateHolder |
	(active := Processor activeProcess) == owner
		ifTrue: [^aNiladicBlock value].

	"We need to acquire the mutex before we can proceed"
	stateHolder := { nil }.
	^[	"The semaphore primitive will atomically wait AND set the wait result if it completes"
		semaphore wait: INFINITE ret: stateHolder.
		owner := active.
		"Set the state to indicate that the owner has been set and can be tested for premature release"
		stateHolder basicAt: 1 put: active.
		aNiladicBlock value
	] ensure: [ | state |
		"There are a number of possibilities:
			1: The normal case. The mutex was acquired, and the block evaluated to termination.
			2: The mutex was acquired and the block evaluated, but it prematurely released the mutex with #signal.
			3: The mutex was acquired, but the process was terminated before it could proceed any further.
			4: The process was terminated before the mutex could be acquired.
		In case 4 there is no action required."
		(state := stateHolder basicAt: 1) == active
			ifTrue: [ "Cases 1 & 2"
				owner == active ifTrue: [ "Case 1: Normal completion"
					owner := nil. semaphore signal]]
			ifFalse: [ "Cases 3 & 4"
				state == WAIT_OBJECT_0 ifTrue: [ "Case 3: Acquired but not evaluated"
					owner := nil. semaphore signal]]]!

critical: aNiladicBlock ifLocked: exceptionHandler
	"If the receiver is NOT owned by another Process than that currently
	active, then grab it and then evaluate the argument, aNiladicBlock, to the 
	exclusion of other Processes using this mutex, answering the result, otherwise
	evaluate the <niladicValuable>, exceptionHandler.
	Implementation Note: See #critical: for comments on the implementation."

	| active stateHolder |
	(active := Processor activeProcess) == owner
		ifTrue: [^aNiladicBlock value].

	stateHolder := Array new: 1.
	^[
		semaphore wait: 0 ret: stateHolder.
		(stateHolder basicAt: 1) == WAIT_TIMEOUT 
			ifTrue: [exceptionHandler value]
			ifFalse: [
				owner := active.
				stateHolder basicAt: 1 put: active.
				aNiladicBlock value]
	] ensure: [ | state |
		(state := stateHolder basicAt: 1) == active
			ifTrue: [
				owner == active ifTrue: [
					owner := nil. semaphore signal]]
			ifFalse: [
				state == WAIT_OBJECT_0 ifTrue: [
					owner := nil. semaphore signal]]]!

initialize
	"Private - Initialise the receiver. The owner is initially nil, signifying no owner,
	the first process to send #critical: will be permitted to take ownership of
	the receiver."

	semaphore := Semaphore forMutualExclusion.
	owner := nil!

owner
	"Private - Answer the owner of the Mutex"

	^owner!

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream 
		basicPrint: self;
		nextPutAll: '(owner: ';
		print: owner;
		nextPutAll: ', waiting: ';
		print: semaphore;
		nextPut: $)!

signal
	"Private - Release the mutex if still owned by the receiver.
	Note that this message _must only_ be sent from inside a critical: block
	as otherwise thread safety may be compromised. Indeed this method
	is only intended for prematurely releasing a mutex, for example on
	the occurrence of an error."

	Processor activeProcess == owner ifTrue: [
		owner := nil. semaphore signal]! !

!Mutex categoriesForMethods!
critical:!debugger-step over!process synchronisation!public! !
critical:ifLocked:!process synchronisation!public! !
initialize!initializing!private! !
owner!accessing!private! !
printOn:!printing!public! !
signal!private!process synchronisation! !
!

Mutex methodProtocol: #mutualExclusionLock attributes: #(#readOnly) selectors: #(#critical:)!

!Mutex class methodsFor!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize! !

!Mutex class categoriesForMethods!
new!instance creation!public! !
!

