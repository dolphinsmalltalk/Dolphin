"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_HEADERS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''!
HTTP_HEADERS guid: (GUID fromString: '{739d04bb-0a15-47ea-8a7d-20b4fd31cc96}')!
HTTP_HEADERS comment: '<HTTP_HEADERS> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_HEADERS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Fields common to HTTP_REQUEST_HEADERS and HTTP_RESPONSE_HEADERS"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(739d04bb-0a15-47ea-8a7d-20b4fd31cc96), helpstring("Fields common to HTTP_REQUEST_HEADERS and HTTP_RESPONSE_HEADERS")]
struct tagHTTP_HEADERS {
	[nonbrowsable, helpstring("The number of entries in the UnknownHeaders array.")] USHORT UnknownHeaderCount;
	[helpstring("The array of unknown HTTP headers."), size_is("UnknownHeaderCount")] PHTTP_UNKNOWN_HEADER pUnknownHeaders;
	[hidden, nonbrowsable, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT TrailerCount;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0), size_is("TrailerCount")] PHTTP_UNKNOWN_HEADER pTrailers;
} HTTP_HEADERS;
'!
!HTTP_HEADERS categoriesForClass!WinHttpServer-Structs! !
!HTTP_HEADERS methodsFor!

knownHeaderName: anInteger
	^##(((0 to: HttpHeaderMaximum) asArray)
		at: HttpHeaderCacheControl + 1 put: 'CacheControl';
		at: HttpHeaderConnection + 1 put: 'Connection';
		at: HttpHeaderDate + 1 put: 'Date';
		at: HttpHeaderKeepAlive + 1 put: 'KeepAlive';
		at: HttpHeaderPragma + 1 put: 'Pragma';
		at: HttpHeaderTrailer + 1 put: 'Trailer';
		at: HttpHeaderTransferEncoding + 1 put: 'TransferEncoding';
		at: HttpHeaderUpgrade + 1 put: 'Upgrade';
		at: HttpHeaderVia + 1 put: 'Via';
		at: HttpHeaderWarning + 1 put: 'Warning';
		at: HttpHeaderAllow + 1 put: 'Allow';
		at: HttpHeaderContentLength + 1 put: 'ContentLength';
		at: HttpHeaderContentType + 1 put: 'ContentType';
		at: HttpHeaderContentEncoding + 1 put: 'ContentEncoding';
		at: HttpHeaderContentLanguage + 1 put: 'ContentLanguage';
		at: HttpHeaderContentLocation + 1 put: 'ContentLocation';
		at: HttpHeaderContentMd5 + 1 put: 'ContentMd5';
		at: HttpHeaderContentRange + 1 put: 'ContentRange';
		at: HttpHeaderExpires + 1 put: 'Expires';
		at: HttpHeaderLastModified + 1 put: 'LastModified';
		at: HttpHeaderAccept + 1 put: 'Accept';
		at: HttpHeaderAcceptCharset + 1 put: 'AcceptCharset';
		at: HttpHeaderAcceptEncoding + 1 put: 'AcceptEncoding';
		at: HttpHeaderAcceptLanguage + 1 put: 'AcceptLanguage';
		at: HttpHeaderAuthorization + 1 put: 'Authorization';
		at: HttpHeaderCookie + 1 put: 'Cookie';
		at: HttpHeaderExpect + 1 put: 'Expect';
		at: HttpHeaderFrom + 1 put: 'From';
		at: HttpHeaderHost + 1 put: 'Host';
		at: HttpHeaderIfMatch + 1 put: 'IfMatch';
		at: HttpHeaderIfModifiedSince + 1 put: 'IfModifiedSince';
		at: HttpHeaderIfNoneMatch + 1 put: 'IfNoneMatch';
		at: HttpHeaderIfRange + 1 put: 'IfRange';
		at: HttpHeaderIfUnmodifiedSince + 1 put: 'IfUnmodifiedSince';
		at: HttpHeaderMaxForwards + 1 put: 'MaxForwards';
		at: HttpHeaderProxyAuthorization + 1 put: 'ProxyAuthorization';
		at: HttpHeaderReferer + 1 put: 'Referer';
		at: HttpHeaderRange + 1 put: 'Range';
		at: HttpHeaderTe + 1 put: 'Te';
		at: HttpHeaderTranslate + 1 put: 'Translate';
		at: HttpHeaderUserAgent + 1 put: 'UserAgent';
		at: HttpHeaderAcceptRanges + 1 put: 'AcceptRanges';
		at: HttpHeaderAge + 1 put: 'Age';
		at: HttpHeaderEtag + 1 put: 'Etag';
		at: HttpHeaderLocation + 1 put: 'Location';
		at: HttpHeaderProxyAuthenticate + 1 put: 'ProxyAuthenticate';
		at: HttpHeaderRetryAfter + 1 put: 'RetryAfter';
		at: HttpHeaderServer + 1 put: 'Server';
		at: HttpHeaderSetCookie + 1 put: 'SetCookie';
		at: HttpHeaderVary + 1 put: 'Vary';
		at: HttpHeaderWwwAuthenticate + 1 put: 'WwwAuthenticate';
		yourself) at: anInteger+1!

KnownHeaders
	^self subclassResponsibility!

printFieldsOn: aStream limit: anInteger
	| first |
	self isNull
		ifTrue: 
			[aStream nextPutAll: 'NULL'.
			^self].
	first := true.
	self KnownHeaders keysAndValuesDo: 
			[:i :each |
			| value |
			aStream position > anInteger
				ifTrue: 
					[aStream nextPutAll: '... etc ...'.
					^self].
			value := each pRawValue.
			value isNil
				ifFalse: 
					[first ifTrue: [first := false] ifFalse: [aStream nextPutAll: ', '].
					aStream
						display: (self knownHeaderName: i - 1);
						nextPutAll: ': ';
						print: value]].
	self pUnknownHeaders do: 
			[:each |
			aStream position > anInteger
				ifTrue: 
					[aStream nextPutAll: '... etc ...'.
					^self].
			first ifTrue: [first := false] ifFalse: [aStream nextPutAll: ', '].
			aStream
				display: each pName;
				nextPutAll: ': ';
				print: each pRawValue]!

pUnknownHeaders
	"Answer the <StructureArray> value of the receiver's 'pUnknownHeaders' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pUnknownHeaders))
		length: self UnknownHeaderCount
		elementClass: HTTP_UNKNOWN_HEADER!

pUnknownHeaders: aStructureArray
	"Set the receiver's 'pUnknownHeaders' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: ##(self offsetOf: #pUnknownHeaders) put: aStructureArray yourAddress.
	self UnknownHeaderCount: aStructureArray size!

UnknownHeaderCount
	"Private - Answer the <Integer> value of the receiver's 'UnknownHeaderCount' field."

	^bytes wordAtOffset: 0!

UnknownHeaderCount: anInteger
	"Set the receiver's 'UnknownHeaderCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: 0 put: anInteger! !
!HTTP_HEADERS categoriesFor: #knownHeaderName:!constants!public! !
!HTTP_HEADERS categoriesFor: #KnownHeaders!accessing!public! !
!HTTP_HEADERS categoriesFor: #printFieldsOn:limit:!development!printing!private! !
!HTTP_HEADERS categoriesFor: #pUnknownHeaders!**compiled accessors**!public! !
!HTTP_HEADERS categoriesFor: #pUnknownHeaders:!**compiled accessors**!public! !
!HTTP_HEADERS categoriesFor: #UnknownHeaderCount!**compiled accessors**!private! !
!HTTP_HEADERS categoriesFor: #UnknownHeaderCount:!**compiled accessors**!private! !

!HTTP_HEADERS class methodsFor!

defineFields
	"Define the fields of the HTTP_HEADERS structure.

	HTTP_HEADERS compileDefinition

		typedef [uuid(739d04bb-0a15-47ea-8a7d-20b4fd31cc96), helpstring('Fields common to HTTP_REQUEST_HEADERS and HTTP_RESPONSE_HEADERS')]
		struct tagHTTP_HEADERS {
			[nonbrowsable, helpstring('The number of entries in the UnknownHeaders array.')] USHORT UnknownHeaderCount;
			[helpstring('The array of unknown HTTP headers.'), size_is('UnknownHeaderCount')] PHTTP_UNKNOWN_HEADER pUnknownHeaders;
			[hidden, nonbrowsable, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT TrailerCount;
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0), size_is('TrailerCount')] PHTTP_UNKNOWN_HEADER pTrailers;
		} HTTP_HEADERS;
"

	self
		defineField: #UnknownHeaderCount type: WORDField new beNonBrowsable offset: 0;
		defineField: #pUnknownHeaders type: (StructureArrayPointerField type: HTTP_UNKNOWN_HEADER lengthField: #UnknownHeaderCount) offset: 4;
		defineField: #TrailerCount type: WORDField new beNonBrowsable beFiller offset: 8;
		defineField: #pTrailers type: (StructureArrayPointerField type: HTTP_UNKNOWN_HEADER lengthField: #TrailerCount) beFiller offset: 12.
	self byteSize: 16! !
!HTTP_HEADERS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

