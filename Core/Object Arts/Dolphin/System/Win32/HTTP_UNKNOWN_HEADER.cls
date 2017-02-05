"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_UNKNOWN_HEADER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_UNKNOWN_HEADER guid: (GUID fromString: '{98A27339-73E3-4D54-BAF2-915B818916B1}')!
HTTP_UNKNOWN_HEADER comment: '<HTTP_UNKNOWN_HEADER> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_UNKNOWN_HEADER'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of an unknown header."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(98A27339-73E3-4D54-BAF2-915B818916B1), helpstring("Structure defining format of an unknown header.")]
struct tagHTTP_UNKNOWN_HEADER {
	unsigned short NameLength;
	unsigned short RawValueLength;
	LPCSTR pName;
	LPCSTR pRawValue;
} HTTP_UNKNOWN_HEADER;
'!
!HTTP_UNKNOWN_HEADER categoriesForClass!Win32-Structs! !
!HTTP_UNKNOWN_HEADER methodsFor!

NameLength
	"Answer the receiver's NameLength field as a Smalltalk object."

	^bytes wordAtOffset: 0!

NameLength: anObject
	"Set the receiver's NameLength field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

pName
	"Answer the receiver's pName field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pName))!

pName: anObject
	"Set the receiver's pName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pName) put: anObject yourAddress!

pRawValue
	"Answer the receiver's pRawValue field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pRawValue))!

pRawValue: anObject
	"Set the receiver's pRawValue field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pRawValue) put: anObject yourAddress!

RawValueLength
	"Answer the receiver's RawValueLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #RawValueLength)!

RawValueLength: anObject
	"Set the receiver's RawValueLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #RawValueLength) put: anObject! !
!HTTP_UNKNOWN_HEADER categoriesFor: #NameLength!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #NameLength:!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #pName!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #pName:!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #pRawValue!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #pRawValue:!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #RawValueLength!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #RawValueLength:!**compiled accessors**!public! !

!HTTP_UNKNOWN_HEADER class methodsFor!

defineFields
	"Define the fields of the HTTP_UNKNOWN_HEADER structure.

	HTTP_UNKNOWN_HEADER  compileDefinition

		typedef [uuid(98A27339-73E3-4D54-BAF2-915B818916B1), helpstring('Structure defining format of an unknown header.')]
		struct tagHTTP_UNKNOWN_HEADER {
			unsigned short NameLength;
			unsigned short RawValueLength;
			LPCSTR pName;
			LPCSTR pRawValue;
		} HTTP_UNKNOWN_HEADER;
"

	self
		defineField: #NameLength type: WORDField new offset: 0;
		defineField: #RawValueLength type: WORDField new offset: 2;
		defineField: #pName type: (PointerField type: String) offset: 4;
		defineField: #pRawValue type: (PointerField type: String) offset: 8.
	self byteSize: 12! !
!HTTP_UNKNOWN_HEADER class categoriesFor: #defineFields!**auto generated**!initializing!public! !

