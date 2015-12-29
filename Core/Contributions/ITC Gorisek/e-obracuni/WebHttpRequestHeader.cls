"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebHttpRequestHeader
	instanceVariableNames: 'lines command url version headerFields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpRequestHeader guid: (GUID fromString: '{E859E05B-00F8-4E7C-86DE-B1F13EB410B5}')!
WebHttpRequestHeader comment: ''!
!WebHttpRequestHeader categoriesForClass!Unclassified! !
!WebHttpRequestHeader methodsFor!

acceptEncoding
	^self at: 'Accept-Encoding' ifAbsent: ['']!

acceptLanguage
	^self at: 'Accept-Language' ifAbsent: ['']!

acceptsLanguage: langName 
	^(self acceptLanguage indexOfSubCollection: langName startingAt: 1) > 0!

at: aKey 
	^self at: aKey ifAbsent: []!

at: aKey ifAbsent: aBlock 
	^headerFields at: aKey asUppercase ifAbsent: aBlock!

clientHandlesInternetExplorerCompression
	| acceptEncoding userAgent index |
	acceptEncoding := headerFields at: 'ACCEPT-ENCODING' ifAbsent: [^false].
	userAgent := headerFields at: 'USER-AGENT' ifAbsent: [^false].

	"Internet Explorer 4.x or more"
	('gzip, deflate' = acceptEncoding and: 
			[(index := userAgent indexOfSubCollection: 'MSIE ' startingAt: 1) > 0 
				and: [(userAgent at: index + 5) > $3]]) 
		ifTrue: [^true].

	^false!

clientHandlesMozillaCompression
	| acceptEncoding userAgent |
	acceptEncoding := headerFields at: 'ACCEPT-ENCODING' ifAbsent: [^false].
	userAgent := headerFields at: 'USER-AGENT' ifAbsent: [^false].

	"Mozilla"
	((acceptEncoding beginsWith: 'gzip,') 
		and: [(userAgent indexOfSubCollection: 'Gecko' startingAt: 1) > 0]) ifTrue: [^true].
	^false!

clientHandlesOperaCompression
	| acceptEncoding userAgent index |
	acceptEncoding := headerFields at: 'ACCEPT-ENCODING' ifAbsent: [^false].
	userAgent := headerFields at: 'USER-AGENT' ifAbsent: [^false].

	"Opera 6.x"
	('deflate, gzip, x-gzip, identity, *;q=0' = acceptEncoding and: 
			[(index := userAgent indexOfSubCollection: 'Opera' startingAt: 1) > 0 
				and: [(userAgent at: index + 6) > $5]]) 
		ifTrue: [^true].
	^false!

command
	^command!

contentLength
	^(headerFields at: 'CONTENT-LENGTH' ifAbsent: []) itcAsInteger!

contentType
	^headerFields at: 'CONTENT-TYPE' ifAbsent: []!

cookie
	^self at: 'COOKIE'!

cookieAt: cookieName 
	"Answer value at cookie named cookieName.
	Answer <nil> if cookie value is not received."

	| str tokens |
	(str := headerFields at: 'COOKIE' ifAbsent: []) isNilOrEmpty ifTrue: [^nil].
	(str itcSubStrings: $;) do: 
			[:eachToken | 
			tokens := eachToken itcSubStrings: $=.
			tokens size = 2 
				ifTrue: [(tokens at: 1) trimBlanks = cookieName ifTrue: [^(tokens at: 2) trimBlanks]]].
	^nil!

generateRedirectionHeaderFor: clientIP secure: aBoolean on: stream 
	"Write HTTP header message for redirecting requests.
	It will set the following fields:
		Connection: Close
		http(s)IP: <ip number of the request originator>"

	lines do: 
			[:each | 
			(each beginsWithUppercase: 'CONNECTION:') 
				ifFalse: 
					[stream
						nextPutAll: each;
						cr]].
	true == aBoolean 
		ifTrue: [stream nextPutAll: 'Connection: Close
httpsIP: ']
		ifFalse: [stream nextPutAll: 'Connection: Close
httpIP: '].
	stream
		nextPutAll: clientIP;
		nextPutAll: '

'!

getHeaderFieldsFrom: stream 
	| previousLine line tab space |
	tab := $	.
	space := $ .
	headerFields := LookupTable new.
	[stream atEnd not and: [(line := stream nextLine) notEmpty]] whileTrue: 
			[lines add: line.
			(line first = tab or: [line first = tab]) 
				ifTrue: 
					["This is a folded line"
					previousLine isNil ifTrue: [^nil].	"invalid location to fold"
					line := line trimSeparators.
					previousLine := previousLine , line]
				ifFalse: 
					[previousLine isNil ifFalse: [self parseHeaderLine: previousLine].
					previousLine := line]].
	previousLine isNil ifFalse: [self parseHeaderLine: previousLine]!

getUrlPathOnly
	^(url includes: $?) ifFalse: [url] ifTrue: [url copyFrom: 1 to: (url indexOf: $?) - 1]!

host
	"Answer value of the Host field. This is used for virtual hosting where multiple domain names
	are registered with the same IP address. Then when the HTTP request comes the server can
	distinguish which web address has to be served."

	^headerFields at: 'HOST' ifAbsent: []!

ifModifiedSince
	"Answer <nil> if field is absent. Answer a timestamp and file size as array."

	| str tokens fileSize day monthIndex year date timeTokens time result |
	str := headerFields at: 'IF-MODIFIED-SINCE' ifAbsent: [^nil].
	
	[tokens := ReadStream on: str subStrings.
	tokens next.
	day := tokens next itcAsInteger.
	monthIndex := #('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec') 
				indexOf: tokens next.
	year := tokens next itcAsInteger.
	date := Date 
				newDay: day
				monthIndex: monthIndex
				year: year.
	timeTokens := tokens next itcSubStrings: $:.
	time := Time 
				hours: (timeTokens at: 1) itcAsInteger
				minutes: (timeTokens at: 2) itcAsInteger
				seconds: (timeTokens at: 3) itcAsInteger.
	tokens next.
	(tokens atEnd not and: [((str := tokens next) indexOfSubCollection: 'length=' startingAt: 1) = 1]) 
		ifTrue: [fileSize := (str copyFrom: 8 to: str size) itcAsInteger].
	result := Array with: (Timestamp date: date time: time) with: fileSize] 
			on: Error
			do: [:sig | sig exitWith: nil].
	^result!

initialize
	url := ''.
	command := ''.
	headerFields := LookupTable new!

initializeFrom: stream 
	| tokens line |
	lines := OrderedCollection new.
	(line := stream nextLine) isEmpty 
		ifTrue: 
			[line := stream nextLine.
			line isEmpty 
				ifTrue: 
					[line := stream nextLine.
					line isEmpty ifTrue: [self error: 'HTTP request header is not valid. Too many empty lines']]].
	tokens := self subStrings: (lines add: line) separator: $ .

	"Check the version field (third element -- if absent, then this is an HTTP/0.9 request). If 
	incompatible, then return an error. Ignore extra fields in %tokens for forwards 
	compatibility."
	version := tokens size < 3 ifTrue: ['HTTP/0.9'] ifFalse: [tokens at: 3].
	tokens size < 2 
		ifTrue: 
			[self error: 'HTTP Request header is not valid. Invalid HTTP request line: ' , line asWebString].
	url := tokens at: 2.
	command := (tokens at: 1) asUppercase.
	self getHeaderFieldsFrom: stream!

initializeOnUrl: aString 
	url := aString.
	command := 'GET'!

isKeepAlive
	^(headerFields at: 'CONNECTION' ifAbsent: ['']) asUppercase = 'KEEP-ALIVE'!

messageContents
	| stream |
	stream := WriteStream on: (String new: 2048).
	lines do: 
			[:each | 
			stream
				nextPutAll: each;
				cr].
	^stream contents!

parseHeaderLine: line 
	| stream headerKey headerValue |
	stream := ReadStream on: line.
	headerKey := stream itcUpToAll: ': '.
	headerValue := stream upToEnd trimSeparators.
	headerFields at: headerKey asUppercase put: headerValue!

printHeaderOn: stream 
	| ws |
	ws := WriteStream on: (String new: 1024).
	lines do: 
			[:each | 
			ws
				nextPutAll: each;
				cr].
	ws nextPutAll: '

'.
	stream nextPutAll: ws contents!

printOn: aStream 
	command printOn: aStream.
	aStream nextPut: $ .
	url printOn: aStream!

setCookie: cookieString 
	^headerFields at: 'COOKIE' put: cookieString!

setPath: newPath 
	lines at: 1 put: command , ' ' , newPath , ' HTTP/1.1'!

setUserAgent: userAgentString 
	^headerFields at: 'USER-AGENT' put: userAgentString!

subStrings: line separator: separator 
	| index results lineSize |
	results := OrderedCollection new: 3.
	index := 1.
	lineSize := line size.
	
	[[index <= lineSize and: [(line at: index) == separator]] whileTrue: [index := index + 1].
	index <= lineSize] 
			whileTrue: 
				[| start |
				start := index.
				[index <= lineSize and: [(line at: index) ~~ separator]] whileTrue: [index := index + 1].
				results add: (line copyFrom: start to: index - 1)].
	^results!

url
	^url!

userAgent
	^self at: 'User-Agent' ifAbsent: ['']! !
!WebHttpRequestHeader categoriesFor: #acceptEncoding!public! !
!WebHttpRequestHeader categoriesFor: #acceptLanguage!public! !
!WebHttpRequestHeader categoriesFor: #acceptsLanguage:!public! !
!WebHttpRequestHeader categoriesFor: #at:!public! !
!WebHttpRequestHeader categoriesFor: #at:ifAbsent:!public! !
!WebHttpRequestHeader categoriesFor: #clientHandlesInternetExplorerCompression!public! !
!WebHttpRequestHeader categoriesFor: #clientHandlesMozillaCompression!public! !
!WebHttpRequestHeader categoriesFor: #clientHandlesOperaCompression!public! !
!WebHttpRequestHeader categoriesFor: #command!public! !
!WebHttpRequestHeader categoriesFor: #contentLength!public! !
!WebHttpRequestHeader categoriesFor: #contentType!public! !
!WebHttpRequestHeader categoriesFor: #cookie!public! !
!WebHttpRequestHeader categoriesFor: #cookieAt:!public! !
!WebHttpRequestHeader categoriesFor: #generateRedirectionHeaderFor:secure:on:!public! !
!WebHttpRequestHeader categoriesFor: #getHeaderFieldsFrom:!public! !
!WebHttpRequestHeader categoriesFor: #getUrlPathOnly!public! !
!WebHttpRequestHeader categoriesFor: #host!public! !
!WebHttpRequestHeader categoriesFor: #ifModifiedSince!public! !
!WebHttpRequestHeader categoriesFor: #initialize!public! !
!WebHttpRequestHeader categoriesFor: #initializeFrom:!public! !
!WebHttpRequestHeader categoriesFor: #initializeOnUrl:!public! !
!WebHttpRequestHeader categoriesFor: #isKeepAlive!public! !
!WebHttpRequestHeader categoriesFor: #messageContents!public! !
!WebHttpRequestHeader categoriesFor: #parseHeaderLine:!public! !
!WebHttpRequestHeader categoriesFor: #printHeaderOn:!public! !
!WebHttpRequestHeader categoriesFor: #printOn:!public! !
!WebHttpRequestHeader categoriesFor: #setCookie:!public! !
!WebHttpRequestHeader categoriesFor: #setPath:!public! !
!WebHttpRequestHeader categoriesFor: #setUserAgent:!public! !
!WebHttpRequestHeader categoriesFor: #subStrings:separator:!public! !
!WebHttpRequestHeader categoriesFor: #url!public! !
!WebHttpRequestHeader categoriesFor: #userAgent!public! !

