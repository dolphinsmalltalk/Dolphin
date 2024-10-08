﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HTTP_HEADERS
	subclass: #'WinHttpServer.HTTP_RESPONSE_HEADERS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_HTTP_RESPONSE_HEADERS_Size' -> 16r100. '_OffsetOf_KnownHeaders' -> 16r10 }!

WinHttpServer.HTTP_RESPONSE_HEADERS guid: (Core.GUID fromString: '{487fd2e3-1549-4dcf-8703-d45a2cbbcd85}')!

WinHttpServer.HTTP_RESPONSE_HEADERS comment: '`HTTP_RESPONSE_HEADERS` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_RESPONSE_HEADERS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of response headers."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(487fd2e3-1549-4dcf-8703-d45a2cbbcd85), helpstring("Structure defining format of response headers.")]
struct tagHTTP_RESPONSE_HEADERS {
	HTTP_HEADERS;
	[helpstring("Known response headers.")] HTTP_KNOWN_HEADER KnownHeaders[30];
} HTTP_RESPONSE_HEADERS;
```
'!

!WinHttpServer.HTTP_RESPONSE_HEADERS categoriesForClass!Win32-Structs! !

!WinHttpServer.HTTP_RESPONSE_HEADERS methodsFor!

KnownHeaders
	"Answer the <StructureArray> value of the receiver's 'KnownHeaders' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_KnownHeaders
		length: 30
		elementClass: HTTP_KNOWN_HEADER!

KnownHeaders: aStructureArrayOfHTTP_KNOWN_HEADER
	"Set the receiver's 'KnownHeaders' field to the value of the argument, aStructureArrayOfHTTP_KNOWN_HEADER"

	| size |
	size := aStructureArrayOfHTTP_KNOWN_HEADER byteSize
				min: ##(30 * HTTP_KNOWN_HEADER._HTTP_KNOWN_HEADER_Size).
	aStructureArrayOfHTTP_KNOWN_HEADER
		replaceBytesOf: bytes
		from: ##(_OffsetOf_KnownHeaders + 1)
		to: _OffsetOf_KnownHeaders + size
		startingAt: 1! !

!WinHttpServer.HTTP_RESPONSE_HEADERS categoriesForMethods!
KnownHeaders!**compiled accessors**!public! !
KnownHeaders:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_RESPONSE_HEADERS class methodsFor!

byteSize
	^_HTTP_RESPONSE_HEADERS_Size!

defineFields
	"Define the fields of the HTTP_RESPONSE_HEADERS structure.

	HTTP_RESPONSE_HEADERS compileDefinition

		typedef [uuid(487fd2e3-1549-4dcf-8703-d45a2cbbcd85), helpstring('Structure defining format of response headers.')]
		struct tagHTTP_RESPONSE_HEADERS {
			HTTP_HEADERS;
			[helpstring('Known response headers.')] HTTP_KNOWN_HEADER KnownHeaders[30];
		} HTTP_RESPONSE_HEADERS;
"

	super defineFields.
	self
		defineField: #KnownHeaders type: (StructureArrayField type: HTTP_KNOWN_HEADER length: 30) offset: 16.
	self byteSize: 256!

getFieldNames
	^#(#UnknownHeaderCount #pUnknownHeaders #KnownHeaders)!

indexToHeaderMap
	^##(LookupTable new
		at: HttpHeaderAcceptRanges put: 'Accept-Ranges';
		at: HttpHeaderAge put: 'Age';
		at: HttpHeaderEtag put: 'ETag';
		at: HttpHeaderLocation put: 'Location';
		at: HttpHeaderProxyAuthenticate put: 'Proxy-Authenticate';
		at: HttpHeaderRetryAfter put: 'Retry-After';
		at: HttpHeaderServer put: 'Server';
		at: HttpHeaderSetCookie put: 'Set-Cookie';
		at: HttpHeaderVary put: 'Vary';
		at: HttpHeaderWwwAuthenticate put: 'WWW-Authenticate';
		yourself)! !

!WinHttpServer.HTTP_RESPONSE_HEADERS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
indexToHeaderMap!public! !
!

