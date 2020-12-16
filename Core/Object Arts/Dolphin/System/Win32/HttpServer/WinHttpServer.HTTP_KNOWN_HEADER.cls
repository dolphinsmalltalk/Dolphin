"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_KNOWN_HEADER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_pRawValue' -> 16r4.
		'_OffsetOf_RawValueLength' -> 16r0
	}!
WinHttpServer.HTTP_KNOWN_HEADER guid: (Core.GUID fromString: '{787c501e-95b2-4a23-9f7c-2dd856b8d51d}')!
WinHttpServer.HTTP_KNOWN_HEADER comment: '`HTTP_KNOWN_HEADER` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_KNOWN_HEADER'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of a known HTTP header. Name is from HTTP_HEADER_ID."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(787c501e-95b2-4a23-9f7c-2dd856b8d51d), helpstring("Structure defining format of a known HTTP header. Name is from HTTP_HEADER_ID.")]
struct tagHTTP_KNOWN_HEADER {
	[nonbrowsable, helpstring("Size in bytes of RawValue not including terminating null")] USHORT RawValueLength;
	[size_is("RawValueLength"), string] LPCSTR pRawValue;
} HTTP_KNOWN_HEADER;
```
'!
!WinHttpServer.HTTP_KNOWN_HEADER categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_KNOWN_HEADER methodsFor!

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
!WinHttpServer.HTTP_KNOWN_HEADER categoriesFor: #pRawValue!**compiled accessors**!public! !
!WinHttpServer.HTTP_KNOWN_HEADER categoriesFor: #pRawValue:!**compiled accessors**!public! !
!WinHttpServer.HTTP_KNOWN_HEADER categoriesFor: #RawValueLength!**compiled accessors**!private! !
!WinHttpServer.HTTP_KNOWN_HEADER categoriesFor: #RawValueLength:!**compiled accessors**!private! !

!WinHttpServer.HTTP_KNOWN_HEADER class methodsFor!

defineFields
	"Define the fields of the HTTP_KNOWN_HEADER structure.

	HTTP_KNOWN_HEADER compileDefinition

		typedef [uuid(787c501e-95b2-4a23-9f7c-2dd856b8d51d), helpstring('Structure defining format of a known HTTP header. Name is from HTTP_HEADER_ID.')]
		struct tagHTTP_KNOWN_HEADER {
			[nonbrowsable, helpstring('Size in bytes of RawValue not including terminating null')] USHORT RawValueLength;
			[size_is('RawValueLength'), string] LPCSTR pRawValue;
		} HTTP_KNOWN_HEADER;
"

	self
		defineField: #RawValueLength type: WORDField new beNonBrowsable offset: 0;
		defineField: #pRawValue type: (ArrayPointerField type: String lengthField: #RawValueLength) offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#RawValueLength #pRawValue)! !
!WinHttpServer.HTTP_KNOWN_HEADER class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_KNOWN_HEADER class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

