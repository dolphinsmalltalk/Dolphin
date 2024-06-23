"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_DATA_CHUNK'
	instanceVariableNames: 'data'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_DATA_CHUNK_Size' -> 16r20.
			'_OffsetOf_DataChunkType' -> 16r0.
			'_OffsetOf_FromFileHandle_ByteRange' -> 16r8.
			'_OffsetOf_FromFileHandle_FileHandle' -> 16r18.
			'_OffsetOf_FromFragmentCache_FragmentNameLength' -> 16r8.
			'_OffsetOf_FromFragmentCache_pFragmentName' -> 16rC.
			'_OffsetOf_FromFragmentCacheEx_ByteRange' -> 16r8.
			'_OffsetOf_FromFragmentCacheEx_pFragmentName' -> 16r18.
			'_OffsetOf_FromMemory_BufferLength' -> 16rC.
			'_OffsetOf_FromMemory_pBuffer' -> 16r8
		}!

WinHttpServer.HTTP_DATA_CHUNK guid: (Core.GUID fromString: '{831e8135-6bb5-45e2-b278-10b1c489883a}')!

WinHttpServer.HTTP_DATA_CHUNK comment: '`HTTP_DATA_CHUNK` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_DATA_CHUNK'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This structure describes an individual data chunk."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(831e8135-6bb5-45e2-b278-10b1c489883a), helpstring("This structure describes an individual data chunk.")]
struct tagHTTP_DATA_CHUNK {
	[helpstring("The type of this data chunk.")] HTTP_DATA_CHUNK_TYPE DataChunkType;
	[helpstring("The data chunk structures, one per supported data chunk type.")] union {
		[helpstring("From-memory data chunk.")] struct {
			PVOID pBuffer;
			ULONG BufferLength;
		} FromMemory;
		[helpstring("From-file handle data chunk.")] struct {
			HTTP_BYTE_RANGE ByteRange;
			HANDLE FileHandle;
		} FromFileHandle;
		[helpstring("From-fragment cache data chunk.")] struct {
			[helpstring("Size in bytes of FragmentName not including terminating null")] USHORT FragmentNameLength;
			LPCWSTR pFragmentName;
		} FromFragmentCache;
		[helpstring("From-fragment cache data chunk that specifies a byte range.")] struct {
			HTTP_BYTE_RANGE ByteRange;
			[helpstring("Null-terminated string")] LPCWSTR pFragmentName;
		} FromFragmentCacheEx;
	};
} HTTP_DATA_CHUNK;
```
'!

!WinHttpServer.HTTP_DATA_CHUNK categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_DATA_CHUNK methodsFor!

data: aByteObject
	data := aByteObject.
	self
		FromMemory_pBuffer: data yourAddress;
		FromMemory_BufferLength: data size;
		DataChunkType: HttpDataChunkFromMemory!

DataChunkType
	"Answer the <Integer> value of the receiver's 'DataChunkType' field."

	^bytes int32AtOffset: _OffsetOf_DataChunkType!

DataChunkType: anInteger
	"Set the receiver's 'DataChunkType' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_DataChunkType put: anInteger!

FromFileHandle_ByteRange
	"Answer the <HTTP_BYTE_RANGE> value of the receiver's 'FromFileHandle_ByteRange' field."

	^HTTP_BYTE_RANGE fromAddress: bytes yourAddress + _OffsetOf_FromFileHandle_ByteRange!

FromFileHandle_ByteRange: aHTTP_BYTE_RANGE
	"Set the receiver's 'FromFileHandle_ByteRange' field to the value of the argument, aHTTP_BYTE_RANGE"

	aHTTP_BYTE_RANGE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_FromFileHandle_ByteRange + 1)
		to: ##(_OffsetOf_FromFileHandle_ByteRange + HTTP_BYTE_RANGE._HTTP_BYTE_RANGE_Size)
		startingAt: 1!

FromFileHandle_FileHandle
	"Answer the <Handle> value of the receiver's 'FromFileHandle_FileHandle' field."

	^(bytes uintPtrAtOffset: _OffsetOf_FromFileHandle_FileHandle) asExternalHandle!

FromFileHandle_FileHandle: aHandle
	"Set the receiver's 'FromFileHandle_FileHandle' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_FromFileHandle_FileHandle put: aHandle!

FromFragmentCache_FragmentNameLength
	"Answer the <Integer> value of the receiver's 'FromFragmentCache_FragmentNameLength' field."

	^bytes uint16AtOffset: _OffsetOf_FromFragmentCache_FragmentNameLength!

FromFragmentCache_FragmentNameLength: anInteger
	"Set the receiver's 'FromFragmentCache_FragmentNameLength' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_FromFragmentCache_FragmentNameLength put: anInteger!

FromFragmentCache_pFragmentName
	"Answer the <Utf16String> value of the receiver's 'FromFragmentCache_pFragmentName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_FromFragmentCache_pFragmentName)!

FromFragmentCache_pFragmentName: anUtf16String
	"Set the receiver's 'FromFragmentCache_pFragmentName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_FromFragmentCache_pFragmentName put: anUtf16String yourAddress!

FromFragmentCacheEx_ByteRange
	"Answer the <HTTP_BYTE_RANGE> value of the receiver's 'FromFragmentCacheEx_ByteRange' field."

	^HTTP_BYTE_RANGE fromAddress: bytes yourAddress + _OffsetOf_FromFragmentCacheEx_ByteRange!

FromFragmentCacheEx_ByteRange: aHTTP_BYTE_RANGE
	"Set the receiver's 'FromFragmentCacheEx_ByteRange' field to the value of the argument, aHTTP_BYTE_RANGE"

	aHTTP_BYTE_RANGE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_FromFragmentCacheEx_ByteRange + 1)
		to: ##(_OffsetOf_FromFragmentCacheEx_ByteRange + HTTP_BYTE_RANGE._HTTP_BYTE_RANGE_Size)
		startingAt: 1!

FromFragmentCacheEx_pFragmentName
	"Answer the <Utf16String> value of the receiver's 'FromFragmentCacheEx_pFragmentName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_FromFragmentCacheEx_pFragmentName)!

FromFragmentCacheEx_pFragmentName: anUtf16String
	"Set the receiver's 'FromFragmentCacheEx_pFragmentName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_FromFragmentCacheEx_pFragmentName put: anUtf16String yourAddress!

FromMemory_BufferLength
	"Answer the <Integer> value of the receiver's 'FromMemory_BufferLength' field."

	^bytes uint32AtOffset: _OffsetOf_FromMemory_BufferLength!

FromMemory_BufferLength: anInteger
	"Set the receiver's 'FromMemory_BufferLength' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_FromMemory_BufferLength put: anInteger!

FromMemory_pBuffer
	"Answer the <Address> value of the receiver's 'FromMemory_pBuffer' field."

	^(bytes uintPtrAtOffset: _OffsetOf_FromMemory_pBuffer) asExternalAddress!

FromMemory_pBuffer: anAddress
	"Set the receiver's 'FromMemory_pBuffer' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_FromMemory_pBuffer put: anAddress!

printableFields
	^{#(#FromMemory_pBuffer #FromFileHandle_FileHandle #FromFragmentCache_pFragmentName #FromFragmentCacheEx_pFragmentName)
			at: self DataChunkType + 1}! !

!WinHttpServer.HTTP_DATA_CHUNK categoriesForMethods!
data:!accessing!public! !
DataChunkType!**compiled accessors**!public! !
DataChunkType:!**compiled accessors**!public! !
FromFileHandle_ByteRange!**compiled accessors**!public! !
FromFileHandle_ByteRange:!**compiled accessors**!public! !
FromFileHandle_FileHandle!**compiled accessors**!public! !
FromFileHandle_FileHandle:!**compiled accessors**!public! !
FromFragmentCache_FragmentNameLength!**compiled accessors**!public! !
FromFragmentCache_FragmentNameLength:!**compiled accessors**!public! !
FromFragmentCache_pFragmentName!**compiled accessors**!public! !
FromFragmentCache_pFragmentName:!**compiled accessors**!public! !
FromFragmentCacheEx_ByteRange!**compiled accessors**!public! !
FromFragmentCacheEx_ByteRange:!**compiled accessors**!public! !
FromFragmentCacheEx_pFragmentName!**compiled accessors**!public! !
FromFragmentCacheEx_pFragmentName:!**compiled accessors**!public! !
FromMemory_BufferLength!**compiled accessors**!public! !
FromMemory_BufferLength:!**compiled accessors**!public! !
FromMemory_pBuffer!**compiled accessors**!public! !
FromMemory_pBuffer:!**compiled accessors**!public! !
printableFields!development!printing!private! !
!

!WinHttpServer.HTTP_DATA_CHUNK class methodsFor!

byteSize
	^_HTTP_DATA_CHUNK_Size!

data: aByteObject
	^(self new)
		data: aByteObject;
		yourself!

defineFields
	"Define the fields of the HTTP_DATA_CHUNK structure.

	HTTP_DATA_CHUNK compileDefinition

		typedef [uuid(831e8135-6bb5-45e2-b278-10b1c489883a), helpstring('This structure describes an individual data chunk.')]
		struct tagHTTP_DATA_CHUNK {
			[helpstring('The type of this data chunk.')] HTTP_DATA_CHUNK_TYPE DataChunkType;
			[helpstring('The data chunk structures, one per supported data chunk type.')] union {
				[helpstring('From-memory data chunk.')] struct {
					PVOID pBuffer;
					ULONG BufferLength;
				} FromMemory;
				[helpstring('From-file handle data chunk.')] struct {
					HTTP_BYTE_RANGE ByteRange;
					HANDLE FileHandle;
				} FromFileHandle;
				[helpstring('From-fragment cache data chunk.')] struct {
					[helpstring('Size in bytes of FragmentName not including terminating null')] USHORT FragmentNameLength;
					LPCWSTR pFragmentName;
				} FromFragmentCache;
				[helpstring('From-fragment cache data chunk that specifies a byte range.')] struct {
					HTTP_BYTE_RANGE ByteRange;
					[helpstring('Null-terminated string')] LPCWSTR pFragmentName;
				} FromFragmentCacheEx;
			};
		} HTTP_DATA_CHUNK;
"

	self
		defineField: #DataChunkType type: Int32Field new offset: 0;
		defineField: #FromMemory_pBuffer type: LPVOIDField new offset: 8;
		defineField: #FromMemory_BufferLength type: UInt32Field new offset: 12;
		defineField: #FromFileHandle_ByteRange type: (StructureField type: HTTP_BYTE_RANGE) offset: 8;
		defineField: #FromFileHandle_FileHandle type: HANDLEField new offset: 24;
		defineField: #FromFragmentCache_FragmentNameLength type: UInt16Field new offset: 8;
		defineField: #FromFragmentCache_pFragmentName type: (PointerField type: Utf16String) offset: 12;
		defineField: #FromFragmentCacheEx_ByteRange type: (StructureField type: HTTP_BYTE_RANGE) offset: 8;
		defineField: #FromFragmentCacheEx_pFragmentName type: (PointerField type: Utf16String) offset: 24.
	self byteSize: 32!

getFieldNames
	^#(#DataChunkType #FromFileHandle_ByteRange #FromFragmentCache_FragmentNameLength #FromFragmentCacheEx_ByteRange #FromMemory_pBuffer #FromFragmentCache_pFragmentName #FromMemory_BufferLength #FromFileHandle_FileHandle #FromFragmentCacheEx_pFragmentName)! !

!WinHttpServer.HTTP_DATA_CHUNK class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
data:!instance creation!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

