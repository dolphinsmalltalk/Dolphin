"Filed out from Dolphin Smalltalk 7"!

EMailObject subclass: #EMailBasicMessage
	instanceVariableNames: 'textContent htmlContent attachments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMailBasicMessage guid: (GUID fromString: '{1c9fdf62-96e6-400b-8096-f7e7d7577e2a}')!
EMailBasicMessage comment: ''!
!EMailBasicMessage categoriesForClass!Unclassified! !
!EMailBasicMessage methodsFor!

addAttachment: anEMailAttachment
	attachments isNil ifTrue: [attachments := OrderedCollection new].
	attachments add: anEMailAttachment!

addHtmlPartTo: stream
	htmlContent isNil ifTrue: [^nil].
	self isMultipart 
		ifTrue: 
			[stream
				nextPutAll: '--' , self boundary;
				cr].
	stream
		nextPutAll: 'Content-type: text/html';
		cr;
		nextPutAll: 'Content-transfer-encoding: quoted-printable';
		cr;
		nextPutAll: htmlContent.
	attachments notEmpty 
		ifTrue: 
			[attachments do: 
					[:each | 
					stream
						nextPutAll: self boundary;
						cr;
						nextPutAll: each toString]].
	^stream!

addTextPartTo: stream
	textContent isNil ifTrue: [^nil].
	self isMultipart 
		ifTrue: 
			[stream
				nextPutAll: '--' , self boundary;
				cr].
	stream
		nextPutAll: 'Content-type: text/plain';
		cr;
		nextPutAll: 'Content-transfer-encoding: quoted-printable';
		cr;
		nextPutAll: textContent.
	^stream!

attachments

	^attachments!

getMessageContentAsUTF8Base64Encoded
	^EmailBase64Encoder encodeFrom: self content asUTF8String!

htmlContent

	^htmlContent isNil ifFalse: [htmlContent].!

htmlContent: aString

	htmlContent := aString.!

isMultipart

	^((textContent notNil and: [htmlContent notNil]) or: [attachments notEmpty])!

parseMultipart: multipartObject 
	| parts partObject attachmentParts decodedContent |
	multipartObject boundary isNil ifTrue: [^self].
	parts := multipartObject content trimSeparators splitString: multipartObject boundary.
	attachmentParts := OrderedCollection new.
	parts do: 
			[:each | 
			each = '--' 
				ifFalse: 
					[partObject := EMailObject createFrom: each.
					partObject boundary notNil 
						ifTrue: [self parseMultipart: partObject]
						ifFalse: 
							[(partObject fileType = self emailMimeTypeTextPlain 
								or: [partObject fileType = self emailMimeTypeTextHtml]) 
									ifTrue: 
										[decodedContent := partObject decodeMessage: partObject contentEncoding.
										partObject fileType = self emailMimeTypeTextPlain 
											ifTrue: [textContent := decodedContent]
											ifFalse: [htmlContent := decodedContent]]
									ifFalse: [attachmentParts add: each]]]].
	attachmentParts notEmpty 
		ifTrue: [attachments addAll: (EMailAttachment createFrom: attachmentParts)]!

postProcess
	| parts multipartObject attachmentParts decodedContent |
	attachments := OrderedCollection new.
	boundary isNil ifTrue: [^self].
	parts := self content trimSeparators splitString: boundary.
	attachmentParts := OrderedCollection new.
	parts do: 
			[:each | 
			each = '--' 
				ifFalse: 
					[multipartObject := EMailObject createFrom: each.
					multipartObject boundary notNil 
						ifTrue: [self parseMultipart: multipartObject]
						ifFalse: 
							[(multipartObject fileType = self emailMimeTypeTextPlain 
								or: [multipartObject fileType = self emailMimeTypeTextHtml]) 
									ifTrue: 
										[decodedContent := multipartObject decodeMessage: multipartObject contentEncoding.
										multipartObject fileType = self emailMimeTypeTextPlain 
											ifTrue: [textContent := decodedContent]
											ifFalse: [htmlContent := decodedContent]]
									ifFalse: [attachmentParts add: each]]]].
	attachmentParts notEmpty 
		ifTrue: [attachments addAll: (EMailAttachment createFrom: attachmentParts)]!

stripMsgToSize: anInteger

	anInteger > content size ifTrue: [ ^self ].
	content := content copyFrom: 1 to: anInteger!

textContent
	textContent isNil ifTrue: [textContent := self decodeMessage: self contentEncoding].
	^textContent!

textContent: aString
	
	textContent := aString!

toString
	| stream |
	stream := WriteStream on: String new.
	self isMultipart 
		ifTrue: 
			[self setBoundary.
			stream
				nextPutAll: 'Content-type: multipart/mixed; boundary=' , self boundary;
				cr].
	self addTextPartTo: stream.
	self addHtmlPartTo: stream.
	self isMultipart 
		ifTrue: 
			[stream
				nextPutAll: self boundary , '--';
				cr].
	^stream contents!

toStringWithHeader
	| stream |
	stream := WriteStream on: String new.
	self 
		addMultipleStrings: contentType
		withStart: 'Content-type: '
		on: stream
		withSeparator: '; '.
	self 
		addMultipleStrings: contentEncoding
		withStart: 'Content-transfer-encoding: '
		on: stream
		withSeparator: '; '.
	self 
		addMultipleStrings: contentDisposition
		withStart: 'Content-Disposition: '
		on: stream
		withSeparator: '; '.
	contentType isNil ifFalse: [stream cr].
	stream
		nextPutAll: content;
		cr.
	^stream contents! !
!EMailBasicMessage categoriesFor: #addAttachment:!public! !
!EMailBasicMessage categoriesFor: #addHtmlPartTo:!public! !
!EMailBasicMessage categoriesFor: #addTextPartTo:!public! !
!EMailBasicMessage categoriesFor: #attachments!public! !
!EMailBasicMessage categoriesFor: #getMessageContentAsUTF8Base64Encoded!private! !
!EMailBasicMessage categoriesFor: #htmlContent!public! !
!EMailBasicMessage categoriesFor: #htmlContent:!public! !
!EMailBasicMessage categoriesFor: #isMultipart!public! !
!EMailBasicMessage categoriesFor: #parseMultipart:!private! !
!EMailBasicMessage categoriesFor: #postProcess!public! !
!EMailBasicMessage categoriesFor: #stripMsgToSize:!public! !
!EMailBasicMessage categoriesFor: #textContent!public! !
!EMailBasicMessage categoriesFor: #textContent:!public! !
!EMailBasicMessage categoriesFor: #toString!public! !
!EMailBasicMessage categoriesFor: #toStringWithHeader!public! !

!EMailBasicMessage class methodsFor!

createFrom: aString 
	| message |
	message := super createFrom: aString.
	^message
		postProcess;
		yourself!

createFrom: aString hasHeader: aBoolean 
	| headerEnd |
	aBoolean ifTrue: [^super createFrom: aString].
	^(self new)
		content: aString;
		yourself! !
!EMailBasicMessage class categoriesFor: #createFrom:!public! !
!EMailBasicMessage class categoriesFor: #createFrom:hasHeader:!public! !

