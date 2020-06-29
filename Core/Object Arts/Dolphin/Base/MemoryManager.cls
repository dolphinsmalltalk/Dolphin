"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MemoryManager
	instanceVariableNames: 'finalizer lastRequests hospice hospiceHighWater maxObjects undertaker bereavements bereaved bereavedHighWater gcInterval lastGCTime lastGCDuration objectHeaderSize events'
	classVariableNames: 'Current GCInterval'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MemoryManager guid: (GUID fromString: '{703bd0ad-fbff-4d00-866b-b80387f7b1d7}')!
MemoryManager comment: 'MemoryManager is a singleton class whose sole instance is responsible for scheduling garbage collection, performing finalization, saving the image, etc.

The MemoryManager owns two processes which are responsible for performing certain garbage collection activities in synchronization with the image. The garbage collector itself cannot perform these tasks because it runs asynchronously in the VM. The first of these processes is responsible for sending #finalize messages to objects that were previously marked as finalized before they expired. It does this by consuming objects from a queue which is populated by the collector. This activity is performed at low priority, as in general it is considered that reclaiming resources is a lower priority activity than interactive tasks. Also the asynchronous nature of garbage collection makes it unpredictable when (if ever) an object will actually be ready for finalization. However, to avoid the queue growing indefinitely when a higher priority CPU intensive task is consuming all available cycles, the finalization queue has a "high water mark". When the collector enqueues a finalizable object and finds the queue has passed the high water mark, it sends an interrupt (via the Processor object) to indicate this condition. The MemoryManager responds by temporarily boosting the priority of the finalization task to a relatively high level (above the normal "user" levels), so that it is cleared down quickly.

There is also a "bereavement" queue which is managed in a similar way. The bereavement queue is populated by the collector with weakling objects (i.e. those with weak references) when they lose one or more of those references. Bereaved objects are consumed from the bereavement queue and sent #elementsExpired: messages by the "undertaker" process. A significant difference from the finalization process is that the undertaker runs at a very high priority in order to guarantee that weak objects are repaired immediately.

Note that collections that nil weak references can only be scheduled from the image (e.g. by the background idle process), never asynchronously by the VM. This is so that weak objects can be operated on atomically without the rug being pulled from under their feet by the collector.

Instance Variables:
	finalizer		<Process>. Low priority task responsible for sending #finalize message to finalizable objects.
	lastRequests	<Semaphore>. Semaphore signalled the GC when finalizable objects enqueued for finalizer.
	hospice		<Array>. Queue of objects requiring finalization. Growns dynamically by the GC as required.
	hospiceHighWater	<integer>. Level at which GC interrupts to notify finalizable garbage building up (default 64)
	reserved		Reserved for future use.
	undertaker		<Process>. High priority task responsible for repairing weak collections.
	bereavements	<Semaphore>. Semaphore signalled by GC when weak collections have suffered bereavements.
	bereaved		<Array>. Queue of weak collections which have suffered losses.
	bereavedHighWater	<integer>. Level at which GC interrupts to notify bereaved queue building up (default 32).
	gcInterval		<integer>. Milliseconds between major GC cycles.
	lastGCTime	<integer>. Milliseconds clock at last major GC cycle.
	lastGCDuration	<integer>. Duration in milliseconds of last major GC cycle.
	objectHeaderSize	<integer>. Number of bytes in object headers allocated by the VM (a constant).

Class Variables:
	GCInterval	<integer>. Default GC interval.
	Current		<MemoryManager>. Singleton instance.

'!
!MemoryManager categoriesForClass!System-Support! !
!MemoryManager methodsFor!

aboutToIdle
	"Private - The system is about to quiesce, see whether its appropriate to reschedule 
	memory management activities. At the moment we just check that the finalization processes
	are still alive, and if not fork new ones."

	| now interval |
	self ensureProcessesRunning.
	Delay aboutToIdle.
	now := self millisecondClock.
	interval := now - lastGCTime.
	(interval > self gcInterval or: [interval < 0]) ifFalse: [^self].
	self collectGarbage.
	lastGCDuration := self millisecondClock - now max: 10.
	gcInterval := GCInterval max: (lastGCDuration * 2 max: self minGCInterval)!

administerLastRites
	"Private - Dequeue dying objects from the system finalization queue, and send them a 
	#finalize message. Multiple finalization processes are permissible because access to the 
	VM queue is atomic (which is in any case required for synchronisation with the VM's garbage 
	collection activities). This allows a user Process to synchronously perform finalization at 
	certain points, for example, so that all objects pending finalization are processed before 
	the image is saved. This may be necessary because the Finalizer rusually uns at a very low priority."

	| dying |
	[(dying := self dequeueForFinalization) isNil] whileFalse: [dying finalize].
	finalizer priority: self finalizerPriority!

bereavedOverflow: interruptArg
	"Private - The VM has detected that the bereavement queue has reached
	its high water mark. This should not happen, because the undertaker
	process runs at very high priority. If it does happen, then presumably
	it is because the Undertaker has died, and must be restarted."

	Notification signal: 'WARNING: Bereavement queue overflow'.
	self ensureProcessesRunning
!

bytesUsedByObject: anObject 
	"Answer the memory consumed directly by the <Object> argument. This does not include any
	space used by objects referenced from the object, and neither does it include any overhead
	such as heap overhead. The calculation is implementation dependent, and may change in new
	versions of Dolphin."

	| bodySize |
	anObject isImmediate ifTrue: [^0].
	"The body is rounded to a multiple of 8 bytes"
	bodySize := (anObject class isPointers 
				ifTrue: [(anObject basicSize + anObject class instSize) * VMConstants.IntPtrSize]
				ifFalse: [anObject basicSize + (anObject class isNullTerminated ifTrue: [1] ifFalse: [0])]) + 7 
				bitAnd: -8.
	"Each object has a header containing a pointer to the body, a class Oop, a intptr object size, and an intptr of flags, i.e. 4 machine words (16 or 32 bytes))"
	^bodySize + (VMConstants.IntPtrSize * 4)!

collectGarbage
	"Private - Invoke the fast (non-compacting) garbage collector to reclaim inaccessible objects
	(those not reachable from root objects, such as the SystemDictionary, Smalltalk),
	and perform the grim reaping of objects which only have weak references from the roots
	of the world. Such objects are queued for finalization if so marked (see 
	Object>>beFinalizable). Objects marked as weak (see Object>>beWeak) will have their 
	losses replaced with the Corpse object, and if an instances of mourning classes (see 
	Behavior>>makeMourner) they will be queued to receive a #elementsExpired: message 
	informing them of the scale of their losses.

	If following the GC there are any objects awaiting finalization in the queue, then
	the Finalizer is signalled via its Semaphore, and it finalizes all objects waiting in
	the queue.

	This message is sent from system idle processing, but can also be invoked directly if desired.

	The MemoryManager makes certain guarantees to objects marked as requiring finalization:
	-	Such objects will receive a #finalize message, at some interval
		(of unspecified duration) after their last reference from an object not
		marked as weak has been cleared.
	- 	Objects with last requests are guaranteed to receive only a single #finalize 
		message no matter how many objects weakly reference them.
	-	Objects with last requests will die immediately after they have carried out
		their last requests.

	Should an objects' #finalize methods cause, directly or indirectly, further references to be 
	taken to itself (e.g. by assignment to variables), then it will receive a reprieve and continue 
	to live. Should such an object require a further finalization message the next time it's on its 
	death bed, then it must be sent the #beFinalizable message again, because its finalization mark 
	is cleared when it is queued for finalization.
	
	It may be that an application requires that finalized objects be able to suspend their own 
	deaths, and this is the reason for the above described behavior, but it is necessary to
	regenerate any weak references still required, as these will have been lost.

	The guarantees to objects with weak references are:
	-	They will receive one, and only one, #elementsExpired: message following each GC,
		should they suffer a bereavement or bereavements, and the argument will inform them
		how many NEW Corpses they have.
	-	Former weak references will have been replaced with references to the Corpse 
		object.
	
	Note that the GC does not remove references to corpse from previous reapings.
	Should this be the behaviour desired, then weaklings must clear away corpses themselves
	from their #elementsExpired: method."

	lastGCTime := self millisecondClock.
	self primCollectGarbage: 0.
	lastGCDuration := self millisecondClock - lastGCTime!

compact
	"Private - Invoke the slow (compacting) garbage collector to minimize the size
	of the object memory. Answers the number of objects in the system following 
	compaction. See #collectGarbage for further GC details."

	^self primCompact
!

dequeueBereavementInto: anArray
	"Private - Remove the next entry from the system bereavement queue and populate anArray
	with its contents. Answers true if an element was dequeued into anArray, or false if the queue is empty.

	Primitive failure reasons:
		InvalidParameter1	- anArray is not an Array, or is not of sufficient size to hold a complete queue entry."

	<primitive: 119>
	^self primitiveFailed: _failureCode!

dequeueForFinalization
	"Private - Answer the next entry in the system finalization queue, or nil if it is
	empty. The primitive should not fail."

	<primitive: 118>
	^self primitiveFailed: _failureCode!

directFunerals
	"Private - Dequeue bereaved objects from the system bereavement queue, and send them an 
	#elementsExpired: message with an argument informing them of the magnitude of their losses. 
	Multiple funeral direction processes are permissible because access to the VM queue is atomic 
	(which is in any case required for synchronisation with the VM's garbage collection activities). 
	This allows a user Process to synchronously send #directFunerals at certain points, though this 
	should not be necessary because the Undertaker (necessarily) runs at a very high priority."
	
	| queueEntry |
	queueEntry := Array new: 2.
	[self dequeueBereavementInto: queueEntry] 
		whileTrue: [(queueEntry basicAt: 1) elementsExpired: (queueEntry basicAt: 2)]!

ensureProcessesRunning
	"Private - If the finalization processes have not been forked, or have died, 
	or are suspended on Semaphores other than the receiver's, refork them"

	(finalizer isNil or: [(finalizer isAlive: lastRequests) not])
		ifTrue: [self forkFinalizer].
	(undertaker isNil or: [(undertaker isAlive: bereavements) not])
		ifTrue: [self forkUndertaker]
	!

finalizer
	"Private - Answer the finalizer <Process>."

	^finalizer!

finalizerMain
	"Private - Wait for objects to be queued to the system finalization queue, then attempt to
	empty that queue. The VM signals the queue semaphore each time it queues a group of objects
	to the queue so the semaphore's signal count does not reflect the number of elements waiting
	in the queue (this is to reduce the asynchronous signalling overhead and to permit user code
	to force synchronous finalization by directly invoking administerLastRites). Should the
	finalizer be prematurely terminated by an error occurring in a #finalize method, then it
	will be restarted the next time the system goes idle, but the semaphore's signal count will
	not be reset, so any waiting objects should get serviced in the near future, assuming
	Processor time is available. Should the VM detect that the finalization queue has reached
	the configured high water mark, then it will send an interrupt to the processor, which
	forwards it to the current memory manager. The default action on receipt of the interrupt is
	to raise the priority of the finalization process to lowIOPriority. After each iteration
	through #administerLastRites we set the priority back to its initial priority, so it never
	remains permanently elevated."

	finalizer := Processor activeProcess.
	finalizer name: 'Finalizer'.
	[finalizer == Processor activeProcess] whileTrue: 
			[lastRequests
				wait;
				excessSignals: 0.
			self administerLastRites]!

finalizerPriority
	^Processor systemBackgroundPriority!

forkFinalizer
	"Private - Start/restart the finalization process which oversees the administration of
	last rites. Note that because the finalizer runs at a low priority, finalization receives
	a low priority. For this reason, and others, it is not a good idea to rely on finalization
	to release limited resources."

	"Notification signal: self class name , ': Restarting Finalizer process...'."
	[self finalizerMain] forkAt: self finalizerPriority!

forkUndertaker
	"Private - Start/restart the process which directs funerals on behalf of objects 
	with weak references which suffer bereavements during a garbage collect. 
	The undertaker MUST run at a priority above that of any process likely to make 
	use of weakly referencing objects, unless those objects are prepared to handle 
	the appearance of Corpses before they receive a notification of the loss. 
	The undertaker's task is to inform weakly referencing objects of their bereavements, 
	so that they can make the necessary repairs. Weakly referencing objects that need 
	to make repairs, will almost certainly need to make these repairs to the exclusion 
	of other processes, so they will need to use a Mutex around all accesses (the Pattern 
	is: subclass the strong version, add a mutex, perform all accesses to potentially shared 
	data inside a critical section against the mutex with a supersend, implement 
	elementsExpired: repairing the shared data inside the mutex)."

	Notification signal: self class name, ': Restarting Undertaker process...'.
	[self undertakerMain] forkAt: Processor highIOPriority!

gcInterval
	"Private - Answer the interval (in milliseconds) between idle time GCs"

	^gcInterval!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

hospiceOverflow: interruptArg
	"Private - The VM has detected that the finalization queue has reached its high water mark.
	Boost the priority of the finalizer thread so that it will run the next time thread
	scheduling occurs."

	finalizer priority: Processor lowIOPriority!

initialize
	"Private - Initialize the receiver's instance variables.
	N.B. Use of this method in a running system is likely to result in 
	system failure."

	self resetGCStats.
	hospiceHighWater := 64.	"Max finalization queue before high priority administerLastRites"
	bereavedHighWater := 16.
	hospice := Array new: hospiceHighWater * 2.
	bereaved := Array new: bereavedHighWater * 2.
	lastRequests := Semaphore new.
	bereavements := Semaphore new.
	self registerObjects!

instanceStats: anArrayOrNil
	"Answer an <LookupTable>, containing counts of the number of instances and the approximate storage used by all instances of a set of classes.
	If the argument is nil, then the table contains the statistics for every class in the system. Note that this will also include metaclass instances. If the
	argument is a collection of classes then the table will contain statistics for only those classes."

	| triplets answer |
	answer := IdentityDictionary new.
	triplets := self primInstanceStats: (anArrayOrNil ifNotNil: [anArrayOrNil asArray]).
	1 to: triplets size
		by: 3
		do: [:i | answer at: (triplets at: i) put: {triplets at: i + 1. triplets at: i + 2}].
	^answer!

maxObjects
	"The maximum number of objects that can be allocated (i.e. the maximum size of the object
	table). This is copied here by the VM from the image header on startup. It can be altered by
	resaving the image using the image snapshot primitive (see
	SessionManager>>#primSnapshot:backup:type:maxObjects:) and restarting. The maximum number of
	objects supported in a running image cannot be altered. The current default is 24*1024*1024
	(i.e. ~24 million) objects, but this is subject to change. There is also an absolute maximum
	number of objects implied by the limited address space available to a 32-bit process. The VM
	currently imposes a maximum limit of 64*1024*1024 objects, but this may not be usable in
	practice."

	^maxObjects!

millisecondClock
	"Private - Answer the current millisecond clock value."

	<primitive: 174>
	^self primitiveFailed: _failureCode!

minGCInterval
	"Private - Answer the minimum interval (in milliseconds) between idle time GCs"

	^5000!

objectCount
	"Private - Answer an approximate indication of the number of live objects in the system
	at the time of invocation."

	<primitive: 169>
	^Class allRoots inject: 0 into: [:sum :e | sum + e primAllSubinstances size]!

objectHeaderSize
	"Private - Answer the value of the receiver's ''objectHeaderSize'' instance variable."

	^objectHeaderSize!

onPreSaveImage
	"Private - Clean up before a snapshot. We perform a compacting garbage collect
	to minimize the image size, and then move objects queued for finalization. 
	We need to ensure that all objects pending finalization do actually get finalized 
	to ensure that those holding external resources are cleared down. If any such objects
	were later finalized in a new session their internal state would be invalid (they will 
	contain invalid handles), but in any case the finalization queue is renewed on restart.
	It is not necessary to inform weak objects of their losses, because the Undertaker 
	runs at a high priority and should interrupt us to perform that task."

	self
		compact;
		administerLastRites!

onStartup
	"Private - The system has just started, kick start the Memory Manager."

	self resetGCStats.
	self registerObjects.
	self ensureProcessesRunning!

otOverflow: anInteger
	"Private - The VM has allocated more memory for objects headers. The <integer> argument
	specifies the new size of the OT. Initiate a GC if we haven't done so very recently (we try
	to avoid performing unecessary GCs when object growth rates are very high, as that may not
	be due to the accumulation of garbage, but just the result of normal activity). N.B. Sent
	with interrupts disabled from the Processor in response to an interrupt generated by the
	VM."

	| now |
	now := self millisecondClock.
	now - lastGCTime > (lastGCDuration * 4)
		ifTrue: 
			[lastGCTime := now.
			self primCollectGarbage: 1.
			lastGCDuration := self millisecondClock - now max: 10].
	"This interrupt is only ever sent to the active process, therefore no need to reschedule"
	Processor enableAsyncEvents: true.
	"Trigger an event so apps can monitor their memory consumption. Note that this will fire in
	whatever Process is active when the OT overflow occurs, so event handlers need to be thread
	safe and not have any thread affiinity."
	self trigger: #otOverflow: with: anInteger!

primCollectGarbage: flags
	"Private - Invoke the fast (non-compacting) garbage collector. Answers the receiver.
	The primitive should not fail.
	Flags:
		1	- Treat all references as strong (i.e. ignore weak attribute of objects).
	"

	<primitive: 112>
	^self primitiveFailed: _failureCode!

primCompact
	"Private - Invoke the slow (compacting) garbage collector. Answers the number of
	objects in the system following compaction. The primitive should not fail."

	<primitive: 115>
	^self primitiveFailed: _failureCode!

primInstanceStats: anArrayOrNil
	"Private - Answer a packed <Array> of triplets {class, instance count, approximate storage
	usage}. If the argument is nil, the answer will contain a triplet for every class in the
	system. If the argument is an array, it is expected to contain the classes for which
	statistics are to be returned. The primitive runs in constant time no matter how many
	classes you choose, in particular it takes just as long to return the stats for one class as
	it does for all classes, and therefore it is less efficient than using #primAllInstances
	unless requesting stats for several classes at once.

	Primitive failure reasons: 
		ObjectTypeMismatch 	- anArrayOrNil is not an Array, or nil."

	<primitive: 179>
	^self primitiveFailed: _failureCode!

registerObjects
	"Private - Register the finalize and bereavement queue Semaphores with the VM."

	VMLibrary default
		registryAt: #memoryManager put: self;
		registryAt: #Corpse put: DeadObject current;
		registryAt: #FinalizeQueue put: hospice;
		registryAt: #FinalizeSemaphore put: lastRequests;
		registryAt: #BereavementQueue put: bereaved;
		registryAt: #BereavementSemaphore put: bereavements.

	"Signal the semaphores in case any objects waiting in the queues"
	lastRequests signal.
	bereavements signal
	!

resetGCStats
	lastGCTime := lastGCDuration := 0.
	gcInterval := GCInterval!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

undertaker
	"Private - Answer the value undertaker <Process>."

	^undertaker!

undertaker: aProcessOrNil
	"Private - Set the receiver's undertaker process to the argument, aProcessOrNil, 
	terminating any existing undertaker. The undertaker funerals for bereaved weak objects 
	(i.e. it sends them #elementsExpired: messages)."

	undertaker isNil ifFalse: [undertaker terminate].
	undertaker := aProcessOrNil!

undertakerMain
	"Private - Wait for bereaved objects to be queued to the system bereavement queue, then attempt
	to empty that queue. The VM signals the queue semaphore each time it queues a group of objects to 
	the queue	so the semaphore's signal count does not accurately reflects the number of elements waiting 
	in the queue (this is to reduce the asynchronous signalling overhead and to permit user code to force
	synchronous notification by synchronously sending #directFunerals). Should the undertaker be
	prematurely terminated by an errror occurring in an elementsExpired: method, then it will be 
	automatically restarted."

	undertaker := Processor activeProcess.
	undertaker name: 'Undertaker'.
	[undertaker == Processor activeProcess] whileTrue: [
	 	bereavements wait.
		self directFunerals]! !
!MemoryManager categoriesFor: #aboutToIdle!accessing!private! !
!MemoryManager categoriesFor: #administerLastRites!finalizing!private! !
!MemoryManager categoriesFor: #bereavedOverflow:!interrupts-handling!private! !
!MemoryManager categoriesFor: #bytesUsedByObject:!helpers!private! !
!MemoryManager categoriesFor: #collectGarbage!garbage collection!private! !
!MemoryManager categoriesFor: #compact!garbage collection!private! !
!MemoryManager categoriesFor: #dequeueBereavementInto:!finalizing!private! !
!MemoryManager categoriesFor: #dequeueForFinalization!finalizing!private! !
!MemoryManager categoriesFor: #directFunerals!finalizing!private! !
!MemoryManager categoriesFor: #ensureProcessesRunning!finalizing!private! !
!MemoryManager categoriesFor: #finalizer!accessing!private! !
!MemoryManager categoriesFor: #finalizerMain!finalizing!private! !
!MemoryManager categoriesFor: #finalizerPriority!finalizing!private! !
!MemoryManager categoriesFor: #forkFinalizer!finalizing!private! !
!MemoryManager categoriesFor: #forkUndertaker!finalizing!private! !
!MemoryManager categoriesFor: #gcInterval!accessing!private! !
!MemoryManager categoriesFor: #getEvents!events!private! !
!MemoryManager categoriesFor: #hospiceOverflow:!interrupts-handling!private! !
!MemoryManager categoriesFor: #initialize!development!initializing!private! !
!MemoryManager categoriesFor: #instanceStats:!enquiries!public! !
!MemoryManager categoriesFor: #maxObjects!accessing!public! !
!MemoryManager categoriesFor: #millisecondClock!enquiries!private! !
!MemoryManager categoriesFor: #minGCInterval!accessing!private! !
!MemoryManager categoriesFor: #objectCount!garbage collection!private! !
!MemoryManager categoriesFor: #objectHeaderSize!accessing!private! !
!MemoryManager categoriesFor: #onPreSaveImage!event handling!private! !
!MemoryManager categoriesFor: #onStartup!event handling!private! !
!MemoryManager categoriesFor: #otOverflow:!interrupts!interrupts-handling!private! !
!MemoryManager categoriesFor: #primCollectGarbage:!garbage collection!private! !
!MemoryManager categoriesFor: #primCompact!garbage collection!private! !
!MemoryManager categoriesFor: #primInstanceStats:!enquiries!private! !
!MemoryManager categoriesFor: #registerObjects!initializing!private! !
!MemoryManager categoriesFor: #resetGCStats!initializing!private! !
!MemoryManager categoriesFor: #setEvents:!events!private! !
!MemoryManager categoriesFor: #undertaker!accessing!private! !
!MemoryManager categoriesFor: #undertaker:!finalizing!private! !
!MemoryManager categoriesFor: #undertakerMain!finalizing!private! !

!MemoryManager class methodsFor!

current
	"Answer the singleton instance of the receiver.
	N.B. This instance can only be replaced with #become:, and the format
	must be the same."

	^Current
!

gcInterval: anInteger
	"Set the interval between GC's (idle time) to anInteger"

	GCInterval := anInteger!

initialize
	"Initialize the class variables of the receiver
		Current		-	The singleton instance of the receiver. Can be replaced with an 
						alternative memory manager if desired by sending #current:.
		GCInterval		-	Minimum idle time (milliseconds) between scheduled GC's"

	GCInterval := 15000.
	Current isNil ifTrue: [Current := super new initialize]!

new
	"The receiver is a singleton class."

	^self shouldNotImplement!

removeFromSystem
	"Private - Remove the receiver completely from the system.
	Override because this class is critical to system operation, 
	and must not be deleted."

	^self shouldNotImplement! !
!MemoryManager class categoriesFor: #current!instance creation!public! !
!MemoryManager class categoriesFor: #gcInterval:!accessing!public! !
!MemoryManager class categoriesFor: #initialize!development!initializing!must strip!public! !
!MemoryManager class categoriesFor: #new!development!instance creation!public! !
!MemoryManager class categoriesFor: #removeFromSystem!class hierarchy-removing!private! !

