"Filed out from Dolphin Smalltalk"!

Net.SocketAbstract
	subclass: #'Net.Socket'
	instanceVariableNames: 'address readStream writeStream isText'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Net.Socket guid: (Core.GUID fromString: '{dfa0db01-8f76-4b2a-a19c-002ecf488fdc}')!

Net.Socket comment: 'This class represents a socket for one end of a TCP/IP network communication link. Sockets can be instantiated to be associated with a specified port on a host computer at a given internet address. Once a connection is made using `#connect` the underlying communication mechanism uses a stream-based protocol rather than the alternative unreliable datagram-based protocol.

When connected, a `Net.Socket` can be used to transfer `ByteArray`s or `String`s or (rather more inefficiently) individual bytes across the network using `#sendByteArray:`, `#sendByte:`, `#receiveByteArray:` and `#receiveByte:` methods. For more flexible and efficient transfers, a `Net.Socket` maintains buffered read and write streams that are accessible via the `#readStream` and `#writeStream` methods respectively. To transfer entire objects, an appropriate STBFiler may be opened on the streams.

Most operations (connect, read or write) will block while waiting for data to arrive or be sent. In general such calls should be made from within a background process.'!

!Net.Socket categoriesForClass!Windows Sockets! !

!Net.Socket methodsFor!

address
	"Answer the InternetAddress of the host that the receiver is connected to"

	^address!

connect
	"Connect to a server socket."

	| socketAddress |
	self isOpen ifFalse: [self create].
	socketAddress := SOCKADDR_IN new
				sin_family: AF_INET;
				port: self port;
				sin_addr: (IN_ADDR address: self address);
				yourself.
	Ws2_32
		connect: self asParameter
		name: socketAddress
		namelen: socketAddress byteSize!

errorNotPositionable
	^self error: 'Sockets are not positionable'!

hasInput
	"Private - Answer whether there is any data ready for reading from the socket,
	Answer false if socket is closed or has no data available to read."

	| fdSet result timeOut |
	self isOpen ifFalse: [^false].
	fdSet := FD_SET new.
	fdSet fd_count: 1.
	fdSet fd_array at: 1 put: self asParameter.
	timeOut := TIMEVAL new.
	result := Ws2_32
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
	winSockAddrLen := Int32 new.
	winSockAddrLen value: winSockAddr byteSize.
	(Ws2_32
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

position
	"Part of the <writeableMedium> protocol used by <ExternalWriteStream>, but sockets cannot be positioned."

	self errorNotPositionable!

position: anInteger
	"Part of the <writeableMedium> protocol used by <ExternalWriteStream>, but sockets cannot be positioned."

	self errorNotPositionable!

read: aByteObject 
	"Read some data from the socket into byte object argument. The current process is blocked until the some data is available to read, but the method will return as soon as some data has been read. Answer the actual number of bytes read, which may be fewer than the number requested. If the socket is closed, or becomes closed, signal a <SocketClosed>  exception. Any other error will result in a <SocketError> exception being raised."

	^self read: aByteObject count: aByteObject size!

read: aByteObject count: anInteger 
	"Read data from the socket up to a maxiumum of <integer> lengthInteger bytes into the buffer, aByteObject. The buffer must be large enough to accommodate the data, or a buffer overrun may occur. The current process is blocked until the some data is available to read. Answer the actual number of bytes read, which may be fewer than the number requested. If the socket is closed, or becomes closed, signal a <SocketClosed>  exception. Any other error will result in a <SocketError> exception being raised."

	^self 
		read: aByteObject
		count: anInteger
		startingAt: 1!

read: aByteObject count: lengthInteger startingAt: startInteger
	"Read data from the socket up to a maxiumum of <integer> lengthInteger bytes into the buffer, aByteObject, starting at <integer> position, startInteger. The buffer must be large enough to accommodate the data, or a buffer overrun may occur. The current process is blocked until the some data is available to read. Answer the actual number of bytes read, which may be fewer than the number requested. If the socket is closed, or becomes closed, then zero bytes may be read. Any other error condition will result in a <SocketError> exception being raised."

	| bytesReceived |
	bytesReceived := Ws2_32
				recv: self asParameter
				buf: aByteObject yourAddress + startInteger - 1
				len: lengthInteger
				flags: 0.
	bytesReceived >= 0 ifTrue: [^bytesReceived].
	^self socketErrorOverlap!

readStream
	"Answer an `ExternalReadStream` for streaming data from the receiver."

	^readStream ifNil: [readStream := ExternalReadStream on: self text: self isText]!

receive: buffer 
	"Receive anInteger bytes from the socket and answer this data as a ByteArray of exactly this length. The current process is blocked until the operation has completed."

	^self receive: buffer count: buffer size!

receive: aByteObject count: anInteger 
	"Read data from the socket of <integer> byte length, lengthInteger, into the buffer, aByteObject. The buffer must be large enough to accommodate the data, or a buffer overrun will occur. The current process is blocked until sufficient data is available to satisfy the request. If the socket is closed, or becomes closed, signal a <SocketClosed>  exception. Any other error will result in a <SocketError> exception being raised."

	^self 
		receive: aByteObject
		count: anInteger
		startingAt: 1!

receive: aByteObject count: countInteger startingAt: startInteger
	"Read data from the socket of <integer> byte length, lengthInteger, into the buffer, aByteObject, starting at <integer> position, startInteger. The buffer must be large enough to accommodate the data, or a buffer overrun will occur. The current process is blocked until sufficient data is available to satisfy the request. If the socket is closed, or becomes closed, signal a <SocketClosed>  exception. Any other error will result in a <SocketError> exception being raised."

	| received |
	received := 0.
	[received < countInteger] whileTrue: 
			[| read |
			read := self
						read: aByteObject
						count: countInteger
						startingAt: received + startInteger.
			read == 0 ifTrue: [self errorSocketClosed].
			received := received + read].
	^aByteObject!

receiveByte
	"Receive and answer a single byte from the socket. The current process is blocked until the operation has completed."

	| buffer |
	buffer := ByteArray new: 1.
	self receive: buffer.
	^buffer first!

send: aByteObject 
	"Write aByteObject to the receiver. The current process is blocked until
	the operation has completed."

	self send: aByteObject count: aByteObject size!

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
	result := Ws2_32
				send: self asParameter
				buf: aByteObject yourAddress + startInteger - 1
				len: lengthInteger
				flags: 0.
	result = SOCKET_ERROR ifTrue: [^self socketErrorOverlap].
	^result!

write: aByteObject count: anInteger 
	self 
		send: aByteObject
		count: anInteger
		startingAt: 1!

write: aByteObject count: countInteger startingAt: startInteger 
	| sent |
	sent := 0.
	[sent < countInteger] whileTrue: 
			[sent := sent + (self 
								sendSome: aByteObject
								count: countInteger - sent
								startingAt: sent + startInteger)]!

writeStream
	"Answer an `ExternalWriteStream` for streaming data to the receiver. Note that if stream is explicitly closed, the socket will be closed."

	^writeStream
		ifNil: 
			[writeStream := (ExternalWriteStream on: self text: self isText)
						ownsMedium: true;
						yourself]! !

!Net.Socket categoriesForMethods!
address!accessing!public! !
connect!operations!public! !
errorNotPositionable!exceptions!private! !
hasInput!private!testing! !
initialize!initializing!private! !
isText!public! !
isText:!accessing!public! !
peerAddress!accessing!public! !
port:address:!initializing!private! !
position!public! !
position:!public! !
read:!operations!public! !
read:count:!operations!public! !
read:count:startingAt:!operations!public! !
readStream!accessing!public! !
receive:!operations!public! !
receive:count:!operations!public! !
receive:count:startingAt:!operations!public! !
receiveByte!operations!public! !
send:!operations!public! !
sendByte:!operations!public! !
sendSome:count:startingAt:!operations!private! !
write:count:!operations!public! !
write:count:startingAt:!operations!public! !
writeStream!accessing!public! !
!

Net.Socket methodProtocol: #writeableMedium attributes: #(#readOnly) selectors: #(#close #isOpen #position #position: #write:count:)!

!Net.Socket class methodsFor!

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

!Net.Socket class categoriesForMethods!
descriptor:port:address:!instance creation!public! !
new!instance creation!private! !
port:address:!instance creation!public! !
port:host:!instance creation!public! !
port:ipAddress:!instance creation!public! !
!

