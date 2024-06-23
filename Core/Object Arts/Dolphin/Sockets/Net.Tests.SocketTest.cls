"Filed out from Dolphin Smalltalk"!

AbstractSocketTest
	subclass: #'Net.Tests.SocketTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Net.Tests.SocketTest guid: (Core.GUID fromString: '{25407553-d303-4d50-ad3d-b05b28a27c47}')!

Net.Tests.SocketTest comment: ''!

!Net.Tests.SocketTest methodsFor!

clientSocketClass
	"Qualified name is not necessary here, but is specified for clarity that this is testing the more recent blocking sockets based on overlapped calls."

	^Net.Socket!

serverSocketClass
	^Net.ServerSocket!

testBindReuseFailure
	| s1 s2 |
	s1 := self serverSocketClass new.
	sockets add: s1.
	s1
		port: 0;
		create.
	s1 bind.
	s2 := self serverSocketClass new.
	sockets add: s2.
	s2
		port: s1 queryPort;
		create.
	self
		should: [s2 bind]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEADDRINUSE]!

testConnectFailure
	| s1 |
	s1 := self clientSocketClass port: 0 address: (InternetAddress fromString: '127.0.0.1').
	sockets add: s1.
	self
		should: [s1 connect]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEADDRNOTAVAIL]!

testListenUnbound
	| s1 |
	s1 := self serverSocketClass new.
	sockets add: s1.
	s1
		port: 0;
		create.
	self
		should: [s1 listen: 5]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEINVAL]!

testPeerAddress
	| s1 s2 peer loopback |
	s1 := self serverSocketClass port: 0.
	sockets add: s1.
	loopback := InternetAddress fromString: '127.0.0.1'.
	s2 := self clientSocketClass port: s1 queryPort address: loopback.
	sockets add: s2.
	s2 connect.
	peer := s2 peerAddress.
	self assert: peer ipAddress equals: loopback ipAddress!

testPeerAddressNotConnected
	| s1 |
	s1 := self clientSocketClass port: 0 address: (InternetAddress fromString: '127.0.0.1').
	sockets add: s1.
	self
		should: [s1 peerAddress]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAECONNRESET]!

testQueryPortUnbound
	| s |
	s := self serverSocketClass new.
	sockets add: s.
	s
		port: 0;
		create.
	self
		should: [s queryPort]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEINVAL]!

testSTBMessages
	| acceptSocket inbound ready messages outbound sent outfiler |
	acceptSocket := self serverSocketClass port: 120 backlog: 0.
	sockets add: acceptSocket.
	ready := Semaphore new.
	
	[inbound := acceptSocket accept.
	sockets add: inbound.
	"Signal that we have the inbound socket"
	ready signal]
			fork.
	messages := OrderedCollection new.
	
	[| readStream filer |
	"Wait for the connection to be accepted so that the inbound socket is available"
	ready wait.
	readStream := inbound readStream.
	filer := Kernel.STBInFiler on: readStream.
	
	[| message |
	message := filer next.
	messages add: message.
	readStream atEnd] whileFalse.
	"Signal that we have finished reading the messages"
	ready signal]
			fork.
	outbound := self clientSocketClass port: 120 address: (InternetAddress fromString: 'localhost').
	sockets add: outbound.
	outbound connect.
	sent := { #Object -> Object comment. Object class }.
	outfiler := Kernel.STBOutFiler on: outbound writeStream.
	sent do: [:each | outfiler nextPut: each].
	"We have to flush the stream before we close the socket or the data might never get written"
	outfiler stream flush.
	outbound close.
	"Wait for the reader to finish reading the messages"
	ready wait.
	messages := messages asArray.
	self assert: messages equals: sent! !

!Net.Tests.SocketTest categoriesForMethods!
clientSocketClass!constants!private! !
serverSocketClass!constants!private!unit tests! !
testBindReuseFailure!public!unit tests! !
testConnectFailure!public!unit tests! !
testListenUnbound!public!unit tests! !
testPeerAddress!public!unit tests! !
testPeerAddressNotConnected!public!unit tests! !
testQueryPortUnbound!public!unit tests! !
testSTBMessages!public!unit tests! !
!

