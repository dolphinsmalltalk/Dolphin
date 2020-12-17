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
!Net.Tests.Socket2Test categoriesFor: #testSTBMessages!public! !

