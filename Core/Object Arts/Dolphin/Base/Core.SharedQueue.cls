"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.SharedQueue'
	instanceVariableNames: 'accessProtect valueAvailable contents'
	classVariableNames: 'AbsentCookie'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

Core.SharedQueue guid: (Core.GUID fromString: '{87b4c4b8-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.SharedQueue comment: ''!

!Core.SharedQueue categoriesForClass!Kernel-Objects! !

!Core.SharedQueue methodsFor!

errorOutOfSync
	"Private - An internal synchronisation error (between the valueAvailable
	Semaphore and the contents OrderedCollection) has been detected.
	Raise an appropriate exception."

	self error: 'internal synchronisation error'!

initialize: anInteger
	"Private - Initialize the receiver, providing sufficient initial space
	in the queue for anInteger elements (the queue will grow however)."

	contents := OrderedCollection new.
	accessProtect := Semaphore forMutualExclusion.
	valueAvailable := Semaphore new!

next
	"Answer the first item in the queue. If the queue is empty, make the current active 
	Process wait until another Process has put an object in the queue. Safe for multiple 
	consumers, since valueAvailable effectively records the number of entries in the queue."

	| value |
	valueAvailable wait.
	value := accessProtect critical: [contents removeFirstIfAbsent: AbsentCookie].
	value == AbsentCookie ifTrue: [self errorOutOfSync].
	^value!

nextNoWait
	"Answer the first item in the queue, or nil if the queue is empty. The current active Process
	will not be made to wait, regardless of the queue state.
	Note: This is implemented rather than #isEmpty in order that the test and retrieval can
	be performed as an atomic unit. We also suppress any error due to the valueAvailable and
	contents collection size being out of sync. in order to avoid leaving the critical
	section locked. So even if the queue really is empty when the valueAvailable Semaphore
	says it is not, the external behaviour is correctly maintained."

	| value |
	(valueAvailable wait: 0) == WAIT_TIMEOUT ifTrue: [^nil].
	value := accessProtect critical: [contents removeFirstIfAbsent: AbsentCookie].
	value == AbsentCookie ifTrue: [self errorOutOfSync].
	^value!

nextPut: value
	"Place the object, value, at the end of the queue, signalling the valueAvailable 
	semaphore	to permit consumers to continue, or record the current number of items in
	the queue if there are no consumers waiting. Answer the argument, value."

	accessProtect critical: [contents addLast: value].
	valueAvailable signal.
	^value
!

peek
	"Answer the first object in the queue, but do not remove it. If the queue is empty, answer nil.
	The current active process will not be made to wait regardless of the queue state."

	^accessProtect critical: [contents notEmpty ifTrue: [contents first]]!

removeAll
	"Empty the receiver of all contents."

	"Implementation Note: We must be careful to make sure that the valueAvailable semaphore 
	correctly reflects the number of items in the queue. Since #nextPut: signals valueAvailable
	after adding a new entry to the queue, we mustn't remove any items not yet accounted for
	in the signal count of valueAvailable."

	accessProtect critical: 
			[
			[((valueAvailable wait: 0) == WAIT_TIMEOUT ifFalse: [contents removeFirstIfAbsent: AbsentCookie])
				isNil]
					whileFalse]!

size
	"Answer the number of objects currently in the queue"

	^accessProtect critical: [contents size]! !

!Core.SharedQueue categoriesForMethods!
errorOutOfSync!exceptions!private! !
initialize:!initializing!private! !
next!accessing!public! !
nextNoWait!accessing!public! !
nextPut:!accessing!public! !
peek!accessing!public! !
removeAll!public!removing! !
size!accessing!public! !
!

!Core.SharedQueue class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		SharedQueue initialize
	"

	AbsentCookie := Object new!

new
	"Answer a new instance of the receiver."

	^self new: 4!

new: anInteger 
	"Answer a new instance of the receiver with initial space
	for anInteger elements in the queue."

	^(self basicNew)
		initialize: anInteger;
		yourself! !

!Core.SharedQueue class categoriesForMethods!
initialize!development!initializing!private! !
new!instance creation!public! !
new:!instance creation!public! !
!

