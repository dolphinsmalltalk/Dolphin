"Filed out from Dolphin Smalltalk 7"!

HTTP_HEADERS subclass: #HTTP_REQUEST_HEADERS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''!
HTTP_REQUEST_HEADERS guid: (GUID fromString: '{f762b6ac-f56f-4aeb-aca3-d6b628473c2c}')!
HTTP_REQUEST_HEADERS comment: '<HTTP_REQUEST_HEADERS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST_HEADERS'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of request headers."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(f762b6ac-f56f-4aeb-aca3-d6b628473c2c), helpstring("Structure defining format of request headers.")]
struct tagHTTP_REQUEST_HEADERS {
	HTTP_HEADERS;
	[helpstring("Known request headers.")] HTTP_KNOWN_HEADER KnownHeaders[41];
} HTTP_REQUEST_HEADERS;
'!
!HTTP_REQUEST_HEADERS categoriesForClass!Win32-Structs! !
!HTTP_REQUEST_HEADERS methodsFor!

KnownHeaders
	"Answer the <StructureArray> value of the receiver's 'KnownHeaders' field."

	^StructureArray
		fromAddress: bytes yourAddress + ##(self offsetOf: #KnownHeaders)
		length: 41
		elementClass: HTTP_KNOWN_HEADER!

KnownHeaders: aStructureArrayOfHTTP_KNOWN_HEADER
	"Set the receiver's 'KnownHeaders' field to the value of the argument, aStructureArrayOfHTTP_KNOWN_HEADER"

	| size |
	size := aStructureArrayOfHTTP_KNOWN_HEADER byteSize min: ##(41 * HTTP_KNOWN_HEADER basicByteSize).
	aStructureArrayOfHTTP_KNOWN_HEADER
		replaceBytesOf: bytes
		from: ##((self offsetOf: #KnownHeaders) + 1)
		to: ##(self offsetOf: #KnownHeaders) + size
		startingAt: 1! !
!HTTP_REQUEST_HEADERS categoriesFor: #KnownHeaders!**compiled accessors**!public! !
!HTTP_REQUEST_HEADERS categoriesFor: #KnownHeaders:!**compiled accessors**!public! !

!HTTP_REQUEST_HEADERS class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_HEADERS structure.

	HTTP_REQUEST_HEADERS compileDefinition

		typedef [uuid(f762b6ac-f56f-4aeb-aca3-d6b628473c2c), helpstring('Structure defining format of request headers.')]
		struct tagHTTP_REQUEST_HEADERS {
			HTTP_HEADERS;
			[helpstring('Known request headers.')] HTTP_KNOWN_HEADER KnownHeaders[41];
		} HTTP_REQUEST_HEADERS;
"

	super defineFields.
	self
		defineField: #KnownHeaders type: (StructureArrayField type: HTTP_KNOWN_HEADER length: 41) offset: 16.
	self byteSize: 344! !
!HTTP_REQUEST_HEADERS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

