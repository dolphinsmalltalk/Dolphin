"Filed out from Dolphin Smalltalk 7"!

HttpServiceConfigQuery subclass: #HTTP_SERVICE_CONFIG_URLACL_QUERY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_URLACL_QUERY guid: (GUID fromString: '{fbe6f060-f472-445e-b48c-9caa8faedc7e}')!
HTTP_SERVICE_CONFIG_URLACL_QUERY comment: '<HTTP_SERVICE_CONFIG_URLACL_QUERY> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This data structure is used by HttpQueryServiceConfiguration() for the	config ID HttpServiceConfigUrlAclInfo to query records from the URL ACL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(fbe6f060-f472-445e-b48c-9caa8faedc7e), helpstring("This data structure is used by HttpQueryServiceConfiguration() for the	config ID HttpServiceConfigUrlAclInfo to query records from the URL ACL store.")]
struct tagHTTP_SERVICE_CONFIG_URLACL_QUERY {
	HttpServiceConfigQuery;
	HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
	DWORD dwToken;
} HTTP_SERVICE_CONFIG_URLACL_QUERY;
'!
!HTTP_SERVICE_CONFIG_URLACL_QUERY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_URLACL_QUERY methodsFor!

dwToken
	"Answer the <Integer> value of the receiver's 'dwToken' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwToken)!

dwToken: anInteger
	"Set the receiver's 'dwToken' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwToken) put: anInteger!

KeyDesc
	"Answer the <Utf16String> value of the receiver's 'KeyDesc' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #KeyDesc))!

KeyDesc: anUtf16String
	"Set the receiver's 'KeyDesc' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #KeyDesc) put: anUtf16String yourAddress! !
!HTTP_SERVICE_CONFIG_URLACL_QUERY categoriesFor: #dwToken!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_QUERY categoriesFor: #dwToken:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_QUERY categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_QUERY categoriesFor: #KeyDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_URLACL_QUERY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_URLACL_QUERY structure.

	HTTP_SERVICE_CONFIG_URLACL_QUERY compileDefinition

		typedef [uuid(fbe6f060-f472-445e-b48c-9caa8faedc7e), helpstring('This data structure is used by HttpQueryServiceConfiguration() for the	config ID HttpServiceConfigUrlAclInfo to query records from the URL ACL store.')]
		struct tagHTTP_SERVICE_CONFIG_URLACL_QUERY {
			HttpServiceConfigQuery;
			HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
			DWORD dwToken;
		} HTTP_SERVICE_CONFIG_URLACL_QUERY;
"

	super defineFields.
	self
		defineField: #KeyDesc type: (PointerField type: Utf16String) offset: 4;
		defineField: #dwToken type: DWORDField new offset: 8.
	self byteSize: 12! !
!HTTP_SERVICE_CONFIG_URLACL_QUERY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

