"Filed out from Dolphin Smalltalk 7"!

Object subclass: #BlockingCallMonitor
	instanceVariableNames: 'callBlock completionBlock errorBlock monitorProcess priority'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BlockingCallMonitor guid: (GUID fromString: '{87b4c45b-026e-11d3-9fd7-00a0cc3e4a32}')!
BlockingCallMonitor comment: 'This class can be used to monitor the progress of blocking calls running on a separate process.

A BlockingCallMonitor instance can be configured to evaluate a particular block or monadic valuable (set using #callBlock:) on it''s own process. The process can be started using either #monitorOnce or #monitor depending on whether the call should be made once or repeatedly. It is expected that the call will block this process for a period of time. When the call does eventually complete, the BlockingCallMonitor is responsible for evaluating another block or monadic valuable (set using #completionBlock:). This is passed the result of the call as its argument. Should an error occur during the evaluation of the blocking call then the monitor will choose to evaluate its error block (set using #errorBlock:).

A BlockingCallMonitor must always be provided with a callBlock but does provide defaults for the completionBlock and errorBlock. The former triggers a #completedWith: event off the monitor object whilst the latter simply re-signals the error. 

By default, the monitor process is run at the same priority as the process that instantiated the BlockingCallMonitor object. This can, however, be changed using #priority: prior to commencement of monitoring. Once started, an active monitor process should always be terminated to ensure that the BlockingCallMonitor can be successfully garbage collected.

This class is useful in situations where a known blocking call is to be made, either singly or repeatedly, and you need to be informed when the call has completed or signalled an error. It simplifies the requirement to start a backgound process to perform and monitor the call by encapulating it within a re-useable class.'!
!BlockingCallMonitor categoriesForClass!Windows Sockets! !
!BlockingCallMonitor methodsFor!

callBlock: aNiladicValuable 
	"Set the valuable that is evaluated for the blocking call, to aNiladicValuable."

	callBlock := aNiladicValuable!

completionBlock: aMonadicValuable 
	"Set the valuable that is evaluated when the blocking call completes, to aMonadicValuable.
	The argument to this is expected to be the answer returned from the call"

	completionBlock := aMonadicValuable!

errorBlock: aMonadicValuable 
	"Set the valuable that is evaluated when the blocking call signals an error, to aMonadicValuable.
	The argument to this is the Exception that occurred during the call"

	errorBlock := aMonadicValuable!

initialize
	"Private - Initialize the receiver"

	self
		completionBlock: [:x1 | self trigger: #completedWith: with: x1];
		errorBlock: [:x | x signal];
		priority: Processor activePriority!

makeCall
	"Private - Evaluates the receiver's callBlock. This will block until the operation completes, when the
	receiver's completionBlock will be evaluated with the result of the call as it's single argument. 
	If an error is signalled during the call then the receiver's errorBlock will be evaluated and 
	passed the Exception as its argument."

	[completionBlock value: callBlock value] on: Error do: [:x | errorBlock value: x]!

monitor
	"Start a process to repeatedly monitor the receiver's blocking call"

	self terminate.
	monitorProcess := [[self makeCall] repeat] forkAt: self priority!

monitorOnce
	"Start a process to monitor the receiver's blocking call once only"

	self terminate.
	monitorProcess := [self makeCall] forkAt: self priority!

priority
	"Answer the priority at which the blocking call will be run"

	^priority!

priority: anInteger 
	"Set the priority at which the blocking call will be run to anInteger"

	priority := anInteger!

terminate
	"Terminate any current monitor process"

	monitorProcess notNil 
		ifTrue: 
			[| mp |
			mp := monitorProcess.
			monitorProcess := nil.
			mp terminate]! !
!BlockingCallMonitor categoriesFor: #callBlock:!accessing!public! !
!BlockingCallMonitor categoriesFor: #completionBlock:!accessing!public! !
!BlockingCallMonitor categoriesFor: #errorBlock:!accessing!public! !
!BlockingCallMonitor categoriesFor: #initialize!initializing!private! !
!BlockingCallMonitor categoriesFor: #makeCall!operations!private! !
!BlockingCallMonitor categoriesFor: #monitor!operations!public! !
!BlockingCallMonitor categoriesFor: #monitorOnce!operations!public! !
!BlockingCallMonitor categoriesFor: #priority!accessing!public! !
!BlockingCallMonitor categoriesFor: #priority:!accessing!public! !
!BlockingCallMonitor categoriesFor: #terminate!operations!public! !

!BlockingCallMonitor class methodsFor!

callBlock: aMonadicValuable 
	"Answer an instance of the receiver ready to monitor the blocking call to be evaluated 
	by aMonadicValuable"

	^(self new)
		callBlock: aMonadicValuable;
		yourself!

new
	"Answer a new, initialized instance of the receiver"

	^super new initialize!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^(super publishedEventsOfInstances)
		add: #completedWith:;
		yourself! !
!BlockingCallMonitor class categoriesFor: #callBlock:!instance creation!public! !
!BlockingCallMonitor class categoriesFor: #new!instance creation!public! !
!BlockingCallMonitor class categoriesFor: #publishedEventsOfInstances!development!events!public! !

