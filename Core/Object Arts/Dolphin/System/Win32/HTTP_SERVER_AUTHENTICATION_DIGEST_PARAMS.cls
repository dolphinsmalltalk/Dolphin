"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS guid: (GUID fromString: '{eed513f2-c404-408c-9ddb-f5d39020d426}')!
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

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #DomainName))!

DomainName: anUtf16String
	"Set the receiver's 'DomainName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #DomainName) put: anUtf16String yourAddress!

DomainNameLength
	"Answer the <Integer> value of the receiver's 'DomainNameLength' field."

	^bytes wordAtOffset: 0!

DomainNameLength: anInteger
	"Set the receiver's 'DomainNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: 0 put: anInteger!

Realm
	"Answer the <Utf16String> value of the receiver's 'Realm' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Realm))!

Realm: anUtf16String
	"Set the receiver's 'Realm' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #Realm) put: anUtf16String yourAddress!

RealmLength
	"Answer the <Integer> value of the receiver's 'RealmLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #RealmLength)!

RealmLength: anInteger
	"Set the receiver's 'RealmLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #RealmLength) put: anInteger! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesFor: #DomainName!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesFor: #DomainName:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesFor: #DomainNameLength!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesFor: #DomainNameLength:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesFor: #Realm!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesFor: #Realm:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesFor: #RealmLength!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesFor: #RealmLength:!**compiled accessors**!public! !

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
	self byteSize: 16! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

