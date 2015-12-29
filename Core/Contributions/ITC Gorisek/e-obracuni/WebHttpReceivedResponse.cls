"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebHttpReceivedResponse
	instanceVariableNames: 'clientStream headerLines contents keepAlive'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpReceivedResponse guid: (GUID fromString: '{F7EC767E-7444-447B-81F7-8A27488970A3}')!
WebHttpReceivedResponse comment: ''!
!WebHttpReceivedResponse categoriesForClass!Unclassified! !
!WebHttpReceivedResponse methodsFor!

chunkSizeFromString: aString 
	| hexString hexChars n |
	hexChars := '0123456789ABCDEF'.
	hexString := aString asUppercase.
	n := 0.
	hexString do: 
			[:eachChar | 
			(hexChars includes: eachChar) ifFalse: [^n].
			n := n * 16 + ((hexChars indexOf: eachChar) - 1)].
	^n!

compressResponseForInternetExplorer
		"Do nothing"!

compressResponseForMozilla
		"Do nothing"!

compressResponseForOpera6
		"Do nothing"!

connectionKeepAlive

	keepAlive := true.!

contentLength

	^contents size!

contents
	^contents!

getRedirectionHeader

	| stream |
	stream := WriteStream on: (String new: 2048).
	headerLines do: [:each |
		((each beginsWithUppercase: 'CONTENT-LENGTH:')
			or: [each beginsWithUppercase: 'CONNECTION:'])
			ifFalse: [stream nextPutAll: each; cr]].
	stream
		nextPutAll: 'Content-length: ';
		nextPutAll: contents size printString.
	keepAlive == true
		ifTrue: [stream nextPutAll: '
Connection: Keep-Alive

' ]
		ifFalse: [stream nextPutAll: '
Connection: Close

' ].
	^stream contents!

initializeFrom: stream 
	| line contentLength |
	
	[headerLines := OrderedCollection new.
	contents := ''.
	[(line := stream nextLine) isEmpty] whileFalse: 
			[(line beginsWithUppercase: 'CONTENT-LENGTH:') 
				ifTrue: [contentLength := (line copyFrom: 16 to: line size) itcAsInteger].
			headerLines add: line].
	headerLines isEmpty or: [headerLines first = 'HTTP/1.1 100 Continue']] 
			whileTrue: [].
	contentLength isNil 
		ifFalse: 
			[contents := stream next: contentLength.
			^self].


	"if transfer encoding CHUNKED is used, then parse chunk sizes"
	(headerLines 
		detect: [:eachLine | eachLine beginsWithUppercase: 'TRANSFER-ENCODING: CHUNKED']
		ifNone: []) notNil 
		ifTrue: 
			[contents := self readChunkedResponseFrom: stream.
			headerLines := headerLines 
						reject: [:eachLine | eachLine beginsWithUppercase: 'TRANSFER-ENCODING: CHUNKED'].
			headerLines add: 'Content-length: ' , contents size printString.
			^self].
	"else read up to end of stream"
	contents := stream upToEnd!

initializeFrom: remoteServerStream on: remoteClientStream

	clientStream := remoteClientStream.
	self initializeFrom: remoteServerStream.!

printHeaderOn: aStream 
	| ws |
	ws := WriteStream on: (String new: 1024).
	headerLines do: 
			[:each | 
			ws
				nextPutAll: each;
				cr].
	ws
		cr;
		cr.
	aStream nextPutAll: ws contents!

readChunkedResponseFrom: stream 
	| contentsStream line chunkSize |
	contentsStream := WriteStream on: (String new: 10240).
	
	[line := stream nextLine.
	chunkSize := self chunkSizeFromString: line.
	chunkSize > 0] 
			whileTrue: 
				[contentsStream nextPutAll: (stream next: chunkSize).
				stream next: 2].
	stream nextLine.
	^contentsStream contents!

sendResponse

	clientStream
		nextPutAll: self getRedirectionHeader;
		nextPutAll: contents! !
!WebHttpReceivedResponse categoriesFor: #chunkSizeFromString:!private! !
!WebHttpReceivedResponse categoriesFor: #compressResponseForInternetExplorer!public! !
!WebHttpReceivedResponse categoriesFor: #compressResponseForMozilla!public! !
!WebHttpReceivedResponse categoriesFor: #compressResponseForOpera6!public! !
!WebHttpReceivedResponse categoriesFor: #connectionKeepAlive!public! !
!WebHttpReceivedResponse categoriesFor: #contentLength!public! !
!WebHttpReceivedResponse categoriesFor: #contents!public! !
!WebHttpReceivedResponse categoriesFor: #getRedirectionHeader!public! !
!WebHttpReceivedResponse categoriesFor: #initializeFrom:!public! !
!WebHttpReceivedResponse categoriesFor: #initializeFrom:on:!public! !
!WebHttpReceivedResponse categoriesFor: #printHeaderOn:!public! !
!WebHttpReceivedResponse categoriesFor: #readChunkedResponseFrom:!private! !
!WebHttpReceivedResponse categoriesFor: #sendResponse!public! !

