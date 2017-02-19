"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_RESPONSE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_RESPONSE guid: (GUID fromString: '{5e3a97da-7345-49a7-a5a9-1ddea2366eb2}')!
HTTP_RESPONSE comment: '<HTTP_RESPONSE> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_RESPONSE'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This structure describes an HTTP response."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(5e3a97da-7345-49a7-a5a9-1ddea2366eb2), helpstring("This structure describes an HTTP response.")]
struct tagHTTP_RESPONSE {
	[helpstring("Response flags from the HTTP_RESPONSE_FLAGS_* constants.")] ULONG flags;
	[helpstring("The raw HTTP protocol version number.")] HTTP_VERSION Version;
	[helpstring("The HTTP status code (e.g., 200).")] USHORT StatusCode;
	USHORT ReasonLength;
	[helpstring("The HTTP reason (e.g., ''OK''). This MUST not contain non-ASCII characters (i.e., all chars must be in range 0x20-0x7E).")] LPCSTR pReason;
	[helpstring("The response headers.")] HTTP_RESPONSE_HEADERS Headers;
	USHORT EntityChunkCount;
	[helpstring("pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs.")] HTTP_DATA_CHUNK* pEntityChunks;
	USHORT ResponseInfoCount;
	PHTTP_RESPONSE_INFO pResponseInfo;
} HTTP_RESPONSE;
'!
!HTTP_RESPONSE categoriesForClass!Win32-Structs! !
!HTTP_RESPONSE methodsFor!

EntityChunkCount
	"Answer the <Integer> value of the receiver's 'EntityChunkCount' field."

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
	"Answer the <HTTP_RESPONSE_HEADERS> value of the receiver's 'Headers' field."

	^HTTP_RESPONSE_HEADERS fromAddress: bytes yourAddress + ##(self offsetOf: #Headers)!

Headers: aHTTP_RESPONSE_HEADERS
	"Set the receiver's 'Headers' field to the value of the argument, aHTTP_RESPONSE_HEADERS"

	aHTTP_RESPONSE_HEADERS
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Headers) + 1)
		to: ##((self offsetOf: #Headers) + HTTP_RESPONSE_HEADERS basicByteSize)
		startingAt: 1!

pEntityChunks
	"Answer the <HTTP_DATA_CHUNK> value of the receiver's 'pEntityChunks' field."

	^HTTP_DATA_CHUNK fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pEntityChunks))!

pEntityChunks: aHTTP_DATA_CHUNK
	"Set the receiver's 'pEntityChunks' field to the value of the argument, aHTTP_DATA_CHUNK"

	bytes uintPtrAtOffset: ##(self offsetOf: #pEntityChunks) put: aHTTP_DATA_CHUNK yourAddress!

pReason
	"Answer the <String> value of the receiver's 'pReason' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pReason))!

pReason: aString
	"Set the receiver's 'pReason' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #pReason) put: aString yourAddress!

pResponseInfo
	"Answer the <HTTP_RESPONSE_INFO> value of the receiver's 'pResponseInfo' field."

	^HTTP_RESPONSE_INFO fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pResponseInfo))!

pResponseInfo: aHTTP_RESPONSE_INFO
	"Set the receiver's 'pResponseInfo' field to the value of the argument, aHTTP_RESPONSE_INFO"

	bytes uintPtrAtOffset: ##(self offsetOf: #pResponseInfo) put: aHTTP_RESPONSE_INFO yourAddress!

ReasonLength
	"Answer the <Integer> value of the receiver's 'ReasonLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #ReasonLength)!

ReasonLength: anInteger
	"Set the receiver's 'ReasonLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ReasonLength) put: anInteger!

ResponseInfoCount
	"Answer the <Integer> value of the receiver's 'ResponseInfoCount' field."

	^bytes wordAtOffset: ##(self offsetOf: #ResponseInfoCount)!

ResponseInfoCount: anInteger
	"Set the receiver's 'ResponseInfoCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ResponseInfoCount) put: anInteger!

StatusCode
	"Answer the <Integer> value of the receiver's 'StatusCode' field."

	^bytes wordAtOffset: ##(self offsetOf: #StatusCode)!

StatusCode: anInteger
	"Set the receiver's 'StatusCode' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #StatusCode) put: anInteger!

Version
	"Answer the <WORDArray> value of the receiver's 'Version' field."

	^WORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #Version) length: 2!

Version: aWORDArray
	"Set the receiver's 'Version' field to the value of the argument, aWORDArray"

	| size |
	size := aWORDArray byteSize min: ##(2 * WORDArray elementSize).
	aWORDArray
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Version) + 1)
		to: ##(self offsetOf: #Version) + size
		startingAt: 1! !
!HTTP_RESPONSE categoriesFor: #EntityChunkCount!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #EntityChunkCount:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #Headers!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #Headers:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #pEntityChunks!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #pEntityChunks:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #pReason!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #pReason:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #pResponseInfo!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #pResponseInfo:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #ReasonLength!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #ReasonLength:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #ResponseInfoCount!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #ResponseInfoCount:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #StatusCode!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #StatusCode:!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #Version!**compiled accessors**!public! !
!HTTP_RESPONSE categoriesFor: #Version:!**compiled accessors**!public! !

!HTTP_RESPONSE class methodsFor!

defineFields
	"Define the fields of the HTTP_RESPONSE structure.

	HTTP_RESPONSE  compileDefinition

		typedef [uuid(5e3a97da-7345-49a7-a5a9-1ddea2366eb2), helpstring('This structure describes an HTTP response.')]
		struct tagHTTP_RESPONSE {
			[helpstring('Response flags from the HTTP_RESPONSE_FLAGS_* constants.')] ULONG flags;
			[helpstring('The raw HTTP protocol version number.')] HTTP_VERSION Version;
			[helpstring('The HTTP status code (e.g., 200).')] USHORT StatusCode;
			USHORT ReasonLength;
			[helpstring('The HTTP reason (e.g., 'OK'). This MUST not contain non-ASCII characters (i.e., all chars must be in range 0x20-0x7E).')] LPCSTR pReason;
			[helpstring('The response headers.')] HTTP_RESPONSE_HEADERS Headers;
			USHORT EntityChunkCount;
			[helpstring('pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs.')] HTTP_DATA_CHUNK* pEntityChunks;
			USHORT ResponseInfoCount;
			PHTTP_RESPONSE_INFO pResponseInfo;
		} HTTP_RESPONSE;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #Version type: (ArrayField type: WORDArray length: 2) offset: 4;
		defineField: #StatusCode type: WORDField new offset: 8;
		defineField: #ReasonLength type: WORDField new offset: 10;
		defineField: #pReason type: (PointerField type: String) offset: 12;
		defineField: #Headers type: (StructureField type: HTTP_RESPONSE_HEADERS) offset: 16;
		defineField: #EntityChunkCount type: WORDField new offset: 272;
		defineField: #pEntityChunks type: (PointerField type: HTTP_DATA_CHUNK) offset: 276;
		defineField: #ResponseInfoCount type: WORDField new offset: 280;
		defineField: #pResponseInfo type: (PointerField type: HTTP_RESPONSE_INFO) offset: 284.
	self byteSize: 288! !
!HTTP_RESPONSE class categoriesFor: #defineFields!**auto generated**!initializing!public! !

