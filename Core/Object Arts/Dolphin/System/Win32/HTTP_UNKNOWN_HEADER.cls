"Filed out from Dolphin Smalltalk"!

HttpServerStructure subclass: #HTTP_UNKNOWN_HEADER
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_NameLength _OffsetOf_pName _OffsetOf_pRawValue _OffsetOf_RawValueLength'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_UNKNOWN_HEADER guid: (GUID fromString: '{98a27339-73e3-4d54-baf2-915b818916b1}')!
HTTP_UNKNOWN_HEADER addClassConstant: '_OffsetOf_NameLength' value: 16r0!
HTTP_UNKNOWN_HEADER addClassConstant: '_OffsetOf_pName' value: 16r4!
HTTP_UNKNOWN_HEADER addClassConstant: '_OffsetOf_pRawValue' value: 16r8!
HTTP_UNKNOWN_HEADER addClassConstant: '_OffsetOf_RawValueLength' value: 16r2!
HTTP_UNKNOWN_HEADER comment: '<HTTP_UNKNOWN_HEADER> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_UNKNOWN_HEADER'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of an unknown header."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(98a27339-73e3-4d54-baf2-915b818916b1), helpstring("Structure defining format of an unknown header.")]
struct tagHTTP_UNKNOWN_HEADER {
	[nonbrowsable, helpstring("Size in bytes of Name not including terminating null")] USHORT NameLength;
	[nonbrowsable, helpstring("Size in bytes of RawValue not including terminating null")] USHORT RawValueLength;
	[helpstring("The header name (minus the '':'' character)"), size_is("NameLength"), string] LPCSTR pName;
	[helpstring("The header value."), size_is("RawValueLength"), string] LPCSTR pRawValue;
} HTTP_UNKNOWN_HEADER;
'!
!HTTP_UNKNOWN_HEADER categoriesForClass!WinHttpServer-Structs! !
!HTTP_UNKNOWN_HEADER methodsFor!

NameLength
	"Private - Answer the <Integer> value of the receiver's 'NameLength' field."

	^bytes wordAtOffset: _OffsetOf_NameLength!

NameLength: anInteger
	"Set the receiver's 'NameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_NameLength put: anInteger!

pName
	"Answer the <String> value of the receiver's 'pName' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pName) length: self NameLength!

pName: aString
	"Set the receiver's 'pName' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_pName put: aString yourAddress.
	self NameLength: aString size!

pRawValue
	"Answer the <String> value of the receiver's 'pRawValue' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pRawValue) length: self RawValueLength!

pRawValue: aString
	"Set the receiver's 'pRawValue' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_pRawValue put: aString yourAddress.
	self RawValueLength: aString size!

RawValueLength
	"Private - Answer the <Integer> value of the receiver's 'RawValueLength' field."

	^bytes wordAtOffset: _OffsetOf_RawValueLength!

RawValueLength: anInteger
	"Set the receiver's 'RawValueLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_RawValueLength put: anInteger! !
!HTTP_UNKNOWN_HEADER categoriesForMethods!
NameLength!**compiled accessors**!private! !
NameLength:!**compiled accessors**!private! !
pName!**compiled accessors**!public! !
pName:!**compiled accessors**!public! !
pRawValue!**compiled accessors**!public! !
pRawValue:!**compiled accessors**!public! !
RawValueLength!**compiled accessors**!private! !
RawValueLength:!**compiled accessors**!private! !
!

!HTTP_UNKNOWN_HEADER class methodsFor!

defineFields
	"Define the fields of the HTTP_UNKNOWN_HEADER structure.

	HTTP_UNKNOWN_HEADER compileDefinition

		typedef [uuid(98a27339-73e3-4d54-baf2-915b818916b1), helpstring('Structure defining format of an unknown header.')]
		struct tagHTTP_UNKNOWN_HEADER {
			[nonbrowsable, helpstring('Size in bytes of Name not including terminating null')] USHORT NameLength;
			[nonbrowsable, helpstring('Size in bytes of RawValue not including terminating null')] USHORT RawValueLength;
			[helpstring('The header name (minus the ':' character)'), size_is('NameLength'), string] LPCSTR pName;
			[helpstring('The header value.'), size_is('RawValueLength'), string] LPCSTR pRawValue;
		} HTTP_UNKNOWN_HEADER;
"

	self
		defineField: #NameLength type: WORDField new beNonBrowsable offset: 0;
		defineField: #RawValueLength type: WORDField new beNonBrowsable offset: 2;
		defineField: #pName type: (ArrayPointerField type: String lengthField: #NameLength) offset: 4;
		defineField: #pRawValue type: (ArrayPointerField type: String lengthField: #RawValueLength) offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#NameLength #RawValueLength #pName #pRawValue)! !
!HTTP_UNKNOWN_HEADER class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

