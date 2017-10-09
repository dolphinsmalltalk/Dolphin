"Filed out from Dolphin Smalltalk 7"!

HTTP_HEADERS subclass: #HTTP_RESPONSE_HEADERS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_RESPONSE_HEADERS guid: (GUID fromString: '{487fd2e3-1549-4dcf-8703-d45a2cbbcd85}')!
HTTP_RESPONSE_HEADERS comment: '<HTTP_RESPONSE_HEADERS> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_RESPONSE_HEADERS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of response headers."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(487fd2e3-1549-4dcf-8703-d45a2cbbcd85), helpstring("Structure defining format of response headers.")]
struct tagHTTP_RESPONSE_HEADERS {
	HTTP_HEADERS;
	[helpstring("Known response headers.")] HTTP_KNOWN_HEADER KnownHeaders[30];
} HTTP_RESPONSE_HEADERS;
'!
!HTTP_RESPONSE_HEADERS categoriesForClass!Win32-Structs! !
!HTTP_RESPONSE_HEADERS methodsFor!

KnownHeaders
	"Answer the <StructureArray> value of the receiver's 'KnownHeaders' field."

	^StructureArray
		fromAddress: bytes yourAddress + ##(self offsetOf: #KnownHeaders)
		length: 30
		elementClass: HTTP_KNOWN_HEADER!

KnownHeaders: aStructureArrayOfHTTP_KNOWN_HEADER
	"Set the receiver's 'KnownHeaders' field to the value of the argument, aStructureArrayOfHTTP_KNOWN_HEADER"

	| size |
	size := aStructureArrayOfHTTP_KNOWN_HEADER byteSize min: ##(30 * HTTP_KNOWN_HEADER basicByteSize).
	aStructureArrayOfHTTP_KNOWN_HEADER
		replaceBytesOf: bytes
		from: ##((self offsetOf: #KnownHeaders) + 1)
		to: ##(self offsetOf: #KnownHeaders) + size
		startingAt: 1! !
!HTTP_RESPONSE_HEADERS categoriesFor: #KnownHeaders!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #KnownHeaders:!**compiled accessors**!public! !

!HTTP_RESPONSE_HEADERS class methodsFor!

defineFields
	"Define the fields of the HTTP_RESPONSE_HEADERS structure.

	HTTP_RESPONSE_HEADERS compileDefinition

		typedef [uuid(487fd2e3-1549-4dcf-8703-d45a2cbbcd85), helpstring('Structure defining format of response headers.')]
		struct tagHTTP_RESPONSE_HEADERS {
			HTTP_HEADERS;
			[helpstring('Known response headers.')] HTTP_KNOWN_HEADER KnownHeaders[30];
		} HTTP_RESPONSE_HEADERS;
"

	super defineFields.
	self
		defineField: #KnownHeaders type: (StructureArrayField type: HTTP_KNOWN_HEADER length: 30) offset: 16.
	self byteSize: 256! !
!HTTP_RESPONSE_HEADERS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

