"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS_Size' -> 16r8.
			'_OffsetOf_Realm' -> 16r4.
			'_OffsetOf_RealmLength' -> 16r0
		}!
WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS guid: (Core.GUID fromString: '{813ff062-e4ed-4b4c-8eef-9d94a1fb65c4}')!
WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS comment: '`HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(813ff062-e4ed-4b4c-8eef-9d94a1fb65c4)]
struct tagHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS {
	USHORT RealmLength;
	LPWSTR Realm;
} HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS;
```
'!
!WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS methodsFor!

Realm
	"Answer the <Utf16String> value of the receiver's 'Realm' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Realm)!

Realm: anUtf16String
	"Set the receiver's 'Realm' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_Realm put: anUtf16String yourAddress!

RealmLength
	"Answer the <Integer> value of the receiver's 'RealmLength' field."

	^bytes uint16AtOffset: _OffsetOf_RealmLength!

RealmLength: anInteger
	"Set the receiver's 'RealmLength' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_RealmLength put: anInteger! !
!WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesForMethods!
Realm!**compiled accessors**!public! !
Realm:!**compiled accessors**!public! !
RealmLength!**compiled accessors**!public! !
RealmLength:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class methodsFor!

byteSize
	^_HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS_Size!

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
		defineField: #RealmLength type: UInt16Field new offset: 0;
		defineField: #Realm type: (PointerField type: Utf16String) offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#RealmLength #Realm)! !
!WinHttpServer.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

