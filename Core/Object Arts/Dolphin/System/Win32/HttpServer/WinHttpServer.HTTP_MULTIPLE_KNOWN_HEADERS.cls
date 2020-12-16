"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
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

	^bytes dwordAtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Flags put: anInteger!

HeaderId
	"Answer the <Integer> value of the receiver's 'HeaderId' field."

	^bytes sdwordAtOffset: _OffsetOf_HeaderId!

HeaderId: anInteger
	"Set the receiver's 'HeaderId' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_HeaderId put: anInteger!

KnownHeaderCount
	"Answer the <Integer> value of the receiver's 'KnownHeaderCount' field."

	^bytes wordAtOffset: _OffsetOf_KnownHeaderCount!

KnownHeaderCount: anInteger
	"Set the receiver's 'KnownHeaderCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_KnownHeaderCount put: anInteger!

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
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #Flags!**compiled accessors**!public! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #Flags:!**compiled accessors**!public! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #HeaderId!**compiled accessors**!public! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #HeaderId:!**compiled accessors**!public! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #KnownHeaderCount!**compiled accessors**!public! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #KnownHeaderCount:!**compiled accessors**!public! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #KnownHeaders!**compiled accessors**!public! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #KnownHeaders:!**compiled accessors**!public! !

!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS class methodsFor!

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
		defineField: #HeaderId type: SDWORDField new offset: 0;
		defineField: #Flags type: DWORDField new offset: 4;
		defineField: #KnownHeaderCount type: WORDField new offset: 8;
		defineField: #KnownHeaders type: (StructureArrayPointerField type: HTTP_KNOWN_HEADER lengthField: #KnownHeaderCount) offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#HeaderId #Flags #KnownHeaderCount #KnownHeaders)! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_MULTIPLE_KNOWN_HEADERS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

