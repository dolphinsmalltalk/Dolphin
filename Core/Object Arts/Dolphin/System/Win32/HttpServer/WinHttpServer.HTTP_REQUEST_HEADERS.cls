"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HTTP_HEADERS subclass: #'WinHttpServer.HTTP_REQUEST_HEADERS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_KnownHeaders' -> 16r10
	}!
WinHttpServer.HTTP_REQUEST_HEADERS guid: (Core.GUID fromString: '{f762b6ac-f56f-4aeb-aca3-d6b628473c2c}')!
WinHttpServer.HTTP_REQUEST_HEADERS comment: '`HTTP_REQUEST_HEADERS` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_REQUEST_HEADERS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of request headers."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(f762b6ac-f56f-4aeb-aca3-d6b628473c2c), helpstring("Structure defining format of request headers.")]
struct tagHTTP_REQUEST_HEADERS {
	HTTP_HEADERS;
	[helpstring("Known request headers.")] HTTP_KNOWN_HEADER KnownHeaders[41];
} HTTP_REQUEST_HEADERS;
```
'!
!WinHttpServer.HTTP_REQUEST_HEADERS categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_REQUEST_HEADERS methodsFor!

KnownHeaders
	"Answer the <StructureArray> value of the receiver's 'KnownHeaders' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_KnownHeaders
		length: 41
		elementClass: HTTP_KNOWN_HEADER!

KnownHeaders: aStructureArrayOfHTTP_KNOWN_HEADER
	"Set the receiver's 'KnownHeaders' field to the value of the argument, aStructureArrayOfHTTP_KNOWN_HEADER"

	| size |
	size := aStructureArrayOfHTTP_KNOWN_HEADER byteSize min: ##(41 * HTTP_KNOWN_HEADER basicByteSize).
	aStructureArrayOfHTTP_KNOWN_HEADER
		replaceBytesOf: bytes
		from: ##(_OffsetOf_KnownHeaders + 1)
		to: _OffsetOf_KnownHeaders + size
		startingAt: 1! !
!WinHttpServer.HTTP_REQUEST_HEADERS categoriesFor: #KnownHeaders!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_HEADERS categoriesFor: #KnownHeaders:!**compiled accessors**!public! !

!WinHttpServer.HTTP_REQUEST_HEADERS class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_HEADERS structure.

	HTTP_REQUEST_HEADERS compileDefinition

		typedef [uuid(f762b6ac-f56f-4aeb-aca3-d6b628473c2c), helpstring('Structure defining format of request headers.')]
		struct tagHTTP_REQUEST_HEADERS {
			HTTP_HEADERS;
			[helpstring('Known request headers.')] HTTP_KNOWN_HEADER KnownHeaders[41];
		} HTTP_REQUEST_HEADERS;
"

	super defineFields.
	self
		defineField: #KnownHeaders type: (StructureArrayField type: HTTP_KNOWN_HEADER length: 41) offset: 16.
	self byteSize: 344!

getFieldNames
	^#(#UnknownHeaderCount #pUnknownHeaders #KnownHeaders)!

indexToHeaderMap
	^##(LookupTable new
		at: HttpHeaderCacheControl put: 'Cache-Control';
		at: HttpHeaderConnection put: 'Connection';
		at: HttpHeaderDate put: 'Date';
		at: HttpHeaderKeepAlive put: 'Keep-Alive';
		at: HttpHeaderPragma put: 'Pragma';
		at: HttpHeaderTrailer put: 'Trailer';
		at: HttpHeaderTransferEncoding put: 'Transfer-Encoding';
		at: HttpHeaderUpgrade put: 'Upgrade';
		at: HttpHeaderVia put: 'Via';
		at: HttpHeaderWarning put: 'Warning';
		at: HttpHeaderAllow put: 'Allow';
		at: HttpHeaderContentLength put: 'Content-Length';
		at: HttpHeaderContentType put: 'Content-Type';
		at: HttpHeaderContentEncoding put: 'Content-Encoding';
		at: HttpHeaderContentLanguage put: 'Content-Language';
		at: HttpHeaderContentLocation put: 'Content-Location';
		at: HttpHeaderContentMd5 put: 'Content-MD5';
		at: HttpHeaderContentRange put: 'Content-Range';
		at: HttpHeaderExpires put: 'Expires';
		at: HttpHeaderLastModified put: 'Last-Modified';
		at: HttpHeaderAccept put: 'Accept';
		at: HttpHeaderAcceptCharset put: 'Accept-Charset';
		at: HttpHeaderAcceptEncoding put: 'Accept-Encoding';
		at: HttpHeaderAcceptLanguage put: 'Accept-Language';
		at: HttpHeaderAuthorization put: 'Authorization';
		at: HttpHeaderCookie put: 'Cookie';
		at: HttpHeaderExpect put: 'Expect';
		at: HttpHeaderFrom put: 'From';
		at: HttpHeaderHost put: 'Host';
		at: HttpHeaderIfMatch put: 'If-Match';
		at: HttpHeaderIfModifiedSince put: 'If-Modified-Since';
		at: HttpHeaderIfNoneMatch put: 'If-None-Match';
		at: HttpHeaderIfRange put: 'If-Range';
		at: HttpHeaderIfUnmodifiedSince put: 'If-Unmodified-Since';
		at: HttpHeaderMaxForwards put: 'Max-Forwards';
		at: HttpHeaderProxyAuthorization put: 'Proxy-Authorization';
		at: HttpHeaderReferer put: 'Referer';
		at: HttpHeaderRange put: 'Range';
		at: HttpHeaderTe put: 'TE';
		at: HttpHeaderTranslate put: 'Translate';
		at: HttpHeaderUserAgent put: 'User-Agent';
		yourself)! !
!WinHttpServer.HTTP_REQUEST_HEADERS class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_REQUEST_HEADERS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!WinHttpServer.HTTP_REQUEST_HEADERS class categoriesFor: #indexToHeaderMap!public! !

