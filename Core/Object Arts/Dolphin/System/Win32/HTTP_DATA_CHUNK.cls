"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_DATA_CHUNK
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_DATA_CHUNK guid: (GUID fromString: '{831E8135-6BB5-45E2-B278-10B1C489883A}')!
HTTP_DATA_CHUNK comment: '<HTTP_DATA_CHUNK> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_DATA_CHUNK'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This structure describes an individual data chunk."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(831E8135-6BB5-45E2-B278-10B1C489883A), helpstring("This structure describes an individual data chunk.")]
struct tagHTTP_DATA_CHUNK {
	[helpstring("The type of this data chunk.")] HTTP_DATA_CHUNK_TYPE DataChunkType;
	[helpstring("The data chunk structures, one per supported data chunk type.")] union {
		[helpstring("From-memory data chunk.")] struct {
			void* pBuffer;
			unsigned long BufferLength;
		} FromMemory;
		[helpstring("From-file handle data chunk.")] struct {
			HTTP_BYTE_RANGE ByteRange;
			HANDLE FileHandle;
		} FromFileHandle;
		[helpstring("From-fragment cache data chunk.")] struct {
			unsigned short FragmentNameLength;
			LPCWSTR pFragmentName;
		} FromFragmentCache;
		[helpstring("From-fragment cache data chunk that specifies a byte range.")] struct {
			HTTP_BYTE_RANGE ByteRange;
			LPCWSTR pFragmentName;
		} FromFragmentCacheEx;
	};
} HTTP_DATA_CHUNK;
'!
!HTTP_DATA_CHUNK categoriesForClass!Win32-Structs! !
!HTTP_DATA_CHUNK methodsFor!

DataChunkType
	"Answer the receiver's DataChunkType field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

DataChunkType: anObject
	"Set the receiver's DataChunkType field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

FromFileHandle_ByteRange
	"Answer the receiver's FromFileHandle_ByteRange field as a Smalltalk object."

	^HTTP_BYTE_RANGE fromAddress: bytes yourAddress + ##(self offsetOf: #FromFileHandle_ByteRange)!

FromFileHandle_ByteRange: anObject
	"Set the receiver's FromFileHandle_ByteRange field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #FromFileHandle_ByteRange) + 1)
		to: ##((self offsetOf: #FromFileHandle_ByteRange) + HTTP_BYTE_RANGE basicByteSize)
		startingAt: 1!

FromFileHandle_FileHandle
	"Answer the receiver's FromFileHandle_FileHandle field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #FromFileHandle_FileHandle)) asExternalHandle!

FromFileHandle_FileHandle: anObject
	"Set the receiver's FromFileHandle_FileHandle field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #FromFileHandle_FileHandle) put: anObject!

FromFragmentCache_FragmentNameLength
	"Answer the receiver's FromFragmentCache_FragmentNameLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #FromFragmentCache_FragmentNameLength)!

FromFragmentCache_FragmentNameLength: anObject
	"Set the receiver's FromFragmentCache_FragmentNameLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #FromFragmentCache_FragmentNameLength) put: anObject!

FromFragmentCache_pFragmentName
	"Answer the receiver's FromFragmentCache_pFragmentName field as a Smalltalk object."

	^UnicodeString
		fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #FromFragmentCache_pFragmentName))!

FromFragmentCache_pFragmentName: anObject
	"Set the receiver's FromFragmentCache_pFragmentName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #FromFragmentCache_pFragmentName) put: anObject yourAddress!

FromFragmentCacheEx_ByteRange
	"Answer the receiver's FromFragmentCacheEx_ByteRange field as a Smalltalk object."

	^HTTP_BYTE_RANGE fromAddress: bytes yourAddress + ##(self offsetOf: #FromFragmentCacheEx_ByteRange)!

FromFragmentCacheEx_ByteRange: anObject
	"Set the receiver's FromFragmentCacheEx_ByteRange field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #FromFragmentCacheEx_ByteRange) + 1)
		to: ##((self offsetOf: #FromFragmentCacheEx_ByteRange) + HTTP_BYTE_RANGE basicByteSize)
		startingAt: 1!

FromFragmentCacheEx_pFragmentName
	"Answer the receiver's FromFragmentCacheEx_pFragmentName field as a Smalltalk object."

	^UnicodeString
		fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #FromFragmentCacheEx_pFragmentName))!

FromFragmentCacheEx_pFragmentName: anObject
	"Set the receiver's FromFragmentCacheEx_pFragmentName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #FromFragmentCacheEx_pFragmentName)
		put: anObject yourAddress!

FromMemory_BufferLength
	"Answer the receiver's FromMemory_BufferLength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #FromMemory_BufferLength)!

FromMemory_BufferLength: anObject
	"Set the receiver's FromMemory_BufferLength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #FromMemory_BufferLength) put: anObject!

FromMemory_pBuffer
	"Answer the receiver's FromMemory_pBuffer field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #FromMemory_pBuffer)) asExternalAddress!

FromMemory_pBuffer: anObject
	"Set the receiver's FromMemory_pBuffer field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #FromMemory_pBuffer) put: anObject! !
!HTTP_DATA_CHUNK categoriesFor: #DataChunkType!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #DataChunkType:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFileHandle_ByteRange!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFileHandle_ByteRange:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFileHandle_FileHandle!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFileHandle_FileHandle:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCache_FragmentNameLength!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCache_FragmentNameLength:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCache_pFragmentName!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCache_pFragmentName:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCacheEx_ByteRange!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCacheEx_ByteRange:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCacheEx_pFragmentName!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCacheEx_pFragmentName:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromMemory_BufferLength!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromMemory_BufferLength:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromMemory_pBuffer!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromMemory_pBuffer:!**compiled accessors**!public! !

!HTTP_DATA_CHUNK class methodsFor!

defineFields
	"Define the fields of the HTTP_DATA_CHUNK structure.

	HTTP_DATA_CHUNK  compileDefinition

		typedef [uuid(831E8135-6BB5-45E2-B278-10B1C489883A), helpstring('This structure describes an individual data chunk.')]
		struct tagHTTP_DATA_CHUNK {
			[helpstring('The type of this data chunk.')] HTTP_DATA_CHUNK_TYPE DataChunkType;
			[helpstring('The data chunk structures, one per supported data chunk type.')] union {
				[helpstring('From-memory data chunk.')] struct {
					void* pBuffer;
					unsigned long BufferLength;
				} FromMemory;
				[helpstring('From-file handle data chunk.')] struct {
					HTTP_BYTE_RANGE ByteRange;
					HANDLE FileHandle;
				} FromFileHandle;
				[helpstring('From-fragment cache data chunk.')] struct {
					unsigned short FragmentNameLength;
					LPCWSTR pFragmentName;
				} FromFragmentCache;
				[helpstring('From-fragment cache data chunk that specifies a byte range.')] struct {
					HTTP_BYTE_RANGE ByteRange;
					LPCWSTR pFragmentName;
				} FromFragmentCacheEx;
			};
		} HTTP_DATA_CHUNK;
"

	self
		defineField: #DataChunkType type: SDWORDField new offset: 0;
		defineField: #FromMemory_pBuffer type: LPVOIDField new offset: 8;
		defineField: #FromMemory_BufferLength type: DWORDField new offset: 12;
		defineField: #FromFileHandle_ByteRange type: (StructureField type: HTTP_BYTE_RANGE) offset: 8;
		defineField: #FromFileHandle_FileHandle type: HANDLEField new offset: 24;
		defineField: #FromFragmentCache_FragmentNameLength type: WORDField new offset: 8;
		defineField: #FromFragmentCache_pFragmentName type: (PointerField type: UnicodeString) offset: 12;
		defineField: #FromFragmentCacheEx_ByteRange type: (StructureField type: HTTP_BYTE_RANGE) offset: 8;
		defineField: #FromFragmentCacheEx_pFragmentName type: (PointerField type: UnicodeString) offset: 24.
	self byteSize: 32! !
!HTTP_DATA_CHUNK class categoriesFor: #defineFields!**auto generated**!initializing!public! !

