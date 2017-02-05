"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_KNOWN_HEADER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_KNOWN_HEADER guid: (GUID fromString: '{787C501E-95B2-4A23-9F7C-2DD856B8D51D}')!
HTTP_KNOWN_HEADER comment: '<HTTP_KNOWN_HEADER> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_KNOWN_HEADER'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of a known HTTP header. Name is from HTTP_HEADER_ID."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(787C501E-95B2-4A23-9F7C-2DD856B8D51D), helpstring("Structure defining format of a known HTTP header. Name is from HTTP_HEADER_ID.")]
struct tagHTTP_KNOWN_HEADER {
	unsigned short RawValueLength;
	LPCSTR pRawValue;
} HTTP_KNOWN_HEADER;
'!
!HTTP_KNOWN_HEADER categoriesForClass!Win32-Structs! !
!HTTP_KNOWN_HEADER methodsFor!

pRawValue
	"Answer the receiver's pRawValue field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pRawValue))!

pRawValue: anObject
	"Set the receiver's pRawValue field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pRawValue) put: anObject yourAddress!

RawValueLength
	"Answer the receiver's RawValueLength field as a Smalltalk object."

	^bytes wordAtOffset: 0!

RawValueLength: anObject
	"Set the receiver's RawValueLength field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!HTTP_KNOWN_HEADER categoriesFor: #pRawValue!**compiled accessors**!public! !
!HTTP_KNOWN_HEADER categoriesFor: #pRawValue:!**compiled accessors**!public! !
!HTTP_KNOWN_HEADER categoriesFor: #RawValueLength!**compiled accessors**!public! !
!HTTP_KNOWN_HEADER categoriesFor: #RawValueLength:!**compiled accessors**!public! !

!HTTP_KNOWN_HEADER class methodsFor!

defineFields
	"Define the fields of the HTTP_KNOWN_HEADER structure.

	HTTP_KNOWN_HEADER  compileDefinition

		typedef [uuid(787C501E-95B2-4A23-9F7C-2DD856B8D51D), helpstring('Structure defining format of a known HTTP header. Name is from HTTP_HEADER_ID.')]
		struct tagHTTP_KNOWN_HEADER {
			unsigned short RawValueLength;
			LPCSTR pRawValue;
		} HTTP_KNOWN_HEADER;
"

	self
		defineField: #RawValueLength type: WORDField new offset: 0;
		defineField: #pRawValue type: (PointerField type: String) offset: 4.
	self byteSize: 8! !
!HTTP_KNOWN_HEADER class categoriesFor: #defineFields!**auto generated**!initializing!public! !

