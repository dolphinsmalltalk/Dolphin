"Filed out from Dolphin Smalltalk 7"!

SocketAbstract2 subclass: #Socket2
	instanceVariableNames: 'address readStream writeStream isText'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Socket2 guid: (GUID fromString: '{dfa0db01-8f76-4b2a-a19c-002ecf488fdc}')!
Socket2 comment: 'This class represents a socket for one end of a TCP/IP network communication link. Sockets can be instantiated to be associated with a specified port on a host computer at a given internet address. Once a connection is made using #connect the underlying communication mechanism uses a stream-based protocol rather than the alternative unreliable datagram-based protocol.

When connected, a Socket2 can be used to transfer ByteArrays or Strings or (rather more inefficiently) individual bytes across the network using #sendByteArray:, #sendByte:, receiveByteArray: and #receiveByte: methods. For more flexible and efficient transfers, a Socket2 maintains buffered read and write streams that are accessible via the #readStream and #writeStream methods respectively. To transfer entire objects, an appropriate STBFiler may be opened on the streams.

Most operations (connect, read or write) will block while waiting for data to arrive or be sent. In general such calls should be made from within a background process.'!
!Socket2 categoriesForClass!Windows Sockets! !
!Socket2 methodsFor!

address
	"Answer the InternetAddress of the host that the receiver is connected to"

	^address!

connect
	"Connect to a server socket."

	| result socketAddress |
	self isOpen ifFalse: [self create].
	(socketAddress := SOCKADDR_IN new)
		sin_family: AF_INET;
		port: self port;
		sin_addr: (IN_ADDR address: self address).
	result := WS2_32Library default
				connect: self asParameter
				name: socketAddress
				namelen: socketAddress byteSize.
	result = SOCKET_ERROR ifTrue: [^self socketErrorOverlap]!

hasInput
	"Private - Answer whether there is any data ready for reading from the socket,
	answer false if socket is closed or has not data available to read."

	| fdSet result timeOut |
	self isOpen ifFalse: [^false].
	fdSet := FD_SET new.
	fdSet fd_count: 1.
	fdSet fd_array at: 1 put: self asParameter.
	timeOut := TIMEVAL new.
	result := WS2_32Library default 
				select: 0
				readfds: fdSet
				writefds: nil
				exceptfds: nil
				timeout: timeOut.
	^result asBoolean!

initialize
	"Private - Initialize the receiver."

	self isText: false.
	^super initialize!

isText
	"Answer whether the receiver streams bytes or characters."

	^isText!

isText: aBoolean 
	"Set whether the receiver streams bytes or characters."

	isText := aBoolean.
	readStream isNil ifFalse: [readStream isText: aBoolean].
	writeStream isNil ifFalse: [writeStream isText: aBoolean]!

peerAddress
	"Answer an <InternetAddress> representing the address of the peer machine."

	| winSockAddr winSockAddrLen |
	winSockAddr := SOCKADDR_IN new.
	winSockAddrLen := SDWORD new.
	winSockAddrLen value: winSockAddr byteSize.
	(WS2_32Library default 
		getpeername: self asParameter
		name: winSockAddr
		namelen: winSockAddrLen) = SOCKET_ERROR 
		ifTrue: [^self socketError].
	^InternetAddress ipAddress: winSockAddr sin_addr!

port: anIntegerPort address: anInternetAddress 
	"Private - Initialize the receiver to connect to anIntegerPort on the host
	identified by anInternetAddress"

	port := anIntegerPort.
	address := anInternetAddress!

readStream
	"Answer (lazily) the readStream instance variable."

	readStream isNil ifTrue: [readStream := SocketReadStream on: self text: self isText].
	^readStream!

receive: buffer 
	"Receive anInteger bytes from the socket and answer this data as a ByteArray
	of exactly this length. The current process is blocked until the operation has completed."

	^self receive: buffer count: buffer size!

receive: aByteObject count: anInteger 
	^self 
		receive: aByteObject
		count: anInteger
		startingAt: 1!

receive: aByteObject count: countInteger startingAt: startInteger 
	| received |
	received := 0.
	[received < countInteger] whileTrue: 
			[received := received + (self 
								receiveSome: aByteObject
								count: countInteger
								startingAt: received + startInteger)].
	^aByteObject!

receiveByte
	"Receive and answer a single byte from the socket. The current process is blocked until
	the operation has completed."

	| buffer |
	buffer := ByteArray new: 1.
	self receive: buffer.
	^buffer first!

receiveSome: aByteObject count: lengthInteger startingAt: startInteger 
	"Private - Receive bytes from the socket up to a maxiumum of lengthInteger bytes
	into the buffer, aByteObject. Note that the buffer must be large enough	
	to accomodate the data, or memory corruption may occur.
	The current process is blocked until the some data is available to read. 
	Answer the actual number of bytes read, which may be fewer than the 
	number requested. If the socket is closed, or becomes closed, signal a <SocketClosed> 
	exception. Any other error will result in a <SocketError> exception being raised."

	| bytesReceived |
	bytesReceived := WS2_32Library default 
				recv: self asParameter
				buf: aByteObject yourAddress + startInteger - 1
				len: lengthInteger
				flags: 0.
	bytesReceived > 0 ifTrue: [^bytesReceived].
	bytesReceived = 0 ifTrue: [^self errorSocketClosed].
	^self socketErrorOverlap!

send: aByteObject 
	"Write aByteObject to the receiver. The current process is blocked until
	the operation has completed."

	self send: aByteObject count: aByteObject size!

send: aByteObject count: anInteger 
	self 
		send: aByteObject
		count: anInteger
		startingAt: 1!

send: aByteObject count: countInteger startingAt: startInteger 
	| sent |
	sent := 0.
	[sent < countInteger] whileTrue: 
			[sent := sent + (self 
								sendSome: aByteObject
								count: countInteger - sent
								startingAt: sent + startInteger)]!

sendByte: anInteger 
	"Write a single byte with value anInteger to the socket. The current process is blocked until
	the operation has completed."

	^self send: (ByteArray with: anInteger)!

sendSome: aByteObject count: lengthInteger startingAt: startInteger 
	"Private - Write lengthInteger bytes from aByteObject starting its
	element at startInteger. Answer the number of bytes actually sent,
	which may be less than lengthInteger. The current process is blocked 
	until at least some data has been sent."

	| result |
	result := WS2_32Library default 
				send: self asParameter
				buf: aByteObject yourAddress + startInteger - 1
				len: lengthInteger
				flags: 0.
	result = SOCKET_ERROR ifTrue: [^self socketErrorOverlap].
	^result!

writeStream
	"Answer (lazily) the writeStream instance variable."

	writeStream isNil ifTrue: [writeStream := SocketWriteStream on: self text: self isText].
	^writeStream! !
!Socket2 categoriesFor: #address!accessing!public! !
!Socket2 categoriesFor: #connect!operations!public! !
!Socket2 categoriesFor: #hasInput!private!testing! !
!Socket2 categoriesFor: #initialize!initializing!private! !
!Socket2 categoriesFor: #isText!public! !
!Socket2 categoriesFor: #isText:!accessing!public! !
!Socket2 categoriesFor: #peerAddress!accessing!public! !
!Socket2 categoriesFor: #port:address:!initializing!private! !
!Socket2 categoriesFor: #readStream!accessing!public! !
!Socket2 categoriesFor: #receive:!operations!public! !
!Socket2 categoriesFor: #receive:count:!operations!public! !
!Socket2 categoriesFor: #receive:count:startingAt:!operations!public! !
!Socket2 categoriesFor: #receiveByte!operations!public! !
!Socket2 categoriesFor: #receiveSome:count:startingAt:!operations!private! !
!Socket2 categoriesFor: #send:!operations!public! !
!Socket2 categoriesFor: #send:count:!operations!public! !
!Socket2 categoriesFor: #send:count:startingAt:!operations!public! !
!Socket2 categoriesFor: #sendByte:!operations!public! !
!Socket2 categoriesFor: #sendSome:count:startingAt:!operations!private! !
!Socket2 categoriesFor: #writeStream!accessing!public! !

!Socket2 class methodsFor!

descriptor: anInteger port: anIntegerPort address: anInternetAddress 
	"Answers a new instance of the receiver with socket descriptor anInteger."

	^(super new)
		initialize;
		port: anIntegerPort address: anInternetAddress;
		descriptor: anInteger;
		yourself!

new
	"Private - Not available"

	^self shouldNotImplement!

port: anIntegerPort address: anInternetAddress 
	"Answers a new instance of the receiver for anIntegerPort on the host identified
	by anInternetAddress."

	^(super new)
		initialize;
		port: anIntegerPort address: anInternetAddress;
		yourself!

port: anIntegerPort host: aStringHostName 
	"Answers a new instance of the receiver with anIntegerPort and
	aStringHostName."

	^self port: anIntegerPort address: (InternetAddress host: aStringHostName)!

port: anIntegerPort ipAddress: aByteArray 
	"Answers a new instance of the receiver for anIntegerPort on the host identified by the
	IP address in aByteArray"

	^self port: anIntegerPort address: (InternetAddress ipAddress: aByteArray)! !
!Socket2 class categoriesFor: #descriptor:port:address:!instance creation!public! !
!Socket2 class categoriesFor: #new!instance creation!private! !
!Socket2 class categoriesFor: #port:address:!instance creation!public! !
!Socket2 class categoriesFor: #port:host:!instance creation!public! !
!Socket2 class categoriesFor: #port:ipAddress:!instance creation!public! !

