"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_RESPONSE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_RESPONSE guid: (GUID fromString: '{5E3A97DA-7345-49A7-A5A9-1DDEA2366EB2}')!
HTTP_RESPONSE comment: '<HTTP_RESPONSE> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_RESPONSE'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This structure describes an HTTP response."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(5E3A97DA-7345-49A7-A5A9-1DDEA2366EB2), helpstring("This structure describes an HTTP response.")]
struct tagHTTP_RESPONSE {
	[helpstring("Response flags from the HTTP_RESPONSE_FLAGS_* constants.")] unsigned long flags;
	[helpstring("The raw HTTP protocol version number.")] HTTP_VERSION Version;
	[helpstring("The HTTP status code (e.g., 200).")] unsigned short StatusCode;
	unsigned short ReasonLength;
	[helpstring("The HTTP reason (e.g., ''OK''). This MUST not contain non-ASCII characters (i.e., all chars must be in range 0x20-0x7E).")] LPCSTR pReason;
	[helpstring("The response headers.")] HTTP_RESPONSE_HEADERS Headers;
	unsigned short EntityChunkCount;
	[helpstring("pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs.")] HTTP_DATA_CHUNK* pEntityChunks;
	unsigned short ResponseInfoCount;
	PHTTP_RESPONSE_INFO pResponseInfo;
} HTTP_RESPONSE;
'!
!HTTP_RESPONSE categoriesForClass!Win32-Structs! !
!HTTP_RESPONSE methodsFor!

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

	^HTTP_RESPONSE_HEADERS fromAddress: bytes yourAddress + ##(self offsetOf: #Headers)!

Headers: anObject
	"Set the receiver's Headers field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Headers) + 1)
		to: ##((self offsetOf: #Headers) + HTTP_RESPONSE_HEADERS basicByteSize)
		startingAt: 1!

pEntityChunks
	"Answer the receiver's pEntityChunks field as a Smalltalk object."

	^HTTP_DATA_CHUNK fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pEntityChunks))!

pEntityChunks: anObject
	"Set the receiver's pEntityChunks field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pEntityChunks) put: anObject yourAddress!

pReason
	"Answer the receiver's pReason field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pReason))!

pReason: anObject
	"Set the receiver's pReason field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pReason) put: anObject yourAddress!

pResponseInfo
	"Answer the receiver's pResponseInfo field as a Smalltalk object."

	^HTTP_RESPONSE_INFO fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pResponseInfo))!

pResponseInfo: anObject
	"Set the receiver's pResponseInfo field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pResponseInfo) put: anObject yourAddress!

ReasonLength
	"Answer the receiver's ReasonLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ReasonLength)!

ReasonLength: anObject
	"Set the receiver's ReasonLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ReasonLength) put: anObject!

ResponseInfoCount
	"Answer the receiver's ResponseInfoCount field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ResponseInfoCount)!

ResponseInfoCount: anObject
	"Set the receiver's ResponseInfoCount field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ResponseInfoCount) put: anObject!

StatusCode
	"Answer the receiver's StatusCode field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #StatusCode)!

StatusCode: anObject
	"Set the receiver's StatusCode field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #StatusCode) put: anObject!

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

		typedef [uuid(5E3A97DA-7345-49A7-A5A9-1DDEA2366EB2), helpstring('This structure describes an HTTP response.')]
		struct tagHTTP_RESPONSE {
			[helpstring('Response flags from the HTTP_RESPONSE_FLAGS_* constants.')] unsigned long flags;
			[helpstring('The raw HTTP protocol version number.')] HTTP_VERSION Version;
			[helpstring('The HTTP status code (e.g., 200).')] unsigned short StatusCode;
			unsigned short ReasonLength;
			[helpstring('The HTTP reason (e.g., 'OK'). This MUST not contain non-ASCII characters (i.e., all chars must be in range 0x20-0x7E).')] LPCSTR pReason;
			[helpstring('The response headers.')] HTTP_RESPONSE_HEADERS Headers;
			unsigned short EntityChunkCount;
			[helpstring('pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs.')] HTTP_DATA_CHUNK* pEntityChunks;
			unsigned short ResponseInfoCount;
			PHTTP_RESPONSE_INFO pResponseInfo;
		} HTTP_RESPONSE;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #Version type: (StructureField type: HTTP_VERSION) offset: 4;
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

