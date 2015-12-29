"Filed out from Dolphin Smalltalk X6"!

Socket subclass: #SimpleClientSocket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimpleClientSocket guid: (GUID fromString: '{B548E0E2-4D6B-11D6-B032-DCB705350804}')!
SimpleClientSocket comment: ''!
!SimpleClientSocket categoriesForClass!Unclassified! !
!SimpleClientSocket methodsFor!

connectToServer
	"Private - Answer the result of connect to the server"

	[ self connect  ] on: SocketError
			       do: [ :error | MessageBox notify: 'Failed to connect to server. ' , error description. ^false ].
	self when: #remoteSocketClosed send: #onSocketDisconnected to: self.
	^true
!

getMultilineResponse
	"Get a multiple line response to the last command. A multiple line 
	response ends with a line containing only a single period (.) character."

	| response done line |
	response := WriteStream on: String new.
	done := false.
	[done]
		whileFalse: [ line := self getResponse.
				   response nextPutAll: line.
				  done := line = ('.' , String lineDelimiter)].
	^response contents!

getResponse
	"Answer a one line String with two line delimiter characters (cr lf)"
	
	| result |
	result := self readStream upTo: Character lf asInteger. "The streaming collection is a ByteArray ;)"
	^result asString , Character lf asString
	!

onSocketDisconnected
	"Private - An event has occurred indicating that the remote socket connection was closed 
	so we force a local disconnect"

	self close.
	"and for test only"
	MessageBox notify: 'Connection to server closed!!'!

sendCommand: aString
	"Send aString command through the socket."

	self sendStringCr: aString!

sendStringCr: aString
	"Private - Send aString with cr at end through the socket. Note that this is a convenience method."

	self writeStream nextPutAll: aString; cr; flush! !
!SimpleClientSocket categoriesFor: #connectToServer!private! !
!SimpleClientSocket categoriesFor: #getMultilineResponse!public! !
!SimpleClientSocket categoriesFor: #getResponse!public! !
!SimpleClientSocket categoriesFor: #onSocketDisconnected!private! !
!SimpleClientSocket categoriesFor: #sendCommand:!operations!public! !
!SimpleClientSocket categoriesFor: #sendStringCr:!operations!private! !

