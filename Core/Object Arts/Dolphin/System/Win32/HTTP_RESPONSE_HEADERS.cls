"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_RESPONSE_HEADERS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_RESPONSE_HEADERS guid: (GUID fromString: '{487FD2E3-1549-4DCF-8703-D45A2CBBCD85}')!
HTTP_RESPONSE_HEADERS comment: '<HTTP_RESPONSE_HEADERS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_RESPONSE_HEADERS'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of response headers."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(487FD2E3-1549-4DCF-8703-D45A2CBBCD85), helpstring("Structure defining format of response headers.")]
struct tagHTTP_RESPONSE_HEADERS {
	[helpstring("The array of unknown HTTP headers and the number of entries in the array.")] unsigned short UnknownHeaderCount;
	PHTTP_UNKNOWN_HEADER pUnknownHeaders;
	[helpstring("Trailers - we don''t use these currently, reserved for a future release")] unsigned short TrailerCount;
	PHTTP_UNKNOWN_HEADER pTrailers;
	[helpstring("Known headers.")] HTTP_KNOWN_HEADER KnownHeaders[30];
} HTTP_RESPONSE_HEADERS;
'!
!HTTP_RESPONSE_HEADERS categoriesForClass!Win32-Structs! !
!HTTP_RESPONSE_HEADERS methodsFor!

KnownHeaders
	"Answer the receiver's KnownHeaders field as a Smalltalk object."

	^StructureArray
		fromAddress: bytes yourAddress + ##(self offsetOf: #KnownHeaders)
		length: 30
		elementClass: HTTP_KNOWN_HEADER!

KnownHeaders: anObject
	"Set the receiver's KnownHeaders field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(30 * HTTP_KNOWN_HEADER basicByteSize).
	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #KnownHeaders) + 1)
		to: ##(self offsetOf: #KnownHeaders) + size
		startingAt: 1!

pTrailers
	"Answer the receiver's pTrailers field as a Smalltalk object."

	^HTTP_UNKNOWN_HEADER fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pTrailers))!

pTrailers: anObject
	"Set the receiver's pTrailers field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pTrailers) put: anObject yourAddress!

pUnknownHeaders
	"Answer the receiver's pUnknownHeaders field as a Smalltalk object."

	^HTTP_UNKNOWN_HEADER fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pUnknownHeaders))!

pUnknownHeaders: anObject
	"Set the receiver's pUnknownHeaders field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pUnknownHeaders) put: anObject yourAddress!

TrailerCount
	"Answer the receiver's TrailerCount field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #TrailerCount)!

TrailerCount: anObject
	"Set the receiver's TrailerCount field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #TrailerCount) put: anObject!

UnknownHeaderCount
	"Answer the receiver's UnknownHeaderCount field as a Smalltalk object."

	^bytes wordAtOffset: 0!

UnknownHeaderCount: anObject
	"Set the receiver's UnknownHeaderCount field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!HTTP_RESPONSE_HEADERS categoriesFor: #KnownHeaders!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #KnownHeaders:!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #pTrailers!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #pTrailers:!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #pUnknownHeaders!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #pUnknownHeaders:!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #TrailerCount!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #TrailerCount:!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #UnknownHeaderCount!**compiled accessors**!public! !
!HTTP_RESPONSE_HEADERS categoriesFor: #UnknownHeaderCount:!**compiled accessors**!public! !

!HTTP_RESPONSE_HEADERS class methodsFor!

defineFields
	"Define the fields of the HTTP_RESPONSE_HEADERS structure.

	HTTP_RESPONSE_HEADERS  compileDefinition

		typedef [uuid(487FD2E3-1549-4DCF-8703-D45A2CBBCD85), helpstring('Structure defining format of response headers.')]
		struct tagHTTP_RESPONSE_HEADERS {
			[helpstring('The array of unknown HTTP headers and the number of entries in the array.')] unsigned short UnknownHeaderCount;
			PHTTP_UNKNOWN_HEADER pUnknownHeaders;
			[helpstring('Trailers - we don't use these currently, reserved for a future release')] unsigned short TrailerCount;
			PHTTP_UNKNOWN_HEADER pTrailers;
			[helpstring('Known headers.')] HTTP_KNOWN_HEADER KnownHeaders[30];
		} HTTP_RESPONSE_HEADERS;
"

	self
		defineField: #UnknownHeaderCount type: WORDField new offset: 0;
		defineField: #pUnknownHeaders type: (PointerField type: HTTP_UNKNOWN_HEADER) offset: 4;
		defineField: #TrailerCount type: WORDField new offset: 8;
		defineField: #pTrailers type: (PointerField type: HTTP_UNKNOWN_HEADER) offset: 12;
		defineField: #KnownHeaders type: (StructureArrayField type: HTTP_KNOWN_HEADER length: 30) offset: 16.
	self byteSize: 256! !
!HTTP_RESPONSE_HEADERS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

