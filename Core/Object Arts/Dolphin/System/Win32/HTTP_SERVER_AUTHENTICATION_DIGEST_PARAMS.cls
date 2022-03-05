"Filed out from Dolphin Smalltalk"!

HttpServerStructure subclass: #HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_DomainName _OffsetOf_DomainNameLength _OffsetOf_Realm _OffsetOf_RealmLength'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS guid: (GUID fromString: '{eed513f2-c404-408c-9ddb-f5d39020d426}')!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS addClassConstant: '_OffsetOf_DomainName' value: 16r4!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS addClassConstant: '_OffsetOf_DomainNameLength' value: 16r0!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS addClassConstant: '_OffsetOf_Realm' value: 16rC!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS addClassConstant: '_OffsetOf_RealmLength' value: 16r8!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS comment: '<HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(eed513f2-c404-408c-9ddb-f5d39020d426)]
struct tagHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS {
	USHORT DomainNameLength;
	LPWSTR DomainName;
	USHORT RealmLength;
	LPWSTR Realm;
} HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS;
'!
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS methodsFor!

DomainName
	"Answer the <Utf16String> value of the receiver's 'DomainName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_DomainName)!

DomainName: anUtf16String
	"Set the receiver's 'DomainName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_DomainName put: anUtf16String yourAddress!

DomainNameLength
	"Answer the <Integer> value of the receiver's 'DomainNameLength' field."

	^bytes wordAtOffset: _OffsetOf_DomainNameLength!

DomainNameLength: anInteger
	"Set the receiver's 'DomainNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_DomainNameLength put: anInteger!

Realm
	"Answer the <Utf16String> value of the receiver's 'Realm' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Realm)!

Realm: anUtf16String
	"Set the receiver's 'Realm' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_Realm put: anUtf16String yourAddress!

RealmLength
	"Answer the <Integer> value of the receiver's 'RealmLength' field."

	^bytes wordAtOffset: _OffsetOf_RealmLength!

RealmLength: anInteger
	"Set the receiver's 'RealmLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_RealmLength put: anInteger! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesForMethods!
DomainName!**compiled accessors**!public! !
DomainName:!**compiled accessors**!public! !
DomainNameLength!**compiled accessors**!public! !
DomainNameLength:!**compiled accessors**!public! !
Realm!**compiled accessors**!public! !
Realm:!**compiled accessors**!public! !
RealmLength!**compiled accessors**!public! !
RealmLength:!**compiled accessors**!public! !
!

!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS structure.

	HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS compileDefinition

		typedef [uuid(eed513f2-c404-408c-9ddb-f5d39020d426)]
		struct tagHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS {
			USHORT DomainNameLength;
			LPWSTR DomainName;
			USHORT RealmLength;
			LPWSTR Realm;
		} HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS;
"

	self
		defineField: #DomainNameLength type: WORDField new offset: 0;
		defineField: #DomainName type: (PointerField type: Utf16String) offset: 4;
		defineField: #RealmLength type: WORDField new offset: 8;
		defineField: #Realm type: (PointerField type: Utf16String) offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#DomainNameLength #DomainName #RealmLength #Realm)! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

