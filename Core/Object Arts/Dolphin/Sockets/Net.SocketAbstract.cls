"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SocketAbstract
	instanceVariableNames: 'port descriptor asyncError events'
	classVariableNames: 'AllSockets WaitingSemaphores'
	poolDictionaries: 'WinSocketConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
SocketAbstract guid: (GUID fromString: '{87b4c4bb-026e-11d3-9fd7-00a0cc3e4a32}')!
SocketAbstract isAbstract: true!
SocketAbstract comment: '** This class is part of the old asynchronous Sockets Connection package which has been superseded by the Dolphin Sockets package **

This class is the abstract superclass of all sockets classes for TCP/IP network communication.'!
!SocketAbstract categoriesForClass!Windows Sockets! !
!SocketAbstract methodsFor!

allowAsyncEvents
	"Private - Use the services of the WinAsyncSocket singleton to handle
	asynchronous WSA events. These events will be routed back to us
	in the form of onAsyncXxxxx messages."

	WinAsyncSocket default monitorSocket: self!

asParameter
	"Answer the receiver in a form suitable for passing to an external function."

	^self descriptor!

asyncError
	"Answer the asyncError instance variable."

	^asyncError!

asyncError: aSocketError 
	"Private - Set the asyncError instance variable to aSocketError."

	asyncError := aSocketError!

cancel
	"Cancel a pending accept request. Will asynchronously signal
	a SocketWaitCancelled error"

	self asyncError: SocketWaitCancelled new.
	self cancelWait!

cancelWait
	"Private - Cancel a pending accept request"

	self subclassResponsibility!

close
	"Close the socket."

	self descriptor notNil 
		ifTrue: 
			[WSockLibrary default closesocket: self descriptor.
			self unregisterDescriptor.
			self descriptor: nil]!

create
	"Private - Create a new socket."

	self descriptor: (WSockLibrary default 
				socket: AF_INET
				type: SOCK_STREAM
				protocol: 0).
	self descriptor = INVALID_SOCKET ifTrue: [self error]!

descriptor
	"Private - Answer the descriptor instance variable."

	^descriptor!

descriptor: anIntegerOrNil 
	"Private - Set the descriptor instance variable to anIntegerOrNil."

	descriptor := anIntegerOrNil!

error
	"Private - Throw a SocketError exception.
	We MUST do the wsaGetLastError here rather than leaving it to the SocketError class.
	Otherwise it is possible (especially with loading classes from STC files) that the 
	last error is lost by the time it is fished out by SocketError."

	SocketError signalWith: WSockLibrary default wsaGetLastError!

finalize
	"Private - Sent when the object no longer has any strong references to it.
	Frees the external resources by closing the socket."

	self close!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

initialize
	"Private - Initialize the receiver."

	self beFinalizable!

isOpen
	"Answer true if the receiver is open"

	^self descriptor notNil!

onAsyncAccept
	"Private - Handle the notification of an asynchronous accept event."

	^self subclassResponsibility!

onAsyncClose
	"Private - Handle the notification of an asynchronous close event. Triggers a
	#remoteSocketClosed event"

	self asyncError: SocketClosed new.
	self cancelWait.
	self trigger: #remoteSocketClosed!

onAsyncError: errorCode 
	"Private - Handle the notification of an asynchronous error event."

	| socketError |
	socketError := (SocketError new)
				tag: errorCode;
				yourself.
	self asyncError: socketError.
	self cancelWait!

onAsyncRead
	"Private - Handle the notification of an asynchronous read event."

	^self subclassResponsibility!

onAsyncWrite
	"Private - Handle the notification of an asynchronous write event."

	^self subclassResponsibility!

onShutdown
	"Private - Perform any shutdown processing."

	self close!

onStartup
	"Private - Perform any startup processing."

	self descriptor: nil!

port
	"Answer the port instance variable."

	^port!

port: anInteger 
	"Private - Set the port instance variable to anInteger."

	port := anInteger!

printOn: aStream 
	"Append, to aStream, a String whose characters are a description
	of the receiver as a developer would want to see it."

	aStream
		basicPrint: self;
		nextPut: $(;
		display: self descriptor;
		nextPut: $)!

queryPort
	"Lookup the port using getsockname().  Answer the result as a SmallInteger,
	or signal a socket error."

	| name nameLength |
	name := (SOCKADDR_IN new)
				sin_family: AF_INET;
				yourself.
	nameLength := (SDWORD new)
				value: name size;
				yourself.
	(WSockLibrary default 
		getsockname: self asParameter
		name: name
		namelen: nameLength) < 0 
		ifTrue: [self error].
	^name port!

registerDescriptor
	"Private - Add the receiver to the AllSockets class variable."

	self class addSocket: self!

setEvents: anEventsCollectionOrNil 
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

unregisterDescriptor
	"Private - Remove the receiver from the AllSockets class variable."

	self class removeSocket: self!

waitOn: aSemaphore 
	"Private - Asks the receiver to wait on aSemaphore. Add the semaphore to the 
	set of waiting semaphores during this period"

	"If we are executing on the user interface process we must ensure that another is started.
	Otherwise the message loop will be blocked and we will not be able to receive the 
	#onAsyncXXX messages"

	Processor forkMainIfMain.
	self asyncError: nil.
	self class waitingSemaphores add: aSemaphore.
	[aSemaphore wait] ensure: [self class waitingSemaphores remove: aSemaphore ifAbsent: []].
	self asyncError isNil ifFalse: [self asyncError signal]! !
!SocketAbstract categoriesFor: #allowAsyncEvents!operations!private! !
!SocketAbstract categoriesFor: #asParameter!converting!public! !
!SocketAbstract categoriesFor: #asyncError!accessing!public! !
!SocketAbstract categoriesFor: #asyncError:!accessing!private! !
!SocketAbstract categoriesFor: #cancel!operations!public! !
!SocketAbstract categoriesFor: #cancelWait!operations!private! !
!SocketAbstract categoriesFor: #close!operations!public! !
!SocketAbstract categoriesFor: #create!operations!private! !
!SocketAbstract categoriesFor: #descriptor!accessing!private! !
!SocketAbstract categoriesFor: #descriptor:!accessing!private! !
!SocketAbstract categoriesFor: #error!exceptions!private! !
!SocketAbstract categoriesFor: #finalize!finalizing!private! !
!SocketAbstract categoriesFor: #getEvents!events!private! !
!SocketAbstract categoriesFor: #initialize!initializing!private! !
!SocketAbstract categoriesFor: #isOpen!public!testing! !
!SocketAbstract categoriesFor: #onAsyncAccept!event handling!private! !
!SocketAbstract categoriesFor: #onAsyncClose!event handling!private! !
!SocketAbstract categoriesFor: #onAsyncError:!event handling!private! !
!SocketAbstract categoriesFor: #onAsyncRead!event handling!private! !
!SocketAbstract categoriesFor: #onAsyncWrite!event handling!private! !
!SocketAbstract categoriesFor: #onShutdown!event handling!private! !
!SocketAbstract categoriesFor: #onStartup!event handling!private! !
!SocketAbstract categoriesFor: #port!accessing!public! !
!SocketAbstract categoriesFor: #port:!accessing!private! !
!SocketAbstract categoriesFor: #printOn:!printing!public! !
!SocketAbstract categoriesFor: #queryPort!accessing!public! !
!SocketAbstract categoriesFor: #registerDescriptor!operations!private! !
!SocketAbstract categoriesFor: #setEvents:!events!private! !
!SocketAbstract categoriesFor: #unregisterDescriptor!operations!private! !
!SocketAbstract categoriesFor: #waitOn:!operations!private! !

!SocketAbstract class methodsFor!

addSocket: aSocket 
	"Private - Adds aSocket to AllSockets.
	Answers aSocket."

	self allSockets at: aSocket descriptor put: aSocket.
	^aSocket!

allSockets
	"Private - Answers the IdentityDictionary AllSockets
	which maps socket descriptors to the corresponding Socket."

	AllSockets isNil ifTrue: [AllSockets := WeakLookupTable new].
	^AllSockets!

fromDescriptor: anInteger 
	"Answers a Socket or SocketServer that has the descriptor anInteger."

	^AllSockets at: anInteger
		ifAbsent: 
			["It is possible to receive outstanding messages for sockets which have recently closed."
			]!

initialize
	"Private - Register an interest in the #onStartup event.

	self initialize
"

	(SessionManager current)
		when: #sessionStarted
			send: #onStartup
			to: self;
		when: #sessionStopped
			send: #onShutdown
			to: self.

	"We've missed the #onStartup event this time, so do it ourselves."
	self onStartup!

onShutdown
	"Private - Perform any image shutdown operations."

	AllSockets ifNotNil: [:all | all values do: [:each | each onShutdown]]!

onStartup
	"Private - Perform any startup operations."

	"Clear down the set of waiting semaphores. Processes waiting on these
	semaphores will be garbage collected if they are not otherwise referenced"

	WaitingSemaphores := nil.
	AllSockets ifNotNil: [:all | all values do: [:each | each onStartup]]!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^(super publishedEventsOfInstances)
		add: #remoteSocketClosed;
		yourself!

removeSocket: aSocket 
	"Private - Removes aSocket from AllSockets.
	Answers aSocket."

	self allSockets removeKey: aSocket descriptor ifAbsent: [].
	^aSocket!

uninitialize
	SessionManager current removeEventsTriggeredFor: self!

waitingSemaphores
	"Private - Answers the Set of all the socket semaphores currently being waiting upon"

	WaitingSemaphores isNil ifTrue: [WaitingSemaphores := SharedSet new].
	^WaitingSemaphores! !
!SocketAbstract class categoriesFor: #addSocket:!accessing!private! !
!SocketAbstract class categoriesFor: #allSockets!accessing!private! !
!SocketAbstract class categoriesFor: #fromDescriptor:!instance creation!public! !
!SocketAbstract class categoriesFor: #initialize!initializing!private! !
!SocketAbstract class categoriesFor: #onShutdown!event handling!private! !
!SocketAbstract class categoriesFor: #onStartup!event handling!private! !
!SocketAbstract class categoriesFor: #publishedEventsOfInstances!development!events!public! !
!SocketAbstract class categoriesFor: #removeSocket:!accessing!private! !
!SocketAbstract class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!SocketAbstract class categoriesFor: #waitingSemaphores!accessing!private! !

