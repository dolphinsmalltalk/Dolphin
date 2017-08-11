"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_UNKNOWN_HEADER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_UNKNOWN_HEADER guid: (GUID fromString: '{98a27339-73e3-4d54-baf2-915b818916b1}')!
HTTP_UNKNOWN_HEADER comment: '<HTTP_UNKNOWN_HEADER> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_UNKNOWN_HEADER'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of an unknown header."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(98a27339-73e3-4d54-baf2-915b818916b1), helpstring("Structure defining format of an unknown header.")]
struct tagHTTP_UNKNOWN_HEADER {
	[nonbrowsable] USHORT NameLength;
	[nonbrowsable] USHORT RawValueLength;
	[helpstring("The header name (minus the '':'' character)"), size_is("NameLength"), string] LPCSTR pName;
	[helpstring("The header value."), size_is("RawValueLength"), string] LPCSTR pRawValue;
} HTTP_UNKNOWN_HEADER;
'!
!HTTP_UNKNOWN_HEADER categoriesForClass!Win32-Structs! !
!HTTP_UNKNOWN_HEADER methodsFor!

NameLength
	"Private - Answer the <Integer> value of the receiver's 'NameLength' field."

	^bytes wordAtOffset: 0!

NameLength: anInteger
	"Set the receiver's 'NameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: 0 put: anInteger!

pName
	"Answer the <String> value of the receiver's 'pName' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pName)) length: self NameLength!

pName: aString
	"Set the receiver's 'pName' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #pName) put: aString yourAddress.
	self NameLength: aString size!

pRawValue
	"Answer the <String> value of the receiver's 'pRawValue' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pRawValue))
		length: self RawValueLength!

pRawValue: aString
	"Set the receiver's 'pRawValue' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #pRawValue) put: aString yourAddress.
	self RawValueLength: aString size!

RawValueLength
	"Private - Answer the <Integer> value of the receiver's 'RawValueLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #RawValueLength)!

RawValueLength: anInteger
	"Set the receiver's 'RawValueLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #RawValueLength) put: anInteger! !
!HTTP_UNKNOWN_HEADER categoriesFor: #NameLength!**compiled accessors**!private! !
!HTTP_UNKNOWN_HEADER categoriesFor: #NameLength:!**compiled accessors**!private! !
!HTTP_UNKNOWN_HEADER categoriesFor: #pName!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #pName:!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #pRawValue!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #pRawValue:!**compiled accessors**!public! !
!HTTP_UNKNOWN_HEADER categoriesFor: #RawValueLength!**compiled accessors**!private! !
!HTTP_UNKNOWN_HEADER categoriesFor: #RawValueLength:!**compiled accessors**!private! !

!HTTP_UNKNOWN_HEADER class methodsFor!

defineFields
	"Define the fields of the HTTP_UNKNOWN_HEADER structure.

	HTTP_UNKNOWN_HEADER compileDefinition

		typedef [uuid(98a27339-73e3-4d54-baf2-915b818916b1), helpstring('Structure defining format of an unknown header.')]
		struct tagHTTP_UNKNOWN_HEADER {
			[nonbrowsable] USHORT NameLength;
			[nonbrowsable] USHORT RawValueLength;
			[helpstring('The header name (minus the ':' character)'), size_is('NameLength'), string] LPCSTR pName;
			[helpstring('The header value.'), size_is('RawValueLength'), string] LPCSTR pRawValue;
		} HTTP_UNKNOWN_HEADER;
"

	self
		defineField: #NameLength type: WORDField new beNonBrowsable offset: 0;
		defineField: #RawValueLength type: WORDField new beNonBrowsable offset: 2;
		defineField: #pName type: (ArrayPointerField type: String lengthField: #NameLength) offset: 4;
		defineField: #pRawValue type: (ArrayPointerField type: String lengthField: #RawValueLength) offset: 8.
	self byteSize: 12! !
!HTTP_UNKNOWN_HEADER class categoriesFor: #defineFields!**auto generated**!initializing!public! !

