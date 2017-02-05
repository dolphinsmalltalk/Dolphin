"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS guid: (GUID fromString: '{813FF062-E4ED-4B4C-8EEF-9D94A1FB65C4}')!
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS comment: '<HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(813FF062-E4ED-4B4C-8EEF-9D94A1FB65C4)]
struct tagHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS {
	unsigned short RealmLength;
	LPWSTR Realm;
} HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS;
'!
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesForClass!Win32-Structs! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS methodsFor!

Realm
	"Answer the receiver's Realm field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Realm))!

Realm: anObject
	"Set the receiver's Realm field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Realm) put: anObject yourAddress!

RealmLength
	"Answer the receiver's RealmLength field as a Smalltalk object."

	^bytes wordAtOffset: 0!

RealmLength: anObject
	"Set the receiver's RealmLength field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesFor: #Realm!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesFor: #Realm:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesFor: #RealmLength!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS categoriesFor: #RealmLength:!**compiled accessors**!public! !

!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS structure.

	HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS  compileDefinition

		typedef [uuid(813FF062-E4ED-4B4C-8EEF-9D94A1FB65C4)]
		struct tagHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS {
			unsigned short RealmLength;
			LPWSTR Realm;
		} HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS;
"

	self
		defineField: #RealmLength type: WORDField new offset: 0;
		defineField: #Realm type: (PointerField type: UnicodeString) offset: 4.
	self byteSize: 8! !
!HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

