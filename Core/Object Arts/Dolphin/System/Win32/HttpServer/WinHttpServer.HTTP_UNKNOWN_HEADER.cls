"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_UNKNOWN_HEADER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_NameLength' -> 16r0.
		'_OffsetOf_pName' -> 16r4.
		'_OffsetOf_pRawValue' -> 16r8.
		'_OffsetOf_RawValueLength' -> 16r2
	}!
WinHttpServer.HTTP_UNKNOWN_HEADER guid: (Core.GUID fromString: '{98a27339-73e3-4d54-baf2-915b818916b1}')!
WinHttpServer.HTTP_UNKNOWN_HEADER comment: '`HTTP_UNKNOWN_HEADER` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_UNKNOWN_HEADER'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of an unknown header."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(98a27339-73e3-4d54-baf2-915b818916b1), helpstring("Structure defining format of an unknown header.")]
struct tagHTTP_UNKNOWN_HEADER {
	[nonbrowsable, helpstring("Size in bytes of Name not including terminating null")] USHORT NameLength;
	[nonbrowsable, helpstring("Size in bytes of RawValue not including terminating null")] USHORT RawValueLength;
	[helpstring("The header name (minus the '':'' character)"), size_is("NameLength"), string] LPCSTR pName;
	[helpstring("The header value."), size_is("RawValueLength"), string] LPCSTR pRawValue;
} HTTP_UNKNOWN_HEADER;
```
'!
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_UNKNOWN_HEADER methodsFor!

NameLength
	"Private - Answer the <Integer> value of the receiver's 'NameLength' field."

	^bytes wordAtOffset: _OffsetOf_NameLength!

NameLength: anInteger
	"Set the receiver's 'NameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_NameLength put: anInteger!

pName
	"Answer the <AnsiString> value of the receiver's 'pName' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_pName) length: self NameLength!

pName: anAnsiString
	"Set the receiver's 'pName' field to the value of the argument, anAnsiString"

	bytes uintPtrAtOffset: _OffsetOf_pName put: anAnsiString yourAddress.
	self NameLength: anAnsiString size!

pRawValue
	"Answer the <AnsiString> value of the receiver's 'pRawValue' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_pRawValue) length: self RawValueLength!

pRawValue: anAnsiString
	"Set the receiver's 'pRawValue' field to the value of the argument, anAnsiString"

	bytes uintPtrAtOffset: _OffsetOf_pRawValue put: anAnsiString yourAddress.
	self RawValueLength: anAnsiString size!

RawValueLength
	"Private - Answer the <Integer> value of the receiver's 'RawValueLength' field."

	^bytes wordAtOffset: _OffsetOf_RawValueLength!

RawValueLength: anInteger
	"Set the receiver's 'RawValueLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_RawValueLength put: anInteger! !
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesFor: #NameLength!**compiled accessors**!private! !
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesFor: #NameLength:!**compiled accessors**!private! !
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesFor: #pName!**compiled accessors**!public! !
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesFor: #pName:!**compiled accessors**!public! !
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesFor: #pRawValue!**compiled accessors**!public! !
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesFor: #pRawValue:!**compiled accessors**!public! !
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesFor: #RawValueLength!**compiled accessors**!private! !
!WinHttpServer.HTTP_UNKNOWN_HEADER categoriesFor: #RawValueLength:!**compiled accessors**!private! !

!WinHttpServer.HTTP_UNKNOWN_HEADER class methodsFor!

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
		defineField: #pName type: (ArrayPointerField type: AnsiString lengthField: #NameLength) offset: 4;
		defineField: #pRawValue type: (ArrayPointerField type: AnsiString lengthField: #RawValueLength) offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#NameLength #RawValueLength #pName #pRawValue)! !
!WinHttpServer.HTTP_UNKNOWN_HEADER class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_UNKNOWN_HEADER class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

