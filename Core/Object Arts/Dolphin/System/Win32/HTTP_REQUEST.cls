"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_REQUEST
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_REQUEST guid: (GUID fromString: '{5F3F936F-B824-47AF-A69E-62DC4730010C}')!
HTTP_REQUEST comment: '<HTTP_REQUEST> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The structure of an HTTP request for downlevel OS"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(5F3F936F-B824-47AF-A69E-62DC4730010C), helpstring("The structure of an HTTP request for downlevel OS")]
struct tagHTTP_REQUEST {
	[helpstring("Request flags (see HTTP_REQUEST_FLAG_* definitions below).")] unsigned long flags;
	[helpstring("An opaque request identifier. These values are used by the driver to correlate outgoing responses with incoming requests.")] unsigned __int64 ConnectionId;
	unsigned __int64 RequestId;
	[helpstring("The context associated with the URL prefix.")] HTTP_URL_CONTEXT UrlContext;
	[helpstring("The HTTP version number.")] HTTP_VERSION Version;
	[helpstring("The request verb.")] HTTP_VERB Verb;
	[helpstring("The length of the verb string if the Verb field is HttpVerbUnknown. In bytes not including the NUL")] unsigned short UnknownVerbLength;
	[helpstring("The length of the raw (uncooked) URL in bytes not including the NUL")] unsigned short RawUrlLength;
	[helpstring("Pointer to the verb string if the Verb field is HttpVerbUnknown.")] LPCSTR pUnknownVerb;
	[helpstring("Pointer to the raw (uncooked) URL")] LPCSTR pRawUrl;
	[helpstring("The canonicalized Unicode URL")] HTTP_COOKED_URL CookedUrl;
	[helpstring("Local and remote transport addresses for the connection.")] HTTP_TRANSPORT_ADDRESS Address;
	[helpstring("The request headers.")] HTTP_REQUEST_HEADERS Headers;
	[helpstring("The total number of bytes received from network for this request.")] unsigned __int64 BytesReceived;
	unsigned short EntityChunkCount;
	[helpstring("pEntityChunks is an array of EntityChunkCount HTTP_DATA_CHUNKs. The entity body is copied only if HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY was passed to HttpReceiveHttpRequest().")] HTTP_DATA_CHUNK* pEntityChunks;
	unsigned __int64 RawConnectionId;
	[helpstring("SSL connection information.")] PHTTP_SSL_INFO pSslInfo;
	unsigned short RequestInfoCount;
	[helpstring("Additional Request Informations.")] PHTTP_REQUEST_INFO pRequestInfo;
} HTTP_REQUEST;
'!
!HTTP_REQUEST categoriesForClass!Win32-Structs! !
!HTTP_REQUEST methodsFor!

Address
	"Answer the receiver's Address field as a Smalltalk object."

	^HTTP_TRANSPORT_ADDRESS fromAddress: bytes yourAddress + ##(self offsetOf: #Address)!

Address: anObject
	"Set the receiver's Address field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Address) + 1)
		to: ##((self offsetOf: #Address) + HTTP_TRANSPORT_ADDRESS basicByteSize)
		startingAt: 1!

byteSize
	^bytes class isIndirection ifTrue: [super byteSize] ifFalse: [bytes size]!

BytesReceived
	"Answer the receiver's BytesReceived field as a Smalltalk object."

	^bytes qwordAtOffset: ##(self offsetOf: #BytesReceived)!

BytesReceived: anObject
	"Set the receiver's BytesReceived field to the value of anObject."

	bytes qwordAtOffset: ##(self offsetOf: #BytesReceived) put: anObject!

ConnectionId
	"Answer the receiver's ConnectionId field as a Smalltalk object."

	^bytes qwordAtOffset: ##(self offsetOf: #ConnectionId)!

ConnectionId: anObject
	"Set the receiver's ConnectionId field to the value of anObject."

	bytes qwordAtOffset: ##(self offsetOf: #ConnectionId) put: anObject!

CookedUrl
	"Answer the receiver's CookedUrl field as a Smalltalk object."

	^HTTP_COOKED_URL fromAddress: bytes yourAddress + ##(self offsetOf: #CookedUrl)!

CookedUrl: anObject
	"Set the receiver's CookedUrl field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #CookedUrl) + 1)
		to: ##((self offsetOf: #CookedUrl) + HTTP_COOKED_URL basicByteSize)
		startingAt: 1!

EntityChunkCount
	"Answer the receiver's EntityChunkCount field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #EntityChunkCount)!

EntityChunkCount: anObject
	"Set the receiver's EntityChunkCount field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #EntityChunkCount) put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

Headers
	"Answer the receiver's Headers field as a Smalltalk object."

	^HTTP_REQUEST_HEADERS fromAddress: bytes yourAddress + ##(self offsetOf: #Headers)!

Headers: anObject
	"Set the receiver's Headers field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Headers) + 1)
		to: ##((self offsetOf: #Headers) + HTTP_REQUEST_HEADERS basicByteSize)
		startingAt: 1!

pEntityChunks
	"Answer the receiver's pEntityChunks field as a Smalltalk object."

	^HTTP_DATA_CHUNK fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pEntityChunks))!

pEntityChunks: anObject
	"Set the receiver's pEntityChunks field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pEntityChunks) put: anObject yourAddress!

pRawUrl
	"Answer the receiver's pRawUrl field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pRawUrl))!

pRawUrl: anObject
	"Set the receiver's pRawUrl field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pRawUrl) put: anObject yourAddress!

pRequestInfo
	"Answer the receiver's pRequestInfo field as a Smalltalk object."

	^HTTP_REQUEST_INFO fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pRequestInfo))!

pRequestInfo: anObject
	"Set the receiver's pRequestInfo field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pRequestInfo) put: anObject yourAddress!

pSslInfo
	"Answer the receiver's pSslInfo field as a Smalltalk object."

	^HTTP_SSL_INFO fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pSslInfo))!

pSslInfo: anObject
	"Set the receiver's pSslInfo field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pSslInfo) put: anObject yourAddress!

pUnknownVerb
	"Answer the receiver's pUnknownVerb field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pUnknownVerb))!

pUnknownVerb: anObject
	"Set the receiver's pUnknownVerb field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pUnknownVerb) put: anObject yourAddress!

RawConnectionId
	"Answer the receiver's RawConnectionId field as a Smalltalk object."

	^bytes qwordAtOffset: ##(self offsetOf: #RawConnectionId)!

RawConnectionId: anObject
	"Set the receiver's RawConnectionId field to the value of anObject."

	bytes qwordAtOffset: ##(self offsetOf: #RawConnectionId) put: anObject!

RawUrlLength
	"Answer the receiver's RawUrlLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #RawUrlLength)!

RawUrlLength: anObject
	"Set the receiver's RawUrlLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #RawUrlLength) put: anObject!

RequestId
	"Answer the receiver's RequestId field as a Smalltalk object."

	^bytes qwordAtOffset: ##(self offsetOf: #RequestId)!

RequestId: anObject
	"Set the receiver's RequestId field to the value of anObject."

	bytes qwordAtOffset: ##(self offsetOf: #RequestId) put: anObject!

RequestInfoCount
	"Answer the receiver's RequestInfoCount field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #RequestInfoCount)!

RequestInfoCount: anObject
	"Set the receiver's RequestInfoCount field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #RequestInfoCount) put: anObject!

UnknownVerbLength
	"Answer the receiver's UnknownVerbLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #UnknownVerbLength)!

UnknownVerbLength: anObject
	"Set the receiver's UnknownVerbLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #UnknownVerbLength) put: anObject!

UrlContext
	"Answer the receiver's UrlContext field as a Smalltalk object."

	^bytes qwordAtOffset: ##(self offsetOf: #UrlContext)!

UrlContext: anObject
	"Set the receiver's UrlContext field to the value of anObject."

	bytes qwordAtOffset: ##(self offsetOf: #UrlContext) put: anObject!

Verb
	"Answer the receiver's Verb field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #Verb)!

Verb: anObject
	"Set the receiver's Verb field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #Verb) put: anObject!

Version
	"Answer the receiver's Version field as a Smalltalk object."

	^HTTP_VERSION fromAddress: bytes yourAddress + ##(self offsetOf: #Version)!

Version: anObject
	"Set the receiver's Version field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Version) + 1)
		to: ##((self offsetOf: #Version) + HTTP_VERSION basicByteSize)
		startingAt: 1! !
!HTTP_REQUEST categoriesFor: #Address!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #Address:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #byteSize!accessing!public! !
!HTTP_REQUEST categoriesFor: #BytesReceived!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #BytesReceived:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #ConnectionId!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #ConnectionId:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #CookedUrl!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #CookedUrl:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #EntityChunkCount!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #EntityChunkCount:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #Headers!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #Headers:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pEntityChunks!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pEntityChunks:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pRawUrl!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pRawUrl:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pRequestInfo!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pRequestInfo:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pSslInfo!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pSslInfo:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pUnknownVerb!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #pUnknownVerb:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #RawConnectionId!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #RawConnectionId:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #RawUrlLength!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #RawUrlLength:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #RequestId!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #RequestId:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #RequestInfoCount!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #RequestInfoCount:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #UnknownVerbLength!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #UnknownVerbLength:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #UrlContext!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #UrlContext:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #Verb!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #Verb:!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #Version!**compiled accessors**!public! !
!HTTP_REQUEST categoriesFor: #Version:!**compiled accessors**!public! !

!HTTP_REQUEST class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST structure.

	HTTP_REQUEST  compileDefinition

		typedef [uuid(5F3F936F-B824-47AF-A69E-62DC4730010C), helpstring('The structure of an HTTP request for downlevel OS')]
		struct tagHTTP_REQUEST {
			[helpstring('Request flags (see HTTP_REQUEST_FLAG_* definitions below).')] unsigned long flags;
			[helpstring('An opaque request identifier. These values are used by the driver to correlate outgoing responses with incoming requests.')] unsigned __int64 ConnectionId;
			unsigned __int64 RequestId;
			[helpstring('The context associated with the URL prefix.')] HTTP_URL_CONTEXT UrlContext;
			[helpstring('The HTTP version number.')] HTTP_VERSION Version;
			[helpstring('The request verb.')] HTTP_VERB Verb;
			[helpstring('The length of the verb string if the Verb field is HttpVerbUnknown. In bytes not including the NUL')] unsigned short UnknownVerbLength;
			[helpstring('The length of the raw (uncooked) URL in bytes not including the NUL')] unsigned short RawUrlLength;
			[helpstring('Pointer to the verb string if the Verb field is HttpVerbUnknown.')] LPCSTR pUnknownVerb;
			[helpstring('Pointer to the raw (uncooked) URL')] LPCSTR pRawUrl;
			[helpstring('The canonicalized Unicode URL')] HTTP_COOKED_URL CookedUrl;
			[helpstring('Local and remote transport addresses for the connection.')] HTTP_TRANSPORT_ADDRESS Address;
			[helpstring('The request headers.')] HTTP_REQUEST_HEADERS Headers;
			[helpstring('The total number of bytes received from network for this request.')] unsigned __int64 BytesReceived;
			unsigned short EntityChunkCount;
			[helpstring('pEntityChunks is an array of EntityChunkCount HTTP_DATA_CHUNKs. The entity body is copied only if HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY was passed to HttpReceiveHttpRequest().')] HTTP_DATA_CHUNK* pEntityChunks;
			unsigned __int64 RawConnectionId;
			[helpstring('SSL connection information.')] PHTTP_SSL_INFO pSslInfo;
			unsigned short RequestInfoCount;
			[helpstring('Additional Request Informations.')] PHTTP_REQUEST_INFO pRequestInfo;
		} HTTP_REQUEST;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #ConnectionId type: QWORDField new offset: 8;
		defineField: #RequestId type: QWORDField new offset: 16;
		defineField: #UrlContext type: QWORDField new offset: 24;
		defineField: #Version type: (StructureField type: HTTP_VERSION) offset: 32;
		defineField: #Verb type: SDWORDField new offset: 36;
		defineField: #UnknownVerbLength type: WORDField new offset: 40;
		defineField: #RawUrlLength type: WORDField new offset: 42;
		defineField: #pUnknownVerb type: (PointerField type: String) offset: 44;
		defineField: #pRawUrl type: (PointerField type: String) offset: 48;
		defineField: #CookedUrl type: (StructureField type: HTTP_COOKED_URL) offset: 52;
		defineField: #Address type: (StructureField type: HTTP_TRANSPORT_ADDRESS) offset: 76;
		defineField: #Headers type: (StructureField type: HTTP_REQUEST_HEADERS) offset: 84;
		defineField: #BytesReceived type: QWORDField new offset: 432;
		defineField: #EntityChunkCount type: WORDField new offset: 440;
		defineField: #pEntityChunks type: (PointerField type: HTTP_DATA_CHUNK) offset: 444;
		defineField: #RawConnectionId type: QWORDField new offset: 448;
		defineField: #pSslInfo type: (PointerField type: HTTP_SSL_INFO) offset: 456;
		defineField: #RequestInfoCount type: WORDField new offset: 460;
		defineField: #pRequestInfo type: (PointerField type: HTTP_REQUEST_INFO) offset: 464.
	self byteSize: 472! !
!HTTP_REQUEST class categoriesFor: #defineFields!**auto generated**!initializing!public! !

