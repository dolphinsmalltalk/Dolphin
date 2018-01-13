"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerHeaders
	instanceVariableNames: 'knownHeaders unknownHeaders pHeaders pKnownHeaders pUnknownHeaders'
	classVariableNames: ''
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''!
HttpServerHeaders guid: (GUID fromString: '{3c247e66-990d-4f32-b404-83fa77221599}')!
HttpServerHeaders comment: ''!
!HttpServerHeaders categoriesForClass!Unclassified! !
!HttpServerHeaders methodsFor!

allHeaders
	^LookupTable withAll: knownHeaders associations , unknownHeaders associations!

headerAt: name
	self headersMap at: name ifPresent: [:idx | ^knownHeaders at: name].
	^unknownHeaders at: name!

headerAt: name ifAbsent: aBlock
	self headersMap at: name ifPresent: [:idx | ^knownHeaders at: name ifAbsent: aBlock].
	^unknownHeaders at: name ifAbsent: aBlock!

headerAt: name ifPresent: aBlock
	self headersMap at: name ifPresent: [:idx | ^knownHeaders at: name ifPresent: aBlock].
	^unknownHeaders at: name ifPresent: aBlock!

headerAt: name put: value
	self headersMap at: name ifPresent: [:idx | ^knownHeaders at: name put: value].
	^unknownHeaders at: name put: value!

headersMap
	^##(LookupTable new
		at: 'Cache-Control' put: HttpHeaderCacheControl + 1;
		at: 'Connection' put: HttpHeaderConnection + 1;
		at: 'Date' put: HttpHeaderDate + 1;
		at: 'Keep-Alive' put: HttpHeaderKeepAlive + 1;
		at: 'Pragma' put: HttpHeaderPragma + 1;
		at: 'Trailer' put: HttpHeaderTrailer + 1;
		at: 'Transfer-Encoding' put: HttpHeaderTransferEncoding + 1;
		at: 'Upgrade' put: HttpHeaderUpgrade + 1;
		at: 'Via' put: HttpHeaderVia + 1;
		at: 'Warning' put: HttpHeaderWarning + 1;
		at: 'Allow' put: HttpHeaderAllow + 1;
		at: 'Content-Length' put: HttpHeaderContentLength + 1;
		at: 'Content-Type' put: HttpHeaderContentType + 1;
		at: 'Content-Encoding' put: HttpHeaderContentEncoding + 1;
		at: 'Content-Language' put: HttpHeaderContentLanguage + 1;
		at: 'Content-Location' put: HttpHeaderContentLocation + 1;
		at: 'Content-MD5' put: HttpHeaderContentMd5 + 1;
		at: 'Content-Range' put: HttpHeaderContentRange + 1;
		at: 'Expires' put: HttpHeaderExpires + 1;
		at: 'Last-Modified' put: HttpHeaderLastModified + 1;
		at: 'Accept' put: HttpHeaderAccept + 1;
		at: 'Accept-Charset' put: HttpHeaderAcceptCharset + 1;
		at: 'Accept-Encoding' put: HttpHeaderAcceptEncoding + 1;
		at: 'Accept-Language' put: HttpHeaderAcceptLanguage + 1;
		at: 'Authorization' put: HttpHeaderAuthorization + 1;
		at: 'Cookie' put: HttpHeaderCookie + 1;
		at: 'Expect' put: HttpHeaderExpect + 1;
		at: 'From' put: HttpHeaderFrom + 1;
		at: 'Host' put: HttpHeaderHost + 1;
		at: 'If-Match' put: HttpHeaderIfMatch + 1;
		at: 'If-Modified-Since' put: HttpHeaderIfModifiedSince + 1;
		at: 'If-None-Match' put: HttpHeaderIfNoneMatch + 1;
		at: 'If-Range' put: HttpHeaderIfRange + 1;
		at: 'If-Unmodified-Since' put: HttpHeaderIfUnmodifiedSince + 1;
		at: 'Max-Forwards' put: HttpHeaderMaxForwards + 1;
		at: 'Proxy-Authorization' put: HttpHeaderProxyAuthorization + 1;
		at: 'Referer' put: HttpHeaderReferer + 1;
		at: 'Range' put: HttpHeaderRange + 1;
		at: 'TE' put: HttpHeaderTe + 1;
		at: 'Translate' put: HttpHeaderTranslate + 1;
		at: 'User-Agent' put: HttpHeaderUserAgent + 1;
		at: 'Accept-Ranges' put: HttpHeaderAcceptRanges + 1;
		at: 'Age' put: HttpHeaderAge + 1;
		at: 'ETag' put: HttpHeaderEtag + 1;
		at: 'Location' put: HttpHeaderLocation + 1;
		at: 'Proxy-Authenticate' put: HttpHeaderProxyAuthenticate + 1;
		at: 'Retry-After' put: HttpHeaderRetryAfter + 1;
		at: 'Server' put: HttpHeaderServer + 1;
		at: 'Set-Cookie' put: HttpHeaderSetCookie + 1;
		at: 'Vary' put: HttpHeaderVary + 1;
		at: 'WWW-Authenticate' put: HttpHeaderWwwAuthenticate + 1;
		yourself)!

initialize
	super initialize.
	knownHeaders := LookupTable new.
	unknownHeaders := LookupTable new!

read: request
	pHeaders := request Headers.
	pHeaders KnownHeaders keysAndValuesDo: 
			[:eachKey :eachValue |
			eachValue pRawValue
				ifNotNil: [knownHeaders at: (self requestHeaderName: eachKey - 1) put: eachValue pRawValue]].
	pHeaders pUnknownHeaders
		do: [:each | each pRawValue ifNotNil: [unknownHeaders at: each pName put: each pRawValue]].
	pHeaders := nil!

requestHeaderName: anInteger
	"This array differs from the one in HTTP_HEADER because it does not includes the respond headers."
	^##(((0 to: HttpHeaderMaximum) asArray)
		at: HttpHeaderCacheControl + 1 put: 'Cache-Control';
		at: HttpHeaderConnection + 1 put: 'Connection';
		at: HttpHeaderDate + 1 put: 'Date';
		at: HttpHeaderKeepAlive + 1 put: 'Keep-Alive';
		at: HttpHeaderPragma + 1 put: 'Pragma';
		at: HttpHeaderTrailer + 1 put: 'Trailer';
		at: HttpHeaderTransferEncoding + 1 put: 'Transfer-Encoding';
		at: HttpHeaderUpgrade + 1 put: 'Upgrade';
		at: HttpHeaderVia + 1 put: 'Via';
		at: HttpHeaderWarning + 1 put: 'Warning';
		at: HttpHeaderAllow + 1 put: 'Allow';
		at: HttpHeaderContentLength + 1 put: 'Content-Length';
		at: HttpHeaderContentType + 1 put: 'Content-Type';
		at: HttpHeaderContentEncoding + 1 put: 'Content-Encoding';
		at: HttpHeaderContentLanguage + 1 put: 'Content-Language';
		at: HttpHeaderContentLocation + 1 put: 'Content-Location';
		at: HttpHeaderContentMd5 + 1 put: 'Content-MD5';
		at: HttpHeaderContentRange + 1 put: 'Content-Range';
		at: HttpHeaderExpires + 1 put: 'Expires';
		at: HttpHeaderLastModified + 1 put: 'Last-Modified';
		at: HttpHeaderAccept + 1 put: 'Accept';
		at: HttpHeaderAcceptCharset + 1 put: 'Accept-Charset';
		at: HttpHeaderAcceptEncoding + 1 put: 'Accept-Encoding';
		at: HttpHeaderAcceptLanguage + 1 put: 'Accept-Language';
		at: HttpHeaderAuthorization + 1 put: 'Authorization';
		at: HttpHeaderCookie + 1 put: 'Cookie';
		at: HttpHeaderExpect + 1 put: 'Expect';
		at: HttpHeaderFrom + 1 put: 'From';
		at: HttpHeaderHost + 1 put: 'Host';
		at: HttpHeaderIfMatch + 1 put: 'If-Match';
		at: HttpHeaderIfModifiedSince + 1 put: 'If-Modified-Since';
		at: HttpHeaderIfNoneMatch + 1 put: 'If-None-Match';
		at: HttpHeaderIfRange + 1 put: 'If-Range';
		at: HttpHeaderIfUnmodifiedSince + 1 put: 'If-Unmodified-Since';
		at: HttpHeaderMaxForwards + 1 put: 'Max-Forwards';
		at: HttpHeaderProxyAuthorization + 1 put: 'Proxy-Authorization';
		at: HttpHeaderReferer + 1 put: 'Referer';
		at: HttpHeaderRange + 1 put: 'Range';
		at: HttpHeaderTe + 1 put: 'TE';
		at: HttpHeaderTranslate + 1 put: 'Translate';
		at: HttpHeaderUserAgent + 1 put: 'User-Agent';
		yourself) at: anInteger+1!

respondHeaderIndex: name
	^self headersMap at: name!

write: response
	pHeaders := response Headers.
	pKnownHeaders := pHeaders KnownHeaders.
	knownHeaders keysAndValuesDo: 
			[:eachKey :eachValue |
			(self headersMap includesKey: eachKey)
				ifTrue: 
					[pKnownHeaders at: (self respondHeaderIndex: eachKey)
						put: (HTTP_KNOWN_HEADER new
								pRawValue: eachValue;
								yourself)]].
	unknownHeaders notEmpty
		ifTrue: 
			[pUnknownHeaders := StructureArray length: unknownHeaders size elementClass: HTTP_UNKNOWN_HEADER.
			unknownHeaders associations with: pUnknownHeaders
				do: 
					[:header :pHeader |
					pHeader
						pName: header key;
						pRawValue: header value].
			pHeaders pUnknownHeaders: pUnknownHeaders].
	response Headers: pHeaders! !
!HttpServerHeaders categoriesFor: #allHeaders!public! !
!HttpServerHeaders categoriesFor: #headerAt:!public! !
!HttpServerHeaders categoriesFor: #headerAt:ifAbsent:!public! !
!HttpServerHeaders categoriesFor: #headerAt:ifPresent:!public! !
!HttpServerHeaders categoriesFor: #headerAt:put:!public! !
!HttpServerHeaders categoriesFor: #headersMap!accessing!private! !
!HttpServerHeaders categoriesFor: #initialize!private! !
!HttpServerHeaders categoriesFor: #read:!public! !
!HttpServerHeaders categoriesFor: #requestHeaderName:!accessing!private! !
!HttpServerHeaders categoriesFor: #respondHeaderIndex:!accessing!private! !
!HttpServerHeaders categoriesFor: #write:!public! !

