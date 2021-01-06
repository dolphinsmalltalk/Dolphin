"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_RESPONSE_V1'
	instanceVariableNames: 'contentType content'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_EntityChunkCount' -> 16r110.
		'_OffsetOf_Flags' -> 16r0.
		'_OffsetOf_Headers' -> 16r10.
		'_OffsetOf_pEntityChunks' -> 16r114.
		'_OffsetOf_pReason' -> 16rC.
		'_OffsetOf_ReasonLength' -> 16rA.
		'_OffsetOf_StatusCode' -> 16r8.
		'_OffsetOf_Version' -> 16r4
	}!
WinHttpServer.HTTP_RESPONSE_V1 guid: (Core.GUID fromString: '{c23ac8a9-b97f-4aec-8096-91648573c429}')!
WinHttpServer.HTTP_RESPONSE_V1 comment: '`HTTP_RESPONSE_V1` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_RESPONSE_V1'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This structure describes an HTTP response (V1)."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(c23ac8a9-b97f-4aec-8096-91648573c429), helpstring("This structure describes an HTTP response (V1).")]
struct tagHTTP_RESPONSE_V1 {
	[helpstring("Response flags from the HTTP_RESPONSE_FLAGS_* constants.")] ULONG Flags;
	[helpstring("The raw HTTP protocol version number.")] HTTP_VERSION Version;
	[helpstring("The HTTP status code (e.g., 200).")] USHORT StatusCode;
	[nonbrowsable] USHORT ReasonLength;
	[helpstring("The HTTP reason (e.g., ''OK''). This MUST not contain non-ASCII characters (i.e., all chars must be in range 0x20-0x7E)."), size_is("ReasonLength"), string] LPCSTR pReason;
	[helpstring("The response headers.")] HTTP_RESPONSE_HEADERS Headers;
	[nonbrowsable] USHORT EntityChunkCount;
	[helpstring("pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs."), size_is("EntityChunkCount")] HTTP_DATA_CHUNK* pEntityChunks;
} HTTP_RESPONSE_V1;
```
'!
!WinHttpServer.HTTP_RESPONSE_V1 categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_RESPONSE_V1 methodsFor!

content: aByteObject
	content := HTTP_DATA_CHUNK data: aByteObject.
	bytes uintPtrAtOffset: _OffsetOf_pEntityChunks put: content yourAddress.
	self EntityChunkCount: 1!

contentType: aString
	contentType := aString.
	(self Headers KnownHeaders at: HttpHeaderContentType + 1) pRawValue: contentType!

EntityChunkCount
	"Private - Answer the <Integer> value of the receiver's 'EntityChunkCount' field."

	^bytes wordAtOffset: _OffsetOf_EntityChunkCount!

EntityChunkCount: anInteger
	"Set the receiver's 'EntityChunkCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_EntityChunkCount put: anInteger!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes dwordAtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Flags put: anInteger!

Headers
	"Answer the <HTTP_RESPONSE_HEADERS> value of the receiver's 'Headers' field."

	^HTTP_RESPONSE_HEADERS fromAddress: bytes yourAddress + _OffsetOf_Headers!

Headers: aHTTP_RESPONSE_HEADERS
	"Set the receiver's 'Headers' field to the value of the argument, aHTTP_RESPONSE_HEADERS"

	aHTTP_RESPONSE_HEADERS
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Headers + 1)
		to: ##(_OffsetOf_Headers + HTTP_RESPONSE_HEADERS basicByteSize)
		startingAt: 1!

initialize
	bytes dwordAtOffset: _OffsetOf_Version put: 16r10001!

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

pReason
	"Answer the <AnsiString> value of the receiver's 'pReason' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_pReason) length: self ReasonLength!

pReason: anAnsiString
	"Set the receiver's 'pReason' field to the value of the argument, anAnsiString"

	bytes uintPtrAtOffset: _OffsetOf_pReason put: anAnsiString yourAddress.
	self ReasonLength: anAnsiString size!

ReasonLength
	"Private - Answer the <Integer> value of the receiver's 'ReasonLength' field."

	^bytes wordAtOffset: _OffsetOf_ReasonLength!

ReasonLength: anInteger
	"Set the receiver's 'ReasonLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ReasonLength put: anInteger!

StatusCode
	"Answer the <Integer> value of the receiver's 'StatusCode' field."

	^bytes wordAtOffset: _OffsetOf_StatusCode!

StatusCode: anInteger
	"Set the receiver's 'StatusCode' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_StatusCode put: anInteger!

Version
	"Answer the <HTTP_VERSION> value of the receiver's 'Version' field."

	^HTTP_VERSION fromAddress: bytes yourAddress + _OffsetOf_Version!

Version: aHTTP_VERSION
	"Set the receiver's 'Version' field to the value of the argument, aHTTP_VERSION"

	aHTTP_VERSION
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Version + 1)
		to: ##(_OffsetOf_Version + HTTP_VERSION basicByteSize)
		startingAt: 1! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #content:!accessing!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #contentType:!accessing!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #EntityChunkCount!**compiled accessors**!private! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #EntityChunkCount:!**compiled accessors**!private! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #Flags!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #Flags:!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #Headers!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #Headers:!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #initialize!initializing!private! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #pEntityChunks!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #pEntityChunks:!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #pReason!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #pReason:!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #ReasonLength!**compiled accessors**!private! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #ReasonLength:!**compiled accessors**!private! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #StatusCode!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #StatusCode:!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #Version!**compiled accessors**!public! !
!WinHttpServer.HTTP_RESPONSE_V1 categoriesFor: #Version:!**compiled accessors**!public! !

!WinHttpServer.HTTP_RESPONSE_V1 class methodsFor!

defineFields
	"Define the fields of the HTTP_RESPONSE_V1 structure.

	HTTP_RESPONSE_V1 compileDefinition

		typedef [uuid(c23ac8a9-b97f-4aec-8096-91648573c429), helpstring('This structure describes an HTTP response (V1).')]
		struct tagHTTP_RESPONSE_V1 {
			[helpstring('Response flags from the HTTP_RESPONSE_FLAGS_* constants.')] ULONG Flags;
			[helpstring('The raw HTTP protocol version number.')] HTTP_VERSION Version;
			[helpstring('The HTTP status code (e.g., 200).')] USHORT StatusCode;
			[nonbrowsable] USHORT ReasonLength;
			[helpstring('The HTTP reason (e.g., 'OK'). This MUST not contain non-ASCII characters (i.e., all chars must be in range 0x20-0x7E).'), size_is('ReasonLength'), string] LPCSTR pReason;
			[helpstring('The response headers.')] HTTP_RESPONSE_HEADERS Headers;
			[nonbrowsable] USHORT EntityChunkCount;
			[helpstring('pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs.'), size_is('EntityChunkCount')] HTTP_DATA_CHUNK* pEntityChunks;
		} HTTP_RESPONSE_V1;
"

	self
		defineField: #Flags type: DWORDField new offset: 0;
		defineField: #Version type: (StructureField type: HTTP_VERSION) offset: 4;
		defineField: #StatusCode type: WORDField new offset: 8;
		defineField: #ReasonLength type: WORDField new beNonBrowsable offset: 10;
		defineField: #pReason type: (ArrayPointerField type: AnsiString lengthField: #ReasonLength) offset: 12;
		defineField: #Headers type: (StructureField type: HTTP_RESPONSE_HEADERS) offset: 16;
		defineField: #EntityChunkCount type: WORDField new beNonBrowsable offset: 272;
		defineField: #pEntityChunks type: (StructureArrayPointerField type: HTTP_DATA_CHUNK lengthField: #EntityChunkCount) offset: 276.
	self byteSize: 280!

getFieldNames
	^#(#Flags #Version #StatusCode #ReasonLength #pReason #Headers #EntityChunkCount #pEntityChunks)! !
!WinHttpServer.HTTP_RESPONSE_V1 class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_RESPONSE_V1 class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

