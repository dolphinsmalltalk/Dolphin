"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS guid: (GUID fromString: '{EED513F2-C404-408C-9DDB-F5D39020D426}')!
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS comment: '<HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(EED513F2-C404-408C-9DDB-F5D39020D426)]
struct tagHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS {
	unsigned short DomainNameLength;
	LPWSTR DomainName;
	unsigned short RealmLength;
	LPWSTR Realm;
} HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS;
'!
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS categoriesForClass!Win32-Structs! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS methodsFor!

DomainName
	"Answer the receiver's DomainName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #DomainName))!

DomainName: anObject
	"Set the receiver's DomainName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #DomainName) put: anObject yourAddress!

DomainNameLength
	"Answer the receiver's DomainNameLength field as a Smalltalk object."

	^bytes wordAtOffset: 0!

DomainNameLength: anObject
	"Set the receiver's DomainNameLength field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

Realm
	"Answer the receiver's Realm field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Realm))!

Realm: anObject
	"Set the receiver's Realm field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Realm) put: anObject yourAddress!

RealmLength
	"Answer the receiver's RealmLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #RealmLength)!

RealmLength: anObject
	"Set the receiver's RealmLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #RealmLength) put: anObject! !
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

	HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS  compileDefinition

		typedef [uuid(EED513F2-C404-408C-9DDB-F5D39020D426)]
		struct tagHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS {
			unsigned short DomainNameLength;
			LPWSTR DomainName;
			unsigned short RealmLength;
			LPWSTR Realm;
		} HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS;
"

	self
		defineField: #DomainNameLength type: WORDField new offset: 0;
		defineField: #DomainName type: (PointerField type: UnicodeString) offset: 4;
		defineField: #RealmLength type: WORDField new offset: 8;
		defineField: #Realm type: (PointerField type: UnicodeString) offset: 12.
	self byteSize: 16! !
!HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

