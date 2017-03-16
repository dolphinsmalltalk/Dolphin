"Filed out from Dolphin Smalltalk 7"!

Object subclass: #EmailSMTPConnector
	instanceVariableNames: 'smtpServer status socket serverID host port'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmailSMTPConnector guid: (GUID fromString: '{6b2859b5-0570-43a7-b1de-0d5e8666a7a5}')!
EmailSMTPConnector comment: ''!
!EmailSMTPConnector categoriesForClass!Unclassified! !
!EmailSMTPConnector methodsFor!

adoptMessage: aString
	| in out line |
	in := ReadStream on: aString.
	out := WriteStream on: (String new: aString size + 100).
	[in atEnd] whileFalse: [
		(line := in nextLine) = '.'
			ifTrue: [out nextPutAll: '..']
			ifFalse: [out nextPutAll: line].
		out cr ].
	^out contents!

close
	socket isNil ifFalse: [socket close].
	socket := nil!

connect
	socket isNil 
		ifTrue: 
			[socket := ItcSystemManager newTCPclientSocketToHost: host port: self class SMTPPORT.
			socket readStream isBytes: false]!

CONNECTERROR

	^100!

DATAENDERROR

	^105!

DATASTARTERROR

	^104!

extractEmail: aString 
	| idx idx2 |
	aString isNil ifTrue: [^nil].
	idx := aString indexOf: $< ifAbsent: [^aString].
	^(idx2 := aString indexOf: $> startingAt: idx) = 0 
		ifFalse: [aString copyFrom: idx + 1 to: idx2 - 1]!

extractEmails: anArray 
	| aCollection aString |
	aCollection := OrderedCollection new.
	anArray do: 
			[:each | 
			aString := self extractEmail: each.
			aString isNil ifFalse: [aCollection add: aString]].
	^aCollection!

finalize
	self close.
	^super finalize!

forward: anEMailMessage to: anArray 
	"Directly forward e-mail message without changing the sender. E-mail redirection...."

	(anEMailMessage isKindOf: EMailMessage) 
		ifFalse: [^self error: 'The message to send is not an EMailMessage!!'].
	anArray isNil ifTrue: [^self error: 'No email recipients defined!!'].
	anArray isEmpty ifTrue: [^self error: 'No email recipient defined!!'].
	self 
		sendMessageString: anEMailMessage getEMailMessageSourceForSending
		to: anArray
		as: anEMailMessage sender
		domain: anEMailMessage getSenderDomain!

forwardInline: anEMailMessage withMsg: aString from: anEmailString to: aToArray cc: aCcArray bcc: aBccArray 
	"Forward e-mail message with changing the sender. Forward inline."

	| newMsg newEMailMsg newHeader writeStream |
	(anEMailMessage isKindOf: EMailMessage) 
		ifFalse: [^self error: 'The message to send is not an EMailMessage!!'].
	(aToArray isNil and: [aCcArray isNil and: [aBccArray isNil]]) 
		ifTrue: [^self error: 'No recipients are defined!!'].
	newEMailMsg := anEMailMessage copy.
	newMsg := newEMailMsg message copy.
	newHeader := newEMailMsg header copy.
	newEMailMsg message: newMsg.
	newEMailMsg header: newHeader.
	newHeader
		subject: '[Fwd: ' , newEMailMsg subject , ']';
		sender: anEmailString;
		addressTo: aToArray;
		addressCC: aCcArray;
		addressBCC: aBccArray.
	newEMailMsg getRecipients isEmpty ifTrue: [^self error: 'No recipients are defined!!'].
	writeStream := WriteStream on: String new.
	aString isNil 
		ifFalse: 
			[writeStream
				nextPutAll: aString;
				cr].
	writeStream
		nextPutAll: '-------- Original Message --------
Subject: ';
		nextPutAll: anEMailMessage subject;
		nextPutAll: '
Date: ';
		nextPutAll: anEMailMessage header sendDate;
		nextPutAll: '
From: ';
		nextPutAll: anEMailMessage header sender;
		nextPutAll: '
To: '.
	anEMailMessage header addressTo doWithIndex: 
			[:each :idx | 
			writeStream nextPutAll: each.
			idx < anEMailMessage header addressTo size ifTrue: [writeStream nextPutAll: '; ']].
	anEMailMessage header addressCC isNil 
		ifFalse: 
			[writeStream nextPutAll: '
Cc: '.
			anEMailMessage header addressCC doWithIndex: 
					[:each :idx | 
					writeStream nextPutAll: each.
					idx < anEMailMessage header addressCC size ifTrue: [writeStream nextPutAll: '; ']]].
	writeStream
		cr;
		cr;
		nextPutAll: newMsg content.
	newMsg content: writeStream contents.
	self 
		sendMessageString: newEMailMsg getEMailMessageSourceForSending
		to: newEMailMsg getRecipients
		as: newEMailMsg sender
		domain: newEMailMsg getSenderDomain!

forwardMessageOnly: anEMailMessage to: anArray 
	"Directly forward e-mail message without changing the sender, but without attachments. E-mail redirection...."

	(anEMailMessage isKindOf: EMailMessage) 
		ifFalse: [^self error: 'The message to send is not an EMailMessage!!'].
	anArray isNil ifTrue: [^self error: 'No email recipients defined!!'].
	anArray isEmpty ifTrue: [^self error: 'No email recipient defined!!'].
	self 
		sendMessageString: anEMailMessage getEMailMessageSourceWithoutAttachments
		to: anArray
		as: anEMailMessage sender
		domain: anEMailMessage getSenderDomain!

forwardQuoted: anEMailMessage withMsg: aString from: anEmailString to: aToArray cc: aCcArray bcc: aBccArray 
	"Forward e-mail message with changing the sender. Forward as qouted message."

	| newMsg newEMailMsg newHeader writeStream |
	(anEMailMessage isKindOf: EMailMessage) 
		ifFalse: [^self error: 'The message to send is not an EMailMessage!!'].
	(aToArray isNil and: [aCcArray isNil and: [aBccArray isNil]]) 
		ifTrue: [^self error: 'No recipient are defined!!'].
	newEMailMsg := anEMailMessage copy.
	newMsg := newEMailMsg message copy.
	newHeader := newEMailMsg header copy.
	newEMailMsg message: newMsg.
	newEMailMsg header: newHeader.
	newHeader
		subject: '[Fwd: ' , newEMailMsg subject , ']';
		sender: anEmailString;
		addressTo: aToArray;
		addressCC: aCcArray;
		addressBCC: aBccArray.
	newEMailMsg getRecipients isEmpty ifTrue: [^self error: 'No recipients are defined!!'].
	writeStream := WriteStream on: String new.
	aString isNil 
		ifFalse: 
			[writeStream
				nextPutAll: aString;
				cr].
	writeStream
		nextPutAll: anEMailMessage header sender;
		nextPutAll: ' wrote:
'.
	newMsg content lines do: 
			[:each | 
			writeStream
				nextPutAll: '> ';
				nextPutAll: each;
				cr].
	newMsg content: writeStream contents.
	self 
		sendMessageString: newEMailMsg getEMailMessageSourceForSending
		to: newEMailMsg getRecipients
		as: newEMailMsg sender
		domain: newEMailMsg getSenderDomain!

getResponse: anErrorID 
	| response |
	Processor activeProcess webHttpClientSocketToClose: socket.
	
	[response := socket readStream nextLine asString.
	response size < 4 or: [(response at: 4) = $-]] 
			whileTrue.
	(response first = $2 or: [response first = $3]) ifFalse: [self error: 'SMTP error: ' , response].
	^response!

HELOERROR

	^101!

host: hostname

	host := hostname !

LOGOUTERROR

	^106!

MAILFROMERROR

	^102!

RCPTTOERROR

	^103!

sendCommand: aString withErrorID: anInteger 
	Processor activeProcess webHttpClientSocketToClose: socket.
	(socket writeStream)
		sendLine: aString;
		flush.
	^self getResponse: anInteger!

sendMessage: anEMailMessage 
	"Send message."

	(anEMailMessage isKindOf: EMailMessage) 
		ifFalse: [^self error: 'The message to send is not an EMailMessage!!'].
	anEMailMessage getRecipients isNil ifTrue: [^self error: 'No email recipients defined!!'].
	anEMailMessage getRecipients isEmpty ifTrue: [^self error: 'No email recipient defined!!'].
	self 
		sendMessageString: anEMailMessage getEMailMessageSourceForSending
		to: anEMailMessage getRecipients
		as: anEMailMessage sender
		domain: anEMailMessage getSenderDomain!

sendMessages: messages

	"TO DO: this method could be optimized."

	messages do: [:each | self sendMessage: each ].!

sendMessageString: aString to: anRecipientsArray as: aSenderString domain: aDomainString 
	| response recipients |
	anRecipientsArray isNil ifTrue: [^self error: 'No email recipients defined!!'].
	anRecipientsArray isEmpty ifTrue: [^self error: 'No email recipient defined!!'].
	recipients := self extractEmails: anRecipientsArray.
	socket isNil ifTrue: [self connect].
	socket isClosed ifTrue: [self connect].
	response := self getResponse: self CONNECTERROR.
	serverID := response copyFrom: 5 to: response size.
	self sendCommand: 'HELO ' , aDomainString withErrorID: self HELOERROR.
	self sendCommand: 'MAIL FROM:' , (self extractEmail: aSenderString)
		withErrorID: self MAILFROMERROR.
	recipients 
		do: [:each | self sendCommand: 'RCPT TO:' , each withErrorID: self RCPTTOERROR].
	self sendCommand: 'DATA' withErrorID: self DATASTARTERROR.
	self sendCommand: (self adoptMessage: aString) , '
.' withErrorID: self DATAENDERROR.
	self sendCommand: 'QUIT' withErrorID: self LOGOUTERROR.
	socket close.
	socket := nil! !
!EmailSMTPConnector categoriesFor: #adoptMessage:!public! !
!EmailSMTPConnector categoriesFor: #close!public! !
!EmailSMTPConnector categoriesFor: #connect!private! !
!EmailSMTPConnector categoriesFor: #CONNECTERROR!private! !
!EmailSMTPConnector categoriesFor: #DATAENDERROR!private! !
!EmailSMTPConnector categoriesFor: #DATASTARTERROR!private! !
!EmailSMTPConnector categoriesFor: #extractEmail:!public! !
!EmailSMTPConnector categoriesFor: #extractEmails:!public! !
!EmailSMTPConnector categoriesFor: #finalize!private! !
!EmailSMTPConnector categoriesFor: #forward:to:!public! !
!EmailSMTPConnector categoriesFor: #forwardInline:withMsg:from:to:cc:bcc:!public! !
!EmailSMTPConnector categoriesFor: #forwardMessageOnly:to:!public! !
!EmailSMTPConnector categoriesFor: #forwardQuoted:withMsg:from:to:cc:bcc:!public! !
!EmailSMTPConnector categoriesFor: #getResponse:!public! !
!EmailSMTPConnector categoriesFor: #HELOERROR!private! !
!EmailSMTPConnector categoriesFor: #host:!public! !
!EmailSMTPConnector categoriesFor: #LOGOUTERROR!private! !
!EmailSMTPConnector categoriesFor: #MAILFROMERROR!private! !
!EmailSMTPConnector categoriesFor: #RCPTTOERROR!private! !
!EmailSMTPConnector categoriesFor: #sendCommand:withErrorID:!public! !
!EmailSMTPConnector categoriesFor: #sendMessage:!public! !
!EmailSMTPConnector categoriesFor: #sendMessages:!public! !
!EmailSMTPConnector categoriesFor: #sendMessageString:to:as:domain:!public! !

!EmailSMTPConnector class methodsFor!

forSMTPHost: aString

	^super new
		addToBeFinalized;
		host: aString !

SMTPPORT

	^25! !
!EmailSMTPConnector class categoriesFor: #forSMTPHost:!public! !
!EmailSMTPConnector class categoriesFor: #SMTPPORT!public! !

