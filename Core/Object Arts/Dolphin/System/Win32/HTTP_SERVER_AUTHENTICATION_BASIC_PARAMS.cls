"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Realm' -> 16r4.
		'_OffsetOf_RealmLength' -> 16r0
	}!
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS guid: (GUID fromString: '{813ff062-e4ed-4b4c-8eef-9d94a1fb65c4}')!
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS comment: '<HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(813ff062-e4ed-4b4c-8eef-9d94a1fb65c4)]
struct tagHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS {
	USHORT RealmLength;
	LPWSTR Realm;
} HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS;
'!
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS methodsFor!

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
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesFor: #Realm!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesFor: #Realm:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesFor: #RealmLength!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesFor: #RealmLength:!**compiled accessors**!public! !

!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS structure.

	HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS compileDefinition

		typedef [uuid(813ff062-e4ed-4b4c-8eef-9d94a1fb65c4)]
		struct tagHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS {
			USHORT RealmLength;
			LPWSTR Realm;
		} HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS;
"

	self
		defineField: #RealmLength type: WORDField new offset: 0;
		defineField: #Realm type: (PointerField type: Utf16String) offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#RealmLength #Realm)! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

