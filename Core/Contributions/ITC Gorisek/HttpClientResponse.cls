"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #HttpClientResponse
	instanceVariableNames: 'headerLines headerFields contents parsedPage alreadyUncompressed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpClientResponse guid: (GUID fromString: '{15400BDF-F7F9-43DF-A8C4-CEAEAA453449}')!
HttpClientResponse comment: ''!
!HttpClientResponse categoriesForClass!Unclassified! !
!HttpClientResponse methodsFor!

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

contents
	(headerFields at: 'CONTENT-ENCODING' ifAbsent: ['']) asUppercase = 'DEFLATE' 
		ifTrue: 
			[alreadyUncompressed = true 
				ifFalse: 
					[alreadyUncompressed := true.
					contents := ZLibInterface decompress: contents]].
	^contents!

contentsAsLocalCodePageString
	^(self headerFieldAt: 'CONTENT-TYPE') = 'text/html; charset=utf-8' 
		ifTrue: [self contents webUTF8Decoded]
		ifFalse: [self contents]!

contentType
	^self headerFieldAt: 'CONTENT-TYPE'!

getCookieFromLine: line 
	| tokens token name value path |
	line isNilOrEmpty ifTrue: [^#()].
	tokens := line itcSubStrings: $;.
	path := '/'.
	token := tokens first trimBlanks.
	(token includes: $=) 
		ifTrue: 
			[name := (token itcSubStrings: $=) first.
			value := (token itcSubStrings: $=) size > 1 ifTrue: [(token itcSubStrings: $=) at: 2] ifFalse: ['']]
		ifFalse: 
			[name := token.
			value := ''].
	tokens doWithIndex: 
			[:each :index | 
			index > 1 
				ifTrue: 
					[token := each trimBlanks.
					(token beginsWith: 'path=') ifTrue: [path := token copyFrom: 6 to: token size]]].
	^name isNilOrEmpty 
		ifFalse: 
			[Array with: ((HttpCookie new)
						name: name;
						value: value;
						path: path;
						yourself)]
		ifTrue: [#()]!

getCookies
	| cookies |
	cookies := OrderedCollection new.
	headerLines do: 
			[:line | 
			(line beginsWithUppercase: 'SET-COOKIE: ') 
				ifTrue: [cookies addAll: (self getCookieFromLine: (line copyFrom: 13 to: line size))]].
	^cookies!

headerFieldAt: fieldName 
	^headerFields at: fieldName asUppercase ifAbsent: []!

httpHeaderLocation
	^self headerFieldAt: 'LOCATION'!

httpHeaderLocationLocalPath
	^(HttpClient decomposeUrl: self httpHeaderLocation) at: 4!

readChunkedResponseFrom: stream 
	| contentsStream line chunkSize |
	contentsStream := WriteStream on: (String new: 10240).
	
	[line := stream nextLine.
	chunkSize := self chunkSizeFromString: line.
	chunkSize > 0] 
			whileTrue: 
				[contentsStream nextPutAll: (stream next: chunkSize).
				stream next: 2].
	contents := contentsStream contents.
	stream nextLine!

readFrom: stream 
	| line i contentLength |
	headerLines := OrderedCollection new.
	headerFields := LookupTable new.
	[stream atEnd or: [(line := stream nextLine) isEmpty]] whileFalse: 
			[headerLines add: line.
			((i := line indexOf: $:) > 1 and: [i + 1 < line size]) 
				ifTrue: 
					[headerFields at: (line copyFrom: 1 to: i - 1) asUppercase put: (line copyFrom: i + 2 to: line size)]].
	contentLength := (headerFields at: 'CONTENT-LENGTH' ifAbsent: ['']) trimBlanks.
	"content length is given -> read bytes"
	contentLength isNilOrEmpty 
		ifFalse: 
			[contents := stream next: contentLength itcAsInteger.
			^self].
	"is HTTP/1.1 100 Continue response?"
	self statusLine = 'HTTP/1.1 100 Continue' ifTrue: [^self].
	"if transfer encoding is used parse chunk sizes"
	(headerFields at: 'TRANSFER-ENCODING' ifAbsent: ['']) asUppercase = 'CHUNKED' 
		ifTrue: 
			[self readChunkedResponseFrom: stream.
			^self].
	"else read until connection closes"
	contents := stream itcUpToEnd!

status
	| str index |
	^(str := self statusLine) isNilOrEmpty 
		ifFalse: 
			[index := str indexOf: $ .
			index > 0 ifTrue: [(str copyFrom: index + 1 to: str size) asUppercase]]!

statusCode
	| statusString |
	^(statusString := self status) isNilOrEmpty ifFalse: [statusString itcAsInteger]!

statusLine
	^headerLines isEmpty ifTrue: [''] ifFalse: [headerLines first]! !
!HttpClientResponse categoriesFor: #chunkSizeFromString:!public! !
!HttpClientResponse categoriesFor: #contents!public! !
!HttpClientResponse categoriesFor: #contentsAsLocalCodePageString!public! !
!HttpClientResponse categoriesFor: #contentType!public! !
!HttpClientResponse categoriesFor: #getCookieFromLine:!public! !
!HttpClientResponse categoriesFor: #getCookies!public! !
!HttpClientResponse categoriesFor: #headerFieldAt:!public! !
!HttpClientResponse categoriesFor: #httpHeaderLocation!public! !
!HttpClientResponse categoriesFor: #httpHeaderLocationLocalPath!public! !
!HttpClientResponse categoriesFor: #readChunkedResponseFrom:!public! !
!HttpClientResponse categoriesFor: #readFrom:!public! !
!HttpClientResponse categoriesFor: #status!public! !
!HttpClientResponse categoriesFor: #statusCode!public! !
!HttpClientResponse categoriesFor: #statusLine!public! !

