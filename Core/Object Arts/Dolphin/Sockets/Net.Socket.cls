"Filed out from Dolphin Smalltalk 7"!

Net.SocketAbstract subclass: #'Net.Socket'
	instanceVariableNames: 'address readSemaphore writeSemaphore connectSemaphore readStream writeStream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.Socket guid: (Core.GUID fromString: '{87b4c6e1-026e-11d3-9fd7-00a0cc3e4a32}')!
Net.Socket comment: '** This class is part of the old asynchronous Sockets Connection package which has been superseded by the Dolphin Sockets package **

This class represents a socket for one end of a TCP/IP network communication link. Sockets can be instantiated to be associated with a specified port on a host computer at a given internet address. Once a connection is made using #connect the underlying communication mechanism uses a stream-based protocol rather than the alternative unreliable datagram-based protocol.

When connected, a Socket can be used to transfer ByteArrays or (rather more inefficiently) individual bytes across the network using #sendByteArray:, #sendByte:, receiveByteArray: and #receiveByte: methods. For more flexible and efficient transfers, a Socket maintains buffered read and write streams that are accessible via the #readStream and #writeStream methods respectively. To transfer entire objects, an appropriate STBFiler may be opened on the streams. The #send: and #receive methods provide a default implementation for use when single or relatively infrequent object transfers are required.

Most operations (connect, read or write) will block while waiting for data to arrive or be sent. In general such calls should be made from within a background process. It is, however,  possible to use a Socket from the main user interface process without blocking by making use of the #connected and  #dataRead events that are triggered.'!
!Net.Socket categoriesForClass!Windows Sockets! !
!Net.Socket methodsFor!

address
	"Answer the InternetAddress of the host that the receiver is connected to"

	^address!

basicConnect
	"Private - Attempt a socket connection to a host."

	| result socketAddress |
	self create.
	(socketAddress := SOCKADDR_IN new)
		sin_family: AF_INET;
		port: self port;
		sin_addr: (IN_ADDR address: self address).
	result := WSockLibrary default
				connect: self asParameter
				name: socketAddress asParameter
				namelen: socketAddress byteSize.
	result = 0
		ifFalse: 
			["The call is overlapped, so any error that occurred will have been stored into the Process by the overlapped call primitive"
			SocketError signalWith: Processor activeProcess lastError].
	self
		registerDescriptor;
		allowAsyncEvents!

basicReceiveByte
	"Private - Receives a byte from the socket.
	Answers an Integer representing the byte."

	^(self basicReceiveByteArray: 1) first!

basicReceiveByteArray: anInteger
	"Private - Reads anInteger bytes from the socket.
	Answers a ByteArray representing the bytes read."

	| bytesReceived byteArray |
	byteArray := ByteArray new: anInteger.
	bytesReceived := WSockLibrary default
				recv: self asParameter
				buf: byteArray
				len: byteArray size
				flags: 0.
	bytesReceived > 0
		ifTrue: 
			["Success."
			^byteArray copyFrom: 1 to: bytesReceived].
	bytesReceived = 0
		ifTrue: 
			["Socket has been closed."
			SocketClosed signal].
	"Some other error."
	self error!

basicSendByte: anInteger 
	"Private - Sends a byte with value anInteger through the socket."

	^self basicSendByteArray: (ByteArray with: anInteger)!

basicSendByteArray: aByteArray
	"Private - Sends aByteArray through the socket."

	| result |
	result := WSockLibrary default
				send: self asParameter
				buf: aByteArray
				len: aByteArray size
				flags: 0.
	result = -1 ifTrue: [self error].
	^result!

cancelWait
	"Private - Signal all semaphores associated with the receiver."

	(self class waitingSemaphores)
		remove: (readSemaphore
					signal;
					reset)
			ifAbsent: [];
		remove: (writeSemaphore
					signal;
					reset)
			ifAbsent: [];
		remove: (connectSemaphore
					signal;
					reset)
			ifAbsent: []!

connect
	"Connect to the socket"

	| result |
	
	[| retry |
	retry := false.
	[result := self basicConnect] on: SocketWouldBlock do: [:e | retry := true].
	retry]
			whileTrue: [self waitConnect].
	^result!

connectNoWait
	"Connect to the socket to a ServerSocket without blocking. 
	A #connected event will be triggered off the receiver when a connection is made."

	[self connect] fork!

hasInput
	"Private - Answer whether there is any data ready for reading from the socket."

	| fdSet result timeOut |
	self isOpen ifFalse: [^false].
	fdSet := ByteArray new: ##(4 * (1 + 64)).
	timeOut := ByteArray new: ##(4 * 2).
	fdSet at: 1 put: 1.
	fdSet dwordAtOffset: 4 put: self descriptor.
	result := WSockLibrary default
				select: 0
				readfds: fdSet
				writefds: nil
				exceptfds: nil
				timeout: timeOut.
	^result asBoolean!

initialize
	"Private - Initialize the receiver."

	super initialize.
	readSemaphore := Semaphore new.
	writeSemaphore := Semaphore new.
	connectSemaphore := Semaphore new!

onAsyncClose
	"Private - Handle the notification of an asynchronous close event. Triggers a
	#remoteSocketClosed event, after first allowing blocking readers/writers
	to proceed in case there is more data to be read (see #726)."

	self cancelWait.
	self trigger: #remoteSocketClosed!

onAsyncConnect
	"Private - Handle the notification of an asynchronous connect event. Triggers a #connected
	event when a connection is made."

	connectSemaphore signal.
	self trigger: #connected!

onAsyncRead
	"Private - Handle the notification of an asynchronous read event. Triggers a
	#dataRead event to indicate that data has been received by the receiver."

	readSemaphore signal.
	self trigger: #dataRead!

onAsyncWrite
	"Private - Handle the notification of an asynchronous write event"

	writeSemaphore signal!

peerAddress
	"Answer an InternetAddress representing the address of the peer machine."

	| winSockAddr winSockAddrLen |
	winSockAddr := SOCKADDR_IN new.
	winSockAddrLen := SDWORD new.
	winSockAddrLen value: winSockAddr byteSize.
	WSockLibrary default
		getpeername: self asParameter
		name: winSockAddr
		namelen: winSockAddrLen.
	^InternetAddress ipAddress: winSockAddr sin_addr!

port: anIntegerPort address: anInternetAddress 
	"Private - Initialize the receiver to connect to anIntegerPort on the host
	identified by anInternetAddress"

	port := anIntegerPort.
	address := anInternetAddress!

readStream
	"Answer (lazily) the readStream instance variable."

	readStream isNil ifTrue: [readStream := SocketReadStream on: self].
	^readStream!

receive
	"Receive and answer a single object through the socket using a one-shot STBInFiler. Note 
	that this is a convenience method. If you are intending to receive many objects through the 
	socket then it will be more efficient to create your own STBInFiler onto the socket's 
	readStream. This method blocks until the object is received"

	^(Kernel.STBInFiler on: self readStream) next!

receive: aByteArray 
	"Compatiblity method with Socket2>>receive:"

	| buffer |
	buffer := self receiveByteArray: aByteArray size.
	aByteArray 
		replaceFrom: 1
		to: aByteArray size
		with: buffer
		startingAt: 1!

receiveByte
	"Receive and answer a single byte from the socket. The current process is blocked until
	the operation has completed."

	| result |
	
	[| retry |
	retry := false.
	[result := self basicReceiveByte] on: SocketWouldBlock do: [:e | retry := true].
	retry]
			whileTrue: [self waitRead].
	^result!

receiveByteArray: anInteger 
	"Receive anInteger bytes from the socket and answer this data as a ByteArray
	of exactly this length.The current process is blocked until the operation has completed."

	| buffer received |
	buffer := self receiveByteArrayPartial: anInteger.
	received := buffer size.
	[received < anInteger] whileTrue: 
			[buffer := buffer , (self receiveByteArrayPartial: anInteger - received).
			received := buffer size].
	^buffer!

receiveByteArrayPartial: anInteger
	"Receive bytes from the socket up to a maxiumum of anInteger bytes
	and answer this data as a ByteArray. This may answer a array with fewer bytes
	than requested.	The current process is blocked until the operation has completed."

	| result |
	
	[| retry |
	retry := false.
	[result := self basicReceiveByteArray: anInteger] on: SocketWouldBlock do: [:e | retry := true].
	retry]
			whileTrue: [self waitRead].
	^result!

receiveSome: aByteObject count: lengthInteger startingAt: startInteger 
	""

	"N.B. This is implemented so that old-style sockets are usable with the SocketReadStream
	defined in the new Dolphin Sockets package. It is not intended to be the most efficient
	mechanism."

	| received count |
	received := self receiveByteArrayPartial: lengthInteger.
	count := received size.
	aByteObject 
		replaceFrom: 1
		to: count
		with: received
		startingAt: startInteger.
	^count!

send: anObject 
	"Send anObject through the socket using a one-shot STBOutFiler. Note that this is a convenience 
	method. If you are intending to send many object through the socket then it will be more efficient 
	to create your own STBOutFiler onto the socket's writeStream"

	(Kernel.STBOutFiler on: self writeStream) nextPut: anObject.
	self writeStream flush!

send: aByteObject count: anInteger 
	"N.B. This is implemented so that old-style sockets are usable with the SocketWriteStream
	defined in the new Dolphin Sockets package. This class is now deprecated.."

	self 
		send: aByteObject
		count: anInteger
		startingAt: 1!

send: aByteObject count: countInteger startingAt: startInteger 
	"N.B. This is implemented so that old-style sockets are usable with the SocketWriteStream
	defined in the new Dolphin Sockets package. This class is now deprecated."

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

	| result |
	
	[| retry |
	retry := false.
	[result := self basicSendByte: anInteger] on: SocketWouldBlock do: [:e | retry := true].
	retry]
			whileTrue: [self waitWrite].
	^result!

sendByteArray: aByteArray 
	"Write aByteArray to the receiver. The current process is blocked until
	the operation has completed. Answers the number of bytes sent or a 
	Sockets error code if some failure occurs."

	| sent |
	sent := 0.
	[sent < aByteArray size] whileTrue: 
			[| buffer ret |
			buffer := aByteArray copyFrom: sent + 1.
			ret := self sendByteArrayPartial: buffer.
			ret < 0 ifTrue: [^ret].
			sent := sent + ret].
	^sent!

sendByteArrayPartial: aByteArray
	"Private - Write aByteArray to the receiver. Answers the number of bytes
	actually sent which may be less than the requested buffer size. 
	The current process is blocked until the operation has completed."

	| result |
	
	[| retry |
	retry := false.
	[result := self basicSendByteArray: aByteArray] on: SocketWouldBlock do: [:e | retry := true].
	retry]
			whileTrue: [self waitWrite].
	^result!

sendSome: aByteObject count: lengthInteger startingAt: startInteger 
	"Private - N.B. This is implemented so that old-style sockets are usable with the SocketWriteStream
	defined in the new Dolphin Sockets package. It is not intended to be the most efficient
	mechanism."

	^self sendByteArrayPartial: (aByteObject copyFrom: startInteger
				to: startInteger + lengthInteger - 1)!

waitConnect
	"Private - Wait on the connectSemaphore."

	self waitOn: connectSemaphore!

waitRead
	"Private - Wait on the readSemaphore."

	self waitOn: readSemaphore!

waitWrite
	"Private - Wait on the writeSemaphore."

	self waitOn: writeSemaphore!

writeStream
	"Answer (lazily) the writeStream instance variable."

	writeStream isNil ifTrue: [writeStream := SocketWriteStream on: self].
	^writeStream! !
!Net.Socket categoriesFor: #address!accessing!public! !
!Net.Socket categoriesFor: #basicConnect!operations!private! !
!Net.Socket categoriesFor: #basicReceiveByte!operations!private! !
!Net.Socket categoriesFor: #basicReceiveByteArray:!operations!private! !
!Net.Socket categoriesFor: #basicSendByte:!operations!private! !
!Net.Socket categoriesFor: #basicSendByteArray:!operations!private! !
!Net.Socket categoriesFor: #cancelWait!accessing!private! !
!Net.Socket categoriesFor: #connect!operations!public! !
!Net.Socket categoriesFor: #connectNoWait!operations!public! !
!Net.Socket categoriesFor: #hasInput!private!testing! !
!Net.Socket categoriesFor: #initialize!initializing!private! !
!Net.Socket categoriesFor: #onAsyncClose!event handling!private! !
!Net.Socket categoriesFor: #onAsyncConnect!event handling!private! !
!Net.Socket categoriesFor: #onAsyncRead!event handling!private! !
!Net.Socket categoriesFor: #onAsyncWrite!event handling!private! !
!Net.Socket categoriesFor: #peerAddress!accessing!public! !
!Net.Socket categoriesFor: #port:address:!initializing!private! !
!Net.Socket categoriesFor: #readStream!accessing!public! !
!Net.Socket categoriesFor: #receive!operations!public! !
!Net.Socket categoriesFor: #receive:!public! !
!Net.Socket categoriesFor: #receiveByte!operations!public! !
!Net.Socket categoriesFor: #receiveByteArray:!operations!public! !
!Net.Socket categoriesFor: #receiveByteArrayPartial:!operations!public! !
!Net.Socket categoriesFor: #receiveSome:count:startingAt:!public! !
!Net.Socket categoriesFor: #send:!operations!public! !
!Net.Socket categoriesFor: #send:count:!operations!public! !
!Net.Socket categoriesFor: #send:count:startingAt:!operations!public! !
!Net.Socket categoriesFor: #sendByte:!operations!public! !
!Net.Socket categoriesFor: #sendByteArray:!operations!public! !
!Net.Socket categoriesFor: #sendByteArrayPartial:!operations!private! !
!Net.Socket categoriesFor: #sendSome:count:startingAt:!private! !
!Net.Socket categoriesFor: #waitConnect!operations!private! !
!Net.Socket categoriesFor: #waitRead!operations!private! !
!Net.Socket categoriesFor: #waitWrite!operations!private! !
!Net.Socket categoriesFor: #writeStream!accessing!public! !

!Net.Socket class methodsFor!

descriptor: anInteger port: anIntegerPort address: anInternetAddress 
	"Answers a new instance of the receiver with socket descriptor anInteger."

	^(super new)
		initialize;
		port: anIntegerPort address: anInternetAddress;
		descriptor: anInteger;
		registerDescriptor;
		allowAsyncEvents;
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

	^self port: anIntegerPort address: (InternetAddress ipAddress: aByteArray)!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^(super publishedEventsOfInstances)
		add: #dataRead;
		add: #connected;
		yourself! !
!Net.Socket class categoriesFor: #descriptor:port:address:!instance creation!public! !
!Net.Socket class categoriesFor: #new!instance creation!private! !
!Net.Socket class categoriesFor: #port:address:!instance creation!public! !
!Net.Socket class categoriesFor: #port:host:!instance creation!public! !
!Net.Socket class categoriesFor: #port:ipAddress:!instance creation!public! !
!Net.Socket class categoriesFor: #publishedEventsOfInstances!development!events!public! !

