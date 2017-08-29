"Filed out from Dolphin Smalltalk 7"!

Object subclass: #EMailObject
	instanceVariableNames: 'content contentType contentEncoding contentDisposition contentId boundary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMailObject guid: (GUID fromString: '{8d9ff3ee-2edc-4eb7-b47f-d3d6b534d4a0}')!
EMailObject comment: ''!
!EMailObject categoriesForClass!Unclassified! !
!EMailObject methodsFor!

addMultipleStrings: anArray withStart: aString on: aStream withSeparator: aSepString 
	anArray isNilOrEmpty ifTrue: [^self].
	anArray isString 
		ifTrue: 
			[aStream
				nextPutAll: aString;
				nextPutAll: (self getWordEncodedStringFor: anArray);
				cr.
			^self].
	aStream nextPutAll: aString.
	anArray size > 1 
		ifTrue: 
			[1 to: anArray size - 1
				do: 
					[:idx | 
					aStream
						nextPutAll: (self getWordEncodedStringFor: (anArray at: idx));
						nextPutAll: aSepString]].
	aStream
		nextPutAll: anArray last;
		cr!

boundary

	^boundary!

content

	^content!

content: aString

	content := aString!

contentDisposition

	^contentDisposition!

contentDisposition: anArray 
	contentDisposition := anArray!

contentEncoding

	^contentEncoding!

contentEncoding: anArray

	contentEncoding := anArray!

contentId

	^contentId!

contentId: aString

	contentId := aString!

contentType

	^contentType!

contentType: anArray

	contentType := anArray!

createFrom: aString messageStart: anIndex
	| header |
	header := self parseHeader: (aString copyFrom: 1 to: anIndex).
	contentType := self parseInformation: (header at: #'content-type' ifAbsent: [])
				separator: $;.
	contentEncoding := self 
				parseInformation: (header at: #'content-transfer-encoding' ifAbsent: [])
				separator: $;.
	contentDisposition := self 
				parseInformation: (header at: #'content-disposition' ifAbsent: [])
				separator: $;.
	(contentId := self parseInformation: (header at: #'content-id' ifAbsent: []) separator: $;) 
		notNil 
			ifTrue: 
				[contentId first = $< ifTrue: [contentId removeAtIndex: 1].
				contentId last = $> ifTrue: [contentId removeAtIndex: contentId size]].
	content := aString copyFrom: anIndex to: aString size.
	boundary := self contentType isNil 
				ifFalse: 
					[self contentType 
						detect: [:each | (each beginsWith: 'boundary=') or: [each beginsWith: 'Boundary=']]
						ifNone: []].
	boundary isNil 
		ifFalse: 
			[(boundary at: 10) = $" 
				ifTrue: [boundary := '--' , (boundary copyFrom: 11 to: boundary size - 1)]
				ifFalse: [boundary := '--' , (boundary copyFrom: 10 to: boundary size)]]!

CRLF
	^##(String with: 13 asCharacter with: 10 asCharacter)!

CRLFHTAB
	^
	##(String 
		with: 13 asCharacter
		with: 10 asCharacter
		with: 9 asCharacter)!

CRLFSPACE
	^
	##(String 
		with: 13 asCharacter
		with: 10 asCharacter
		with: 32 asCharacter)!

decodeMessage
	contentEncoding isNil ifTrue: [^content].
	^EmailMIMEDecoder decodeFrom: content withEncoding: contentEncoding first!

decodeMessage: msgEncod 
	| enc |
	enc := contentEncoding isNil 
				ifTrue: 
					[msgEncod isNil ifTrue: [^content].
					msgEncod first]
				ifFalse: [contentEncoding first].
	enc isNil ifTrue: [^content].
	^EmailMIMEDecoder decodeFrom: content withEncoding: enc!

emailDispositionAttachment
	^'attachment'!

emailDispositionInline
	^'inline'!

emailMimeTypeTextHtml
	^'text/html'!

emailMimeTypeTextPlain
	^'text/plain'!

fileType
	^contentType notNil ifTrue: [contentType first]!

getWordEncodedStringFor: aStringOrNil 
	| utfString ws |
	aStringOrNil isNilOrEmpty ifTrue: [^aStringOrNil].
	utfString := aStringOrNil asUTF8String.
	(utfString conform: [:each | each asInteger < 128]) 
		ifTrue: 
			["needs no encoding since it is already ASCII"
			^aStringOrNil].
	ws := WriteStream on: String new.
	ws
		nextPutAll: '=?UTF-8?B?';
		nextPutAll: ((EmailBase64Encoder encodeFrom: utfString) reject: [:eachCh | eachCh isSeparator]);
		nextPutAll: '?='.
	^ws contents!

HTAB
	^9 asCharacter!

isMultipart
	^boundary notNil!

lineSeparator

	^13 asCharacter!

parseHeader: aString 
	| lastHeader lastItem index tempItem headerDict |
	headerDict := LookupTable new.
	aString lines do: 
			[:each | 
			(each size > 0 and: [each first = self SPACE or: [each first = self HTAB]]) 
				ifTrue: 
					[lastItem := lastItem asString , ' ' , each trimSeparators.
					lastHeader isNil ifFalse: [headerDict at: lastHeader put: lastItem]]
				ifFalse: 
					[index := each indexOf: $:.
					index = 0 
						ifFalse: 
							[lastHeader := (each copyFrom: 1 to: index - 1) asLowercase asSymbol.
							lastItem := (each copyFrom: index + 2 to: each size) trimSeparators.
							tempItem := headerDict at: lastHeader ifAbsent: [].
							tempItem isNil ifFalse: [lastItem := tempItem trimSeparators , ' ' , lastItem].
							headerDict at: lastHeader put: lastItem]]].
	^headerDict!

parseInformation: aString separator: aCharacter 
	| items |
	aString isNil ifTrue: [^nil].
	items := aString itcSubStrings: aCharacter.
	^items collect: [:each | each trimSeparators]!

setBoundary
	boundary := '1__=' , ItcSystemManager generateShortRandomString 
				, ((Time now asSeconds printStringRadix: 16) copyFrom: 4) 
					, ((Time microsecondClockValue printStringRadix: 16) copyFrom: 4) 
					, ((Time millisecondClockValue printStringRadix: 16) copyFrom: 4) 
					, (((Time microsecondClockValue bitXor: 230876) printStringRadix: 16) copyFrom: 4) 
					, (((Time millisecondClockValue bitXor: 760823) printStringRadix: 16) copyFrom: 4)!

SPACE
	^$ ! !
!EMailObject categoriesFor: #addMultipleStrings:withStart:on:withSeparator:!private! !
!EMailObject categoriesFor: #boundary!accessing!public! !
!EMailObject categoriesFor: #content!accessing!public! !
!EMailObject categoriesFor: #content:!accessing!public! !
!EMailObject categoriesFor: #contentDisposition!public! !
!EMailObject categoriesFor: #contentDisposition:!public! !
!EMailObject categoriesFor: #contentEncoding!accessing!public! !
!EMailObject categoriesFor: #contentEncoding:!accessing!public! !
!EMailObject categoriesFor: #contentId!public! !
!EMailObject categoriesFor: #contentId:!public! !
!EMailObject categoriesFor: #contentType!accessing!public! !
!EMailObject categoriesFor: #contentType:!accessing!public! !
!EMailObject categoriesFor: #createFrom:messageStart:!public! !
!EMailObject categoriesFor: #CRLF!private! !
!EMailObject categoriesFor: #CRLFHTAB!private! !
!EMailObject categoriesFor: #CRLFSPACE!private! !
!EMailObject categoriesFor: #decodeMessage!public! !
!EMailObject categoriesFor: #decodeMessage:!public! !
!EMailObject categoriesFor: #emailDispositionAttachment!public! !
!EMailObject categoriesFor: #emailDispositionInline!public! !
!EMailObject categoriesFor: #emailMimeTypeTextHtml!public! !
!EMailObject categoriesFor: #emailMimeTypeTextPlain!public! !
!EMailObject categoriesFor: #fileType!public! !
!EMailObject categoriesFor: #getWordEncodedStringFor:!private! !
!EMailObject categoriesFor: #HTAB!private! !
!EMailObject categoriesFor: #isMultipart!public! !
!EMailObject categoriesFor: #lineSeparator!private! !
!EMailObject categoriesFor: #parseHeader:!public! !
!EMailObject categoriesFor: #parseInformation:separator:!public! !
!EMailObject categoriesFor: #setBoundary!public! !
!EMailObject categoriesFor: #SPACE!private! !

!EMailObject class methodsFor!

createFrom: aString 
	| headerEnd |
	headerEnd := (aString indexOfSubCollection: EMailHeader headerSeparator startingAt: 1) 
				+ 4.
	^headerEnd <= 4 
		ifFalse: [self new createFrom: aString messageStart: headerEnd]
		ifTrue: 
			[(self new)
				content: aString;
				yourself]! !
!EMailObject class categoriesFor: #createFrom:!public! !

