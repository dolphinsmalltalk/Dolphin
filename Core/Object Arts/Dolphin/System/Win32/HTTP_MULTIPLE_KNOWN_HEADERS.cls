"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_MULTIPLE_KNOWN_HEADERS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_MULTIPLE_KNOWN_HEADERS guid: (GUID fromString: '{A12486B1-FDF5-4D31-A4B7-AF9848FFE5C6}')!
HTTP_MULTIPLE_KNOWN_HEADERS comment: '<HTTP_MULTIPLE_KNOWN_HEADERS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_MULTIPLE_KNOWN_HEADERS'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This structure allows the provision of providing multiple known headers."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A12486B1-FDF5-4D31-A4B7-AF9848FFE5C6), helpstring("This structure allows the provision of providing multiple known headers.")]
struct tagHTTP_MULTIPLE_KNOWN_HEADERS {
	[helpstring("Known header id.")] HTTP_HEADER_ID HeaderId;
	[helpstring("The flags corresponding to the response header in the HeaderId member. This member is used only when the WWW-Authenticate header is present.")] unsigned long flags;
	[helpstring("The number of elements in the array specified in the KnownHeaders member.")] unsigned short KnownHeaderCount;
	[helpstring("A pointer to the first element in the array of HTTP_KNOWN_HEADER structures.")] PHTTP_KNOWN_HEADER KnownHeaders;
} HTTP_MULTIPLE_KNOWN_HEADERS;
'!
!HTTP_MULTIPLE_KNOWN_HEADERS categoriesForClass!Win32-Structs! !
!HTTP_MULTIPLE_KNOWN_HEADERS methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

HeaderId
	"Answer the receiver's HeaderId field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

HeaderId: anObject
	"Set the receiver's HeaderId field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

KnownHeaderCount
	"Answer the receiver's KnownHeaderCount field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #KnownHeaderCount)!

KnownHeaderCount: anObject
	"Set the receiver's KnownHeaderCount field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #KnownHeaderCount) put: anObject!

KnownHeaders
	"Answer the receiver's KnownHeaders field as a Smalltalk object."

	^HTTP_KNOWN_HEADER fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #KnownHeaders))!

KnownHeaders: anObject
	"Set the receiver's KnownHeaders field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #KnownHeaders) put: anObject yourAddress! !
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

	HTTP_MULTIPLE_KNOWN_HEADERS  compileDefinition

		typedef [uuid(A12486B1-FDF5-4D31-A4B7-AF9848FFE5C6), helpstring('This structure allows the provision of providing multiple known headers.')]
		struct tagHTTP_MULTIPLE_KNOWN_HEADERS {
			[helpstring('Known header id.')] HTTP_HEADER_ID HeaderId;
			[helpstring('The flags corresponding to the response header in the HeaderId member. This member is used only when the WWW-Authenticate header is present.')] unsigned long flags;
			[helpstring('The number of elements in the array specified in the KnownHeaders member.')] unsigned short KnownHeaderCount;
			[helpstring('A pointer to the first element in the array of HTTP_KNOWN_HEADER structures.')] PHTTP_KNOWN_HEADER KnownHeaders;
		} HTTP_MULTIPLE_KNOWN_HEADERS;
"

	self
		defineField: #HeaderId type: SDWORDField new offset: 0;
		defineField: #flags type: DWORDField new offset: 4;
		defineField: #KnownHeaderCount type: WORDField new offset: 8;
		defineField: #KnownHeaders type: (PointerField type: HTTP_KNOWN_HEADER) offset: 12.
	self byteSize: 16! !
!HTTP_MULTIPLE_KNOWN_HEADERS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

