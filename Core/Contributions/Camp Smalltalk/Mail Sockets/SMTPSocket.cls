"Filed out from Dolphin Smalltalk X6"!

SimpleClientSocket subclass: #SMTPSocket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SMTPSocket guid: (GUID fromString: '{B548E0E1-4D6B-11D6-B032-DCB705350804}')!
SMTPSocket comment: ''!
!SMTPSocket categoriesForClass!MailSockets! !
!SMTPSocket methodsFor!

checkSMTPResponse
	"Get an SMTP response, and check that it's in the 200's or 300's. If it's 
	not, close the socket and issue an error:"

	(#(2 3 ) includes: self getSMTPResponse // 100)
		ifFalse: [self close.
			    self error: 'Server responded with an error']!

connectToSMTPServer
	"Connect the receiver to the server"

	self connectToServer
		ifFalse: [ ^false ].
	Transcript show: 'Connected to: ' , self address displayString; cr.
	self checkSMTPResponse.
	self sendCommand: 'HELO aDolphin4.xSystem'.
	self checkSMTPResponse.
	^true!

data: messageData 
	"Send the data of a message"
	"Inform the server we are sending the message data"

	| cookedLine |
	self sendCommand: 'DATA'.
	self checkSMTPResponse.
	"process the data one line at a time"
	messageData lines
			do: [:messageLine | 
				cookedLine := messageLine.
				(cookedLine beginsWith: '.')
					ifTrue: ["lines beginning with a dot must have the dot doubled"
						   cookedLine := '.' , cookedLine].
				self sendCommand: cookedLine].
	"inform the server the entire message text has arrived"
	self sendCommand: '.'.
	self checkSMTPResponse!

getSMTPResponse
	"Wait for an SMTP response, and return the number of the response"

	| line |
	[ line := self getResponse.
	 Transcript show: line.
	 (line at: 4)  = $- ] whileTrue.
	^(line copyFrom: 1 to: 3) asNumber!

mailFrom: fromAddress 
	"Send the command 'MAIL FROM: ' to the server"

	self sendCommand: 'MAIL FROM: <' , fromAddress , '>'.
	self checkSMTPResponse!

mailFrom: sender to: recipientList text: messageText 
	"Deliver this mail to a list of users. NOTE: the recipient list should be a 
	collection of simple internet style addresses -- no '<>' or '()' stuff"

	self mailFrom: sender.
	recipientList do: [:recipient | self recipient: recipient].
	self data: messageText!

quit
	"Send a QUIT command. This is polite to do, and indeed some servers might 
	drop messages that don't have an associated QUIT"

	self sendCommand: 'QUIT'.
	self checkSMTPResponse!

recipient: aRecipient 
	"Specify a recipient for the message. aRecipient should be a bare email 
	address "

	self sendCommand: 'RCPT TO: <' , aRecipient , '>'.
	self checkSMTPResponse! !
!SMTPSocket categoriesFor: #checkSMTPResponse!public! !
!SMTPSocket categoriesFor: #connectToSMTPServer!public! !
!SMTPSocket categoriesFor: #data:!public! !
!SMTPSocket categoriesFor: #getSMTPResponse!public! !
!SMTPSocket categoriesFor: #mailFrom:!public! !
!SMTPSocket categoriesFor: #mailFrom:to:text:!public! !
!SMTPSocket categoriesFor: #quit!public! !
!SMTPSocket categoriesFor: #recipient:!public! !

!SMTPSocket class methodsFor!

deliverMailFrom: fromAddress to: recipientList text: messageText usingServer: serverName 
	"Deliver a single email to a list of users and then close the connection. 
	For delivering multiple messages, it is best to create a single connection 
	and send all mail over it. NOTE: the recipient list should be a collection 
	of simple internet style addresses -- no '<>' or '()' stuff"

	| sock |
	sock := self usingServer: serverName.
	sock	mailFrom: fromAddress
		to: recipientList
		text: messageText.
	sock quit.
	sock close.
	^true!

example
	"A simple fast test sending messages to yourself

	self example
	"

	| sock |
	self deliverMailFrom: 'yourName@yourDomain'
		to: #( 'destinationName@destinationDomain' 'destinationName2@destinationDomain2')
		text: 'From: yourName
To: receiverName
Subject: Stupid Test!!

Hello from Dolphin guys :)'
		usingServer: 'yourSMTPserver'!

usingServer: serverName 
	"Create and answer a SMTP socket to the specified server for sending one or more 
	mail messages"

	| sock |
	sock := self port: 25 host: serverName.
	sock connectToSMTPServer.
	^sock! !
!SMTPSocket class categoriesFor: #deliverMailFrom:to:text:usingServer:!public! !
!SMTPSocket class categoriesFor: #example!public! !
!SMTPSocket class categoriesFor: #usingServer:!public! !

