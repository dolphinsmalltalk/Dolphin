"Filed out from Dolphin Smalltalk X6"!

SimpleClientSocket subclass: #POPSocket
	instanceVariableNames: 'userName password numMessages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
POPSocket guid: (GUID fromString: '{FBE3D9A0-4A24-11D6-B032-85F761705405}')!
POPSocket comment: ''!
!POPSocket categoriesForClass!MailSockets! !
!POPSocket methodsFor!

connectToPOP
	"Answer the result of  connect the receiver to the POP server"

	| response |
	self connectToServer
		ifFalse: [ ^false ].
	Transcript show: 'Connected to: ' , self address displayString; cr.
	"get a hello message"
	Transcript show: (response := self getResponse); cr.
	(response beginsWith: '+')
		ifFalse: [self close. ^false].
	^self login
	



	!

deleteAllMessages
	"Delete all messages"

	1 to: self numMessages do: [:num | self deleteMessage: num]!

deleteMessage: number 
	"Delete the numbered message"

	self sendCommand: 'DELE ' , number printString.
!

disconnectFromPOP
	"Send the quit command to the server and close the receiver"

	self sendCommand: 'QUIT'.
	Transcript show: 'Quit enviado...'; cr.
	self close!

login
	"Private - Answer the result of login to a POP server"

	| response |
	self sendCommand: 'USER ' , userName.
	Transcript show: (response := self getResponse); cr.
	(response beginsWith: '+')
		ifFalse: [self close. ^false].
	self sendCommand: 'PASS ' , password.
	Transcript show: (response := self getResponse); cr.
	(response beginsWith: '+')
		ifFalse: [self close. ^ false].
	^true!

messagesDo: aBlock 
	"Perform aBlock on each message text"

	| thisMessage |
	1 to: self numMessages
	  do: [:num | thisMessage := self retrieveMessage: num.
			aBlock value: thisMessage]!

numMessages
	"Query the server and answer the number of messages that are in the 
	user's mailbox."

	| response answerString |
	numMessages notNil
		ifTrue: [^ numMessages].
	self sendCommand: 'STAT'.
	response := self getResponse.
	Transcript show: 'Respuesta: ', response; cr.
	(response beginsWith: '+OK')
		ifFalse: [ ^0 ].
	answerString := response subStrings second.
	
	numMessages := answerString asNumber asInteger.
	^numMessages!

password
	"Answer the password value"

	^password!

password: aString
	"Set the password"

	password := aString
!

retrieveMessage: number 
	"Retrieve the numbered message"

	| response |
	self sendCommand: 'RETR ' , number printString.
	Transcript show: 'Command: RETR ' , number printString , ' sent ...'; cr.
	response := self getResponse.
	Transcript show: 'Received: ' , response; cr.
	(response beginsWith: '+OK')
		ifFalse: [self error: 'error: ' , response].
	^self getMultilineResponse!

userName
	"Answer the userName value"

	^userName!

userName: aString
	"Set the username"

	userName := aString! !
!POPSocket categoriesFor: #connectToPOP!public! !
!POPSocket categoriesFor: #deleteAllMessages!public! !
!POPSocket categoriesFor: #deleteMessage:!public! !
!POPSocket categoriesFor: #disconnectFromPOP!public! !
!POPSocket categoriesFor: #login!private! !
!POPSocket categoriesFor: #messagesDo:!public! !
!POPSocket categoriesFor: #numMessages!public! !
!POPSocket categoriesFor: #password!public! !
!POPSocket categoriesFor: #password:!public! !
!POPSocket categoriesFor: #retrieveMessage:!public! !
!POPSocket categoriesFor: #userName!public! !
!POPSocket categoriesFor: #userName:!public! !

!POPSocket class methodsFor!

example
	"This is a fast test

	self example
	"

	| pop messages |
	pop := self port: 110 host: (Prompter prompt: 'object-arts.com').
	pop userName: (Prompter prompt: 'username').
	pop password: (Prompter prompt: 'password').
	messages := OrderedCollection new.

	pop connectToPOP.
	pop messagesDo: [ :each | messages add: each ].
	"pop deleteAllMessages." "don´t touch, only if you want to loose your inbox"
	pop disconnectFromPOP.
	messages inspect.


	! !
!POPSocket class categoriesFor: #example!public! !

