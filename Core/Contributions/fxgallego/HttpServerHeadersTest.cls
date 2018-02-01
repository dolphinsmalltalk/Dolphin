"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #HttpServerHeadersTest
	instanceVariableNames: 'headers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerHeadersTest guid: (GUID fromString: '{d7c7b190-9400-461a-918f-8e1c8466658a}')!
HttpServerHeadersTest comment: ''!
!HttpServerHeadersTest categoriesForClass!Unclassified! !
!HttpServerHeadersTest methodsFor!

setUp
	headers := HttpServerHeaders new!

testAllHeadersIncludeKnownAndUnknown
	headers headerAt: 'Set-Cookie' put: 'a Cookie'.
	headers headerAt: 'foo' put: 'bar'.
	headers headerAt: 'Content-Type' put: 'html/text'.

	self assert: (headers allHeaders at: 'Set-Cookie') = 'a Cookie'.
	self assert: (headers allHeaders at: 'foo') = 'bar'.
	self assert: (headers allHeaders at: 'Content-Type') = 'html/text'.!

testHeadersMap
	"This test somthing that's really private but it's really important too."
	
	| map |
	map := headers headersMap.
	self assert: (map at: 'Last-Modified') = 19.
	self assert: (map at: 'WWW-Authenticate') = 29.
	self assert: (map at: 'Transfer-Encoding') = 6.
	self assert: (map at: 'Accept-Encoding') = 22.
	self assert: (map at: 'Accept-Ranges') = 20.
	self assert: (map at: 'From') = 27.
	self assert: (map at: 'Max-Forwards') = 34.
	self assert: (map at: 'Trailer') = 5.
	self assert: (map at: 'Accept-Charset') = 21.
	self assert: (map at: 'Expect') = 26.
	self assert: (map at: 'Content-Length') = 11.
	self assert: (map at: 'If-Range') = 32.
	self assert: (map at: 'Retry-After') = 25.
	self assert: (map at: 'If-None-Match') = 31.
	self assert: (map at: 'Via') = 8.
	self assert: (map at: 'Warning') = 9.
	self assert: (map at: 'Translate') = 39.
	self assert: (map at: 'ETag') = 22.
	self assert: (map at: 'Content-Language') = 14.
	self assert: (map at: 'Host') = 28.
	self assert: (map at: 'Pragma') = 4.
	self assert: (map at: 'Proxy-Authorization') = 35.
	self assert: (map at: 'Referer') = 36.
	self assert: (map at: 'Vary') = 28.
	self assert: (map at: 'TE') = 38.
	self assert: (map at: 'Age') = 21.
	self assert: (map at: 'Date') = 2.
	self assert: (map at: 'Content-Range') = 17.
	self assert: (map at: 'Cache-Control') = 0.
	self assert: (map at: 'If-Modified-Since') = 30.
	self assert: (map at: 'Expires') = 18.
	self assert: (map at: 'Content-MD5') = 16.
	self assert: (map at: 'If-Unmodified-Since') = 33.
	self assert: (map at: 'If-Match') = 29.
	self assert: (map at: 'Server') = 26.
	self assert: (map at: 'Content-Location') = 15.
	self assert: (map at: 'Content-Type') = 12.
	self assert: (map at: 'Accept-Language') = 23.
	self assert: (map at: 'Upgrade') = 7.
	self assert: (map at: 'Cookie') = 25.
	self assert: (map at: 'Proxy-Authenticate') = 24.
	self assert: (map at: 'Authorization') = 24.
	self assert: (map at: 'Keep-Alive') = 3.
	self assert: (map at: 'Range') = 37.
	self assert: (map at: 'Set-Cookie') = 27.
	self assert: (map at: 'Allow') = 10.
	self assert: (map at: 'User-Agent') = 40.
	self assert: (map at: 'Accept') = 20.
	self assert: (map at: 'Content-Encoding') = 13.
	self assert: (map at: 'Connection') = 1.
	self assert: (map at: 'Location') = 23! !
!HttpServerHeadersTest categoriesFor: #setUp!private! !
!HttpServerHeadersTest categoriesFor: #testAllHeadersIncludeKnownAndUnknown!public! !
!HttpServerHeadersTest categoriesFor: #testHeadersMap!public! !

