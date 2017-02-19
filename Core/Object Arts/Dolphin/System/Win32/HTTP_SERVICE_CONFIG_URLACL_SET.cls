"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_URLACL_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_URLACL_SET guid: (GUID fromString: '{8144c4ca-dfd3-4ed0-a83b-ad096bd611a4}')!
HTTP_SERVICE_CONFIG_URLACL_SET comment: '<HTTP_SERVICE_CONFIG_URLACL_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_URLACL_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(8144c4ca-dfd3-4ed0-a83b-ad096bd611a4), helpstring("This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store.")]
struct tagHTTP_SERVICE_CONFIG_URLACL_SET {
	HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_URLACL_PARAM paramdesc;
} HTTP_SERVICE_CONFIG_URLACL_SET;
'!
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_URLACL_SET methodsFor!

KeyDesc
	"Answer the <UnicodeString> value of the receiver's 'KeyDesc' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 0)!

KeyDesc: anUnicodeString
	"Set the receiver's 'KeyDesc' field to the value of the argument, anUnicodeString"

	bytes uintPtrAtOffset: 0 put: anUnicodeString yourAddress!

paramdesc
	"Answer the <UnicodeString> value of the receiver's 'paramdesc' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #paramdesc))!

paramdesc: anUnicodeString
	"Set the receiver's 'paramdesc' field to the value of the argument, anUnicodeString"

	bytes uintPtrAtOffset: ##(self offsetOf: #paramdesc) put: anUnicodeString yourAddress! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #paramdesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #paramdesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_URLACL_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_URLACL_SET structure.

	HTTP_SERVICE_CONFIG_URLACL_SET compileDefinition

		typedef [uuid(8144c4ca-dfd3-4ed0-a83b-ad096bd611a4), helpstring('This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store.')]
		struct tagHTTP_SERVICE_CONFIG_URLACL_SET {
			HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_URLACL_PARAM paramdesc;
		} HTTP_SERVICE_CONFIG_URLACL_SET;
"

	self
		defineField: #KeyDesc type: (PointerField type: UnicodeString) offset: 0;
		defineField: #paramdesc type: (PointerField type: UnicodeString) offset: 4.
	self byteSize: 8! !
!HTTP_SERVICE_CONFIG_URLACL_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

