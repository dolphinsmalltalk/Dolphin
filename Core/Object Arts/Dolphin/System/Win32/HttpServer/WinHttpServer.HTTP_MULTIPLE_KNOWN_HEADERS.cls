"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_HTTP_MULTIPLE_KNOWN_HEADERS_Size' -> 16r10.
		'_OffsetOf_Flags' -> 16r4.
		'_OffsetOf_HeaderId' -> 16r0.
		'_OffsetOf_KnownHeaderCount' -> 16r8.
		'_OffsetOf_KnownHeaders' -> 16rC
	}!
WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS guid: (Core.GUID fromString: '{a12486b1-fdf5-4d31-a4b7-af9848ffe5c6}')!
WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS comment: '`HTTP_MULTIPLE_KNOWN_HEADERS` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This structure allows the provision of providing multiple known headers."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(a12486b1-fdf5-4d31-a4b7-af9848ffe5c6), helpstring("This structure allows the provision of providing multiple known headers.")]
struct tagHTTP_MULTIPLE_KNOWN_HEADERS {
	[helpstring("Known header id.")] HTTP_HEADER_ID HeaderId;
	[helpstring("The flags corresponding to the response header in the HeaderId member. This member is used only when the WWW-Authenticate header is present.")] ULONG Flags;
	[helpstring("The number of elements in the array specified in the KnownHeaders member.")] USHORT KnownHeaderCount;
	[helpstring("A pointer to the first element in the array of HTTP_KNOWN_HEADER structures."), size_is("KnownHeaderCount")] PHTTP_KNOWN_HEADER KnownHeaders;
} HTTP_MULTIPLE_KNOWN_HEADERS;
```
'!
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS methodsFor!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes uint32AtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Flags put: anInteger!

HeaderId
	"Answer the <Integer> value of the receiver's 'HeaderId' field."

	^bytes int32AtOffset: _OffsetOf_HeaderId!

HeaderId: anInteger
	"Set the receiver's 'HeaderId' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_HeaderId put: anInteger!

KnownHeaderCount
	"Answer the <Integer> value of the receiver's 'KnownHeaderCount' field."

	^bytes uint16AtOffset: _OffsetOf_KnownHeaderCount!

KnownHeaderCount: anInteger
	"Set the receiver's 'KnownHeaderCount' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_KnownHeaderCount put: anInteger!

KnownHeaders
	"Answer the <StructureArray> value of the receiver's 'KnownHeaders' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_KnownHeaders)
		length: self KnownHeaderCount
		elementClass: HTTP_KNOWN_HEADER!

KnownHeaders: aStructureArray
	"Set the receiver's 'KnownHeaders' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_KnownHeaders put: aStructureArray yourAddress.
	self KnownHeaderCount: aStructureArray size! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesForMethods!
Flags!**compiled accessors**!public! !
Flags:!**compiled accessors**!public! !
HeaderId!**compiled accessors**!public! !
HeaderId:!**compiled accessors**!public! !
KnownHeaderCount!**compiled accessors**!public! !
KnownHeaderCount:!**compiled accessors**!public! !
KnownHeaders!**compiled accessors**!public! !
KnownHeaders:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS class methodsFor!

byteSize
	^_HTTP_MULTIPLE_KNOWN_HEADERS_Size!

defineFields
	"Define the fields of the HTTP_MULTIPLE_KNOWN_HEADERS structure.

	HTTP_MULTIPLE_KNOWN_HEADERS compileDefinition

		typedef [uuid(a12486b1-fdf5-4d31-a4b7-af9848ffe5c6), helpstring('This structure allows the provision of providing multiple known headers.')]
		struct tagHTTP_MULTIPLE_KNOWN_HEADERS {
			[helpstring('Known header id.')] HTTP_HEADER_ID HeaderId;
			[helpstring('The flags corresponding to the response header in the HeaderId member. This member is used only when the WWW-Authenticate header is present.')] ULONG Flags;
			[helpstring('The number of elements in the array specified in the KnownHeaders member.')] USHORT KnownHeaderCount;
			[helpstring('A pointer to the first element in the array of HTTP_KNOWN_HEADER structures.'), size_is('KnownHeaderCount')] PHTTP_KNOWN_HEADER KnownHeaders;
		} HTTP_MULTIPLE_KNOWN_HEADERS;
"

	self
		defineField: #HeaderId type: Int32Field new offset: 0;
		defineField: #Flags type: UInt32Field new offset: 4;
		defineField: #KnownHeaderCount type: UInt16Field new offset: 8;
		defineField: #KnownHeaders type: (StructureArrayPointerField type: HTTP_KNOWN_HEADER lengthField: #KnownHeaderCount) offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#HeaderId #Flags #KnownHeaderCount #KnownHeaders)! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

