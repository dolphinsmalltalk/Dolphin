"Filed out from Dolphin Smalltalk"!

AbstractSocketTest
	subclass: #'Net.Tests.SocketTest'
	instanceVariableNames: 'readStream writeStream'
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

createConnectedPair
	| acceptSocket ready outbound |
	acceptSocket := self serverSocketClass port: 120 backlog: 0.
	sockets add: acceptSocket.
	ready := Semaphore new.
	
	[| inbound |
	inbound := acceptSocket accept.
	sockets add: inbound.
	readStream := inbound readStream.
	"Signal that we have the inbound socket"
	ready signal]
			fork.
	outbound := self clientSocketClass port: 120 address: (InternetAddress fromString: 'localhost').
	sockets add: outbound.
	outbound connect.

	"Wait for the connection to be accepted so that the inbound socket is available"
	ready wait.
	writeStream := outbound writeStream.
	self assert: readStream isBufferEmpty!

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

testNextAvailable
	self createConnectedPair.
	readStream on: (ByteArray newFixed: 3).
	writeStream on: (ByteArray newFixed: 3).
	writeStream
		nextPutAll: #[1 2 3 4 5 6 7];
		flush.
	self assert: (readStream nextAvailable: 3) equals: #[1 2 3].
	self assert: readStream nextAvailable equals: 4.
	self assert: (readStream nextAvailable: 3) equals: #[5 6 7].
	self deny: readStream hasInput.
	self assert: readStream isBufferEmpty.
	"Switch to text"
	writeStream on: (Utf8String newFixed: 4).
	readStream on: (Utf8String newFixed: 4).
	writeStream
		nextPutAll: 'a🐬b£';
		close.
	self assert: readStream nextAvailable equals: $a.
	self assert: (readStream nextAvailable: 2) equals: '🐬b'.
	self assert: (readStream nextAvailable: 2) equals: '£'.
	self assertIsNil: readStream nextAvailable!

testNextPutAll
	self createConnectedPair.
	"Use a small buffer so output will overflow it easily"
	writeStream on: (ByteArray new: 4).
	writeStream
		nextPutAll: #[1 2 3];
		nextPutAll: #[4 5 6 7].
	"There should still be some unwritten (buffered) data in the output stream"
	self assert: writeStream collection equals: #[5 6 7 4].
	self assert: writeStream bufferPosition equals: 3.
	self assert: (readStream next: 4) equals: #[1 2 3 4].
	"The input stream should now all have been read as the remaining output is not yet sent"
	self deny: readStream hasInput.
	self assert: readStream isBufferEmpty.
	"Cause buffer to overflow, which should flush the existing data."
	writeStream nextPutAll: #[8 9].
	self assert: writeStream collection equals: #[9 6 7 8].
	self assert: writeStream bufferPosition equals: 1.
	self assert: readStream hasInput.
	self assert: readStream isBufferEmpty.
	self assert: readStream next equals: 5.
	self deny: readStream isBufferEmpty.
	self assert: (readStream next: 3) equals: #[6 7 8].
	self deny: readStream hasInput.
	self assert: readStream isBufferEmpty.
	writeStream flush.
	self assert: writeStream bufferPosition equals: 0.
	self assert: readStream next equals: 9.
	self deny: readStream hasInput.
	writeStream isText: true.
	readStream isText: true.
	writeStream nextPutAll: 'a🐬'.
	self assert: readStream next equals: $a.
	"The Dolphin emoji is part written, but has one byte remaining in the write buffer that hasn't been flushed to the socket yet"
	self assert: readStream hasInput.
	self deny: readStream isBufferEmpty.
	"Writing more data will definitely overflow"
	writeStream nextPutAll: 'bcd🐭'.
	"The remainder or the Dolphin will be flushed along with 'bcd', and the next emoji written to the buffer written to the buffer. There won't be room for the next emoji, so the b will be flushed, and the emoji written to the buffer."
	self assert: writeStream bufferPosition equals: 4.
	self assert: (readStream next: 4) equals: '🐬bcd'.
	self deny: readStream hasInput.
	writeStream nextPutAll: '£'.
	self assert: writeStream bufferPosition equals: 2.
	self assert: readStream next equals: $🐭.
	self deny: readStream hasInput.
	writeStream close.
	self assert: readStream next equals: $£.
	
	self should: [readStream next] raise: Stream endOfStreamSignal!

testNextPutAllStartingAtAsBytes
	"SocketWriteStream>>next:putAll:startingAt:, with byte buffer (i.e transmitting bytes)"
	| data |
	self createConnectedPair.
	"Use a small buffer so output will overflow it easily"
	writeStream on: (ByteArray new: 4).
	data := #[1 2 3 4 5 6].
	writeStream
		next: 3
		putAll: data
		startingAt: 2.
	"There should still be some unwritten (buffered) data in the output stream"
	self assert: writeStream collection equals: #[2 3 4 0].
	self assert: writeStream bufferPosition equals: 3.
	"The input stream is empty as the output is not yet sent"
	self deny: readStream hasInput.
	self assert: readStream isBufferEmpty.
	"Write more data, but still not overflowing the buffer"
	writeStream
		next: 1
		putAll: data
		startingAt: 5.
	self assert: writeStream collection equals: #[2 3 4 5].
	self assert: writeStream bufferPosition equals: 4.
	"The input stream is empty as the output is still not yet sent"
	self deny: readStream hasInput.
	self assert: readStream isBufferEmpty.
	"Write one byte causing buffer overflow"
	writeStream
		next: 1
		putAll: data
		startingAt: 6.
	"The 6 should be retained in the buffer"
	self assert: writeStream collection equals: #[6 3 4 5].
	self assert: writeStream bufferPosition equals: 1.
	self assert: readStream hasInput.
	self assert: (readStream next: 4) equals: #[2 3 4 5].
	"Now write more data than would fit in the buffer anyway. Leading data should be sent, and tail data up to the buffer size is buffered."
	writeStream
		next: 5
		putAll: data
		startingAt: 1.
	self assert: writeStream bufferPosition equals: 2.
	self assert: readStream hasInput.
	self assert: (readStream next: 4) equals: #[6 1 2 3].
	self deny: readStream hasInput.
	self assert: readStream isBufferEmpty.
	writeStream flush.
	self assert: (readStream next: 2) equals: #[4 5].
	"Try UTF-8 text"
	readStream isText: true.
	data := 'a🐬c' asUtf8String.
	writeStream
		next: 1
		putAll: data
		startingAt: 1.
	"There should still be some unwritten (buffered) data in the output stream"
	self assert: writeStream bufferPosition equals: 1.
	"The input stream is empty as the output is not yet sent"
	self deny: readStream hasInput.
	self assert: readStream isBufferEmpty.
	"Overflow with buffered data and data too large for buffer"
	writeStream
		next: 5
		putAll: data
		startingAt: 1.
	self assert: writeStream bufferPosition equals: 2.
	self assert: readStream hasInput.
	writeStream flush.
	self assert: (readStream next: 3) equals: 'a' , (data copyFrom: 1 to: 5).
	"Data too large for empty buffer"
	writeStream
		next: 5
		putAll: data
		startingAt: 1.
	self assert: writeStream bufferPosition equals: 1.
	self assert: readStream hasInput.
	writeStream flush.
	self assert: (readStream next: 2) equals: (data copyFrom: 1 to: 5).
	self deny: readStream hasInput.
	self assert: readStream isBufferEmpty.

	"Now UTF-16"
	readStream isText: false.
	data := data asUtf16String.
	writeStream
		next: 3
		putAll: data
		startingAt: 1.
	"Will have overflowed the 4-byte buffer since requires 6 bytes. The first 4 will have been flushed"
	self assert: writeStream bufferPosition equals: 2.
	self assert: readStream hasInput.
	"Flush the remainder so that we can read the two chars"
	writeStream flush.
	self assert: (readStream next: 6) equals: (data copyFrom: 1 to: 3) asByteArray!

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
	| ready messages sent outfiler |
	self createConnectedPair.
	ready := Semaphore new.
	messages := OrderedCollection new.
	
	[| filer |
	filer := Kernel.STBInFiler on: readStream.
	
	[| message |
	message := filer next.
	messages add: message.
	readStream atEnd] whileFalse.
	"Signal that we have finished reading the messages"
	ready signal]
			fork.
	sent := { #Object -> Object comment. Object class }.
	outfiler := Kernel.STBOutFiler on: writeStream.
	sent do: [:each | outfiler nextPut: each].
	"We have to flush the stream before we close the socket or the data might never get written"
	writeStream close.
	"Wait for the reader to finish reading the messages"
	ready wait.
	messages := messages asArray.
	self assert: messages equals: sent!

testUpTo
	self createConnectedPair.
	"Use small buffers to cause intra-character overflow"
	writeStream on: (Utf8String newFixed: 6).
	readStream on: (Utf8String newFixed: 6).
	writeStream nextPutAll: 'abcd🐬e🐬f💩£g'.
	writeStream close.
	self assert: (readStream upTo: $a) equals: ''.
	self assert: (readStream upTo: $c) equals: 'b'.
	self assert: (readStream upTo: $🐬) equals: 'd'.
	self assert: (readStream upTo: $💩) equals: 'e🐬f'.
	self assert: (readStream upTo: $g) equals: '£'.
	self assert: readStream atEnd.
	self assert: readStream upToEnd equals: ''.
	self assert: readStream atEnd!

testUtf8Peeking
	"Peeking is look-ahead, normally remembers are resets the stream position. Given that a SocketReadStream holds only a block of recent data from the stream, and so cannot step back to visit previous data that has been replaced by the most recent read into the buffer. Thus SocketReadStream requires special support to be able to peek multi-byte encodings that may straddle a buffer boundary."

	self createConnectedPair.
	"Minimum buffer size is max encoding length of Utf8String, i.e. 4"
	readStream on: (Utf8String newFixed: 4).
	writeStream
		isText: true;
		nextPutAll: 'a🐬£';
		close.
	self assert: readStream peek equals: $a.
	self assert: readStream peek equals: $a.
	self deny: (readStream peekFor: $🐬).
	self assert: (readStream peekFor: $a).
	self assert: readStream peek equals: $🐬.
	self assert: readStream peek equals: $🐬.
	self deny: (readStream peekFor: $£).
	self assert: readStream peek equals: $🐬.
	self assert: (readStream peekFor: $🐬).
	self assert: readStream peek equals: $£.
	self assert: (readStream peekFor: $£).
	self assert: readStream peek isNil.
	self assert: readStream atEnd! !

!Net.Tests.SocketTest categoriesForMethods!
clientSocketClass!constants!private! !
createConnectedPair!helpers!private! !
serverSocketClass!constants!private!unit tests! !
testBindReuseFailure!public!unit tests! !
testConnectFailure!public!unit tests! !
testListenUnbound!public!unit tests! !
testNextAvailable!public!unit tests! !
testNextPutAll!public!unit tests! !
testNextPutAllStartingAtAsBytes!public!unit tests! !
testPeerAddress!public!unit tests! !
testPeerAddressNotConnected!public!unit tests! !
testQueryPortUnbound!public!unit tests! !
testSTBMessages!public!unit tests! !
testUpTo!public!unit tests! !
testUtf8Peeking!public!unit tests! !
!

