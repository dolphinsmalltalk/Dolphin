"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ThreadPool
	instanceVariableNames: 'maxPoolSize minPoolSize poolManager queueWorkers workQueue'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ThreadPool guid: (GUID fromString: '{219a54bd-a9ad-4ffd-9710-87ef11f841fa}')!
ThreadPool comment: ''!
!ThreadPool categoriesForClass!Kernel-Objects! !
!ThreadPool methodsFor!

adjustThreadPoolSize
	(Delay forSeconds: 1) wait.
	(queueWorkers anySatisfy: [:each | each isDead]) ifTrue: [self cleanDead].
	self isPoolTooSmall
		ifTrue: [self startWorker]
		ifFalse: [self isPoolTooBig ifTrue: [self killWorker]]!

cleanDead
	"Private - Clean dead processes, for example those kill when a debugger session ends
	on terminated by exception handling."

	self
		queueWorkItem: [queueWorkers removeAll: (queueWorkers select: [:each | each isDead])]
		expiresAt: (TimeStamp current addSeconds: 600)!

free
	self stop!

initialize
	super initialize.
	minPoolSize := 5.
	maxPoolSize := 15.
	workQueue := SharedQueue new.
	queueWorkers := SharedIdentitySet new.
	self beFinalizable
!

isPoolTooBig
	^queueWorkers size > minPoolSize and: [workQueue size < queueWorkers size]!

isPoolTooSmall
	^queueWorkers size < minPoolSize
		or: [workQueue size > queueWorkers size and: [queueWorkers size < maxPoolSize]]!

killWorker
	"Private - just queue a task that kill the activeProcess, 
    which will be the worker that picks it up"

	self
		queueWorkItem: [self isPoolTooBig ifTrue: [(queueWorkers remove: Processor activeProcess) terminate]]
		expiresAt: (TimeStamp current addSeconds: 600)!

processQueueElement
	workQueue next evaluate!

queueWorkItem: aBlock
	self queueWorkItem: aBlock expiresAt: (TimeStamp current addSeconds: 60)!

queueWorkItem: aBlock expiresAt: aTimestamp
	| worker |
	worker := ThreadWorker on: aBlock expires: aTimestamp.
	workQueue nextPut: worker.
	^worker!

start
	self stop.
	minPoolSize timesRepeat: [self startWorker].
	poolManager := [[self adjustThreadPoolSize] repeat] forkAt: Processor systemBackgroundPriority.
	poolManager name: 'ThreadPool manager'!

startWorker
	| process |
	process := queueWorkers
				add: ([[self processQueueElement] repeat] forkAt: Processor systemBackgroundPriority).
	process name: 'ThreadWorker process'!

stop
	queueWorkers do: [:each | each terminate].
	queueWorkers := SharedIdentitySet new.
	workQueue := SharedQueue new.
	poolManager
		ifNotNil: 
			[poolManager terminate.
			poolManager := nil].
	! !
!ThreadPool categoriesFor: #adjustThreadPoolSize!private! !
!ThreadPool categoriesFor: #cleanDead!private! !
!ThreadPool categoriesFor: #free!private! !
!ThreadPool categoriesFor: #initialize!private! !
!ThreadPool categoriesFor: #isPoolTooBig!private! !
!ThreadPool categoriesFor: #isPoolTooSmall!private! !
!ThreadPool categoriesFor: #killWorker!private! !
!ThreadPool categoriesFor: #processQueueElement!private! !
!ThreadPool categoriesFor: #queueWorkItem:!public! !
!ThreadPool categoriesFor: #queueWorkItem:expiresAt:!public! !
!ThreadPool categoriesFor: #start!public! !
!ThreadPool categoriesFor: #startWorker!private! !
!ThreadPool categoriesFor: #stop!public! !

!ThreadPool class methodsFor!

new
	^super new initialize! !
!ThreadPool class categoriesFor: #new!public! !

