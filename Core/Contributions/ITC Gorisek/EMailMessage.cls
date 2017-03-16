"Filed out from Dolphin Smalltalk 7"!

Object subclass: #EMailMessage
	instanceVariableNames: 'header message attachments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMailMessage guid: (GUID fromString: '{8d6edb01-ef40-4904-9476-e6aef0f0e513}')!
EMailMessage comment: ''!
!EMailMessage categoriesForClass!Unclassified! !
!EMailMessage methodsFor!

addAttachment: aString 
	"adds an attachment to the current EMailMessage. It has to be a text attachment and 8bit encoded"

	| anAttachment |
	header boundary isNil ifTrue: [header setBoundary].
	header contentType isNil ifTrue: [header setMultipart].
	anAttachment := EMailAttachment new.
	anAttachment
		contentType: 'text/plain';
		contentEncoding: '8bit';
		content: aString.
	attachments isNil ifTrue: [attachments := OrderedCollection new].
	(attachments isKindOf: OrderedCollection) 
		ifFalse: [attachments := attachments asOrderedCollection].
	attachments add: anAttachment!

addBccRecipient: aString

"adds a BCC recipient, aString has to be formulated as email@domain.com or Name <email@domain.com>"

	header addBccRecipient: aString!

addBccRecipients: aString 
	"adds a BCC recipients, aString has to be formulated as email@domain.com or Name <email@domain.com> and separated with ; "

	| stream |
	stream := ReadStream on: aString.
	[stream atEnd] whileFalse: [self addBccRecipient: (stream upTo: $;) trimBlanks]!

addCcRecipient: aString 
	(aString itcSubStrings: $;) 
		do: [:each | each trimBlanks isEmpty ifFalse: [header addCcRecipient: each trimBlanks]]!

addCcRecipients: aString 
	"adds a CC recipients, aString has to be formulated as email@domain.com or Name <email@domain.com> and separated with ; "

	| stream |
	stream := ReadStream on: aString.
	[stream atEnd] whileFalse: [self addCcRecipient: (stream upTo: $;) trimBlanks]!

addFileAttachment: aFilename 
	"adds a file as an attachment to the current EMailMessage. The encoding type is set according to the filename type (.txt,.zip)"

	| anAttachment |
	header boundary isNil ifTrue: [header setBoundary].
	header contentType isNil ifTrue: [header setMultipart].
	anAttachment := EMailAttachment new.
	anAttachment addFile: aFilename.
	attachments isNil ifTrue: [attachments := OrderedCollection new].
	(attachments isKindOf: OrderedCollection) 
		ifFalse: [attachments := attachments asOrderedCollection].
	attachments add: anAttachment!

addStreamAttachment: aStream filename: aFilename 
	"adds a file as an attachment to the current EMailMessage. The encoding type is set according to the filename type (.txt,.zip)"

	| anAttachment |
	header boundary isNil ifTrue: [header setBoundary].
	header contentType isNil ifTrue: [header setMultipart].
	anAttachment := EMailAttachment new.
	anAttachment addFromStream: aStream filename: aFilename.
	attachments isNil ifTrue: [attachments := OrderedCollection new].
	(attachments isKindOf: OrderedCollection) 
		ifFalse: [attachments := attachments asOrderedCollection].
	attachments add: anAttachment!

addToRecipient: aString 
	"Adds a TO recipient, aString has to be formulated as email@domain.com or Name <email@domain.com>."

	aString isNilOrEmpty 
		ifFalse: 
			[(aString itcSubStrings: $;) 
				do: [:each | each trimBlanks isEmpty ifFalse: [header addToRecipient: each trimBlanks]]]!

addToRecipients: aString 
	"adds a TO recipients, aString has to be formulated as email@domain.com or Name <email@domain.com> and separated with ; "

	| stream |
	stream := ReadStream on: aString.
	[stream atEnd] whileFalse: [self addToRecipient: (stream upTo: $;) trimBlanks]!

attachments: anEMailAttachmentArray

	attachments := anEMailAttachmentArray!

charset
	| msgType |
	msgType := message contentType isNil 
				ifTrue: [header contentType]
				ifFalse: [message contentType].
	msgType isNil ifTrue: [^nil].
	msgType 
		do: [:each | (each beginsWith: 'charset') ifTrue: [^((each itcSubStrings: $=) at: 2) trimSeparators]].
	^nil!

dateFromEmailString: aString 
	| months token1 token2 token3 token4 stream day month year |
	months := #('JAN' 'FEB' 'MAR' 'APR' 'MAY' 'JUN' 'JUL' 'AUG' 'SEP' 'OCT' 'NOV' 'DEC').
	stream := ReadStream on: aString.
	token1 := stream upTo: $ .
	token2 := stream upTo: $ .
	token3 := stream upTo: $ .
	token4 := stream upTo: $ .
	(months includes: token2 asUppercase) 
		ifTrue: 
			[day := token1.
			month := token2.
			year := token3]
		ifFalse: 
			[day := token2.
			month := token3.
			year := token4].
	(day notEmpty and: [month notEmpty and: [year notEmpty]]) ifFalse: [^nil].
	^Date 
		newDay: day itcAsInteger
		month: month
		year: year itcAsInteger!

dateReceived
	| idx dateString |
	self header received isNil ifTrue: [^nil].
	idx := self header received indexOf: $;.
	idx = 0 ifTrue: [^nil].
	dateString := self header received copyFrom: idx + 2
				to: (idx + 32 min: self header received size).
	^self timestampFromEString: dateString!

dateReceivedGMT
	| idx dateString |
	self header received isNil ifTrue: [^nil].
	idx := self header received indexOf: $;.
	idx = 0 ifTrue: [^nil].
	dateString := self header received copyFrom: idx + 2 to: idx + 32.
	^self timestampFromEString: dateString timeOffset: 0!

decodeToCentralEuropean: aString 
	| writeStream |
	writeStream := WriteStream on: String new.
	aString do: 
			[:each | 
			each > 168 asCharacter 
				ifTrue: 
					[each = 185 asCharacter ifTrue: [writeStream nextPut: $s].
					each = 232 asCharacter ifTrue: [writeStream nextPut: $c].
					each = 190 asCharacter ifTrue: [writeStream nextPut: $z].
					each = 169 asCharacter ifTrue: [writeStream nextPut: $S].
					each = 200 asCharacter ifTrue: [writeStream nextPut: $C].
					each = 174 asCharacter ifTrue: [writeStream nextPut: $Z].
					each = 252 asCharacter ifTrue: [writeStream nextPutAll: #($u $e)].
					each = 246 asCharacter ifTrue: [writeStream nextPutAll: #($o $e)].
					each = 228 asCharacter ifTrue: [writeStream nextPutAll: #($a $e)].
					each = 220 asCharacter ifTrue: [writeStream nextPutAll: #($U $E)].
					each = 214 asCharacter ifTrue: [writeStream nextPutAll: #($O $E)].
					each = 196 asCharacter ifTrue: [writeStream nextPutAll: #($A $E)]]
				ifFalse: [writeStream nextPut: each]].
	^writeStream contents!

extractEmail: aString
	| idx idx2 |
	aString isNil ifTrue: [^nil].
	(aString includes: $@) ifFalse: [^nil].
	(idx := aString indexOf: $<) = 0 ifTrue: [^aString].
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

getCCRecipients
	^header addressCC!

getEMailMessageSourceForSending
	| stream |
	stream := WriteStream on: String new.
	self isMultiplePart ifTrue: [header setBoundary].
	stream
		nextPutAll: header getEMailMessageHeaderSource;
		cr.
	self isMultiplePart 
		ifTrue: 
			[stream
				nextPutAll: '--';
				nextPutAll: header boundary;
				cr;
				nextPutAll: message toStringWithHeader]
		ifFalse: [stream nextPutAll: message getMessageContentAsUTF8Base64Encoded].
	attachments isNil 
		ifFalse: 
			[attachments do: 
					[:each | 
					self isMultiplePart 
						ifTrue: 
							[stream
								nextPutAll: '--';
								nextPutAll: header boundary;
								cr].
					stream nextPutAll: each toString]].
	self isMultiplePart 
		ifTrue: 
			[stream
				nextPutAll: '--';
				nextPutAll: header boundary;
				nextPutAll: '--'].
	^stream contents!

getEMailMessageSourceWithoutAttachments
	"Private - Answer message source for sending e-mail message without its attachments."

	| stream headerCopy |
	stream := WriteStream on: String new.
	headerCopy := header copy.
	self isMultiplePart 
		ifTrue: 
			[headerCopy boundary: nil.
			headerCopy contentType: message contentType.
			headerCopy contentEncoding: message contentEncoding.
			headerCopy contentDisposition: message contentDisposition].
	stream
		nextPutAll: headerCopy getEMailMessageHeaderSource;
		cr;
		nextPutAll: message content.
	^stream contents!

getHTMLAttachments
	"Answer html attachments of the message (if any exists) as a String."

	^message attachments!

getHTMLMessage
	"Answer the html part of the message (if it exists) as a String."

	^message htmlContent!

getMessage
	"returns the body of the message as a String"

	^message decodeMessage: header contentEncoding!

getMessageAsASCII
	"Returns the message body decoded to plain ASCII text"

	| msgEnc charset msg |
	msgEnc := message contentEncoding isNil 
				ifTrue: 
					[header contentEncoding isNil ifTrue: [^message content].
					header contentEncoding first]
				ifFalse: [message contentEncoding first].
	msgEnc isNil ifTrue: [^message content].
	charset := self charset asString.
	msg := message decodeMessage: header contentEncoding.
	(msgEnc = '8bit' 
		and: [(charset beginsWith: 'iso-8859-2') or: [charset beginsWith: 'Windows-1250']]) 
			ifTrue: [^self decodeToCentralEuropean: msg].
	(msgEnc = 'base64' 
		and: [(charset beginsWith: 'iso-8859-2') or: [charset beginsWith: 'Windows-1250']]) 
			ifTrue: [^self decodeToCentralEuropean: msg].
	^msg!

getMessageContent
	"returns original body text content as fetched from the mail server"

	^message content!

getRecipients
	"returns an array of Strings that contain the full email addresses of persons to recieve (have recieved) the EMailMessage)"

	^header getRecipients!

getSenderDomain
	"returns the domain of sender of the current EMailMessage"

	^header getSenderDomain!

getTextMessage
	"returns the plain-text part of the message as a String"

	^message textContent!

getToRecipients
	^header addressTo!

header
	^header!

header: anEMailHeader 
	header := anEMailHeader!

initialize
	header := EMailHeader new.
	message := EMailBasicMessage new.
	header
		contentType: #('text/plain; format=flowed; charset="UTF-8"');
		contentEncoding: #('base64')!

isMultiplePart

	^attachments notNil!

listAttachments

"returns an array of EMailAttachment objects associated with the current email message"

	^attachments!

message

	^message!

message: aString 
	"Use #setMessage: for setting message text."

	message := aString!

messageID

"returns a messageID (as String) of the current email that should be unique for every email"

	^header messageID!

postProcess
	| removedAttachments |
	attachments notEmpty 
		ifTrue: 
			[removedAttachments := OrderedCollection new: attachments size.
			attachments do: 
					[:each | 
					each isMessagePart 
						ifTrue: 
							[(each fileType = each emailMimeTypeTextHtml 
								or: [each fileType = each emailMimeTypeTextPlain]) 
									ifTrue: 
										[each fileType = each emailMimeTypeTextHtml 
											ifTrue: [message htmlContent: each getContent]
											ifFalse: [message textContent: each getContent]]
									ifFalse: [message addAttachment: each].
							removedAttachments add: each]].
			removedAttachments do: [:each | attachments remove: each ifAbsent: []]]!

replyTo
	^header replyTo!

replyTo: aString 
	header replyTo: aString!

sender
	"returns the full email address of the sender of the current email message"

	^header sender!

sender: aString 
	"sets full email address of the email message sender"

	header sender: aString!

senderEmail
	"returns senders email"

	^self extractEmail: self sender!

senderFullName
	"returns senders email"

	^((ReadStream on: self sender asString) upTo: $<) trimBlanks!

sentDate
	"Answer date sent as an instance of Date."

	^self dateFromEmailString: self header sendDate!

sentTimestamp
	"returns an instance of Timestamp which contains local date and time of the email message when it was sent"

	^self timestampFromEString: self header sendDate!

sentTimestampGMT
	"returns an instance of Timestamp which contains GMT date and time of the email message when it was sent"

	^self timestampFromEString: self header sendDate timeOffset: 0!

setMessage: aString 
	"sets email message's body text and defines it as 8bit encoded"

	message
		contentType: (Array 
					with: 'text/plain; charset=' , (Processor activeProcess webRequestCodePage ifNil: ['iso-8859-2']));
		contentEncoding: #('8bit');
		content: aString!

stripMsgToSize: anInteger 
	message stripMsgToSize: anInteger!

subject
	"returns the email message subject"

	^header subject!

subject: aString 
	"sets the email message subject"

	header subject: aString!

timestampFromEString: aString 
	^self timestampFromEString: aString timeOffset: ItcSystemManager timeZoneMinutesFromGMT!

timestampFromEString: aString timeOffset: minOffset 
	| stream day month year hour min sec date time sign locTimeDiff timeDiff |
	stream := ReadStream on: aString.
	stream skipTo: $ .
	day := (stream upTo: $ ) itcAsInteger.
	month := stream upTo: $ .
	year := (stream upTo: $ ) itcAsInteger.
	(day = 0 or: [month isEmpty or: [year = 0]]) ifTrue: [^nil].
	hour := (stream upTo: $:) itcAsInteger.
	min := (stream upTo: $:) itcAsInteger.
	sec := (stream upTo: $ ) itcAsInteger.
	sign := stream next: 1.
	locTimeDiff := (stream next: 2) itcAsInteger * 60 + (stream next: 2) itcAsInteger.
	sign first = $- ifTrue: [locTimeDiff := locTimeDiff negated].
	date := Date 
				newDay: day
				month: month
				year: year.
	time := Time new 
				hours: hour
				minutes: min
				seconds: sec.
	minOffset - locTimeDiff > 0 ifTrue: [sign := false] ifFalse: [sign := true].
	timeDiff := Time fromSeconds: ((minOffset - locTimeDiff) * 60) abs.
	sign 
		ifTrue: 
			[time asSeconds - timeDiff asSeconds < 0 ifTrue: [date := date subtractDays: 1].
			time := time subtractTime: timeDiff]
		ifFalse: 
			[time asSeconds + timeDiff asSeconds > Time secondsPerDay 
				ifTrue: [date := date addDays: 1].
			time := time addTime: timeDiff].
	^Timestamp date: date time: time! !
!EMailMessage categoriesFor: #addAttachment:!public! !
!EMailMessage categoriesFor: #addBccRecipient:!public! !
!EMailMessage categoriesFor: #addBccRecipients:!public! !
!EMailMessage categoriesFor: #addCcRecipient:!public! !
!EMailMessage categoriesFor: #addCcRecipients:!public! !
!EMailMessage categoriesFor: #addFileAttachment:!public! !
!EMailMessage categoriesFor: #addStreamAttachment:filename:!public! !
!EMailMessage categoriesFor: #addToRecipient:!public! !
!EMailMessage categoriesFor: #addToRecipients:!public! !
!EMailMessage categoriesFor: #attachments:!public! !
!EMailMessage categoriesFor: #charset!public! !
!EMailMessage categoriesFor: #dateFromEmailString:!private! !
!EMailMessage categoriesFor: #dateReceived!public! !
!EMailMessage categoriesFor: #dateReceivedGMT!public! !
!EMailMessage categoriesFor: #decodeToCentralEuropean:!private! !
!EMailMessage categoriesFor: #extractEmail:!public! !
!EMailMessage categoriesFor: #extractEmails:!public! !
!EMailMessage categoriesFor: #getCCRecipients!public! !
!EMailMessage categoriesFor: #getEMailMessageSourceForSending!private! !
!EMailMessage categoriesFor: #getEMailMessageSourceWithoutAttachments!private! !
!EMailMessage categoriesFor: #getHTMLAttachments!public! !
!EMailMessage categoriesFor: #getHTMLMessage!public! !
!EMailMessage categoriesFor: #getMessage!public! !
!EMailMessage categoriesFor: #getMessageAsASCII!public! !
!EMailMessage categoriesFor: #getMessageContent!public! !
!EMailMessage categoriesFor: #getRecipients!public! !
!EMailMessage categoriesFor: #getSenderDomain!public! !
!EMailMessage categoriesFor: #getTextMessage!public! !
!EMailMessage categoriesFor: #getToRecipients!public! !
!EMailMessage categoriesFor: #header!public! !
!EMailMessage categoriesFor: #header:!public! !
!EMailMessage categoriesFor: #initialize!private! !
!EMailMessage categoriesFor: #isMultiplePart!public! !
!EMailMessage categoriesFor: #listAttachments!public! !
!EMailMessage categoriesFor: #message!private! !
!EMailMessage categoriesFor: #message:!private! !
!EMailMessage categoriesFor: #messageID!public! !
!EMailMessage categoriesFor: #postProcess!private! !
!EMailMessage categoriesFor: #replyTo!public! !
!EMailMessage categoriesFor: #replyTo:!public! !
!EMailMessage categoriesFor: #sender!public! !
!EMailMessage categoriesFor: #sender:!public! !
!EMailMessage categoriesFor: #senderEmail!public! !
!EMailMessage categoriesFor: #senderFullName!public! !
!EMailMessage categoriesFor: #sentDate!public! !
!EMailMessage categoriesFor: #sentTimestamp!public! !
!EMailMessage categoriesFor: #sentTimestampGMT!public! !
!EMailMessage categoriesFor: #setMessage:!public! !
!EMailMessage categoriesFor: #stripMsgToSize:!private! !
!EMailMessage categoriesFor: #subject!public! !
!EMailMessage categoriesFor: #subject:!public! !
!EMailMessage categoriesFor: #timestampFromEString:!private! !
!EMailMessage categoriesFor: #timestampFromEString:timeOffset:!private! !

!EMailMessage class methodsFor!

createFrom: aMessage 
	| message msgParts |
	message := self new.
	message header: (EMailHeader createFrom: aMessage).
	message header boundary isNil 
		ifTrue: 
			[message message: (EMailBasicMessage 
						createFrom: (aMessage copyFrom: message header size + 1 to: aMessage size))]
		ifFalse: 
			[msgParts := aMessage splitString: message header boundary.
			message
				attachments: (EMailAttachment createFrom: (msgParts copyFrom: 3 to: msgParts size - 1));
				message: (EMailBasicMessage createFrom: (msgParts at: 2));
				postProcess].
	^message!

new

	^super new initialize! !
!EMailMessage class categoriesFor: #createFrom:!public! !
!EMailMessage class categoriesFor: #new!public! !

