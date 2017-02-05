"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_URLACL_KEY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_URLACL_KEY guid: (GUID fromString: '{5A98E5AE-54DA-40BF-9DE7-FA90ACB6E27C}')!
HTTP_SERVICE_CONFIG_URLACL_KEY comment: '<HTTP_SERVICE_CONFIG_URLACL_KEY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_URLACL_KEY'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"URL ACL"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(5A98E5AE-54DA-40BF-9DE7-FA90ACB6E27C), helpstring("URL ACL")]
struct tagHTTP_SERVICE_CONFIG_URLACL_KEY {
	LPWSTR pUrlPrefix;
} HTTP_SERVICE_CONFIG_URLACL_KEY;
'!
!HTTP_SERVICE_CONFIG_URLACL_KEY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_URLACL_KEY methodsFor!

pUrlPrefix
	"Answer the receiver's pUrlPrefix field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 0)!

pUrlPrefix: anObject
	"Set the receiver's pUrlPrefix field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress! !
!HTTP_SERVICE_CONFIG_URLACL_KEY categoriesFor: #pUrlPrefix!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_KEY categoriesFor: #pUrlPrefix:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_URLACL_KEY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_URLACL_KEY structure.

	HTTP_SERVICE_CONFIG_URLACL_KEY  compileDefinition

		typedef [uuid(5A98E5AE-54DA-40BF-9DE7-FA90ACB6E27C), helpstring('URL ACL')]
		struct tagHTTP_SERVICE_CONFIG_URLACL_KEY {
			LPWSTR pUrlPrefix;
		} HTTP_SERVICE_CONFIG_URLACL_KEY;
"

	self
		defineField: #pUrlPrefix type: (PointerField type: UnicodeString) offset: 0.
	self byteSize: 4! !
!HTTP_SERVICE_CONFIG_URLACL_KEY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

