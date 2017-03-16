"Filed out from Dolphin Smalltalk 7"!

Object subclass: #HttpClient
	instanceVariableNames: 'serverHostname serverPort cookies host location lastUrl acceptEncoding userAgent proxyServer proxyServerPort proxyServerUsername proxyServerPassword lastSocket autoRedirect authorization maxRandomDelay minRequestDelay lastRequestTime randomNumberGenerator mimeMapping'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpClient guid: (GUID fromString: '{0e660abb-78e7-48f3-bf7a-f578ff32c531}')!
HttpClient comment: ''!
!HttpClient categoriesForClass!Unclassified! !
!HttpClient methodsFor!

addCookie: aHttpCookie 
	self 
		setCookie: aHttpCookie name
		value: aHttpCookie value
		path: aHttpCookie path!

autoRedirect
	^autoRedirect == true!

autoRedirect: aBoolean 
	autoRedirect := aBoolean!

basicGetResponseFor: httpCommand url: url contents: contents contentType: contentType referer: referer writeStream: writeStream readStream: readStream additionalRequestHeaderFields: additionalRequestHeaderFields 
	| stream response coll |
	stream := WriteStream on: (String new: 2048).
	stream nextPutAll: httpCommand , ' ' , (self proxiedURL: url) 
				, ' HTTP/1.1
Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*
'.
	referer isNil ifFalse: [stream nextPutAll: 'Referer: ' , referer , '
'].
	stream nextPutAll: 'Accept-Language: sl
'.
	acceptEncoding isNil ifFalse: [stream nextPutAll: 'Accept-Encoding: ' , acceptEncoding , '
'].
	stream 
		nextPutAll: 'User-Agent: ' , (userAgent isNil 
						ifTrue: ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)']
						ifFalse: [userAgent]) 
				, '
'.
	host isNil ifFalse: [stream nextPutAll: 'Host: ' , host , '
'].
	proxyServerUsername isNil 
		ifFalse: 
			[stream 
				nextPutAll: 'Proxy-Authorization: Basic ' 
						, (EmailBase64Encoder new encodeString: proxyServerUsername , ':' , proxyServerPassword) , '
'].
	authorization isNil ifFalse: [stream nextPutAll: 'Authorization: ' , authorization , '
'].
	location isNil ifFalse: [stream nextPutAll: 'Location: ' , location , '
'].
	contents isNil ifFalse: [stream nextPutAll: 'Content-Length: ' , contents size printString , '
'].
	contentType isNil ifFalse: [stream nextPutAll: 'Content-Type: ' , contentType , '
'].
	additionalRequestHeaderFields isNilOrEmpty 
		ifFalse: 
			[additionalRequestHeaderFields keysAndValuesDo: 
					[:eachKey :eachValue | 
					stream
						nextPutAll: eachKey;
						nextPutAll: ': ';
						nextPutAll: eachValue;
						nextPutAll: '
']].
	stream nextPutAll: 'Connection: Close
'.
	coll := cookies select: [:eachCookie | url beginsWith: eachCookie path].
	coll isEmpty 
		ifFalse: 
			[stream nextPutAll: 'Cookie: '.
			coll doWithIndex: 
					[:eachCookie :i | 
					i = 1 ifFalse: [stream nextPutAll: '; '].
					stream nextPutAll: eachCookie name , '=' , eachCookie value].
			stream nextPutAll: '
'].
	stream nextPutAll: '
'.
	(contents isNil or: [contents isString]) 
		ifTrue: 
			[contents isNil ifFalse: [stream nextPutAll: contents].
			writeStream nextPutAll: stream contents.
			writeStream flush]
		ifFalse: 
			[writeStream
				isBytes: true;
				nextPutAll: stream contents asByteArray , contents;
				flush;
				isBytes: false].
	lastUrl := url.
	response := HttpClientResponse new readFrom: readStream.
	response getCookies do: 
			[:eachNewCookie | 
			cookies := cookies 
						reject: [:eachCookie | eachCookie name = eachNewCookie name and: [eachCookie path = eachNewCookie path]].
			cookies add: eachNewCookie].
	^response!

checkBoundary: aString for: fields 
	"Private - Preveri ali se boundary string pojavlja kjerkoli v vsebini.
	Ce se pojavi, je potrebno izbrati drugi boundary string."

	fields do: 
			[:each | 
			each value isString 
				ifTrue: [(each value indexOfSubCollection: aString startingAt: 1) = 0 ifFalse: [^false]]
				ifFalse: 
					[(each value value indexOfSubCollection: aString startingAt: 1) = 0 ifFalse: [^false]]].
	^true!

close
	lastSocket isNil 
		ifFalse: 
			[[lastSocket close] on: Error do: [:ex | ex exitWith: nil].
			lastSocket := nil]!

connection
	| currentDelay |
	minRequestDelay isNil 
		ifFalse: 
			[lastRequestTime isNil 
				ifFalse: 
					[currentDelay := lastRequestTime + minRequestDelay - ItcSystemManager absoluteMillisecondsClockValue.
					currentDelay > 0 ifTrue: [(Delay forMilliseconds: currentDelay) wait]]].
	maxRandomDelay isNil 
		ifFalse: 
			[lastRequestTime isNil 
				ifFalse: 
					[currentDelay := lastRequestTime + minRequestDelay 
								+ ((maxRandomDelay - minRequestDelay itcAsNumberOrZero max: 0) * randomNumberGenerator next) 
										asInteger 
									- ItcSystemManager absoluteMillisecondsClockValue.
					currentDelay > 0 ifTrue: [(Delay forMilliseconds: currentDelay) wait]]].
	lastRequestTime := ItcSystemManager absoluteMillisecondsClockValue.
	^lastSocket := proxyServer isNil 
				ifFalse: [ItcSystemManager newTCPclientSocketToHost: proxyServer port: proxyServerPort]
				ifTrue: [ItcSystemManager newTCPclientSocketToHost: serverHostname port: serverPort]!

cookies
	^cookies!

createRedirectUrlFor: aString 
	^self 
		createRedirectUrlFor: aString
		currentUrl: nil
		concatenateWithCurrentUrl: false!

createRedirectUrlFor: aString currentUrl: aString2 concatenateWithCurrentUrl: aBoolean 
	| currentUrl index |
	(currentUrl := aString2 isNil ifTrue: [lastUrl] ifFalse: [aString2]) isNil 
		ifTrue: [currentUrl := ''].
	(aString beginsWith: '../') 
		ifTrue: 
			[(index := currentUrl lastIndexOf: $/) > 1 
				ifTrue: 
					[currentUrl := currentUrl copyFrom: 1 to: index - 1.
					(index := currentUrl lastIndexOf: $/) > 0 
						ifTrue: [currentUrl := currentUrl copyFrom: 1 to: index]].
			^self 
				createRedirectUrlFor: (aString copyFrom: 4)
				currentUrl: currentUrl
				concatenateWithCurrentUrl: true].
	(aString beginsWith: './') 
		ifTrue: 
			[^self 
				createRedirectUrlFor: (aString copyFrom: 3)
				currentUrl: currentUrl
				concatenateWithCurrentUrl: true].
	aBoolean == true 
		ifTrue: 
			[currentUrl := currentUrl trimBlanks.
			currentUrl last = '/' 
				ifFalse: 
					[(index := currentUrl lastIndexOf: $/) > 0 
						ifTrue: [currentUrl := currentUrl copyFrom: 1 to: index]].
			^currentUrl , aString].
	^aString!

defaultServerPort
	^80!

extensionOf: filepath 
	"Return the extension of @filepath. Answer nil if there is no extension."

	| index nextIndex size |
	index := 0.
	size := filepath size.
	[(nextIndex := filepath indexOf: $. startingAt: index + 1) ~~ 0] 
		whileTrue: [index := nextIndex].
	(index == 0 or: [index = size]) ifTrue: [^nil].
	^filepath copyFrom: index + 1 to: size!

forServer: hostname port: port 
	serverHostname := hostname.
	serverPort := port.
	cookies := OrderedCollection new!

get: url 
	^self 
		getResponseFor: 'GET'
		url: url
		contents: nil
		contentType: nil
		referer: ((lastUrl notNil and: [host notNil]) ifTrue: ['http://' , host , lastUrl])
		additionalRequestHeaderFields: nil!

get: url additionalRequestHeaderFields: additionalRequestHeaderFields 
	^self 
		getResponseFor: 'GET'
		url: url
		contents: nil
		contentType: nil
		referer: ((lastUrl notNil and: [host notNil]) ifTrue: ['http://' , host , lastUrl])
		additionalRequestHeaderFields: additionalRequestHeaderFields!

get: url fields: fields 
	^self 
		getResponseFor: 'GET'
		url: (self urlEncode: url with: fields)
		contents: nil
		contentType: nil
		referer: ((lastUrl notNil and: [host notNil]) ifTrue: ['http://' , host , lastUrl])
		additionalRequestHeaderFields: nil!

get: url fields: fields referer: referer 
	^self 
		getResponseFor: 'GET'
		url: (self urlEncode: url with: fields)
		contents: nil
		contentType: nil
		referer: referer
		additionalRequestHeaderFields: nil!

get: url referer: referer 
	^self 
		getResponseFor: 'GET'
		url: url
		contents: nil
		contentType: nil
		referer: referer
		additionalRequestHeaderFields: nil!

getResponseFor: httpCommand url: url contents: contents contentType: contentType referer: referer additionalRequestHeaderFields: additionalRequestHeaderFields 
	^self 
		getResponseFor: httpCommand
		url: url
		contents: contents
		contentType: contentType
		referer: referer
		redirectTries: 0
		additionalRequestHeaderFields: additionalRequestHeaderFields!

getResponseFor: httpCommand url: url contents: contents contentType: contentType referer: referer redirectTries: redirectTries additionalRequestHeaderFields: additionalRequestHeaderFields 
	| response socket writeStream readStream |
	socket := self connection.
	Processor activeProcess webHttpClientSocketToClose: socket.
	
	[writeStream := socket writeStream.
	writeStream isBytes: false.
	readStream := socket readStream.
	readStream isBytes: false.
	response := self 
				basicGetResponseFor: httpCommand
				url: url
				contents: contents
				contentType: contentType
				referer: referer
				writeStream: writeStream
				readStream: readStream
				additionalRequestHeaderFields: additionalRequestHeaderFields.
	response statusLine = 'HTTP/1.1 100 Continue' 
		ifTrue: 
			[response := HttpClientResponse new readFrom: readStream.
			response getCookies do: 
					[:eachNewCookie | 
					cookies := cookies 
								reject: [:eachCookie | eachCookie name = eachNewCookie name and: [eachCookie path = eachNewCookie path]].
					cookies add: eachNewCookie]]] 
			ensure: 
				[Processor activeProcess webHttpClientSocketToClose: nil.
				socket close.
				socket := nil].
	(autoRedirect == true and: 
			["Object Moved (or Moved Temporarily) redirection response"
			((response statusLine ifNil: ['']) beginsWith: 'HTTP/1.1 302') and: [redirectTries < 3]]) 
		ifTrue: 
			[response := self 
						getResponseFor: httpCommand
						url: (self createRedirectUrlFor: (response headerFieldAt: 'LOCATION'))
						contents: contents
						contentType: contentType
						referer: referer
						redirectTries: redirectTries + 1
						additionalRequestHeaderFields: additionalRequestHeaderFields].
	^response!

getServerUrl
	"Answer URL of the server for which this client is initialized."

	^(self class == HttpClient ifTrue: ['http://'] ifFalse: ['https://']) , serverHostname 
		, (serverPort = self defaultServerPort ifTrue: [''] ifFalse: [':' , serverPort printString])!

getUrl: url 
	| server port path str index |
	(url beginsWith: 'http://') ifFalse: [self error: 'Bad url'].
	str := url copyFrom: 8 to: url size.
	index := str indexOf: $/.
	index > 1 ifFalse: [self error: 'Bad url'].
	path := str copyFrom: index to: str size.
	str := str copyFrom: 1 to: index - 1.
	index := str indexOf: $:.
	index = 0 
		ifTrue: 
			[server := str.
			port := 80]
		ifFalse: 
			[(index = 1 or: [index = str size]) ifTrue: [self error: 'Bad url'].
			server := str copyFrom: 1 to: index - 1.
			port := (str copyFrom: index + 1 to: str size) itcAsInteger].
	^self get: path!

lastUrl
	^lastUrl!

lastUrlBasePath
	| str |
	lastUrl isNilOrEmpty ifTrue: [^'/'].
	str := lastUrl reverse.
	^(str copyFrom: (str indexOf: $/) to: str size) reverse!

mimeMapping
	mimeMapping isNil ifTrue: [mimeMapping := self class defaultMimeMapping].
	^mimeMapping!

mimeTypeOf: filepath 
	"Answer the MIME type of the file at @filepath.
	Answer nil if the MIME type cannot be determined."

	| extension |
	(extension := self extensionOf: filepath) isNil ifTrue: [^'application/octet-stream'].
	^self mimeMapping at: extension asLowercase ifAbsent: ['application/octet-stream']!

multipartFormDataEncode: fields 
	| boundary stream |
	stream := WriteStream on: String new.
	
	[boundary := '---------------------------' , ItcSystemManager generateRandomString.
	self checkBoundary: boundary for: fields] 
			whileFalse: [].
	fields do: 
			[:each | 
			stream
				nextPutAll: '--';
				nextPutAll: boundary;
				nextPutAll: '
Content-Disposition: form-data; name="';
				nextPutAll: each key;
				nextPut: $".
			each value isString 
				ifFalse: 
					["file upload"
					stream
						nextPutAll: '; filename="';
						nextPutAll: each value key;
						nextPutAll: '"
Content-Type: ';
						nextPutAll: (self mimeTypeOf: each value key);
						nextPutAll: '

';
						nextPutAll: each value value]
				ifTrue: 
					["form field"
					stream
						nextPutAll: '

';
						nextPutAll: each value].
			stream nextPutAll: '
'].
	stream
		nextPutAll: '--';
		nextPutAll: boundary;
		nextPutAll: '--
'.
	^Association key: boundary value: stream contents!

post: url contents: postData 
	^self 
		getResponseFor: 'POST'
		url: url
		contents: postData
		contentType: nil
		referer: nil
		additionalRequestHeaderFields: nil!

post: url fields: fields 
	^self 
		getResponseFor: 'POST'
		url: url
		contents: (self postEncode: fields)
		contentType: 'application/x-www-form-urlencoded'
		referer: ((lastUrl notNil and: [host notNil]) ifTrue: ['http://' , host , lastUrl])
		additionalRequestHeaderFields: nil!

post: url fields: fields referer: referer 
	^self 
		getResponseFor: 'POST'
		url: url
		contents: (self postEncode: fields)
		contentType: 'application/x-www-form-urlencoded'
		referer: referer
		additionalRequestHeaderFields: nil!

post: url multipartFormDataEncodedFields: fields 
	| result boundary postContents |
	result := self multipartFormDataEncode: fields.
	boundary := result key.
	postContents := result value.
	^self 
		getResponseFor: 'POST'
		url: url
		contents: postContents
		contentType: 'multipart/form-data; boundary=' , boundary
		referer: ((lastUrl notNil and: [host notNil]) ifTrue: ['http://' , host , lastUrl])
		additionalRequestHeaderFields: nil!

post: url xWwwFormUrlEncodedContents: aString referer: referer 
	^self 
		getResponseFor: 'POST'
		url: url
		contents: aString
		contentType: 'application/x-www-form-urlencoded'
		referer: referer
		additionalRequestHeaderFields: nil!

postEncode: fieldsCollectionOrDictionary 
	| stream firstTime fields |
	firstTime := true.
	stream := WriteStream on: (String new: 1024).
	fields := fieldsCollectionOrDictionary isDictionaryOrLookupTable 
				ifTrue: [fieldsCollectionOrDictionary associations]
				ifFalse: [fieldsCollectionOrDictionary].
	fields do: 
			[:each | 
			firstTime ifFalse: [stream nextPut: $&] ifTrue: [firstTime := false].
			stream
				nextPutAll: each key webHttpUrlEncodedForPost;
				nextPut: $=;
				nextPutAll: (each value isNil ifTrue: [''] ifFalse: [each value webHttpUrlEncodedForPost])].
	^stream contents!

proxiedURL: url 
	"Ce se uporablja proxy streznik bo poslal cel URL s hostname."

	^proxyServer isNil 
		ifTrue: [url]
		ifFalse: 
			['http://' , serverHostname , ((serverPort isNil or: [serverPort = 80]) 
						ifFalse: [':' , serverPort printString]
						ifTrue: ['']) 
				, url]!

proxyServerList
	"Private - See:

	http://www.publicproxyservers.com/page1.html
	"

	^
	[(OrderedCollection new)
		add: '203.162.2.128';
		add: '203.162.2.129';
		add: '203.162.2.133';
		add: '203.162.2.134';
		add: '203.162.2.135';
		add: '203.162.2.138';
		add: '203.162.2.140';
		add: '203.162.2.141';
		add: '203.162.2.143';
		yourself] 
			cachedValue!

setAcceptEncoding: stringValue 
	acceptEncoding := stringValue!

setBasicAuthorizationString: aString 
	authorization := 'Basic ' , (EmailBase64Encoder new encodeString: aString)!

setBasicAuthorizationUsername: username password: password 
	self setBasicAuthorizationString: username , ':' , password!

setCookie: cookieName value: cookieValue path: pathString 
	cookies := cookies 
				reject: [:eachCookie | eachCookie name = cookieName and: [eachCookie path = pathString]].
	cookies add: ((HttpCookie new)
				name: cookieName;
				value: cookieValue;
				path: pathString;
				yourself)!

setHost: aString 
	host := aString!

setLocation: aString 
	location := aString!

setMaxRandomDelay: milliseconds 
	"Set maximum delay between requests. Before every request the HTTP client will calculate a random number in the interval from 0 to milliseconds.

	If the time between now and the last request timestamp is shorter than the random delay, then it will wait until the delay is over before sending the next request.
	"

	maxRandomDelay := milliseconds.
	randomNumberGenerator isNil 
		ifTrue: [randomNumberGenerator := ItcSystemManager newRandomNumberGenerator]!

setMinimumRequestDelay: milliseconds 
	"Set minimum delay between requests."

	minRequestDelay := milliseconds!

setUserAgent: aString 
	userAgent := aString!

setUserAgentAndEncodingForWebPageCompression
	"Set HTTP client user agent and accept-encoding header fields so that if the request will be sent to the e-racuni server, the response will be compressed with ZLIB."

	self
		setAcceptEncoding: 'deflate, gzip, x-gzip, identity, *;q=0';
		setUserAgent: 'Opera/6 [e-racuni download agent]'!

useProxyServer: proxyHost port: proxyPort 
	proxyServer := proxyHost.
	proxyServerPort := proxyPort!

useProxyServerUsername: uid password: pwd 
	proxyServerUsername := uid.
	proxyServerPassword := pwd!

useRandomProxyServer
	| coll proxy |
	randomNumberGenerator isNil 
		ifTrue: [randomNumberGenerator := ItcSystemManager newRandomNumberGenerator].
	coll := self proxyServerList.
	proxy := coll at: (randomNumberGenerator next * (coll size - 1)) rounded + 1.
	proxy isString 
		ifTrue: 
			[proxyServer := proxy.
			proxyServerPort := 80]
		ifFalse: 
			[proxyServer := proxy key.
			proxyServerPort := proxy value].
	ItcSystemManager 
		logLineWithTsAndPID: 'HTTP client using random proxy server at ' , proxyServer , ':' 
				, proxyServerPort asWebString! !
!HttpClient categoriesFor: #addCookie:!public! !
!HttpClient categoriesFor: #autoRedirect!public! !
!HttpClient categoriesFor: #autoRedirect:!public! !
!HttpClient categoriesFor: #basicGetResponseFor:url:contents:contentType:referer:writeStream:readStream:additionalRequestHeaderFields:!private! !
!HttpClient categoriesFor: #checkBoundary:for:!private! !
!HttpClient categoriesFor: #close!public! !
!HttpClient categoriesFor: #connection!public! !
!HttpClient categoriesFor: #cookies!public! !
!HttpClient categoriesFor: #createRedirectUrlFor:!private! !
!HttpClient categoriesFor: #createRedirectUrlFor:currentUrl:concatenateWithCurrentUrl:!private! !
!HttpClient categoriesFor: #defaultServerPort!public! !
!HttpClient categoriesFor: #extensionOf:!public! !
!HttpClient categoriesFor: #forServer:port:!public! !
!HttpClient categoriesFor: #get:!public! !
!HttpClient categoriesFor: #get:additionalRequestHeaderFields:!public! !
!HttpClient categoriesFor: #get:fields:!public! !
!HttpClient categoriesFor: #get:fields:referer:!public! !
!HttpClient categoriesFor: #get:referer:!public! !
!HttpClient categoriesFor: #getResponseFor:url:contents:contentType:referer:additionalRequestHeaderFields:!private! !
!HttpClient categoriesFor: #getResponseFor:url:contents:contentType:referer:redirectTries:additionalRequestHeaderFields:!private! !
!HttpClient categoriesFor: #getServerUrl!public! !
!HttpClient categoriesFor: #getUrl:!public! !
!HttpClient categoriesFor: #lastUrl!public! !
!HttpClient categoriesFor: #lastUrlBasePath!public! !
!HttpClient categoriesFor: #mimeMapping!public! !
!HttpClient categoriesFor: #mimeTypeOf:!public! !
!HttpClient categoriesFor: #multipartFormDataEncode:!private! !
!HttpClient categoriesFor: #post:contents:!public! !
!HttpClient categoriesFor: #post:fields:!public! !
!HttpClient categoriesFor: #post:fields:referer:!public! !
!HttpClient categoriesFor: #post:multipartFormDataEncodedFields:!public! !
!HttpClient categoriesFor: #post:xWwwFormUrlEncodedContents:referer:!public! !
!HttpClient categoriesFor: #postEncode:!private! !
!HttpClient categoriesFor: #proxiedURL:!private! !
!HttpClient categoriesFor: #proxyServerList!private! !
!HttpClient categoriesFor: #setAcceptEncoding:!public! !
!HttpClient categoriesFor: #setBasicAuthorizationString:!authorization!public! !
!HttpClient categoriesFor: #setBasicAuthorizationUsername:password:!authorization!public! !
!HttpClient categoriesFor: #setCookie:value:path:!public! !
!HttpClient categoriesFor: #setHost:!public! !
!HttpClient categoriesFor: #setLocation:!public! !
!HttpClient categoriesFor: #setMaxRandomDelay:!public! !
!HttpClient categoriesFor: #setMinimumRequestDelay:!public! !
!HttpClient categoriesFor: #setUserAgent:!public! !
!HttpClient categoriesFor: #setUserAgentAndEncodingForWebPageCompression!public! !
!HttpClient categoriesFor: #useProxyServer:port:!public! !
!HttpClient categoriesFor: #useProxyServerUsername:password:!public! !
!HttpClient categoriesFor: #useRandomProxyServer!public! !

!HttpClient class methodsFor!

decomposeUrl: url 
	"Answer array with:
		protocolString
		hostname
		port
		path
	"

	| server port path str index protocolString |
	url isNilOrEmpty ifTrue: [self error: 'URL can not be nil or empty'].
	(url beginsWith: 'http://') ifTrue: [protocolString := 'http'].
	(url beginsWith: 'https://') ifTrue: [protocolString := 'https'].
	protocolString isNil ifTrue: [self error: 'No protocol is specified (http or https).'].
	str := url copyFrom: protocolString size + 4 to: url size.
	index := str indexOf: $/.
	index > 1 ifFalse: [self error: 'No url path was found'].
	path := str copyFrom: index to: str size.
	str := str copyFrom: 1 to: index - 1.
	index := str indexOf: $:.
	index = 0 
		ifTrue: 
			[server := str.
			port := protocolString = 'https' ifTrue: [HttpsClient defaultPort] ifFalse: [HttpClient defaultPort]]
		ifFalse: 
			[(index = 1 or: [index = str size]) 
				ifTrue: [self error: 'Invalid syntax for server port specification'].
			server := str copyFrom: 1 to: index - 1.
			port := (str copyFrom: index + 1 to: str size) itcAsInteger].
	^Array 
		with: protocolString
		with: server
		with: port
		with: path!

defaultMimeMapping
	^(LookupTable new)
		at: 'txt' put: 'text/plain';
		at: 'xml' put: 'text/xml';
		at: 'asc' put: 'text/plain';
		at: 'text' put: 'text/plain';
		at: 'htm' put: 'text/html';
		at: 'html' put: 'text/html';
		at: 'css' put: 'text/css';
		at: 'js' put: 'application/x-javascript';
		at: 'tiff' put: 'image/tiff';
		at: 'tif' put: 'image/tiff';
		at: 'gif' put: 'image/gif';
		at: 'png' put: 'image/png';
		at: 'jpg' put: 'image/jpeg';
		at: 'jpeg' put: 'image/jpeg';
		at: 'pcd' put: 'image/x-photo-cd';
		at: 'xbm' put: 'image/x-xbitmap';
		at: 'bmp' put: 'image/x-ms-bitmap';
		at: 'ppm' put: 'image/x-portable-pixmap';
		at: 'pgm' put: 'image/x-portable-graymap';
		at: 'pbm' put: 'image/x-portable-bitmap';
		at: 'au' put: 'audio/basic';
		at: 'aif' put: 'audio/aiff';
		at: 'aiff' put: 'audio/aiff';
		at: 'wav' put: 'audio/wav';
		at: 'mp2' put: 'audio/x-mpeg';
		at: 'mp3' put: 'audio/x-pn-realaudio';
		at: 'mpa' put: 'audio/x-mpeg';
		at: 'abs' put: 'audio/x-mpeg';
		at: 'mpega' put: 'audio/x-mpeg';
		at: 'avi' put: 'video/avi';
		at: 'mpg' put: 'video/mpeg';
		at: 'mpeg' put: 'video/mpeg';
		at: 'mpe' put: 'video/mpeg';
		at: 'mpv' put: 'video/mpeg';
		at: 'vbs' put: 'video/mpeg';
		at: 'mpegv' put: 'video/mpeg';
		at: 'mpa' put: 'video/mpeg';
		at: 'mov' put: 'video/quicktime';
		at: 'swf' put: 'application/x-shockwave-flash';
		at: 'hqx' put: 'application/mac-binhex40';
		at: 'pdf' put: 'application/pdf';
		at: 'bin' put: 'application/octet-stream';
		at: 'exe' put: 'application/octet-stream';
		at: 'ps' put: 'application/postscript';
		at: 'z' put: 'application/x-compress';
		at: 'gz' put: 'application/x-gzip';
		at: 'zip' put: 'application/x-zip';
		at: 'crt' put: 'application/x-x509-ca-cert';
		at: 'der' put: 'application/x-x509-ca-cert';
		at: 'rtf' put: 'application/rtf';
		at: 'tar' put: 'application/x-tar';
		at: 'gtar' put: 'application/x-gtar';
		at: 'doc' put: 'application/msword';
		at: 'dot' put: 'application/msword';
		at: 'xls' put: 'application/vnd.ms-excel';
		at: 'ppt' put: 'application/vnd.ms-powerpoint';
		at: 'sxw' put: 'application/vnd.sun.xml.writer';
		at: 'sxc' put: 'application/vnd.sun.xml.calc';
		at: 'odt' put: 'application/vnd.oasis.opendocument.text';
		at: 'ods' put: 'application/vnd.oasis.opendocument.spreadsheet';
		yourself!

defaultPort
	^80!

forServer: serverAddress 
	"serverAddress je:
		192.168.0.1
		192.168.0.1:8000
		localhost:1234
		localhost
		...
	"

	| index server port |
	index := serverAddress indexOf: $:.
	index = 0 
		ifTrue: 
			[server := serverAddress.
			port := self defaultPort]
		ifFalse: 
			[(index = 1 or: [index = serverAddress size]) ifTrue: [self error: 'Bad server address'].
			server := serverAddress copyFrom: 1 to: index - 1.
			port := (serverAddress copyFrom: index + 1 to: serverAddress size) itcAsInteger].
	^self forServer: server port: port!

forServer: hostname port: port 
	^self new forServer: hostname port: port!

forUrl: url 
	| a |
	a := self decomposeUrl: url.
	^((self serverClassForProtocol: (a at: 1)) forServer: (a at: 2) port: (a at: 3))
		setHost: (a at: 2);
		yourself!

getPathFromUrl: aString 
	^(self decomposeUrl: aString) last!

getUrl: url 
	"This method will get HTML response from an URL. HTTP or HTTPS URL addresses can be used.

	Example:

		HttpClient getUrl: 'https://gorisek.com/racuni/login.html'.

		HttpClient getUrl: 'http://www.google.com/'.

	"

	| a |
	a := self decomposeUrl: url.
	^((self serverClassForProtocol: (a at: 1)) forServer: (a at: 2) port: (a at: 3))
		setHost: (a at: 2);
		get: (a at: 4)!

isValidURL: aString 
	| result |
	result := false.
	
	[self decomposeUrl: aString.
	result := true] on: Error do: [:ex | ].
	(aString includes: $ ) ifTrue: [^false].
	^result!

serverClassForProtocol: aString 
	^aString = 'https' ifTrue: [HttpsClient] ifFalse: [HttpClient]! !
!HttpClient class categoriesFor: #decomposeUrl:!public! !
!HttpClient class categoriesFor: #defaultMimeMapping!public! !
!HttpClient class categoriesFor: #defaultPort!public! !
!HttpClient class categoriesFor: #forServer:!public! !
!HttpClient class categoriesFor: #forServer:port:!public! !
!HttpClient class categoriesFor: #forUrl:!public! !
!HttpClient class categoriesFor: #getPathFromUrl:!public! !
!HttpClient class categoriesFor: #getUrl:!public! !
!HttpClient class categoriesFor: #isValidURL:!public! !
!HttpClient class categoriesFor: #serverClassForProtocol:!private! !

