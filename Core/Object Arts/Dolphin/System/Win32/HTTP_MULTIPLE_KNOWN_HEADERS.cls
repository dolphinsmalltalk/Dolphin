"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_MULTIPLE_KNOWN_HEADERS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_MULTIPLE_KNOWN_HEADERS guid: (GUID fromString: '{a12486b1-fdf5-4d31-a4b7-af9848ffe5c6}')!
HTTP_MULTIPLE_KNOWN_HEADERS comment: '<HTTP_MULTIPLE_KNOWN_HEADERS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_MULTIPLE_KNOWN_HEADERS'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This structure allows the provision of providing multiple known headers."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(a12486b1-fdf5-4d31-a4b7-af9848ffe5c6), helpstring("This structure allows the provision of providing multiple known headers.")]
struct tagHTTP_MULTIPLE_KNOWN_HEADERS {
	[helpstring("Known header id.")] HTTP_HEADER_ID HeaderId;
	[helpstring("The flags corresponding to the response header in the HeaderId member. This member is used only when the WWW-Authenticate header is present.")] ULONG flags;
	[helpstring("The number of elements in the array specified in the KnownHeaders member.")] USHORT KnownHeaderCount;
	[helpstring("A pointer to the first element in the array of HTTP_KNOWN_HEADER structures."), size_is("KnownHeaderCount")] PHTTP_KNOWN_HEADER KnownHeaders;
} HTTP_MULTIPLE_KNOWN_HEADERS;
'!
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesForClass!Win32-Structs! !
!HTTP_MULTIPLE_KNOWN_HEADERS methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anInteger!

HeaderId
	"Answer the <Integer> value of the receiver's 'HeaderId' field."

	^bytes sdwordAtOffset: 0!

HeaderId: anInteger
	"Set the receiver's 'HeaderId' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

KnownHeaderCount
	"Answer the <Integer> value of the receiver's 'KnownHeaderCount' field."

	^bytes wordAtOffset: ##(self offsetOf: #KnownHeaderCount)!

KnownHeaderCount: anInteger
	"Set the receiver's 'KnownHeaderCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #KnownHeaderCount) put: anInteger!

KnownHeaders
	"Answer the <StructureArray> value of the receiver's 'KnownHeaders' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #KnownHeaders))
		length: self KnownHeaderCount
		elementClass: HTTP_KNOWN_HEADER!

KnownHeaders: aStructureArray
	"Set the receiver's 'KnownHeaders' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: ##(self offsetOf: #KnownHeaders) put: aStructureArray yourAddress.
	self KnownHeaderCount: aStructureArray size! !
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #HeaderId!**compiled accessors**!public! !
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #HeaderId:!**compiled accessors**!public! !
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #KnownHeaderCount!**compiled accessors**!public! !
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #KnownHeaderCount:!**compiled accessors**!public! !
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #KnownHeaders!**compiled accessors**!public! !
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesFor: #KnownHeaders:!**compiled accessors**!public! !

!HTTP_MULTIPLE_KNOWN_HEADERS class methodsFor!

defineFields
	"Define the fields of the HTTP_MULTIPLE_KNOWN_HEADERS structure.

	HTTP_MULTIPLE_KNOWN_HEADERS compileDefinition

		typedef [uuid(a12486b1-fdf5-4d31-a4b7-af9848ffe5c6), helpstring('This structure allows the provision of providing multiple known headers.')]
		struct tagHTTP_MULTIPLE_KNOWN_HEADERS {
			[helpstring('Known header id.')] HTTP_HEADER_ID HeaderId;
			[helpstring('The flags corresponding to the response header in the HeaderId member. This member is used only when the WWW-Authenticate header is present.')] ULONG flags;
			[helpstring('The number of elements in the array specified in the KnownHeaders member.')] USHORT KnownHeaderCount;
			[helpstring('A pointer to the first element in the array of HTTP_KNOWN_HEADER structures.'), size_is('KnownHeaderCount')] PHTTP_KNOWN_HEADER KnownHeaders;
		} HTTP_MULTIPLE_KNOWN_HEADERS;
"

	self
		defineField: #HeaderId type: SDWORDField new offset: 0;
		defineField: #flags type: DWORDField new offset: 4;
		defineField: #KnownHeaderCount type: WORDField new offset: 8;
		defineField: #KnownHeaders type: (StructureArrayPointerField type: HTTP_KNOWN_HEADER lengthField: #KnownHeaderCount) offset: 12.
	self byteSize: 16! !
!HTTP_MULTIPLE_KNOWN_HEADERS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

