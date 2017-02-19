"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_RESPONSE_V1
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_RESPONSE_V1 guid: (GUID fromString: '{c23ac8a9-b97f-4aec-8096-91648573c429}')!
HTTP_RESPONSE_V1 comment: '<HTTP_RESPONSE_V1> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_RESPONSE_V1'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This structure describes an HTTP response (V1)."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(c23ac8a9-b97f-4aec-8096-91648573c429), helpstring("This structure describes an HTTP response (V1).")]
struct tagHTTP_RESPONSE_V1 {
	[helpstring("Response flags from the HTTP_RESPONSE_FLAGS_* constants.")] ULONG flags;
	[helpstring("The raw HTTP protocol version number.")] HTTP_VERSION Version;
	[helpstring("The HTTP status code (e.g., 200).")] USHORT StatusCode;
	[nonbrowsable] USHORT ReasonLength;
	[helpstring("The HTTP reason (e.g., ''OK''). This MUST not contain non-ASCII characters (i.e., all chars must be in range 0x20-0x7E)."), string, size_is("ReasonLength")] LPCSTR pReason;
	[helpstring("The response headers.")] HTTP_RESPONSE_HEADERS Headers;
	[nonbrowsable] USHORT EntityChunkCount;
	[helpstring("pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs."), size_is("EntityChunkCount")] HTTP_DATA_CHUNK* pEntityChunks;
} HTTP_RESPONSE_V1;
'!
!HTTP_RESPONSE_V1 categoriesForClass!Win32-Structs! !
!HTTP_RESPONSE_V1 methodsFor!

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
	"Answer the <StructureArray> value of the receiver's 'pEntityChunks' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pEntityChunks))
		length: self EntityChunkCount
		elementClass: HTTP_DATA_CHUNK!

pEntityChunks: aStructureArray
	"Set the receiver's 'pEntityChunks' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: ##(self offsetOf: #pEntityChunks) put: aStructureArray yourAddress.
	self EntityChunkCount: aStructureArray size!

pReason
	"Answer the <String> value of the receiver's 'pReason' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pReason)) length: self ReasonLength!

pReason: aString
	"Set the receiver's 'pReason' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #pReason) put: aString yourAddress.
	self ReasonLength: aString size!

ReasonLength
	"Private - Answer the <Integer> value of the receiver's 'ReasonLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #ReasonLength)!

ReasonLength: anInteger
	"Set the receiver's 'ReasonLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ReasonLength) put: anInteger!

StatusCode
	"Answer the <Integer> value of the receiver's 'StatusCode' field."

	^bytes wordAtOffset: ##(self offsetOf: #StatusCode)!

StatusCode: anInteger
	"Set the receiver's 'StatusCode' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #StatusCode) put: anInteger!

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
!HTTP_RESPONSE_V1 categoriesFor: #EntityChunkCount!**compiled accessors**!private! !
!HTTP_RESPONSE_V1 categoriesFor: #EntityChunkCount:!**compiled accessors**!private! !
!HTTP_RESPONSE_V1 categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #Headers!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #Headers:!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #pEntityChunks!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #pEntityChunks:!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #pReason!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #pReason:!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #ReasonLength!**compiled accessors**!private! !
!HTTP_RESPONSE_V1 categoriesFor: #ReasonLength:!**compiled accessors**!private! !
!HTTP_RESPONSE_V1 categoriesFor: #StatusCode!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #StatusCode:!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #Version!**compiled accessors**!public! !
!HTTP_RESPONSE_V1 categoriesFor: #Version:!**compiled accessors**!public! !

!HTTP_RESPONSE_V1 class methodsFor!

defineFields
	"Define the fields of the HTTP_RESPONSE_V1 structure.

	HTTP_RESPONSE_V1 compileDefinition

		typedef [uuid(c23ac8a9-b97f-4aec-8096-91648573c429), helpstring('This structure describes an HTTP response (V1).')]
		struct tagHTTP_RESPONSE_V1 {
			[helpstring('Response flags from the HTTP_RESPONSE_FLAGS_* constants.')] ULONG flags;
			[helpstring('The raw HTTP protocol version number.')] HTTP_VERSION Version;
			[helpstring('The HTTP status code (e.g., 200).')] USHORT StatusCode;
			[nonbrowsable] USHORT ReasonLength;
			[helpstring('The HTTP reason (e.g., 'OK'). This MUST not contain non-ASCII characters (i.e., all chars must be in range 0x20-0x7E).'), string, size_is('ReasonLength')] LPCSTR pReason;
			[helpstring('The response headers.')] HTTP_RESPONSE_HEADERS Headers;
			[nonbrowsable] USHORT EntityChunkCount;
			[helpstring('pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs.'), size_is('EntityChunkCount')] HTTP_DATA_CHUNK* pEntityChunks;
		} HTTP_RESPONSE_V1;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #Version type: (StructureField type: HTTP_VERSION) offset: 4;
		defineField: #StatusCode type: WORDField new offset: 8;
		defineField: #ReasonLength type: WORDField new beNonBrowsable offset: 10;
		defineField: #pReason type: (ArrayPointerField type: String lengthField: #ReasonLength) offset: 12;
		defineField: #Headers type: (StructureField type: HTTP_RESPONSE_HEADERS) offset: 16;
		defineField: #EntityChunkCount type: WORDField new beNonBrowsable offset: 272;
		defineField: #pEntityChunks type: (StructureArrayPointerField type: HTTP_DATA_CHUNK lengthField: #EntityChunkCount) offset: 276.
	self byteSize: 280! !
!HTTP_RESPONSE_V1 class categoriesFor: #defineFields!**auto generated**!initializing!public! !

