"Filed out from Dolphin Smalltalk 7"!

EMailObject subclass: #EMailHeader
	instanceVariableNames: 'subject addressFrom addressTo addressCC addressBCC messageID mimeVersion received sendDate references mailer organization replyTo priority'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMailHeader guid: (GUID fromString: '{e0f8b892-4f35-48d8-a43e-c54deefb938d}')!
EMailHeader comment: ''!
!EMailHeader categoriesForClass!Unclassified! !
!EMailHeader methodsFor!

addBccRecipient: aString 
	addressBCC isNil ifTrue: [addressBCC := OrderedCollection new].
	(addressBCC isKindOf: OrderedCollection) 
		ifFalse: [addressBCC := addressBCC asOrderedCollection].
	addressBCC add: aString!

addCcRecipient: aString 
	addressCC isNil ifTrue: [addressCC := OrderedCollection new].
	(addressCC isKindOf: OrderedCollection) 
		ifFalse: [addressCC := addressCC asOrderedCollection].
	addressCC add: aString!

addressBCC

	^addressBCC!

addressBCC: anArray 
	addressBCC := anArray!

addressCC

	^addressCC!

addressCC: anArray 
	addressCC := anArray!

addressTo

	^addressTo!

addressTo: anArray

	addressTo := anArray!

addToRecipient: aString 
	addressTo isNil ifTrue: [addressTo := OrderedCollection new].
	(addressTo isKindOf: OrderedCollection) 
		ifFalse: [addressTo := addressTo asOrderedCollection].
	addressTo add: aString!

boundary: aString

	boundary := aString!

getEMailMessageHeaderSource
	| stream |
	stream := WriteStream on: String new.
	self 
		addMultipleStrings: addressFrom
		withStart: 'From: '
		on: stream
		withSeparator: ', '.
	replyTo isNilOrEmpty 
		ifFalse: 
			[self 
				addMultipleStrings: replyTo
				withStart: 'Reply-To: '
				on: stream
				withSeparator: ', '].
	self
		addMultipleStrings: addressTo
			withStart: 'To: '
			on: stream
			withSeparator: ', ';
		addMultipleStrings: addressCC
			withStart: 'Cc: '
			on: stream
			withSeparator: ', ';
		addMultipleStrings: subject
			withStart: 'Subject: '
			on: stream
			withSeparator: ', '.
	boundary isNil 
		ifTrue: 
			[contentType isNil 
				ifFalse: 
					[self 
						addMultipleStrings: contentType
						withStart: 'Content-Type: '
						on: stream
						withSeparator: '; '].
			contentEncoding isNil 
				ifFalse: 
					[self 
						addMultipleStrings: contentEncoding
						withStart: 'Content-Transfer-Encoding: '
						on: stream
						withSeparator: '; '].
			contentDisposition isNil 
				ifFalse: 
					[self 
						addMultipleStrings: contentDisposition
						withStart: 'Content-Disposition: '
						on: stream
						withSeparator: '; '].
			mimeVersion isNil 
				ifFalse: 
					[stream
						nextPutAll: 'MIME-Version: ';
						nextPutAll: mimeVersion;
						cr]]
		ifFalse: 
			[stream
				nextPutAll: 'MIME-Version: 1.0
Content-type: multipart/mixed; Boundary="';
				nextPutAll: boundary;
				nextPutAll: '"
Content-Disposition: inline
'].
	stream
		nextPutAll: 'X-Mailer: e-racuni.com Mailer';
		cr.
	^stream contents!

getHeader: aKey 
	^self getHeader: aKey from: content!

getHeader: aKey from: aString 
	| index index2 values value |
	index := aString indexOfSubCollection: aKey.
	index = 0 ifTrue: [^nil].
	value := aString copyFrom: index + aKey size
				to: (aString 
						nextIndexOf: self lineSeparator
						from: index
						to: aString size) - 1.
	value last = $; ifFalse: [^(value itcSubStrings: $;) collect: [:each | each trimBlanks]].
	index := index + aKey size + value size + 2.
	values := OrderedCollection new.
	
	[values addAll: ((value itcSubStrings: $;) collect: [:each | each trimBlanks]) asOrderedCollection.
	index2 := aString 
				nextIndexOf: self lineSeparator
				from: index
				to: aString size.
	index2 = 0 ifTrue: [^values asArray].
	value := aString copyFrom: index to: index2 - 1.
	index := index2 + 2.
	value last = $;] 
			whileTrue.
	values addAll: ((value itcSubStrings: $;) collect: [:each | each trimBlanks]) asOrderedCollection.
	^values asArray!

getHeaderOne: aKey 
	^self getHeaderOne: aKey from: content!

getHeaderOne: aKey from: aString 
	| index value |
	index := aString indexOfSubCollection: aKey.
	index = 0 ifTrue: [^nil].
	value := aString copyFrom: index + aKey size
				to: (aString 
						nextIndexOf: self lineSeparator
						from: index - 1
						to: aString size) - 1.
	^value!

getRecipients
	| coll |
	coll := OrderedCollection new.
	addressTo isNil ifFalse: [coll addAll: addressTo].
	addressCC isNil ifFalse: [coll addAll: addressCC].
	addressBCC isNil ifFalse: [coll addAll: addressBCC].
	^coll!

getSenderDomain
	| idx idx2 |
	addressFrom isNil ifTrue: [^nil].
	idx := addressFrom indexOf: $@ ifAbsent: [^nil].
	^(idx2 := addressFrom indexOf: $> startingAt: idx) = 0 
		ifTrue: [addressFrom copyFrom: idx + 1]
		ifFalse: [addressFrom copyFrom: idx + 1 to: idx2 - 1]!

messageID
	^messageID!

received

	^received!

replyTo
	^replyTo!

replyTo: aString 
	replyTo := aString!

retreiveInformation
	| headerDict |
	headerDict := self parseHeader: self content.
	addressFrom := headerDict at: #from ifAbsent: [headerDict at: #sender ifAbsent: []].
	addressTo := self parseInformation: (headerDict at: #to ifAbsent: []) separator: $,.
	addressCC := self parseInformation: (headerDict at: #cc ifAbsent: []) separator: $,.
	sendDate := headerDict at: #date ifAbsent: [].
	messageID := headerDict at: #'message-id' ifAbsent: [].
	contentType := self parseInformation: (headerDict at: #'content-type' ifAbsent: []) separator: $;.
	contentEncoding := self 
				parseInformation: (headerDict at: #'content-transfer-encoding' ifAbsent: [])
				separator: $;.
	contentDisposition := self parseInformation: (headerDict at: #'content-disposition' ifAbsent: [])
				separator: $;.
	subject := headerDict at: #subject ifAbsent: [].
	mailer := headerDict at: #'x-mailer' ifAbsent: [].
	organization := headerDict at: #organization ifAbsent: [].
	mimeVersion := headerDict at: #'mime-version' ifAbsent: [].
	replyTo := headerDict at: #'reply-to' ifAbsent: [].
	priority := headerDict at: #'x-priority' ifAbsent: [].
	received := headerDict at: #received ifAbsent: [].
	references := self parseInformation: (headerDict at: #references ifAbsent: []) separator: $ .
	boundary := contentType isNil 
				ifFalse: 
					[contentType detect: [:each | (each beginsWith: 'boundary=') or: [each beginsWith: 'Boundary=']]
						ifNone: []].
	boundary isNil 
		ifFalse: 
			[(boundary at: 10) = $" 
				ifTrue: [boundary := '--' , (boundary copyFrom: 11 to: boundary size - 1)]
				ifFalse: [boundary := '--' , (boundary copyFrom: 10 to: boundary size)]]!

sendDate
	^sendDate!

sender

	^addressFrom!

sender: aString

	addressFrom := aString!

setMultipart
	boundary isNil ifTrue: [self setBoundary].
	contentType := Array new: 2.
	contentType
		at: 1 put: 'multipart/mixed';
		at: 2 put: 'boundary="' , boundary , '"'!

size
	^content size!

subject

	^subject!

subject: aString

	subject := aString! !
!EMailHeader categoriesFor: #addBccRecipient:!public! !
!EMailHeader categoriesFor: #addCcRecipient:!public! !
!EMailHeader categoriesFor: #addressBCC!accessing!public! !
!EMailHeader categoriesFor: #addressBCC:!accessing!public! !
!EMailHeader categoriesFor: #addressCC!accessing!public! !
!EMailHeader categoriesFor: #addressCC:!accessing!public! !
!EMailHeader categoriesFor: #addressTo!accessing!public! !
!EMailHeader categoriesFor: #addressTo:!accessing!public! !
!EMailHeader categoriesFor: #addToRecipient:!public! !
!EMailHeader categoriesFor: #boundary:!accessing!public! !
!EMailHeader categoriesFor: #getEMailMessageHeaderSource!public! !
!EMailHeader categoriesFor: #getHeader:!public! !
!EMailHeader categoriesFor: #getHeader:from:!public! !
!EMailHeader categoriesFor: #getHeaderOne:!public! !
!EMailHeader categoriesFor: #getHeaderOne:from:!public! !
!EMailHeader categoriesFor: #getRecipients!public! !
!EMailHeader categoriesFor: #getSenderDomain!public! !
!EMailHeader categoriesFor: #messageID!accessing!public! !
!EMailHeader categoriesFor: #received!accessing!public! !
!EMailHeader categoriesFor: #replyTo!accessing!public! !
!EMailHeader categoriesFor: #replyTo:!accessing!public! !
!EMailHeader categoriesFor: #retreiveInformation!public! !
!EMailHeader categoriesFor: #sendDate!accessing!public! !
!EMailHeader categoriesFor: #sender!accessing!public! !
!EMailHeader categoriesFor: #sender:!accessing!public! !
!EMailHeader categoriesFor: #setMultipart!public! !
!EMailHeader categoriesFor: #size!public! !
!EMailHeader categoriesFor: #subject!accessing!public! !
!EMailHeader categoriesFor: #subject:!accessing!public! !

!EMailHeader class methodsFor!

createFrom: aMessage
	| header endIndex |

	endIndex := aMessage indexOfSubCollection: self headerSeparator startingAt: 1.
	endIndex = 0 ifTrue: [ ^nil ].
	header := self new content: (aMessage copyFrom: 1 to: endIndex-1).
	header retreiveInformation.
	^header!

headerSeparator
	^String 
		with: 13 asCharacter
		with: 10 asCharacter
		with: 13 asCharacter
		with: 10 asCharacter! !
!EMailHeader class categoriesFor: #createFrom:!public! !
!EMailHeader class categoriesFor: #headerSeparator!public! !

