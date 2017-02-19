"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_REQUEST_V1
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''!
HTTP_REQUEST_V1 guid: (GUID fromString: '{7927a79c-8c4e-423a-bf24-f1b36b4df5c4}')!
HTTP_REQUEST_V1 comment: '<HTTP_REQUEST_V1> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST_V1'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Represents an incoming HTTP request (N.B. this is the V1, pre-Vista, structure)"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(7927a79c-8c4e-423a-bf24-f1b36b4df5c4), helpstring("Represents an incoming HTTP request (N.B. this is the V1, pre-Vista, structure)")]
struct tagHTTP_REQUEST_V1 {
	[helpstring("Request flags (see HTTP_REQUEST_FLAG_* definitions below).")] ULONG flags;
	[helpstring("An opaque request identifier. These values are used by the driver to correlate outgoing responses with incoming requests.")] unsigned __int64 ConnectionId;
	unsigned __int64 RequestId;
	[helpstring("The context associated with the URL prefix.")] HTTP_URL_CONTEXT UrlContext;
	[helpstring("The HTTP protocol version number.")] HTTP_VERSION Version;
	[helpstring("An HTTP verb associated with this request. This member can be one of the values from the HTTP_VERB enumeration.")] HTTP_VERB Verb;
	[nonbrowsable, helpstring("The length of the verb string if the Verb field is HttpVerbUnknown. In bytes not including the NUL")] USHORT UnknownVerbLength;
	[nonbrowsable, helpstring("The length of the raw (uncooked) URL in bytes not including the NUL")] USHORT RawUrlLength;
	[helpstring("Pointer to the verb string if the Verb field is HttpVerbUnknown."), string, size_is("UnknownVerbLength")] LPCSTR pUnknownVerb;
	[nonbrowsable, helpstring("Pointer to the raw (uncooked) URL"), string, size_is("RawUrlLength")] LPCSTR pRawUrl;
	[helpstring("The canonicalized Unicode URL")] HTTP_COOKED_URL CookedUrl;
	[helpstring("Local and remote transport addresses for the connection.")] HTTP_TRANSPORT_ADDRESS Address;
	[helpstring("The request headers.")] HTTP_REQUEST_HEADERS Headers;
	[helpstring("The total number of bytes received from network for this request.")] unsigned __int64 BytesReceived;
	[nonbrowsable, helpstring("The number of elements in the pEntityChunks array. If no entity body was copied, this value is zero.")] USHORT EntityChunkCount;
	[helpstring("pEntityChunks is an array of EntityChunkCount HTTP_DATA_CHUNKs. The entity body is copied only if HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY was passed to HttpReceiveHttpRequest()."), size_is("EntityChunkCount")] HTTP_DATA_CHUNK* pEntityChunks;
	[helpstring("Raw connection ID for an Secure Sockets Layer (SSL) request.")] unsigned __int64 RawConnectionId;
	[helpstring("A pointer to an HTTP_SSL_INFO structure that contains Secure Sockets Layer (SSL) information about the connection on which the request was received.")] HTTP_SSL_INFO* pSslInfo;
} HTTP_REQUEST_V1;
'!
!HTTP_REQUEST_V1 categoriesForClass!Win32-Structs! !
!HTTP_REQUEST_V1 methodsFor!

Address
	"Answer the <PointerArray> value of the receiver's 'Address' field."

	^PointerArray
		fromAddress: bytes yourAddress + ##(self offsetOf: #Address)
		length: 2
		elementClass: SOCKADDR!

Address: aStructureArrayOfSOCKADDR
	"Set the receiver's 'Address' field to the value of the argument, aStructureArrayOfSOCKADDR"

	| size |
	size := aStructureArrayOfSOCKADDR byteSize min: ##(2 * SOCKADDR basicByteSize).
	aStructureArrayOfSOCKADDR
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Address) + 1)
		to: ##(self offsetOf: #Address) + size
		startingAt: 1!

BytesReceived
	"Answer the <Integer> value of the receiver's 'BytesReceived' field."

	^bytes qwordAtOffset: ##(self offsetOf: #BytesReceived)!

BytesReceived: anInteger
	"Set the receiver's 'BytesReceived' field to the value of the argument, anInteger"

	bytes qwordAtOffset: ##(self offsetOf: #BytesReceived) put: anInteger!

ConnectionId
	"Answer the <Integer> value of the receiver's 'ConnectionId' field."

	^bytes qwordAtOffset: ##(self offsetOf: #ConnectionId)!

ConnectionId: anInteger
	"Set the receiver's 'ConnectionId' field to the value of the argument, anInteger"

	bytes qwordAtOffset: ##(self offsetOf: #ConnectionId) put: anInteger!

CookedUrl
	"Answer the <HTTP_COOKED_URL> value of the receiver's 'CookedUrl' field."

	^HTTP_COOKED_URL fromAddress: bytes yourAddress + ##(self offsetOf: #CookedUrl)!

CookedUrl: aHTTP_COOKED_URL
	"Set the receiver's 'CookedUrl' field to the value of the argument, aHTTP_COOKED_URL"

	aHTTP_COOKED_URL
		replaceBytesOf: bytes
		from: ##((self offsetOf: #CookedUrl) + 1)
		to: ##((self offsetOf: #CookedUrl) + HTTP_COOKED_URL basicByteSize)
		startingAt: 1!

EntityChunkCount
	"Private - Answer the <Integer> value of the receiver's 'EntityChunkCount' field."

	^bytes wordAtOffset: ##(self offsetOf: #EntityChunkCount)!

EntityChunkCount: anInteger
	"Set the receiver's 'EntityChunkCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #EntityChunkCount) put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: 0!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

Headers
	"Answer the <HTTP_REQUEST_HEADERS> value of the receiver's 'Headers' field."

	^HTTP_REQUEST_HEADERS fromAddress: bytes yourAddress + ##(self offsetOf: #Headers)!

Headers: aHTTP_REQUEST_HEADERS
	"Set the receiver's 'Headers' field to the value of the argument, aHTTP_REQUEST_HEADERS"

	aHTTP_REQUEST_HEADERS
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Headers) + 1)
		to: ##((self offsetOf: #Headers) + HTTP_REQUEST_HEADERS basicByteSize)
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
		fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pEntityChunks))
		length: self EntityChunkCount
		elementClass: HTTP_DATA_CHUNK!

pEntityChunks: aStructureArray
	"Set the receiver's 'pEntityChunks' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: ##(self offsetOf: #pEntityChunks) put: aStructureArray yourAddress.
	self EntityChunkCount: aStructureArray size!

pRawUrl
	"Private - Answer the <String> value of the receiver's 'pRawUrl' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pRawUrl)) length: self RawUrlLength!

pRawUrl: aString
	"Set the receiver's 'pRawUrl' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #pRawUrl) put: aString yourAddress.
	self RawUrlLength: aString size!

printableFields
	^(super printableFields)
		removeAll: #(#Verb #pUnknownVerb);
		yourself!

printFields: aCollection on: aStream limit: anInteger
	aStream
		nextPutAll: self verb;
		nextPutAll: ': '.
	^super
		printFields: aCollection
		on: aStream
		limit: anInteger!

pSslInfo
	"Answer the <HTTP_SSL_INFO> value of the receiver's 'pSslInfo' field."

	^HTTP_SSL_INFO fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pSslInfo))!

pSslInfo: aHTTP_SSL_INFO
	"Set the receiver's 'pSslInfo' field to the value of the argument, aHTTP_SSL_INFO"

	bytes uintPtrAtOffset: ##(self offsetOf: #pSslInfo) put: aHTTP_SSL_INFO yourAddress!

pUnknownVerb
	"Answer the <String> value of the receiver's 'pUnknownVerb' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pUnknownVerb))
		length: self UnknownVerbLength!

pUnknownVerb: aString
	"Set the receiver's 'pUnknownVerb' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #pUnknownVerb) put: aString yourAddress.
	self UnknownVerbLength: aString size!

RawConnectionId
	"Answer the <Integer> value of the receiver's 'RawConnectionId' field."

	^bytes qwordAtOffset: ##(self offsetOf: #RawConnectionId)!

RawConnectionId: anInteger
	"Set the receiver's 'RawConnectionId' field to the value of the argument, anInteger"

	bytes qwordAtOffset: ##(self offsetOf: #RawConnectionId) put: anInteger!

RawUrlLength
	"Private - Answer the <Integer> value of the receiver's 'RawUrlLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #RawUrlLength)!

RawUrlLength: anInteger
	"Set the receiver's 'RawUrlLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #RawUrlLength) put: anInteger!

RequestId
	"Answer the <Integer> value of the receiver's 'RequestId' field."

	^bytes qwordAtOffset: ##(self offsetOf: #RequestId)!

RequestId: anInteger
	"Set the receiver's 'RequestId' field to the value of the argument, anInteger"

	bytes qwordAtOffset: ##(self offsetOf: #RequestId) put: anInteger!

UnknownVerbLength
	"Private - Answer the <Integer> value of the receiver's 'UnknownVerbLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #UnknownVerbLength)!

UnknownVerbLength: anInteger
	"Set the receiver's 'UnknownVerbLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #UnknownVerbLength) put: anInteger!

UrlContext
	"Answer the <Integer> value of the receiver's 'UrlContext' field."

	^bytes qwordAtOffset: ##(self offsetOf: #UrlContext)!

UrlContext: anInteger
	"Set the receiver's 'UrlContext' field to the value of the argument, anInteger"

	bytes qwordAtOffset: ##(self offsetOf: #UrlContext) put: anInteger!

verb
	| verb |
	verb := self Verb.
	^verb = HttpVerbUnknown ifTrue: [self pUnknownVerb] ifFalse: [self nameOfVerb: verb]!

Verb
	"Answer the <Integer> value of the receiver's 'Verb' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #Verb)!

Verb: anInteger
	"Set the receiver's 'Verb' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #Verb) put: anInteger!

Version
	"Answer the <HTTP_VERSION> value of the receiver's 'Version' field."

	^HTTP_VERSION fromAddress: bytes yourAddress + ##(self offsetOf: #Version)!

Version: aHTTP_VERSION
	"Set the receiver's 'Version' field to the value of the argument, aHTTP_VERSION"

	aHTTP_VERSION
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Version) + 1)
		to: ##((self offsetOf: #Version) + HTTP_VERSION basicByteSize)
		startingAt: 1! !
!HTTP_REQUEST_V1 categoriesFor: #Address!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #Address:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #BytesReceived!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #BytesReceived:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #ConnectionId!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #ConnectionId:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #CookedUrl!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #CookedUrl:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #EntityChunkCount!**compiled accessors**!private! !
!HTTP_REQUEST_V1 categoriesFor: #EntityChunkCount:!**compiled accessors**!private! !
!HTTP_REQUEST_V1 categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #Headers!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #Headers:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #maxPrint!constants!private! !
!HTTP_REQUEST_V1 categoriesFor: #nameOfVerb:!constants!public! !
!HTTP_REQUEST_V1 categoriesFor: #pEntityChunks!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #pEntityChunks:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #pRawUrl!**compiled accessors**!private! !
!HTTP_REQUEST_V1 categoriesFor: #pRawUrl:!**compiled accessors**!private! !
!HTTP_REQUEST_V1 categoriesFor: #printableFields!development!printing!private! !
!HTTP_REQUEST_V1 categoriesFor: #printFields:on:limit:!development!printing!private! !
!HTTP_REQUEST_V1 categoriesFor: #pSslInfo!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #pSslInfo:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #pUnknownVerb!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #pUnknownVerb:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #RawConnectionId!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #RawConnectionId:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #RawUrlLength!**compiled accessors**!private! !
!HTTP_REQUEST_V1 categoriesFor: #RawUrlLength:!**compiled accessors**!private! !
!HTTP_REQUEST_V1 categoriesFor: #RequestId!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #RequestId:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #UnknownVerbLength!**compiled accessors**!private! !
!HTTP_REQUEST_V1 categoriesFor: #UnknownVerbLength:!**compiled accessors**!private! !
!HTTP_REQUEST_V1 categoriesFor: #UrlContext!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #UrlContext:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #verb!accessing!public! !
!HTTP_REQUEST_V1 categoriesFor: #Verb!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #Verb:!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #Version!**compiled accessors**!public! !
!HTTP_REQUEST_V1 categoriesFor: #Version:!**compiled accessors**!public! !

!HTTP_REQUEST_V1 class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_V1 structure.

	HTTP_REQUEST_V1 compileDefinition

		typedef [uuid(7927a79c-8c4e-423a-bf24-f1b36b4df5c4), helpstring('Represents an incoming HTTP request (N.B. this is the V1, pre-Vista, structure)')]
		struct tagHTTP_REQUEST_V1 {
			[helpstring('Request flags (see HTTP_REQUEST_FLAG_* definitions below).')] ULONG flags;
			[helpstring('An opaque request identifier. These values are used by the driver to correlate outgoing responses with incoming requests.')] unsigned __int64 ConnectionId;
			unsigned __int64 RequestId;
			[helpstring('The context associated with the URL prefix.')] HTTP_URL_CONTEXT UrlContext;
			[helpstring('The HTTP protocol version number.')] HTTP_VERSION Version;
			[helpstring('An HTTP verb associated with this request. This member can be one of the values from the HTTP_VERB enumeration.')] HTTP_VERB Verb;
			[nonbrowsable, helpstring('The length of the verb string if the Verb field is HttpVerbUnknown. In bytes not including the NUL')] USHORT UnknownVerbLength;
			[nonbrowsable, helpstring('The length of the raw (uncooked) URL in bytes not including the NUL')] USHORT RawUrlLength;
			[helpstring('Pointer to the verb string if the Verb field is HttpVerbUnknown.'), string, size_is('UnknownVerbLength')] LPCSTR pUnknownVerb;
			[nonbrowsable, helpstring('Pointer to the raw (uncooked) URL'), string, size_is('RawUrlLength')] LPCSTR pRawUrl;
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
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #ConnectionId type: QWORDField new offset: 8;
		defineField: #RequestId type: QWORDField new offset: 16;
		defineField: #UrlContext type: QWORDField new offset: 24;
		defineField: #Version type: (StructureField type: HTTP_VERSION) offset: 32;
		defineField: #Verb type: SDWORDField new offset: 36;
		defineField: #UnknownVerbLength type: WORDField new beNonBrowsable offset: 40;
		defineField: #RawUrlLength type: WORDField new beNonBrowsable offset: 42;
		defineField: #pUnknownVerb type: (ArrayPointerField type: String lengthField: #UnknownVerbLength) offset: 44;
		defineField: #pRawUrl type: (ArrayPointerField type: String lengthField: #RawUrlLength) beNonBrowsable offset: 48;
		defineField: #CookedUrl type: (StructureField type: HTTP_COOKED_URL) offset: 52;
		defineField: #Address type: (PointerArrayField type: SOCKADDR length: 2) offset: 76;
		defineField: #Headers type: (StructureField type: HTTP_REQUEST_HEADERS) offset: 84;
		defineField: #BytesReceived type: QWORDField new offset: 432;
		defineField: #EntityChunkCount type: WORDField new beNonBrowsable offset: 440;
		defineField: #pEntityChunks type: (StructureArrayPointerField type: HTTP_DATA_CHUNK lengthField: #EntityChunkCount) offset: 444;
		defineField: #RawConnectionId type: QWORDField new offset: 448;
		defineField: #pSslInfo type: (PointerField type: HTTP_SSL_INFO) offset: 456.
	self byteSize: 464! !
!HTTP_REQUEST_V1 class categoriesFor: #defineFields!**auto generated**!initializing!public! !

