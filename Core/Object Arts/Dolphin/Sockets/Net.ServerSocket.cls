﻿"Filed out from Dolphin Smalltalk"!

Net.SocketAbstract
	subclass: #'Net.ServerSocket'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Net.ServerSocket guid: (Core.GUID fromString: '{13ab65d3-5229-4982-9d9c-fb0a6fea8376}')!

Net.ServerSocket comment: 'This class is used by a server to listen for a connection request from a socket client. 

`A Net.ServerSocket` is instantiated to listen on a particular port with a particular queue size for incoming client connections. Incoming connection requests will be acknowledged and placed on a queue waiting for the `Net.ServerSocket` to accept them. This is done using #accept which then answers the socket for the next client connection in the queue. If the queue becomes full at any time because sufficient `#accept` calls have not been issued then additional client connections are rejected. The `#accept` call blocks the calling `Process` until an incoming connection request is available, and so should ideally be performed from a background process dedicated to the job.'!

!Net.ServerSocket categoriesForClass!Windows Sockets! !

!Net.ServerSocket methodsFor!

accept
	"Start listening for a connection. This blocks the current process until a connection is accepted. 
	Answers a Socket representing the incoming connection and triggers a #connectionAccepted:
	event."

	| address length newDescriptor |
	address := SOCKADDR_IN new.
	length := UInt32 new.
	length value: address byteSize.
	newDescriptor := Ws2_32
				accept: self asParameter
				addr: address
				addrlen: length.
	newDescriptor = INVALID_SOCKET ifTrue: [self socketErrorOverlap].
	^Socket
		descriptor: newDescriptor
		port: address sin_port
		address: address sin_addr address!

bind
	"Private - Associates a local address with a socket."

	| socketAddress |
	socketAddress := SOCKADDR_IN new.
	socketAddress sin_family: AF_INET.
	socketAddress sin_addr s_addr: INADDR_ANY.
	socketAddress port: self port.
	Ws2_32
		bind: self asParameter
		name: socketAddress
		namelen: socketAddress byteSize!

bindPort: anInteger 
	"Private - Create a socket on anIntegerPort and bind to it. The socket is 
	not yet listening for connections."

	self createOnPort: anInteger.
	self bind!

createOnPort: anInteger
	| dw |
	self
		port: anInteger;
		create.
	dw := UInt32 fromInteger: 1.
	"Set the re-use address option so can re-use server port without having to wait for timeout."
	Ws2_32
		setsockopt: self asParameter
		level: SOL_SOCKET
		optname: SO_REUSEADDR
		optval: dw asParameter
		optlen: dw byteSize!

listen: anIntegerBacklog
	"Private - Listen for incoming connections. The receiver can acknowledge anIntegerBacklog
	number of connection requests, placing each in a queue, before any are actually accepted 
	using #accept."

	| result |
	result := Ws2_32 listen: self asParameter backlog: anIntegerBacklog.
	result = SOCKET_ERROR ifTrue: [self socketError]!

preBindPort: anInteger 
	"Private - Same as #bindPort, but dont call bind."

	self createOnPort: anInteger! !

!Net.ServerSocket categoriesForMethods!
accept!operations!public! !
bind!operations!private! !
bindPort:!operations!private! !
createOnPort:!helpers!private! !
listen:!operations!private! !
preBindPort:!public!swazoo! !
!

!Net.ServerSocket class methodsFor!

defaultMaxPendingConnects
	"Answer the default maximum number of pending connects that can be acknowledged 
	without being accepted."

	^16!

new
	"Answer an initialized instance of the receiver"

	^super new initialize!

newPort: anIntegerPort 
	^(self new)
		createOnPort: anIntegerPort;
		yourself!

port: anIntegerPort 
	"Answer a new instance of the receiver set up to listen on anIntegerPort. The instance will
	be able to queue and number of pending connection requests as given by #defaultPendingConnects"

	^self port: anIntegerPort backlog: self defaultMaxPendingConnects!

port: anIntegerPort backlog: anIntegerBacklog 
	"Answer a new instance of the receiver set up to listen on anIntegerPort. The instance will
	be capable of acknowledging anIntegerBacklog number of connection requests before
	any are actually accepted."

	^(self newPort: anIntegerPort)
		bind;
		listen: anIntegerBacklog;
		yourself! !

!Net.ServerSocket class categoriesForMethods!
defaultMaxPendingConnects!constants access!public! !
new!instance creation!public! !
newPort:!public! !
port:!instance creation!public! !
port:backlog:!instance creation!public! !
!

