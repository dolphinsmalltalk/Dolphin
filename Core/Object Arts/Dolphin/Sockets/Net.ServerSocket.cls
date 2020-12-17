"Filed out from Dolphin Smalltalk 7"!

Net.SocketAbstract subclass: #'Net.ServerSocket'
	instanceVariableNames: 'acceptSemaphore'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.ServerSocket guid: (Core.GUID fromString: '{87b4c6e0-026e-11d3-9fd7-00a0cc3e4a32}')!
Net.ServerSocket comment: '** This class is part of the old asynchronous Sockets Connection package which has been superseded by the Dolphin Sockets package **

This class is used by a server to listen for a connection request from a client. 

A ServerSocket is instantiated to listen on a particular port with a particular queue size for incoming client connections. Incoming connection requests will be acknowledged and placed on a queue waiting for the ServerSocket to accept them. This is done using #accept which then answers the socket for the next client connection in the queue. If the queue becomes full at any time because sufficient #accept calls have not been issued then additional client connections are rejected.'!
!Net.ServerSocket categoriesForClass!Windows Sockets! !
!Net.ServerSocket methodsFor!

accept
	"Start listening for a connection. This blocks the current process until a connection is accepted. 
	Answers a Socket representing the incoming connection and triggers a #connectionAccepted:
	event."

	| acceptedSocket |
	
	[| retry |
	retry := false.
	[acceptedSocket := self basicAccept] on: SocketWouldBlock do: [:e | retry := true].
	retry]
			whileTrue: [self waitAccept].
	self trigger: #connectionAccepted: with: acceptedSocket.
	^acceptedSocket!

acceptNoWait
	"Start listening for a connection. This does not block the current process but a
	#connectionAccepted: event will be triggered when a connection has been accepted."

	[self accept] fork!

basicAccept
	"Private - Accepts a connection on a socket. Answers the 
	connected socket or signals a SocketWouldBlock error if no connection
	is yet pending"

	| address length newDescriptor |
	address := SOCKADDR_IN new.
	length := DWORD new.
	length value: address byteSize.
	newDescriptor := WSockLibrary default
				accept: self asParameter
				addr: address asParameter
				addrlen: length.
	newDescriptor = INVALID_SOCKET ifTrue: [self error].
	^Socket
		descriptor: newDescriptor
		port: address sin_port
		address: address sin_addr address!

bind
	"Private - Associates a local address with a socket."

	| result socketAddress |
	socketAddress := SOCKADDR_IN new.
	socketAddress sin_family: AF_INET.
	socketAddress sin_addr s_addr: INADDR_ANY.
	socketAddress port: self port.
	result := WSockLibrary default
				bind: self asParameter
				addr: socketAddress asParameter
				namelen: socketAddress byteSize.
	result = 0 ifFalse: [self error]!

bindPort: anInteger 
	"Private - Create a socket on anIntegerPort and bind to it. The socket is 
	not yet listening for connections."

	self
		port: anInteger;
		create;
		registerDescriptor;
		allowAsyncEvents;
		bind!

cancelWait
	"Private - Cancel a pending accept request"

	self class waitingSemaphores remove: acceptSemaphore signal ifAbsent: []!

close
	"Close the socket and kill the acceptance process."

	acceptSemaphore terminateProcess.
	super close!

initialize
	"Private - Initialize the receiver."

	super initialize.
	acceptSemaphore := Semaphore new!

listen: anIntegerBacklog
	"Private - Listen for incoming connections. The receiver can acknowledge anIntegerBacklog
	number of connection requests, placing each in a queue, before any are actually accepted 
	using #accept."

	| result |
	result := WSockLibrary default listen: self asParameter backlog: anIntegerBacklog.
	result = 0 ifFalse: [self error]!

onAsyncAccept
	"Private - Handle the notification of an asynchronous accept event."

	acceptSemaphore signal!

waitAccept
	"Private - Wait on the acceptSemaphore until a connection is accepted."

	self waitOn: acceptSemaphore! !
!Net.ServerSocket categoriesFor: #accept!operations!public! !
!Net.ServerSocket categoriesFor: #acceptNoWait!operations!public! !
!Net.ServerSocket categoriesFor: #basicAccept!operations!private! !
!Net.ServerSocket categoriesFor: #bind!operations!private! !
!Net.ServerSocket categoriesFor: #bindPort:!operations!private! !
!Net.ServerSocket categoriesFor: #cancelWait!operations!private! !
!Net.ServerSocket categoriesFor: #close!operations!public! !
!Net.ServerSocket categoriesFor: #initialize!initializing!private! !
!Net.ServerSocket categoriesFor: #listen:!operations!private! !
!Net.ServerSocket categoriesFor: #onAsyncAccept!event handling!private! !
!Net.ServerSocket categoriesFor: #waitAccept!operations!private! !

!Net.ServerSocket class methodsFor!

defaultMaxPendingConnects
	"Answer the default maximum number of pending connects that can be acknowledged 
	without being accepted."

	^16!

new
	"Answer an initialized instance of the receiver"

	^super new initialize!

port: anIntegerPort 
	"Answer a new instance of the receiver set up to listen on anIntegerPort. The instance will
	be able to queue and number of pending connection requests as given by #defaultPendingConnects"

	^self port: anIntegerPort backlog: self defaultMaxPendingConnects!

port: anIntegerPort backlog: anIntegerBacklog 
	"Answer a new instance of the receiver set up to listen on anIntegerPort. The instance will
	be capable of acknowledging anIntegerBacklog number of connection requests before
	any are actually accepted."

	^(self new)
		bindPort: anIntegerPort;
		listen: anIntegerBacklog;
		yourself!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^(super publishedEventsOfInstances)
		add: #connectionAccepted:;
		yourself! !
!Net.ServerSocket class categoriesFor: #defaultMaxPendingConnects!constants access!public! !
!Net.ServerSocket class categoriesFor: #new!instance creation!public! !
!Net.ServerSocket class categoriesFor: #port:!instance creation!public! !
!Net.ServerSocket class categoriesFor: #port:backlog:!instance creation!public! !
!Net.ServerSocket class categoriesFor: #publishedEventsOfInstances!development!events!public! !

