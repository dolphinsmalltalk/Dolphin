"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #EmailPOP3Reader
	instanceVariableNames: 'status username password socket serverID host port numberOfMessages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmailPOP3Reader guid: (GUID fromString: '{1D6E2A1B-C4C1-4209-9347-7A32D35F0083}')!
EmailPOP3Reader comment: ''!
!EmailPOP3Reader categoriesForClass!Unclassified! !
!EmailPOP3Reader methodsFor!

connect
	socket isNil 
		ifFalse: 
			[socket close.
			socket := nil].
	socket := ItcSystemManager newTCPclientSocketToHost: host port: port.
	socket readStream isBytes: false.
	socket writeStream isBytes: true!

deleteMessage: anInteger

	self sendCommand: ('DELE ',anInteger printString) withErrorID: 'deleteMessage/DELE'
!

finalize

	socket isNil ifFalse: [ socket close ].
	socket := nil.
	super finalize!

FIRSTMSGLINES

	^40!

getMessage: anInteger
	| message response |
	(numberOfMessages notNil and: [anInteger > numberOfMessages]) 
		ifTrue: [self error: 'Message index out of range'].
	self sendCommand: 'RETR ' , anInteger printString withErrorID: 'getMessage/RETR'.
	message := self readMultilineResponse.
	self deleteMessage: anInteger.
	^EMailMessage createFrom: message!

getMessages
	| messages message response |
	messages := OrderedCollection new.
	1 to: self getNumberOfMessages
		do: 
			[:index | 
			self sendCommand: 'RETR ' , index printString withErrorID: 'getMessages/RETR'.
			message := self readMultilineResponse.
			messages add: (EMailMessage createFrom: message).
			self deleteMessage: index].
	^messages!

getMessageSizes
	| response msgList |
	self sendCommand: 'LIST' withErrorID: 'LIST/getMessageSizes'.
	msgList := OrderedCollection new.
	
	[response := socket readStream nextLine.
	response first = $. 
		ifTrue: 
			[numberOfMessages := msgList size.
			^msgList]
		ifFalse: [msgList add: ((response itcSubStrings: $ ) at: 2) itcAsInteger].
	true] 
			whileTrue!

getNumberOfMessages
	"Uses STAT command:

		response comes in the form of:
			+OK nn mm
		where:
			nn - number of messages
			mm - total size of messages in octets"

	| response |
	numberOfMessages isNil ifFalse: [^numberOfMessages].
	response := self sendCommand: 'STAT' withErrorID: 'POP3/STAT'.
	^numberOfMessages := ((response itcSubStrings: $ ) at: 2) itcAsInteger!

getResponse: anErrorID
	| response |
	response := socket readStream nextLine.
	(response beginsWith: '+OK') 
		ifFalse: 
			[self 
				error: 'POP3 error: ' , anErrorID printString , '[response: ' , response printString , ']'].
	^response!

host: aString

	host := aString !

listMessage: index

	| lines message |
	lines := self topOfMessage: index lines: self FIRSTMSGLINES.
	message :=(EMailMessage createFrom: lines).
	message stripMsgToSize: self MSGMAXLENGTH.
	^message!

listMessages

	| messages message emsg |
	messages := OrderedCollection new.
	1 to: self getNumberOfMessages do: [:index |
		message := self topOfMessage: index lines: self FIRSTMSGLINES.
		emsg := EMailMessage createFrom: message.
		emsg stripMsgToSize: self MSGMAXLENGTH.
		messages add: emsg ].
	^messages!

login

	numberOfMessages := nil.
	socket isNil ifTrue: [ self connect ].
	socket isClosed ifTrue: [ self connect ].
	serverID := socket readStream nextLine.
	self sendCommand: ('USER ',username) withErrorID: 'logging in/USER'.
	self sendCommand: ('PASS ',password) withErrorID: 'logging in/PASS'.
 !

logout

	[ self sendCommand: 'QUIT' withErrorID: 'logging out/QUIT' ] on: Error do: [:ex | ex exitWith: nil ].
	socket close.
	socket := nil.
	numberOfMessages := nil.
   !

MSGMAXLENGTH

	^200!

password: aString

	password := aString!

peekMessage: anInteger
	| message response |
	(numberOfMessages notNil and: [anInteger > numberOfMessages]) 
		ifTrue: [self error: 'Message index out of range'].
	self sendCommand: 'RETR ' , anInteger printString withErrorID: 'peekMessage/RETR'.
	message := self readMultilineResponse.
	^EMailMessage createFrom: message!

peekMessages
	| messages message |
	messages := OrderedCollection new.
	1 to: self getNumberOfMessages
		do: 
			[:index | 
			self sendCommand: 'RETR ' , index printString withErrorID: 'peekMessages/RETR'.
			message := self readMultilineResponse.
			messages add: (EMailMessage createFrom: message)].
	^messages!

peekMessageSource: anInteger
	| message response |
	(numberOfMessages notNil and: [anInteger > numberOfMessages]) 
		ifTrue: [self error: 'Message index out of range'].
	self sendCommand: 'RETR ' , anInteger printString withErrorID: 'peekMessageSource/RETR'.
	message := self readMultilineResponse.
	^message!

port: anInteger

	port := anInteger !

readMultilineResponse
	| response writeStream |
	writeStream := WriteStream on: String new.
	[true] whileTrue: 
			[response := socket readStream nextLine.
			(response size = 1 and: [response first = $.]) ifTrue: [^writeStream contents].
			response = '..' 
				ifTrue: [writeStream nextPut: $.]
				ifFalse: [writeStream nextPutAll: response].
			writeStream cr]!

sendCommand: aString withErrorID: anInteger

	socket writeStream
		sendLine: aString;
		flush.
	^self getResponse: anInteger
	 !

topOfMessage: anInteger lines: lines
	| message response |
	(numberOfMessages notNil and: [anInteger > numberOfMessages]) 
		ifTrue: [self error: 'Message index out of range'].
	self sendCommand: 'TOP ' , anInteger printString , ' ' , lines printString
		withErrorID: 'topOfMessage/TOP'.
	message := self readMultilineResponse.
	^message!

undelete

	self sendCommand: 'RSET' withErrorID: 'undelete/RSET'
!

username: aString

	username := aString! !
!EmailPOP3Reader categoriesFor: #connect!public! !
!EmailPOP3Reader categoriesFor: #deleteMessage:!public! !
!EmailPOP3Reader categoriesFor: #finalize!private! !
!EmailPOP3Reader categoriesFor: #FIRSTMSGLINES!private! !
!EmailPOP3Reader categoriesFor: #getMessage:!public! !
!EmailPOP3Reader categoriesFor: #getMessages!public! !
!EmailPOP3Reader categoriesFor: #getMessageSizes!public! !
!EmailPOP3Reader categoriesFor: #getNumberOfMessages!public! !
!EmailPOP3Reader categoriesFor: #getResponse:!private! !
!EmailPOP3Reader categoriesFor: #host:!public! !
!EmailPOP3Reader categoriesFor: #listMessage:!public! !
!EmailPOP3Reader categoriesFor: #listMessages!public! !
!EmailPOP3Reader categoriesFor: #login!public! !
!EmailPOP3Reader categoriesFor: #logout!public! !
!EmailPOP3Reader categoriesFor: #MSGMAXLENGTH!private! !
!EmailPOP3Reader categoriesFor: #password:!public! !
!EmailPOP3Reader categoriesFor: #peekMessage:!public! !
!EmailPOP3Reader categoriesFor: #peekMessages!public! !
!EmailPOP3Reader categoriesFor: #peekMessageSource:!public! !
!EmailPOP3Reader categoriesFor: #port:!public! !
!EmailPOP3Reader categoriesFor: #readMultilineResponse!private! !
!EmailPOP3Reader categoriesFor: #sendCommand:withErrorID:!private! !
!EmailPOP3Reader categoriesFor: #topOfMessage:lines:!public! !
!EmailPOP3Reader categoriesFor: #undelete!public! !
!EmailPOP3Reader categoriesFor: #username:!public! !

!EmailPOP3Reader class methodsFor!

connectTo: aString

	^self new
		host: aString;
		port: self POP3PORT;
		connect  !

forPOP3Host: aString

	^self new
		host: aString;
		port: self POP3PORT;
		yourself  !

POP3PORT

	^110! !
!EmailPOP3Reader class categoriesFor: #connectTo:!public! !
!EmailPOP3Reader class categoriesFor: #forPOP3Host:!public! !
!EmailPOP3Reader class categoriesFor: #POP3PORT!public! !

