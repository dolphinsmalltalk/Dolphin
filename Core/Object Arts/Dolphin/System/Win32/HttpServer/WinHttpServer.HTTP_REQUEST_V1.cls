﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_REQUEST_V1'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_REQUEST_V1_Size' -> 16r1D0.
			'_OffsetOf_Address' -> 16r4C.
			'_OffsetOf_BytesReceived' -> 16r1B0.
			'_OffsetOf_ConnectionId' -> 16r8.
			'_OffsetOf_CookedUrl' -> 16r34.
			'_OffsetOf_EntityChunkCount' -> 16r1B8.
			'_OffsetOf_Flags' -> 16r0.
			'_OffsetOf_Headers' -> 16r54.
			'_OffsetOf_pEntityChunks' -> 16r1BC.
			'_OffsetOf_pRawUrl' -> 16r30.
			'_OffsetOf_pSslInfo' -> 16r1C8.
			'_OffsetOf_pUnknownVerb' -> 16r2C.
			'_OffsetOf_RawConnectionId' -> 16r1C0.
			'_OffsetOf_RawUrlLength' -> 16r2A.
			'_OffsetOf_RequestId' -> 16r10.
			'_OffsetOf_UnknownVerbLength' -> 16r28.
			'_OffsetOf_UrlContext' -> 16r18.
			'_OffsetOf_Verb' -> 16r24.
			'_OffsetOf_Version' -> 16r20
		}!

WinHttpServer.HTTP_REQUEST_V1 guid: (Core.GUID fromString: '{7927a79c-8c4e-423a-bf24-f1b36b4df5c4}')!

WinHttpServer.HTTP_REQUEST_V1 comment: '`HTTP_REQUEST_V1` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_REQUEST_V1'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Represents an incoming HTTP request (N.B. this is the V1, pre-Vista, structure)"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(7927a79c-8c4e-423a-bf24-f1b36b4df5c4), helpstring("Represents an incoming HTTP request (N.B. this is the V1, pre-Vista, structure)")]
struct tagHTTP_REQUEST_V1 {
	[helpstring("Request flags (see HTTP_REQUEST_FLAG_* definitions below).")] ULONG Flags;
	[helpstring("An opaque request identifier. These values are used by the driver to correlate outgoing responses with incoming requests.")] unsigned __int64 ConnectionId;
	unsigned __int64 RequestId;
	[helpstring("The context associated with the URL prefix.")] HTTP_URL_CONTEXT UrlContext;
	[helpstring("The HTTP protocol version number.")] HTTP_VERSION Version;
	[helpstring("An HTTP verb associated with this request. This member can be one of the values from the HTTP_VERB enumeration.")] HTTP_VERB Verb;
	[nonbrowsable, helpstring("The length of the verb string if the Verb field is HttpVerbUnknown. In bytes not including the NUL")] USHORT UnknownVerbLength;
	[nonbrowsable, helpstring("The length of the raw (uncooked) URL in bytes not including the NUL")] USHORT RawUrlLength;
	[helpstring("Pointer to the verb string if the Verb field is HttpVerbUnknown."), size_is("UnknownVerbLength"), string] LPCSTR pUnknownVerb;
	[nonbrowsable, helpstring("Pointer to the raw (uncooked) URL"), size_is("RawUrlLength"), string] LPCSTR pRawUrl;
	[helpstring("The canonicalized Unicode URL")] HTTP_COOKED_URL CookedUrl;
	[helpstring("Local and remote transport addresses for the connection.")] HTTP_TRANSPORT_ADDRESS Address;
	[helpstring("The request headers.")] HTTP_REQUEST_HEADERS Headers;
	[helpstring("The total number of bytes received from network for this request.")] unsigned __int64 BytesReceived;
	[nonbrowsable, helpstring("The number of elements in the pEntityChunks array. If no entity body was copied, this value is zero.")] USHORT EntityChunkCount;
	[helpstring("pEntityChunks is an array of EntityChunkCount HTTP_DATA_CHUNKs. The entity body is copied only if HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY was passed to HttpReceiveHttpRequest()."), size_is("EntityChunkCount")] HTTP_DATA_CHUNK* pEntityChunks;
	[helpstring("Raw connection ID for an Secure Sockets Layer (SSL) request.")] unsigned __int64 RawConnectionId;
	[helpstring("A pointer to an HTTP_SSL_INFO structure that contains Secure Sockets Layer (SSL) information about the connection on which the request was received.")] HTTP_SSL_INFO* pSslInfo;
} HTTP_REQUEST_V1;
```
'!

!WinHttpServer.HTTP_REQUEST_V1 categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_REQUEST_V1 methodsFor!

Address
	"Answer the <PointerArray> value of the receiver's 'Address' field."

	^PointerArray
		fromAddress: bytes yourAddress + _OffsetOf_Address
		length: 2
		elementClass: SOCKADDR!

Address: aStructureArrayOfSOCKADDR
	"Set the receiver's 'Address' field to the value of the argument, aStructureArrayOfSOCKADDR"

	| size |
	size := aStructureArrayOfSOCKADDR byteSize min: ##(2 * SOCKADDR._SOCKADDR_Size).
	aStructureArrayOfSOCKADDR
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Address + 1)
		to: _OffsetOf_Address + size
		startingAt: 1!

BytesReceived
	"Answer the <Integer> value of the receiver's 'BytesReceived' field."

	^bytes uint64AtOffset: _OffsetOf_BytesReceived!

BytesReceived: anInteger
	"Set the receiver's 'BytesReceived' field to the value of the argument, anInteger"

	bytes uint64AtOffset: _OffsetOf_BytesReceived put: anInteger!

ConnectionId
	"Answer the <Integer> value of the receiver's 'ConnectionId' field."

	^bytes uint64AtOffset: _OffsetOf_ConnectionId!

ConnectionId: anInteger
	"Set the receiver's 'ConnectionId' field to the value of the argument, anInteger"

	bytes uint64AtOffset: _OffsetOf_ConnectionId put: anInteger!

CookedUrl
	"Answer the <HTTP_COOKED_URL> value of the receiver's 'CookedUrl' field."

	^HTTP_COOKED_URL fromAddress: bytes yourAddress + _OffsetOf_CookedUrl!

CookedUrl: aHTTP_COOKED_URL
	"Set the receiver's 'CookedUrl' field to the value of the argument, aHTTP_COOKED_URL"

	aHTTP_COOKED_URL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_CookedUrl + 1)
		to: ##(_OffsetOf_CookedUrl + HTTP_COOKED_URL._HTTP_COOKED_URL_Size)
		startingAt: 1!

EntityChunkCount
	"Private - Answer the <Integer> value of the receiver's 'EntityChunkCount' field."

	^bytes uint16AtOffset: _OffsetOf_EntityChunkCount!

EntityChunkCount: anInteger
	"Set the receiver's 'EntityChunkCount' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_EntityChunkCount put: anInteger!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes uint32AtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Flags put: anInteger!

Headers
	"Answer the <HTTP_REQUEST_HEADERS> value of the receiver's 'Headers' field."

	^HTTP_REQUEST_HEADERS fromAddress: bytes yourAddress + _OffsetOf_Headers!

Headers: aHTTP_REQUEST_HEADERS
	"Set the receiver's 'Headers' field to the value of the argument, aHTTP_REQUEST_HEADERS"

	aHTTP_REQUEST_HEADERS
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Headers + 1)
		to: ##(_OffsetOf_Headers + HTTP_REQUEST_HEADERS._HTTP_REQUEST_HEADERS_Size)
		startingAt: 1!

maxPrint
	^1000!

nameOfVerb: anInteger
	^##(((0 to: HttpVerbMaximum) asArray)
		at: HttpVerbUnparsed + 1 put: 'Unparsed';
		at: HttpVerbUnknown + 1 put: 'Unknown';
		at: HttpVerbInvalid + 1 put: 'Invalid';
		at: HttpVerbOPTIONS + 1 put: 'OPTIONS';
		at: HttpVerbGET + 1 put: 'GET';
		at: HttpVerbHEAD + 1 put: 'HEAD';
		at: HttpVerbPOST + 1 put: 'POST';
		at: HttpVerbPUT + 1 put: 'PUT';
		at: HttpVerbDELETE + 1 put: 'DELETE';
		at: HttpVerbTRACE + 1 put: 'TRACE';
		at: HttpVerbCONNECT + 1 put: 'CONNECT';
		at: HttpVerbTRACK + 1 put: 'TRACK';
		at: HttpVerbMOVE + 1 put: 'MOVE';
		at: HttpVerbCOPY + 1 put: 'COPY';
		at: HttpVerbPROPFIND + 1 put: 'PROPFIND';
		at: HttpVerbPROPPATCH + 1 put: 'PROPPATCH';
		at: HttpVerbMKCOL + 1 put: 'MKCOL';
		at: HttpVerbLOCK + 1 put: 'LOCK';
		at: HttpVerbUNLOCK + 1 put: 'UNLOCK';
		at: HttpVerbSEARCH + 1 put: 'SEARCH';
		yourself) at: anInteger + 1!

pEntityChunks
	"Answer the <StructureArray> value of the receiver's 'pEntityChunks' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pEntityChunks)
		length: self EntityChunkCount
		elementClass: HTTP_DATA_CHUNK!

pEntityChunks: aStructureArray
	"Set the receiver's 'pEntityChunks' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_pEntityChunks put: aStructureArray yourAddress.
	self EntityChunkCount: aStructureArray size!

pRawUrl
	"Private - Answer the <AnsiString> value of the receiver's 'pRawUrl' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_pRawUrl) length: self RawUrlLength!

pRawUrl: anAnsiString
	"Set the receiver's 'pRawUrl' field to the value of the argument, anAnsiString"

	bytes uintPtrAtOffset: _OffsetOf_pRawUrl put: anAnsiString yourAddress.
	self RawUrlLength: anAnsiString size!

printableFields
	| printable |
	printable := super printableFields.
	(bytes intPtrAtOffset: _OffsetOf_pSslInfo) == 0 ifTrue: [printable remove: #pSslInfo].
	self EntityChunkCount == 0 ifTrue: [printable remove: #pEntityChunks].
	^printable
		removeAll: #(#Verb #pUnknownVerb);
		yourself!

printFields: aCollection on: aStream
	aStream
		nextPutAll: self verb;
		nextPutAll: ': '.
	^super printFields: aCollection on: aStream!

pSslInfo
	"Answer the <HTTP_SSL_INFO> value of the receiver's 'pSslInfo' field."

	^HTTP_SSL_INFO fromAddress: (bytes intPtrAtOffset: _OffsetOf_pSslInfo)!

pSslInfo: aHTTP_SSL_INFO
	"Set the receiver's 'pSslInfo' field to the value of the argument, aHTTP_SSL_INFO"

	bytes uintPtrAtOffset: _OffsetOf_pSslInfo put: aHTTP_SSL_INFO yourAddress!

pUnknownVerb
	"Answer the <AnsiString> value of the receiver's 'pUnknownVerb' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_pUnknownVerb)
		length: self UnknownVerbLength!

pUnknownVerb: anAnsiString
	"Set the receiver's 'pUnknownVerb' field to the value of the argument, anAnsiString"

	bytes uintPtrAtOffset: _OffsetOf_pUnknownVerb put: anAnsiString yourAddress.
	self UnknownVerbLength: anAnsiString size!

RawConnectionId
	"Answer the <Integer> value of the receiver's 'RawConnectionId' field."

	^bytes uint64AtOffset: _OffsetOf_RawConnectionId!

RawConnectionId: anInteger
	"Set the receiver's 'RawConnectionId' field to the value of the argument, anInteger"

	bytes uint64AtOffset: _OffsetOf_RawConnectionId put: anInteger!

RawUrlLength
	"Private - Answer the <Integer> value of the receiver's 'RawUrlLength' field."

	^bytes uint16AtOffset: _OffsetOf_RawUrlLength!

RawUrlLength: anInteger
	"Set the receiver's 'RawUrlLength' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_RawUrlLength put: anInteger!

RequestId
	"Answer the <Integer> value of the receiver's 'RequestId' field."

	^bytes uint64AtOffset: _OffsetOf_RequestId!

RequestId: anInteger
	"Set the receiver's 'RequestId' field to the value of the argument, anInteger"

	bytes uint64AtOffset: _OffsetOf_RequestId put: anInteger!

UnknownVerbLength
	"Private - Answer the <Integer> value of the receiver's 'UnknownVerbLength' field."

	^bytes uint16AtOffset: _OffsetOf_UnknownVerbLength!

UnknownVerbLength: anInteger
	"Set the receiver's 'UnknownVerbLength' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_UnknownVerbLength put: anInteger!

UrlContext
	"Answer the <Integer> value of the receiver's 'UrlContext' field."

	^bytes uint64AtOffset: _OffsetOf_UrlContext!

UrlContext: anInteger
	"Set the receiver's 'UrlContext' field to the value of the argument, anInteger"

	bytes uint64AtOffset: _OffsetOf_UrlContext put: anInteger!

verb
	| verb |
	verb := self Verb.
	^verb = HttpVerbUnknown ifTrue: [self pUnknownVerb] ifFalse: [self nameOfVerb: verb]!

Verb
	"Answer the <Integer> value of the receiver's 'Verb' field."

	^bytes int32AtOffset: _OffsetOf_Verb!

Verb: anInteger
	"Set the receiver's 'Verb' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Verb put: anInteger!

Version
	"Answer the <HTTP_VERSION> value of the receiver's 'Version' field."

	^HTTP_VERSION fromAddress: bytes yourAddress + _OffsetOf_Version!

Version: aHTTP_VERSION
	"Set the receiver's 'Version' field to the value of the argument, aHTTP_VERSION"

	aHTTP_VERSION
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Version + 1)
		to: ##(_OffsetOf_Version + HTTP_VERSION._HTTP_VERSION_Size)
		startingAt: 1! !

!WinHttpServer.HTTP_REQUEST_V1 categoriesForMethods!
Address!**compiled accessors**!public! !
Address:!**compiled accessors**!public! !
BytesReceived!**compiled accessors**!public! !
BytesReceived:!**compiled accessors**!public! !
ConnectionId!**compiled accessors**!public! !
ConnectionId:!**compiled accessors**!public! !
CookedUrl!**compiled accessors**!public! !
CookedUrl:!**compiled accessors**!public! !
EntityChunkCount!**compiled accessors**!private! !
EntityChunkCount:!**compiled accessors**!private! !
Flags!**compiled accessors**!public! !
Flags:!**compiled accessors**!public! !
Headers!**compiled accessors**!public! !
Headers:!**compiled accessors**!public! !
maxPrint!constants!private! !
nameOfVerb:!constants!public! !
pEntityChunks!**compiled accessors**!public! !
pEntityChunks:!**compiled accessors**!public! !
pRawUrl!**compiled accessors**!private! !
pRawUrl:!**compiled accessors**!private! !
printableFields!development!printing!private! !
printFields:on:!development!printing!private! !
pSslInfo!**compiled accessors**!public! !
pSslInfo:!**compiled accessors**!public! !
pUnknownVerb!**compiled accessors**!public! !
pUnknownVerb:!**compiled accessors**!public! !
RawConnectionId!**compiled accessors**!public! !
RawConnectionId:!**compiled accessors**!public! !
RawUrlLength!**compiled accessors**!private! !
RawUrlLength:!**compiled accessors**!private! !
RequestId!**compiled accessors**!public! !
RequestId:!**compiled accessors**!public! !
UnknownVerbLength!**compiled accessors**!private! !
UnknownVerbLength:!**compiled accessors**!private! !
UrlContext!**compiled accessors**!public! !
UrlContext:!**compiled accessors**!public! !
verb!accessing!public! !
Verb!**compiled accessors**!public! !
Verb:!**compiled accessors**!public! !
Version!**compiled accessors**!public! !
Version:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_REQUEST_V1 class methodsFor!

byteSize
	^_HTTP_REQUEST_V1_Size!

defineFields
	"Define the fields of the HTTP_REQUEST_V1 structure.

	HTTP_REQUEST_V1 compileDefinition

		typedef [uuid(7927a79c-8c4e-423a-bf24-f1b36b4df5c4), helpstring('Represents an incoming HTTP request (N.B. this is the V1, pre-Vista, structure)')]
		struct tagHTTP_REQUEST_V1 {
			[helpstring('Request flags (see HTTP_REQUEST_FLAG_* definitions below).')] ULONG Flags;
			[helpstring('An opaque request identifier. These values are used by the driver to correlate outgoing responses with incoming requests.')] unsigned __int64 ConnectionId;
			unsigned __int64 RequestId;
			[helpstring('The context associated with the URL prefix.')] HTTP_URL_CONTEXT UrlContext;
			[helpstring('The HTTP protocol version number.')] HTTP_VERSION Version;
			[helpstring('An HTTP verb associated with this request. This member can be one of the values from the HTTP_VERB enumeration.')] HTTP_VERB Verb;
			[nonbrowsable, helpstring('The length of the verb string if the Verb field is HttpVerbUnknown. In bytes not including the NUL')] USHORT UnknownVerbLength;
			[nonbrowsable, helpstring('The length of the raw (uncooked) URL in bytes not including the NUL')] USHORT RawUrlLength;
			[helpstring('Pointer to the verb string if the Verb field is HttpVerbUnknown.'), size_is('UnknownVerbLength'), string] LPCSTR pUnknownVerb;
			[nonbrowsable, helpstring('Pointer to the raw (uncooked) URL'), size_is('RawUrlLength'), string] LPCSTR pRawUrl;
			[helpstring('The canonicalized Unicode URL')] HTTP_COOKED_URL CookedUrl;
			[helpstring('Local and remote transport addresses for the connection.')] HTTP_TRANSPORT_ADDRESS Address;
			[helpstring('The request headers.')] HTTP_REQUEST_HEADERS Headers;
			[helpstring('The total number of bytes received from network for this request.')] unsigned __int64 BytesReceived;
			[nonbrowsable, helpstring('The number of elements in the pEntityChunks array. If no entity body was copied, this value is zero.')] USHORT EntityChunkCount;
			[helpstring('pEntityChunks is an array of EntityChunkCount HTTP_DATA_CHUNKs. The entity body is copied only if HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY was passed to HttpReceiveHttpRequest().'), size_is('EntityChunkCount')] HTTP_DATA_CHUNK* pEntityChunks;
			[helpstring('Raw connection ID for an Secure Sockets Layer (SSL) request.')] unsigned __int64 RawConnectionId;
			[helpstring('A pointer to an HTTP_SSL_INFO structure that contains Secure Sockets Layer (SSL) information about the connection on which the request was received.')] HTTP_SSL_INFO* pSslInfo;
		} HTTP_REQUEST_V1;
"

	self
		defineField: #Flags type: UInt32Field new offset: 0;
		defineField: #ConnectionId type: UInt64Field new offset: 8;
		defineField: #RequestId type: UInt64Field new offset: 16;
		defineField: #UrlContext type: UInt64Field new offset: 24;
		defineField: #Version type: (StructureField type: HTTP_VERSION) offset: 32;
		defineField: #Verb type: Int32Field new offset: 36;
		defineField: #UnknownVerbLength type: UInt16Field new beNonBrowsable offset: 40;
		defineField: #RawUrlLength type: UInt16Field new beNonBrowsable offset: 42;
		defineField: #pUnknownVerb type: (ArrayPointerField type: AnsiString lengthField: #UnknownVerbLength) offset: 44;
		defineField: #pRawUrl type: (ArrayPointerField type: AnsiString lengthField: #RawUrlLength) beNonBrowsable offset: 48;
		defineField: #CookedUrl type: (StructureField type: HTTP_COOKED_URL) offset: 52;
		defineField: #Address type: (PointerArrayField type: SOCKADDR length: 2) offset: 76;
		defineField: #Headers type: (StructureField type: HTTP_REQUEST_HEADERS) offset: 84;
		defineField: #BytesReceived type: UInt64Field new offset: 432;
		defineField: #EntityChunkCount type: UInt16Field new beNonBrowsable offset: 440;
		defineField: #pEntityChunks type: (StructureArrayPointerField type: HTTP_DATA_CHUNK lengthField: #EntityChunkCount) offset: 444;
		defineField: #RawConnectionId type: UInt64Field new offset: 448;
		defineField: #pSslInfo type: (PointerField type: HTTP_SSL_INFO) offset: 456.
	self byteSize: 464!

getFieldNames
	^#(#Flags #ConnectionId #RequestId #UrlContext #Version #Verb #UnknownVerbLength #RawUrlLength #pUnknownVerb #pRawUrl #CookedUrl #Address #Headers #BytesReceived #EntityChunkCount #pEntityChunks #RawConnectionId #pSslInfo)! !

!WinHttpServer.HTTP_REQUEST_V1 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

