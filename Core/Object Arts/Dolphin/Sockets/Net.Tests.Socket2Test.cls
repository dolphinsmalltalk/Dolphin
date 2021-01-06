"Filed out from Dolphin Smalltalk 7"!

Net.Tests.AbstractSocketTest subclass: #'Net.Tests.Socket2Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.Tests.Socket2Test guid: (Core.GUID fromString: '{25407553-d303-4d50-ad3d-b05b28a27c47}')!
Net.Tests.Socket2Test comment: ''!
!Net.Tests.Socket2Test categoriesForClass!Unclassified! !
!Net.Tests.Socket2Test methodsFor!

clientSocketClass
	^Socket2!

serverSocketClass
	^ServerSocket2!

testBindReuseFailure
	| s1 s2 |
	s1 := self serverSocketClass new.
	s1
		port: 0;
		create.
	s1 bind.
	s2 := self serverSocketClass new.
	s2
		port: s1 queryPort;
		create.
	self
		should: [s2 bind]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEADDRINUSE].
	s1 close.
	s2 close!

testConnectFailure
	| s1 s2 |
	s1 := self clientSocketClass port: 0 address: (InternetAddress fromString: '127.0.0.1').
	self
		should: [s1 connect]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEADDRNOTAVAIL].
	s1 close!

testListenUnbound
	| s1 |
	s1 := self serverSocketClass new.
	s1
		port: 0;
		create.
	self
		should: [s1 listen: 5]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEINVAL].
	s1 close!

testPeerAddress
	| s1 s2 peer loopback |
	s1 := self serverSocketClass port: 0.
	loopback := InternetAddress fromString: '127.0.0.1'.
	s2 := self clientSocketClass port: s1 queryPort address: loopback.
	s2 connect.
	peer := s2 peerAddress.
	self assert: peer ipAddress equals: loopback ipAddress.
	s2 close.
	s1 close!

testPeerAddressNotConnected
	| s1 |
	s1 := self clientSocketClass port: 0 address: (InternetAddress fromString: '127.0.0.1').
	self
		should: [s1 peerAddress]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAECONNRESET].
	s1 close!

testQueryPort
	"See #1317"

	| s |
	s := self serverSocketClass port: 1000.
	[self assert: s queryPort = 1000] ensure: [s close]!

testQueryPortUnbound
	| s |
	s := self serverSocketClass new.
	s
		port: 0;
		create.
	self
		should: [s queryPort]
		raise: SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEINVAL].
	s close!

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
	sent := {#Object -> Object comment. Object class}.
	outfiler := Kernel.STBOutFiler on: outbound writeStream.
	sent do: [:each | outfiler nextPut: each].
	"We have to flush the stream before we close the socket or the data might never get written"
	outfiler stream flush.
	outbound close.
	"Wait for the reader to finish reading the messages"
	ready wait.
	messages := messages asArray.
	self assert: messages equals: sent! !
!Net.Tests.Socket2Test categoriesFor: #clientSocketClass!constants!private! !
!Net.Tests.Socket2Test categoriesFor: #serverSocketClass!constants!private!unit tests! !
!Net.Tests.Socket2Test categoriesFor: #testBindReuseFailure!public!unit tests! !
!Net.Tests.Socket2Test categoriesFor: #testConnectFailure!public!unit tests! !
!Net.Tests.Socket2Test categoriesFor: #testListenUnbound!public!unit tests! !
!Net.Tests.Socket2Test categoriesFor: #testPeerAddress!public!unit tests! !
!Net.Tests.Socket2Test categoriesFor: #testPeerAddressNotConnected!public!unit tests! !
!Net.Tests.Socket2Test categoriesFor: #testQueryPort!public!unit tests! !
!Net.Tests.Socket2Test categoriesFor: #testQueryPortUnbound!public!unit tests! !
!Net.Tests.Socket2Test categoriesFor: #testSTBMessages!public!unit tests! !

